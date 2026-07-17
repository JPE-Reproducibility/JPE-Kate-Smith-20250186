
set more off
clear all


**********
** Merge in LSOA data and then temperature data

u "$dataProcess/CSenergyallspending_step2_combine", clear

merge m:1 lsoa year month using "$dataProcess/weather"
drop if _m==2
drop _m


gen postcode_district = substr(postcode_sector,1,strpos(postcode_sector, " "))
replace postcode_district = subinstr(postcode_district," ","",.)
merge m:1 postcode_district using "$dataProcess/postcodedistricts2ofgemregions_expanded"
drop if _m==2

**sort out some postcodes that are not classified
gen twodigitpostcode = substr(postcode_district,1,2)
replace ofgem_region = "Yorkshire" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"YO","HD","DN","BB","S2")
replace ofgem_region = "East England" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"WD","PE","RM","NW","CM","CB","N2","LE")
replace ofgem_region = "London" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"WC","SW","EC","W1","N1","E1","E2")
replace ofgem_region = "South West England" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"TR","EX")
replace ofgem_region = "North West England" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"SK","OL","PR","IM","BS","M5")
replace ofgem_region = "Southern England" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"RG","OX","SN","JE","GU","GL","SO")
replace ofgem_region = "North Scotland" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"PH","KW","KA","IV","HS","AB")
replace ofgem_region = "South Wales" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"NP","CF")
replace ofgem_region = "East Midlands" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"NN","S3")
replace ofgem_region = "West Midlands" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"NN","HR","CV")
replace ofgem_region = "North Wales / Cheshire" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"CH")

replace ofgem_region = "Northern Ireland" if gor==12

assert  ofgem_region !=""
drop _m

**some users don't have lsoa identifiers - use mean across country for them
foreach var in tmax tmin tavg rain humid  {
	bysort year month: egen temp = mean(`var')
	replace `var' = temp if `var' == .
	drop temp
}

drop geo_label name 

**merge in price data 
merge m:1 year month using "$dataProcess/cpi_stata"
drop if _m==2
drop _m
drop Period monthname
ren cpi cpi_allitems


merge m:1 year month ofgem_region using "$dataProcess/unitcosts_gas_elec_yrmn"
drop if _m==2
drop _m


replace exp_energy_t = 0 if exp_energy_t == .


**Adjust for rebates
gen EBSS_refund = max(EBSS_refund1, EBSS_refund2)

bysort userref: egen EBSS_everrefund = max(EBSS_refund)

gen exp_energy_t_reb = exp_energy_t
replace exp_energy_t_reb = exp_energy_t_reb + 66 		if (yrmn>=202210 & yrmn<=202211) & EBSS_refund == 0  & sample_PP == 0
replace exp_energy_t_reb = exp_energy_t_reb + 67 		if (yrmn>=202212 & yrmn<=202303)  & EBSS_refund == 0  & sample_PP == 0
replace exp_energy_t_reb = exp_energy_t_reb + 66*0.90 	if (yrmn>=202210 & yrmn<=202211) & EBSS_refund == 0  & sample_PP == 1		//only 90% of rebates were claimed for PP people
replace exp_energy_t_reb = exp_energy_t_reb + 67*0.90 	if (yrmn>=202212 & yrmn<=202303)  & EBSS_refund == 0  & sample_PP == 1		//only 90% of rebates were claimed for PP people

replace exp_energy_t_reb = exp_energy_t if gor == 12

label var exp_energy_t_reb "Total energy spend in year-month (across all modes). Adding EBSS rebate."
order exp_energy_t_reb, after(exp_energy_t)
ren exp_energy_t exp_energy_t_noreb

gen exp_energy_t_sc = 30*ElecSingle_Other_sc/365 + 30*Gas_Other_sc/365
gen exp_energy_t_sc_gb = 30*ElecSingle_Other_sc_gb/365 + 30*Gas_Other_sc_gb/365

	
foreach x in noreb reb {

	gen exp_energy_t_`x'_nosc = exp_energy_t_`x' - exp_energy_t_sc	//subtract off standing charges
	replace exp_energy_t_`x'_nosc = 0 if exp_energy_t_`x'_nosc<0 

	gen exp_energy_t_`x'_nosc_gb = exp_energy_t_`x' - exp_energy_t_sc_gb	//subtract off standing charges
	replace exp_energy_t_`x'_nosc_gb = 0 if exp_energy_t_`x'_nosc_gb <0 

}


**adjust non-durable spending to account for rebate
gen tot_out_nondurab_noreb = tot_out_nondurab
gen tot_out_nondurab_reb = tot_out_nondurab + (exp_energy_t_reb - exp_energy_t_noreb) 	//adjust for energy rebate 
order tot_out_nondurab_noreb, after(tot_out_nondurab)
order tot_out_nondurab_reb, after(tot_out_nondurab_noreb)
label var tot_out_nondurab_noreb "Total amount out (non-durables) in that year-month, excl. EBSS rebate"
label var tot_out_nondurab_reb "Total amount out (non-durables) in that year-month, incl. EBSS rebate"

gen qidx_energy_reb_tot = exp_energy_t_reb_nosc/pidx_energy_tot_lasp
gen qidx_energy_reb_tot_gb = exp_energy_t_reb_nosc_gb/pidx_energy_tot_lasp_gb
gen qidx_energy_noreb_tot = exp_energy_t_reb_nosc/pidx_energy_tot_lasp


label var tmin 		"Min temp in LSOA in year-month"
label var tmax 		"Max temp in LSOA in year-month"
label var tavg 		"Average temp in LSOA in year-month"
label var humid 		"Humidity in LSOA in year-month"
label var cpi_energy 	"CPI energy"
label var cpi_allitems 	"CPI overall"
label var cpi_food 		"CPI food"

label var exp_energy_t_sc "Monthly standing charge for energy"
label var exp_energy_t_noreb_nosc "Imputed variable spending on energy (no EBSS rebate)"
label var exp_energy_t_reb_nosc "Imputed variable spending on energy (incl. EBSS rebate)"
label var qidx_energy_reb_tot 		"Quantity index of energy purchased in yrmn (incl. EBSS rebate)"
label var qidx_energy_noreb_tot 		"Quantity index of energy purchased in yrmn (no EBSS rebate)"

isid userref yrmn
sort userref yrmn
compress 


sa "$dataProcess/CSenergyallspending_step3_combine", replace

u "$dataProcess/CSenergyallspending_step3_combine", clear

gen dayspermonth = 31 if month==1
replace dayspermonth = 28 if month==2 & year!=2020 & year!=2016
replace dayspermonth = 29 if month==2 & (year==2020|year==2016)
replace dayspermonth = 31 if month==3
replace dayspermonth = 30 if month==4
replace dayspermonth = 31 if month==5
replace dayspermonth = 30 if month==6
replace dayspermonth = 31 if month==7
replace dayspermonth = 31 if month==8
replace dayspermonth = 30 if month==9
replace dayspermonth = 31 if month==10
replace dayspermonth = 31 if month==11
replace dayspermonth = 31 if month==12



**make all nominal values real
// Loop through all variables in the dataset
foreach var of varlist _all {
    // Check if the variable name contains any of the specified substrings
    if (strpos("`var'", "exp") | strpos("`var'", "amount") | strpos("`var'", "cpi") ///
       | strpos("`var'", "price") | strpos("`var'", "sc") | strpos("`var'", "subsidy") ///
       | strpos("`var'", "idx") | strpos("`var'", "tot_in") | strpos("`var'", "tot_out") | strpos("`var'", "asset") ////
		| strpos("`var'", "cwp") | strpos("`var'", "wfp")) & strpos("`var'", "cpi_allitems") == 0 & strpos("`var'", "qidx") == 0{
        // Perform the replacement
        replace `var' = `var' / cpi_allitems
        
        // Modify the variable label
        local current_label: variable label `var'
        label variable `var' "`current_label' REAL"
    }
}



// Generate new variables with their constructions
gen leqnt_noreb = log(qidx_energy_noreb_tot / dayspermonth)
label variable leqnt_noreb "Log of energy quantity (no rebate) per day"

gen leqnt = log(qidx_energy_reb_tot / dayspermonth)
label variable leqnt "Log of energy quantity (with rebate) per day"

gen leqnt_gb = log(qidx_energy_reb_tot_gb / dayspermonth)
label variable leqnt_gb "Log of energy quantity (with rebate, GB) per day"

gen lexp = log(exp_energy_t_reb / dayspermonth)
label variable lexp "Log of energy expenditure (with rebate) per day"

gen lexp_nosc = log(exp_energy_t_reb_nosc / dayspermonth)
label variable lexp "Log of energy expenditure (with rebate, no SC) per day"

gen lexp_noreb = log(exp_energy_t_noreb / dayspermonth)
label variable lexp_noreb "Log of energy expenditure (no rebate) per day"

gen lprice = log(pidx_energy_tot_lasp)
label variable lprice "Log of energy price index (Laspeyres)"

gen lpnondur = log(cpi_nondur_excenergy)
label variable lpnondur "Log of CPI for non-durables excluding energy"

gen lrealprice = lprice - lpnondur
label variable lrealprice "Real price of energy (log price - log CPI non-durables)"

gen lprice2 = lprice^2
label variable lprice2 "Squared log of energy price index"


gen ltotexp_nondur = log(tot_out_nondurab_reb/dayspermonth)
label variable ltotexp_nondur "Log of nondurable energy spending (with rebate) per day"

gen ltotexp_nondur_noreb = log(tot_out_nondurab_noreb/dayspermonth)
label variable ltotexp_nondur_noreb "Log of nondurable energy spending (no rebate) per day"


gen log_inc = log(tot_in_excltrans/dayspermonth)
label variable log_inc "Log of income per day"
gen lnY = ln(tot_in_excltrans)
label variable log_inc "Log of income per day"

egen reccol = max(col), by(userref)

gen tot_out_nondurab_reb_nosc = tot_out_nondurab_reb-exp_energy_t_sc
label variable tot_out_nondurab_reb_nosc "Nondurable energy spending (with rebate) net of standing charge"
gen s_ener_nosc = (exp_energy_t_reb-exp_energy_t_sc)/tot_out_nondurab_reb_nosc
replace s_ener_nosc  = exp_energy_t_reb/tot_out_nondurab_reb if gor == 12 //northern ireland - don't know standing charge
replace tot_out_nondurab_reb_nosc  = tot_out_nondurab_reb if gor == 12 //northern ireland - don't know standing charge
label variable s_ener_nosc "Energy budget share net of standing charge"




gen postmonth = yrmn
replace postmonth = 0 if yrm<202001 & dataset==1
replace postmonth = 0 if yrm<201901 & dataset==2

**Periods when work from home was encouraged
gen wfh = 0 
replace wfh = 1 if year==2020 & inlist(month,3,12)
**Sources for 2021
**https://www.gov.uk/government/publications/covid-19-response-spring-2021/covid-19-response-spring-2021-summary
**https://www.personneltoday.com/hr/omicron-working-from-home-set-to-be-announced-in-england/
replace wfh = 1 if year==2021 & inlist(month,1,2,3,12)
replace wfh = 1 if year==2022 & month==1

gen rebates = (year==2022 & month>=10)|(year==2023 & month <=3)


egen age_5band = cut(age), at(16(5)91)
replace age_5band = 76 if age_5band>=76

foreach var in month lprice lprice2 {
	gen `var'_pre2020 = `var' if year<=2018 & dataset==2
	replace `var'_pre2020 = 0 if year>=2020 & dataset==1
} 

**create variable that's the same as lexp to make it easier to loop over all cases (including when we use the full sample and not just the variable sample)
gen lexp_fullsamp = lexp
gen lexp_fullsamp_noreb =lexp_noreb

ren weight_fullsamp weight_fullsam_all
ren weight_balsamp weight_balsam_all

gen tmin2 = tmin^2/10
gen tmin3 = tmin^3/100
gen tmin4 = tmin^4/1000
gen tmin5 = tmin^5/10000

gen tmax2 = tmax^2/10	
gen tmax3 = tmax^3/100
gen tmax4 = tmax^4/1000
gen tmax5 = tmax^5/10000
gen tminlesstmax2 = (tmin-tmax)^2

isid yrmn userref
sort yrmn userref
egen t = group(yrmn)
gen t2 = t^2

gen month2 = month^2


**time periods
drop postmonth
gen postmonth = yrmn
replace postmonth = 0 if yrm<202001 

gen postmonth2 = yrmn
replace postmonth2 = 0 if yrm<202101 

gen postmonth3 = yrmn
replace postmonth3 = 0 if yrm<202106 

gen postmonth4 = yrmn
replace postmonth4 = 0 if yrm<202111

gen tt_toinclude = ((year==2021 & month>=6)|(year==2022 & month<10))
gen tt_toinclude2 = ((year==2021 & month>=6)|inlist(year,2022,2023))

gen onemonth_post = (year == 2021 & (month ==10)) | (year == 2022 & (month ==4))
gen onemonth_pre = (year == 2021 & (month==9)) | (year == 2022 & (month==3))

**drop outliers 
gen sample = 1 if sample_PP == 1
replace sample = 2 if sample_variable_semistrict == 1
replace sample = 3 if sample == .
label def sample 1 "PP" 2 "Variable DD semistrict" 3 "Everyone else (mainly fixed DD)"
label val sample sample




gen dropflag = 0
replace dropflag = 1 if (sample==3)

gen drop_outliers = 0

replace drop_outliers = 1 if (s_ener_nosc<0.01|s_ener_nosc>=1) 

forval year = 2019/2023 {
	forval m = 1/12 {
		disp as error "Year `year', month `m'"

		_pctile s_ener_nosc if year==`year' & month == `m'  & s_ener_nosc<1 & NI!=1, p(99)
		gen lb = s_ener_nosc<0.01 & year==`year' & month == `m' 
		gen ub = s_ener_nosc>r(r1) & year==`year' & month == `m' 
		
		replace drop_outliers = 1 if (lb==1|ub==1) & year==`year' & month == `m' & drop_outliers==0 
		
		drop lb ub
		
		_pctile tot_out_nondurab_reb_nosc if year==`year' & month == `m'  & NI!=1, p(1 99)
		gen lb =  tot_out_nondurab_reb_nosc<r(r1) & year==`year' & month == `m' 
		gen ub =  tot_out_nondurab_reb_nosc>r(r2) & year==`year' & month == `m' 
		
		replace drop_outliers = 1 if (lb==1|ub==1) & year==`year' & month == `m' & drop_outliers==0 
		
		drop lb ub

		_pctile log_inc if year==`year' & month == `m' & NI!=1, p(1 99)
		gen lb =  log_inc<r(r1) & year==`year' & month == `m' 
		gen ub =  log_inc>r(r2) & year==`year' & month == `m' 
		
		replace drop_outliers = 1 if (lb==1|ub==1) & year==`year' & month == `m' & drop_outliers==0 
		
		drop lb ub
	}
}


replace drop_outliers = 1 if log_inc==. 
replace drop_outliers = 1 if (col==.| rain==.) 


**new condition requiring being present at least 6 months in the tt_toinclude2 period
gen temp = (1-drop_outliers)*tt_toinclude2
bysort userref: egen totN = total(temp)

replace drop_outliers = 1 if totN<6
drop totN temp

replace dropflag = 1 if drop_outliers == 1


isid userref year month
sort userref year month



**notes: drop_outliers drops extreme values from the CS variable sample
**	     drop_flag additionally drops the CS fixed payment sample


sa "$dataProcess/CSenergyallspending_step4", replace

*/

**********




**********
**CREATE HETEROGENEITY MEASURES: INCOME, PRE-CRISIS ENERGY SPENDING AND EPC CONSUMPTION



u "$dataProcess/CSenergyallspending_step4", clear

**drop outliers
drop if drop_outliers == 1
drop if NI==1

isid userref year month 
sort userref year month 
by userref year: egen mtot_in_excltrans = mean(tot_in_excltrans)
by userref year: egen mtot_out_nondurab = mean(tot_out_nondurab)
by userref year: egen mexp_energy_t_reb = mean(exp_energy_t_reb)

**keep the pre-period (2019 and 2020)
drop if year>=2021 

collapse (mean) mtot_in_excltrans mtot_out_nondurab  mexp_energy_t_reb  sample (max) onbenefits children, by(userref)

**drop extremes of income distribution
su mtot_in_excltrans, d
drop if mtot_in_excltrans<1000 | mtot_in_excltrans>r(p99)

gen mshr_e = mexp_energy_t_reb/mtot_out_nondurab

foreach v in mtot_in_excltrans mtot_out_nondurab  mexp_energy_t_reb  mshr_e {
	xtile `v'_p = `v' , nq(100)
	xtile `v'_dec = `v' , nq(10)
	xtile `v'_quint = `v' , nq(5)
	xtile `v'_quart = `v' , nq(4)
}

isid userref 
sort userref 


sa "$dataProcess/heterogeneity_measures.dta", replace

*/



u "$dataProcess/CSenergyallspending_step4", clear

**drop outliers
drop if drop_outliers == 1
drop if NI==1


**tax year
gen     yeartax = 2018 if (year==2018 & month>3) | (year==2019 & month<4)
replace yeartax = 2019 if (year==2019 & month>3) | (year==2020 & month<4)
replace yeartax = 2020 if (year==2020 & month>3) | (year==2021 & month<4)
replace yeartax = 2021 if (year==2021 & month>3) | (year==2022 & month<4)
replace yeartax = 2022 if (year==2022 & month>3) | (year==2023 & month<4)
replace yeartax = 2023 if (year==2023 & month>3) | (year==2024 & month<4)

drop if yeartax==.

**Merge in lagged tax year
replace yeartax = yeartax+1

rename tot_in_excltrans  inc

collapse (mean) inc ,by(userref yeartax)

drop if inc<1000 | inc>15000

tempfile temp
sa `temp'

su year
local mn = `r(min)'
local mx = `r(max)'
forv y =`mn'/`mx' {
	u `temp'
	
	keep if year==`y'
	foreach v in inc {
		xtile `v'_p_taxyr = `v'    , nq(100)	
		xtile `v'_dec_taxyr = `v'  , nq(10)
		xtile `v'_quint_taxyr = `v', nq(5)
	}

	tempfile temp`y'
	sa `temp`y''
}

u `temp`mn''

local mn = `mn'+1
forv y =`mn'/`mx' {
	append using `temp`y''
}

ren inc inc_taxyr

sort userref yeartax 

sa "$dataProcess/inc_measure_contemporaneous.dta", replace




******



**********
**Merge in heterogeneity measures

u "$dataProcess/CSenergyallspending_step4", clear


merge m:1 userref using "$dataProcess/heterogeneity_measures.dta"
drop if _m==2
gen no_heterogeneity_measures = _merge==1
drop _m

gen     yeartax = 2018 if (year==2018 & month>3) | (year==2019 & month<4)
replace yeartax = 2019 if (year==2019 & month>3) | (year==2020 & month<4)
replace yeartax = 2020 if (year==2020 & month>3) | (year==2021 & month<4)
replace yeartax = 2021 if (year==2021 & month>3) | (year==2022 & month<4)
replace yeartax = 2022 if (year==2022 & month>3) | (year==2023 & month<4)
replace yeartax = 2023 if (year==2023 & month>3) | (year==2024 & month<4)


merge m:1 userref yeartax using "$dataProcess/inc_measure_contemporaneous.dta"
gen no_lagged_income = _merge==1
drop if _m==2
drop _m


rename mtot_in_excltrans_quint inc_quint 
rename mexp_energy_t_reb_quint eexp_quint 
rename mshr_e_quint			   sexp_quint

rename mtot_in_excltrans_dec inc_dec
rename mexp_energy_t_reb_dec eexp_dec
rename mshr_e_dec 			 sexp_dec

rename mtot_in_excltrans_p inc_p
rename mexp_energy_t_reb_p eexp_p
rename mshr_e_p 		   sexp_p


rename mtot_in_excltrans minc
rename mexp_energy_t_reb meexp
rename mshr_e 			 msexp



merge m:1 yrmn ofgem_region inc_quint eexp_quint using "$dataProcess/laspeyres_hetweights"
drop _m //note _m==1 are for those with no heterogeneity measures


save "$dataProcess/CSenergyallspending_step5", replace

*/


**********



**********
**CREATE ANALYSIS DATASET WITH FEWER VARIABLES AND DESEASONALISED MEASURES


use "$dataProcess/CSenergyallspending_step5", clear 


gen sc_monthly = (mode1=="Card payment" & mode2 == "" & freq_monthly1 == 1 ) | (mode1=="Card payment" & mode2 =="Card payment" & freq_monthly1 == 1  & freq_monthly2 == 1 )


drop if drop_outliers == 1
drop if no_het == 1  & NI ==0
drop if year<=2018

#delimit ;
keep userref NI gor everheatingoil userref_orig yrmn inc_dec rebates energy_supplier1 energy_supplier2 col reccol wfh cpi_allitems 
salaryrange weight_fullsam_all weight_fullsam_vari? weight_fullsam_vari?_x 
EBSS_refund1 EBSS_everrefund1 EBSS_refund2 EBSS_everrefund2 year month onemonth* 
exp_energy_t* sample_*  sc_monthly
tmin tmax tavg humid rain  cpi_gas cpi_elec cpi_ener 
qidx_* pidx_energy_tot_lasp* leqnt_noreb leqnt lexp lexp_noreb  lexp_nosc
lprice rebates tmin? tmax? tminlesstmax2 t t2 lnY postmonth* tt_toinclude* sample  inc_quint eexp_quint sexp_quint ofgem_region
;
#delimit cr 



**change supplier between June 2021 and Dec 2021
isid userref yrmn 
sort userref yrmn
by userref: gen new_supplier = ((energy_supplier1 != energy_supplier1[_n-1]) & (energy_supplier1 != energy_supplier2[_n-1] )) | ((energy_supplier2 != energy_supplier2[_n-1]) & (energy_supplier2 != energy_supplier1[_n-1] ))

gen temp = yrmn>=202106 & yrmn<=202112
by userref: egen max_new_supplier = max(temp*new_supplier)
drop temp


**frequency of direct debit review by supplier
gen dd_review = 99
foreach x in 1 2 {
	decode energy_supplier`x', gen(supplier_str)
	replace dd_review = 1 if supplier_str == "Octopus Energy"  | supplier_str == "Scottish Power"
	replace dd_review = 2 if (supplier_str == "E.ON"  | supplier_str == "Ovo Energy" ) & dd_review == 99
	replace dd_review = 3 if (supplier_str == "British Gas"  | supplier_str == "EDF Energy" ) & dd_review == 99
	drop supplier_str
}





**EBSS ever paid into account
gen EBSS_refund = EBSS_refund1
replace EBSS_refund = 1 if EBSS_refund2 == 1
egen everEBSS = max(EBSS_refund>0), by(userref)
gen everEBSSbutnorebate_temp = 1 if everEBSS==1 & rebate==1 & EBSS_refund==0
egen everEBSSbutnorebate = min(everEBSSbutnorebate_temp), by(userref)

gen everEBSScash = everEBSS==1 if everEBSSbutnorebate!=1
drop everEBSSbutnorebate_temp

gen lexp_nom = log(exp(lexp)*cpi_allitems)

global tempcontrols "tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5  rain humid tminlesstmax2"


**Step 1: residualise using month dummies from 2019 and 2020
foreach v in lexp lexp_nosc lexp_nom leqnt {
	gen `v'_ds = `v'
	gen `v'_dsw = `v'
	foreach s in 1 2 3 {
		xtreg `v' i.month if sample==`s' & year<2021 & NI!=1, i(userref) fe robust
		forval m = 2/12 {
			replace `v'_ds = `v' - _b[`m'.month]  if `m'.month == 1 & sample == `s'
		}
		xtreg `v' i.month $tempcontrols if sample==`s' & year<2021 & NI!=1, i(userref) fe robust
		forval m = 2/12 {
			replace `v'_dsw = `v' - _b[`m'.month]  if `m'.month == 1 & sample == `s'
		}

	}
}

	

**now regress deseasonalised measure on year-month dummies
egen userref_sample = group(userref sample)
gen sample1 = sample==1
gen sample2 = sample==2
egen tt = group(yrmn)

gen weight_fullsam_vari_x = weight_fullsam_vari1_x if sample1==1
replace weight_fullsam_vari_x = weight_fullsam_vari2_x if sample2==1

gen weight_fullsam_vari = weight_fullsam_vari1 if sample1==1
replace weight_fullsam_vari = weight_fullsam_vari2 if sample2==1


tab month, gen(mm)

isid userref year month
sort userref year month 


sa "$dataProcess/CSenergyallspending_step6", replace


**********




