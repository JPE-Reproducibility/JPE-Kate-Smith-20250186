

****Insheet policy simulations

insheet using "$dataAnalysisIn/observedpolicy.raw",clear

rename v1  id
rename v2  t
rename v3  weight
rename v4  s
rename v5  R
rename v6  q0
rename v7  qLF
rename v8  qSR
rename v9  qST
rename v10 pS
rename v11 gt
rename v12 FOSR
rename v13 FOLF
rename v14 EVSR
rename v15 EVLF
rename v16 CVLF
rename v17 EVTt
rename v18 EVTl
rename v19 EVST
rename v20 EVSTe
rename v21 tag
drop v22

tab tag
drop tag

replace pS=exp(pS)

preserve

su pS
gen SC=(s/(1-s))*qSR*pS
gen TC=R
gen EX=$E*`r(mean)'*(qSR-qLF)

gen RNB=(s/(1-s))*qLF*pS+R

collapse (mean) SC TC EX RNB [iw=w]

foreach v in SC TC EX RNB {
	replace `v'=`v'*$S
}

gen RB=SC+TC+EX
su RB SC TC EX RNB

restore

preserve

keep if gt!=0

gen xSR=qSR*pS
gen xST=qST*pS

collapse (mean) gt xSR xST EVSR EVST [iw=w]

restore

egen base = sum(weight)
replace weight = weight/base

egen hhw=sum(weight),by(id)
replace weight=weight/hhw

merge 1:1 id t using "$dataRaw/estimationdata_merge.dta",keepusing(inc_p inc_t inc_d eexp_d mtot_out_nondurab_dec tot_out_nondurab_noreb)
keep if _m==3
drop _m
rename inc_t inc

preserve
rename inc_dec_taxyr inc_dec
merge m:1 inc_dec mtot_out_nondurab_dec eexp_dec  using "$dataProcess/lcfsdata_incAHC"
drop _m
gen incAHC = incAHC_over_nondur_pred*tot_out_nondurab_noreb
replace incAHC=100 if incAHC<100

foreach v in SR LF 0 {
	replace q`v'=q`v'*pS
}

collapse (mean)  q0 qLF qSR s incAHC R hhw [iw=weight],by(id inc_p)

gen shLF=(qLF/(1-s))/incAHC
gen shSR=qSR/(incAHC+R)
gen shFOLF=(q0/(1-s))/incAHC
gen shFOSR=q0/(incAHC+R)

foreach v in LF SR FOLF FOSR {
	gen ep`v'=sh`v'>0.1
}
collapse (mean) ep* [iw=hhw]

foreach v in LF SR FOLF FOSR {
	replace ep`v'=ep`v'*$HH
	format ep`v' %9.1f
    tostring ep`v', gen(t) force usedisplayformat
    gen ep`v'_s=t+"m"
	drop t
}
keep *_s

sa "$dataAnalysis/energypoverty.dta",replace

restore

collapse (mean)  FO* EV* CV inc hhw [iw=weight],by(id inc_p)

sa "$dataAnalysis/observedpolicy.dta",replace


********************************
***Loss distribution (monetary) 
********************************

u "$dataAnalysis/observedpolicy.dta",clear

su EVLF CVLF EVSR [aw=hhw]
su EVLF if inc_p<=20 [aw=hhw],d
su EVLF if inc_p>80 [aw=hhw],d

#delimit ;
collapse (mean)
mEVLF=EVLF 
mEVSR=EVSR 
(p10) p10EVSR=EVSR p10EVLF=EVLF
(p25) p25EVSR=EVSR p25EVLF=EVLF 
(p50) p50EVSR=EVSR p50EVLF=EVLF
(p75) p75EVSR=EVSR p75EVLF=EVLF
(p90) p90EVSR=EVSR p90EVLF=EVLF 
[iw=hhw],by(inc_p);
#delimit cr

sa "$dataAnalysis/loss_level.dta",replace

***********************************
***Loss distribution (% of income)  
***********************************

u "$dataAnalysis/observedpolicy.dta",clear
  
foreach v in LF SR {
	replace EV`v'=(EV`v'/inc)*100
}  
su EVLF [aw=hhw],d 
su EVLF if inc_p==10 [aw=hhw]
su EVLF if inc_p==90 [aw=hhw] 
su EVLF if inc_p<=10 [aw=hhw],d

su EVSR [aw=hhw],d 
su EVSR if inc_p==10 [aw=hhw]
su EVSR if inc_p==90 [aw=hhw]
  
#delimit ;
collapse (mean) 
mEVLF=EVLF 
mEVSR=EVSR 
(p10) p10EVSR=EVSR p10EVLF=EVLF
(p25) p25EVSR=EVSR p25EVLF=EVLF 
(mean) p50EVSR=EVSR p50EVLF=EVLF
(p75) p75EVSR=EVSR p75EVLF=EVLF
(p90) p90EVSR=EVSR p90EVLF=EVLF 
[iw=hhw],by(inc_p);
#delimit cr

sa "$dataAnalysis/loss_proportional.dta",replace


***********************************
***Average losses
***********************************

u "$dataAnalysis/observedpolicy.dta",clear

foreach v in EVLF EVSR FOLF FOSR {
	gen `v'y=(`v'/inc)*100
}  

collapse (mean) EVLF* EVSR* FOSR* FOLF* inc [iw=hhw]

foreach v in EVLF EVSR FOSR FOLF {
	gen `v'a=`v'*$S
}

foreach v in EVLF EVSR FOSR FOLF {	
	format `v' `v'y  `v'a %9.2f 	
}

foreach v in EVLF EVSR FOSR FOLF {
		tostring `v'y,gen(`v'y_s) usedisplay force
		replace `v'y_s = `v'y_s+"\%"	
}


sa "$dataAnalysis/loss_average.dta",replace

***********************************
***Efficiency costs
***********************************

u "$dataAnalysis/observedpolicy.dta",clear

collapse (mean) EVSR EVLF EVTt EVTl EVST EVSTe inc [iw=hhw]

foreach v in EVSR EVLF EVTt EVTl EVST EVSTe inc  {
	replace `v'=`v'*$S
}

gen eff=EVSR-EVTt

gen prc=EVSTe-EVTl
gen chc=EVSR-EVST
gen fis=EVST-EVSTe
gen car=EVTl-EVTt

format eff prc chc fis car  %9.2f 


foreach v in prc chc fis car {
	gen p`v'=(`v'/eff)*100
	format p`v' %9.2f 
	tostring p`v',gen(p`v'_s) usedisplay force
	replace p`v'_s = "("+p`v'_s+"\%)"

}

sa "$dataAnalysis/efficiency_cost.dta",replace

