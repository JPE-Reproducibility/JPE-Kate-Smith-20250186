u "$dataAnalysis/psi.dta",clear

su psi
global psi "`r(mean)'"

local z = 0
foreach pi in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 $psi  {
	
	local z = `z'+1
	u "$dataAnalysis/counterfactualpolicy.dta",clear
		
	replace inc=inc/100

	gen loss=EVSR/inc
	centile loss,centile(99.9)
	gen cap=`r(c_1)'
	drop loss

	foreach v in SR STe STy STs STys {
		gen loss`v' = (EV`v'/inc)
		gen W`v' =(1/`pi')*(exp(`pi'*min((EV`v'/inc),cap))-1)
	}

	collapse (mean) W* inc [iweight=hhw],by(s)

	foreach v in SR STe STy STs STys {
		replace W`v'=(1/`pi')*log(`pi'*W`v'+1)
		egen min = min(W`v')
		gen optimal`v'=abs(min-W`v')<1e-6
		drop min
	}

	gen p     = 1 if _n==1
	replace p = 2 if _n==2
	replace p = 3 if _n==3
	replace p = 4 if _n==4
	replace p = 5 if _n==5
	lab def  p 1 "(s,T,L=1)" 2 "(s,T,L=0)" 3 "(s,(T/Y),L=0)" 4 "(s,(TxE),L=0)" 5 "(s,(TxE/Y),L=0)"
	lab val p p

	gen W=.
	gen ops=.

	local i=1
	foreach v in SR STe STy STs STys {
		su W`v' if  optimal`v'==1
		replace W=`r(mean)' if _n==`i'
		
		su s if  optimal`v'==1
		replace ops=`r(mean)' if _n==`i'
		local i=`i'+1
	}

	keep if _n<6
	keep W p ops

	su W if p==1
	replace W=100*(W/`r(mean)')

	gen psi = `pi'
	tempfile d`z'
	sa `d`z''
}

u `d1'

forv x=2/`z' {
	append using `d`x''
}

sort psi

gen cpsi = $psi

sa "$dataAnalysis/socialpreferences.dta",replace


local z = 0
foreach pi in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 $psi  {
	
	local z = `z'+1
	u "$dataAnalysis/counterfactualpolicy.dta",clear
		
	replace inc=inc/100

	gen loss=EVSR/inc
	centile loss,centile(99.9)
	gen cap=`r(c_1)'
	drop loss

	foreach v in SR STe STy STs STys {
		gen loss`v' = (EV`v'/inc)
		gen W`v' =(1/`pi')*(exp(`pi'*min((EV`v'/inc),cap))-1)
	}

	collapse (mean) W* inc [iweight=hhw],by(s)

	foreach v in SR STe STy STs STys {
		replace W`v'=(1/`pi')*log(`pi'*W`v'+1)
		egen min = min(W`v')
		gen optimal`v'=abs(min-W`v')<1e-6
		drop min
	}

	gen p     = 1 if _n==1
	replace p = 2 if _n==2
	replace p = 3 if _n==3
	replace p = 4 if _n==4
	replace p = 5 if _n==5
	lab def  p 1 "(s,T,L=1)" 2 "(s,T,L=0)" 3 "(s,(T/Y),L=0)" 4 "(s,(TxE),L=0)" 5 "(s,(TxE/Y),L=0)"
	lab val p p

	gen W=.

	su WSR if optimalSR==1
	replace W=`r(mean)' if _n==1
		
	local i=2
	foreach v in STe STy STs STys {
		su W`v' if  s==0
		replace W=`r(mean)' if _n==`i'
		local i=`i'+1	
	}

	keep if _n<6
	keep W p 

	su W if p==1
	replace W=100*(W/`r(mean)')

	gen psi = `pi'
	tempfile d`z'
	sa `d`z''
}

u `d1'

forv x=2/`z' {
	append using `d`x''
}

sort psi

gen cpsi = $psi

sa "$dataAnalysis/socialpreferences_nosub.dta",replace


u "$dataAnalysis/observedpolicy.dta",clear

keep EVSR inc hhw

gen loss=EVSR/inc
centile loss,centile(99.9)
drop if loss>`r(c_1)'

drop if EV<0

gen t = (1/inc)
su t [iw=hhw]
local sl =`r(mean)'
drop t


foreach v in 1 2 3 4 5 10 25 50 100 {
	local y=100*`v'
	gen w`v' = 100/(`sl'*`y'^2)
	gen ls`v' = (1/1000)*((100*${psi}*EV)/(`sl'*log(${psi}*EV*w`v'+1)))^(1/2)
	gen lsh`v'= (1/1000)*(100/(`sl'*w`v'))^(1/2)
	}
replace inc=inc/1000
sort ls1

keep inc EVSR ls* lsh* w*

u "$dataAnalysis/counterfactualpolicy.dta",clear

keep if s==0

collapse (mean) EVFB inc [iw=hhw]

replace EVFB=(EVFB/inc)*100

su EVFB
global effb "`r(mean)'"

u "$dataAnalysis/counterfactualpolicy.dta",clear
	
replace inc=inc/100
	
gen t = (1/inc)
su t [iw=hhw]
gen g=(1/`r(mean)')*(1/inc)
su g [iw=hhw]
drop t

gen loss=(EVSR/inc)
centile loss,centile(99.9)
gen cap=`r(c_1)'
drop loss

foreach v in SR STe STy STs STys {
	gen loss`v' = (EV`v'/inc)
	gen W`v' =(1/${psi})*g*(exp(${psi}*min((EV`v'/inc),cap))-1)
	gen capped`v' = (EV`v'/inc)>cap
}

su capped*

collapse (mean) W* loss* EV* inc [iweight=hhw],by(s)

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
sa "$dataAnalysis/optimal_decomp_incweight.dta",replace

restore 

foreach v in SR STe STy STs STys {
	replace ec`v'=-ec`v'
	replace tar`v'=-tar`v'
}


sa "$dataAnalysis/optimal_frontier_incweight.dta",replace

