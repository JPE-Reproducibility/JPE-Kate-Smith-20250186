
u "$dataProcess/preestimationdata", clear

* set number interactions, Engel curve order and convergence criterion
global ndem_y 10
global ndem_p 10
global npowers 2
global npowers_int 1
global nxinstr 1
* set a convergence criterion and choose whether or not to base it on parameters
global conv_crit "0.000000001"
scalar conv_param=1
scalar conv_y=0

*data labeling conventions:
* budget shares: s1, s2
* prices: p1, p2
* log total expenditures: x
* log total expenditure instrument: xinst
* implicit utility: y
* demographic interactions: z1 to ndem

g s1=s_ener
g s2=s_cons

g p1=p_ener
g p2=p_cons

*demographic characteristics
g z1 = prepay
forv z=2/10 {
	g z`z'=eexp_dec==`z'
}
forv z=2/10 {
	local x=`z'-1
	g ps`x'=sexp_dec==`z'
}
forv z=2/14 {
	gen rg`z'=region==`z'
}

gen ddr=(year==2022 & month>9) | (year==2023 & month<4)
gen ddpr=(year==2023 & month>3)

g r1=rebates*prepay
forv z=2/12 {
	gen mm`z'=month==`z'
}
forv x=2/10 {
	gen r`x' = rebates*prepay*z`x'
}
foreach v in  tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain tminlesstmax2 {
	su `v'
	replace `v'=(`v'-`r(mean)')/`r(sd)'
}
*Constant shifters
global Cshift  "z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 wfh mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm9 mm10 mm11 mm12 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 ddr ddpr"
*Rebate shifters 
global Crebate "r1 r2 r3 r4 r5 r6 r7 r8 r9 r10"
*Engel curve shifters
global Yshift  "z1 z2 z3 z4 z5 z6 z7 z8 z9 z10"
*Price shifters
global Pshift  "z1 z2 z3 z4 z5 z6 z7 z8 z9 z10"

**Y interaction 
global zlist_y "$Yshift"
**P interactions
global zlist_p "$Pshift"
**Constant 
global zlist_c "$Cshift $Crebate"

* log expenditure
g x = log_x
* instrument for x 
gen xi1=log_inc

global xinstr "xi1"

global ndemY=$ndem_y
global ndemP=$ndem_p

global zlistC $zlist_c 
global zlistY $zlist_y
global zlistP $zlist_p

*Relative price
global nplist ""
g np=p1-p2	
global nplist "$nplist np"

*make pz interactions
global npzlist ""
forvalues k=1(1)$ndemP {
	g npz`k'=np`j'*z`k'	
	global npzlist "$npzlist npz`k'"
}

*make y_stone=x-p'w, and gross instrument, y_tilde=x-p'w^bar
g y_stone=x
forvalues num=1(1)2 {
	egen mean_s`num'=mean(s`num')	
}

*Make holdout sample
preserve
keep if year==2023 & month>6

save "$dataAnalysis/holdout.dta",replace
restore

drop if year==2023 & month>6

forvalues x=1(1)$nxinstr {
	g y_tilde`x'=xi`x'	
	forvalues num=1(1)2 {
		replace y_tilde`x'=y_tilde`x'-mean_s`num'*p`num'
	}
}

g y=y_stone
global ylist ""
global yzlist ""
global ynplist ""
forvalues j=1(1)$npowers {
	g y`j'=y^`j'
	global ylist "$ylist y`j'"
}
forvalues k=1(1)$ndemY {
  forvalues j=1(1)$npowers_int {	
	g y`j'z`k'=y`j'*z`k'
	global yzlist "$yzlist y`j'z`k'"
  }
}
g ynp=y*np
global ynplist "$ynplist ynp"

global yinstlist ""
global yzinstlist ""
global ynpinstlist ""
forvalues x=1(1)$nxinstr {
  g y_inst`x'=y_tilde`x'	
  forvalues j=1(1)$npowers {
	g y`j'_inst`x'=y_inst^`j'
	global yinstlist "$yinstlist y`j'_inst"
  }
  forvalues k=1(1)$ndemY {
   forvalues j=1(1)$npowers_int {	
	g y`j'z`k'_inst`x'=y`j'_inst*z`k'
	global yzinstlist "$yzinstlist y`j'z`k'_inst"
   }
  }
  g ynp_inst`x'=y_inst*np 
  global ynpinstlist "$ynpinstlist ynp_inst"

}


*two step estimation:  step 1) get a pre-estimate to construct the intrument, step 2) use the instrument to estimate the model

*step 1: get a pre-estimate to create the instrument:
*run two stage least squares on the model with py, pz or yz interactions, and then iterate to convergence,
* constructing y=(y_stone+0.5*p'Bp)/(1-0.5*p'Dp) at each iteration

replace y=y_stone
g y_backup=y_stone
g y_old=y_stone
g y_change=0
scalar crit_test=1
scalar iter=0
while crit_test>$conv_crit {
	scalar iter=iter+1
	quietly ivreg s1 $zlistC $nplist $npzlist  ( $ylist $ynplist $yzlist=$yinstlist $ynpinstlist $yzinstlist) 
	if (iter>1) {		
		matrix params_old=params
	}
	matrix params=e(b)
	quietly replace y_old=y
	quietly replace y_backup=y
	
	predict s1_y,xb
	
	quietly replace y =_b[np]
	if $ndemP>0 {
		forv x=1/$ndemP {
			quietly replace y = y+ _b[npz`x']*z`x'
		}
	}
	quietly replace y=(1/(1-0.5*_b[ynp]*np^2))*(x-p2-s1_y*np+0.5*y*np^2)	
	forvalues j=1(1)$npowers {
		quietly replace y`j'=y^`j'
	}	
	
	forvalues j=1(1)$ndemY {
	  forvalues k=1(1)$npowers_int {
		quietly replace y`k'z`j'=y`k'*z`j'
	  }
	} 
	quietly replace ynp=y*np	
	quietly drop s1_y

	if (iter>1 & conv_param==1) {		
		matrix params_change=(params-params_old)
		matrix crit_test_mat=(params_change*(params_change'))
		svmat crit_test_mat, names(temp)
		scalar crit_test=temp
		drop temp
	}
	quietly replace y_change=abs(y-y_old)
	quietly summ y_change
	if(conv_y==1) {
		scalar crit_test=r(max)
	}
	display "iteration " iter 
	scalar list crit_test 
	summ y_change y_stone y y_old 
}

*now, create the instrument, and its interactions yp and yz
forv x=1(1)$nxinstr {
	quietly replace y_inst`x' =_b[np]
	if $ndemP>0 {
		forv j=1/$ndemP {
			quietly replace y_inst`x' = y_inst`x'+ _b[npz`j']*z`j'
		}
	}
	quietly replace y_inst`x'=(1/(1-0.5*_b[ynp]*np^2))*(y_tilde`x'+0.5*y_inst`x'*np^2)
	forvalues j=1(1)$npowers {
	  quietly replace y`j'_inst`x'=y_inst`x'^`j'
	}	
    forvalues k=1(1)$npowers_int {
	  replace ynp_inst`x'=y_inst`x'*np
    } 	
	forvalues j=1(1)$ndemY {
	  forvalues k=1(1)$npowers_int {
		 replace y`k'z`j'_inst`x'=y`k'_inst`x'*z`j'
	  }
	} 
}


*with instrument in hand, run two stage least squares on the model, and then iterate to convergence
replace y_old=y
replace y_change=0
scalar iter=0
scalar crit_test=1
while crit_test>$conv_crit {
	scalar iter=iter+1
	quietly ivreg s1 $zlistC $nplist $npzlist ( $ylist $ynplist $yzlist=$yinstlist $ynpinstlist $yzinstlist)  
	if (iter>1) {		
		matrix params_old=params
	}
	matrix params=e(b)
	quietly replace y_old=y
	quietly replace y_backup=y
	
	predict s1_y,xb
	quietly replace y =_b[np]
	if $ndemP>0 {
		forv x=1/$ndemP {
			quietly replace y = y+ _b[npz`x']*z`x'
		}
	}
	quietly replace y=(1/(1-0.5*_b[ynp]*np^2))*(x-p2-s1_y*np+0.5*y*np^2)
	forvalues j=1(1)$npowers {
		quietly replace y`j'=y^`j'
	}	
	
	forvalues j=1(1)$ndemY {
	  forvalues k=1(1)$npowers_int {
		quietly replace y`k'z`j'=y`k'*z`j'
	  }
	} 
	quietly replace ynp=y*np	
	quietly drop s1_y
	
	if (iter>1 & conv_param==1) {		
		matrix params_change=(params-params_old)
		matrix crit_test_mat=(params_change*(params_change'))
		svmat crit_test_mat, names(temp)
		scalar crit_test=temp
		drop temp
	}
	quietly replace y_change=abs(y-y_old)
	quietly summ y_change
	if(conv_y==1) {
		scalar crit_test=r(max)
	}
	display "iteration " iter 
	scalar list crit_test 
	summ y_change y_stone y y_old
}

log using "$dataAnalysis/startingvalues.log",replace
ivreg s1 $zlistC $nplist $npzlist  ( $ylist $ynplist $yzlist=$yinstlist $ynpinstlist $yzinstlist) ,cluster(id) 
log close

*************
**Outsheet coefficient starting values
*************
preserve
gen title = ""
gen coef = .
gen se = .
replace title = "constant" if _n==1
replace coef = _b[_cons] if _n==1
replace se   = _se[_cons] if _n==1
local l = 2
foreach v in $zlistC $ylist $yzlist $nplist $npzlist $ynplist {
	replace title = "`v'" if _n==`l'
	replace coef = _b[`v'] if _n==`l'
	replace se = _se[`v'] if _n==`l'
	local l = `l'+1
}


keep if coef!=.
keep title coef se
sa "$dataAnalysis/startingvalues.dta",replace

outsheet coef using "$dataAnalysis/startingvalues.raw",comma non replace

restore
sort id t

drop np-mean_s2  
drop y-y_change

sa "$dataAnalysis/estimationdata.dta",replace

*************
**Outsheet estimation data
*************

u "$dataAnalysis/estimationdata.dta",clear

egen hh = group(id)
sort id t

keep  hh t x p_e p_co $zlist_c s1 y_tilde
order hh t x p_e p_co $zlist_c s1 y_tilde

outsheet using "$dataAnalysis/estimationdata.raw",comma non replace

*************
**Outsheet for prediction verification
*************

u "$dataAnalysis/holdout.dta",clear

keep if year==2023& month>9

sort id t

keep  id t x p_e p_co $zlist_c
order id t x p_e p_co $zlist_c  

outsheet using "$dataAnalysis/holdoutdata.raw",comma non replace

u "$dataAnalysis/estimationdata.dta",clear

keep if year==2022& month>9

sort id t

keep  id t x p_e p_co $zlist_c
order id t x p_e p_co $zlist_c  

outsheet using "$dataAnalysis/insampledata.raw",comma non replace

*************
**Outsheet for price effect verification
*************
u "$dataAnalysis/estimationdata.dta",clear

**Hold real energy price at pre shock level
gen temp = p1 if (year==2021 & month>10) | (year==2022 & month<4)
egen p_cf = mean(temp),by(region)
drop temp

keep if year==2022 & (month>3&month<10)

sort eexp_dec inc_dec prepay id t
set seed 62
drawnorm dr
sort eexp_dec inc_dec prepay dr
by eexp_dec inc_dec prepay: keep if _n<1001 
drop dr

sort id t

keep  id t x p_e p_co $zlist_c p_cf
order id t x p_e p_co $zlist_c p_cf 

outsheet using "$dataAnalysis/priceeffectsdata.raw",comma non replace

*************
**Outsheet for flypaper prediction verification
*************

u "$dataAnalysis/estimationdata.dta",clear

egen hh = group(id)
sort id t

keep  hh t x p_e p_co $zlist_c s1 y_tilde
order hh t x p_e p_co $zlist_c s1 y_tilde

su r1 if r1==1
local Ns = `r(N)'
disp `Ns'

set seed 25
drawnorm dr
sort r1 dr
by r1: gen n = _n

gen ho = n<int(0.25*`Ns') & r1==1

preserve

keep if ho==0

keep  hh t x p_e p_co $zlist_c s1 y_tilde
order hh t x p_e p_co $zlist_c s1 y_tilde

outsheet using "$dataAnalysis/flyvalid_estimationdata.raw",comma non replace

restore
preserve

keep if ho==1

keep  hh t x p_e p_co $zlist_c s1 y_tilde
order hh t x p_e p_co $zlist_c s1 y_tilde

outsheet using "$dataAnalysis/flyvalid_holdoutdata1.raw",comma non replace

restore

keep if ho==1

foreach v in $Crebate {
	replace `v'=0
}

keep  hh t x p_e p_co $zlist_c s1 y_tilde
order hh t x p_e p_co $zlist_c s1 y_tilde

outsheet using "$dataAnalysis/flyvalid_holdoutdata2.raw",comma non replace

*************
**Outsheet for Engel curve
*************
u "$dataAnalysis/estimationdata.dta",clear

keep if year==2022 & (month>3&month<10)

sort eexp_dec inc_dec prepay id t
set seed 62
drawnorm dr
sort eexp_dec inc_dec prepay dr
by eexp_dec inc_dec prepay: keep if _n<1001 
drop dr


foreach v in p_e p_c tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 mm4 mm5 mm6 mm7 mm8 mm9 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 {
	egen temp = mean(`v')
	replace `v'=temp
	drop temp
}
egen mean = mean(z1)
egen meang = mean(z1),by(eexp_dec)
replace z1=($pp_shr/mean)*meang
drop mean*
foreach v in ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 {
	egen meang = mean(`v'),by(eexp_dec)
	replace `v'=meang 
	drop meang
}

sort id t

keep  id t x p_e p_co $zlist_c
order id t x p_e p_co $zlist_c

outsheet using "$dataAnalysis/engelcurvesdata.raw",comma non replace

