
set more off
clear all

**********
** Combine and clean data on other spending

global max_tranche = 130
global data_dir "${dataCS}"
	
local numbatches = 4
local batchsize = int(130/`numbatches')
forval b = 1/`numbatches' {
	local batchsize`b' = `batchsize' 
}
local batchsize`numbatches' = `batchsize`numbatches'' + (130 - `batchsize'*`numbatches')
	
forval batch = 1/`numbatches' {
	
		local u = 0
		forval b2 = 1/`numbatches' {
			if (`b2'>=`batch') {
				continue
			}
			else {
				local u = `u' + `batchsize`b2''
			}
		}
		
		**Loop over data tranches
		forval b = 1/`batchsize`batch'' {
		
			local u = `u'+1
			disp as error "Running tranche `u' in batch `batch' (size `batchsize`batch'')"

			global time_vars "month yrmn"

			**Step 2: all other spending
			use "${dataCS}//Transaction`u'", clear
			
			gen tag_agg = int(defaulttag/10000)

			merge m:1 transdate using  "$dataProcess/dates"
			keep if _m==3
			drop _m

			**drop duplicate rows 
			duplicates tag userref accref transdate amount transdescrip accountbalance, gen(duplicate)
			duplicates drop userref accref transdate amount transdescrip accountbalance, force


			**drop spending outliers	
			centile amount , centile(0.1 99.9)
			drop if amount<r(c_1) | amount>r(c_2)


			**drop business accounts
			sort userref accref transdate
			by userref accref : gen f_useracc = _n
			by userref accref : egen tot_bus = total(amount) if defaulttag>=170000 & defaulttag<=170400
			replace tot_bus = 0 if tot_bus==.
			drop if tot_bus>0

			
			**drop internal transfers
			drop if transflag == 1 

			**merge in account info
			merge m:1 userref accref using "${dataCS}/Account.dta" 
			drop if _m==2
			drop _m

			**construct number of accounts per year month
			egen tag = tag(userref accref year)
			bysort userref year: egen n_accounts = total(tag)


			*****
			**Step 1: Spending and income categories	

			gen supermarket = merchant == 1088 | merchant == 83 | merchant == 696 | merchant == 957 //Tesco;  Asda; M&S; Sainsburys
			gen amazon = (merchant == 53 )
			gen online = (merchant == 369 | merchant == 842 | merchant == 1282)  //etsy; paypal; ebay
			gen bnpl = (merchant == 244 | merchant == 613 )  //buy now pay later: clearpay; klarna


			gen exp_cat = "_out_energy" 		if defaulttag == 110200 
			replace exp_cat = "_out_fuel" 		if exp_cat=="" & (defaulttag == 210200 )
			replace exp_cat = "_out_grocery" 	if exp_cat=="" & ((defaulttag >= 140300 & defaulttag <=140304 ) | supermarket == 1) //Tesco;  Asda; M&S; Sainsburys
			replace exp_cat = "_out_childcare" 	if exp_cat=="" & ((defaulttag >= 130100 & defaulttag <=130303 ))
			replace exp_cat = "_out_personal" 	if exp_cat=="" & (defaulttag >= 100300 & defaulttag <= 100500  ) | defaulttag == 100000
			replace exp_cat = "_out_clothes" 	if exp_cat=="" & (defaulttag >= 100100 & defaulttag <=100203 )
			replace exp_cat = "_out_discret" 	if exp_cat=="" & (defaulttag >= 120000 & defaulttag <=120800 ) | (defaulttag >= 130400 & defaulttag <=130504 )
			replace exp_cat = "_out_diy" 		if exp_cat=="" & ((defaulttag >= 140500 & defaulttag <=140501 )   )
			replace exp_cat = "_out_homeimp" 	if exp_cat=="" & ((defaulttag >= 140000 & defaulttag <=140502 )   )
			replace exp_cat = "_out_mortrent" 	if exp_cat=="" & ((defaulttag >= 110500 & defaulttag <=110502 ))
			replace exp_cat = "_out_phonetv"  	if exp_cat=="" & ((defaulttag >= 110600 & defaulttag <=110700 ) | defaulttag == 110400)
			replace exp_cat = "_out_othbill" 	if exp_cat=="" & (defaulttag == 110000 | (defaulttag >= 110300 & defaulttag <=110800 )  | (defaulttag >= 160000 & defaulttag <=160401 ))
			replace exp_cat = "_out_counciltax" if exp_cat=="" & (defaulttag == 110100 )
			replace exp_cat = "_out_transport" 	if exp_cat=="" & (defaulttag >= 210000 & defaulttag <=210603  )
			replace exp_cat = "_out_loanpay" 	if exp_cat=="" & (defaulttag >= 180400 & defaulttag <=180502  )
			replace exp_cat = "_out_savings" 	if exp_cat=="" & (defaulttag >= 190000 & defaulttag <=190802  )
			replace exp_cat = "_out_transfers" 	if exp_cat=="" & creditdebit == -1 & (defaulttag == 200000  )

			replace exp_cat = "_out_amazon" 	if exp_cat=="" &  amazon == 1
			replace exp_cat = "_out_online" 	if exp_cat=="" &  online == 1  //etsy; paypal; ebay
			replace exp_cat = "_out_bnpl" 		if exp_cat=="" &  bnpl == 1  //buy now pay later: clearpay; klarna

			replace exp_cat = "_out_other_card" 	if exp_cat == "" & creditdebit == -1 & (bankcode == 2 | bankcode == 9 | bankcode == 18 | bankcode == 28) 
			replace exp_cat = "_out_other" 			if exp_cat == "" & creditdebit == -1




			**Income categories:
			** 1 Salary
			** 2 Savings income
			** 3 Benefits
			** 4 Loan funds
			** 5 Pension
			replace exp_cat = "_in_salary" if  exp_cat=="" & (defaulttag >= 150700 & defaulttag <=150804 )
			replace exp_cat = "_in_savinc" if  exp_cat=="" & (defaulttag >= 150200 & defaulttag <=150204 )
			replace exp_cat = "_in_benefit" if  exp_cat=="" & (defaulttag >= 150100 & defaulttag <=150104 )
			replace exp_cat = "_in_loanfnd" if  exp_cat=="" & (defaulttag >= 150403 & defaulttag <=150406 )
			replace exp_cat = "_in_pension" if  exp_cat=="" & (defaulttag >= 150500 & defaulttag <=150503 )
			replace exp_cat = "_in_transfers" if  exp_cat=="" & creditdebit == 1 & (defaulttag == 200000 )

			replace exp_cat = "_in_other" 	if exp_cat == "" & creditdebit == 1


			gen amount_updated = amount 
			replace amount_updated = -amount if creditdebit == 1 & index(lower(exp_cat),"_out_")		//if an `out' category, then make all credits negative
			replace amount_updated = -amount if creditdebit == -1 & index(lower(exp_cat),"_in_")		//if an `in' category, then make all debits negative


			#delimit ;
			gen nondur = exp_cat == "_out_energy" 
				| exp_cat == "_out_grocery"
				| exp_cat == "_out_fuel"
				| exp_cat == "_out_childcare"
				| exp_cat == "_out_discret"
				| exp_cat == "_out_personal"
				| exp_cat == "_out_phonetv"
				| exp_cat == "_out_othbill"
				| exp_cat == "_out_transport"
				| exp_cat == "_out_amazon"
				| exp_cat == "_out_online"
				;
			gen semidur = exp_cat == "_out_clothes" 
				| exp_cat == "_out_diy"
				| exp_cat == "_out_bnpl"
				;
			gen durable = exp_cat == "_out_homeimp" ;
			gen housing = exp_cat == "_out_mortrent" | exp_cat == "_out_counciltax" ;
			#delimit cr


			sort userref $time_vars
			by userref $time_vars: egen tot_in = total(amount_updated) 	if index(lower(exp_cat),"_in_")	
			by userref $time_vars: egen tot_out = total(amount_updated) if index(lower(exp_cat),"_out_")	
			by userref $time_vars: egen tot_in_excltrans = total(amount_updated) 	if index(lower(exp_cat),"_in_") & exp_cat != "_in_transfers" 
			by userref $time_vars: egen tot_out_excltrans = total(amount_updated) 	if index(lower(exp_cat),"_out_") & exp_cat != "_out_transfers" 
			by userref $time_vars: egen tot_out_nondurab = total(amount_updated) 	if   nondur == 1
			by userref $time_vars: egen tot_out_semidurab = total(amount_updated) 	if   semidur == 1
			by userref $time_vars: egen tot_out_durable = total(amount_updated) 	if   durable == 1
			by userref $time_vars: egen tot_out_housing = total(amount_updated) 	if   housing == 1

			*****
			**Step 2: Measures of financial health


			**Financial hardship measures
			gen payday_in  = defaulttag == 150403
			gen payday_out = defaulttag == 180400 
			gen anyloan_in  = (defaulttag >= 150403 & defaulttag <=150406 )
			gen anyloan_out = (defaulttag >= 180400 & defaulttag <=180502  )

			gen onbenefits = exp_cat == "_in_benefit"

			**Measure of liquid assets
			drop tag 	
			gsort userref accref transdate -accountbalance
			by userref accref transdate: gen tag = _n
			gen temp = accountbalance
			replace temp = 0 if acctype == 2 //remove credit card balances
			replace temp = 0 if tag!=1 		//take the largest balance on a given day
			
			sort userref transdate
			by userref transdate: egen A_it = total(temp)
			drop temp
			by userref transdate: gen f = _n

			sort userref f year month transdate
			by userref f year month: gen n_month = _n
			by userref f year month: gen N_month = _N

			by userref f year month: gen F_it = A_it - A_it[_n-1]
			
			gen A_it_start = A_it if n_month == 1 & f == 1
			by userref f year month: egen temp = max(A_it_start)
			replace A_it_start = temp
			drop temp

			gen C = 30 if month == 9 | month == 4 | month == 6 | month == 11
			replace C = 28 if month == 2
			replace C = 29 if month == 2 & year == 2020
			replace C = 31 if C==.
			gen d_it = day(transdate)
			gen W_it = (C - d_it)/C

			by userref f year month: egen temp = total(W_it*F_it)
			gen Adietz_iym = A_it_start + temp
			drop temp

			replace Adietz_iym = . if f != 1
			bysort userref year month: egen temp = max(Adietz_iym)
			replace Adietz_iym = temp
			drop temp

			ren Adietz_iym liquid_assets





			*****





			*****
			**Step 3: other demographics

			gen children = benefit == 15 | ((defaulttag >= 130100 & defaulttag <=130303 ))
			gen disabled = benefit == 18 | benefit == 23 


			** Declare first child amounts
			local cbfc_2019 = 20.70
			local cbfc_2020 = 21.05
			local cbfc_2021 = 21.15
			local cbfc_2022 = 21.80 
			local cbfc_2023 = 24.00 

			** Declare subsequent children amounts
			local cbsc_2019 = 13.70
			local cbsc_2020 = 13.95
			local cbsc_2021 = 14.00
			local cbsc_2022 = 14.45
			local cbsc_2023 = 15.90

			** Create number of children variable
			gen numchld = .
			lab var numchld "Number of children (inferred from CB amounts)"

			** Populate variable
			forvalues y = 2019/2023 {
				
				replace numchld = 1 if inrange(amount,`cbfc_`y''-0.01,`cbfc_`y''+0.01) & benefit == 15
				** Sometimes paid 4-weekly
				replace numchld = 1 if inrange(amount,(4*`cbfc_`y'')-0.01,(4*`cbfc_`y'')+0.01) & benefit == 15
				
				** Code currently looks for up to 6 children
				forvalues c = 1/5 {
					
					local refamount = `cbfc_`y'' + (`c'*`cbsc_`y'')
					replace numchld = (1 + `c') if inrange(amount,`refamount'-0.01,`refamount'+0.01) & benefit == 15
					
					** Sometimes paid 4-weekly
					local refamount = `refamount'*4
					replace numchld = (1 + `c') if inrange(amount,`refamount'-0.01,`refamount'+0.01) & benefit == 15
				}
			}



			**cost of living payments paid in 2022 in July and November https://www.gov.uk/guidance/cost-of-living-payment-2022
			**later payments in 2023 might be harder to identify as closer to a round number (£300)
			gen col = 0 
			replace col = 1 if inrange(amount,325.999,326.001) & inrange(transdate,td(14jul2022),td(31jul2022)) & creditdebit==1
			replace col = 1 if inrange(amount,323.999,324.001) & inrange(transdate,td(8nov2022),td(23nov2022)) & creditdebit==1
			replace col = 1 if inrange(amount,300.999,301.001) & inrange(transdate,td(25apr2023),td(17may2023)) & creditdebit==1
			replace col = 1 if inrange(amount,299.999,300.001) & inrange(transdate,td(31oct2023),td(19nov2023)) & creditdebit==1
			
			egen reccol = max(col), by(userref)
			
			


			**winter fuel payment
			gen wfp = amount if benefit == 29
			replace wfp = 0 if wfp == .

			**cold weather payment
			gen cwp = amount if benefit == 17
			replace cwp = 0 if cwp == .


			collapse (sum) amount_updated (mean) n_accounts payday_in payday_out anyloan_in anyloan_out onbenefits numchld children disabled  tot_in* tot_out* liquid_assets wfp cwp (max) col, by(userref year $time_vars exp_cat)
			
			ren amount_updated amount

			sort userref $time_vars
			foreach v of var   tot_in* tot_out* payday_in payday_out anyloan_in anyloan_out onbenefits numchld children disabled n_accounts col wfp cwp  {
				by userref $time_vars: egen temp = max(`v')
				replace `v' = temp
				drop temp
			}
			replace numchld = 0 if numchld == .

			drop if exp_cat == ""
			reshape wide amount, i(userref year $time_vars) j(exp_cat) s


			order userref year $time_vars n_accounts payday_in payday_out anyloan_in anyloan_out onbenefits disabled children numchld  tot_in* tot_out* liquid_assets amount* col wfp cwp 

			label var year "Year"
			label var month "Month indicator within year"
			label var yrmn "Year-month indicator"

			label var n_accounts 	"Number of accounts for user in year-month"
			label var payday_in 	"=1 if receipt of payday funds in year-month"
			label var payday_out 	"=1 if paying payday loan interest in that year-month"
			label var anyloan_in 	"=1 if receipt of any loan in year-month"
			label var anyloan_out	"=1 if paying loan interest in that year-month"
			label var onbenefits 	"=1 if in receipt of benefits in that year-month"
			label var disabled 		"=1 if receive disability payments"
			label var children 		"=1 if children present"
			label var numchld 		"Number of children, extracted from child benefit"

			label var tot_in 			"Total amount in in that year-month"
			label var tot_in_excltrans 	"Total amount in (excl transfers) in that year-month"
			label var tot_out 			"Total amount out in that year-month"
			label var tot_out_excltrans "Total amount out (excl transfers) in that year-month"
			label var tot_out_nondurab 	"Total amount out (non-durables) in that year-month"
			label var tot_out_semidurab "Total amount out (semi-durables) in that year-month"
			label var tot_out_durable 	"Total amount out (durables) in that year-month"
			label var tot_out_housing 	"Total amount out (housing) in that year-month"
			label var liquid_assets 	"Liquid assets in that year-month (constructed using Dietz method)"

			label var amount_in_benefit 	"Amount flowing in: benefits"
			label var amount_in_loanfnd 	"Amount flowing in: loan funds"
			label var amount_in_pension 	"Amount flowing in: pension"
			label var amount_in_salary 		"Amount flowing in: salary"
			label var amount_in_savinc 		"Amount flowing in: savings income"
			label var amount_in_other 		"Amount flowing in: untagged"
			label var amount_in_transfers	"Amount flowing in: transfers"

			label var amount_out_discret 	"Amount flowing out: discretionary leisure"
			label var amount_out_energy  	"Amount flowing out: energy"
			label var amount_out_grocery  	"Amount flowing out: groceries"
			label var amount_out_childcare  "Amount flowing out: childcare"
			label var amount_out_homeimp  	"Amount flowing out: home improvements"
			label var amount_out_loanpay  	"Amount flowing out: loan payments"
			label var amount_out_othbill  	"Amount flowing out: other bills"
			label var amount_out_savings  	"Amount flowing out: savings"
			label var amount_out_diy  		"Amount flowing out: diy"
			label var amount_out_fuel  		"Amount flowing out: fuel"
			label var amount_out_mortrent  	"Amount flowing out: mortgage and rent"
			label var amount_out_personal  	"Amount flowing out: personal services"
			label var amount_out_phonetv  	"Amount flowing out: phone and TV"
			label var amount_out_clothes  	"Amount flowing out: clothes"
			label var amount_out_counciltax	"Amount flowing out: council tax"
			label var amount_out_other		"Amount flowing out: untagged"
			label var amount_out_other_card	"Amount flowing out: untagged, paid by card"
			label var amount_out_transfers	"Amount flowing out: transfers"
			label var amount_out_transport	"Amount flowing out: transport"
			label var amount_out_amazon		"Amount flowing out: amazon"
			label var amount_out_online		"Amount flowing out: other online retailers"
			label var amount_out_bnpl		"Amount flowing out: buy now pay later"
			
			label var col 					"Cost of living payment (£326 or £324 in-flow)"
			label var wfp 					"= amount of winter fuel payment received"
			label var cwp 					"= amount of cold weather payment received"

			foreach v of var amount* tot_in* tot_out* liquid_assets {
				replace `v' = 0 if `v' == .
			}

			compress

			gen tranche = `u'

			if `b'>1 append using "$dataProcess/CSallspending_step1_combine_batch`batch'.dta
			sa "$dataProcess/CSallspending_step1_combine_batch`batch'.dta", replace


		} /*end of loop within batch*/
} /*end of batch loop*/
	
use "$dataProcess/CSallspending_step1_combine_batch1.dta", clear
forval batch = 2/`numbatches' {
	append using "$dataProcess/CSallspending_step1_combine_batch`batch'.dta"
}
	
sa "$dataProcess/CSallspending_step1_combine.dta", replace
	
forval batch = 1/`numbatches' {
	erase "$dataProcess/CSallspending_step1_combine_batch`batch'.dta"
}

*********






















