
set more off
clear all

**********
** START WITH ENERGY DATA AND REMOVE PERIODS OF NON RECORDING

foreach data in  CS    {

	u "$dataProcess/`data'energy_step1_combine", clear
	
	**drop periods of negative or zero nondurable spending (likely because of large refunds in that month)
	merge m:1 userref year month using "$dataProcess/`data'allspending_step1_combine.dta", keep(match master) keepusing(tot_out_nondurab n_accounts)
	drop _m 
	drop if tot_out_nondurab<=0

	**keep periods in which we observe the max number of accounts we ever observe
	bysort userref: egen max_n_accounts = max(n_accounts)
	gen keep = max_n_accounts == n_accounts
	drop tot_out_nondurab keep max_n_accounts n_accounts

	**drop strings that are less than 6 months long
	drop if string_6mplus == 0
	
	assert amount>=0

	**sort accounts by spending within each month
	isid userref yrmn amount energy_supplier mode
	bys userref yrmn (amount energy_supplier mode): gen account = _n
	bys userref yrmn (amount energy_supplier mode): gen naccounts = _N
	
	**very few have more than 2
	drop if naccounts>=3
	**uses heating oil 
	egen heatingoiluser = max(energy_supplier==9), by(userref yrmn)
	egen everheatingoiluser = max(heatingoiluser), by(userref)
	**around 0.5% of the sample ever use heating oil
	drop heatingoiluser
	drop naccounts
	
	drop string_no string_length string_6mplus filled_in filled_in_onlysingles payment_change
	
	reshape wide energy_supplier mode amount amount_energy_credit likely_pp ntrans direct_debit variable_slack variable_semistrict variable_strict EBSS_refund EBSS_everrefund freq_monthly freq_quarterly, i(userref yrmn) j(account) 

	gen energycredits =  0
	replace energycredits = energycredits + amount_energy_credit1 if amount_energy_credit1<.
	replace energycredits = energycredits + amount_energy_credit2 if amount_energy_credit2<.

	gen  exp_energy_t = - energycredits
	replace exp_energy_t = exp_energy_t +  amount1 if amount1<.
	replace exp_energy_t = exp_energy_t +  amount2 if amount2<.
	label var exp_energy_t "Total net energy spend in year-month (across all modes)"
	
	egen evernegative = max(exp_energy_t<0), by(userref)
	*these are often cases where accounts open or close (means that we may get consumption in preceding months incorrect as well)
	drop if evernegative
	drop evernegative
	
	gen sample_PP = ((mode1=="PP") & (mode2=="PP"))|((mode1=="PP") & (mode2=="")) 

	foreach variable in slack semistrict strict {
		gen sample_variable_`variable' = (variable_`variable'1==1 & variable_`variable'2==1)|(variable_`variable'1==1 & variable_`variable'2==.)
	}
	


	**merge in non-energy spending info
	merge 1:1 userref year month using "$dataProcess/`data'allspending_step1_combine.dta", keep(match master)
	drop _m tranche

	foreach v of var payday_in- amount_out_transport {
		replace `v' = 0 if `v' == .
	}

	**merge in user info
	merge m:1 userref using "${dataCS}//user", keepusing(dob sex salaryrange postcode lsoa gor laname)
	drop if _m==2
	drop _m
	label var postcode "Postcode"
	label var lsoa "Local Super Outout Area"
	label var gor "Government Office Region"
	label var laname "Local Authority"
	
	gen doby = yofd(dofm(dob))
	gen dobm = month(dofm(dob))
	
	**create a balanced sample if min year is 2019 and max year is 2023
	bysort userref: egen min_year = min(year)
	bysort userref: egen max_year = max(year)
	gen balanced = min_year == 2019 & max_year==2023

	**merge in weights
	gen age = year - doby
	label var age "Age"
	drop if age<=18 | age>=100

	forval y = 2016/2023 {
		gen age_`y' = age if year == `y'
		bysort userref: egen temp = max(age_`y')
		replace age_`y' = temp if age_`y'== .
		drop temp
	}
	replace age_2021 = age_2020 + 1 if age_2021==.
	replace age_2021 = age_2022 - 1 if age_2021==.
	replace age_2021 = age_2019 + 2 if age_2021==.
	replace age_2021 = age_2023 - 2 if age_2021==.
	replace age_2021 = age_2018 + 2 if age_2021==.
	replace age_2021 = age_2017 + 2 if age_2021==.
	replace age_2021 = age_2016 + 2 if age_2021==.

	replace age_2021 = 90 if age_2021>=90
	drop age_2016 age_2017 age_2018 age_2019 age_2020 age_2022 age_2023
	label var age_2021 "Age in 2021"


	ren postcode postcode_sector
	drop if postcode_sector == ""
	merge m:1 postcode_sector using "$dataProcess/postcode_sector_to_LA.dta"
	drop if _m==2
	drop _m
	label var mode_la "Modal LA for that postcode sector"

	**drop if no LA info for postcode
	drop if mode_la == ""
	drop if gor== . | gor == 14


	** Northern Ireland indicator
	gen NI = gor == 12 
	**drop people that use heating oil and aren't in NI
	drop if everheatingoiluser & gor != 12

	gen dataset = 1 

	label def dataset 1 "ClearScore" 
	label val dataset dataset
	
	isid userref year month 
	sort userref year month 

	sa "$dataProcess/`data'energyallspending_step2a_combine", replace

}

*/

**********



**********
** Construct weights 

**Step 1: reweight to match the population based on gor and age band
u "$dataProcess/CSenergyallspending_step2a_combine", clear

ren userref userref_orig 
egen userref = group(dataset userref_orig)

keep userref yrmn age_2021 mode_la gor balanced
isid userref yrmn
sort userref yrmn
by userref: keep if _n==1
drop yrmn

egen age_5band = cut(age_2021), at(16(5)91)
replace age_5band = 76 if age_5band>=76
label var age_5band "5-year age band"

merge m:1 age_5band gor using "$dataProcess/age_LA_weights.dta", keepusing(count_norm)
drop _m
label var count_norm   "Normalised population of 5-year age band in gor"


**Drop Northern Ireland
drop if gor == 12


gen tag = 1
bysort age_5band gor: egen nsample = total(tag)
egen Nsample = total(tag)
gen count_sample = nsample/(Nsample)

gen weight_fullsamp = count_norm/count_sample
label var weight_fullsamp "Weight to adjust to population by age band and gor, full sample"

drop nsample Nsample count_sample

bysort age_5band gor: egen nsample = total(tag) if balanced == 1
egen Nsample = total(tag) if balanced == 1
gen count_sample = nsample/(Nsample)

gen weight_balsamp = count_norm/count_sample
label var weight_balsamp "Weight to adjust to population by age band and gor, balanced sample"
drop nsample Nsample count_sample


bysort age_5band gor: gen f=_n

tab gor [iw= weight_fullsamp ]
tab gor [iw= weight_balsamp ] if balanced==1		//note, there are couple of missing age band gor combos, so this one is not exact
tab gor [iw = count_norm] if f==1

keep userref age_5band gor  weight_fullsamp weight_balsamp count_norm balanced

isid userref age_5band gor
sort userref age_5band gor

sa "$dataProcess/CSenergyallspending_step2b_weights", replace
*/


**Step 2: reweight variable sample to match full sample
foreach s in 1 2 {
	u "$dataProcess/CSenergyallspending_step2a_combine", clear

	ren userref userref_orig 
	egen userref = group(dataset userref_orig)


	**Drop Northern Ireland
	drop if gor == 12


	merge m:1 userref using "$dataProcess/CSenergyallspending_step2b_weights"
	drop _m

	
	if `s'== 1 gen variable_sample = sample_PP==1
	if `s'== 2 gen variable_sample = sample_variable_semistrict==1

	collapse (mean) tot_in_excltrans exp_energy_t weight_fullsamp weight_balsamp (max) variable_sample, by(userref gor age_5band balanced)

	egen tot_in_excltrans_dec = cut(tot_in_excltrans), group(10)
	
	isid userref gor age_5band
	sort userref gor age_5band


	**1) Full sample, not expenditure weighted
	probit variable_sample i.age_5band#i.gor i.tot_in_excltrans_dec 
	predict variable_sample_pred, pr

	gen weight_fullsam_vari = 1/((1/weight_fullsamp)*variable_sample_pred)
	replace weight_fullsam_vari = 50 if weight_fullsam_var>50		//truncate distribution
	label var weight_fullsam_vari "Weight to adjust variable sample to full sample (age and region adjusted)"
	drop variable_sample_pred

	**2) Full sample, expenditure weighted
	probit variable_sample i.age_5band#i.gor i.tot_in_excltrans_dec  [iw = exp_energy_t]
	predict variable_sample_pred, pr

	gen weight_fullsam_vari_x = 1/((1/weight_fullsamp)*variable_sample_pred)
	replace weight_fullsam_vari_x = 50 if weight_fullsam_vari_x>50		//truncate distribution
	label var weight_fullsam_vari_x "Weight to adjust variable sample to full sample, exp weighted (age and region adjusted)"
	drop variable_sample_pred

	**3) Balanced sample, not expenditure weighted
	probit variable_sample i.age_5band#i.gor i.tot_in_excltrans_dec  if balanced==1
	predict variable_sample_pred, pr
	replace variable_sample_pred = . if balanced == 0

	gen weight_balsam_vari = 1/((1/weight_balsamp)*variable_sample_pred)
	replace weight_balsam_vari = 50 if weight_balsam_vari>50	& weight_balsam_vari<.	//truncate distribution
	label var weight_balsam_vari "Weight to adjust variable sample to balanced sample (age and region adjusted)"
	drop variable_sample_pred

	**4) Balanced sample, expenditure weighted
	probit variable_sample i.age_5band#i.gor i.tot_in_excltrans_dec  [iw = exp_energy_t]  if balanced==1
	predict variable_sample_pred, pr
	replace variable_sample_pred = . if balanced == 0

	gen weight_balsam_vari_x = 1/((1/weight_balsamp)*variable_sample_pred)
	replace weight_balsam_vari_x = 50 if weight_balsam_vari_x>50	& weight_balsam_vari_x<.		//truncate distribution
	label var weight_balsam_vari_x "Weight to adjust variable sample to balanced sample, exp weighted (age and region adjusted)"
	drop variable_sample_pred

	ren weight_fullsam_vari weight_fullsam_vari`s'
	ren weight_fullsam_vari_x  weight_fullsam_vari`s'_x 
	ren weight_balsam_vari weight_balsam_vari`s' 
	ren weight_balsam_vari_x weight_balsam_vari`s'_x

	keep userref weight_fullsamp weight_balsamp weight_fullsam_vari`s' weight_fullsam_vari`s'_x weight_balsam_vari`s' weight_balsam_vari`s'_x
	
	
	isid userref
	sort userref
	


	sa "$dataProcess/CSenergyallspending_step2c_weights`s'", replace


}


**merge weights back in
u "$dataProcess/CSenergyallspending_step2a_combine", clear

ren userref userref_orig 
egen userref = group(dataset userref_orig)
order userref, before(userref_orig)
order dataset, after(userref_orig)

label var userref "Uniquely identifies users across the CS and MDB datasets"
label var userref_orig "Original userref variable that identifies users within CS and MDB"
label var dataset "Indicator for which dataset the user belongs to"


merge m:1 userref using "$dataProcess/CSenergyallspending_step2c_weights1"
drop _m
merge m:1 userref using "$dataProcess/CSenergyallspending_step2c_weights2"
drop _m

drop min_year max_year
label var balanced "=1 if user present in 2019 and 2023"
label var weight_fullsamp "Weight to adjust to population by age band and gor, full sample"
label var weight_balsamp "Weight to adjust to population by age band and gor, balanced sample"

isid userref year month
sort userref year month 

sa "$dataProcess/CSenergyallspending_step2_combine", replace






**********

