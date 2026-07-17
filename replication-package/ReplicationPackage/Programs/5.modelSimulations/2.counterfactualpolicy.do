
***************************************************
***Insheet data 
***************************************************

insheet using "$dataAnalysisIn/counterfactualpolicy.raw",clear

rename v1  id
rename v2  t
rename v3  pLF
rename v4  tFB
rename v5  EVFB
rename v6  s
rename v7  tSR
rename v8  tSTe
rename v9  tSTy
rename v10 tSTs
rename v11 tSTys
rename v12 qSR
rename v13 qST
rename v14 qSTe
rename v15 qSTy
rename v16 qSTs
rename v17 qSTys
rename v18 EVSR
rename v19 EVST
rename v20 EVSTe
rename v21 EVSTy
rename v22 EVSTs
rename v23 EVSTys
rename v24 tag
drop v25

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

sa "$dataAnalysis/counterfactualpolicy.dta",replace

***************************************************
***Infer social preferences
***************************************************

u "$dataAnalysis/counterfactualpolicy.dta",clear

gen loss  = 100*(EVSR/inc)

centile loss,centile(99.9)
replace loss=`r(c_1)' if loss>`r(c_1)'

global cap "`r(c_1)'"

keep s loss hhw

tempfile temp
sa `temp'

forv p=700/900 {

	local psi=(`p')/1000

	u `temp',clear

	gen W=(1/`psi')*(exp(`psi'*loss)-1)

	collapse (mean) W [iweight=hhw],by(s)

	replace W=(1/`psi')*log(`psi'*W+1)

	egen min = min(W)

	keep if abs(min-W)<1e-6
	
	gen psi=`psi'
	keep psi s
	
	tempfile temp`p'
	sa `temp`p''
	
}	

u `temp700'

forv z=701/900 {
	append using `temp`z''
}

su psi if s==39
global psi "`r(mean)'"

keep if s==39
collapse (mean) psi
keep psi

gen cap = $cap

sa "$dataAnalysis/psi.dta",replace

outsheet using "$dataAnalysis/psi.raw",comma non replace

***************************************************
***No efficiency cost baseline
***************************************************

u "$dataAnalysis/counterfactualpolicy.dta",clear

keep if s==0

collapse (mean) EVFB inc [iw=hhw]

replace EVFB=(EVFB/inc)*100

su EVFB
global effb "`r(mean)'"


***************************************************
***Efficiency-equity trade-off
***************************************************

u "$dataAnalysis/counterfactualpolicy.dta",clear
	
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
lab def  p 1 "Labelled" 2 "Unlabelled " 3 "Prop. to (1/Y)" 4 "Prop. to E" 5 "Prop. to (E/Y)"

lab val p p

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

sa "$dataAnalysis/optimal_decomp.dta",replace

restore 

foreach v in SR STe STy STs STys {
	replace ec`v'=-ec`v'
	replace tar`v'=-tar`v'
}

su ecSR tarSR if s>52
su ecSR tarSR if s==0

su unSR
su s WSR ecSR tarSR       if optimalSR==1
su s WSTe ecSTe tarSTe    if optimalSTe==1
su s WSTy ecSTy tarSTy    if optimalSTy==1
su s WSTs ecSTs tarSTs    if optimalSTs==1
su s WSTys ecSTys tarSTys if optimalSTys==1

keep s tar* ec* optimal*

sa "$dataAnalysis/optimal_frontier.dta",replace

foreach v in STe STy STs STys {
	su s if optimal`v'
	gen s`v' = `r(mean)'/100
}

keep if s==0
keep sSTe sSTy sSTs sSTys

outsheet using "$dataAnalysis/opts.raw",comma non replace


u "$dataAnalysis/optimal_frontier.dta",clear

keep if optimalSR==1
keep *SR
gen W=tarSR+ecSR  
su ecSR
local e=`r(mean)'
su tarSR
local t=`r(mean)'
su W
local w=`r(mean)'
local sl = (`w'-`t')/(-`e')


clear
set obs 121
gen ec = -(_n-1)/100
gen tr = `w'+`sl'*ec
gen bd=0

append using "$dataAnalysis/optimal_frontier.dta"

sa "$dataAnalysis/optimal_frontier_plus.dta",replace

