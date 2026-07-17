set more off
clear all


**********
** READ IN MACRO DATA

local i = 1
foreach x in elec ener gas {
	foreach z in sa nsa {

		foreach v in IDEF CVM CP  {

		clear
		import excel using "$dataRaw/downloaded/energyspend_consumertrends_`x'_`z'", first  sheet(`v')

		gen start = 1 if  Period=="1985 Q1"
		gen n = _n
		su n if start==1
		keep if n>r(mean)
		drop start

		gen strquarter = word(Period,2)
		gen quarter = substr(strquarter,2,2)
		destring quarter, replace
		drop strquarter

		gen year = word(Period,1)
		destring year, replace
		drop Period
		if "`v'" == "IDEF" rename Value `x'_defl_`z'
		if "`v'" == "CVM" rename Value `x'_vol_`z'
		if "`v'" == "CP" rename Value `x'_exp_`z'

		if `i' > 1 {
			merge m:1 year quarter using "$dataProcess/macro_aggregates"
			drop _m
		}
		sa "$dataProcess/macro_aggregates", replace
		local i = `i'+1
		}
	}
}

u "$dataProcess/macro_aggregates", clear

keep year quarter ener_* gas_* elec_*
order year quarter ener_* gas_* elec_*

sa "$dataProcess/macro_aggregates", replace



**********


