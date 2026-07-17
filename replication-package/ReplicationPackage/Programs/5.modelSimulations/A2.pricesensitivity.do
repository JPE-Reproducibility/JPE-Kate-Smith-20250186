
u "$dataAnalysis/psi.dta",clear

su psi
global psi "`r(mean)'"

su cap
global cap "`r(mean)'"

insheet using "$dataAnalysisIn/sensitivity${s}.raw",clear

rename v1  id
rename v2  t
rename v3  pLF
rename v4  tFB
rename v5  EVFB
rename v6  FOSR
rename v7  s
rename v8  tSR
rename v9  tSTe
rename v10  tSTy
rename v11 tSTs
rename v12 tSTys
rename v13 qSR
rename v14 qST
rename v15 qSTe
rename v16 qSTy
rename v17 qSTs
rename v18 qSTys
rename v19 EVSR
rename v20 EVST
rename v21 EVSTe
rename v22 EVSTy
rename v23 EVSTs
rename v24 EVSTys
rename v25 tag
drop v26

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

collapse (mean) FO* EV* inc_taxyr (sum) hhw [iw=we],by(id s)
 
su EVSR FOSR [iw=hhw]
drop FOSR 

sa "$dataAnalysis/sensitivity${s}.dta",replace

keep if s==0

collapse (mean) EVFB inc [iw=hhw]

replace EVFB=(EVFB/inc)*100

su EVFB
global effb "`r(mean)'"

u "$dataAnalysis/sensitivity${s}.dta",clear
	
replace inc=inc/100

gen loss=EVSR/inc
centile loss,centile(99.9)
gen cap=`r(c_1)'
drop loss

foreach v in SR STe STy STs STys {
	gen loss`v' = (EV`v'/inc)
	gen W`v' =(1/$psi)*(exp($psi*min((EV`v'/inc),cap))-1)
	gen capped`v' = (EV`v'/inc)>cap
}

su capped*

collapse (mean) W* loss* EV*  inc [iweight=hhw],by(s)

foreach v in SR STe STy STs STys {
	replace W`v'=(1/$psi)*log($psi*W`v'+1)
	egen min = min(W`v')
	gen optimal`v'=abs(min-W`v')<1e-6
	drop min
	replace EV`v'=(EV`v'/inc)
	gen un`v'=$effb
	gen ec`v'=EV`v'-$effb
	gen tar`v'=W`v'-EV`v'
}


gen p     = 1 if _n==1
replace p = 2 if _n==2
replace p = 3 if _n==3
replace p = 4 if _n==4
replace p = 5 if _n==5
*lab def  p 1 "(s,t,L=1)" 2 "(s,t,L=0)" 3 "(s,(t/Y),L=0)" 4 "(s,(txE),L=0)" 5 "(s,(txE/Y),L=0)"
*lab val p p

foreach x in un ec tar {
	gen `x'=.
}
local i=1
foreach v in SR STe STy STs STys {
	foreach x in un ec tar {
		su `x'`v' if  optimal`v'==1
		replace `x'=`r(mean)' if _n==`i'
	}
	local i=`i'+1
}

preserve

keep if _n<6
keep un ec tar p

sa "$dataAnalysis/optimal_decomp_s${s}.dta",replace

restore 

foreach v in SR STe STy STs STys {
	replace ec`v'=-ec`v'
	replace tar`v'=-tar`v'
}

keep s tar* ec* optimal*

sa "$dataAnalysis/optimal_frontier_s${s}.dta",replace

if "$s"=="2" {
	u "$dataAnalysis/optimal_decomp_s1.dta",clear
	
	replace p = p+5
	
	tempfile temp1
	sa `temp1'
	
	u "$dataAnalysis/optimal_decomp_s2.dta",clear	

	replace p = p+10
	
	append using "$dataAnalysis/optimal_decomp.dta"
	append using `temp1'
	
	gen     menu = 1 if p==1|p==6|p==11 
	replace menu = 2 if p==2|p==7|p==12 
	replace menu = 3 if p==3|p==8|p==13 
	replace menu = 4 if p==4|p==9|p==14 
	replace menu = 5 if p==5|p==10|p==15  	
 
    label define menu 1 "Labelled" 2 "Unlabelled" 3 "Prop. to E" 4 "Prop. to (1/Y)" 5 "Prop. to (E/Y)" 
    label values menu menu
	
	gen     pp = 1 if p<6
    replace pp = 2 if p>5 & p<11
    replace pp = 3 if p>10
    drop p

	lab def pp 1 "Baseline" 2 "50% less elastic" 3 "50% more elastic" 
	lab val pp pp
	
	sa "$dataAnalysis/optimal_decomp_s.dta",replace	
}


