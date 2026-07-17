set more off
clear all


**********
** Insheet temperature data

foreach ww in rainfall humidity tempmax tempav tempmin {
	
	forval y = 2018/2023 {
		
		insheet using "$dataRaw/`ww'`y'.csv", clear

		ren geo_code lsoa
		drop geo_labelw 
		drop label

		ren jan m1
		ren feb m2
		ren mar m3
		ren apr m4
		ren may m5
		ren jun m6
		ren july m7
		ren aug m8
		ren sep m9
		ren oct m10
		ren nov m11
		ren dec m12 

		reshape long m@, i(lsoa) j(month)
		
		destring m, gen(`ww') force
		
		drop m
		drop id
		
		gen year = `y'
		
		if `y'>2018 append using "$dataProcess/`ww'"
		sa "$dataProcess/`ww'", replace
		
	}
	
}


u "$dataProcess/rainfall", clear
foreach ww in rainfall humidity tempmax tempav tempmin {
	merge m:1 lsoa year month using  "$dataProcess/`ww'"
	drop _m
}

ren rainfall rain
ren humidity humid
ren tempmax tmax
ren tempmin tmin
ren tempav tavg

sa "$dataProcess/weather", replace 


**********


**********
** NORTHERN IRELAND PRICE SERIES

**manually extracted from https://www.consumercouncil.org.uk/research/home-energy-index
**it is the electricity & gas composite price series

clear
set obs 21
gen yrmn = _n + 202100 if _n<=12
replace yrmn = (_n - 12) + 202200 if _n>12

gen pIdx_NI = 106.626			if yrmn == 202101
replace pIdx_NI = 106.981		if yrmn == 202102
replace pIdx_NI = 108.009		if yrmn == 202103
replace pIdx_NI = 110.237		if yrmn == 202104
replace pIdx_NI = 110.237		if yrmn == 202105
replace pIdx_NI = 110.237		if yrmn == 202106
replace pIdx_NI = 115.235		if yrmn == 202107
replace pIdx_NI = 118.17 		if yrmn == 202108
replace pIdx_NI = 125.776 		if yrmn == 202109
replace pIdx_NI = 125.776		if yrmn == 202110
replace pIdx_NI = 131.2			if yrmn == 202111
replace pIdx_NI = 132.05		if yrmn == 202112
replace pIdx_NI = 144.218		if yrmn == 202201
replace pIdx_NI = 145.12		if yrmn == 202202
replace pIdx_NI = 153.08		if yrmn == 202203
replace pIdx_NI = 153.08		if yrmn == 202204
replace pIdx_NI = 165.021		if yrmn == 202205
replace pIdx_NI = 171.336		if yrmn == 202206
replace pIdx_NI = 205.8			if yrmn == 202207
replace pIdx_NI = 205.8			if yrmn == 202208
replace pIdx_NI = 205.8			if yrmn == 202209

replace pIdx_NI = pIdx_NI/100



sa "$dataProcess/NI_priceseries.dta", replace


**********



**********
** Create unit prices at year month level
if $synthetic==0 {
**common fixed weight for Laspeyeres index
u "$dataProcess/LCFS_sharegas_byincandexp", clear
su share_gas
local fixedweight = r(mean)
}
if $synthetic==1 { //directly enter value for synthetic run
local fixedweight = .4251503
}

if $synthetic==0 {
	u "$dataProcess/dates", clear
}
if $synthetic==1 {
	u "$dataRaw/dates", clear
}

bysort year month: keep if _n==1
keep year month yrmn

gen capperiodno = 13 if yrmn >= 202010 & yrmn<=202103
replace capperiodno = 14 if yrmn >= 202104 & yrmn<=202109
replace capperiodno = 15 if yrmn >= 202110 & yrmn<=202203
replace capperiodno = 16 if yrmn >= 202204 & yrmn<=202209
replace capperiodno = 17 if yrmn >= 202210 & yrmn<=202212
replace capperiodno = 18 if yrmn >= 202301 & yrmn<=202303
replace capperiodno = 19 if yrmn >= 202304 & yrmn<=202306
replace capperiodno = 20 if yrmn >= 202307 & yrmn<=202309
replace capperiodno = 21 if yrmn >= 202309 & yrmn<=202312

sa "$dataProcess/dates_yrmn", replace

** obtain monthly quantity measures
clear 

*take quarterly quantity series and make monthly using moving average 
import excel using "$dataRaw/downloaded/energyquantities.xlsx", sheet(forstata) first
rename A date
gen quarter = substr(date,9,1)
gen year = substr(date,11,4)
destring year, replace
destring quarter, replace
expand 3
bys year quarter: gen month = (quarter-1)*3 + _n
gen yrmn = year*100 + month
gen time = _n
tsset time
foreach var in Domestic Domestic_nas Domestic_gas_sa Domestic_elec_sa {
	gen month`var' = `var'/3 
	tssmooth ma smooth`var' = month`var', window(1 1 1)
}

drop time

sa "$dataProcess/monthlyenergyquantities", replace

clear
import delimited using "$dataRaw/downloaded/postcodedistricts2ofgemregions_expanded.csv", delimiter(",") varnames(1)
drop v1
bys ofgem_region postcode_district: keep if _n==1
*in two ofgem regions - put in London
drop if ofgem_region=="East England" & postcode_district=="N 8"
replace postcode_district = subinstr(postcode_district," ","",.)

sa "$dataProcess/postcodedistricts2ofgemregions_expanded", replace



**for 2020 and before use BEIS unit prices at the yearly  level
use "$dataProcess/beis_averageunitcosts_gas.dta" , clear

rename region ofgem_region
replace ofgem_region = "North Wales / Cheshire" if ofgem_region == "Merseyside & North Wales"
replace ofgem_region = "East England" if ofgem_region =="Eastern"
replace ofgem_region = "North East England" if ofgem_region == "North East"
replace ofgem_region = "North West England" if ofgem_region == "North West"
replace ofgem_region = "South East England" if ofgem_region == "South East"
replace ofgem_region = "South West England" if ofgem_region == "South West"
replace ofgem_region = "North Scotland" if ofgem_region =="Northern Scotland"
replace ofgem_region = "South Scotland" if ofgem_region == "Southern Scotland"
replace ofgem_region = "Southern England" if ofgem_region == "Southern"

replace ofgem_region = "United Kingdom" if ofgem_region == "Great Britain"

keep if year<=2020

keep ofgem_region year Gas_Other_unitprice Gas_Other_standingcharge

sa  "$dataProcess/unitcosts_gas_pre2020", replace



use "$dataProcess/beis_averageunitcosts_elec.dta" , clear

rename region ofgem_region

replace ofgem_region = "North Wales / Cheshire" if ofgem_region == "Merseyside & North Wales"
replace ofgem_region = "East England" if ofgem_region =="Eastern"
replace ofgem_region = "North East England" if ofgem_region == "North East"
replace ofgem_region = "North West England" if ofgem_region == "North West"
replace ofgem_region = "South East England" if ofgem_region == "South East"
replace ofgem_region = "South West England" if ofgem_region == "South West"
replace ofgem_region = "North Scotland" if ofgem_region =="Northern Scotland"
replace ofgem_region = "South Scotland" if ofgem_region == "Southern Scotland"
replace ofgem_region = "Southern England" if ofgem_region == "Southern"

replace ofgem_region = "United Kingdom" if ofgem_region == "GB average"
keep if year<=2020
keep ofgem_region year ElecSingle_Other_unitprice ElecSingle_Other_standingcharge

sa  "$dataProcess/unitcosts_elec_pre2020", replace


**for 2021 and after use the price cap data
use "$dataProcess/OfgemPriceCaps_EPG.dta" , clear

keep if endyear>=2021

keep region startmonth startyear endmonth endyear period capperiodno EPG up_ElecSingle_Other standcharge_ElecSingle_Other up_Gas_Other standcharge_Gas_Other up_ElecSingle_Other_EPG up_Gas_Other_EPG standcharge_ElecSingle_Other_EPG standcharge_Gas_Other_EPG

rename region ofgem_region

replace ofgem_region = "North Wales / Cheshire" if ofgem_region == "N Wales and Mersey"
replace ofgem_region = "East England" if ofgem_region =="Eastern"
replace ofgem_region = "West Midlands" if ofgem_region =="Midlands"
replace ofgem_region = "North East England" if ofgem_region == "Northern"
replace ofgem_region = "North West England" if ofgem_region == "North West"
replace ofgem_region = "South East England" if ofgem_region == "South East"
replace ofgem_region = "North Scotland" if ofgem_region =="Northern Scotland"
replace ofgem_region = "South Scotland" if ofgem_region == "Southern Scotland"
replace ofgem_region = "Southern England" if ofgem_region == "Southern"
replace ofgem_region = "South West England" if ofgem_region == "Southern Western"

gen Gas_Other_unitprice = up_Gas_Other if EPG==0
replace Gas_Other_unitprice = up_Gas_Other_EPG if EPG==1

gen Gas_Other_standingcharge = standcharge_Gas_Other*365 if EPG==0
replace Gas_Other_standingcharge = standcharge_Gas_Other_EPG*365 if EPG==1

gen ElecSingle_Other_unitprice = up_ElecSingle_Other if EPG==0
replace ElecSingle_Other_unitprice = up_ElecSingle_Other_EPG if EPG==1

gen ElecSingle_Other_standingcharge = standcharge_ElecSingle_Other*365 if EPG==0
replace ElecSingle_Other_standingcharge = standcharge_ElecSingle_Other_EPG*365 if EPG==1

gen EPGsubsidy_up_Elec = up_ElecSingle_Other_EPG/up_ElecSingle_Other -1
gen EPGsubsidy_up_Gas =  up_Gas_Other_EPG/up_Gas_Other -1

keep ofgem_region capperiodno  ElecSingle_Other_unitprice ElecSingle_Other_standingcharge Gas_Other_unitprice Gas_Other_standingcharge EPGsubsidy_up_Elec EPGsubsidy_up_Gas

replace ofgem_region = "United Kingdom" if ofgem_region == "GB average"

sa "$dataProcess/unitcosts_gas_elec_post2020", replace


u "$dataProcess/dates_yrmn", clear
expand 16
gen ofgem_region=""
bys year month: replace ofgem_region = "East England" if _n==1
bys year month: replace ofgem_region = "East Midlands" if _n==2
bys year month: replace ofgem_region = "London" if _n==3
bys year month: replace ofgem_region = "North East England" if _n==4
bys year month: replace ofgem_region = "North Scotland" if _n==5
bys year month: replace ofgem_region = "North Wales / Cheshire" if _n==6
bys year month: replace ofgem_region = "North West England" if _n==7
bys year month: replace ofgem_region = "Northern Ireland" if _n==8
bys year month: replace ofgem_region = "South East England" if _n==9
bys year month: replace ofgem_region = "South Scotland" if _n==10
bys year month: replace ofgem_region = "South Wales" if _n==11
bys year month: replace ofgem_region = "South West England" if _n==12
bys year month: replace ofgem_region = "Southern England" if _n==13
bys year month: replace ofgem_region = "United Kingdom" if _n==14
bys year month: replace ofgem_region = "West Midlands" if _n==15
bys year month: replace ofgem_region = "Yorkshire" if _n==16

merge m:1 year ofgem_region using "$dataProcess/unitcosts_gas_pre2020"
drop if _m==2
drop _m

merge m:1 year ofgem_region using "$dataProcess/unitcosts_elec_pre2020"
drop if _m==2
drop _m

replace capperiodno = . if (year==2021 & month<10)|(year<2021)
merge m:1 capperiodno ofgem_region using "$dataProcess/unitcosts_gas_elec_post2020", update  replace
drop if _m==2
drop _m

gen cap_binding = capperiodno!=.
drop capperiodno
label var cap_binding "=1 if using cap price as the price"

sort yrmn 

merge m:1 year month using "$dataProcess/cpi_stata", keepusing(cpi_energy cpi_electricity cpi_gas cpi_nondur_excenergy)
drop if _m==2
drop _m

gen mp_gas = Gas_Other_unitprice if cap_binding==1
gen mp_elec = ElecSingle_Other_unitprice if cap_binding==1

gen f_gas = Gas_Other_standingcharge if cap_binding==1
gen f_elec = ElecSingle_Other_standingcharge if cap_binding==1

ren cpi_electricity cpi_elec

**rebase CPI to level in Oct 21 - this is to uprate the unit costs by the cpi when the cap doesn't bind
foreach x in cpi_gas cpi_elec cpi_ener {
	su `x' if year == 2021 & month ==10
	gen `x'_idx = `x'/r(mean)

}

foreach var in elec gas {
	foreach price in mp_`var' f_`var' {
		gen Oct2021_`price'_`var'_temp = `price' if year==2021 & month==10
		bysort ofgem_region:  egen  Oct2021_`price'_`var' = min(Oct2021_`price'_`var'_temp)
		drop Oct2021_`price'_`var'_temp
		replace `price' = Oct2021_`price'_`var'*cpi_`var'_idx if cap_binding==0
		drop Oct2021_`price'_`var'

	}
}


drop cpi_gas_idx cpi_elec_idx cpi_ener_idx

**rebase unit prices to Jan 2019
foreach x in mp_elec mp_gas {
	gen t1 = `x' if year == 2019 & month == 1
	bysort ofgem_region: egen t2 = max(t1)

	gen `x'_idx = `x'/t2
	drop t1 t2 
}



replace Gas_Other_standingcharge = f_gas
replace ElecSingle_Other_standingcharge = f_elec

ren Gas_Other_standingcharge Gas_Other_sc
ren ElecSingle_Other_standingcharge ElecSingle_Other_sc

replace Gas_Other_unitprice = mp_gas
replace ElecSingle_Other_unitprice = mp_elec 

foreach v in Gas_Other_sc ElecSingle_Other_sc Gas_Other_unitprice ElecSingle_Other_unitprice mp_gas_idx mp_elec_idx {
	gen `v'_gb = `v' if ofgem_region=="United Kingdom"
	bysort yrmn: egen temp = mean(`v'_gb )
	replace `v'_gb  = temp
	drop temp
}

merge m:1 yrmn using "$dataProcess/monthlyenergyquantities", keep(1 3) nogen keepusing(smoothDomestic_gas_sa smoothDomestic_elec_sa)

foreach var in gas elec {
	
	bys ofgem_region: gen q0_`var'_temp = smoothDomestic_`var'_sa if year==2019 & month==1
	egen q0_`var' = min(q0_`var'_temp), by(ofgem_region)
	
	bys ofgem_region: gen p0_`var'_temp = mp_`var' if year==2019 & month==1
	egen p0_`var' = min(p0_`var'_temp), by(ofgem_region)
}

*2019 implied gas share (to check)
*gen impliedgasshare = q0_gas*p0_gas/(q0_gas*p0_gas + q0_elec*p0_elec)

gen pidx_energy_tot_altlasp = (q0_gas*mp_gas + q0_elec*mp_elec)/(q0_gas*p0_gas + q0_elec*p0_elec) if year>=2019
label var pidx_energy_tot_altlasp "Laspeyres using Jan 2019 quantities as weights"
gen pidx_energy_tot_paasche = (smoothDomestic_gas_sa*mp_gas  + smoothDomestic_elec_sa*mp_elec)/(smoothDomestic_gas_sa*p0_gas + smoothDomestic_elec_sa*p0_elec) if year>=2019
label var pidx_energy_tot_paasche "Paasche using current quantities as weights"
gen pidx_energy_tot_fisher =  (pidx_energy_tot_paasche*pidx_energy_tot_altlasp)^0.5 if year>=2019
label var pidx_energy_tot_fisher "Fisher using quantities as weights"

*chained indices 
foreach var in gas elec {
	bys ofgem_region (yrmn): gen qtminusone_`var' = smoothDomestic_`var'_sa[_n-1]
	bys ofgem_region (yrmn): gen ptminusone_`var' = mp_`var'[_n-1]
}

gen pidx_energy_tot_altlasp_chain  = 1 if year==2019 & month==1
bys ofgem_region (yrmn): replace pidx_energy_tot_altlasp_chain = pidx_energy_tot_altlasp_chain[_n-1]*(qtminusone_gas*mp_gas + qtminusone_elec*mp_elec)/(qtminusone_gas*ptminusone_gas + qtminusone_elec*ptminusone_elec) if (year==2019 & month>=2)|year>2019
label var pidx_energy_tot_altlasp_chain "Chained Laspeyres using quantities as weights"

gen pidx_energy_tot_paasche_chain  = 1 if year==2019 & month==1
bys ofgem_region (yrmn): replace pidx_energy_tot_paasche_chain = pidx_energy_tot_paasche_chain[_n-1]*(smoothDomestic_gas_sa*mp_gas + smoothDomestic_elec_sa*mp_elec)/(smoothDomestic_gas_sa*ptminusone_gas + smoothDomestic_elec_sa*ptminusone_elec) if (year==2019 & month>=2)|year>2019
label var pidx_energy_tot_paasche_chain "Chained Paasche quantities as weights"

gen pidx_energy_tot_fisher_chain  = 1 if year==2019 & month==1
bys ofgem_region (yrmn): replace pidx_energy_tot_fisher_chain = pidx_energy_tot_fisher_chain[_n-1]*((smoothDomestic_gas_sa*mp_gas + smoothDomestic_elec_sa*mp_elec)/(smoothDomestic_gas_sa*ptminusone_gas + smoothDomestic_elec_sa*ptminusone_elec)*(qtminusone_gas*mp_gas + qtminusone_elec*mp_elec)/(qtminusone_gas*ptminusone_gas + qtminusone_elec*ptminusone_elec))^0.5 if (year==2019 & month>=2)|year>2019
label var pidx_energy_tot_fisher_chain "Chained Fisher quantities as weights"

foreach v in pidx_energy_tot_altlasp pidx_energy_tot_paasche pidx_energy_tot_fisher pidx_energy_tot_altlasp_chain pidx_energy_tot_paasche_chain pidx_energy_tot_fisher_chain {
	gen `v'_gb = `v' if ofgem_region=="United Kingdom"
	bysort yrmn: egen temp = mean(`v'_gb )
	replace `v'_gb  = temp
	local lbl : variable label `v'
	label var `v'_gb "`lbl', GB average"
	drop temp
}

drop p0* q0* smoothDomestic_gas_sa smoothDomestic_elec_sa  qtminusone* ptminusone*

**construct price and quantity index
gen pidx_energy_tot_lasp = `fixedweight'*mp_gas_idx + (1-`fixedweight')*mp_elec_idx
label var pidx_energy_tot_lasp "Fixed weight laspeyres using 2019 gas share as base"

gen pidx_energy_tot_lasp_gb = `fixedweight'*mp_gas_idx_gb + (1-`fixedweight')*mp_elec_idx_gb
label var pidx_energy_tot_lasp_gb "Fixed weight laspeyres using 2019 gas share as base, GB average"

gen EPGsubsidy_Energy = `fixedweight'*EPGsubsidy_up_Gas + (1-`fixedweight')*EPGsubsidy_up_Elec
label var  EPGsubsidy_Energy "EPG unit subsidy for energy"

sort year month ofgem_region

drop f_gas f_elec mp_gas mp_elec
drop if ofgem_region=="United Kingdom"
drop if ofgem_region=="Northern Ireland"

sa "$dataProcess/unitcosts_gas_elec_yrmn", replace

**heterogeneity measures by price
if $synthetic==0 {
use "$dataProcess/LCFS_sharegas_byincandexp", clear
}
if $synthetic==1 {
use "$dataRaw/LCFS_sharegas_byincandexp", clear
}	
matrix gasshare = J(5,5,-999)
forval i = 1/5 {
	forval j = 1/5 {
		qui su share_gas if quintinc==`i' & quintenergyspend==`j', meanonly
		matrix gasshare[`i',`j'] = r(mean)
	}
}
matrix rownames gasshare = "quintinc1" "quintinc2" "quintinc3" "quintinc4" "quintinc5"  
matrix colnames gasshare =  "quintexp1" "quintexp2" "quintexp3" "quintexp4" "quintexp5"

use "$dataProcess/unitcosts_gas_elec_yrmn", replace

merge m:1 year month using "$dataProcess/cpi_stata", nogen
ren cpi cpi_allitems


expand 5
bysort yrmn ofgem_region: gen inc_quint = _n
expand 5
bysort yrmn ofgem_region inc_quint: gen eexp_quint = _n


**we make everything real  because it is merged in after making real 
gen pidx_energy_tot_lasp_het = .
forval i = 1/5 {
	forval j = 1/5 {
		replace pidx_energy_tot_lasp_het = gasshare[`i',`j']*mp_gas_idx + (1-gasshare[`i',`j'])*mp_elec_idx if inc_quint == `i' & eexp_quint == `j'
	}
}

replace pidx_energy_tot_lasp_het = pidx_energy_tot_lasp_het/cpi_allitems
gen lprice_het = log(pidx_energy_tot_lasp_het)


keep yrmn ofgem_region inc_quint eexp_quint pidx_energy_tot_lasp_het lprice_het
drop if yrmn == .

save "$dataProcess/laspeyres_hetweights", replace



**********




