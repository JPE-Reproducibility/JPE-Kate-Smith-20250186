
forv z=1/$REPS {
	insheet using "$dataAnalysisIn/confidenceinterval`z'.raw",clear
	
	rename v1  inc
	rename v2  FOSR
	rename v3  FOLF
	rename v4  EVSR
	rename v5  EVLF
	rename v6  CVLF	
	rename v7  EVTt
	rename v8  EVTl
	rename v9  EVST
	rename v10 EVSTe
	rename v11 FOSRy
	rename v12 FOLFy	
	rename v13 EVSRy
	rename v14 EVLFy
	rename v15 CVLFy
	rename v16 EVTty
	rename v17 EVTly
	rename v18 EVSTy
	rename v19 EVSTey
	drop v20
	
	preserve
	
	keep FOSR FOLF EVSR EVLF FOSRy FOLFy EVSRy EVLFy inc
	
	tempfile loss`z'
	sa `loss`z''

	restore
	
	foreach v in EVSR EVLF EVTt EVTl EVST EVSTe  {
		replace `v'=`v'*$S
	}

	gen eff=EVSR-EVTt

	gen prc=EVSTe-EVTl
	gen chc=EVSR-EVST
	gen fis=EVST-EVSTe
	gen car=EVTl-EVTt	
	
	keep eff prc chc fis car inc
	/*
	foreach v in eff prc chc fis car {
		gen y`v'=(`v'/inc)*100
	}
	*/
	foreach v in prc chc fis car {
		gen p`v'=(`v'/eff)*100
	}	
	
	tempfile ef`z'
	sa `ef`z''
}

u `loss1',clear

forv z=2/$REPS {
	append using `loss`z''
}

foreach v in FOSR FOLF EVSR EVLF {
	gen `v'a=`v'*$S
}

foreach v in FOSR FOLF EVSR EVLF {
	egen lb`v' = pctile(`v'),p(2.5)
	egen ub`v' = pctile(`v'),p(97.5) 
	replace `v'y=`v'y*100
	egen lb`v'y = pctile(`v'y),p(2.5) 
	egen ub`v'y = pctile(`v'y),p(97.5)
	egen lb`v'a = pctile(`v'a),p(2.5)
	egen ub`v'a = pctile(`v'a),p(97.5) 	
}

keep if _n==1
keep lb* ub*

format lb* ub* %9.2f

foreach v in FOSR FOLF EVSR EVLF FOSRy FOLFy EVSRy EVLFy FOSRa FOLFa EVSRa EVLFa {
	tostring ub`v', gen(t2) force usedisplayformat
    tostring lb`v', gen(t1) force usedisplayformat
    gen CI`v'="\scriptsize{["+t1+", "+t2+"]}"
    drop t1 t2	
}

keep CI*

sa "$dataAnalysis/loss_average_CI.dta",replace


u `ef1',clear

forv z=2/$REPS {
	append using `ef`z''
}

foreach v in eff prc chc fis car {
	egen lb`v' = pctile(`v'),p(2.5)
	egen ub`v' = pctile(`v'),p(97.5) 
*	foreach z in y {
*		egen lb`z'`v' = pctile(`z'`v'),p(2.5) 
*		egen ub`z'`v' = pctile(`z'`v'),p(97.5)
*	}
}
foreach v in prc chc fis car {
	egen lbp`v' = pctile(p`v'),p(2.5)
	egen ubp`v' = pctile(p`v'),p(97.5) 
}


keep if _n==1
keep lb* ub*

format lb* ub* %9.2f

*foreach v in eff prc chc fis car yeff yprc ychc yfis ycar pprc pchc pfis pcar {
foreach v in eff prc chc fis car pprc pchc pfis pcar {
	tostring ub`v', gen(t2) force usedisplayformat
    tostring lb`v', gen(t1) force usedisplayformat
    gen CI`v'="\scriptsize{["+t1+", "+t2+"]}"
    drop t1 t2	
}

keep CI*

sa "$dataAnalysis/efficiency_cost_CI.dta",replace


