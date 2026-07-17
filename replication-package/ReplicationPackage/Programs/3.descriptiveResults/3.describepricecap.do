set more off
clear all

set scheme cleanplots





**********
** INSHEET OFGEM DATA ON TARIFFS

*taken from https://www.ofgem.gov.uk/retail-market-indicators
import excel using "$dataRaw/downloaded/cheapest-tariffs-by-paym.xlsx", cellrange(A2:G146) first clear
rename A date
extrdate month month = date
extrdate year year = date

gen monthly = ym(year, month)
format monthly %tm 


rename Largelegacysuppliersdirectd CheapestDD_Large
rename  Largelegacysuppliersstandard  CheapestSC_Large
rename  Largelegacysuppliersprepayme  CheapestPPM_Large
rename Marketdirectdebit CheapestDD_Market
rename Marketstandardcredit CheapestSC_Market
rename  Marketprepayment CheapestPPM_Market

tempfile tariffsbypaymenttype
save `tariffsbypaymenttype'

*taken from https://www.ofgem.gov.uk/retail-market-indicators#:~:text=The%20cheapest%20tariff%20in%20the,was%20unchanged%20at%20%C2%A318.
import excel using "$dataRaw/downloaded/availabletariffs_Ofgem.xlsx", cellrange(A2:H146) first clear

rename A date
extrdate month month = date
extrdate year year = date

gen monthly = ym(year, month)
format monthly %tm 

rename Averagestandardvariabletariff AvSVT_Large
rename C AvSVT_Other
rename Averagefixedtariff AvFixed
rename CheapesttariffLargelegacysu CheapestSVT_Large
rename CheapesttariffAllsuppliers  CheapestSVT_All
rename CheapesttariffBasket  CheapestSVT_Basket
rename Defaulttariffcaplevel EnergyPriceCap

merge 1:1 year month using "$dataProcess/OfgemPriceCaps_EPG_monthly"
drop _merge

merge 1:1 year month using `tariffsbypaymenttype'
drop _merge

merge m:1 year month using "$dataProcess/cpi_stata", nogen
ren cpi cpi_allitems


gen yrmn = year*100+month

merge m:1 yrmn using "$dataProcess/NI_priceseries"
drop _m

gen pIdx_NI_real = pIdx_NI/cpi_allitems

gen EPGval_real = EPGval/cpi_allitems
gen cap_real = cap/cpi_allitems
su cap_real if yrmn>=202210 & yrmn<=202212
su cap_real  if yrmn>=202204 & yrmn<=202209


**values for energy price cap when EPG is in effect
replace EnergyPriceCap = cap
rename cap_prepay EnergyPriceCap_Prepay 

gen proportion = CheapestSVT_Basket/min(EnergyPriceCap,EPGval)

local start = ym(2019,1)
loca end = ym(2023, 12)
di "`start'"
di "`end'"



#delimit ;
scatter EnergyPriceCap  CheapestSVT_Basket EPGval monthly if (year>=2019 & year<=2023),  c(l l l) msymbol(x s d) 
graphr(color(white)) lpattern(solid solid  solid )  xtitle("") ytitle("Annual bill at typical consumption values (£)")  lcolor(edkblue eltblue red) mcolor(edkblue eltblue red)
legend(label(1 "Energy price cap (price received by suppliers)") label(2 "Average of cheapest direct-debit pricing plans") label(3 "Energy price guarantee (price paid by consumers)") order(1 3 2 ) rows(3) pos(6)) xla(`start'(12)`end', format(%tm)) 
;
#delimit cr
graph export "$resultsdir/FIG_energypricecap_epg_cheapest.pdf", replace

#delimit ;
line EnergyPriceCap CheapestSVT_Basket EPGval EnergyPriceCap_Prepay CheapestPPM_Market EPGval_PPM  monthly if (year>=2019 & year<=2023), 
graphr(color(white)) lpattern(solid solid solid dash dash dash)  xtitle("") ytitle("Annual bill at typical consumption values (£)")  lcolor(edkblue eltblue red edkblue eltblue red) mcolor(edkblue eltblue red edkblue eltblue red)
legend(label(1 "Energy price cap") label(2 "Average of cheapest direct-debit pricing plans")  label(3 "Energy price guarantee") 
label(4 "Energy price cap (prepay)") label(5 "Average of cheapest prepayment pricing plans")  label(6 "Energy price guarantee (prepay)") 
order(1 4 3 6 2 5) rows(3) pos(6)) xla(`start'(12)`end', format(%tm)) 
;
#delimit cr
graph export "$resultsdir/FIG_energypricecap_epg_prepay.pdf", replace

 
su CheapestSVT_Basket if yrmn == 202106
gen energyprice_GB_rb = CheapestSVT_Basket/r(mean)

su pIdx_NI if yrmn == 202106
gen energyprice_NI_rb = pIdx_NI/r(mean) 


local start = ym(2021,1)
local end = ym(2022, 9)
di "`start'"
di "`end'"

#delimit ;
line energyprice_NI_rb energyprice_GB_rb monthly if (year>=2021 & yrmn<=202209), 
graphr(color(white)) lpattern(solid solid solid dash dash dash)  xtitle("") ytitle("Change relative to June 2021")  lcolor(edkblue red ) lpattern(dash solid)
legend(label(1 "NI energy price index") label(2 "Average of cheapest pricing plans in UK (excl. NI)")  
order(2 1) rows(3) pos(6)) xla(`start'(3)`end', format(%tm)) 
;
#delimit cr
graph export "$resultsdir/FIG_energypriceNI.pdf", replace



gen ratio_ppdd = EnergyPriceCap_Prepay/EnergyPriceCap
su ratio_ppdd if year ==2021 & month==6
gen ratio_ppdd_reb = ratio_ppdd/r(mean)

// table monthly, con(m ratio_ppdd m ratio_ppdd_reb)








**increases in real price of energy
use "$dataProcess/unitcosts_gas_elec_yrmn.dta", clear

merge m:1 year month using "$dataProcess/cpi_stata", nogen
ren cpi cpi_allitems

gen pidx_real = pidx_energy_tot_lasp/ cpi_allitems

cap log close
log using "$resultsdir/LOG_realpriceincreases.log", replace

su pidx_real if yrmn>=202104 & yrmn<=202109
global pidx_base = r(mean)

su pidx_real if yrmn>=202110 & yrmn<=202203
global pidx_oct21 = r(mean)
global pidxDelta_oct21 = $pidx_oct21/$pidx_base
disp $pidxDelta_oct21


su pidx_real if yrmn>=202204 & yrmn<=202209
global pidx_apr22 = r(mean)
global pidxDelta_apr22 = $pidx_apr22/$pidx_oct21
disp $pidxDelta_apr22


su pidx_real if yrmn>=202210 & yrmn<=202306
global pidx_oct22 = r(mean)
global pidxDelta_oct22 = $pidx_oct22/$pidx_apr22
disp $pidxDelta_oct22


su pidx_real if yrmn>=202307 & yrmn<=202309
global pidx_jul23 = r(mean)
global pidxDelta_jul23 = $pidx_jul23/$pidx_oct22
disp $pidxDelta_jul23


su pidx_real if yrmn>=202310 & yrmn<=202312
global pidx_oct23 = r(mean)
global pidxDelta_oct23 = $pidx_oct23/$pidx_jul23
disp $pidxDelta_oct23

log close


























