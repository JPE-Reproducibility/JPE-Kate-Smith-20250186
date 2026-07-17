

cap estimates drop *



**********
** ESTIMATE TIME SERIES  & PRICE ELASTICITIES



**summary stats on regional price variation 
u "$dataProcess/unitcosts_gas_elec_yrmn", clear

tab ofgem_region yrmn if yrmn>=202203 & yrmn<=202204,su(pidx_energy_tot_lasp) mean

gen pidx_mar22 = pidx_energy_tot_lasp if yrmn==202203
bysort ofgem_region: egen temp = max(pidx_mar22)
replace pidx_mar22 = temp
drop temp

gen pidx_apr22 = pidx_energy_tot_lasp if yrmn==202204
bysort ofgem_region: egen temp = max(pidx_apr22)
replace pidx_apr22 = temp
drop temp

gen inc_apr22= pidx_apr22/pidx_mar22

**note: relative prices across the regions are the same in March 2022 because they are indexed to Jan 2019, and there were
**		no changes in the relative price caps over this period

log using "$resultsdir/LOG_pvar_byregion.log" , replace

su inc_apr22

table ofgem_region if yrmn==202204, stat(mean pidx_mar22  pidx_apr22 inc_apr22)

log close

*/




**Heterogeneous temp controls
global tempcontrols "tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2"
global tempcontrols_het ""
foreach v in $tempcontrols {
	global tempcontrols_het "$tempcontrols_het i.sample#c.`v' "
}
global tempcontrols_constrained "tmin tmin2  tmax tmax2  rain humid tminlesstmax2"
global tempcontrols_het_constrained ""
foreach v in $tempcontrols_constrained {
	global tempcontrols_het_constrained "$tempcontrols_het_constrained i.sample#c.`v' "
}

global anticip "onemonth_pre onemonth_post"
global anticip_het ""
foreach v in $anticip {
	global anticip_het "$anticip_het i.sample#c.`v' "
}
global montheff "mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm10 mm11 mm12"
global montheff_het ""
foreach v in $montheff {
	global montheff_het "$montheff_het i.sample#c.`v' "
}

global wgt_pp = $pp_shr




u "$dataProcess/CSenergyallspending_step6", clear


foreach v in lexp_ds  {
	xtreg `v' c.sample1#i.yrmn c.sample2#i.yrmn  if year>=2021 & sample<=2 & NI!=1, i(userref_sample) fe robust

	gen m_`v' = 0
	gen lb_`v' = 0
	gen ub_`v' = 0
	forval t = 25/60 {
		su yrmn if tt == `t'
		local yrmn = r(mean)
		lincom (c.sample1#`yrmn'.yrmn - c.sample1#202106.yrmn)*$wgt_pp + (c.sample2#`yrmn'.yrmn - c.sample2#202106.yrmn)*(1-$wgt_pp)
		replace m_`v' = r(estimate) if tt == `t'
		replace lb_`v' = r(estimate) - 1.96*r(se) if tt == `t'
		replace ub_`v' = r(estimate) + 1.96*r(se) if tt == `t'
	}
}



	
bysort yrmn: gen f=_n


global lines_postmonth "33.5 39.5 45.5 51.5 "
global labels_postmonth `"  33.5	 "8% cap rise"  39.5 "45% cap rise"  45.5 "22% EPG rise"  46.5 "+transfers"  51.5 "transfers end"  "'

labmask tt, val(yrmn)




#delimit ;
scatter m_lexp_ds tt if f==1 & yrmn>=202106 & yrmn<=202306, c(l) 
xlabel(31 "Jul 2021" 34 "Oct 2021" 37 "Jan 2022" 40 "Apr 2022" 43 "Jul 2022" 46 "Oct 2022" 49 "Jan 2023" 52 "Apr 2023" 54 " " , nogrid) 
legend(off) mcolor(red) lcolor(red)
|| rcap ub_lexp_ds lb_lexp_ds tt if f==1 & yrmn>=202106 & yrmn<=202306, lcolor(gs8) 
|| scatter m_lexp_ds tt if f==1 & yrmn>=202106 & yrmn<=202306, msymbol(none) xaxis(2)
legend(pos(6))
xline($lines_postmonth) 
xla(${labels_postmonth}, axis(2) angle(45) tlength(0)) xtitle("", axis(2)) xscale(noline axis(2)) 
xtitle("") ytitle("Log spending (deseasonalised)")
;
#delimit cr
graph export "$resultsdir/FIG_lx_ds.pdf", replace


gen NI_nooil = NI ==1 & everheatingoiluser==0
gen NI_oil = NI ==1 & everheatingoiluser==1
gen NI_elec = NI ==1 & energy_supplier1 == 13
gen GB = NI!=1

xtreg lexp i.yrmn i.yrmn#c.NI_nooil if year>=2021  & yrmn<=202209 & (GB==1 | NI_nooil==1), i(userref_sample) fe robust
gen m_lexp_GB = 0
gen lb_lexp_GB = 0
gen ub_lexp_GB = 0
gen m_lexp_NI = 0
gen lb_lexp_NI = 0
gen ub_lexp_NI = 0
gen m_lexp_DID = 0
gen lb_lexp_DID = 0
gen ub_lexp_DID = 0
forval t = 25/45 {
	su yrmn if tt == `t'
	local yrmn = r(mean)
	lincom (`yrmn'.yrmn - 202106.yrmn)
	replace m_lexp_GB = r(estimate) if tt == `t'
	replace lb_lexp_GB = r(estimate) - 1.96*r(se) if tt == `t'
	replace ub_lexp_GB = r(estimate) + 1.96*r(se) if tt == `t'

	lincom (`yrmn'.yrmn - 202106.yrmn) + (`yrmn'.yrmn#c.NI_nooil - 202106.yrmn#c.NI_nooil)
	replace m_lexp_NI = r(estimate) if tt == `t'
	replace lb_lexp_NI= r(estimate) - 1.96*r(se) if tt == `t'
	replace ub_lexp_NI = r(estimate) + 1.96*r(se) if tt == `t'

	lincom -(`yrmn'.yrmn#c.NI_nooil - 202106.yrmn#c.NI_nooil)
	replace m_lexp_DID = r(estimate) if tt == `t'
	replace lb_lexp_DID= r(estimate) - 1.96*r(se) if tt == `t'
	replace ub_lexp_DID = r(estimate) + 1.96*r(se) if tt == `t'
}



#delimit ;
scatter m_lexp_GB tt if f==1 & year>=2021  & yrmn<=202209 , c(l) xlabel(25(1)45, val angle(90) nogrid)  mcolor(red) lcolor(red) legend(label(1 "UK excluding Northern Ireland"))
|| rcap lb_lexp_GB ub_lexp_GB tt if f==1 & year>=2021  & yrmn<=202209, lcolor(gs8) 
|| scatter m_lexp_NI  tt if f==1 & year>=2021  & yrmn<=202209 , c(l) xlabel(25(1)45, val angle(90) nogrid)  mcolor(edkblue) lcolor(edkblue) legend(label(3 "Northern Ireland"))
|| rcap lb_lexp_NI ub_lexp_NI tt if f==1 & year>=2021  & yrmn<=202209, lcolor(gs8) 
legend(pos(6) order(1 3)) xline(40)
xtitle("") ytitle("Change in log spending relative to June 2021")
;
#delimit cr
graph export "$resultsdir/FIG_lx_GBvsNI.pdf", replace




#delimit ;
scatter m_lexp_DID tt if f==1 & year>=2021  & yrmn<=202209 , c(l) xlabel(25(1)45, val angle(90) nogrid)  mcolor(red) lcolor(red) 
|| rcap lb_lexp_DID ub_lexp_DID tt if f==1 & year>=2021  & yrmn<=202209, lcolor(gs8) 
legend(off) xline(40)
xtitle("") ytitle("Difference in log spending" "in the rUK and NI")
;
#delimit cr
graph export "$resultsdir/FIG_lx_DiD.pdf", replace



*/





u "$dataProcess/CSenergyallspending_step6", clear


**create cap periods
gen cap1 = yrmn>=202106 & yrmn<=202109
gen cap2 = yrmn>=202110 & yrmn<=202203
gen cap3 = yrmn>=202204 & yrmn<=202209
gen cap4 = yrmn>=202210 & yrmn<=202303
gen cap5 = yrmn>=202304 & yrmn<=202305

gen cap_per = 1 if yrmn>=202106 & yrmn<=202109
replace cap_per = 2 if yrmn>=202110 & yrmn<=202203
replace cap_per = 3 if yrmn>=202204 & yrmn<=202209
replace cap_per = 4 if yrmn>=202210 & yrmn<=202303
replace cap_per = 5 if yrmn>=202304 & yrmn<=202305
replace cap_per = 0 if cap_per == .

gen p = pidx_energy_tot_lasp
gen lp = log(p)

gen NI_nooil = NI ==1 & everheatingoiluser==0
gen NI_oil = NI ==1 & everheatingoiluser==1
gen NI_elec = NI ==1 & energy_supplier1 == 13
gen GB = NI!=1

merge m:1 yrmn using "$dataProcess/NI_priceseries"
drop _m


gen pIdx_NI_real = (pIdx_NI/100)/cpi_allitems
replace lp = log(pIdx_NI_real) if NI == 1


**Log price changes
su lp if cap_per == 1  & NI !=1
global lp_base = r(mean)
su lp if cap_per == 2  & NI !=1
global lp_postOct21 = r(mean)
su lp if cap_per == 3  & NI !=1
global lp_postApr22 = r(mean)


gen lp_PP = lp*(sample == 1)
gen lp_DD = lp*(sample == 2 | sample == 3)


gen lp_het = log(pidx_energy_tot_lasp_het)
gen lp_het_PP = lp_het*(sample == 1)
gen lp_het_DD = lp_het*(sample == 2 | sample == 3)

global wgt_PP = $pp_shr
global wgt_SC = 0.07			//taken from the LOG_LCFS_ppshr.log 
global wgt_PPifSC = 0.14		//taken from the LOG_LCFS_ppshr.log 

gen lq = leqnt
gen lq_ds = leqnt_ds
gen lx = lexp_nosc
gen lx_ds = lexp_nosc_ds


replace lx = lexp if NI == 1 //don't know the standing charge for NI


gen cap_prepost = yrmn<=202110
gen PP = sample == 1
gen vDD = sample == 2

gen lp_DD_cap2 = lp_DD*cap_prepost
gen lp_DD_cap3 = lp_DD*(1-cap_prepost)
gen lp_PP_cap2 = lp_PP*cap_prepost
gen lp_PP_cap3 = lp_PP*(1-cap_prepost)

gen lp_DD_NI = lp_DD*NI
gen lp_PP_NI = lp_PP*NI


gen cap1_PP = cap1*(sample == 1)
gen cap2_PP = cap2*(sample == 1)
gen cap3_PP = cap3*(sample == 1)
gen cap1_DD = cap1*(sample == 2 | sample==3)
gen cap2_DD = cap2*(sample == 2 | sample==3)
gen cap3_DD = cap3*(sample == 2 | sample==3)

gen lp_vDD = lp*(sample == 2)
gen lp_SC = lp*(sample == 3 & sc_monthly==1)



** Calculate elasticity program
cap prog drop calc_avg_elas
program define calc_avg_elas
    syntax ,  LPBASE(numlist) LPPOST(numlist)  OUTELAS(string) OUTSE(string)  DEPVAR(string) WGTPP(numlist) OUTVAR(string) [SCINCL(string) WGTSC(numlist)]

	if "`scincl'" == "" | "`scincl'" == "no" {
		if "`outvar'" == "elas" {
			if "`depvar'" == "q" {
				#delimit ;
				nlcom 
				((1-`wgtpp')*((exp(_b[lp_DD]*`lppost') - exp(_b[lp_DD]*`lpbase'))/exp(_b[lp_DD]*`lpbase'))
				+`wgtpp'*((exp(_b[lp_PP]*`lppost') - exp(_b[lp_PP]*`lpbase'))/exp(_b[lp_PP]*`lpbase'))
				)/
				((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
				;
				#delimit cr
			}
			if "`depvar'" == "x" {
				#delimit ;
				nlcom 
				((1-`wgtpp')*((exp((_b[lp_DD]-1)*`lppost') - exp((_b[lp_DD]-1)*`lpbase'))/exp((_b[lp_DD]-1)*`lpbase'))
				+`wgtpp'*((exp((_b[lp_PP]-1)*`lppost') - exp((_b[lp_PP]-1)*`lpbase'))/exp((_b[lp_PP]-1)*`lpbase'))
				)/
				((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
				;
				#delimit cr
			}
		}
		if "`outvar'" == "qchg" {
			if "`depvar'" == "q" {
				#delimit ;
				nlcom 
				((1-`wgtpp')*((exp(_b[lp_DD]*`lppost') - exp(_b[lp_DD]*`lpbase'))/exp(_b[lp_DD]*`lpbase'))
				+`wgtpp'*((exp(_b[lp_PP]*`lppost') - exp(_b[lp_PP]*`lpbase'))/exp(_b[lp_PP]*`lpbase'))
				)
				;
				#delimit cr
			}
			if "`depvar'" == "x" {
				#delimit ;
				nlcom 
				((1-`wgtpp')*((exp((_b[lp_DD]-1)*`lppost') - exp((_b[lp_DD]-1)*`lpbase'))/exp((_b[lp_DD]-1)*`lpbase'))
				+`wgtpp'*((exp((_b[lp_PP]-1)*`lppost') - exp((_b[lp_PP]-1)*`lpbase'))/exp((_b[lp_PP]-1)*`lpbase'))
				)
				;
				#delimit cr
			}
		}
	}
	if "`scincl'" == "yes" {
		if "`outvar'" == "elas" {
			if "`depvar'" == "q" {
				#delimit ;
				nlcom 
				((1-`wgtpp'-`wgtsc')*((exp(_b[lp_vDD]*`lppost') - exp(_b[lp_vDD]*`lpbase'))/exp(_b[lp_vDD]*`lpbase'))
				+`wgtpp'*((exp(_b[lp_PP]*`lppost') - exp(_b[lp_PP]*`lpbase'))/exp(_b[lp_PP]*`lpbase'))
				+`wgtsc'*((exp(_b[lp_SC]*`lppost') - exp(_b[lp_SC]*`lpbase'))/exp(_b[lp_SC]*`lpbase'))
				)/
				((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
				;
				#delimit cr
			}
			if "`depvar'" == "x" {
				#delimit ;
				nlcom 
				((1-`wgtpp'-`wgtsc')*((exp((_b[lp_vDD]-1)*`lppost') - exp((_b[lp_vDD]-1)*`lpbase'))/exp((_b[lp_vDD]-1)*`lpbase'))
				+`wgtpp'*((exp((_b[lp_PP]-1)*`lppost') - exp((_b[lp_PP]-1)*`lpbase'))/exp((_b[lp_PP]-1)*`lpbase'))
				+`wgtsc'*((exp((_b[lp_SC]-1)*`lppost') - exp((_b[lp_SC]-1)*`lpbase'))/exp((_b[lp_SC]-1)*`lpbase'))
				)/
				((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
				;
				#delimit cr
			}
		}
		if "`outvar'" == "qchg" {
			if "`depvar'" == "q" {
				#delimit ;
				nlcom 
				((1-`wgtpp'-`wgtsc')*((exp(_b[lp_vDD]*`lppost') - exp(_b[lp_vDD]*`lpbase'))/exp(_b[lp_vDD]*`lpbase'))
				+`wgtpp'*((exp(_b[lp_PP]*`lppost') - exp(_b[lp_PP]*`lpbase'))/exp(_b[lp_PP]*`lpbase'))
				+`wgtsc'*((exp(_b[lp_SC]*`lppost') - exp(_b[lp_SC]*`lpbase'))/exp(_b[lp_SC]*`lpbase'))
				)
				;
				#delimit cr
			}
			if "`depvar'" == "x" {
				#delimit ;
				nlcom 
				((1-`wgtpp'-`wgtsc')*((exp((_b[lp_vDD]-1)*`lppost') - exp((_b[lp_vDD]-1)*`lpbase'))/exp((_b[lp_vDD]-1)*`lpbase'))
				+`wgtpp'*((exp((_b[lp_PP]-1)*`lppost') - exp((_b[lp_PP]-1)*`lpbase'))/exp((_b[lp_PP]-1)*`lpbase'))
				+`wgtsc'*((exp((_b[lp_SC]-1)*`lppost') - exp((_b[lp_SC]-1)*`lpbase'))/exp((_b[lp_SC]-1)*`lpbase'))
				)
				;
				#delimit cr
			}
		}
	}


	matrix b = r(b)
	matrix V = r(V)
	gen `outelas' = b[1,1]
	gen `outse' = sqrt(V[1,1])

end

cap prog drop calc_avg_elas_het
program define calc_avg_elas_het
    syntax ,  LPBASE(numlist) LPPOST(numlist)  OUTELAS(string) OUTSE(string)  DEPVAR(string) CAPPER(numlist) OUTVAR(string)

	if "`outvar'" == "elas" {
		if "`depvar'" == "q" {
			#delimit ;
			nlcom 
			((1-$wgt_PP)*((exp(_b[lp_DD_cap`capper']*`lppost') - exp(_b[lp_DD_cap`capper']*`lpbase'))/exp(_b[lp_DD_cap`capper']*`lpbase'))
			+$wgt_PP*((exp(_b[lp_PP_cap`capper']*`lppost') - exp(_b[lp_PP_cap`capper']*`lpbase'))/exp(_b[lp_PP_cap`capper']*`lpbase'))
			)/
			((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
			;
			#delimit cr
		}
		if "`depvar'" == "x" {
			#delimit ;
			nlcom 
			((1-$wgt_PP)*((exp((_b[lp_DD_cap`capper']-1)*`lppost') - exp((_b[lp_DD_cap`capper']-1)*`lpbase'))/exp((_b[lp_DD_cap`capper']-1)*`lpbase'))
			+$wgt_PP*((exp((_b[lp_PP_cap`capper']-1)*`lppost') - exp((_b[lp_PP_cap`capper']-1)*`lpbase'))/exp((_b[lp_PP_cap`capper']-1)*`lpbase'))
			)/
			((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
			;
			#delimit cr
		}
	}
	if "`outvar'" == "qchg" {
		if "`depvar'" == "q" {
			#delimit ;
			nlcom 
			((1-$wgt_PP)*((exp(_b[lp_DD_cap`capper']*`lppost') - exp(_b[lp_DD_cap`capper']*`lpbase'))/exp(_b[lp_DD_cap`capper']*`lpbase'))
			+$wgt_PP*((exp(_b[lp_PP_cap`capper']*`lppost') - exp(_b[lp_PP_cap`capper']*`lpbase'))/exp(_b[lp_PP_cap`capper']*`lpbase'))
			)
			;
			#delimit cr
		}
		if "`depvar'" == "x" {
			#delimit ;
			nlcom 
			((1-$wgt_PP)*((exp((_b[lp_DD_cap`capper']-1)*`lppost') - exp((_b[lp_DD_cap`capper']-1)*`lpbase'))/exp((_b[lp_DD_cap`capper']-1)*`lpbase'))
			+$wgt_PP*((exp((_b[lp_PP_cap`capper']-1)*`lppost') - exp((_b[lp_PP_cap`capper']-1)*`lpbase'))/exp((_b[lp_PP_cap`capper']-1)*`lpbase'))
			)
			;
			#delimit cr
		}
	}
	

	matrix b = r(b)
	matrix V = r(V)
	gen `outelas' = b[1,1]
	gen `outse' = sqrt(V[1,1])

end




foreach v in q x {

	disp as error "MAIN, spec 1"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec1 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec1) outse(e_`v'_apr22_spec1_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec1) outse(qchg_`v'_apr22_spec1_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec1) outse(e_`v'_oct21_spec1_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec1) outse(qchg_`v'_oct21_spec1_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)

	disp as error "MAIN + weather controls (constrained), spec 2"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het_constrained  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec2 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec2) outse(e_`v'_apr22_spec2_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec2) outse(qchg_`v'_apr22_spec2_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec2) outse(e_`v'_oct21_spec2_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec2) outse(qchg_`v'_oct21_spec2_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	
	
	disp as error "MAIN + weather controls, no DS, monthly dummies, spec 3"
	xtreg l`v'   lp_DD lp_PP $anticip_het $tempcontrols_het $montheff_het if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec3 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec3) outse(e_`v'_apr22_spec3_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec3) outse(qchg_`v'_apr22_spec3_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec3) outse(e_`v'_oct21_spec3_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec3) outse(qchg_`v'_oct21_spec3_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)

 
	disp as error "MAIN + reweighting by age and region, no DS, monthly dummies, spec 4"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het  if tt_toinclude==1 & sample<=2   & NI!=1 [aw=weight_fullsam_vari], i(userref_sample) fe robust
	gen N_`v'_spec4 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec4) outse(e_`v'_apr22_spec4_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec4) outse(qchg_`v'_apr22_spec4_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec4) outse(e_`v'_oct21_spec4_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec4) outse(qchg_`v'_oct21_spec4_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)	


	disp as error "MAIN + conditioning on new supplier, spec 5"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het  if tt_toinclude==1 & (sample==1 | ( sample == 2 & max_new_supplier==1))  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec5 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec5) outse(e_`v'_apr22_spec5_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec5) outse(qchg_`v'_apr22_spec5_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec5) outse(e_`v'_oct21_spec5_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec5) outse(qchg_`v'_oct21_spec5_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)


	disp as error "MAIN +  smoothed DD people with regularly reviewed DD, and conditioning on new supplier, spec 6"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het  if tt_toinclude==1 & (sample==1 |  ( sample == 2) | ( sample == 3 & max_new_supplier==1 & dd_review !=3))  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec6 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec6) outse(e_`v'_apr22_spec6_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec6) outse(qchg_`v'_apr22_spec6_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec6) outse(e_`v'_oct21_spec6_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec6) outse(qchg_`v'_oct21_spec6_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	
	
	disp as error "MAIN + heterogeneous price indices, spec 7"
	gen temp1 = lp_DD
	gen temp2 = lp_PP
	replace lp_DD = lp_het_DD
	replace lp_PP = lp_het_PP

	xtreg l`v'_ds   lp_DD lp_PP $anticip_het $tempcontrols_het  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec7 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec7) outse(e_`v'_apr22_spec7_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec7) outse(qchg_`v'_apr22_spec7_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec7) outse(e_`v'_oct21_spec7_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec7) outse(qchg_`v'_oct21_spec7_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)

	replace lp_DD = temp1
	replace lp_PP = temp2
	drop temp*

	
	disp as error "MAIN + using only the april cap change for the price variation (and more constrained weather controls), spec 8"
	xtreg l`v'_ds   lp_DD_cap2 lp_DD_cap3  lp_PP_cap2 lp_PP_cap3 $anticip_het $tempcontrols_het_constrained if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec8 = e(N)
	estimates store spec8
	calc_avg_elas_het, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec8) outse(e_`v'_apr22_spec8_se) depvar("`v'") capper(3)  outvar(elas)
	calc_avg_elas_het, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec8) outse(qchg_`v'_apr22_spec8_se) depvar("`v'") capper(3)  outvar(qchg)
	estimates restore spec8
	calc_avg_elas_het, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec8) outse(e_`v'_oct21_spec8_se) depvar("`v'") capper(2) outvar(elas)
	calc_avg_elas_het, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec8) outse(qchg_`v'_oct21_spec8_se) depvar("`v'") capper(2) outvar(qchg)
	
	

	disp as error "MAIN + including northern ireland and add full year-month dummies, spec 9"
	xtreg l`v'    lp_DD  lp_PP   c.onemonth_pre#c.GB#i.sample c.onemonth_post#c.GB#i.sample $tempcontrols i.yrmn#i.sample if tt_toinclude==1 & sample<=2 & (GB==1 | NI_nooil == 1) , i(userref_sample) fe robust
	gen N_`v'_spec9 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec9) outse(e_`v'_apr22_spec9_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec9) outse(qchg_`v'_apr22_spec9_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec9) outse(e_`v'_oct21_spec9_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec9) outse(qchg_`v'_oct21_spec9_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)

	
	disp as error "MAIN + no weather controls, spec 10"
	xtreg l`v'_ds   lp_DD lp_PP $anticip_het  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
	gen N_`v'_spec10 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec10) outse(e_`v'_apr22_spec10_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec10) outse(qchg_`v'_apr22_spec10_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec10) outse(e_`v'_oct21_spec10_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec10) outse(qchg_`v'_oct21_spec10_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	
	
	disp as error "MAIN + instrumenting, spec 11"
	xtivreg l`v'_ds $anticip_het $tempcontrols_het (lp_DD lp_PP   = cap?_PP cap?_DD)  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe vce(robust)  first 	
	gen N_`v'_spec11 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec11) outse(e_`v'_apr22_spec11_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec11) outse(qchg_`v'_apr22_spec11_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec11) outse(e_`v'_oct21_spec11_se) depvar("`v'") wgtpp($wgt_PP) outvar(elas)
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec11) outse(qchg_`v'_oct21_spec11_se) depvar("`v'") wgtpp($wgt_PP) outvar(qchg)
	

	disp as error "MAIN + sc credit people, appropriately weighted, spec 12"
	xtreg l`v'_ds   lp_vDD lp_PP lp_SC $anticip_het $tempcontrols_het  if tt_toinclude==1 & (sample<=2 | (sample==3 & sc_monthly==1))  & NI!=1, i(userref_sample) fe robust	
	gen N_`v'_spec12 = e(N)
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(e_`v'_apr22_spec12) outse(e_`v'_apr22_spec12_se) depvar("`v'") wgtpp($wgt_PPifSC) outvar(elas) wgtsc($wgt_SC) scincl("yes")
	calc_avg_elas, lpbase($lp_postOct21) lppost($lp_postApr22) outelas(qchg_`v'_apr22_spec12) outse(qchg_`v'_apr22_spec12_se) depvar("`v'") wgtpp($wgt_PPifSC) outvar(qchg) wgtsc($wgt_SC) scincl("yes")
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(e_`v'_oct21_spec12) outse(e_`v'_oct21_spec12_se) depvar("`v'") wgtpp($wgt_PPifSC) outvar(elas) wgtsc($wgt_SC) scincl("yes")
	calc_avg_elas, lpbase($lp_base) lppost($lp_postOct21) outelas(qchg_`v'_oct21_spec12) outse(qchg_`v'_oct21_spec12_se) depvar("`v'") wgtpp($wgt_PPifSC) outvar(qchg) wgtsc($wgt_SC) scincl("yes")
	
}



egen inc_eexp_dec = group(inc_quint eexp_quint)


gen wgt_het = 0
su sample_PP if  tt_toinclude==1
global scale_PP = r(mean)
forval i = 1/25 {
	su sample_PP if  tt_toinclude==1 & `i'.inc_eexp_dec == 1 & NI!=1
	global wgt_PP`i' = (r(mean)/$scale_PP) * $wgt_PP

	replace wgt_het = ${wgt_PP`i' } if sample == 1 &  `i'.inc_eexp_dec == 1
	replace wgt_het = 1 - ${wgt_PP`i' } if sample == 2 &  `i'.inc_eexp_dec == 1
}


gen lp_hom = lp
gen lp_hom_DD = lp_DD
gen lp_hom_PP = lp_PP

foreach p in hom het {
	foreach dep in x q {

		xtreg l`dep'_ds  c.lp_`p'#i.eexp_quint#i.inc_quint  c.lp_`p'_PP c.lp_`p'_DD  $anticip_het $tempcontrols_het  if tt_toinclude==1 & sample<=2  & NI!=1, i(userref_sample) fe robust
		estimates store spec_`p'_`dep'


		estimates restore spec_`p'_`dep'
		foreach v in  Apr22 Oct21 {
			gen e_`dep'_`p'_`v' = .
			gen e_`dep'_`p'_`v'_se = .
			gen eDiff51_`dep'_`p'_`v' = .
			gen eDiff51_`dep'_`p'_`v'_se = .

			forval i = 1/5 {
				forval j = 1/5 {

				su lp_`p' if cap_per == 1  & eexp_quint == `i' & inc_quint == `j'
				global lp_base = r(mean)
				su lp_`p' if cap_per == 2  & eexp_quint == `i' & inc_quint == `j'
				global lp_postOct21 = r(mean)
				su lp_`p' if cap_per == 3  & eexp_quint == `i' & inc_quint == `j'
				global lp_postApr22 = r(mean)

				local lppost = ${lp_post`v'}
				if "`v'" == "Oct21" local lpbase = $lp_base
				if "`v'" == "Apr22" local lpbase = $lp_postOct21

				su wgt_het if sample == 1 & eexp_quint == `i' & inc_quint == `j'
				global wgt_PP_het = r(mean)

				disp as error "i = `i', j = `j'"
				estimates restore spec_`p'_`dep'

				** save elasticities				
				if "`dep'" == "x" {
					#delimit ;
					nlcom 
					((1-${wgt_PP_het})*((exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lppost') - exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase'))/exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase'))
					+   ${wgt_PP_het} *((exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lppost') - exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase'))/exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase'))
					)/
					((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
					;
					#delimit cr
				}
				if "`dep'" == "q" {
					#delimit ;
					nlcom 
					((1-${wgt_PP_het})*((exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD])*`lppost') - exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase'))/exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase'))
					+   ${wgt_PP_het} *((exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP])*`lppost') - exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase'))/exp((_b[lp_`p'#`i'.eexp_quint#`j'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase'))
					)/
					((exp(`lppost') - exp(`lpbase'))/exp(`lpbase'))
					;
					#delimit cr
				}

				matrix b = r(b)
				matrix V = r(V) 
				replace e_`dep'_`p'_`v' = b[1,1] 			 if eexp_quint == `i' & inc_quint == `j'
				replace e_`dep'_`p'_`v'_se = sqrt(V[1,1])    if eexp_quint == `i' & inc_quint == `j'
				
				}
				
			** Test the difference between 1st and 5th income quintile 
			estimates restore spec_`p'_`dep'
			local j1 = 5
			local j2 = 1
			
			su lp_`p' if cap_per == 1  & eexp_quint == `i' & inc_quint == `j1'
			global lp1_base = r(mean)
			su lp_`p' if cap_per == 2  & eexp_quint == `i' & inc_quint == `j1'
			global lp1_postOct21 = r(mean)
			su lp_`p' if cap_per == 3  & eexp_quint == `i' & inc_quint == `j1'
			global lp1_postApr22 = r(mean)				
			su lp_`p' if cap_per == 1  & eexp_quint == `i' & inc_quint == `j2'
			global lp2_base = r(mean)
			su lp_`p' if cap_per == 2  & eexp_quint == `i' & inc_quint == `j2'
			global lp2_postOct21 = r(mean)
			su lp_`p' if cap_per == 3  & eexp_quint == `i' & inc_quint == `j2'
			global lp2_postApr22 = r(mean)	
			
			local lppost_j1 = ${lp1_post`v'}
			local lppost_j2 = ${lp2_post`v'}
			if "`v'" == "Oct21" local lpbase_j1 = $lp1_base
			if "`v'" == "Oct21" local lpbase_j2 = $lp2_base
			if "`v'" == "Apr22" local lpbase_j1 = $lp1_postOct21
			if "`v'" == "Apr22" local lpbase_j2 = $lp2_postOct21

			su wgt_het if sample == 1 & eexp_quint == `i' & inc_quint == `j1'
			global wgt_PP_het_j1 = r(mean)				
			su wgt_het if sample == 1 & eexp_quint == `i' & inc_quint == `j2'
			global wgt_PP_het_j2 = r(mean)				
		
			
			if "`dep'" == "x" {
				#delimit ;
				nlcom 
				(((1-${wgt_PP_het_j1})*((exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lppost_j1') - exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase_j1'))/exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase_j1'))
				+   ${wgt_PP_het_j1} *((exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lppost_j1') - exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase_j1'))/exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase_j1'))
				)/
				((exp(`lppost_j1') - exp(`lpbase_j1'))/exp(`lpbase_j1')))
				-
				(((1-${wgt_PP_het_j2})*((exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lppost_j2') - exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase_j2'))/exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD]-1)*`lpbase_j2'))
				+   ${wgt_PP_het_j2} *((exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lppost_j2') - exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase_j2'))/exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP]-1)*`lpbase_j2'))
				)/
				((exp(`lppost_j2') - exp(`lpbase_j2'))/exp(`lpbase_j2')))				
				;
				#delimit cr
			}
			if "`dep'" == "q" {
				#delimit ;
				nlcom 
				(((1-${wgt_PP_het_j1})*((exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD])*`lppost_j1') - exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase_j1'))/exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase_j1'))
				+   ${wgt_PP_het_j1} *((exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP])*`lppost_j1') - exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase_j1'))/exp((_b[lp_`p'#`i'.eexp_quint#`j1'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase_j1'))
				)/
				((exp(`lppost_j1') - exp(`lpbase_j1'))/exp(`lpbase_j1')))
				-
				(((1-${wgt_PP_het_j2})*((exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD])*`lppost_j2') - exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase_j2'))/exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_DD])*`lpbase_j2'))
				+   ${wgt_PP_het_j2} *((exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP])*`lppost_j2') - exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase_j2'))/exp((_b[lp_`p'#`i'.eexp_quint#`j2'.inc_quint]+ _b[c.lp_`p'_PP])*`lpbase_j2'))
				)/
				((exp(`lppost_j2') - exp(`lpbase_j2'))/exp(`lpbase_j2')))				
				;
				#delimit cr				

			}			
			
			matrix b = r(b)
			matrix V = r(V) 
			replace eDiff51_`dep'_`p'_`v' = b[1,1] 			 if eexp_quint == `i'
			replace eDiff51_`dep'_`p'_`v'_se = sqrt(V[1,1])    if eexp_quint == `i'
				
			}	
		}
	}
}


sa "$dataAnalysis/eventstudy_elasticities_full", replace

*/


u "$dataAnalysis/eventstudy_elasticities_full", clear


collapse (mean) e_*_spec* qchg_*_spec* e_?_h??_Apr22 e_?_h??_Apr22_se e_?_h??_Oct21 e_?_h??_Oct21_se N_?_spec* eDiff51* , by(inc_eexp_dec inc_quint eexp_quint)
drop if inc_eexp_dec == .


sa "$dataAnalysis/eventstudy_elasticities_compress", replace





*/

u "$dataAnalysis/eventstudy_elasticities_compress", clear

format %9.3f e_*_spec*
format %9.0fc N_*_spec*


foreach v in q x {
	foreach x in oct21 apr22 {
		foreach s in 1 2 3 4 5 6 7 8 9 10 11 12 {
			su e_`v'_`x'_spec`s'_se
			gen temp = r(mean)
			format %9.3f temp
			tostring temp, use force gen(e_`v'_`x'_spec`s'_se_s)
			replace e_`v'_`x'_spec`s'_se_s = "{\small ("+e_`v'_`x'_spec`s'_se_s+")}"
			drop temp

			replace qchg_`v'_`x'_spec`s' = qchg_`v'_`x'_spec`s'*100
			replace qchg_`v'_`x'_spec`s'_se = qchg_`v'_`x'_spec`s'_se*100
			format %9.1f qchg_`v'_`x'_spec`s'
			su qchg_`v'_`x'_spec`s'_se
			gen temp = r(mean)
			format %9.1f temp
			tostring temp, use force gen(qchg_`v'_`x'_spec`s'_se_s)
			replace qchg_`v'_`x'_spec`s'_se_s = "{\small ("+qchg_`v'_`x'_spec`s'_se_s+")}"
			drop temp
			
			
			gen e_`v'_`x'_spec`s'_lb = e_`v'_`x'_spec`s' - 1.96* e_`v'_`x'_spec`s'_se
			gen e_`v'_`x'_spec`s'_ub = e_`v'_`x'_spec`s' + 1.96* e_`v'_`x'_spec`s'_se

		}
	}
}



gen e_lab = "Own-price elasticity"
gen q_lab = "\%$\Delta e $ over cap change"
gen N_lab = "N"
gen blank = ""

//MAIN RESULTS
foreach v in apr22 {
	listtab e_lab e_x_`v'_spec1  e_x_`v'_spec11    e_x_`v'_spec5      e_x_`v'_spec6        in 1 using "$resultsdir/TAB_elas_`v'.tex", replace rstyle(tabular)
	listtab blank e_x_`v'_spec1_se_s e_x_`v'_spec11_se_s e_x_`v'_spec5_se_s e_x_`v'_spec6_se_s    in 1 using "$resultsdir/TAB_elas_`v'_se.tex", replace rstyle(tabular)
	listtab q_lab qchg_x_`v'_spec1  qchg_x_`v'_spec11 qchg_x_`v'_spec5      qchg_x_`v'_spec6        in 1 using "$resultsdir/TAB_qchg_`v'.tex", replace rstyle(tabular)
	listtab blank 	qchg_x_`v'_spec1_se_s  qchg_x_`v'_spec11_se_s qchg_x_`v'_spec5_se_s qchg_x_`v'_spec6_se_s  in 1 using "$resultsdir/TAB_qchg_`v'_se.tex", replace rstyle(tabular)
	listtab N_lab N_x_spec1 N_x_spec11  N_x_spec5      N_x_spec6         in 1 using "$resultsdir/TAB_N_`v'.tex", replace rstyle(tabular)
	
}

//APPENDIX RESULTS
foreach v in apr22 {
	listtab e_lab e_q_`v'_spec1 e_x_`v'_spec10     e_x_`v'_spec3      e_x_`v'_spec2      e_x_`v'_spec8      e_x_`v'_spec7   e_x_`v'_spec4 e_x_`v'_spec12  e_x_`v'_spec9  in 1 using "$resultsdir/TAB_elas_`v'_app.tex", replace rstyle(tabular)
	listtab blank 	e_q_`v'_spec1_se_s e_x_`v'_spec10_se_s e_x_`v'_spec3_se_s e_x_`v'_spec2_se_s e_x_`v'_spec8_se_s e_x_`v'_spec7_se_s e_x_`v'_spec4_se_s e_x_`v'_spec12_se_s  e_x_`v'_spec9_se_s  in 1 using "$resultsdir/TAB_elas_`v'_se_app.tex", replace rstyle(tabular)
	listtab q_lab    qchg_q_`v'_spec1  qchg_x_`v'_spec10     qchg_x_`v'_spec3      qchg_x_`v'_spec2      qchg_x_`v'_spec8      qchg_x_`v'_spec7    qchg_x_`v'_spec4 qchg_x_`v'_spec12 qchg_x_`v'_spec9      in 1 using "$resultsdir/TAB_qchg_`v'_app.tex", replace rstyle(tabular)
	listtab blank 	qchg_q_`v'_spec1_se_s qchg_x_`v'_spec10_se_s qchg_x_`v'_spec3_se_s qchg_x_`v'_spec2_se_s qchg_x_`v'_spec8_se_s qchg_x_`v'_spec7_se_s qchg_x_`v'_spec4_se_s qchg_x_`v'_spec12_se_s qchg_x_`v'_spec9_se_s  in 1 using "$resultsdir/TAB_qchg_`v'_se_app.tex", replace rstyle(tabular)
	listtab N_lab N_q_spec1   N_x_spec10      N_x_spec3      N_x_spec2  N_x_spec8 N_x_spec7 N_x_spec4 N_x_spec12 N_x_spec9  in 1 using "$resultsdir/TAB_N_`v'_app.tex", replace rstyle(tabular)
}





u "$dataAnalysis/eventstudy_elasticities_compress", clear

format %9.3f e_*_spec*

drop inc_eexp_dec
keep inc_quint eexp_quint  e_x_h??_Apr22 e_x_h??_Apr22_se e_x_h??_Oct21 e_x_h??_Oct21_se eDiff51*

rename e_x_* elas_*
rename elas_* =_inc

gen eDiff51_x_hom_Apr22_lb = eDiff51_x_hom_Apr22 - 1.96*eDiff51_x_hom_Apr22_se
gen eDiff51_x_hom_Apr22_ub = eDiff51_x_hom_Apr22 + 1.96*eDiff51_x_hom_Apr22_se

cap log close
log using "$resultsdir/LOG_elasbyeexpquint.log" ,replace

su elas_het_Apr22_inc if eexp_quint==1
su elas_hom_Apr22_inc if eexp_quint==1

su elas_het_Apr22_inc if eexp_quint==5
su elas_hom_Apr22_inc if eexp_quint==5


table eexp_quint inc_quint, stat(m elas_hom_Apr22_inc  )
table eexp_quint , stat(m eDiff51_x_hom_Apr22  eDiff51_x_hom_Apr22_lb  eDiff51_x_hom_Apr22_ub)


log close

foreach p in het hom {

	gen elas_`p'_Apr22_ub_inc = elas_`p'_Apr22_inc + 1.96*elas_`p'_Apr22_se_inc
	gen elas_`p'_Apr22_lb_inc = elas_`p'_Apr22_inc - 1.96*elas_`p'_Apr22_se_inc

	gen elas_`p'_Oct21_ub_inc = elas_`p'_Oct21_inc + 1.96*elas_`p'_Oct21_se_inc
	gen elas_`p'_Oct21_lb_inc = elas_`p'_Oct21_inc - 1.96*elas_`p'_Oct21_se_inc

}

#delimit ;
reshape wide 
elas_het_Oct21_inc  	elas_het_Apr22_inc 
elas_het_Oct21_se_inc 	elas_het_Apr22_se_inc 
elas_het_Apr22_ub_inc elas_het_Apr22_lb_inc 
elas_het_Oct21_ub_inc elas_het_Oct21_lb_inc
elas_hom_Oct21_inc  	elas_hom_Apr22_inc 
elas_hom_Oct21_se_inc 	elas_hom_Apr22_se_inc 
elas_hom_Apr22_ub_inc elas_hom_Apr22_lb_inc 
elas_hom_Oct21_ub_inc elas_hom_Oct21_lb_inc
, i(eexp_quint) j(inc_quint)
;
#delimit cr

gen eexp_quint_minus2 = eexp_quint - 0.1
gen eexp_quint_minus1 = eexp_quint - 0.05
gen eexp_quint_plus2 = eexp_quint + 0.1
gen eexp_quint_plus1 = eexp_quint + 0.05

foreach p in het hom {

	#delimit ;
	twoway rcap elas_`p'_Apr22_ub_inc1 elas_`p'_Apr22_lb_inc1 eexp_quint_minus2, lcolor(gs13)
	|| rcap elas_`p'_Apr22_ub_inc2 elas_`p'_Apr22_lb_inc2 eexp_quint_minus1, lcolor(gs13)
	|| rcap elas_`p'_Apr22_ub_inc3 elas_`p'_Apr22_lb_inc3 eexp_quint, lcolor(gs13)
	|| rcap elas_`p'_Apr22_ub_inc4 elas_`p'_Apr22_lb_inc4 eexp_quint_plus1, lcolor(gs13)
	|| rcap elas_`p'_Apr22_ub_inc5 elas_`p'_Apr22_lb_inc5 eexp_quint_plus2, lcolor(gs13)
	|| scatter elas_`p'_Apr22_inc1 eexp_quint_minus2, c(l) lcolor(gs12) mcolor(gs12) lpattern(solid) msymbol(o)
	|| scatter elas_`p'_Apr22_inc2 eexp_quint_minus1, c(l) lcolor(eltblue) mcolor(eltblue) lpattern(solid) msymbol(d)
	|| scatter elas_`p'_Apr22_inc3 eexp_quint, c(l) lcolor(ebblue) mcolor(ebblue) lpattern(solid) msymbol(t)
	|| scatter elas_`p'_Apr22_inc4 eexp_quint_plus1, c(l) lcolor(edkblue) mcolor(edkblue) lpattern(solid) msymbol(s)
	|| scatter elas_`p'_Apr22_inc5 eexp_quint_plus2, c(l) lcolor(black) mcolor(black) lpattern(solid) msymbol(X)
	yscale(range(-0.5(0.1)0)) ylabel(-0.5(0.1)0)
	xtitle("Pre-shock energy spending quintile")
	ytitle("Price elasticity associated" "with April 2022 increase")
	legend(pos(6) rows(1) label(6 "Q1") label(7 "Q2") label(8 "Q3") label(9 "Q4") label(10 "Q5") order(6 7 8 9 10) title("Income quintile:", size(medsmall)))
	;
	#delimit cr
	graph export "$resultsdir/FIG_elas_apr22_`p'.pdf", replace	



}



reshape long elas_hom_Oct21_inc elas_hom_Apr22_inc, i(eexp_quint) j(inc_quint)

sa "$dataAnalysis/eventstudy_elasticities_het", replace



*/


**********



