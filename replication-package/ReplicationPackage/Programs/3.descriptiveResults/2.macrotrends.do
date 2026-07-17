clear



cap estimates drop *



**********
** DESEASONALISE  CLEARSCORE DATA


use "$dataProcess/CSenergyallspending_step5", clear 

drop if drop_outliers == 1
drop if no_het == 1 
drop if year<=2018


keep userref userref_orig yrmn  year month onemonth* cpi_allitems inc_dec onemonth* salaryrange weight_fullsam_all weight_fullsam_vari? weight_fullsam_vari?_x exp_energy_t_noreb exp_energy_t_reb sample_* tmin tmax rain  cpi_gas cpi_elec cpi_ener pidx_energy_tot_lasp leqnt_noreb leqnt lexp lexp_noreb lprice rebates tmin? tmax? tminlesstmax2 t t2 lnY postmonth* tt_toinclude* sample inc_quint eexp_quint sexp_quint 

global tempcontrols "tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5  rain tminlesstmax2 humid"

gen lexp_nom = log(exp(lexp)*cpi_allitems)


**Step 1: residualise using month dummies from 2019 and 2020
foreach v in lexp lexp_nom leqnt  {
	gen `v'_ds = `v'
	gen `v'_dsw = `v'
	foreach s in 1 2 3  {
		reg `v' i.month if sample==`s' & year<2021 
		forval m = 2/12 {
			replace `v'_ds = `v' - _b[`m'.month]  if `m'.month == 1 & sample==`s'
		}

		xtreg `v' i.month  if sample==`s' & year<2021, i(userref) fe robust
		forval m = 2/12 {
			replace `v'_dsw = `v' - _b[`m'.month]  if `m'.month == 1 & sample==`s'
		}

	}
}

gen 	quarter = 1 if month>=1 & month<=3
replace quarter = 2 if month>=4 & month<=6
replace quarter = 3 if month>=7 & month<=9
replace quarter = 4 if month>=10 & month<=12
gen yq = year*100 + quarter
gen ym = yrmn

egen t_ym = group(ym)
egen t_yq = group(yq)

gen exp_ds = exp(lexp_ds)
gen exp_dsw = exp(lexp_dsw)
gen exp_nom_ds = exp(lexp_nom_ds)
gen exp_nom_dsw = exp(lexp_nom_dsw)
gen eqnt_ds = exp(leqnt_ds)
gen eqnt_dsw = exp(leqnt_dsw)

gen q_ds = exp(lexp_ds - lprice)
gen q_dsw = exp(lexp_dsw - lprice)

gen sample_vDD = sample==2
gen sample_DD = sample==2 | sample==3


foreach v in exp exp_nom eqnt q lexp lexp_nom leqnt {
	
	foreach d in ds dsw {
	
		foreach s in PP vDD DD {
			gen `v'_`d'_ym_s`s' = .
			gen `v'_`d'_yq_s`s' = .

			if "`d'" == "ds"  reg `v'_`d' i.t_ym  if sample_`s'==1
			if "`d'" == "dsw" xtreg `v'_`d' i.t_ym  if sample_`s'==1, i(userref) fe robust
			forval t = 2/60 {
				replace `v'_`d'_ym_s`s' = _b[_cons] + _b[`t'.t_ym] if `t'.t_ym == 1 &  sample_`s'==1
			}

			if "`d'" == "ds"  reg `v'_`d' i.t_yq onemonth_post onemonth_pre if sample_`s'==1
			if "`d'" == "dsw" xtreg `v'_`d' i.t_yq onemonth_post onemonth_pre if sample_`s'==1, i(userref) fe robust
			forval t = 2/20 {
				replace `v'_`d'_yq_s`s' = _b[_cons] + _b[`t'.t_yq] if `t'.t_yq== 1 &  sample_`s'==1
			}

		}
	}
}




collapse (mean) exp_ds_ym_sPP- leqnt_dsw_yq_sDD, by(year quarter yq year month ym)


global vars "exp_ds_ym exp_ds_yq exp_dsw_ym exp_dsw_yq exp_nom_ds_ym exp_nom_ds_yq exp_nom_dsw_ym exp_nom_dsw_yq eqnt_ds_ym eqnt_ds_yq eqnt_dsw_ym eqnt_dsw_yq q_ds_ym q_ds_yq q_dsw_ym q_dsw_yq"
global lvars "lexp_ds_ym lexp_ds_yq lexp_dsw_ym lexp_dsw_yq lexp_nom_ds_ym lexp_nom_ds_yq lexp_nom_dsw_ym lexp_nom_dsw_yq leqnt_ds_ym leqnt_ds_yq leqnt_dsw_ym leqnt_dsw_yq"

global wgt_pp = 0.15
foreach v in $vars {
	gen `v'_tot = $wgt_pp*`v'_sPP + (1-$wgt_pp)*`v'_svDD
	gen `v'_totF = $wgt_pp*`v'_sPP + (1-$wgt_pp)*`v'_sDD
}
foreach v in $lvars {
	gen `v'_tot = $wgt_pp*exp(`v'_sPP) + (1-$wgt_pp)*exp(`v'_svDD)
	gen `v'_totF = $wgt_pp*exp(`v'_sPP) + (1-$wgt_pp)*exp(`v'_sDD)
}



sa "$dataAnalysis/CS_aggregates", replace

**********


**********
** PLOT AGAINST NATIONAL ACCOUNTS


**CPI prices
use "$dataProcess/cpi_stata", clear 

gen quarter = 1 if inrange(month,1,3)
replace quarter = 2 if inrange(month,4,6)
replace quarter = 3 if inrange(month,7,9)
replace quarter = 4 if inrange(month,10,12)

collapse (mean) cpi cpi_energy, by(year quarter)

tempfile quarterlycpi
save `quarterlycpi'



u "$dataAnalysis/CS_aggregates", clear

merge m:1 year quarter using  `quarterlycpi'
keep if _merge==3|_merge==1
drop _merge


merge m:1 year quarter using  "$dataProcess/macro_aggregates"
keep if _merge==3|_merge==1
drop _merge


**convert  to real terms in the same way
foreach v of var ener_exp_nsa ener_exp_sa gas_exp_nsa gas_exp_sa elec_exp_nsa elec_exp_sa lexp_nom_dsw_yq_tot {
	gen `v'_rl = `v'/cpi
}



#delimit ;
global var_rb "
exp_ds_ym_tot exp_ds_yq_tot exp_dsw_ym_tot exp_dsw_yq_tot 
exp_nom_ds_ym_tot exp_nom_ds_yq_tot exp_nom_dsw_ym_tot exp_nom_dsw_yq_tot 
exp_nom_ds_ym_totF exp_nom_ds_yq_totF exp_nom_dsw_ym_totF exp_nom_dsw_yq_totF 
eqnt_ds_ym_tot eqnt_ds_yq_tot eqnt_dsw_ym_tot eqnt_dsw_yq_tot 
q_ds_ym_tot q_ds_yq_tot q_dsw_ym_tot q_dsw_yq_tot 
lexp_ds_ym_tot lexp_ds_yq_tot lexp_dsw_ym_tot lexp_dsw_yq_tot 
lexp_ds_ym_totF lexp_ds_yq_totF lexp_dsw_ym_totF lexp_dsw_yq_totF
lexp_nom_ds_ym_tot lexp_nom_ds_yq_tot lexp_nom_dsw_ym_tot lexp_nom_dsw_yq_tot  lexp_nom_dsw_yq_tot_rl
lexp_nom_ds_ym_totF lexp_nom_ds_yq_totF lexp_nom_dsw_ym_totF lexp_nom_dsw_yq_totF
leqnt_ds_ym_tot leqnt_ds_yq_tot leqnt_dsw_ym_tot leqnt_dsw_yq_tot  
ener_exp_sa ener_vol_sa ener_exp_sa_rl {
"
;
#delimit cr




foreach v in $var_rb {
	su `v' if year == 2021 
	gen `v'_rb = `v'/r(mean)
}


egen tm = group(year month)
egen tq = group(year quarter)
bysort tq: gen f=_n

#delimit ;
scatter ener_exp_sa_rl_rb lexp_nom_dsw_yq_tot_rl_rb   tq , 
c(l l) mcolor(red  eltblue) lcolor(red  eltblue) msymbol(c d)
legend(label(2 "ExactOne") label(1 "National Accounts") size(med) rows(1) pos(6)) 
ytitle("Energy spending (indexed to 2021)")
xtitle("")
xlabel(1 "2019" 5 "2020" 9 "2021" 13 "2022" 17 "2023" 21 "2024")
;
#delimit cr
graph export "$resultsdir/FIG_NAvsCS_spend.pdf", replace




**********



**********
** STABLE GAS VS ELECTRICITY SHARE OVER TIME

clear
import excel using "$dataRaw/downloaded/energyquantities", sheet(forstata) first

gen quarter = substr(A,9,1)
gen year = substr(A,10,9)
*drop final provisional estimate
drop if _n==_N
destring year, replace
destring quarter, replace
rename Domestic BEIS_domestic_sa
rename Domestic_nas BEIS_domestic_nsa
rename Domestic_gas_sa BEIS_gas_sa
rename Domestic_elec_sa BEIS_elec_sa

gen shr = BEIS_elec_sa/( BEIS_gas_sa +  BEIS_elec_sa)

keep if year >=2019

egen tq = group(year quarter)
bysort tq: gen f=_n



#delimit ;
line shr   tq  , 
ytitle("Share of total energy from electricity")
xtitle("")
xlabel(1 "2019" 5 "2020" 9 "2021" 13 "2022" 17 "2023" 21 "2024")
ylabel(0(0.1)0.4) 
;
#delimit cr
graph export "$resultsdir/FIG_shr_elec.pdf", replace

*/

**********
** ALTERNATIVE PRICE INDEXES

use "$dataProcess/unitcosts_gas_elec_yrmn", clear 

keep if year>=2019
bys ofgem_region (yrmn) : gen time = _n
twoway (line pidx_energy_tot_lasp_gb time ) (line pidx_energy_tot_altlasp_chain_gb time) (line pidx_energy_tot_fisher_gb time, lpattern(dash)) if ofgem_region=="London" & year>=2019, legend(rows(4) position(6)  order(1 "Fixed weight Laspeyres index (using 2019 gas share)" 2 "Fisher index (using quantities)" 3 "Monthly chained Laspeyres index (using quantities)")) xlabel(1 "2019" 13 "2020" 26 "2021" 39 "2022" 51 "2023" 63 "2024") xtitle("") ytitle("Price Index (Jan 2019 = 1)") 
graph export "$resultsdir/FIG_altpriceindexes.pdf", replace

*/




**********









