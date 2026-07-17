
set scheme cleanplots
cap estimates drop *
cap log close 

version 17

*Duan smearing method 
cap program drop duansmearing
program define duansmearing, eclass

	syntax, tabname(string) varlist(varlist) [noprice(string)] [postrebates(string) lagleadprices(string) calmonths(string)]
	
	marksample touse
	
	tempvar sample ehat predicteddepvar duanvar 
	tempname duan meanrebatesvalue meancolvalue beta beta_variance estimates beta_variance_diag dydx

	estimates store `estimates' 
	
	local N = e(N)
	local Ng = e(N_g)
	local depvar = e(depvar)

	gen `sample' = e(sample)
	
	*note includes e and fixed effect
	qui predict double `ehat' if `sample', residual
	qui predict double `predicteddepvar' if `sample', xb

	scalar avdayspermonth = 365/12

	egen `duanvar' = mean( exp(`ehat') ) 
	scalar `duan' = `duanvar'[1]
	ereturn scalar duanmean = `duan'
	
	qui su reb_val if rebates==1, meanonly
	scalar `meanrebatesvalue' =  r(mean)
	qui su col_val if col==1, meanonly
	scalar `meancolvalue' =  r(mean)
	
	qui su lprice if rebates==1
	local meanlprice_rebates =  r(mean)
	
	qui su lprice if postrebates_3qtr==1
	local meanlprice_post3qtr =  r(mean)
	
	qui su lprice if postrebates_qtr==1
	local meanlprice_post_qtr = r(mean)
	
	qui su lprice if postrebates_month==1
	local meanlprice_post_month = r(mean)
	
	foreach period in rebates postrebates_3qtr postrebates_qtr postrebates_month {
		foreach var in $tempcontrols {
			qui su `var' if `period'==1
			local mean = r(mean)
			local tempmean_`period' = "`tempmean_`period'' `var'=`mean'"
		}
	}
	
	*chosen to be month with roughly mean of month calendar month dummies in that period 
	if "`calmonths'"=="yes" {
		local month_rebates = "month=11"
		local month_postrebates_3qtr = "month=7"
		local month_postrebates_qtr = "month=6"
		local month_postrebates_month = "month=4"
	}
	
	if "`lagleadprices'"=="yes" {
		local lagleadterms "lag_lprice=`meanlprice_rebates' lead_lprice=`meanlprice_rebates'"
		local lagleadterms_post3quarters "lag_lprice=`meanlprice_post3quarters' lead_lprice=`meanlprice_post3quarters'"
		local lagleadterms_postqtr "lag_lprice=`meanlprice_post_qtr' lead_lprice=`meanlprice_post_qtr'"
		local lagleadterms_postmonth "lag_lprice=`meanlprice_post_month' lead_lprice=`meanlprice_post_month'"
	}

	*MPC out of rebate and col payments 
	local i = 1
	foreach var in `varlist' {
		qui estimates restore `estimates' 
		
		if inlist("`var'","rebates","col") {
			local meanvalue = `mean`var'value'
		}
		
		***********************************
		*Allowing for spillover effects

		if "`postrebates'"=="qtr" & "`var'"=="rebates" {
			*to get MPC from rebates add on estimate of monthly effect during post rebate period (halved because only lasts 3 months rather than 6)
			margins, dydx(`var' postrebates_qtr) expression(exp(xb())*`duan'*avdayspermonth/`meanvalue') at(wfh=0 rebates=1  lprice=`meanlprice_rebates' `lagleadterms' postrebates_qtr=0 `tempmean_rebates') ///
			at(wfh=0 rebates=0 lprice=`meanlprice_post_qtr' `lagleadterms_postqtr' postrebates_qtr=1 `tempmean_postrebates_qtr') post
			lincom [1.rebates]1._at + 0.5*[1.postrebates_qtr]2._at
			scalar `var'_b = r(estimate)
			scalar `var'_var = r(se)^2

		}
		if "`postrebates'"=="month" & "`var'"=="rebates" {
			*to get MPC from rebates add on estimate of monthly effect during post rebate period (divided by 6 because only lasts 1 rather than 6)
			margins, dydx(`var' postrebates_month) expression(exp(xb())*`duan'*avdayspermonth/`meanvalue') at(wfh=0 rebates=1  lprice=`meanlprice_rebates' `lagleadterms' postrebates_month=0 `tempmean_rebates') ///
			at(wfh=0 rebates=0 lprice=`meanlprice_post_month' `lagleadterms_postmonth' postrebates_month=1 `tempmean_postrebates_month') post
			lincom [1.rebates]1._at + (1/6)*[1.postrebates_month]2._at
			scalar `var'_b = r(estimate)
			scalar `var'_var = r(se)^2
		}
		
		*********
		
		if ("`postrebates'"=="" & "`var'"=="rebates") {
			
			margins, dydx(`var') expression(exp(xb())*`duan'*avdayspermonth/`meanvalue') at(wfh=0  lprice=`meanlprice_rebates' `tempmean_rebates'  `lagleadterms') post
			scalar `var'_b = _b[1.`var']
			scalar `var'_var = _se[1.`var']^2
		}
		
		if ("`var'"=="col") {
			
			margins, dydx(`var') expression(exp(xb())*`duan'*avdayspermonth/`meanvalue') at(wfh=0) post

			scalar `var'_b = _b[1.`var']
			scalar `var'_var = _se[1.`var']^2
		}
		
		**********	
		*Allowing COL effects to take place in month following transfer as well
		if "`var'"=="col2months" {
			
			margins, dydx(`var') expression(exp(xb())*`duan'*2*avdayspermonth/`meancolvalue') at(wfh=0) post
			
			scalar `var'_b = _b[1.`var']
			scalar `var'_var = _se[1.`var']^2
		}
		
		matrix `beta' = nullmat(`beta'),`var'_b
		matrix `beta_variance_diag' = nullmat(`beta_variance_diag'),`var'_var
		local varnames "`varnames' `var'"
		local ++i
	}
	
	matrix `beta_variance' = diag(`beta_variance_diag')
	
	matrix colnames `beta' = `varnames'
	matrix colnames `beta_variance' = `varnames'
	matrix rownames `beta_variance' = `varnames'
	
	ereturn clear
	ereturn post `beta' `beta_variance', esample(`touse') buildfvinfo
	
	ereturn scalar N    = `N'
	ereturn scalar Ng    = `Ng'
	ereturn local depvar = "`depvar'"
	ereturn local cmd "`tabname'"
	etable

end

*program to normalise coefficient according to pre-rebate period average
cap program drop adjustmonthdummies
program define adjustmonthdummies, eclass

	syntax, interactvar(string)
	tempvar sample 
	tempname b V
	
	local N = e(N)
	local N_g = e(N_g)
	local r2 = e(r2)
	local depvar = e(depvar)
	gen `sample' = e(sample)
		
	#delimit ;
	foreach yrmn in 202106 202107 202108 202109 202110 202111 202112 
	202201 202202 202203 202204 202205 202206 202207 202208 202209 202210 202211 202212  
	202301 202302 202303 202304 202305 202306 202307 202308 202309 202310 202311 202312 {;
	
			*qui lincom `yrmn'.yrmn#1.`interactvar' - 202209.yrmn#1.`interactvar'; 
			qui lincom `yrmn'.yrmn#1.`interactvar' - (202106.yrmn#1.`interactvar' + 202107.yrmn#1.`interactvar' + 202108.yrmn#1.`interactvar' + 202109.yrmn#1.`interactvar' + 202110.yrmn#1.`interactvar' + 202111.yrmn#1.`interactvar' + 202112.yrmn#1.`interactvar' + 202201.yrmn#1.`interactvar' + 202202.yrmn#1.`interactvar' + 202203.yrmn#1.`interactvar' + 202204.yrmn#1.`interactvar' + 202205.yrmn#1.`interactvar' + 202206.yrmn#1.`interactvar' + 202207.yrmn#1.`interactvar' + 202208.yrmn#1.`interactvar' + 202209.yrmn#1.`interactvar')/16;
			
			matrix `b' = nullmat(`b'),r(estimate);
			matrix `V' = nullmat(`V')\r(se)^2;
			local bcolnames "`bcolnames' `yrmn'.yrmn#1.`interactvar'";
			local Vrownames "`Vrownames' `yrmn'.yrmn#1.`interactvar'";
	};
	#delimit cr
	
	matrix colnames `b' = `bcolnames'
	matrix rownames `V' = `Vrownames'
	matrix `V' = diag(`V')

	ereturn post `b' `V', esample(`sample') buildfvinfo
	ereturn local depvar = "`depvar'"
	ereturn scalar N    = `N'
	ereturn scalar N_g    = `N_g'
	ereturn scalar r2   = `r2'
	ereturn local cmd "results_season"
	
end 


*deasonalise 
cap prog drop deseason
program deseason

	syntax, v(string) newv(string) 

	gen `v'_ds_everEBSS = `v' 
	xtreg `v' i.month if year<2021 & everEBSS==1 & everEBSSbutnorebate!=1 & sampletouse == 1, i(userref) fe robust
	forval m = 2/12 {
		replace `v'_ds_everEBSS = `v' - _b[`m'.month] + rnormal(0, _se[`m'.month]) if `m'.month == 1 & everEBSS==1 & sampletouse == 1
	}
	xtreg `v' i.month if year<2021 & everEBSS==0 & sampletouse == 1, i(userref) fe robust
	forval m = 2/12 {
		replace `v'_ds_everEBSS = `v' - _b[`m'.month] + rnormal(0, _se[`m'.month]) if `m'.month == 1 & everEBSS==0 & sampletouse == 1
	}

	gen `newv' = exp(`v'_ds_everEBSS)
	drop `v'_ds_everEBSS
	
end 


*************************************
** Budget share of energy
*************************************


u "$dataProcess/CSenergyallspending_step5", clear

log using "$resultsdir/LOG_energyshr_pp_overrebates.log", replace

su s_ener_nosc if sample == 1 & rebates==1

log close

*Construct lags and leads of prices 
use "$dataProcess/unitcosts_gas_elec_yrmn", clear

gen lprice = log(pidx_energy_tot_lasp_gb)
bys ofgem_region (year month): gen lag_lprice= lprice[_n-1]
bys ofgem_region (year month): gen lead_lprice= lprice[_n+1]

keep ofgem_region year month lag_lprice lead_lprice
tempfile lagsandleads
save `lagsandleads'

*************************************
*Graphical evidence
*************************************

global tempcontrols "tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2"


u "$dataProcess/CSenergyallspending_step6", clear

drop if NI == 1

gen samp = "PP" if sample==1
replace samp = "cash" if inlist(sample,2,3) & everEBSScash==1 
replace samp = "credit" if inlist(sample,2,3) & everEBSScash==0

*********************************************************************
* Quarterly analysis 

gen quarter = 1 if inlist(month,1,3)
replace quarter = 2 if inlist(month,4,6)
replace quarter = 3 if inlist(month,7,9)
replace quarter = 4 if inlist(month,10,12)

gen yrqn = year*10 + quarter
tostring year, gen(year_str)
tostring quarter, gen(quarter_str)
gen yrqn_str = year_str + "Q" + quarter_str
drop year_str quarter_str

egen tt_q = group(year quarter)

merge m:1 ofgem_region year month using `lagsandleads'

foreach sample in "PP" "cash" "credit" {
	xtreg lexp_ds i.yrqn if yrqn>=20211 & samp == "`sample'", i(userref) fe robust
	gen m_lexp_`sample' = 0
	gen lb_lexp_`sample' = 0
	gen ub_lexp_`sample' = 0
	forval t = 9/20 {
		su yrqn if tt_q == `t'
		local yrqn = r(mean)
		lincom (`yrqn'.yrqn - 20221.yrqn)
		replace m_lexp_`sample' = r(estimate) if tt_q == `t'
		replace lb_lexp_`sample' = r(estimate) - 1.96*r(se) if tt_q == `t'
		replace ub_lexp_`sample' = r(estimate) + 1.96*r(se) if tt_q == `t'
	}
}

foreach sample in "PP" "cash" "credit" {

    if inlist("`sample'","cash","credit") {
		local lagsandleadsofprices "c.lag_lprice c.lead_lprice"
	}
	
	*predicted spending
	gen newrebates = rebates
	xtreg lexp_ds c.lprice `lagsandleadsofprices' wfh $tempcontrols newrebates if yrqn>=20211 & samp == "`sample'" , i(userref) fe robust
	replace newrebates = 0 
	predict lexp_ds_hat_`sample', xbu

	*predicted values by quarter
	xtreg lexp_ds_hat_`sample' i.yrqn if yrqn>=20211 & samp == "`sample'", i(userref) fe robust

	gen m_lexp_qtr_hat_`sample' = 0
	forval t = 9/20 {
		su yrqn if tt_q == `t'
		local yrqn = r(mean)
		lincom (`yrqn'.yrqn - 20221.yrqn)
		replace m_lexp_qtr_hat_`sample' = r(estimate) if tt_q == `t'
	}

	xtreg lexp_ds i.yrqn if yrqn>=20211 & yrmn!=202304 & samp == "`sample'", i(userref) fe robust
	lincom (20232.yrqn - 20221.yrqn)
	gen m_lexp_qtr_`sample'_noApril23 = r(estimate) if tt_q == 18
	
	drop newrebates

}

bysort yrqn: gen f=_n

labmask tt_q, val(yrqn_str)



#delimit ;
scatter m_lexp_PP tt_q if f==1 & year>=2021, c(l) xlabel(9 "Jan 2021" 11 "Jul 2021" 13 "Jan 2022" 15 "Jul 2022" 17 "Jan 2023" 19 "Jul 2023" 20 " ", val  nogrid) mcolor(red) lcolor(red)
|| scatter m_lexp_PP  tt_q if f==1 & year>=2021, msymbol(none) xaxis(2)
|| scatter m_lexp_qtr_hat_PP  tt_q if f==1 & year>=2021,  c(l) mcolor(red) lcolor(red) lpattern(dash)
legend(pos(6) order(1 "Actual" 2 "Allows for price response only") cols(3) size(med)) ylabel(-0.2(0.2)0.6)
xline(15.5 17.5) xtitle("", axis(2)) xscale(noline axis(2)) 
xla("""", axis(2) angle(45) tlength(0)) 
xtitle("") ytitle("Log spending (deseasonalised)");
#delimit cr
graph export "$resultsdir/FIG_lx_ds_rebates_qtr_PP_realvsfitted.pdf", replace

#delimit ;
scatter m_lexp_cash tt_q if f==1 & year>=2021, c(l) xlabel(9 "Jan 2021" 11 "Jul 2021" 13 "Jan 2022" 15 "Jul 2022" 17 "Jan 2023" 19 "Jul 2023" 20 " ", val  nogrid) mcolor(red) lcolor(red)
|| scatter m_lexp_cash tt_q if f==1 & year>=2021, msymbol(none) xaxis(2)
|| scatter m_lexp_credit tt_q if f==1 & year>=2021,  c(l) mcolor(blue) lcolor(blue)
legend(pos(6) order(1 "Cash rebates" 2 "Credit rebates") cols(2) size(med)) ylabel(-0.2(0.2)0.6)
xline(15.5 17.5) xtitle("", axis(2)) xscale(noline axis(2)) xla("""", axis(2) angle(45) tlength(0)) 
xtitle("") ytitle("Log spending (deseasonalised)");
#delimit cr
graph export "$resultsdir/FIG_lx_ds_rebates_qtr_noPP.pdf", replace

#delimit ;
scatter m_lexp_cash tt_q if f==1 & year>=2021, c(l) xlabel(9 "Jan 2021" 11 "Jul 2021" 13 "Jan 2022" 15 "Jul 2022" 17 "Jan 2023" 19 "Jul 2023" 20 " ", val  nogrid) mcolor(red) lcolor(red)
|| scatter m_lexp_cash tt_q if f==1 & year>=2021, msymbol(none) xaxis(2)
|| scatter m_lexp_qtr_hat_cash tt_q if f==1 & year>=2021,  c(l) mcolor(red) lcolor(red) lpattern(dash)
legend(pos(6) order(1 "Cash rebates" 2 "Cash rebates (price response only)") cols(2) size(med)) ylabel(-0.2(0.2)0.6)
xline(15.5 17.5) xtitle("", axis(2)) xscale(noline axis(2)) xla("""", axis(2) angle(45) tlength(0)) 
xtitle("") ytitle("Log spending (deseasonalised)");
#delimit cr
graph export "$resultsdir/FIG_lx_ds_rebates_qtr_DD_realvsfitted.pdf", replace
*/

**********
** ESTIMATE REBATE MPCs


u "$dataProcess/CSenergyallspending_step6", clear

drop if NI == 1

gen quarter = 1 if inlist(month,1,3)
replace quarter = 2 if inlist(month,4,6)
replace quarter = 3 if inlist(month,7,9)
replace quarter = 4 if inlist(month,10,12)

gen yrqn = year*10 + quarter

gen reb_val = 66 if year == 2022 & rebates==1 & inlist(month,10,11)
replace reb_val = 67 if (year == 2023|year==2022 & month==12) & rebates==1
replace reb_val = 0 if reb_val == .
replace reb_val = reb_val/cpi_allitems

gen col_val = 326 if year ==2022 & month==7 & col == 1
replace col_val = 324 if year ==2022 & month==11 & col ==1
replace col_val = 301 if year ==2023 & (month==4 | month==5)  & col==1
replace col_val = 0 if col_val == .
replace col_val =col_val/cpi_allitems

*set col2months = 1 if col==1
sort userref year month
gen col2months = 1 if col==1
bys userref (year month): replace col2months = 1 if col[_n-1]==1 & year==year[_n-1] & month==month[_n-1]+1
replace col2months = 0 if col2months==.

gen lessthanrebate = exp_energy_t_noreb<66 if month==9 & year==2022

log using "${resultsdir}/LOG_prop_lessthanrebate.txt", text replace
su lessthanrebate if year ==2022 & month==9 & sample==1
local ppmean = r(mean)
su lessthanrebate if year ==2022 & month==9 & sample==2
local varddmean = r(mean)
di 0.15*`ppmean' + 0.85*`varddmean' 
di 1- (0.15*`ppmean' + 0.85*`varddmean')
log close 

gen rebatereceived = exp_energy_t_reb - exp_energy_t_noreb
gen possconstrained_temp = inrange(exp_energy_t_reb-rebatereceived,0,5) if rebates==1
**likely constrained if energy expenditure less rebate small
egen possconstrained = max(possconstrained_temp), by(userref)

egen sumrebates = sum(rebates) if rebates==1, by(userref)
egen sumenergyrebate = sum(exp_energy_t_reb) if rebates==1, by(userref)
egen sumenergynorebate = sum(exp_energy_t_noreb) if rebates==1, by(userref)
egen colvalue = sum(col_val) if col==1 & reccol==1, by(userref)
gen col2monthsvalue = colvalue 
gen rebatesvalue = sumenergyrebate - sumenergynorebate
egen sumrebatesvalue = sum(reb_val) if rebates==1, by(userref)
*these individuals received cash rebates in each month we observe them during the rebate period
replace rebatesvalue = sumrebatesvalue if everEBSScash==1 

foreach v in sumenergyrebate sumenergyrebate colvalue rebatesvalue {
	egen temp = max(`v'), by(userref)
	replace `v' = temp
	drop temp
}

gen postrebates_qtr = year==2023 & inlist(month,4,5,6)
gen postrebates_3qtr = year==2023 & month>=4
gen postrebates_month = year==2023 & month==4

merge m:1 ofgem_region year month using `lagsandleads'

*******************************

xtreg lexp_ds c.lprice c.lag_lprice c.lead_lprice wfh $tempcontrols i.rebates i.postrebates_qtr i.col2months if  tt_toinclude2==1 & sample>1 & everEBSScash==1, i(userref) fe robust
duansmearing, tabname("MPC") varlist(rebates col2months) postrebates("qtr") lagleadprices("yes")
estimates store MPCs_cashDD_postqtr

xtreg lexp_ds c.lprice wfh $tempcontrols i.rebates i.col2months if  tt_toinclude2==1 & sample==1, i(userref) fe robust
duansmearing, tabname("MPC") varlist(rebates col2months) 
estimates store MPCs_PP

xtreg lexp_ds c.lprice wfh $tempcontrols i.rebates i.postrebates_month i.col2months if  tt_toinclude2==1 & sample==1, i(userref) fe robust
duansmearing, tabname("MPC") varlist(rebates col2months) postrebates("month")
estimates store MPCs_PP_postmonth

**********
*Diff in diff estimate 

gen lx_ener = ln(exp_energy_t_noreb)

*deseasonalise separately for those who receive EBSS vs not (absolute cash spending)
gen sampletouse = inlist(sample,2,3)
deseason, v(lx_ener) newv("x_ener_ds_everEBSS") 

cap program drop mpccalc
program mpccalc, eclass

	tempvar sample
	
	xtreg x_ener_ds_everEBSS i.yrmn i.yrmn#everEBSS if tt_toinclude2==1 & sample_PP!=1 & everEBSSbutnorebate!=1
	adjustmonthdummies, interactvar("everEBSS")
	
	local N = e(N)
	local Ng = e(N_g)
	local r2 = e(r2)
	local depvar = e(depvar)
	gen `sample' = e(sample)
	
	*sum of coefficients over whole rebate + post period 
	#delimit ;
	lincom 1- ((202210.yrmn#1.everEBSS + 202211.yrmn#1.everEBSS + 202212.yrmn#1.everEBSS + 202301.yrmn#1.everEBSS + 202302.yrmn#1.everEBSS + 202303.yrmn#1.everEBSS + 202304.yrmn#1.everEBSS + 202305.yrmn#1.everEBSS + 202306.yrmn#1.everEBSS + 202307.yrmn#1.everEBSS + 202308.yrmn#1.everEBSS + 202309.yrmn#1.everEBSS + 202310.yrmn#1.everEBSS + 202311.yrmn#1.everEBSS + 202312.yrmn#1.everEBSS)/342.73059);
	#delimit cr
	
	matrix b = r(estimate)
	matrix V = r(se)^2
	matrix colnames b = "rebates"
	matrix colnames V = "rebates"
	matrix rownames V = "rebates"

	local N = e(N)
	local Ng = e(N_g)
	local r2 = e(r2)
	local depvar = e(depvar)

	ereturn post b V, esample(`sample') buildfvinfo
	ereturn local depvar = "`depvar'"
	ereturn scalar N    = `N'
	ereturn scalar Ng    = `Ng'
	ereturn scalar r2   = `r2'
	ereturn local cmd "results_season"
	estimates store MPCestimate_DiD
	
end

mpccalc

sa "$dataProcess/MPCresults", replace 

*/

u "$dataProcess/MPCresults", clear  

#delimit ;
esttab MPCs_cashDD_postqtr MPCs_PP MPCs_PP_postmonth MPCestimate_DiD using "${resultsdir}/LOG_MPCsendofrebates.txt", 
se replace nostar mtitles("CashDD" "PP" "PP_postmonth" "DiD") scalar(Ng r2);
#delimit cr

*Save results for paper

foreach estimates in _cashDD_postqtr _PP _PP_postmonth {
	estimates restore MPCs`estimates'
	gen coeff_reb`estimates' = _b[rebates] 
	gen se_reb`estimates' = _se[rebates] 
	gen coeff_col`estimates' = _b[col] 
	gen se_col`estimates' = _se[col] 
	gen N_`estimates' = e(N)

}

estimates restore MPCestimate_DiD

*make negative to put in terms of MPC of credit recipients
gen coeff_reb_DiD = -_b[rebates] 
gen se_reb_DiD = _se[rebates] 
gen N_g_DiD = e(Ng)
gen N_DiD = e(N)


format %9.2f coeff* se*
format %9.0fc N_*

foreach v in _cashDD_postqtr _PP _PP_postmonth _DiD {
	su se_reb`v'
	gen temp = r(mean)
	format %9.3f temp
	tostring temp, use force gen(se_reb`v'_s)
	replace se_reb`v'_s = "{\small ("+ se_reb`v'_s+")}"
	drop temp
	
	if "`v'"!="_DiD" {
		su se_col`v'
		gen temp = r(mean)
		format %9.3f temp
		tostring temp, use force gen(se_col`v'_s)
		replace se_col`v'_s = "{\small ("+ se_col`v'_s+")}"
		drop temp
	}
}

gen reb_lab = "Energy-support transfers (distributed via suppliers)"
gen col_lab = "Cost-of-living transfers"
gen N_lab = "N"
gen blank = ""

listtab reb_lab  coeff_reb_PP coeff_reb_PP_postmonth in 1 using "$resultsdir/TAB_MPCrebates_PP.tex", replace rstyle(tabular)
listtab blank se_reb_PP_s se_reb_PP_postmonth_s  in 1,  appendto("$resultsdir/TAB_MPCrebates_PP.tex")  rstyle(tabular)
listtab col_lab  coeff_col_PP coeff_col_PP_postmonth   in 1,  appendto("$resultsdir/TAB_MPCrebates_PP.tex")  rstyle(tabular)
listtab blank se_col_PP_s se_col_PP_postmonth_s  in 1,  appendto("$resultsdir/TAB_MPCrebates_PP.tex")  rstyle(tabular)
listtab N_lab  N__PP N__PP_postmonth   in 1 using "$resultsdir/TAB_MPCrebates_PP_N.tex",    rstyle(tabular) replace 

listtab reb_lab coeff_reb_cashDD_postqtr coeff_reb_DiD in 1 using "$resultsdir/TAB_MPCrebates_DD.tex", replace rstyle(tabular)
listtab blank se_reb_cashDD_postqtr_s se_reb_DiD_s in 1,  appendto("$resultsdir/TAB_MPCrebates_DD.tex")  rstyle(tabular)
listtab col_lab coeff_col_cashDD_postqtr blank in 1,  appendto("$resultsdir/TAB_MPCrebates_DD.tex")  rstyle(tabular)
listtab blank se_col_cashDD_postqtr_s blank in 1,  appendto("$resultsdir/TAB_MPCrebates_DD.tex")  rstyle(tabular)
listtab N_lab  N__cashDD_postqtr  N_DiD   in 1 using "$resultsdir/TAB_MPCrebates_DD_N.tex",    rstyle(tabular) replace 


