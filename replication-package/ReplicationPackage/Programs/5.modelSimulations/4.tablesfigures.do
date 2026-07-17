
u "$dataAnalysis/loss_level.dta",clear

#delimit ;
twoway  rarea p10EVLF p90EVLF inc_p, color(navy%30)
|| rarea p25EVLF p75EVLF inc_p, color(navy%40)
|| rarea p10EVSR p90EVSR inc_p, color(red%30)
|| rarea p25EVSR p75EVSR inc_p, color(red%40)
|| scatter mEVLF mEVSR inc_p, mcolor(navy red) msymbol(o d)
legend(off)
ytitle("Loss" "(£ per month)")
xtitle("Income percentile") ylabel(0(100)500)
;
#delimit cr
graph export "$resultsdir/FIG_Loss_level.pdf",replace

u "$dataAnalysis/loss_proportional.dta",clear

#delimit ;
twoway  rarea p10EVLF p90EVLF inc_p, color(navy%30)
|| rarea p25EVLF p75EVLF inc_p, color(navy%40)
|| rarea p10EVSR p90EVSR inc_p, color(red%30)
|| rarea p25EVSR p75EVSR inc_p, color(red%40)
|| scatter mEVLF mEVSR inc_p, mcolor(navy red) msymbol(o d)
legend(off)
ytitle("Loss" "(% of income)")
xtitle("Income percentile") 
;
#delimit cr
graph export "$resultsdir/FIG_Loss_proportional.pdf",replace


#delimit ;
twoway  rarea p10EVLF p90EVLF inc_p, color(navy%30)
|| rarea p25EVLF p75EVLF inc_p, color(navy%40)
|| rarea p10EVSR p90EVSR inc_p, color(red%30)
|| rarea p25EVSR p75EVSR inc_p, color(red%40)
|| scatter mEVLF mEVSR inc_p, mcolor(navy red) msymbol(o d)
legend(order(5 6) lab(5 "No intervention") lab(6 "Observed policy") rows(1) pos(6) size(medium))
ytitle("Loss" "(% of income)")
xtitle("Income percentile") 
;
#delimit cr
graph export "$resultsdir/FIG_Loss_legend.png",replace



u "$dataAnalysis/loss_average.dta",clear
append using "$dataAnalysis/loss_average_CI.dta"
append using "$dataAnalysis/energypoverty.dta"

gen n = _n
gen x="Monetary (\pounds pm)"
gen o=""
listtab x EVLF EVSR FOLF FOSR  using "$resultsdir/losses.tex" if n==1, replace rstyle(tabular)
listtab o CIEVLF CIEVSR CIFOLF CIFOSR   if n==2, appendto("$resultsdir/losses.tex") rstyle(tabular) replace
replace x="Proportional to Y (\%)"
listtab x EVLFy_s EVSRy_s FOLFy_s FOSRy_s  if n==1, appendto("$resultsdir/losses.tex") rstyle(tabular) replace
listtab o CIEVLFy CIEVSRy CIFOLFy CIFOSRy  if n==2, appendto("$resultsdir/losses.tex") rstyle(tabular) replace
replace x="Aggregate (\pounds bn)"
listtab x EVLFa EVSRa FOLFa FOSRa  if n==1, appendto("$resultsdir/losses.tex") rstyle(tabular) replace
listtab o CIEVLFa CIEVSRa CIFOLFa CIFOSRa  if n==2, appendto("$resultsdir/losses.tex") rstyle(tabular) replace

replace x="Number of households"
listtab x o o o o using "$resultsdir/poverty.tex" if n==3, rstyle(tabular) replace
replace x="in energy poverty"
listtab x epLF epSR epFOLF epFOSR if n==3, appendto("$resultsdir/poverty.tex") rstyle(tabular) replace


u "$dataAnalysis/efficiency_cost.dta",clear
append using "$dataAnalysis/efficiency_cost_CI.dta"

gen n = _n
gen o = ""
gen x="Aggregate (\pounds bn)"
listtab x eff prc chc fis car using "$resultsdir/efficiency.tex" if n==1, replace rstyle(tabular)
listtab o  CIeff CIprc CIchc CIfis CIca   if n==2, appendto("$resultsdir/efficiency.tex") rstyle(tabular) replace

replace x="Contribution:"
listtab x o pprc_s pchc_s pfis_s pcar_s  if n==1, appendto("$resultsdir/efficiency.tex")  rstyle(tabular) replace
listtab o o CIpprc CIpchc CIpfis CIpcar    if n==2, appendto("$resultsdir/efficiency.tex")  rstyle(tabular) replace


u "$dataAnalysis/optimal_decomp.dta",clear

graph bar un ec tar,over(p) stack legend(rows(1) pos(6) lab(1 "Uncompensated") lab(2 "Efficiency cost") lab(3 "Mistargeting cost") ) ytitle("Welfare loss" "(% of income)") bar(1,color(gs12)) bar(2,color(midblue)) bar(3,color(navy)) 
graph export "$resultsdir/FIG_optimal_decomp.pdf",replace

u  "$dataAnalysis/optimal_frontier_plus.dta",clear

twoway  rarea bd tr ec if ec<=0,color(gs12%30)|| line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTy ecSTy,color(midblue) lpattern(longdash)|| line  tarSTs ecSTs,color(black) lpattern(solid) || line  tarSTys ecSTys,color(gs8) lpattern(longdash_dot ) || scatter tarSR ecSR if optimalSR==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTe ecSTe if optimalSTe==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTy ecSTy if optimalSTy==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTs==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTys ecSTys if optimalSTys==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTys ecSTys if optimalSTs==1,msymbol(none)   xtitle("Efficiency cost" "(% of income)") ytitle("Mistargeting cost" "(% of income)") legend(off) xlabel(-1.2 "1.2%" -1 "1%" -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )  ylabel( -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-1.2(0.2)0)) yscale(range(-2.0(0.5)0)) text(-0.9 -0.59 "s*=39%", size(small) color(black))  text(-0.72 -0.46 "s*=38%", size(small) color(black)) text(-0.32 -0.52 "s*=40%", size(small) color(black)) text(-0.7 -0.25 "s*=27%", size(small) color(black))  text(-0.19 -0.26 "s*=30%", size(small) color(black))
graph export "$resultsdir/FIG_optimal_frontier_W.pdf",replace

 line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTy ecSTy,color(midblue) lpattern(longdash)|| line  tarSTs ecSTs,color(black) lpattern(solid) || line  tarSTys ecSTys,color(gs8) lpattern(longdash_dot ) || scatter tarSTys ecSTys if optimalSTs==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTys ecSTys if optimalSTs==1,msymbol(none)  legend(title("Subsidy combined with transfer that is:",size(medium)) rows(3) pos(6) order(1 "Labelled" 2 "Unlabelled" 3 "Prop. to (1/Y)" 4 "Prop. to E" 5 "Prop. to (E/Y)" 11 ""  11 "" 6 "Loss minimizing policy") size(medium)) xlabel(-1.2 "1.2%" -1 "1%" -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )  ylabel( -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-1.2(0.2)0)) yscale(range(-2.0(0.5)0))
graph export "$resultsdir/FIG_optimal_frontier_W_legend.png",replace


