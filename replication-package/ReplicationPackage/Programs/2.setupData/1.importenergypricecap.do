*Import energy price cap data 

*Produces datafiles for EPG unit prices and standing charges, price cap unit prices and standing charges
*Shares of consumers using different payment methods
*Average unit prices and standing charges by region (for periods when the price cap is not binding)

*import data on EPG prices
*https://www.gov.uk/government/publications/energy-price-guarantee-regional-rates/energy-price-guarantee-regional-rates#prepayment-meters
forval i = 1/5 {
	clear
	if `i'==1 local sheet "Oct - Dec"
	if `i'==2 local sheet "Jan - Mar"
	if `i'==3 local sheet "Apr - Jun"
	if `i'==4 local sheet "Jul - Sep"
	if `i'==5 local sheet "Oct 23 - Dec 23"
	
	import excel using "$dataRaw/downloaded/EPGrates.xlsx", sheet("`sheet'") first

	*these are all excluding VAT
	foreach var in up_ElecSingle_Other up_Gas_Other up_ElecSingle_SC up_Gas_SC up_ElecSingle_PPM up_Gas_PPM	standcharge_ElecSingle_Other standcharge_Gas_Other standcharge_ElecSingle_SC standcharge_Gas_SC standcharge_ElecSingle_PPM standcharge_Gas_PPM {
		replace `var' = `var'*1.05/100
		rename `var' `var'_EPG
	}

	if `i'==1 {
		gen startmonth = "October" 
		gen startyear = 2022
		gen endmonth = "December"
		gen endyear = 2022
	}
	
	if `i'==2 {
		gen startmonth = "January" 
		gen startyear = 2023
		gen endmonth = "March"
		gen endyear = 2023
	}

	if `i'==3 {
		gen startmonth = "April" 
		gen startyear = 2023
		gen endmonth = "June"
		gen endyear = 2023
	}
	
	if `i'==4 {
		gen startmonth = "July" 
		gen startyear = 2023
		gen endmonth = "September"
		gen endyear = 2023
	}
	
	if `i'==5 {
		gen startmonth = "October" 
		gen startyear = 2023
		gen endmonth = "December"
		gen endyear = 2023
	}

	*under EPG average multi (peak and offpeak price) averages to the same unit rates

	gen up_ElecMulti_Other = up_ElecSingle_Other
	gen up_ElecMulti_SC = up_ElecSingle_SC
	gen up_ElecMulti_PPM = up_ElecSingle_PPM
	gen standcharge_ElecMulti_Other =  standcharge_ElecSingle_Other
	gen standcharge_ElecMulti_SC =  standcharge_ElecSingle_SC 
	gen standcharge_ElecMulti_PPM = standcharge_ElecSingle_PPM

	tempfile EPG`i'
	save `EPG`i''
}


*import average unit prices and standing charges for electricity (standard tariffs) and gas
*taken from here https://www.gov.uk/government/statistical-data-sets/annual-domestic-energy-price-statistics
clear 
import excel using "$dataRaw/downloaded/beis_averageunitcosts_elec.xlsx", sheet("2.2.4") cellrange("A13:K221") first

rename CreditAveragevariableunitpr ElecSingle_SC_unitprice
rename CreditAveragefixedcostye ElecSingle_SC_standingcharge
rename DirectdebitAveragevariableu ElecSingle_Other_unitprice
rename DirectdebitAveragefixedcost ElecSingle_Other_standingcharge
rename PrepaymentAveragevariableuni ElecSingle_PPM_unitprice
rename PrepaymentAveragefixedcost ElecSingle_PPM_standingcharge
rename OverallAveragevariableunitp ElecSingle_All_unitprice
rename OverallAveragefixedcosty ElecSingle_All_standingcharge

rename Year year
rename RegionNote1 region
drop if year<2013
drop PESarea
replace region = strtrim(region)
sort year region
save "$dataProcess/beis_averageunitcosts_elec", replace

clear 
import excel using "$dataRaw/downloaded/beis_averageunitcosts_gas.xlsx", sheet("2.3.4") cellrange("A11:K206") first

rename CreditAveragevariableunitpr Gas_SC_unitprice
rename CreditAveragefixedcostye Gas_SC_standingcharge
rename DirectdebitAveragevariableu Gas_Other_unitprice
rename DirectdebitAveragefixedcost Gas_Other_standingcharge
rename PrepaymentAveragevariableuni Gas_PPM_unitprice
rename PrepaymentAveragefixedcost Gas_PPM_standingcharge
rename OverallAveragevariableunitp Gas_All_unitprice
rename OverallAveragefixedcosty Gas_All_standingcharge

rename Year year
rename LDZarea region 
drop if year<2013
drop Region
replace region = strtrim(region)
sort year region

save "$dataProcess/beis_averageunitcosts_gas", replace

*imports OFGEM's incomprehensible spreadsheet for price caps and converts into unit prices and daily standing charges for each cap period

foreach sheet in ElecSingle_Other_3100kWh ElecSingle_SC_3100kWh Gas_Other_12000kWh Gas_SC_12000kWh ElecMulti_Other_4200kWh ElecMulti_SC_4200kWh ElecSingle_Other_Nil ElecSingle_SC_Nil Gas_Other_Nil Gas_SC_Nil ElecMulti_SC_Nil ElecMulti_Other_Nil ElecSingle_PPM_3100kWh Gas_PPM_12000kWh ElecMulti_PPM_4200kWh ElecSingle_PPM_Nil Gas_PPM_Nil ElecMulti_PPM_Nil  {
	clear 
	import excel using "$dataRaw/downloaded/Default_tariff_cap_level_v1.20.xlsx", sheet("`sheet'") cellrange(B12:AC194) firstrow 
	drop if _n<3
	rename B Category
	keep if Category=="Total"
	drop C
	rename D region
	drop Category
	drop ADChargeRestrictionPeriod
	drop F O X 

	local i = 0
	foreach var of varlist April2015September2015 - October2023December2023 {
		local ++i
		destring `var', replace force
		local l`i' : variable label `var'
		rename `var' stub`i'
	}

	reshape long stub, i(region) j(j)
	gen period = ""
	forval j = 1/`i' {
		replace period = "`l`j''" if j==`j'
	}

	rename stub `sheet'
	tempfile `sheet'_file
	save ``sheet'_file'
}

use `ElecSingle_Other_3100kWh_file', clear
foreach sheet in ElecSingle_SC_3100kWh Gas_Other_12000kWh Gas_SC_12000kWh ElecMulti_Other_4200kWh ElecMulti_SC_4200kWh ElecSingle_Other_Nil ElecSingle_SC_Nil Gas_Other_Nil Gas_SC_Nil ElecMulti_SC_Nil ElecMulti_Other_Nil ElecSingle_PPM_3100kWh Gas_PPM_12000kWh ElecMulti_PPM_4200kWh ElecSingle_PPM_Nil Gas_PPM_Nil ElecMulti_PPM_Nil  {
	merge 1:1 region period using ``sheet'_file', assert(3) nogen
}

sort region j 

foreach tariff in ElecSingle_Other ElecSingle_SC ElecSingle_PPM {
	gen up_`tariff' = `tariff'_3100kWh - `tariff'_Nil
	*add VAT and divide by q to get unit price
	replace up_`tariff' = up_`tariff'*1.05/3100
	label var up_`tariff' "Unit price for `tariff' per KWh" 
	gen standcharge_`tariff' = `tariff'_Nil*1.05/365
	label var standcharge_`tariff' "Daily standing charge for `tariff'" 
}

foreach tariff in Gas_Other Gas_SC Gas_PPM  {
	gen up_`tariff' = `tariff'_12000kWh - `tariff'_Nil
	replace up_`tariff' = up_`tariff'*1.05/12000
	label var up_`tariff' "Unit price for `tariff' per KWh" 
	gen standcharge_`tariff' = `tariff'_Nil*1.05/365
	label var standcharge_`tariff' "Daily standing charge for `tariff'" 
}

foreach tariff in ElecMulti_Other ElecMulti_SC ElecMulti_PPM  {
	gen up_`tariff' = `tariff'_4200kWh - `tariff'_Nil
	replace up_`tariff' = up_`tariff'*1.05/4200
	label var up_`tariff' "Unit price for `tariff' per KWh" 
	gen standcharge_`tariff' = `tariff'_Nil*1.05/365
	label var standcharge_`tariff' "Daily standing charge for `tariff'" 
}

*organise periods 
gen startyearstring = strpos(period,"2")
gen endyearstring = startyearstring + 4
gen endfirstmonthstring = startyearstring -1 
gen startyear = substr(period,startyearstring,4)
gen startmonth = substr(period,1,endfirstmonthstring)
replace startmonth = strtrim(startmonth)

gen secondperiod = substr(period,endyearstring,.)
gen startyearstring2 = strpos(secondperiod,"2")
gen endyearstring2 = startyearstring2 + 4
gen endyear = substr(secondperiod,startyearstring2,4)
gen endsecondmonthstring = startyearstring2 -1 
gen endmonth = substr(secondperiod,1,endsecondmonthstring)
replace endmonth = subinstr(endmonth,"-","",.)
replace endmonth = subinstr(endmonth,"–","",.)
replace endmonth = strtrim(endmonth)

destring startyear, replace
destring endyear, replace

drop startyearstring endyearstring endfirstmonthstring startyearstring2 endyearstring2 secondperiod endsecondmonthstring

rename j capperiodno 
gen EPG = 0 
replace EPG = 1 if startyear==2022 & startmonth=="October"
replace EPG = 1 if startyear==2023 & startmonth=="January"
replace EPG = 1 if startyear==2023 & startmonth=="April"
replace EPG = 1 if startyear==2023 & startmonth=="July"
replace EPG = 1 if startyear==2023 & startmonth=="October"

label var EPG "Period when EPG is in effect"
order region startmonth startyear endmonth endyear period capperiodno

gen cap = up_ElecSingle_Other*2900 + standcharge_ElecSingle_Other*365 + up_Gas_Other*12000 + standcharge_Gas_Other*365
gen totstandingcharge = standcharge_ElecSingle_Other*365 + standcharge_Gas_Other*365
label var cap "Reported value of price cap at TCDV"

gen cap_prepay = up_ElecSingle_PPM*2900 + standcharge_ElecSingle_PPM*365 + up_Gas_PPM*12000 + standcharge_Gas_PPM*365
label var cap_prepay "Reported value of price cap at TCDV (prepay)"

*no cap before this year
*drop if startyear<2019

save "$dataProcess/OfgemPriceCaps", replace

merge 1:1 region startmonth startyear endmonth endyear using `EPG1', nogen
merge 1:1 region startmonth startyear endmonth endyear using `EPG2', update nogen 
merge 1:1 region startmonth startyear endmonth endyear using `EPG3', update nogen 
merge 1:1 region startmonth startyear endmonth endyear using `EPG4', update nogen 
merge 1:1 region startmonth startyear endmonth endyear using `EPG5', update nogen 

sort capperiodno

*Set EPG standing charges for April-June 2023 (these are the same as the Ofgem price cap)
foreach var in standcharge_Gas_Other standcharge_ElecSingle_SC	standcharge_Gas_SC	standcharge_ElecSingle_PPM	standcharge_Gas_PPM {
	replace `var'_EPG = `var' if capperiodno==19 
}

*check value of EPG
gen EPGval = up_ElecSingle_Other_EPG*2900 + standcharge_ElecSingle_Other_EPG*365 + up_Gas_Other_EPG*12000 + standcharge_Gas_Other_EPG*365 if EPG==1
gen EPGval_PPM = up_ElecSingle_PPM_EPG*2900 + standcharge_ElecSingle_PPM_EPG*365 + up_Gas_PPM_EPG*12000 + standcharge_Gas_PPM_EPG*365 if EPG==1

sort capperiodno region 

save "$dataProcess/OfgemPriceCaps_EPG", replace



use "$dataProcess/OfgemPriceCaps_EPG", replace

keep if region=="GB average"
keep region startmonth startyear endmonth endyear period capperiodno cap cap_prepay EPGval EPGval_PPM up_ElecSingle_Other up_ElecSingle_Other_EPG up_Gas_Other up_Gas_Other_EPG up_ElecSingle_PPM up_ElecSingle_PPM_EPG up_Gas_PPM up_Gas_PPM_EPG standcharge_ElecSingle_Other* standcharge_Gas_Other*

tostring startyear, replace
gen startdatetemp = startmonth + " " + startyear
gen newstartdate = monthly(startdatetemp, "MY")

tostring endyear, replace
gen enddatetemp = endmonth + " " + endyear
gen newenddate = monthly(enddatetemp, "MY")

gen nummonths = newenddate - newstartdate + 1
expand nummonths
sort capperiodno
bys period: gen n= _n
gen newdate = date(startdatetemp,"MY")
gen monthlydate = mofd(newdate) + n - 1
gen newdatevar = dofm(monthlydate)
gen month = month(newdatevar)
gen year = year(newdatevar)
sort year month 

keep capperiodno cap cap_prepay EPGval* year month up_ElecSingle* up_Gas* standcharge_ElecSingle_Other* standcharge_Gas_Other*

gen EPGsubsidy_up_Elec = up_ElecSingle_Other_EPG/up_ElecSingle_Other -1
gen EPGsubsidy_up_Gas =  up_Gas_Other_EPG/up_Gas_Other -1
*using weight from create.7.addtempdata
gen EPGsubsidy_Energy =  EPGsubsidy_up_Elec*(1-0.4821) + EPGsubsidy_up_Gas*0.4821

gen EPGsubsidy_up_Elec_PPM = up_ElecSingle_PPM_EPG/up_ElecSingle_PPM -1
gen EPGsubsidy_up_Gas_PPM =  up_Gas_PPM_EPG/up_Gas_PPM -1
gen EPGsubsidy_Energy_PPM =  EPGsubsidy_up_Elec_PPM*(1-0.4821) + EPGsubsidy_up_Gas_PPM*0.4821

gen EPGsubsidy_standingcharge_Elec = (standcharge_ElecSingle_Other - standcharge_ElecSingle_Other_EPG)*30
gen EPGsubsidy_standingcharge_Gas = (standcharge_Gas_Other - standcharge_Gas_Other_EPG)*30

drop if capperiodno<9

save "$dataProcess/OfgemPriceCaps_EPG_monthly", replace
