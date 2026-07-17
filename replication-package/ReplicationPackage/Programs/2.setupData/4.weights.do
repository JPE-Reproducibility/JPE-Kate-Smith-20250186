set more off
clear all


**********
** IMPORT MAPPING FROM POSTCODE TO LA

insheet using "$dataRaw\downloaded\Ward_to_Local_Authority_District_to_County_to_Region_to_Country_(May_2023)_Lookup_in_United_Kingdom.csv", comma clear


keep lad23cd lad23nm rgn23cd rgn23nm
bysort lad23cd: keep if _n==1

gen 	gor = 1 if rgn23cd == "E12000001"
replace gor = 2 if rgn23cd == "E12000002"
replace gor = 3 if rgn23cd == "E12000003"
replace gor = 4 if rgn23cd == "E12000004"
replace gor = 5 if rgn23cd == "E12000005"
replace gor = 6 if rgn23cd == "E12000006"
replace gor = 7 if rgn23cd == "E12000007"
replace gor = 8 if rgn23cd == "E12000008"
replace gor = 9 if rgn23cd == "E12000009"
replace gor = 10 if rgn23cd == "W92000004"
replace gor = 11 if rgn23cd == "S92000003"
replace gor = 12 if rgn23cd == "N92000002"

sa "$dataProcess/lad_to_gor.dta", replace





insheet using "$dataRaw/downloaded/PCD_OA_LSOA_MSOA_LAD_MAY22_UK_LU.csv", comma clear

drop if ladcd==""

keep pcds ladcd
ren pcds postcode

gen temp = strlen(postcode)
replace temp = temp - 2
gen postcode_sector = substr(postcode,1,temp)

sort postcode_sector postcode
by postcode_sector: egen mode_la = mode(ladcd), minmode

by postcode_sector: keep if _n==1

keep postcode_sector  mode_la

sa "$dataProcess/postcode_sector_to_LA.dta", replace





**********



**********
** IMPORT WEIGHTS DATA


import excel using "$dataRaw/downloaded/ukpopestimatesmid2021on2021geographyfinal.xls", sheet("MYE2 - Persons") cellrange(A8:CQ428) first clear


local z = 0
foreach v of var E - CQ {
	ren `v' count`z'
	local z = `z'+1	
}

reshape long count, i(Code) j(age)

gen lad23cd = Code
merge m:1 lad23cd using "$dataProcess/lad_to_gor.dta"
keep if _m==3
drop _m

collapse (sum) count, by(age gor)

drop if age<16
egen age_5band = cut(age), at(16(5)91)
replace age_5band = 76 if age_5band>=76


collapse (sum) count, by(age_5band gor)

** ren Code mode_la

egen tot = total(count)
gen count_norm = count/tot


sa "$dataProcess/age_LA_weights.dta", replace


**********







