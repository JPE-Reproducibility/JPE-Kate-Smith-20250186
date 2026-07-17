
u "$dataAnalysis/psi.dta",clear

su psi
global psi "`r(mean)'"

u "$dataAnalysis/counterfactualpolicy.dta",clear

keep if s==0

collapse (mean) EVFB inc [iw=hhw]

replace EVFB=(EVFB/inc)*100

su EVFB
global effb "`r(mean)'"

insheet using "$dataAnalysisIn/counterfactualpolicy_incadj.raw",clear

rename v1  id
rename v2  t
rename v3  pLF
rename v4  tFB
rename v5  EVFB
rename v6  s
rename v7  tSTe
rename v8  tSTs
rename v9  qSTe
rename v10 qSTs
rename v11 EVSTe
rename v12 EVSTs
drop v13

replace s= s*100

merge m:1 id t using "$dataRaw/estimationdata_merge.dta",keepusing(yeartax inc_dec_taxyr eexp_dec prepay inc_p_taxyr inc_taxyr)
keep if _m==3
drop _m

merge m:1 yeartax inc_dec_taxyr eexp_dec prepay using "$dataRaw/population_weights.dta"
keep if _m==3
drop _m

bysort s inc_dec_taxyr eexp_dec prepay: gen Ns = _N
gen weight = Npop/Ns

egen base = sum(weight),by(s)
replace weight = weight/base

egen hhw=sum(weight),by(id s)
replace weight=weight/hh

collapse (mean) EV* inc_taxyr (sum) hhw [iw=we],by(id s)

replace inc=inc/100

gen loss=EVSTe/inc
centile loss,centile(99.9)
gen cap=`r(c_1)'
drop loss

foreach v in STe STs {
	gen loss`v' = (EV`v'/inc)
	gen W`v' =(1/$psi)*(exp($psi*min((EV`v'/inc),cap))-1)
	gen capped`v' = (EV`v'/inc)>cap
}

su capped*

collapse (mean) W* loss* EV*  inc [iweight=hhw],by(s)

merge 1:1 s using "$dataAnalysis/optimal_frontier.dta",keepusing(optimalSTe optimalSTs)
drop _m

foreach v in STe STs {
	rename optimal`v' optimal`v'b
}

foreach v in STe STs {
	replace W`v'=(1/$psi)*log($psi*W`v'+1)
	egen min = min(W`v')
	gen optimal`v'=abs(min-W`v')<1e-6
	drop min
	replace EV`v'=(EV`v'/inc)
	gen un`v'=$effb
	gen ec`v'=EV`v'-$effb
	gen tar`v'=W`v'-EV`v'
}

gen     p = 6 if _n==1
replace p = 7 if _n==2
replace p = 8 if _n==3
replace p = 9 if _n==4

foreach x in un ec tar {
	gen `x'=.
}
local i=1
foreach v in STe STs {
	foreach x in un ec tar {
		su `x'`v' if  optimal`v'b==1
		replace `x'=`r(mean)' if _n==`i'
	}
	local i=`i'+1
	foreach x in un ec tar {
		su `x'`v' if  optimal`v'==1
		replace `x'=`r(mean)' if _n==`i'
	}
	local i=`i'+1
}

preserve

keep if _n<5
keep un ec tar p

append using "$dataAnalysis/optimal_decomp.dta"

drop if p==1|p==3|p==5

gen menu = p==4|p==8|p==9 
label define menu 0 "Unlabelled (universal)" 1 "Prop. to E"
label values menu menu

gen     pp = 1 if p==2|p==4
replace pp = 2 if p==6|p==8
replace pp = 3 if p==7|p==9
drop p

lab def pp 1 "Baseline" 2 "Inc. transfers" 3 "+re-optimise" 
lab val pp pp

sa "$dataAnalysis/optimal_decomp_incadj.dta",replace

restore

foreach v in STe STs {
	replace ec`v'=-ec`v'
	replace tar`v'=-tar`v'
}

keep s tar* ec* optimal*

sa "$dataAnalysis/optimal_frontier_incadj.dta",replace