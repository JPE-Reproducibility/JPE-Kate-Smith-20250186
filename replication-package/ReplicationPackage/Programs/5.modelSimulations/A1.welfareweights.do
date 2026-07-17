u "$dataAnalysis/psi.dta",clear

su psi
global psi "`r(mean)'"

u "$dataAnalysis/observedpolicy.dta",clear

su EVSR [aw=hhw],d
local EVm=`r(p50)'

su inc if inc_p==25 
local linc = `r(max)'
su inc if inc_p==75 
local hinc = `r(max)'

gen AW1=(1/$psi)*(exp($psi*(100*`EVm'/`linc'))-1)/`EVm'
gen AW2=(1/$psi)*(exp($psi*(100*`EVm'/`hinc'))-1)/`EVm'
gen r = AW1/AW2
su r
drop AW1 AW2 r

su inc if inc_p==50 
local incm = `r(max)'

su EVSR [aw=hhw],d
local lEV=`r(p25)'
local uEV=`r(p75)'

gen AW1=(1/$psi)*(exp($psi*(100*`lEV'/`incm'))-1)/`lEV'
gen AW2=(1/$psi)*(exp($psi*(100*`uEV'/`incm'))-1)/`uEV'
gen r = AW2/AW1
su r
drop AW1 AW2 r


u "$dataAnalysis/observedpolicy.dta",clear

keep EVSR inc

gen loss=EVSR/inc
centile loss,centile(99.9)
drop if loss>`r(c_1)'

drop if EV<0

foreach v in 100 50 25 10 5 4 3 2 1 {
	gen ls`v' = ((0.1*${psi}*EV)/log(${psi}*EV*(`v'/100)+1))
	gen lsh`v'= 0.1*(1/(`v'/100))
	}
replace inc=inc/1000
sort ls1

keep inc EVSR ls* lsh*

sa "$dataAnalysis/welfareweights.dta",replace