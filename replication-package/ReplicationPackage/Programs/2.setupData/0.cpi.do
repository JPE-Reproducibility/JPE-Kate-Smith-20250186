

clear 
import excel using "$dataRaw/downloaded/cpi", first sheet("cpi")

rename Value cpi

gen monthname = substr(Period,6,3)
gen year= substr(Period,1,4)
destring year, replace

keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

gen month = 1 if monthname=="JAN"
replace month = 2 if monthname=="FEB"
replace month = 3 if monthname=="MAR"
replace month = 4 if monthname=="APR"
replace month = 5 if monthname=="MAY"
replace month = 6 if monthname=="JUN"
replace month = 7 if monthname=="JUL"
replace month = 8 if monthname=="AUG"
replace month = 9 if monthname=="SEP"
replace month = 10 if monthname=="OCT"
replace month = 11 if monthname=="NOV"
replace month = 12 if monthname=="DEC"

*rebase
su cpi if year==2022 & month==12
replace cpi = cpi/r(mean)

tempfile cpi_stata
save `cpi_stata'

** make annual cpi for deflating USoc (which is average spending over the last year)
clear 
import excel using "$dataRaw/downloaded/cpi", first sheet("cpi")
gen yearly  = regexm(Period, "^[0-9]{4}$")
keep if yearly==1
gen year= substr(Period,1,4)
destring year, replace
rename Value cpi
su cpi if year==2022 
replace cpi = cpi/r(mean)
drop yearly
save "$dataProcess/cpi_stata_annual", replace

clear

**refresh' the data connection in this file to update (series is DK9U)
import excel using "$dataRaw/downloaded/cpi", first sheet("energy_cpi")

rename Value cpi_energy

gen monthname = substr(Period,6,3)
gen year= substr(Period,1,4)
destring year, replace

keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

gen month = 1 if monthname=="JAN"
replace month = 2 if monthname=="FEB"
replace month = 3 if monthname=="MAR"
replace month = 4 if monthname=="APR"
replace month = 5 if monthname=="MAY"
replace month = 6 if monthname=="JUN"
replace month = 7 if monthname=="JUL"
replace month = 8 if monthname=="AUG"
replace month = 9 if monthname=="SEP"
replace month = 10 if monthname=="OCT"
replace month = 11 if monthname=="NOV"
replace month = 12 if monthname=="DEC"

*rebase
su cpi_energy if year==2022 & month==12
replace cpi_energy= cpi_energy/r(mean)

tempfile energycpi_stata
save `energycpi_stata'


clear 
**refresh' the data connection in this file to update (series is D7DT)
import excel using "$dataRaw/downloaded/cpi", first sheet("elec_cpi")

rename Value cpi_electricity

gen monthname = substr(Period,6,3)
gen year= substr(Period,1,4)
destring year, replace

keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

gen month = 1 if monthname=="JAN"
replace month = 2 if monthname=="FEB"
replace month = 3 if monthname=="MAR"
replace month = 4 if monthname=="APR"
replace month = 5 if monthname=="MAY"
replace month = 6 if monthname=="JUN"
replace month = 7 if monthname=="JUL"
replace month = 8 if monthname=="AUG"
replace month = 9 if monthname=="SEP"
replace month = 10 if monthname=="OCT"
replace month = 11 if monthname=="NOV"
replace month = 12 if monthname=="DEC"

*rebase
su cpi_electricity if year==2022 & month==12
replace cpi_electricity= cpi_electricity/r(mean)

tempfile eleccpi_stata
save `eleccpi_stata'

clear
**refresh' the data connection in this file to update (series is D7DU)
import excel using "$dataRaw/downloaded/cpi", first sheet("gas_cpi")

rename Value cpi_gas

gen monthname = substr(Period,6,3)
gen year= substr(Period,1,4)
destring year, replace

keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

gen month = 1 if monthname=="JAN"
replace month = 2 if monthname=="FEB"
replace month = 3 if monthname=="MAR"
replace month = 4 if monthname=="APR"
replace month = 5 if monthname=="MAY"
replace month = 6 if monthname=="JUN"
replace month = 7 if monthname=="JUL"
replace month = 8 if monthname=="AUG"
replace month = 9 if monthname=="SEP"
replace month = 10 if monthname=="OCT"
replace month = 11 if monthname=="NOV"
replace month = 12 if monthname=="DEC"

*rebase
su cpi_gas if year==2022 & month==12
replace cpi_gas= cpi_gas/r(mean)

tempfile gascpi_stata
save `gascpi_stata'

clear

import excel using "$dataRaw/downloaded/cpi", first sheet("food_cpi")

rename Value cpi_food

gen monthname = substr(Period,6,3)
gen year= substr(Period,1,4)
destring year, replace

keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

gen month = 1 if monthname=="JAN"
replace month = 2 if monthname=="FEB"
replace month = 3 if monthname=="MAR"
replace month = 4 if monthname=="APR"
replace month = 5 if monthname=="MAY"
replace month = 6 if monthname=="JUN"
replace month = 7 if monthname=="JUL"
replace month = 8 if monthname=="AUG"
replace month = 9 if monthname=="SEP"
replace month = 10 if monthname=="OCT"
replace month = 11 if monthname=="NOV"
replace month = 12 if monthname=="DEC"

**rebase
su cpi_food if year==2022 & month==12
replace cpi_food= cpi_food/r(mean)

merge 1:1 year month using `cpi_stata', assert(3) nogen
merge 1:1 year month using `energycpi_stata', assert(3) nogen
merge 1:1 year month using `eleccpi_stata', assert(3) nogen
merge 1:1 year month using `gascpi_stata', assert(3) nogen

order Period year month monthname cpi cpi_*


**nondurable cpi prices (excluding energy) 
merge m:1 year month using "$dataRaw/cpinondurables_exenergy"
drop if _m==2
drop _m
rename chainedindex cpi_nondur_excenergy
label var cpi_nondur_excenergy "CPI nondurables excluding energy"
drop modate

replace cpi_nondur_excenergy = cpi_nondur_excenergy/100 //divide through by 100


save "$dataProcess/cpi_stata", replace
