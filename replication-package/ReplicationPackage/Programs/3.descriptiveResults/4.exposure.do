set more off
cap log close 



**********
**EXPOSURE TO SHOCKS (IN CROSS SECTION)


use "$dataProcess/CSenergyallspending_step5", clear 


drop if drop_outliers == 1
drop if no_het == 1   //drops NI too
keep if year<=2020

su liquid_assets,d
replace liquid_assets = . if liquid_assets<=r(p1) | liquid_assets>=r(p99)


collapse (mean) mliquid_assets = liquid_assets mtot_in_excltrans = tot_in_excltrans  mtot_out_nondurab = tot_out_nondurab  mexp_energy_t_reb = exp_energy_t_reb  sample (max) onbenefits children, by(userref year)


gen mshr_e = mexp_energy_t_reb/mtot_out_nondurab


ren mtot_in_excltrans inc
ren mtot_out_nondurab texp
ren mexp_energy_t_reb eexp
ren mshr_e shr_e



foreach v in inc texp  eexp  shr_e {
	gen `v'_p = .
	gen `v'_dec = .
	gen `v'_quint = .
	gen `v'_quart = .
	
	foreach y in 2019 2020 {

		xtile `v'_p_y`y' = `v' if year == `y', nq(100)
		xtile `v'_dec_y`y' = `v' if year == `y' , nq(10)
		xtile `v'_quint_y`y' = `v' if year == `y', nq(5)
		xtile `v'_quart_y`y' = `v' if year == `y', nq(4)

		foreach x in p dec quint quart {
			replace `v'_`x' = `v'_`x'_y`y' if year == `y'
		}

	}
}


**relationship w.r.t income
foreach v in shr_e  eexp {
	reg `v' i.inc_p
	gen `v'_mean = .
	forval p = 1/100 {
		replace `v'_mean = _b[_cons] + _b[`p'.inc_p] if `p'.inc_p==1
	}
	foreach q in 10 25  75 90 {
		qreg `v' i.inc_p, q(`q')
		gen `v'_q`q' = .
		forval p = 1/100 {
			replace `v'_q`q' = _b[_cons] + _b[`p'.inc_p] if `p'.inc_p==1
		}
	}
}

**relationship w.r.t total expenditure
foreach v in shr_e  eexp {
	reg `v' i.texp_p
	gen `v'_meanx = .
	forval p = 1/100 {
		replace `v'_meanx = _b[_cons] + _b[`p'.texp_p] if `p'.texp_p==1
	}
	foreach q in 10 25  75 90 {
		qreg `v' i.texp_p, q(`q')
		gen `v'_q`q'x = .
		forval p = 1/100 {
			replace `v'_q`q'x = _b[_cons] + _b[`p'.texp_p] if `p'.texp_p==1
		}
	}
}


**relationship w.r.t income, just for 2019
foreach v in shr_e  eexp {
	reg `v' i.inc_p if year == 2019
	gen `v'_mean_y19 = .
	forval p = 1/100 {
		replace `v'_mean_y19 = _b[_cons] + _b[`p'.inc_p] if `p'.inc_p==1 
	}
	foreach q in 10 25  75 90 {
		qreg `v' i.inc_p if year == 2019, q(`q')
		gen `v'_q`q'_y19 = .
		forval p = 1/100 {
			replace `v'_q`q'_y19 = _b[_cons] + _b[`p'.inc_p] if `p'.inc_p==1
		}
	}
}




sa "$dataAnalysis/CSexposuremeasures", replace 

u "$dataAnalysis/CSexposuremeasures", clear 

bysort inc_p: gen f=_n
bysort texp_p: gen fx=_n



sort inc_p
#delimit ;
twoway rarea eexp_q10 eexp_q90 inc_p if f==1, color(edkblue%30)
|| rarea eexp_q25 eexp_q75 inc_p if f==1, color(edkblue%40)
|| scatter eexp_mean inc_p if f==1, mcolor(red)
legend(off)
ytitle("Average monthly energy spending")
xtitle("Income percentile")
;
#delimit cr
graph export "$resultsdir/FIG_x_ener_Vs_inc_2019_20.pdf", replace

sort inc_p
#delimit ;
twoway rarea shr_e_q10 shr_e_q90 inc_p if f==1, color(edkblue%30)
|| rarea shr_e_q25 shr_e_q75 inc_p if f==1, color(edkblue%40)
|| scatter shr_e_mean inc_p if f==1, mcolor(red)
legend(off)
ytitle("Energy budget share")
xtitle("Income percentile")
ylabel(0(0.05)0.25)
;
#delimit cr
graph export "$resultsdir/FIG_shr_ener_Vs_inc_2019_20.pdf", replace


sort inc_p
#delimit ;
twoway rarea eexp_q10_y19 eexp_q90_y19 inc_p if f==1, color(edkblue%30)
|| rarea eexp_q25_y19 eexp_q75_y19 inc_p if f==1, color(edkblue%40)
|| scatter eexp_mean_y19 inc_p if f==1, mcolor(red)
legend(off)
ytitle("Average monthly energy spending")
xtitle("Income percentile")
;
#delimit cr
graph export "$resultsdir/FIG_x_ener_Vs_inc_2019.pdf", replace

sort inc_p
#delimit ;
twoway rarea shr_e_q10_y19 shr_e_q90_y19 inc_p if f==1, color(edkblue%30)
|| rarea shr_e_q25_y19 shr_e_q75_y19 inc_p if f==1, color(edkblue%40)
|| scatter shr_e_mean_y19 inc_p if f==1, mcolor(red)
legend(off)
ytitle("Energy budget share")
xtitle("Income percentile")
ylabel(0(0.05)0.25)
;
#delimit cr
graph export "$resultsdir/FIG_shr_ener_Vs_inc_2019.pdf", replace




sort texp_p
#delimit ;
twoway rarea eexp_q10x eexp_q90x texp_p if fx==1, color(edkblue%30)
|| rarea eexp_q25x eexp_q75x texp_p if fx==1, color(edkblue%40)
|| scatter eexp_meanx texp_p if fx==1, mcolor(red)
legend(off)
ytitle("Average monthly energy spending")
xtitle("Total expenditure percentile")
;
#delimit cr
graph export "$resultsdir/FIG_x_ener_Vs_texp.pdf", replace


sort texp_p
#delimit ;
twoway rarea shr_e_q10x shr_e_q90x texp_p if fx==1, color(edkblue%30)
|| rarea shr_e_q25x shr_e_q75x texp_p if fx==1, color(edkblue%40)
|| scatter shr_e_meanx texp_p if fx==1, mcolor(red)
legend(off)
ytitle("Energy budget share")
xtitle("Total expenditure percentile")
ylabel(0(0.05)0.25)
;
#delimit cr
graph export "$resultsdir/FIG_shr_ener_Vs_texp.pdf", replace




**For descriptive numbers in text
log using "$resultsdir/LOG_exposurebyincome.log", replace

reg eexp i.inc_p 
reg eexp i.inc_p if year==2019
global r2_CS_ener_inc = e(r2) 
global N_CS_ener_inc = e(N)

table inc_dec,stat(mean eexp)
table inc_dec,stat(mean eexp_q90)

table inc_dec,stat(mean shr_e)
table inc_dec,stat(mean shr_e_q90)

log close





** compare with LCFS
use "$dataProcess/lcfsdata", clear

keep if year==2019
drop if gor == 12

gen inc_eq =  hhequivinc
gen inc =  hhinc_lcfs

gen eq_factor = hhinc_lcfs/hhequivinc

xtile inc_p = inc , nq(100)
xtile inc_eq_p = inc_eq , nq(100)

global inc 	  "i.inc_p"
global demogs "i.ageb i.numadmal i.numadfem  i.numhhkid i.empstat i.region "
global hhchar "i.nrooms ratect"


log using "$resultsdir/LOG_energyLCFS_bychar.log", replace

foreach x in  ener fuel grocery transport {
	reg exp_`x' $inc 
	gen r2_LCFS_`x'_inc = e(r2) 
	gen N_LCFS_`x'_inc = e(N)
}
foreach x in ener fuel grocery transport {
	reg exp_`x' $inc $demogs 
	gen r2_LCFS_`x'_incdem = e(r2) 
	gen N_LCFS_`x'_incdem = e(N)
}

reg exp_ener $inc $demogs $hhchar
gen r2_LCFS_ener_incdemhh = e(r2) 
gen N_LCFS_ener_incdemhh = e(N)

corr energy_lcfs inc
corr energy_lcfs inc_eq

log close 


gen r2_CS_ener_inc = $r2_CS_ener_inc
gen N_CS_ener_inc = $N_CS_ener_inc

format %9.3f r2*
format %9.0fc N_*

gen r2_lab = "R-squared"
gen N_lab = "N"

listtab r2_lab r2_CS_ener_inc r2_LCFS_ener_inc r2_LCFS_ener_incdem r2_LCFS_ener_incdemhh r2_LCFS_grocery_inc r2_LCFS_grocery_incdem r2_LCFS_fuel_inc r2_LCFS_fuel_incdem  using "$resultsdir/TAB_r2_LCFS_expcats.tex" in 1, replace rstyle(tabular) 
listtab N_lab N_CS_ener_inc N_LCFS_ener_inc N_LCFS_ener_incdem N_LCFS_ener_incdemhh N_LCFS_grocery_inc N_LCFS_grocery_incdem N_LCFS_fuel_inc N_LCFS_fuel_incdem    in 1, appendto("$resultsdir/TAB_r2_LCFS_expcats.tex" ) rstyle(tabular) 




*/

**********



**********
**CORRELATION IN ENERGY SPENDING OVER TIME


use "$dataProcess/CSenergyallspending_step5", clear 


drop if drop_outliers == 1
drop if no_het == 1   //drops NI too
drop if year<=2018


keep userref userref_orig yrmn inc_dec rebates energy_supplier1 energy_supplier2 col reccol wfh cpi_allitems salaryrange weight_fullsam_all weight_fullsam_vari? weight_fullsam_vari?_x EBSS_refund1 EBSS_everrefund1 EBSS_refund2 EBSS_everrefund2 year month onemonth*  exp_energy_t_noreb exp_energy_t_reb sample_* tmin tmax rain cpi_gas cpi_elec cpi_ener pidx_energy_tot_lasp leqnt_noreb leqnt lexp lexp_noreb lprice rebates tmin? tmax? tminlesstmax2 t t2 lnY postmonth* tt_toinclude* sample inc_quint eexp_quint sexp_quint 


gen season = month>=10 | month<=3
replace season = 2 if season == 0

gen year_season = year*100 + season 
replace year_season = (year+1)*100 + season  if month>=10

gen nmonth = 1


collapse (mean) exp_energy_t_reb (sum) nmonth, by(userref sample year_season )


merge m:1 userref using "$dataProcess/heterogeneity_measures.dta"
drop if _m==2
drop _m



ren exp_energy_t_reb exp 
gen lexp = log(exp)

sort userref sample year_season
by userref sample: gen exp_lag1 = exp[_n-1]
by userref sample: gen exp_lag2 = exp[_n-2]
by userref sample: gen lexp_lag1 = lexp[_n-1]
by userref sample: gen lexp_lag2 = lexp[_n-2]
by userref sample: gen nmonth_lag2 = nmonth[_n-2]


reg lexp lexp_lag2 if nmonth==6 & nmonth_lag2==6

reg lexp lexp_lag2 if nmonth==6 & nmonth_lag2==6 & year_season<=202101, robust
gen beta_pre = _b[lexp_lag2]
gen se_pre = _se[lexp_lag2]
gen r2_pre = e(r2)
gen N_pre = e(N)

reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6
gen beta_crisis = _b[lexp_lag2]
gen se_crisis = _se[lexp_lag2]
gen N_crisis = e(N)
pcorr lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6
matrix sp = r(p_corr)
gen r2_crisis = (sp[1,1])^2


**check stability across income quartiles
log using "$resultsdir/TAB_exp_AR_byincquart.log", replace

**all households
reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 

forval q = 1/4 {
	
	** income quartile: `q'
	reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & mtot_in_excltrans_quart == `q'	
	
	gen beta_crisis_inc`q' = _b[lexp_lag2]
	gen se_crisis_inc`q' = _se[lexp_lag2]
	gen N_crisis_inc`q' = e(N)
	pcorr lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & mtot_in_excltrans_quart == `q'	
	matrix sp_inc`q' = r(p_corr)
	gen r2_crisis_inc`q' = (sp_inc`q'[1,1])^2
	
	reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & year_season<=202101 & mtot_in_excltrans_quart == `q'	
	gen beta_pre_inc`q' = _b[lexp_lag2]
	gen se_pre_inc`q' = _se[lexp_lag2]
	gen r2_pre_inc`q' = e(r2)
	gen N_pre_inc`q' = e(N)
		 
	
}
log close




foreach x in pre crisis pre_inc1 pre_inc2 pre_inc3 pre_inc4 crisis_inc1 crisis_inc2 crisis_inc3 crisis_inc4 {
	su se_`x'
	gen temp = r(mean)
	format %9.3f temp
	tostring temp, use force gen(se_`x'_s)
	replace se_`x'_s = "{\small ("+se_`x'_s+")}"
	drop temp
}



gen beta_lab = "Autocorrelation coefficient, $\hat{\rho}_1$"
gen r2_lab = "(Partial) r-squared"
gen blank = ""
gen N_lab = "N"

format %9.3f beta_pre beta_crisis r2_pre r2_crisis
format %9.0fc N_pre N_crisis

listtab beta_lab beta_pre beta_crisis in 1 using "$resultsdir/TAB_exp_AR.tex", replace rstyle(tabular)
listtab blank 	se_pre_s se_crisis_s in 1 , appendto("$resultsdir/TAB_exp_AR.tex") rstyle(tabular)
listtab r2_lab 	r2_pre r2_crisis in 1 , appendto("$resultsdir/TAB_exp_AR.tex") rstyle(tabular) footlines("\midrule")
listtab N_lab 	N_pre N_crisis in 1 , appendto("$resultsdir/TAB_exp_AR.tex") rstyle(tabular) 

foreach x in pre crisis {
	listtab beta_lab beta_`x'_inc1 beta_`x'_inc2 beta_`x'_inc3 beta_`x'_inc4 in 1 using "$resultsdir/TAB_exp_AR_`x'byinc.tex", replace rstyle(tabular)
	listtab blank 	se_`x'_inc1_s se_`x'_inc2_s se_`x'_inc3_s se_`x'_inc4_s in 1 , appendto("$resultsdir/TAB_exp_AR_`x'byinc.tex") rstyle(tabular)
	listtab r2_lab 	r2_`x'_inc1 r2_`x'_inc2 r2_`x'_inc3 r2_`x'_inc4 in 1 , appendto("$resultsdir/TAB_exp_AR_`x'byinc.tex") rstyle(tabular) footlines("\midrule")
	listtab N_lab 	N_`x'_inc1 N_`x'_inc2 N_`x'_inc3 N_`x'_inc4 in 1 , appendto("$resultsdir/TAB_exp_AR_`x'byinc.tex") rstyle(tabular) 
}


**********

