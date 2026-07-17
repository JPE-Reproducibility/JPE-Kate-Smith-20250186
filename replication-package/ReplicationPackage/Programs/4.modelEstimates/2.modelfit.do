
**********************************
***Consumer theory restrictions
**********************************
/*
u "$dataAnalysis/estimationdata.dta",clear

egen hh = group(id)
sort id t

keep hh t inc_dec_taxyr eexp_dec prepay yeartax
tempfile temp
sa `temp'


insheet using "$dataAnalysis/restrictions.raw",clear

rename v1  hh
rename v2  t
rename v3  s1_hat
rename v4  concavity
rename v5  monotonicity
rename v6  belas
drop   v7  

gen failconcavity = concavity>0 
gen failmonotonicity = monotonicity<0

tab failconcavity
tab failmonotonicity

merge 1:1 hh t using `temp'
drop _m

merge m:1 yeartax inc_dec_taxyr eexp_dec prepay using "$dataProcess/population_weights.dta"
keep if _m==3
drop _m

bysort inc_dec_taxyr eexp_dec prepay: gen Ns = _N
gen weight = Npop/Ns

gen MPCE=belas*s1
su MPCE [iw=we]
*/
**********************************
***Out of sample predictions
**********************************

insheet using "$dataAnalysis/holdoutpredictions.raw",clear

rename v1  id
rename v2  t
rename v3  s1_hat
drop   v4  

gen n = _n

tempfile temp
sa `temp'

u "$dataAnalysis/holdout.dta",clear

keep if year==2023& month>9

keep id t year month s1 inc_p eexp_p inc_dec_taxyr eexp_dec 

merge 1:1 id t using `temp'
drop _m 

sa "$dataAnalysis/holdoutpredictions.dta",replace



u "$dataAnalysis/holdoutpredictions.dta",clear

collapse (mean) s1 s1_hat,by(eexp_p)

rename s1     s1_ho_e
rename s1_hat s1_hp_e
rename eexp_p p

tempfile tempHE
sa `tempHE'


u "$dataAnalysis/holdoutpredictions.dta",clear

collapse (mean) s1 s1_hat,by(inc_p)

rename s1     s1_ho_i
rename s1_hat s1_hp_i
rename inc_p p

tempfile tempHI
sa `tempHI'

insheet using "$dataAnalysis/insamplepredictions.raw",clear

rename v1  id
rename v2  t
rename v3  s1_hat
drop   v4  

gen n = _n

tempfile temp
sa `temp'

u "$dataAnalysis/estimationdata.dta",clear

keep if year==2022& month>9

keep id t year month s1 inc_p eexp_p inc_dec_taxyr eexp_dec 

merge 1:1 id t using `temp'
drop _m 

sa "$dataAnalysis/insamplepredictions.dta",replace




u "$dataAnalysis/insamplepredictions.dta",clear

collapse (mean) s1 s1_hat,by(eexp_p)

rename s1     s1_io_e
rename s1_hat s1_ip_e
rename eexp_p p

tempfile tempIE
sa `tempIE'

u "$dataAnalysis/insamplepredictions.dta",clear

collapse (mean) s1 s1_hat,by(inc_p)

rename s1     s1_io_i
rename s1_hat s1_ip_i
rename inc_p p

merge 1:1 p using `tempHE'
drop _m
merge 1:1 p using `tempHI'
drop _m
merge 1:1 p using `tempIE'
drop _m

foreach v in s1_ho s1_hp s1_io s1_ip  {
	replace `v'_i=`v'_i*100
	replace `v'_e=`v'_e*100
}


scatter s1_hp_e s1_ho_e s1_ip_e s1_io_e p,msymbol(o X d X) mcolor(navy eltblue black gs8) ytitle(Budget share (%)) xtitle(Percentile) legend(off)
graph export "$resultsdir/FIG_outinsample_exp.pdf",replace

scatter s1_hp_i s1_ho_i s1_ip_i s1_io_i p,msymbol(o X d X) mcolor(navy eltblue black gs8) ytitle(Budget share (%)) xtitle(Percentile) legend(off)
graph export "$resultsdir/FIG_outinsample_inc.pdf",replace

scatter s1_hp_i s1_ho_i s1_ip_i s1_io_i p,msymbol(o X d X) mcolor(navy eltblue black gs8) ytitle(Budget share (%)) xtitle(Percentile) legend(order(3 1) lab(3 "In sample (2022)") lab(1 "Out of sample (2023)")  size(medium) pos(6) row(1))
graph export "$resultsdir/FIG_outinsample_legend.png",replace

*scatter s1_hp_e s1_ho_e s1_hp_i s1_ho_i p,msymbol(o X o X) mcolor(navy eltblue dkgreen eltgreen) ytitle(Budget share (%)) xtitle(Percentile) legend(order(1 3) lab(1 "Pre-shock energy spending") lab(3 "Income") pos(6) row(1))
*graph export "$resultsdir/FIG_outofsample_fit.pdf",replace

u "$dataAnalysis/holdoutpredictions.dta",clear

gen     group = 1 if eexp_p<=33
replace group = 2 if eexp_p>33 & eexp_p<=66
replace group = 3 if eexp_p>66

collapse (mean) s1 s1_hat,by(inc_p group)

scatter s1 s1_hat inc_p if group==1,msymbol(o X) mcolor(navy eltblue) || scatter s1 s1_hat inc_p if group==2, msymbol(o X ) mcolor(black gs8) || scatter s1 s1_hat inc_p if group==3, msymbol(o X ) mcolor(dkgreen eltgreen) ytitle(Budget share (%)) xtitle(Income percentile) legend(off)
graph export "$resultsdir/FIG_outofsample_inc.pdf",replace

u "$dataAnalysis/insamplepredictions.dta",clear

gen     group = 1 if eexp_p<=33
replace group = 2 if eexp_p>33 & eexp_p<=66
replace group = 3 if eexp_p>66

collapse (mean) s1 s1_hat,by(inc_p group)

scatter s1 s1_hat inc_p if group==1,msymbol(o X) mcolor(navy eltblue) || scatter s1 s1_hat inc_p if group==2, msymbol(o X ) mcolor(black gs8) || scatter s1 s1_hat inc_p if group==3, msymbol(o X ) mcolor(dkgreen eltgreen) ytitle(Budget share (%)) xtitle(Income percentile) legend(off)
graph export "$resultsdir/FIG_insample_inc.pdf",replace

scatter s1 s1_hat inc_p if group==1,msymbol(o X) mcolor(navy eltblue) || scatter s1 s1_hat inc_p if group==2, msymbol(o X ) mcolor(black gs8) || scatter s1 s1_hat inc_p if group==3, msymbol(o X ) mcolor(dkgreen eltgreen) ytitle(Budget share (%)) xtitle(Income percentile) legend(order(1 3 5) title("Pre-shock energy spending tercile:") lab(1 "Bottom") lab(3 "Middle") lab(5 "Top")  pos(6) row(1) size(medium))
graph export "$resultsdir/FIG_insample_legend.png",replace


**********************************
***Flypaper validation
**********************************

insheet using "$dataAnalysis/flyvalidpredictions1.raw",clear

rename v1  hh
rename v2  t
rename v3  s1_hat1
drop   v4  

gen n = _n

tempfile tempA
sa `tempA'


insheet using "$dataAnalysis/flyvalidpredictions2.raw",clear

rename v1  hh
rename v2  t
rename v3  s1_hat2
drop   v4  

gen n = _n

tempfile tempB
sa `tempB'

u "$dataAnalysis/estimationdata.dta",clear

egen hh = group(id)
keep hh t s1 eexp_p

merge 1:1 hh t using `tempA'
keep if _m==3
drop _m

merge 1:1 hh t using `tempB'
keep if _m==3
drop _m

collapse (mean) s1_hat1 s1_hat2 s1,by(eexp_p)

scatter s1_hat1 s1_hat2 s1 eexp_p,msymbol(o o X) mcolor(navy black gs8) ytitle(Budget share (%)) xtitle(Pre-shock energy spending percentile) legend(order(1 "Predicted" 2 "Predicted (no flypaper)" 3 "Observed")  pos(6) row(1))
graph export "$resultsdir/FIG_flyvalid.pdf",replace

**********************************
***In sample elasticities
**********************************

insheet using "$dataAnalysis/pricepredictions.raw",clear

rename v1  id
rename v2  t
rename v3  pS
rename v4  pNS
rename v5  x
rename v6  qS
rename v7  qNS
drop v8

merge 1:1 id t using "$dataAnalysis/estimationdata.dta",keepusing(yeartax inc_dec_taxyr eexp_dec prepay inc_quint eexp_quint)
keep if _m==3
drop _m

merge m:1 yeartax inc_dec_taxyr eexp_dec prepay using "$dataProcess/population_weights.dta"
keep if _m==3
drop _m

bysort inc_dec_taxyr eexp_dec prepay: gen Ns = _N
gen weight = Npop/Ns

gen Marshallian  = ((qS-qNS)/qNS)/((exp(pS)-exp(pNS))/exp(pNS))
bysort eexp_quint inc_quint: egen base = sum(weight)
egen mn_Marshallian  = sum(Marshallian*(weight/base)),by(eexp_quint inc_quint)
drop base*


line mn_Marshallian eexp_quint if inc_quint==1,lcolor(gs12) || line mn_Marshallian eexp_quint if inc_quint==2,lcolor(eltblue) || line mn_Marshallian eexp_quint if inc_quint==3,lcolor(ebblue) || line mn_Marshallian eexp_quint if inc_quint==4,lcolor(edkblue) || line mn_Marshallian eexp_quint if inc_quint==5,lcolor(black) xtitle("Pre-shock energy spending quintile") ytitle("Price elasticity associated" "with April 2022 increase")  legend(rows(1) lab(1 "Bottom") lab(2 "2") lab(3 "3") lab(4 "4") lab(5 "Top")  region(lstyle(none)) title("Income quintile",size(medium) color(black)) pos(6)) graphr(color(white)) xscale(range(1(1)5)) xlabel(1(1)5) yscale(range(-0.5(0.1)0)) ylabel(-0.5(0.1)0)
graph export "$resultsdir/FIG_elashet_model.pdf",replace

**********************************
***Engel curves
**********************************

insheet using "$dataAnalysis/Engelpredictions.raw",clear

rename v1  id
rename v2  t
rename v3  w
drop v4

merge 1:1 id t using "$dataAnalysis/estimationdata.dta",keepusing(eexp_dec x)
keep if _m==3
drop _m

sort eexp_d x
#delimit ;
line w x if eexp_dec==1,lcolor(gs12) lpattern(dash) || line w x if eexp_dec==2,lcolor(gs12) lpattern(solid)  || line w x if eexp_dec==3,lcolor(eltblue) lpattern(dash) || line w x if eexp_dec==4,lcolor(eltblue) lpattern(solid)  || line w x if eexp_dec==5,lcolor(ebblue) lpattern(dash) || line w x if eexp_dec==6,lcolor(ebblue) lpattern(solid)  || line w x if eexp_dec==7, lcolor(edkblue) lpattern(dash) || line w x if eexp_dec==8, lcolor(edkblue) lpattern(solid)  || line w x if eexp_dec==9, lcolor(black) lpattern(dash) || line w x if eexp_dec==10, lcolor(black) lpattern(solid) 
xtitle("Log total expenditure (x)") ytitle("Energy budget share (w)")
legend(label(1 "1") label(2 "2") label(3 "3") label(4 "4") label(5 "5") label(6 "6") label(7 "7") label(8 "8") label(9 "9") label(10 "10")  title("Pre-shock energy spending decile:", size(medium)) pos(6) rows(2))
;
#delimit cr
graph export "$resultsdir/FIG_Engelcurve.pdf",replace


