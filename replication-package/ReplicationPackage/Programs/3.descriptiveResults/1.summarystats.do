set more off
clear all

set scheme cleanplots


**********
** Summary stats

use "$dataProcess/CSenergyallspending_step5", clear 


drop if drop_outliers == 1
drop if no_het == 1 
drop if year<=2018


bysort userref sample: gen nn=_n

log using "$resultsdir/LOG_numusers.log", replace

** number of  usrs
distinct userref 
distinct userref if sample==1 | sample==2


tab sample if nn==1

tab sample if mode1!="Card payment" & mode2!="Card payment" & sample!=1

** shr of DD households that are fixed
distinct userref if sample == 3 & mode1!="Card payment" & mode2!="Card payment"
local num_fixedDD = r(ndistinct) 
distinct userref if sample ==2 & mode1!="Card payment" & mode2!="Card payment" 
local num_varDD = r(ndistinct) 

disp `num_varDD'/(`num_varDD' + `num_fixedDD')


**number of top ups per pp household per month
su ntrans1 if sample == 1 & year<=2020


**share of spending on SC from 2021 onwards
su exp_energy_t_sc if year>=2021
local msc = r(mean)
su exp_energy_t_reb if year>=2021
local mexp = r(mean)
disp `msc'/`mexp'


log close

*/

**********



**********
** VALIDATION

use "$dataProcess/CSenergy_step1_combine.dta" , clear


log using "$resultsdir/LOG_likelyPP_bysupplier.log", replace


tab energy_supplier likely_pp, row

bysort userref year month: gen N=_N
bysort userref year month: gen n=_n


tab N if n==1 & direct_debit == 1

tab mode if direct_debit==1

log close

*/

**********

 

**********
** SEASONALITY OF VARIABLE SPENDING

use "$dataProcess/CSenergyallspending_step5", clear 


drop if drop_outliers == 1
drop if no_het == 1  //effectively drops NI too
drop if dataset==2
drop if year<=2018


keep userref userref_orig yrmn  rebates energy_supplier1 energy_supplier2 salaryrange year month  exp_energy_t_noreb exp_energy_t_reb sample_*  cpi_gas cpi_elec cpi_ener pidx_energy_tot_lasp leqnt_noreb leqnt lexp lexp_noreb lprice rebates  sample inc_quint eexp_quint sexp_quint 


gen beta_mm = 0
gen lb_mm = 0
gen ub_mm = 0
foreach s in 1 2 3  {
	xtreg lexp i.month if sample == `s' & year<=2020, i(userref) fe robust
	forval m = 1/12 {
		lincom _b[`m'.month]
		replace beta_mm =r(estimate) if sample == `s' & `m'.month==1
		replace lb_mm = r(estimate) - 1.96*r(se) if sample == `s' & `m'.month==1
		replace ub_mm = r(estimate) + 1.96*r(se) if sample == `s' & `m'.month==1
	}
}

bysort month sample: gen f=_n

#delimit ;
twoway rcap lb_mm ub_mm month if sample == 1 & f==1, lcolor(gs10)
|| rcap lb_mm ub_mm month if sample == 2 & f==1, lcolor(gs10)
|| rcap lb_mm ub_mm month if sample == 3 & f==1, lcolor(gs10)
|| scatter beta_mm month if sample == 1 & f==1, c(l) mcolor(red) lcolor(red) msymbol(s)  legend(label(4 "Prepayment"))
|| scatter beta_mm month if sample == 2 & f==1, c(l) mcolor(edkblue) lcolor(edkblue) msymbol(d) legend(label(5 "Variable direct debit"))
|| scatter beta_mm month if sample == 3 & f==1, c(l) mcolor(eltblue) lcolor(eltblue) msymbol(o) lpattern(dash) legend(label(6 "Other payment types") order(4 5 6) pos(6))
xlabel(1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec")
ytitle("Log energy spending (relative to January)") xtitle("")
;
#delimit cr
graph export "$resultsdir/FIG_paymenttypes_season.pdf", replace

*/


**********







**********
** SUMMARY STAT TABLE

use "$dataProcess/CSenergyallspending_step5", clear 

drop if drop_outliers == 1
drop if no_het == 1 
drop if year<=2018


keep userref yrmn  rebates year month age_2021  exp_energy_t_noreb exp_energy_t_reb sample_* age age_2021 gor  sample inc_quint eexp_quint sexp_quint 

bysort userref sample: gen n = _n
replace n = 0 if n>1

bysort sample: gen Nobs=_N
bysort sample: egen Nuser = total(n)

gen mexp = .
foreach s in 1 2 3 {
	su exp_energy_t_noreb if sample == `s' & year == 2019
	replace mexp = r(mean) if sample == `s'
}


merge m:1 userref using "$dataProcess/heterogeneity_measures.dta"
drop if _m==2
drop _m

egen age_5band = cut(age_2021), at(16(5)91)
replace age_5band = 76 if age_5band>=76
label var age_5band "5-year age band"


foreach v in inc_quint eexp_quint  age_5band  gor {

	bysort sample `v': egen Nuser_`v' = total(n)
	gen shrUser_`v' = Nuser_`v'*100/Nuser

}

collapse (mean) Nobs mexp Nuser* shrUser* , by(sample inc_quint eexp_quint age_5band gor)


sa "$dataAnalysis/summarystats", replace

*/

u "$dataAnalysis/summarystats", clear


collapse (mean) Nobs mexp Nuser , by(sample)

egen Nobs_tot  = total(Nobs)
egen Nuser_tot = total(Nuser)
gen shrUser = Nuser*100/Nuser_tot

gen sample_vari = "\cmark " if sample == 1 | sample ==2
replace sample_vari = "\xmark " if sample == 3

gen sample_all = "\cmark " 


gen sample_name = "Smoothed direct debit \& other payment modes" if sample == 3
replace sample_name = "Variable direct debit" if sample == 2
replace sample_name = "Prepayment" if sample == 1

gen total = "Total"
gen blank = ""
gen shr_tot = 100

format %9.1f shrUser mexp shr_tot
format %9.0fc Nobs Nuser Nuser_tot Nobs_tot


listtab sample_name sample_vari  Nuser shrUser  mexp using "$resultsdir/TAB_summary.tex", replace rstyle(tabular)
listtab total blank  Nuser_tot shr_tot  blank using "$resultsdir/TAB_summary_tot.tex" in 1, replace rstyle(tabular)

*/


foreach v in gor age_5band {

	u "$dataProcess/CSenergyallspending_step2b_weights", clear

	bysort age_5band gor: gen f=_n

	bysort `v': egen t1 = total(count_norm) if f == 1
	egen t2 = total(count_norm) if f == 1
	gen shr_`v'_pop = t1/t2
	drop t1 t2

	collapse (mean) shr_`v'_pop, by(`v')

	sa "$dataAnalysis/`v'_pop", replace

}
*/


u "$dataAnalysis/summarystats", clear

collapse (mean) shrUser_gor, by(gor sample)

ren shrUser_gor shrUser_s
reshape wide shrUser_s, i(gor) j(sample)

merge m:1 gor using "$dataAnalysis/gor_pop"
drop _m

replace shr_gor_pop = shr_gor_pop*100


#delimit ;
label def gorr
1 "North East"
2 "North West"
3 "Yorkshire"
4 "East Midlands"
5 "West Midlands"
6 "East"
7 "London"
8 "South East"
9 "South West"
10 "Wales"
11 "Scotland"
12 "Northern Ireland"
;
#delimit cr
label val gor gorr

#delimit ;
graph bar shrUser_s1 shrUser_s2 shrUser_s3 shr_gor_pop, over(gor, label(angle(45)) sort(shr_gor_pop) desc)
legend(label(1 "Prepayment") label(2 "Variable direct debit") label (3 "Smoothed direct debit and other payment types") label(4 "UK population") pos(6))
bar(3, color(eltblue%30) lcolor(edkblue))
bar(4, color(gs12) )
ytitle("% households")
;
#delimit cr
graph export  "$resultsdir/FIG_sample_gor.pdf", replace



u "$dataAnalysis/summarystats", clear

collapse (mean) shrUser_age_5band, by(age_5band sample)

ren shrUser_age_5band shrUser_s
reshape wide shrUser_s, i(age_5band) j(sample)

merge m:1 age_5band using "$dataAnalysis/age_5band_pop"
drop _m

replace shr_age_5band_pop = shr_age_5band_pop*100

label def age_5band 16 "16-20" 21 "21-25" 26 "26-30" 31 "31-35" 36 "36-40" 41 "41-45" 46 "46-50" 51 "51-55" 56 "56-60" 61 "61-65" 66 "66-70" 71 "71-75" 76 "76+"
label val age_5band age_5band


#delimit ;
graph bar shrUser_s1 shrUser_s2 shrUser_s3 shr_age_5band_pop, over(age_5band, label(angle(45)))
legend(label(1 "Prepayment") label(2 "Variable direct debit") label (3 "Smoothed direct debit and other payment types") label(4 "UK population") pos(6))
bar(3, color(eltblue%30) lcolor(edkblue))
bar(4, color(gs12) )
ytitle("% households")
;
#delimit cr
graph export  "$resultsdir/FIG_sample_age.pdf", replace

*/


use "$dataProcess/CSenergyallspending_step5", clear 

drop if drop_outliers == 1
drop if no_het == 1 
drop if year<=2018


keep userref yrmn  rebates year month age_2021  exp_energy_t_noreb exp_energy_t_reb sample_* age age_2021 gor  sample inc_quint eexp_quint sexp_quint 


merge m:1 userref using "$dataProcess/heterogeneity_measures.dta"
drop if _m==2
drop _m


isid  userref sample yrmn 
sort userref sample yrmn 
by userref sample: gen n = _n
keep if n==1


#delimit ;
twoway histogram mtot_in_excltrans if sample == 1, fcolor(red%20) lcolor(red%40) w(100) legend(label(1 "Prepayment")) frac
|| histogram mtot_in_excltrans if sample == 2, fcolor(eltblue%20) lcolor(eltblue) w(100) legend(label(2 "Variable direct debit")) frac
|| histogram mtot_in_excltrans if sample == 3, fcolor(none) lcolor(edkblue) w(100) legend(label(3 "Smoothed direct debit and other payment types") pos(6)) frac
xtitle("Mean monthly income (£)") xlabel(1000(1000)10000)
; 
#delimit cr
graph export  "$resultsdir/FIG_sample_inc_distr.pdf", replace


#delimit ;
twoway histogram mexp_energy_t_reb if sample == 1  & mexp_energy_t_reb>=25 & mexp_energy_t_reb<=250, fcolor(red%20) lcolor(red%40) w(2.5) legend(label(1 "Prepayment")) frac
|| histogram mexp_energy_t_reb if sample == 2 & mexp_energy_t_reb>=25 & mexp_energy_t_reb<=250, fcolor(eltblue%20) lcolor(eltblue) w(2.5) legend(label(2 "Variable direct debit")) frac
|| histogram mexp_energy_t_reb if sample == 3 & mexp_energy_t_reb>=25 & mexp_energy_t_reb<=250, fcolor(none) lcolor(edkblue) w(2.5) legend(label(3 "Smoothed direct debit and other payment types") pos(6)) frac
xtitle("Mean monthly energy spend (£)")
 xlabel(25(25)250)
; 
#delimit cr
graph export  "$resultsdir/FIG_sample_eexp_distr.pdf", replace

*/


**********

**********
** FUEL POVERTY

use "$dataProcess/CSenergyallspending_step5", clear 

drop if drop_outliers == 1
drop if no_het == 1 
drop if year<=2018


merge m:1 inc_dec mtot_out_nondurab_dec eexp_dec  using "$dataProcess/lcfsdata_incAHC"
drop _m

gen incAHC = incAHC_over_nondur_pred*tot_out_nondurab_reb
replace incAHC=100 if incAHC<100

gen shrAHC = exp_energy_t_reb / incAHC

gen fuel_poverty = shrAHC>=0.1
tab year fuel_poverty, row

log using "$resultsdir/LOG_energy_poverty.log", replace

tab  fuel_poverty if year==2019 
su fuel_poverty if year==2019 
global num_fuelpov = 28*r(mean)
disp as error "number of households in fuel poverty in 2019: $num_fuelpov"

log close


collapse (mean) shrAHC incAHC tot_in_excltrans, by(userref year)

binscatter incAHC tot_in_excltrans, xtitle("Income measured in the ExactOne data (£/month)") ytitle("Imputed after-housing-costs income (£/month)")
graph export "$resultsdir/FIG_incAHC_byinc.pdf", replace

gen energy_poverty =  shrAHC >0.1
xtile inc_dec = tot_in_excltrans, nq(10)

bysort inc_dec: egen menergy_poverty = mean(energy_poverty)
bysort inc_dec: gen f=_n

graph twoway bar menergy_poverty inc_dec if f==1, barw(0.8) xlabel(1(1)10) ylabel(0(0.1)0.5) yscale(range(0(0.1)0.5)) xtitle("Income decile") ytitle("Share of households in energy poverty in 2019") color(edkblue)
graph export "$resultsdir/FIG_energypov_bydecile.pdf", replace


**********




**********
** NUMBER OF OBSERVATIONS TABLE



use "$dataProcess/CSenergyallspending_step5", clear 

drop if drop_outliers == 1
drop if no_het == 1  & NI ==0
drop if year<=2018
drop if NI == 1



keep userref yrmn  rebates year month age_2021 no_lagged_income exp_energy_t_noreb exp_energy_t_reb sample_* age age_2021 gor  sample inc_quint eexp_quint sexp_quint  tt_toinc* tt_toinclude* NI

 
gen period_all = yrmn>=202106 & yrmn<=202312 & sample<=2
gen period_elas = yrmn>=202106 & yrmn<=202209 & sample<=2
gen period_label1 = yrmn>=202106 & yrmn<=202312 & sample == 1
gen period_label2 = yrmn>=202210 & yrmn<=202306 & sample == 1
gen period_demin = yrmn>=202106 & yrmn<=202306 & sample<=2 & no_lagged_income==0
gen period_demout = yrmn>=202310 & yrmn<=202312 & sample<=2 & no_lagged_income==0


foreach v in all elas label1 label2 demin demout {
	egen nobs_`v' = total(period_`v')
	

	bysort userref sample period_`v': gen n = _n
	replace n = 0 if n>1
	
	egen nuser_`v' = total(n*period_`v')
	drop n
}

keep in 1 
keep nobs* nuser*

gen i = 1
reshape long nobs_ nuser_, i(i) j(period) s

gen time_period = 11 if period == "elas"
replace time_period = 21 if period == "label1"
replace time_period = 22 if period == "label2"
replace time_period = 31 if period == "demin"
replace time_period = 32 if period == "demout"

replace time_period = 1 if period == "all"

#delimit ;
label def time_period
1   "June 2021 -- December 2023"
11  "June 2021 -- September 2022"
21  "June 2021 -- December 2023 (prepay only)"
22  "October 2022 -- June 2023 (prepay only)"
31  "June 2021 -- June 2023 (in-sample)"
32  "October 2023 -- December 2023 (out-of-sample)"
;
#delimit cr

label val time_period time_period 

format %9.0fc  nuser_ nobs_


listtab time_period nuser_ nobs_ using "$resultsdir/TAB_nobs_elas.tex" if time_period == 11 , replace  rstyle(tabular) 
listtab time_period nuser_ nobs_ using "$resultsdir/TAB_nobs_label.tex" if time_period >= 21 & time_period <= 21, replace  rstyle(tabular) 
listtab time_period nuser_ nobs_ using "$resultsdir/TAB_nobs_dem.tex" if time_period >= 31 & time_period <= 32, replace  rstyle(tabular) 
listtab time_period nuser_ nobs_ using "$resultsdir/TAB_nobs_all.tex" if time_period ==1, replace  rstyle(tabular) 



**********



**********
** Compare distributions with the LCFS

use "$dataProcess/CSenergyallspending_step5", clear 

** drop if drop_outliers == 1
drop if no_het == 1 
keep if year==2019

gen exp_energy_t_noreb_PP = exp_energy_t_noreb if sample_PP==1

**take the mean over months present in the data
collapse (mean) tot_out_nondurab tot_in_excltrans exp_energy_t_noreb exp_energy_t_noreb_PP  weight_fullsam_all, by(userref)

ren weight_fullsam_all weight_fullsamp

gen v_nondur = tot_out_nondurab
gen v_inc = tot_in_excltrans
gen v_energy = exp_energy_t_noreb
gen v_energy_PP = exp_energy_t_noreb_PP

foreach var in v_energy v_nondur v_inc {
	sort `var', stable
	egen rank_`var' = rank(`var'), field
	count if `var'!=.
	replace rank_`var' = 100 - 100*rank_`var'/r(N)
	**spearman's rank correlation
	corr rank_v_energy rank_`var'
	local spearman_energy_`var' = r(rho)
}

binscatter rank_v_energy rank_v_nondur, nquantiles(100) ylabel(0(20)100) xlabel(0(20)100) text(95 80 `"Spearman's rank = `:display %6.3f `spearman_energy_v_nondur''"') xtitle("Rank average monthly nondurable spend") ytitle("Rank average monthly energy spend")
graph export "$resultsdir/FIG_rankrank_energyvsnondur_CS.pdf", replace

binscatter rank_v_energy rank_v_inc , nquantiles(100) ylabel(0(20)100) xlabel(0(20)100) text(95 80 `"Spearman's rank = `:display %6.3f `spearman_energy_v_inc''"') xtitle("Rank average monthly income") ytitle("Rank average monthly energy spend")
graph export "$resultsdir/FIG_rankrank_energyvshhinc_CS.pdf", replace

**histogram variables 
foreach v in nondur inc energy energy_PP {
	centile v_`v', centile(1 99)
	global start = r(c_1)
	global end = r(c_2)
	global width_cs_`v' = (r(c_2)  - r(c_1))/100
	gen weight_temp = weight_fullsamp
	replace weight_temp = . if v_`v'<$start | v_`v'>$end

	egen x_`v'_cs = cut(v_`v'), at($start(${width_cs_`v'})$end)
	bysort x_`v'_cs: egen t1 = total(weight_temp)
	egen t2 = total(weight_temp)
	gen density_`v'_cs = (t1/t2)/${width_cs_`v'}
	drop t1 t2 weight_temp
	bysort  x_`v'_cs: gen f_`v' = _n
	replace  density_`v'_cs = . if f_`v'>1
	replace  x_`v'_cs = . if f_`v'>1

	sort  x_`v'_cs 
	gen n_`v' = _n if x_`v'_cs != .

}

drop if n_nondur == . & n_inc == . &  n_energy == . &  n_energy_PP == . 

collapse (mean) x_nondur_cs density_nondur_cs x_inc_cs density_inc_cs x_energy_cs x_energy_PP_cs density_energy_cs density_energy_PP_cs, by( n_nondur n_inc n_energy n_energy_PP)

gen n = n_nondur 
forval n = 1/99 {
	foreach v in inc energy energy_PP {
		gen temp = x_`v'_cs if n_`v' == `n'
		egen temp2 = max(temp)
		replace x_`v'_cs = temp2 if n == `n' &  x_`v'_cs  == .
		drop temp*

		gen temp = density_`v'_cs if n_`v' == `n'
		egen temp2 = max(temp)
		replace density_`v'_cs = temp2 if n == `n' & density_`v'_cs == .
		drop temp*
	}
}

drop n_*
drop if n==.
tempfile cshist
save `cshist'

use "$dataProcess/lcfsdata", clear

keep if year==2019
drop if gor == 12

gen v_nondur = nondurables_lcfs
gen v_inc = hhinc_lcfs
gen v_energy = energy_lcfs

gen weight_fullsamp = 1

foreach var in v_energy v_nondur v_inc {
	sort `var', stable
	egen rank_`var' = rank(`var'), field
	count if `var'!=.
	replace rank_`var' = 100 - 100*rank_`var'/r(N)	
	*spearman's rank correlation
	corr rank_v_energy rank_`var'
	local spearman_energy_`var' = r(rho)
}

binscatter rank_v_energy rank_v_nondur, nquantiles(100) ylabel(0(20)100) xlabel(0(20)100) text(95 80 `"Spearman's rank = `:display %6.3f `spearman_energy_v_nondur''"') xtitle("Rank average monthly nondurable spend") ytitle("Rank average monthly energy spend")
graph export "$resultsdir/FIG_rankrank_energyvsnondur_LCFS.pdf", replace

binscatter rank_v_energy rank_v_inc, nquantiles(100) ylabel(0(20)100) xlabel(0(20)100) text(95 80 `"Spearman's rank = `:display %6.3f `spearman_energy_v_inc''"') xtitle("Rank average monthly income") ytitle("Rank average monthly energy spend")
graph export "$resultsdir/FIG_rankrank_energyvshhinc_LCFS.pdf", replace

foreach source in elec gas combined {
	gen prepay`source' = inlist(paymentmethod_`source',3)
	gen directdebit`source' = inlist(paymentmethod_`source',1)
	gen standardcredit`source' = inlist(paymentmethod_`source',2)
	gen payother`source' = inlist(paymentmethod_`source',4,5,6,7,8)
}

gen sample_PP = ((prepayelec==1 & prepaygas==1)| prepaycombined==1)

gen v_energy_PP = energy_lcfs if sample_PP==1

**histogram variables 
foreach v in nondur inc energy energy_PP {
	centile v_`v', centile(1 99)
	global start = r(c_1)
	global end = r(c_2)
	global width_lcfs_`v' = (r(c_2)  - r(c_1))/100
	gen weight_temp = weight_fullsamp
	replace weight_temp = . if v_`v'<$start | v_`v'>$end

	egen x_`v'_lcfs = cut(v_`v'), at($start(${width_lcfs_`v'})$end)
	bysort x_`v'_lcfs: egen t1 = total(weight_temp)
	egen t2 = total(weight_temp)
	gen density_`v'_lcfs = (t1/t2)/${width_lcfs_`v'}
	drop t1 t2 weight_temp
	bysort  x_`v'_lcfs: gen f_`v' = _n
	replace  density_`v'_lcfs = . if f_`v'>1
	replace  x_`v'_lcfs = . if f_`v'>1

	sort  x_`v'_lcfs 
	gen n_`v' = _n if x_`v'_lcfs != .

}


drop if n_nondur == . & n_inc == . &  n_energy == .  &  n_energy_PP == . 

collapse (mean) x_nondur_lcfs density_nondur_lcfs x_inc_lcfs density_inc_lcfs x_energy_lcfs density_energy_lcfs x_energy_PP_lcfs density_energy_PP_lcfs, by( n_nondur n_inc n_energy n_energy_PP)


gen n = _n
forval n = 1/100 {
	foreach v in nondur inc energy energy_PP {
		gen temp = x_`v'_lcfs if n_`v' == `n' 
		egen temp2 = max(temp)
		replace x_`v'_lcfs = temp2 if n == `n' &  x_`v'_lcfs == .
		drop temp*

		gen temp = density_`v'_lcfs if n_`v' == `n'
		egen temp2 = max(temp)
		replace density_`v'_lcfs = temp2 if n == `n' & density_`v'_lcfs==.
		drop temp*
	}
}


drop n_*
drop if n==.

merge 1:1 n  using `cshist'
drop _m

#delimit ;
twoway bar density_energy_lcfs x_energy_lcfs, legend(label(1 "LCFS")) barw($width_lcfs_energy) 
|| bar density_energy_cs x_energy_cs, fcolor(none)  barw($width_cs_energy) legend(off) 
xtitle("Monthly energy spending in 2019")  ytitle("Density")
graphr(color(white))
;
#delimit cr
graph export "$resultsdir/FIG_lcfsvscs_energy.pdf", replace

#delimit ;
twoway bar density_energy_PP_lcfs x_energy_PP_lcfs, legend(label(1 "LCFS")) barw($width_lcfs_energy) 
|| bar density_energy_cs x_energy_cs, fcolor(none)  barw($width_cs_energy) legend(off) 
xtitle("Monthly energy spending in 2019")  ytitle("Density")
graphr(color(white))
;
#delimit cr
graph export "$resultsdir/FIG_lcfsvscs_energy_PP.pdf", replace

#delimit ;
twoway bar density_nondur_lcfs x_nondur_lcfs, legend(label(1 "LCFS")) barw($width_lcfs_nondur)
|| bar density_nondur_cs x_nondur_cs, fcolor(none)  barw($width_cs_nondur) legend(off) 
xtitle("Monthly nondurable spending in 2019")  ytitle("Density")
graphr(color(white))
;
#delimit cr
graph export "$resultsdir/FIG_lcfsvscs_nondur.pdf", replace


#delimit ;
twoway bar density_inc_lcfs x_inc_lcfs, legend(label(1 "LCFS")) barw($width_lcfs_inc)
|| bar density_inc_cs x_inc_cs, fcolor(none)  barw($width_cs_inc) 
legend(off) 
xtitle("Monthly income in 2019")  ytitle("Density")
graphr(color(white))
;
#delimit cr
graph export "$resultsdir/FIG_lcfsvscs_inc.pdf", replace


**********
*/


**********
** DIFFERENT PAYMENT TYPES

use "$dataProcess/lcfsdata", clear

keep if year==2019
drop if gor==12

gen directdebitspend = exp_elec*(paymentmethod_elec==1) + exp_gas*(paymentmethod_gas==1) + (exp_elec+exp_gas)*(paymentmethod_combined==1)
gen creditspend = exp_elec*(paymentmethod_elec==2) + exp_gas*(paymentmethod_gas==2) + (exp_elec+exp_gas)*(paymentmethod_combined==2)
gen ppspend = exp_elec*(paymentmethod_elec==3) + exp_gas*(paymentmethod_gas==3) + (exp_elec+exp_gas)*(paymentmethod_combined==3)
gen otherspend = exp_elec*(paymentmethod_elec>3) + exp_gas*(paymentmethod_gas>3) + (exp_elec+exp_gas)*(paymentmethod_combined>3)

collapse (sum) directdebitspend creditspend ppspend otherspend exp_elec exp_gas [aw=weighta]

gen total = exp_elec + exp_gas - otherspend
foreach var in directdebitspend creditspend ppspend {
	gen prop`var' = `var'/total
}

log using "$resultsdir/LOG_LCFS_ppshr.log", replace

su propdirectdebitspend 
su propcreditspend 
su propppspend 

log close 


**********

use "$dataProcess/lcfsdata", clear

gen sepgas = paymentmethod_gas>1 if paymentmethod_gas<.
gen sepelec = paymentmethod_elec>1 if paymentmethod_elec<.
gen combined= paymentmethod_combined>1 if paymentmethod_combined<.

gen hasgas = sepgas==1 | combined==1 if sepgas<. & combined<.
gen haselec = sepelec==1 | combined==1 if sepelec<. & combined<.

log using "$resultsdir/sharecombinedbills_LCFS.txt", text replace
tab hasgas combined if year==2019 & gor<12, row
tab haselec combined if year==2019 & gor<12, row
log close 

/************************************************/
/*          GAS/ELEC SHARES BY DECILE           */
/************************************************/

*How does LCFS split up combined bills?
*Ask households to consult combined statements
*On your most recent bill or online statement, how much of the combined amount is for
*gas?

gen quintinc = .
forval year = 2013/2019 {
	xtile quintinc_temp = hhinc [aw=weighta] if year==`year', n(5)
	replace quintinc = quintinc_temp if year==`year'
	drop quintinc_temp
}

label define quintinc 1 "Poorest" 2 "2" 3 "3" 4 "4" 5 "Richest"
label values quintinc quintinc

*do within month to account for seasonal effects
gen quintenergyspend = .
forval year = 2013/2019 {
	forval month = 1/12 {
		xtile quintenergyspend_temp = exp_energy [aw=weighta] if year==`year' & month==`month', n(5)
		replace quintenergyspend = quintenergyspend_temp if year==`year' & month==`month'
		drop quintenergyspend_temp
	}
}

label define quintenergyspend 1 "Lowest" 2 "2" 3 "3" 4 "4" 5 "Highest"
label values quintenergyspend quintenergyspend

gen share_gas = exp_gas/exp_energy

preserve
collapse (mean) share_gas if year==2019 & share_gas>=0 & share_gas<=1 [aw=weighta], by(quintenergyspend quintinc)
#delimit ;
twoway 
(scatter share_gas quintenergyspend if quintinc==1, c(l) lcolor(gs12) mcolor(gs12) lpattern(solid) msymbol(o))
(scatter share_gas quintenergyspend if quintinc==2, c(l) lcolor(eltblue) mcolor(eltblue) lpattern(solid) msymbol(d))
(scatter share_gas quintenergyspend if quintinc==3, c(l) lcolor(ebblue) mcolor(ebblue) lpattern(solid) msymbol(t))
(scatter share_gas quintenergyspend if quintinc==4, c(l) lcolor(edkblue) mcolor(edkblue) lpattern(solid) msymbol(s))
(scatter share_gas quintenergyspend if quintinc==5, c(l) lcolor(black) mcolor(black) lpattern(solid) msymbol(X)), 
legend(pos(6) rows(1) label(1 "Q1") label(2 "Q2") label(3 "Q3") label(4 "Q4") label(5 "Q5")  title("Income quintile:", size(medsmall)))
ytitle(Share spent on gas) xtitle(Energy spend quintile) ylabel(0(0.1)0.6) ;
#delimit cr
graph export "$resultsdir/FIG_sharegas_byincandexp.pdf", replace
restore 

















