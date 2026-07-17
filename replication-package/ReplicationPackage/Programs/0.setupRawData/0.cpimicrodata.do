*Get CPI microdata

*defines program for chaining item indices
cap program drop chainitems
*do "${pricesdir}/do/chaining_item_indices"

*PL 06/11/2020
*This file takes a selection of item indices, combines them with appropriate weights then chains them together over time
capture program drop chainitems
program define chainitems

	syntax, startyear(numlist) endyear(numlist) coicopindex(string) savedirectory(string) regional(string) basedate(numlist) graph(string)
	
	*need a two year lag in weight data - earliest year is 1999 for weights
	capture assert `startyear'>=1998
	if _rc==9 {
		di as error "Error: startyear must be 1998 or greater"
		exit
	}
	
	capture assert `startyear'>=2001 if "`regional'"=="yes"
	if _rc==9 {
		di as error "Error: startyear must be 2001 or greater if regional is set to yes"
		exit
	}
	
	*rent data appear to be missing in the microdata files
	capture assert strpos("04.1","`coicopindex'") ==0 &  strpos("04","`coicopindex'")==0
	if _rc==9 {
		di in red "Warning: key items (local authority rents in E&W and NI) are missing for rental index"
	}
	
	*check base year 
	scalar baseyear = int(`basedate'/100)
	capture assert baseyear>=`startyear' & baseyear<=`endyear'
	if _rc==9 {
		di as error  "Error: basedate must in between startyear and endyear"
		exit
	}
	scalar drop baseyear
	
	use "${cpipricesdir}/itemindices", clear
	
	drop if year>`endyear'
	
	if "`regional'"=="yes" {
	    drop if year<1999
		*_merge==2 are dates out of scope
		qui merge 1:m item_id index_date using "${cpipricesdir}/item_index_region_allyears"
		qui assert _merge!=1 
		qui assert minstratum_type==maxstratum_type
		qui replace all_gm_index = regional_item_index if (minstratum_type==maxstratum_type & inlist(minstratum_type,1,2) & inlist(maxstratum_type,1,2))|imputation_flag=="FULL"
		*qui gen diff= all_gm_index - regional_item_index if minstratum_type==maxstratum_type & inlist(minstratum_type,0,3) & inlist(maxstratum_type,0,3)
		*drop regional_item_index
		
		local region gor_region
		local regioncondminus1 "& gor_region==gor_region[_n-1]"
		local regioncondminus12 "& gor_region==gor_region[_n-12]"
		local regioncondminus13 "& gor_region==gor_region[_n-13]"
		drop _merge

	}
	
	if "`regional'"!="yes" & "`regional'"!="no" {
		di as error "Error: regional must be either yes or no"
		exit
	}

	local startyearminusone = `startyear' - 1
	
	local numberofcoicopcodes= wordcount("`coicopindex'") 
	
	forval i = 1/`numberofcoicopcodes' {
		local thiscoicopindex = word("`coicopindex'",`i')
		*get number of digits after decimal point for each coicop code
		local dppos = strpos("`thiscoicopindex'",".")
		local afterdp = substr("`thiscoicopindex'",`dppos',.)
		local afterdp = subinstr("`afterdp'",".","",.)
		if "`afterdp'" == "" {
			 local ndigit`i' = 2
		}
		else {
			local ndigit`i' = strlen("`afterdp'") + 2
		}
		if `i'==1 {
			local ndigitlist "`ndigit`i''"
		}
		else {
			local ndigitlist "`ndigitlist',`ndigit`i''"
		}
	}
	
	if `numberofcoicopcodes' > 1 {
		local minndigitlist = min(`ndigitlist')
		local maxndigitlist = max(`ndigitlist')	
		capture assert `minndigitlist'==5 if `maxndigitlist'==5 & `startyear'<2018
		if _rc==9 {
			di as error "Do not mix 5 digit codes with less than 5 digit before 2018"
			exit
		}
	}
	
	if `numberofcoicopcodes' ==1  {
		local minndigitlist =`ndigit1'
		local maxndigitlist =`ndigit1'
	}

	***** If year < 2018 calculate indices at 4 digit COICOP level first ******
	***** If year >=  2018 lowest level is COICOP5 ******
	
	*need two sets of 2017 observations - so that in 2018 we know indices for 5 digit COICOP codes. This is because we need to know average across item indices in Dec 2017
	*within FIVE digit not FOUR digit COICOP
	qui expand 2 if year==2017, gen(fivedigit2017)
	qui gen pre2017 = year<=2017
	
	if `maxndigitlist'<5 {
		qui gen lowestlevel = stringcoicop4 if pre2017
		qui replace lowestlevel = stringcoicop5 if (pre2017==0|fivedigit2017==1)
	}
	
	if `maxndigitlist'==5 {
		qui gen lowestlevel = stringcoicop5
	}
	
	qui gen fivedigit=fivedigit2017==1|pre2017==0

	qui gen itemstocombine = 0
	forval i = 1/`numberofcoicopcodes' {
		*some items have missing coicop codes - these all have zero or missing coicop weights except for potatoes in 2005
		qui replace itemstocombine = 1 if strpos("`coicopindex'",stringcoicop`ndigit`i'') > 0 & !inlist(stringcoicop`ndigit`i''," ",".","")
	}
	
	qui egen maxitemstocombine = max(itemstocombine)

	capture assert maxitemstocombine==1
	if _rc==9 {
		di as error "Error: No items in that COICOP category: COICOP indices should be entered as XX.X.X (or XX if two digit). (e.g. 01 or 01.1.1 etc.)"
		exit
	}
	
	qui keep if itemstocombine==1
	qui drop if coicop_weight>.
	
	sort `region' item_id index_date
	*Weights at level of 4 digit coicop are "price updated" to previous december in each january. However, item weights are not. 
	*Update item_weights in line with change in coicop weights - at 4 digit coicop level up to Jan 17, 5 digit thereafter
	assert classsubclassweight<. if month==1 & year>=`startyear' -1  & coicop_weight<. & coicop_weight>0 & !inlist(item_id,"212309","212310","212311") 
	assert prevjancoicopclassweight<. if month==1 & year>=`startyear' -1  & coicop_weight<. & coicop_weight>0 & !inlist(item_id,"212309","212310","212311") & year!=2018

	qui replace coicop_weight = coicop_weight*(classsubclassweight/prevjancoicopclassweight) if month==1 & year<=2017 
	qui replace coicop_weight = coicop_weight*(classsubclassweight/prevfebcoicopclassweight) if month==1 & year>=2018
	
	*coicop weight is for the CPI, item_weight is for the RPI
	qui egen sumweights = sum(coicop_weight*itemstocombine), by(index_date lowestlevel fivedigit2017 `region')
	qui egen newindex = sum(coicop_weight*all_gm_index*itemstocombine), by(index_date lowestlevel fivedigit2017 `region')
	qui replace newindex = newindex/sumweights
	
	*take one observation from each item and then aggregate up to the desired level
	collapse (first) newindex year month (sum) newcoicop_weight = coicop_weight if itemstocombine==1, by(`region' index_date lowestlevel fivedigit)
	
	qui egen sumweights = sum(newcoicop_weight), by(index_date fivedigit `region')
	qui egen aggnewindex = sum(newcoicop_weight*newindex), by(index_date fivedigit `region')
	qui replace aggnewindex = aggnewindex/sumweights
	
	qui keep if inrange(year,`startyearminusone',`endyear')

	bys `region' lowestlevel (fivedigit index_date):  assert month[_n-1]==12 if month==1 & year>=`startyear' & fivedigit==0 `regioncondminus1'

	*divide by previous December value if January for each item
	*Dec 2015 to Jan 2016 change is Jan 2015 to Jan 2016 change divided by Jan 2015 to Dec 2015 change

	qui {
		
		bys `region' lowestlevel (fivedigit index_date): replace aggnewindex = 100*aggnewindex/aggnewindex[_n-1]  if month==1 & year<=2017 & fivedigit==0 `regioncondminus1'
		*We have duplicated 2017 to calculate item indices within 5 digit COICOP codes. Here divide Jan 2017 value by Dec 2016.
		bys `region' lowestlevel (fivedigit index_date): replace aggnewindex = 100*aggnewindex/aggnewindex[_n-13]  if month==1 & year==2017 & fivedigit==1 `regioncondminus13'
		*No need to do this after Jan 2018
	}

	if `maxndigitlist'<5 { 	
		qui drop if fivedigit==1 & year==2017
	}
	
	if `maxndigitlist'==5 { 	
		qui drop if fivedigit==0 & year==2017
	}

	*take one observation from each item (one for each region if regional)
	collapse (first) aggnewindex year month, by(`region' index_date)
	
	if "`regional'"=="yes" {
		
		forval gor = 1/12 {
			preserve
			qui keep if gor_region==`gor'
			su aggnewindex if year == `startyear' - 1 & month==1, meanonly
			local lastjanvalue = r(mean)
			su aggnewindex if year == `startyear' - 1 & month==12, meanonly
			local lastdecvalue = r(mean)
			
			local lastjanchainvalue = `lastjanvalue'
			local lastdecchainvalue = `lastdecvalue'

			***** Aggregate to desired level then chain ******
			
			qui gen chainedindex = aggnewindex 
			qui keep if inrange(year,`startyear',`endyear')

			forval year = `startyear'/`endyear' {
				
				*chain relative to previous january
				qui replace chainedindex = aggnewindex*(`lastdecchainvalue'/100) if month==1 & year==`year'  

				qui su chainedindex if month==1 & year==`year', meanonly
				qui gen janvalue = r(mean)
				qui replace chainedindex  = aggnewindex*janvalue/100 if month>=2 & year==`year' 
				
				qui su chainedindex  if month==1 & year==`year', meanonly
				local lastjanchainvalue = r(mean)
				
				qui su chainedindex  if month==12 & year==`year', meanonly
				local lastdecchainvalue = r(mean)

				drop janvalue
				
			}

			qui su chainedindex if index_date==`basedate', meanonly
			qui replace chainedindex = 100*chainedindex/r(mean)
			
			tempfile region`gor'
			qui save `region`gor''
			restore
		}
		
		qui use `region1', clear
		forval gor = 2/12 {
			qui append using `region`gor''
		}
		
		gen modate = ym(year, month)
		format modate %tm
		sort gor_region year month 
		keep modate chainedindex gor_region year month
		
		if "`graph'"=="yes" {
			
			twoway (line chainedindex modate if gor_region==1)  (line chainedindex modate if gor_region==2) (line chainedindex modate if gor_region==3) ///
			(line chainedindex modate if gor_region==4)  (line chainedindex modate if gor_region==5) (line chainedindex modate if gor_region==6) ///
			(line chainedindex modate if gor_region==7)  (line chainedindex modate if gor_region==8) (line chainedindex modate if gor_region==9) ///
			(line chainedindex modate if gor_region==10)  (line chainedindex modate if gor_region==11) (line chainedindex modate if gor_region==12), ///
			legend(order(1 "London" 2 "SE" 3 "SW" 4 "East Anglia" 5 "East Midlands" 6 "West Midlands" 7 "Yorks & Humber" 8 "NW" 9 "NE" 10 "Wales" 11 "Scotland" 12 "NI")) title("`coicopindex'") xtitle("") ytitle("Index base = `basedate'")
				
		}
		
		*qui reshape wide chainedindex, i(modate) j(gor_region)
	}
	
	else {

		su aggnewindex if year == `startyear' - 1 & month==1, meanonly
		local lastjanvalue = r(mean)
		su aggnewindex if year == `startyear' - 1 & month==12, meanonly
		local lastdecvalue = r(mean)
		
		local lastjanchainvalue = `lastjanvalue'
		local lastdecchainvalue = `lastdecvalue'

		***** Aggregate to desired level then chain ******
		
		qui gen chainedindex = aggnewindex
		qui keep if inrange(year,`startyear',`endyear')

		forval year = `startyear'/`endyear' {
			
			*chain relative to previous january
			qui replace chainedindex = aggnewindex*(`lastdecchainvalue'/100) if month==1 & year==`year'  

			qui su chainedindex if month==1 & year==`year', meanonly
			qui gen janvalue = r(mean)
			qui replace chainedindex  = aggnewindex*janvalue/100 if month>=2 & year==`year' 
			
			qui su chainedindex  if month==1 & year==`year', meanonly
			local lastjanchainvalue = r(mean)
			
			qui su chainedindex  if month==12 & year==`year', meanonly
			local lastdecchainvalue = r(mean)

			drop janvalue
			
		}
		
		qui su chainedindex if index_date==`basedate', meanonly
		qui replace chainedindex = 100*chainedindex/r(mean)
		
		gen modate = ym(year, month)
		format modate %tm
		keep modate chainedindex year month
		
		if "`graph'"=="yes" {

			twoway (line chainedindex modate),  title("`coicopindex'") xtitle("") ytitle("Index base = `basedate'")
			
		}
	}

	save "`savedirectory'", replace

end

chainitems, startyear(2001) endyear(2023) coicopindex("01.1 01.2 2.1 2.2 3.1 3.2 04.4 06.1 07.2 08.2 09.1 09.2 09.3 09.4 09.5 09.6 10.0 11.1 11.2 12.1 12.5") savedirectory("$dataRaw/cpinondurables_exenergy.dta") regional("no") basedate(202112) graph("yes")
