



u "$dataAnalysis/welfareweights.dta",clear

scatter EVSR inc if inc<15,msymbol(x) mcolor(red) msize(tiny) || line EV ls1 if ls1<15,lcolor(navy) lpattern(solid) || line EV ls2 if ls2<15,lcolor(gs3) lpattern(dash) || line EV ls3 if ls3<15,lcolor(gs6) lpattern(solid) || line EV ls4 if ls4<15,lcolor(gs9) lpattern(dash) || line EV ls5 if ls5<15 ,lcolor(gs12) lpattern(solid) || line EV ls10 if ls10<15 ,lcolor(edkblue) lpattern(dash) || line EV ls25 if ls25<15 ,lcolor(midblue) lpattern(solid)|| line EV ls50 if ls50<15,lcolor(ebblue) lpattern(dash)|| line EV ls100 if ls100<15,lcolor(navy) lpattern(solid) legend(off) xtitle(Monthly income (£1000)) ytitle(Loss per month (£))
graph export "$resultsdir/FIG_lossfunctionww.pdf",replace

scatter EVSR inc if inc<15,msymbol(x) mcolor(red) msize(tiny) || line EV ls1 if ls1<15,lcolor(black) lpattern(solid) || line EV ls2 if ls2<15,lcolor(gs3) lpattern(dash) || line EV ls3 if ls3<15,lcolor(gs6) lpattern(solid) || line EV ls4 if ls4<15,lcolor(gs9) lpattern(dash) || line EV ls5 if ls5<15 ,lcolor(gs12) lpattern(solid) || line EV ls10 if ls10<15 ,lcolor(edkblue) lpattern(dash) || line EV ls25 if ls25<15 ,lcolor(midblue) lpattern(solid)|| line EV ls50 if ls50<15,lcolor(ebblue) lpattern(dash) || line EV ls100 if ls100<15,lcolor(navy) lpattern(solid) legend(rows(1) pos(6) order(10 9 8 7 6 5 4 3 2)  lab(10 "100") lab(9 "50") lab(8 "25") lab(7 "10") lab(6 "5") lab(5 "4") lab(4 "3") lab(3 "2") lab(2 "1") title(Average welfare weight)) xtitle(Monthly income (£1000)) ytitle(Loss per month (£))
graph export "$resultsdir/FIG_legend_ww.png",replace

scatter EVSR inc if inc<15,msymbol(x) mcolor(red) msize(tiny) || line EV lsh1 if lsh1<15,lcolor(black) lpattern(solid) || line EV lsh2 if lsh2<15,lcolor(gs3) lpattern(dash) || line EV lsh3 if lsh3<15,lcolor(gs6) lpattern(solid) || line EV lsh4 if lsh4<15,lcolor(gs9) lpattern(dash) || line EV lsh5 if lsh5<15 ,lcolor(gs12) lpattern(solid) || line EV lsh10 if lsh10<15 ,lcolor(edkblue) lpattern(dash) || line EV lsh25 if lsh25<15 ,lcolor(midblue) lpattern(solid)|| line EV lsh50 if lsh50<15,lcolor(ebblue) lpattern(dash) || line EV lsh100 if inc<150,lcolor(navy) lpattern(solid) legend(off) xtitle(Monthly income (£1000)) ytitle(Loss per month (£))
graph export "$resultsdir/FIG_standardww.pdf",replace


u "$dataAnalysis/optimal_frontier_s1.dta",clear

line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTy ecSTy,color(midblue) lpattern(longdash)|| line  tarSTs ecSTs,color(black) lpattern(solid) || line  tarSTys ecSTys,color(gs8) lpattern(longdash_dot ) || scatter tarSR ecSR if optimalSR==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTe ecSTe if optimalSTe==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTy ecSTy if optimalSTy==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTs==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTys ecSTys if optimalSTys==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTys ecSTys if optimalSTs==1,msymbol(none)   xtitle("Efficiency cost" "(% of income)") ytitle("Mistargeting cost" "(% of income)") legend(off) xlabel(-1.4 "1.4%" -1.2 "1.2%" -1 "1%" -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )  ylabel( -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-1.4(0.2)0)) yscale(range(-2.0(0.5)0)) text(-0.83 -0.3 "s*=24%", size(small) color(black))  text(-0.64 -0.2 "s*=25%", size(small) color(black)) text(-0.4 -0.45 "s*=34%", size(small) color(black)) text(-0.6 -0.08 "s*=13%", size(small) color(black))  text(-0.22 -0.16 "s*=21%", size(small) color(black))
graph export "$resultsdir/FIG_optimal_frontier_s1.pdf",replace


u "$dataAnalysis/optimal_frontier_s2.dta",clear

line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTy ecSTy,color(midblue) lpattern(longdash)|| line  tarSTs ecSTs,color(black) lpattern(solid) || line  tarSTys ecSTys,color(gs8) lpattern(longdash_dot ) || scatter tarSR ecSR if optimalSR==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTe ecSTe if optimalSTe==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTy ecSTy if optimalSTy==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTs==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTys ecSTys if optimalSTys==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTys ecSTys if optimalSTs==1,msymbol(none)   xtitle("Efficiency cost" "(% of income)") ytitle("Mistargeting cost" "(% of income)") legend(off) xlabel( -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )  ylabel( -3 "3.0%" -2.5 "2.5%" -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-0.8(0.2)0)) yscale(range(-3.0(0.5)0)) text(-0.68 -0.72 "s*=52%", size(small) color(black))  text(-.98 -0.66 "s*=50%", size(small) color(black)) text(-0.35 -0.47 "s*=43%", size(small) color(black)) text(-1 -0.35 "s*=37%", size(small) color(black))  text(-0.1 -0.35 "s*=36%", size(small) color(black))
graph export "$resultsdir/FIG_optimal_frontier_s2.pdf",replace

u "$dataAnalysis/optimal_decomp_s.dta",clear

graph bar un ec tar, stack over(pp,  gap(5) label(angle(45))) over(menu, gap(40) label(labsize(medium))) bar(1, color(gs12)) bar(2, color(midblue)) bar(3, color(navy)) legend(rows(1) pos(6) lab(1 "Uncompensated") lab(2 "Efficiency cost") lab(3 "Mistargeting cost")) ytitle("Welfare loss (% of income)")
graph export "$resultsdir/FIG_optimal_decomp_s.pdf",replace


u  "$dataAnalysis/optimal_frontier_incadj.dta",clear

line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTs ecSTs,color(black) lpattern(solid)  || scatter tarSTe ecSTe if optimalSTe==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTs==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTe ecSTe if optimalSTeb==1, mcolor(red) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTsb==1, mcolor(red) msymbol(X) msize(large)  xtitle("Efficiency cost" "(% of income)") ytitle("Mistargeting cost" "(% of income)")  xlabel(-1.2 "1.2%" -1 "1%" -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )  ylabel( -2.5 "2.5%" -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-1.2(0.2)0)) yscale(range(-2.5(0.5)0))  legend(size(medium) rows(2) pos(6) title("Subsidy combined with transfer that is:",size(medium))  order(1 "Unlabelled (universal)" 2 "Prop. to E" 5 "Baseline optimal policy" 3 "Re-optimised policy"))   text(-0.68 -0.45 "s*=38%", size(small) color(red)) text(-0.2 -0.22 "s*=26%", size(small) color(red)) text(-0.58 -0.73 "s*=45%", size(small) color(black)) text(-0.5 -0.17 "s*=23%", size(small) color(black))
graph export "$resultsdir/FIG_optimal_frontier_W_incadj.pdf",replace


u "$dataAnalysis/optimal_decomp_incadj.dta",clear

graph bar un ec tar, stack over(pp,  gap(5)) over(menu, gap(40) label(labsize(medlarge))) bar(1, color(gs12)) bar(2, color(midblue)) bar(3, color(navy)) legend(rows(1) pos(6) lab(1 "Uncompensated") lab(2 "Efficiency cost") lab(3 "Mistargeting cost") size(medium)) ytitle("Welfare loss (% of income)")
graph export "$resultsdir/FIG_optimal_decomp_incadj.pdf",replace




u "$dataAnalysis/revenuemin.dta",clear

gen x = "s=s$^{*}$"
listtab x R_bar_s R_STe_s R_STy_s R_STs_s R_STys_s  using "$resultsdir/Wequiv.tex", replace rstyle(tabular)
replace x = "s$=0$"
gen o = ""
listtab x o R_Te_s R_Ty_s R_Ts_s R_Tys_s ,appendto("$resultsdir/Wequiv.tex") replace rstyle(tabular)


u "$dataAnalysis/socialpreferences.dta",clear

su cpsi
local x=`r(mean)'
 line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)|| line W psi if p==3,color(midblue) lpattern(longdash) || line W psi if p==4,color(black) lpattern(solid)  || line W psi  if p==5 , lpattern(longdash_dot ) color(gs8) xline(`x')  xtitle("Social loss convexity ({&psi})") ytitle("Social loss" "(% relative (s,T,L=1))") legend(off)
 graph export "$resultsdir/FIG_psi_W.pdf",replace


su cpsi
local x=`r(mean)'
line ops psi if p==1,color(red)  lpattern(dash) || line ops psi if p==2,color(navy)  lpattern(shortdash) || line ops psi if p==3,color(midblue) lpattern(longdash) || line ops psi if p==4,color(black)  lpattern(solid)  || line ops psi  if p==5,  lpattern(longdash_dot ) color(gs8) xline(`x')  xtitle("Social loss convexity ({&psi})") ytitle("Optimal subsidy (%)") legend(off)
 graph export "$resultsdir/FIG_psi_sub.pdf",replace


u "$dataAnalysis/socialpreferences_nosub.dta",clear 
  
su cpsi
local x=`r(mean)'
line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)|| line W psi if p==3,color(midblue) lpattern(longdash) || line W psi if p==4,color(black) lpattern(solid)  || line W psi  if p==5 , lpattern(longdash_dot ) color(gs8) xline(`x')  xtitle("Social loss convexity ({&psi})") ytitle("Social loss" "(% relative (s,T,L=1))") legend(off)
 graph export "$resultsdir/FIG_psi_W_nosub.pdf",replace
 
 
 su cpsi
local x=`r(mean)'
 line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)|| line W psi if p==3,color(midblue) lpattern(longdash) || line W psi if p==4,color(black) lpattern(solid)  || line W psi  if p==5 , lpattern(longdash_dot )color(gs8) xline(`x')  xtitle("Social loss convexity ({&psi})") ytitle("Social loss" "(% relative (s,T,L=1))")  legend(title("Zero subsidy and transfer that is:",size(medium)) rows(2) pos(6) order(1 "Labelled" 2 "Unlabelled" 3 "Prop. to (1/Y)" 4 "Prop. to E" 5 "Prop. to (E/Y)") size(medium))
 graph export "$resultsdir/FIG_psi_nosub_legend.png",replace

 


u "$dataAnalysis/optimal_frontier_incweight.dta",clear

line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || line  tarSTy ecSTy,color(midblue) lpattern(longdash)|| line  tarSTs ecSTs,color(black) lpattern(solid) || line  tarSTys ecSTys,color(gs8) lpattern(longdash_dot ) || scatter tarSR ecSR if optimalSR==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTe ecSTe if optimalSTe==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTy ecSTy if optimalSTy==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTs ecSTs if optimalSTs==1, mcolor(black) msymbol(X) msize(large) || scatter tarSTys ecSTys if optimalSTys==1, mcolor(black) msymbol(X) msize(large)  || scatter tarSTys ecSTys if optimalSTs==1,msymbol(none)   xtitle("Efficiency cost" "(% of income)") ytitle("Mistargeting cost" "(% of income)") legend(off) xlabel(-1.2 "1.2%" -1 "1%" -.8 "0.8%" -.6 "0.6%" -.4 "0.4%" -.2 "0.2%" 0 "0%" )   ylabel( -2.5 "2.5%" -2 "2.0%" -1.5 "1.5%" -1 "1.0%" -0.5 "0.5%" 0 "0%") xscale(range(-1.2(0.2)0)) yscale(range(-2.5(0.5)0))text(-1.22 -0.59 "s*=39%", size(small) color(black))  text(-1 -0.46 "s*=37%", size(small) color(black)) text(-0.41 -0.43 "s*=36%", size(small) color(black)) text(-0.82 -0.27 "s*=29%", size(small) color(black))  text(-0.12 -0.22 "s*=25%", size(small) color(black))
graph export "$resultsdir/FIG_optimal_frontier_W_incweight.pdf",replace

u "$dataAnalysis/optimal_decomp_incweight.dta",clear

graph bar un ec tar,over(p,  label(labsize(medium))) stack legend(rows(1) pos(6) lab(1 "Uncompensated") lab(2 "Efficiency cost") lab(3 "Mistargeting cost") size(medium)) ytitle("Welfare loss" "(% of income)") bar(1,color(gs12)) bar(2,color(midblue)) bar(3,color(navy)) 
graph export "$resultsdir/FIG_optimal_decomp_incweight.pdf",replace