clear

capture log close

global startyear = 2001
global startyearplusone = $startyear + 1 
global endyear  = 2021 

/**********DEMOGRAPHICS************/

/*get equivalence scale*/ 

forvalues i = $startyear / $endyear {
	use "$dataLCFS/Demographics/fesdemo`i'.dta", clear
	bys data year hhref buno: gen bupersno=_n
	drop firinbu
	gen firinbu=bupersno==1
	for Q in num 1/9: qui replace agekidQ=. if numtukid<Q

	for Y in num 1/9: gen tu0kY = agekidY==0
	for Y in num 1/9: gen tu1kY = agekidY==1
	for Y in num 1/9: gen tu2kY = agekidY==2
	for Y in num 1/9: gen tu3kY = agekidY==3
	for Y in num 1/9: gen tu4kY = agekidY==4
	for Y in num 1/9: gen tu5kY = agekidY==5
	for Y in num 1/9: gen tu6kY = agekidY==6
	for Y in num 1/9: gen tu7kY = agekidY==7
	for Y in num 1/9: gen tu8kY = agekidY==8
	for Y in num 1/9: gen tu9kY = agekidY==9
	for Y in num 1/9: gen tu10kY = agekidY==10
	for Y in num 1/9: gen tu11kY = agekidY==11
	for Y in num 1/9: gen tu12kY = agekidY==12
	for Y in num 1/9: gen tu13kY = agekidY==13
	for Y in num 1/9: gen tu14kY = agekidY==14
	for Y in num 1/9: gen tu15kY = agekidY==15
	for Y in num 1/9: gen tu16kY = agekidY==16
	for Y in num 1/9: gen tu17kY = agekidY==17
	for Y in num 1/9: gen tu18kY = agekidY==18

	for Z in num 0/18: egen ntukZ = rsum(tuZk1-tuZk9)
	for Z in num 0/18: replace ntukZ = 0 if firinbu==0
	drop tu*k*
	for Z in num 0/18: egen kZ = sum(ntukZ), by(datayear hhref year)
	drop *tu*k*
	gen youngkids=k0+k1+k2+k3+k4+k5+k6+k7+k8+k9+k10+k11+k12+k13
	gen oldkids  =k14+k15+k16+k17+k18
	keep if reltohoh==0
	gen numeqads=(.67+(numads-1)*.33)/.67
	gen numeqkids=(.2*youngkids+.33*oldkids)/.67
	gen kidsto16    = k0+k1+k2+k3+k4+k5+k6+k7+k8+k9+k10+k11+k12+k13+k14+k15
	gen kids16plus  = k16+k17+k18
	gen hheqsize=numeqads+numeqkids
	keep year datayear hhref hheqsize kidsto16 kids16plus
	tempfile equiv`i'
	save `equiv`i''
}

use `equiv$startyear', clear
forvalues i = $startyearplusone / $endyear {
	append using `equiv`i''
}
save "$dataProcess/equiv", replace





forval X = $startyear / $endyear { 
	use "$dataLCFS/Demographics/fesdemo`X'.dta", replace

	keep hhref datayear year week goregion numadmal numadfem numadRet numadern numhhkid kids0 - kids1718  agekid1-agekid7 tenure lfamtype washmach cenheat tv ncars nrooms age ageced empstat hours buno reltohoh sex popdens grosfac hhweight numpeeps firinhh

	/*could split north east and north west if we are willing to ignore cumbria*/
	recode goregion (1 2 = 1) (3 = 2) (4 = 3) (5 = 4) (6 8 = 5) (7 = 6) (9 = 7) (10 = 8) (11 = 9) (12 = 10), gen(region)
	label define newregion 1 "North" 2 "Yorks + Humbs" 3 "E. Mids" 4 "W. Mids" 5 "S. East + E. Ang" 6 "G. London" 7 "S. West" 8 "Wales" 9 "Scotland" 10 "N. Ireland"
	label values region newregion

	replace ageced  =  . if ageced==0
	gen dob         = year - age
	gen yrlefted    = dob + ageced
	gen csl         = (ageced <=14 & yrlefted < 1948) | (ageced <= 15 & yrlefted >= 1948 & yrlefted < 1973) | (ageced <= 16 & yrlefted >= 1973)
	gen alev        = ageced < 19 & csl == 0
	gen coll        = csl == 0 & alev == 0 & ageced ~= .
	gen highed      = alev == 1 | coll == 1
	drop dob yrlefted alev coll csl ageced
	egen temp = mean(age), by(hhref year week)
	gen meanage = temp
	drop temp
	gen temp = age*(reltohoh==0)
	*gen temp = age*(buno==1)
	egen agehead = max(temp),by(hhref year week)
	replace temp = ((age>=60 & sex==2)|(age>=65 & sex==1))*(reltohoh==0)
	egen penhead = max(temp),by(hhref year week)
	drop temp
	sort hhref buno
	qui by hhref buno : gen N= _N
	gen tusumage = agekid1+agekid2+agekid3 + agekid4 + agekid5 + agekid6 + agekid7
	gen temp = tusumage/N
	egen sumage = sum(temp), by(hhref year week)
	gen kidage = sumage/numhhkid
	replace kidage = 0 if kidage==.
	drop temp sumage tusumage agekid1-agekid7 kids0 - kids1718 N
	egen temp = mean(hours), by(hhref year week)
	replace hours = temp
	drop temp
	gen temp = highed*(reltohoh==0)
	egen headed = max(temp),by(hhref year week)
	drop temp
	egen temp = sum(highed), by(hhref year week)
	replace highed = temp
	drop temp
	gen temp = empstat*(reltohoh==0)
	egen heademp = sum(temp),by(hhref year week)
	drop temp
	gen empstat1 = empstat==1
	gen empstat2 = empstat==2
	gen empstat3 = empstat==3|empstat==4|empstat==6
	egen numempl  = sum(empstat1), by(hhref year week)
	egen numself  = sum(empstat2), by(hhref year week)
	egen numunemp = sum(empstat3), by(hhref year week)
	gen temp  = empstat*(reltohoh==0)
	egen emphead = max(temp),by(hhref year week)
	drop temp
	gen oocc    = tenure>=5 & tenure<=7
	gen pubrent = tenure<=2
	gen prrent  = tenure ==3|tenure==4|tenure==8
	gen lone    = lfamtype==2|lfamtype==4
	gen couple = lfamtype>=5 & lfamtype<=8
	gen exfam  = lfamtype==9|lfamtype==10
	gen month = int((week+3)/4)
	gen yrm = (year*100)+month
	tab month, gen(month)
	*Weights
	cap gen weighta=.
	replace weighta=hhweight if weighta==.
	gen weight=.
	replace weight=grosfac if data<2001
	replace weight=hhweight if data>=2001
	replace weight=int(weight*1000)
	gen male = sex==1

	*PENSIONER HOUSEHOLD TYPES
	gen pens = ((age>=60 & sex==2)|(age>=65 & sex==1))
	egen headbuno = max(reltohoh==0*(buno)), by(hhref datayear year)
	assert headbuno==1
	gen firstbu = buno==1
	gen peninfirstbu=pens*firstbu
	egen penhh = max(peninfirstbu), by(hhref year datayear)
	drop peninfirstbu firstbu headbuno
	egen anypen = max(pens), by(hhref year datayear)
	gen penother = penhh==1 & lfamtype~=1 & lfamtype ~=5
	gen pensingm = pens==1 & sex==1 & lfamtype==1
	gen pensingf = pens==1 & sex==2 & lfamtype==1
	gen temppencoup = pens==1 & lfamtype==5
	egen pencoup = max(temppencoup), by(hhref year datayear) /*note that a pensioner couple is defined to be one where at least one party is a pensioner*/
	
	egen age_oldest = max(age), by(hhref year datayear)
	gen oldestawoman_temp = age==age_oldest & sex==2
	egen oldestawoman = max(oldestawoman_temp), by(hhref year datayear)
	drop oldestawoman_temp

	drop temppen*
	gen famother = lfamtype~=1 & lfamtype ~=5
	gen famsingm = sex==1 & lfamtype==1
	gen famsingf = sex==2 & lfamtype==1
	gen tempfamcoup = lfamtype==5
	egen famcoup = max(tempfamcoup), by(hhref year datayear) /*note that a pensioner couple is defined to be one where at least one party is a pensioner*/
	keep if reltohoh==0
	*gen check= penother+pensingm+pensingf+pencoup
	*count if anypen~=check
	*if r(N)>0 stop
	label var penhh    "Pensioner Household"
	label var anypen   "Any Pensioner Present"
	label var pensingf "Pensioner Single - Female"
	label var pensingm "Pensioner Single - Male"
	label var pencoup  "Pensioner Couple"
	label var penother "Pensioner Other"
	label var famsingf "Family Type Single - Female"
	label var famsingm "Family Type Single - Male"
	label var famcoup  "Family Type Couple"
	label var famother "Family Type Other"

	gen famtype=.
	replace famtype=1 if famother==1
	replace famtype=2 if famsingm==1
	replace famtype=3 if famsingf==1
	replace famtype=4 if famcoup==1
	label define famtype 1 "Other" 2 "Single M" 3 "Single F" 4 "Couple"
	label values famtype famtype
	label var famtype "Family Type - Broad"

	gen newfam=.
	replace newfam=1 if lfamtype==1 & sex==1
	replace newfam=2 if lfamtype==1 & sex==2
	replace newfam=3 if lfamtype==2
	replace newfam=4 if lfamtype==5
	replace newfam=5 if lfamtype==6
	replace newfam=9 if lfamtype==4 | lfamtype==8 | lfamtype==10 | lfamtype==12 
	replace newfam=10 if lfamtype==3 | lfamtype==7 | lfamtype==9  | lfamtype==11 
	replace newfam=6 if pensingm==1 & numhhkid==0
	replace newfam=7 if pensingf==1 & numhhkid==0
	replace newfam=8 if pencoup==1 & numhhkid==0

	#delimit ;
	label define newfam 1 "Single Male" 2 "Single Female" 3 "Lone Parent" 4 "Couple, no kids"
	5 "Couple, with kids" 6 "Pen Single Male" 7 "Pen Single Female"
	8 "Pen Couple" 9 "Other, with kids" 10 "Other no kids";
	#delimit cr
	label values newfam newfam
	label var newfam "Family Type - Narrow"


	*TENURE TYPES
	gen     housingten = 1 if tenure==1|tenure==2
	replace housingten = 2 if tenure==3|tenure==4|tenure==8
	replace housingten = 3 if tenure==5|tenure==6
	replace housingten = 4 if tenure==7

	label define htenval 1 "Rented - LA" 2 "Rented - Other" 3 "Owner-Still Mortgaged" 4 "Owned Outright"
	label values housingten htenval
	label var housingten "Housing Tenure"

	qui tab housingten, gen(ten)

	/*Age Groups WITHIN PENSIONER GROUPS**/
	recode agehead (min/59 = . ) (60/64 = 1 "60-64") (65/69 = 2 "65-69") (70/74 = 3 "70-74") (75/79 = 4 "75-79") (80/max = 5 "80+"), gen(agedum)
	qui tab agedum, gen(age)
	label var age1 "Age head 60-64"
	label var age2 "Age head 65-69"
	label var age3 "Age head 70-74"
	label var age4 "Age head 75-79"
	label var age5 "Age head 80+"

	recode agehead (min/29 =1 "20s") (30/39 = 2 "30s") (40/49 = 3 "40s") (50/59 = 4 "50s") (60/69 = 5 "60s") (70/79=6 "70s") (80/max = 7 "80+"), gen(ageb)

	qui tab ageb, gen(ageb)
	label var ageb1 "Age head 20s"
	label var ageb2 "Age head 30s"
	label var ageb3 "Age head 40s"
	label var ageb4 "Age head 50s"
	label var ageb5 "Age head 60s"
	label var ageb6 "Age head 70s"
	label var ageb7 "Age head 80s"

	recode agehead (min/34 =1 "<35") (35/59 = 2 "35-49") (50/64 = 3 "50-65") (65/max =4 "65+"), gen(bageb)
	qui tab bageb, gen(bageb)
	label var bageb1 "Age head <35"
	label var bageb2 "Age head 35-49"
	label var bageb3 "Age head 50-65"
	label var bageb4 "Age head 65+"

	gen bagebpen = 1 if agehead <35
	replace bagebpen = 2 if agehead>=35 & agehead<45
	replace bagebpen = 3 if agehead>=45 & penhead==0
	replace bagebpen = 4 if penhead==1

	recode agehead (min/59 = .) (60/69 = 1) (70/79 = 2) (80/max = 3), gen(terage)
	qui tab terage, gen(terage)
	label var terage1 "Age head 60-69"
	label var terage2 "Age head 70-79"
	label var terage3 "Age head 80+"

	recode agehead (min/34 =1 "<35") (35/65 = 2 "35-65") (65/max = 3 "65+"), gen(ageg3)
	qui tab ageg3, gen(ageg3)
	label var ageg31 "Age head 18-34"
	label var ageg32 "Age head 35-64"
	label var ageg33 "Age head 65+"

	*drop tenure month empstat reltohoh age
	sort hhref year week
	qui by hhref year week: gen n=_n
	keep if n==1
	drop n
	sort hhref year week
	tempfile demogs`X'
	save "`demogs`X''"
}

use "`demogs${startyear}'",replace
forval X = $startyearplusone / $endyear {
	append using `demogs`X''
}
compress
sort hhref datayear year week
save "$dataProcess/lcfsdemogs",replace

/************************************************/
/*          EXPENDITURE                         */
/************************************************/

forval X = $startyear / $endyear {
	use "$dataLCFS/Expenditure/CPICons/CPICons`X'.dta", clear
	sort hhref datayear year
	*Water charges are only needed for particular years so not for the time period we look at
	*merge hhref datayear year using "$datadir\extracted\watercharge`X'"
	*drop _m
	sort hhref datayear year
	rename * ads*
	rename adshhref hhref
	rename adsdatayear datayear
	rename adsyear year
	merge 1:1 hhref datayear year using "$dataLCFS/Expenditure/CPICons/CPIkidscons`X'"
	assert _m==3
	drop _m
	*renpfix cpi
	foreach var of varlist breadcereals-MISC {
		replace `var' = ads`var'+`var'
		drop ads`var'
	}
	drop adstotexp
	egen totexptemp = rsum(FOODDRINK ALCTOB CLOTHFOOT HOUSING FURNEQUIP HEALTH TRANSPORT COMMUNICATION RECREATION EDUCATION RESTHOT MISC)
	replace totexp = totexptemp
	drop totexptemp
	/*order cpiFOODDRINK cpiALCTOB cpiCLOTHFOOT cpiHOUSING cpiFURNEQUIP cpiHEALTH cpiTRANSPORT cpiCOMMUNICATION cpiRECREATION cpiEDUCATION cpiRESTHOT cpiMISC */
	sort hhref datayear week
	save "$dataProcess/cpiexpends`X'",replace
}

use "$dataProcess/cpiexpends${startyear}", replace
forval X =  $startyearplusone / $endyear {
	append using "$dataProcess/cpiexpends`X'"
	erase "$dataProcess/cpiexpends`X'.dta" 
}

for var  breadcereals- MISC  : qui gen cpiw_X = X/totexp
/*don't drop negatives - consistent with treatment of ney purchases in the CPI*/
*for var  breadcereals- MISC  : drop if X<0
*for var  breadcereals- MISC  : assert X>=0
for var  breadcereals- MISC  : rename X cpix_X
for var  cpiw_breadcereals- cpiw_MISC : qui replace X = 0 if X==.
*drop breadcereals - MISC
rename totexp cpi_totexp
compress

sort hhref datayear year week
save "$dataProcess/lcfscpiexpends", replace
erase "$dataProcess/cpiexpends${startyear}.dta"

*Use rpi files to get council tax and tv licences spending 
forval X = $startyear / $endyear {
	use "$dataLCFS/Expenditure/RPICons`X'.dta", clear
	keep hhref datayear year ratect tvlicen week totexp FUEL_LIG insgr rent mortgageint mortgagetot
	sort hhref datayear year
	rename totexp rpi_totexp
	rename FUEL_LIG rpi_FUEL_LIG
	gen housingcosts = rent + mortgagetot
	save "$dataProcess/rpiexpends`X'",replace
}

use "$dataProcess/rpiexpends${startyear}", replace
forval X =  $startyearplusone / $endyear {
	append using "$dataProcess/rpiexpends`X'"
	erase "$dataProcess/rpiexpends`X'.dta" 
}
compress
sort hhref datayear year week
save "$dataProcess/lcfsrpiexpends", replace
erase "$dataProcess/rpiexpends${startyear}.dta" 

/************************************************/
/*          INCOME                              */
/************************************************/


forval X = $startyear / $endyear {
	if `X'==2020 {
		continue 
	}
	use "$dataLCFS/FESPcodeIncome/pcodenetincome`X'.dta", clear
	keep hhref persno indinc year datayear week
	egen hhinc = sum(indinc), by(hhref)
	bys hhref year week: gen n=_n
	keep if n==1
	drop indinc n
	sort hhref datayear week
	tempfile lcfsincome`X'
	save "`lcfsincome`X''"
}

use "`lcfsincome${startyear}'",replace
forval X = $startyearplusone / $endyear {
	if `X'==2020 {
		continue 
	}
	append using `lcfsincome`X''
compress
sort hhref datayear year week
save "$dataProcess/lcfsincome",replace
}

*/



/************************************************/
/*          MERGING                             */
/************************************************/

use "$dataProcess/lcfsdemogs",replace


merge 1:1  hhref datayear year week using "$dataProcess/lcfscpiexpends"
tab _m
drop _m 

merge 1:1 hhref datayear year week using "$dataProcess/lcfsrpiexpends"
tab _m
drop _m 

sort hhref datayear year week
merge 1:1 hhref datayear year week using "$dataProcess/lcfsincome"
tab _m
drop _m

gen quarter = 1 if inrange(month,1,3)
replace quarter = 2 if inrange(month,4,6)
replace quarter = 3 if inrange(month,7,9)
replace quarter = 4 if inrange(month,10,12)

merge 1:1 hhref  datayear year  using "$dataProcess/equiv"
drop _m 

gen indivweight = weighta*numpeeps

gen hhequivinc = hhinc/hheqsize

drop popdens

*monthly spending on energy and all "nondurables" matching CS definition
** gen energy_lcfs = cpix_FUEL*4.33
** gen nondurables_lcfs =  (cpix_FOODDRINK + cpix_ALCTOB + cpix_WATSEW + cpix_FUEL + cpix_HHAPP + cpix_GLASSTABLEWARE + cpix_ROUTMAINT + cpix_HEALTH + cpix_TRANSEQUIP + cpix_TRANSSERVS + cpix_COMMUNICATION + cpix_RECREATION + cpix_EDUCATION + cpix_RESTHOT + cpix_MISC + ratect + tvlicen)*4.33
** gen nondurables_lcfs =  (cpix_FOODDRINK + cpix_ALCTOB + cpix_WATSEW + cpix_FUEL + cpix_PERSCARE + cpix_TRANSEQUIP + cpix_TRANSSERVS + cpix_COMMUNICATION + cpix_RECREATION + cpix_EDUCATION + cpix_RESTHOT + cpix_MISC + ratect + tvlicen)*4.33

gen exp_childcare	= cpix_EDUCATION
gen exp_discret 	= cpix_AUDIOVISUAL+ cpix_RECDURABLES+ cpix_OTHERRECGOODS+ cpix_RECSERVS+ cpix_NEWSBOOKS +cpix_PKGHOLIDAYS+ cpix_CATERINGSERVS+ cpix_ACCOMSERVICES
gen exp_elec 		= cpix_electricity
gen exp_gas 		= cpix_gas
gen exp_nonelecgasenergy = cpix_liquidfuel + cpix_solidfuel
gen exp_energy 		= cpix_electricity+ cpix_gas
gen exp_fuel 		= cpix_vehfuel
gen exp_grocery 	= cpix_FOODDRINK+cpix_ALCTOB
gen exp_othbill 	= cpix_INSURANCE+ cpix_WATSEW
gen exp_personal 	= cpix_MEDICAL+cpix_PERSCARE
gen exp_phonetv 	= cpix_PHONE + tvlicen
gen exp_transport	= cpix_vehmaint+ cpix_vehservices+cpix_TRANSSERVS


gen nondurables_lcfs = exp_childcare + exp_discret + exp_energy + exp_fuel + exp_grocery + exp_othbill + exp_personal + exp_phonetv + exp_transport
gen energy_lcfs = exp_energy
ren hhinc  hhinc_lcfs

drop cpix* cpiw*

foreach v of var energy_lcfs nondurables_lcfs exp_* hhinc_lcfs cpi_totexp rpi_totexp rpi_FUEL_LIG housingcosts{
	replace `v' = `v'*4.33

}

merge m:1 year month using "$dataProcess/cpi_stata"
drop if _m==2
drop _m
drop Period monthname
ren cpi cpi_allitems

*put all cash variables in 2022 Dec real terms 
foreach var of varlist energy_lcfs nondurables_lcfs exp_* hhinc_lcfs cpi_totexp rpi_totexp rpi_FUEL_LIG housingcosts  {
	replace `var' = `var'/cpi_allitems
}

save "$dataProcess/lcfsdata",replace



/************************************************/
/*          GAS/ELEC SHARES BY DECILE           */
/************************************************/


use "$dataProcess/lcfsdata",replace

gen quintinc = .
forval year = 2013/2019 {
	xtile quintinc_temp = hhinc [aw=weighta] if year==`year', n(5)
	replace quintinc = quintinc_temp if year==`year'
	drop quintinc_temp
}

label define quintinc 1 "Poorest" 2 "2" 3 "3" 4 "4" 5 "Richest"
label values quintinc quintinc

*do within month to account for seasonal effects
gen quintenergyspend = .
forval year = 2013/2019 {
	forval month = 1/12 {
		xtile quintenergyspend_temp = exp_energy [aw=weighta] if year==`year' & month==`month', n(5)
		replace quintenergyspend = quintenergyspend_temp if year==`year' & month==`month'
		drop quintenergyspend_temp
	}
}

label define quintenergyspend 1 "Lowest" 2 "2" 3 "3" 4 "4" 5 "Highest"
label values quintenergyspend quintenergyspend

*How does LCFS split up combined bills?
*Ask households to consult combined statements
*On your most recent bill or online statement, how much of the combined amount is for
*gas?

gen share_gas = exp_gas/exp_energy


collapse (mean) share_gas if year==2019 & share_gas>=0 & share_gas<=1 [aw=weighta], by(quintenergyspend quintinc)


save "$dataProcess/LCFS_sharegas_byincandexp", replace


/************************************************/
/*          AFTER HOUSING COSTS INCOME MEASURE           */
/************************************************/


use "$dataProcess/lcfsdata",clear

keep if year == 2019

gen incAHC = hhinc_lcfs - housingcosts
gen incAHC_over_inc = incAHC /hhinc_lcfs
gen incAHC_over_nondur = incAHC /nondurables_lcfs


replace incAHC_over_inc = 0 if incAHC_over_inc<0
replace incAHC_over_inc = 1 if incAHC_over_inc>=1
su incAHC_over_inc,d
replace incAHC_over_inc = r(p1) if incAHC_over_inc<r(p1)
replace incAHC_over_inc = r(p99) if incAHC_over_inc>r(p99)

xtile inc_dec = hhinc_lcfs  , nq(10)
xtile nondur_dec = nondurables_lcfs  , nq(10)
xtile energy_dec = energy_lcfs  , nq(10)


reg incAHC_over_inc i.inc_dec i.nondur_dec i.energy_dec
predict incAHC_over_inc_pred, xb

reg incAHC_over_nondur i.inc_dec i.nondur_dec i.energy_dec
predict incAHC_over_nondur_pred, xb


gen shrAHC = energy_lcfs/incAHC


collapse (mean) incAHC_over_inc_pred incAHC_over_nondur_pred, by(inc_dec nondur_dec energy_dec)

fillin inc_dec nondur_dec energy_dec
drop _f

bysort inc_dec : egen temp = mean(incAHC_over_inc_pred)
replace incAHC_over_inc_pred= temp if incAHC_over_inc_pred == .
drop temp

bysort inc_dec : egen temp = mean(incAHC_over_nondur_pred)
replace incAHC_over_nondur_pred= temp if incAHC_over_nondur_pred == .
drop temp


ren nondur_dec mtot_out_nondurab_dec
ren energy_dec  eexp_dec



sa "$dataProcess/lcfsdata_incAHC",replace









