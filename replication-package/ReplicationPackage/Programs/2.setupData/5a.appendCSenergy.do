
set more off
clear all
pause on 

*********
** Create year-week indicator


use "${dataCS}//Transaction1", clear

bysort transdate: keep if _n==1

gen year = year(transdate)
gen month = month(transdate)

keep year month transdate

egen tt = group(transdate)
egen t = group(year transdate)
gen twy = t
foreach y in 2018 2019 2020 2021 2022 2023{
	su t if year == `y'-1
	replace twy = t - r(max) if year ==`y'
}
drop t

keep if year>=2018

gen wk = 1
forval w = 1/52 {
	replace wk = `w' if twy> (`w'-1)*7 & twy <= `w'*7 
}
replace wk = 52 if twy == 365 | twy == 366

ren twy t
gen yrwk = year*100 + wk
gen yrmn = year*100 + month



sa "$dataProcess/dates", replace

*********



**********
** Combine and clean data on energy spending


cap prog drop create_shr_likelypp
program def create_shr_likelypp 	
	cap drop shr_likelypp Nlikely_pp
	isid id energy_supplier year $time_vars transdate transref 
	sort id energy_supplier year $time_vars transdate transref 
	by id energy_supplier year $time_vars: egen Nlikely_pp = total(likely_pp)
	gen shr_likelypp = Nlikely_pp/N
end



foreach data in CS  {

	if "`data'" == "CS" {
		global max_tranche = 130
		global data_dir "${dataCS}"
	}

	**Loop over data tranches
	forval u = 1/$max_tranche {


		disp as error "Running tranche `u' of $max_tranche"

		
		foreach agg in yrmn    {

			if "`agg'" == "yrwk" {
				global time_vars "wk yrwk"
			}
			if "`agg'" == "yrmn" {
				global time_vars "month yrmn"
			}
			

			
			**Step 1: isolate energy spending. 
			use "${data_dir}//Transaction`u'", clear


			merge m:1 transdate using  "$dataProcess/dates"
			keep if _m==3
			drop _m

			**drop business accounts
			isid userref accref transdate transref 
			sort userref accref transdate transref 
			by userref accref : gen f_useracc = _n
			by userref accref : egen tot_bus = total(amount) if defaulttag>=170000 & defaulttag<=170400
			replace tot_bus = 0 if tot_bus==.
			drop if tot_bus>0


			**find heating oil (for NI - exclude car fuel oil)
			merge m:1 userref using "${dataCS}//user", keepusing(gor)
			drop if _m==2
			drop _m
			gen heating_oil = index(lower(transdesc), "oil")>0 & (defaulttag == 999999)  & gor==12
			

			
			**keep gas and electricity tag
			keep if defaulttag == 110200  | heating_oil==1
			
			**drop duplicate rows 
			isid userref accref transdate amount transdescrip accountbalance bankcode transref , missok 
			sort userref accref transdate amount transdescrip accountbalance bankcode transref 
			duplicates tag userref accref transdate amount transdescrip accountbalance, gen(duplicate)
			duplicates drop userref accref transdate amount transdescrip accountbalance, force
			
			

			**opus is a business energy supplier - only v small number of transactions left
			drop if index(lower( transdescrip),"opus")>0 & index(lower( transdescrip),"octopus")==0

			**Identifier energy supplier
			decode merchant, gen(merchant_s)
			tab merchant
			gen energy_supplier = "British Gas" 	if merchant_s == "British Gas"
			replace energy_supplier = "Boost Energy" 	if index(lower(transdescrip),"boost")
			replace energy_supplier = "Bulb Energy" 	if merchant_s == "Bulb Energy"
			replace energy_supplier = "E.ON" 			if merchant_s == "E.ON"
			replace energy_supplier = "EDF Energy" 		if merchant_s == "EDF Energy"
			replace energy_supplier = "Octopus Energy" 	if merchant_s == "Octopus Energy"
			replace energy_supplier = "Ovo Energy" 		if merchant_s == "Ovo Energy"
			replace energy_supplier = "Scottish Power" 	if merchant_s == "Scottish Power"
			replace energy_supplier = "Shell" 			if merchant_s == "Shell"
			replace energy_supplier = "Southern Electric" 	if merchant_s == "Southern Electric"
			replace energy_supplier = "Utilita Energy" 		if merchant_s == "Utilita Energy"
			replace energy_supplier = "npower" 				if merchant_s == "npower"

			replace energy_supplier = "Power NI" 			if merchant_s == "Power NI" & gor==12
			replace energy_supplier = "Electric Ireland" 	if merchant_s == "No Merchant" & gor==12 & (index(lower(transdescrip), "electric ire"))
			replace energy_supplier = "Budget Energy" 		if merchant_s == "No Merchant" & gor==12 & (index(lower(transdescrip), "budget")) & (index(lower(transdescrip), "energy"))
			replace energy_supplier = "Firmus" 				if merchant_s == "No Merchant" & gor==12 & (index(lower(transdescrip), "firmus")) 
			replace energy_supplier = "Other" 				if energy_supplier == "" 
			
			#delimit ;
			replace energy_supplier = "Heating oil" if heating_oil==1 | (merchant_s == "Boilerjuice"|
							(energy_supplier=="Other" & (index(lower(transdescrip), "certas")))|
							(energy_supplier=="Other" & (index(lower(transdescrip), "highland fuels")))|
							(energy_supplier=="Other" & (index(lower(transdescrip), "boilerjuice"))));
			#delimit cr	


			encode energy_supplier, gen(temp2)
			drop energy_supplier
			ren temp2 energy_supplier
			
			**some payments are for boiler insurance etc. or for arenas named after energy companies
			drop if (index(lower(transdescrip), "home services"))>0
			drop if (index(lower(transdescrip), "arena"))>0
			**these look like purchases made in scottish power hq - most are small
			drop if (index(lower(transdescrip), "scottish power hq"))>0

			replace bankcode = 20 if (index(lower(transdescrip), "ddr") | index(lower(transdescrip), "direct debit") | index(lower(transdescrip), "standing order")) & bankcode == 999999
			replace bankcode = 9  if (index(lower(transdescrip), "bcc") | index(lower(transdescrip), "bdc") | index(lower(transdescrip), "card pay")) & bankcode == 999999
			replace bankcode = 5  if (index(lower(transdescrip), "bgc") | index(lower(transdescrip), "giro")) & bankcode == 999999

			**most of the remaining transactions with missing bankcodes look like card payments
			gen direct_debit = bankcode == 20

			gen round_1 = round(amount) == amount
			gen round_5_10 = round(amount, 5) == amount | round(amount, 10) == amount


			**look by periodicity and month
			egen id = group(userref accref)
		
			isid id merchant year $time_vars amount transref 
			sort id merchant year $time_vars amount transref

		
			tempfile energy_step1
			save `energy_step1'


			
			


			
			*****
			**Step 1: pay for at least one type of energy on pre-pay
			u `energy_step1', clear

			gen likely_pp_paymentmethod = (direct_debit == 0 & round_5_10 == 1 & amount<=100 & creditdebit==-1)
			gen likely_pp = likely_pp_paymentmethod
			
			isid id year $time_vars transdate transref 
			sort id year $time_vars transdate transref 
			by id year $time_vars: egen maxlikely_pp_yrm = max(likely_pp)
			by id year: egen maxlikely_pp_y = max(likely_pp)
			tab maxlikely_pp_yrm likely_pp, row //around 90% of transactions in a year-month that have one PP transaction are also PP
			
			keep if maxlikely_pp_y == 1 //keep only id-year-months in which one PP transaction is recorded
			
			isid id energy_supplier year $time_vars transdate transref
			sort id energy_supplier year $time_vars transdate transref

			gen amount_updated = amount 
			replace amount_updated = . if creditdebit == 1
			gen amount_energy_credit = amount if creditdebit == 1

			**did they receive a bills rebate
			gen EBSS_refund = creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67)
			bysort id year month: egen temp = max(EBSS_refund)
			replace EBSS_refund = temp
			drop temp
			by id: egen EBSS_everrefund = max(EBSS_refund)
			drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67) //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)

			
			**N is number of debit payments made each month 
			isid id energy_supplier year $time_vars creditdebit transdate transref 
			sort id energy_supplier year $time_vars creditdebit transdate transref 
			by id energy_supplier year $time_vars creditdebit: gen Ntemp = _N
			replace Ntemp = . if creditdebit ==1
			egen N = min(Ntemp), by(id energy_supplier year $time_vars)
			
			
			********************************
			**use periodicity in payments to further eliminate direct debits
			gen day = day(transdate)
			gen dayofweek = day(transdate)
			gen weekend = inlist(dayofweek,0,6)
			
			gen numdaysinmonth = day(dofm(1 + mofd(mdy(month, day, year))) - 1)
			gen numdaysinlastmonth = day(dofm(1 + mofd(mdy(month-1, day, year))) - 1)
			gen daylastmonth = transdate-numdaysinlastmonth 
			gen daynextmonth = transdate+numdaysinmonth 
			format daylastmonth %d 
			format daynextmonth %d 
			gen dayofweeklastmonth = dow(daylastmonth)
			gen dayofweeknextmonth = dow(daynextmonth)
			
			**if one payment per month and same date each month - direct debit
			isid id energy_supplier creditdebit transdate transref
			bys id energy_supplier creditdebit (transdate transref): gen samedatelastmonth = day == day[_n-1] if mofd(transdate) == mofd(transdate[_n-1])+1 & N==1 & N[_n-1]==1 & weekend==0 & weekend[_n-1]==0 
			bys id energy_supplier creditdebit (transdate transref): replace samedatelastmonth = day == day[_n-1] - 1 if mofd(transdate) == mofd(transdate[_n-1])+1 & N==1 & N[_n-1]==1 & dayofweeklastmonth==0 & (samedatelastmonth ==0|samedatelastmonth ==.) 
			bys id energy_supplier creditdebit (transdate transref): replace samedatelastmonth = day == day[_n-1] - 2 if mofd(transdate) == mofd(transdate[_n-1])+1 & N==1 & N[_n-1]==1 & dayofweeklastmonth==6 & (samedatelastmonth ==0|samedatelastmonth ==.) 
			
			**do some for next month has the same 
			bys id energy_supplier creditdebit (transdate transref): gen samedatenextmonth = day == day[_n+1] if mofd(transdate) == mofd(transdate[_n+1])-1 & N==1 & N[_n+1]==1 & weekend==0 & weekend[_n+1]==0 
			bys id energy_supplier creditdebit (transdate transref): replace samedatenextmonth = day == day[_n+1] - 1 if mofd(transdate) == mofd(transdate[_n+1])-1 & N==1 & N[_n-1]==1 & dayofweeknextmonth==0 & (samedatenextmonth ==0|samedatenextmonth ==.)
			bys id energy_supplier creditdebit (transdate transref): replace samedatenextmonth = day == day[_n+1] - 2 if mofd(transdate) == mofd(transdate[_n+1])-1 & N==1 & N[_n-1]==1 & dayofweeknextmonth==6 & (samedatenextmonth ==0|samedatenextmonth ==.)
			
			isid id energy_supplier transdate transref
			gsort id energy_supplier -transdate transref
			bys id energy_supplier: replace samedatenextmonth = samedatenextmonth[_n+1]
			gsort id energy_supplier transdate transref
			
			gen regularpayments = max(samedatenextmonth,samedatelastmonth)
			isid id energy_supplier creditdebit transdate transref
			bys  id energy_supplier creditdebit (transdate transref): replace regularpayments = 1 if samedatelastmonth[_n+1]==1 & _n==1
			replace regularpayments = . if creditdebit==1
		
			bys id energy_supplier creditdebit (transdate transref): egen share_regularpayments = sum(regularpayments)
			bys id energy_supplier creditdebit (transdate transref): replace share_regularpayments = share_regularpayments/_N
			
			
			**replace likely_pp = 0 if within a spell most payments are regular 
			bys id energy_supplier creditdebit (transdate transref): replace likely_pp = 0 if share_regularpayments>=0.5 & _N>=3
			drop day dayofweek weekend numdaysinmonth numdaysinlastmonth daylastmonth daynextmonth dayofweeklastmonth dayofweeknextmonth samedatelastmonth samedatenextmonth
			
			**don't include credits in definition of likely_pp (when calculating share likely_PP)
			replace likely_pp = . if creditdebit==1
			
			**replace likely_pp = 1 if majority of other transactions in each year month are PP (could be paying off arrears)
			create_shr_likelypp
			replace likely_pp = 1 if shr_likelypp>=0.5	 & shr_likelypp<1
			replace likely_pp = . if creditdebit==1
			create_shr_likelypp

			isid id energy_supplier year $time_vars transdate transref
			sort id energy_supplier year $time_vars transdate transref

			**replace likely_pp = 0 if majority of other payments in each year month are not PP (probably just randomly a round number)
			replace likely_pp = 0 if shr_likelypp<0.5
			replace likely_pp = . if creditdebit==1
			create_shr_likelypp
			gen ntrans = 1
			
		
			
			
			collapse (sum) amount_updated amount_energy_credit ntrans (mean) likely_pp EBSS_refund EBSS_everrefund, by(userref accref id energy_supplier year $time_vars)

			sort userref accref id year $time_vars energy_supplier 

			**check multiple accounts
			egen tag = tag(userref accref id year $time_vars )
			bysort userref year $time_vars: egen tot_accounts = total(tag)
			tab tot_accounts
			bysort userref: egen max_tot_accounts = max(tot_accounts)

			sort userref year $time_vars energy_supplier  accref

			collapse (sum) amount_updated amount_energy_credit ntrans (mean) likely_pp EBSS_refund EBSS_everrefund, by(userref energy_supplier year $time_vars)
			
			**fillin in the period over which the rebates were available to get any zeros
			egen id = group(userref energy_supplier)
			bysort id: egen min_yrmn = min(yrmn)
			bysort id: egen max_yrmn = max(yrmn)
		
			fillin id yrmn
			gen filled_in = _f
			foreach v in min_yrmn  max_yrmn userref energy_supplier EBSS_everrefund {
				bysort id: egen temp = max(`v')
				replace `v' = temp
				drop temp
			}
			foreach v in year month{
				bysort yrmn: egen temp = max(`v')
				replace `v' = temp
				drop temp
			}
			drop if yrmn<min_yrmn | yrmn>max_yrmn //remove periods before or after last month in sample
			sort id yrmn
			by id: replace _f = 0 if _f[_n-1]==0 & _f[_n+1]==0 //fillin in single month gaps
			gen filled_in_onlysingles = _f==0 & filled_in == 1
			
			drop if _f==1 	   //drop all other filled in periods  i.e. keep only single month gaps
			drop id min_yrmn  max_yrmn _f
			
			replace EBSS_refund = 0 if EBSS_refund == .
			replace amount_updated = 0 if amount_updated == .
			replace amount_energy_credit = 0 if amount_energy_credit == .
			replace ntrans = 0 if ntrans == .
			
			**when likely_pp = . - only received a credit that month. Ignore for determination of prepay vs not.
			replace likely_pp = 1 if likely_pp>=0.5 & likely_pp<.
			replace likely_pp = 0 if likely_pp<0.5

			sort userref  year $time_vars amount_updated
			by userref  year $time_vars: gen N=_N
			by userref  year $time_vars: gen n=_n
			by userref: egen mN = mean(N)

			**share of months with multiple suppliers
			egen tag = tag(userref $time_vars)
			gen tag_multiple = tag
			replace tag_multiple = 0 if N==1
			bysort userref: egen tot_yrmn = total(tag) 
			bysort userref: egen tot_multi_yrmn = total(tag_multiple) 
			gen shr_multiple = tot_multi_yrmn/tot_yrmn

			**check for random payments to other suppliers
			bysort userref energy_supplier: gen N_supplier = _N
			bysort userref : gen N_userref = _N
			gen shr_supplier = N_supplier/N_userref

			egen t = group(year $time_vars)
			bysort userref energy_supplier: egen mint = min(t)
			bysort userref energy_supplier: egen maxt = max(t)
			gen new_supplier = t == mint & t!=1

			gen switcher = mN>1 & mN<1.1 & N>=2

			isid userref  energy_supplier year $time_vars 
			sort userref  energy_supplier year $time_vars 
			by userref energy_supplier: gen n_idmm = _n
			by userref energy_supplier: gen N_idmm = _N

			gen string_no = 1
			forval t = 2/60 {
				by userref energy_supplier: replace string_no = string_no[_n-1] 		if n_idmm==`t' & (t - t[_n-1] <= 2)
				by userref energy_supplier: replace string_no = string_no[_n-1] + 1 	if n_idmm==`t' & (t - t[_n-1] > 2)
			}
			
			isid userref  energy_supplier string_no t
			sort userref  energy_supplier string_no t
			by userref energy_supplier string_no: gen string_length = _N
			gen string_6mplus = string_length>=6

			**drop if less than half the months within a spell are majority likely prepay - these are most likely direct debit
			**do not include filled in cells as these just copy likely_pp status of what is in other cells
			egen meanlikely_pp_temp = mean(likely_pp) if filled_in==0, by(userref energy_supplier string_no)
			
			**fill in info for entire spell (including filled in terms)
			egen meanlikely_pp = min(meanlikely_pp_temp), by(userref energy_supplier string_no)
			drop if meanlikely_pp<0.5
			drop if meanlikely_pp>=.
			
			keep userref- EBSS_everrefund string_no string_length string_6mplus filled_in filled_in_onlysingles
			
			gen mode = "PP"

			
			tempfile energy_step1_PP
			save `energy_step1_PP'


			*****
			
			 
			 

			*****
			**Step 2: pay for at least one energy type on direct debit
			u `energy_step1', clear
		

			
			**drop prepay people (covered above). note _m==2 are filled in above.
			merge m:1 userref $time_vars energy_supplier using `energy_step1_PP', keepusing(likely_pp)
			keep if _m==1
			drop _m
			drop likely_pp
			

			isid id year $time_vars transref 
			sort id year $time_vars transref
			by id year $time_vars: egen maxdirect_debit_yrm = max(direct_debit)
			by id year: egen maxdirect_debit_y = max(direct_debit)
			tab maxdirect_debit_yrm direct_debit, row //around 94% of transactions in a year-month that have one DD transaction are also DD


			
			keep if maxdirect_debit_yrm == 1 //keep only id-year-months in which one DD transaction is recorded
			
						
			**did they receive a bills rebate
			gen EBSS_refund = creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67)
			by id year month: egen temp = max(EBSS_refund)
			replace EBSS_refund = temp
			drop temp
			by id: egen EBSS_everrefund = max(EBSS_refund)
			
			drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303  & (amount>=66) & (amount<=67) //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)
			sort id energy_supplier $time_vars transdate

			gen amount_updated = amount 
			replace amount_updated = . if creditdebit == 1
			gen amount_energy_credit = amount if creditdebit == 1
			
		
	
			isid id energy_supplier year creditdebit $time_vars transdate transref
			sort id energy_supplier year creditdebit $time_vars transdate transref
			by id energy_supplier year creditdebit $time_vars: gen N = _N
			replace N = . if creditdebit==1
			drop if N>3 & N<.


		
			**most N==2 look like separate bills paid to the same supplier
			isid id energy_supplier year creditdebit $time_vars amount_updated transref, missok 
			sort id energy_supplier year creditdebit $time_vars amount_updated transref
			by id energy_supplier year creditdebit $time_vars: gen n = _n
			replace n = . if creditdebit==1
			gen smallest = amount_updated*(N==3 & n==1)
			gen biggest = amount_updated*(N==3 & n==3)
			by id energy_supplier year creditdebit $time_vars: egen temp = max(smallest)
			replace smallest = temp	
			drop temp
			by id energy_supplier year creditdebit $time_vars: egen temp = max(biggest)
			replace biggest = temp	
			drop temp
			gen ratio = smallest/biggest
			
			
			drop if N==3 & n==1 & ratio<=0.2
			drop N n
			isid id energy_supplier year creditdebit $time_vars transdate transref
			sort id energy_supplier year creditdebit $time_vars transdate transref
			by id energy_supplier year creditdebit $time_vars: gen N = _N
			replace N = . if creditdebit==1
			drop if N==3
			drop N 
			

			
			isid id year $time_vars creditdebit amount_updated transref, missok 
			sort id year $time_vars creditdebit amount_updated transref
			by id year $time_vars creditdebit: gen N=_N
			by id year $time_vars creditdebit: gen n=_n
			replace N=. if creditdebit==1
			replace n=. if creditdebit==1
			
			by id: egen mN = mean(N)
			
			gen mode = "DD: dual" if N==1  |  mN<1.2
			replace mode = "DD: single (smallest payment)" if (N==2 & n==1 & mN>=1.2)  
			replace mode = "DD: single (largest payment)" if (N==2 & n==2 & mN>=1.2) 
			
			replace mode = "DD: unknown mode" if N>2 & N<. & mode==""
			replace mode = "DD: unknown mode" if N>=. & mode==""
			
			**drop observations that are more than a year to the previous one
			egen t_yrm = group(year $time_vars)
			
			 

			count
			global max_gap = 1000
			global thresh = 365
			while $max_gap >= $thresh {
				sort id  mode transdate transref
				by id  mode: gen n_idmm = _n
				by id  mode: gen day_gap = tt - tt[_n-1]
				su day_gap if n_idmm!=1
				global max_gap = r(max) 
				drop if day_gap>=$thresh & n_idmm!=1
				drop n_idmm  day_gap

			}

			isid id  mode transdate transref
			sort id  mode transdate transref
			by id  mode: gen day_gap = tt - tt[_n-1]
			by id mode: gen n_idmm = _n
			by id mode: gen N_idmm = _N

			**this is only used to construct the variation in spend variable below. We then redefine the string_no at the monthly level to align with the prepay definition
			gen string_no = 1
			forval t = 2/60 {
				by id mode: replace string_no = string_no[_n-1] if day_gap<=60 & n_idmm==`t'
				by id mode: replace string_no = string_no[_n-1] + 1 if day_gap>60 & n_idmm==`t'
			}
			
			isid id  mode string_no transdate transref
			sort id  mode string_no transdate transref
			by id mode string_no: gen string_length = _N
			gen string_6mplus = string_length>=6

			**variation in spend
			isid id mode string_no transdate transref
			sort id mode string_no transdate transref
			by 	id mode string_no: gen chg = amount_updated - amount_updated[_n-1]
			replace chg = 0 if abs(chg)<0.5
			by 	id mode string_no: gen tot_idmm = _N
			by 	id mode string_no: egen tot_chg_idmm = total(abs(chg)>0.5)
			gen shr_chg = tot_chg_idmm/tot_idmm

			gen variable_slack = shr_chg>=0.25 & shr_chg<. 
			gen variable_semistrict = shr_chg>=0.5 & shr_chg<. 
			gen variable_strict = shr_chg>=0.75 & shr_chg<. 
			
			gen payment_change = abs(chg)>0.5

			
			collapse (sum) amount_updated amount_energy_credit (mean) direct_debit (mean) variable_slack variable_semistrict variable_strict EBSS_refund EBSS_everrefund (max) payment_change, by(userref accref id energy_supplier mode year $time_vars)
			
			isid userref accref id year $time_vars energy_supplier mode 
			sort userref accref id year $time_vars energy_supplier mode 

			**check multiple accounts
			egen tag = tag(userref accref id year $time_vars )
			bysort userref year $time_vars: egen tot_accounts = total(tag)
			tab tot_accounts
			bysort userref: egen max_tot_accounts = max(tot_accounts)

			sort userref year $time_vars energy_supplier  accref

			collapse (sum) amount_updated amount_energy_credit (max) direct_debit variable_slack variable_semistrict variable_strict payment_change EBSS_refund EBSS_everrefund,  by(userref energy_supplier mode year $time_vars)

			
			**fillin in the period over which the rebates were available to get any zeros
			encode mode, gen(mode_c)
			drop mode
		
		
			replace amount_updated = 0 if amount_updated == .
			replace amount_energy_credit = 0 if amount_energy_credit == .
			replace EBSS_refund = 0 if EBSS_refund == .
			decode mode_c, gen(mode)
			drop mode_c

			egen t = group(year $time_vars)
			isid userref mode energy_supplier year $time_vars
			sort userref mode energy_supplier year $time_vars
			by userref mode energy_supplier: gen n_idmm = _n
			by userref mode energy_supplier: gen N_idmm = _N

			gen string_no = 1
			forval t = 2/60 {
				by userref mode energy_supplier: replace string_no = string_no[_n-1] 		if n_idmm==`t' & (t - t[_n-1] <= 2)
				by userref mode energy_supplier: replace string_no = string_no[_n-1] + 1 	if n_idmm==`t' & (t - t[_n-1] > 2)
			}
			
			isid userref mode energy_supplier string_no t
			sort userref mode energy_supplier string_no t
			by userref mode energy_supplier string_no: gen string_length = _N
			gen string_6mplus = string_length>=6
			
			foreach v in slack semistrict strict {
				by userref mode energy_supplier string_no: egen mvariable_`v' = mean(variable_`v')
				replace variable_`v' = 0 if mvariable_`v'<=0.5
				replace variable_`v' = 1 if mvariable_`v'>0.5
				drop  mvariable_`v'
			}


			keep userref- EBSS_everrefund string_no string_length string_6mplus mode 
			
			tempfile energy_step1_DD
			save `energy_step1_DD'


			*****
			**Step 3: pay for at least one energy type by card payment
			
			u `energy_step1', clear
			

			**drop prepay people (covered above)
			merge m:1 userref $time_vars energy_supplier using `energy_step1_PP', keepusing(likely_pp)
			keep if _m==1
			drop _m
			drop likely_pp

			**drop direct debit people (covered above)
			isid id year $time_vars transref
			sort id year $time_vars transref
			by id year $time_vars: egen maxdirect_debit_yrm = max(direct_debit)
			by id year: egen maxdirect_debit_y = max(direct_debit)
			tab maxdirect_debit_yrm direct_debit, row //around 94% of transactions in a year-month that have one DD transaction are also DD

			keep if maxdirect_debit_yrm == 0

			**did they receive a bills rebate
			gen EBSS_refund = creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67)
			by id year month: egen temp = max(EBSS_refund)
			replace EBSS_refund = temp
			drop temp
			by id: egen EBSS_everrefund = max(EBSS_refund)
			drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67)  //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)

			isid id energy_supplier $time_vars transdate transref 
			sort id energy_supplier $time_vars transdate transref 

			gen amount_updated = amount 
			replace amount_updated = . if creditdebit == 1
			gen amount_energy_credit = amount if creditdebit == 1	

			isid id year $time_vars creditdebit amount_updated transref, missok 
			sort id year $time_vars creditdebit amount_updated
			by id year $time_vars creditdebit: gen N=_N
			by id year $time_vars creditdebit: gen n=_n
			
			replace N=. if creditdebit==1
			replace n=. if creditdebit==1
			*drop if N>=3

			by id: egen mN = mean(N)
			

			**drop observations that are more than a year to the previous one
			egen t_yrm = group(year $time_vars)

			count
			global max_gap = 1000
			global thresh = 365
			isid id  energy_supplier transdate transref 
			while $max_gap >= $thresh {
				sort id  energy_supplier transdate transref 
				by id energy_supplier: gen n_idmm = _n
				by id  energy_supplier: gen day_gap = tt - tt[_n-1]
				su day_gap if n_idmm!=1
				global max_gap = r(max) 
				drop if day_gap>=$thresh & n_idmm!=1
				drop n_idmm  day_gap

			}

			isid id energy_supplier transdate transref 
			sort id energy_supplier transdate transref
			by id energy_supplier: gen day_gap = tt - tt[_n-1]
			by id energy_supplier: gen n_idmm = _n
			by id energy_supplier: gen N_idmm = _N

			sort id energy_supplier transdate transref
			gen string_no = 1
			forval t = 2/60 {
				by id energy_supplier: replace string_no = string_no[_n-1] if day_gap<=150 & n_idmm==`t'
				by id energy_supplier: replace string_no = string_no[_n-1] + 1 if day_gap>150 & n_idmm==`t'
			}
			
			isid id energy_supplier string_no transdate transref
			sort id energy_supplier string_no transdate transref
			by id energy_supplier string_no: gen string_length = _N
			gen string_6mplus = string_length>=6


			by id energy_supplier string_no: egen mday_gap = mean(day_gap)
			by id energy_supplier string_no: egen energy_supplier_day_gap = mode(day_gap), minmode
			gen freq_monthly = energy_supplier_day_gap>=25 & energy_supplier_day_gap<=35
			gen freq_quarterly = energy_supplier_day_gap>=85 & energy_supplier_day_gap<=100


			**variation in spend
			isid id energy_supplier string_no transdate transref			
			sort id energy_supplier string_no transdate transref
			by 	id energy_supplier string_no: gen chg = amount_updated - amount_updated[_n-1]
			replace chg = 0 if abs(chg)<0.5
			by 	id energy_supplier string_no: gen tot_idmm = _N
			by 	id energy_supplier string_no: egen tot_chg_idmm = total(abs(chg)>0.5)
			gen shr_chg = tot_chg_idmm/tot_idmm

			gen payment_change = abs(chg)>0.5

			collapse (sum) amount_updated amount_energy_credit (mean) freq_monthly freq_quarterly EBSS_refund EBSS_everrefund (max) payment_change , by(userref accref id energy_supplier year $time_vars)

			isid userref accref id year $time_vars energy_supplier 
			sort userref accref id year $time_vars energy_supplier 

			**check multiple accounts
			egen tag = tag(userref accref id year $time_vars )
			bysort userref year $time_vars: egen tot_accounts = total(tag)
			tab tot_accounts

			bysort userref: egen max_tot_accounts = max(tot_accounts)

			sort userref year $time_vars energy_supplier accref
			*br if max_tot_accounts>1

			collapse (sum) amount_updated amount_energy_credit (max) freq_monthly freq_quarterly payment_change EBSS_refund EBSS_everrefund,  by(userref energy_supplier year $time_vars)


			**fillin in the period over which the rebates were available to get any zeros
			egen id = group(userref energy_supplier)
			bysort id: egen min_yrmn = min(yrmn)
			bysort id: egen max_yrmn = max(yrmn)


			egen t = group(year $time_vars)
			isid userref energy_supplier year $time_vars
			sort userref energy_supplier year $time_vars
			by userref energy_supplier: gen n_idmm = _n
			by userref energy_supplier: gen N_idmm = _N


			**reduced stringency of breaks because of quarterly payments. 
			gen string_no = 1
			forval t = 2/60 {
				by userref energy_supplier: replace string_no = string_no[_n-1] 		if n_idmm==`t' & (t - t[_n-1] <= 4)
				by userref energy_supplier: replace string_no = string_no[_n-1] + 1 	if n_idmm==`t' & (t - t[_n-1] > 4)
			}
			
			isid userref energy_supplier string_no t
			sort userref energy_supplier string_no t
			by userref energy_supplier string_no: gen string_length = _N
			gen string_6mplus = string_length>=6
			
			gen mode = "Card payment"
			
			keep userref- EBSS_everrefund string_no string_length string_6mplus mode 

			tempfile energy_step1_card
			save `energy_step1_card'
			

			*****

		
			*****
			**Combine all the different payment types and label
			u `energy_step1_PP', clear
			append using `energy_step1_DD'
			append using `energy_step1_card'

			ren amount_updated amount
			replace likely_pp = 0 if likely_pp == .
			replace direct_debit = 0 if direct_debit == .


			label var year 				"Year"
			label var month	 			"Month"
			label var yrmn 				"Year-month"
			label var energy_supplier 	"Energy supplier"
			label var amount 			"Payment amount"
			label var amount_energy_credit "Amount of credits from energy company"
			label var ntrans 			"Num. transactions per month for PP consumers"
			label var likely_pp 		"=1 if pre-payment"
			label var string_no 		"Within consumer-mode string of continuous payments"
			label var string_length 	"Length of string of continuous payments"
			label var string_6mplus 	"=1 if string of continuous payments at least 6 months"
			label var mode 				"Payment mode"
			label var direct_debit		"=1 if direct debit payment"
			label var variable_slack	"=1 if DD and >=25% months in string have a change in payment amount"
			label var variable_semistrict	"=1 if DD and >=50% months in string have a change in payment amount"
			label var variable_strict		"=1 if DD and >=75% months in string have a change in payment amount"
			label var payment_change 	"=1 if change in payment amount for DD or card consumers"
			label var freq_monthly 		"=1 if monthly frequency of payment for card consumers"
			label var freq_quarterly	"=1 if quarterly frequency of payment for card consumers"
			label var EBSS_refund		"=1 if received an EBSS refund in that month"
			label var EBSS_everrefund	"=1 if user ever received an EBSS refund"

			order userref year month yrmn energy_supplier mode amount amount_energy_credit string_no string_length string_6mplus likely_pp ntrans direct_debit payment_change variable_slack variable_semistrict variable_strict EBSS_refund EBSS_everrefund freq_*

			
			if `u'>1 append using "$dataProcess/`data'energy_step1_combine.dta"
			sa "$dataProcess/`data'energy_step1_combine.dta", replace
			
			
		}
		
		

}

		


*********























