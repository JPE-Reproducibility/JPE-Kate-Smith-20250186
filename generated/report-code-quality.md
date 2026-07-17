## Code Quality

### Stata

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (master.do, line 4)
  → global matlab "C:/Program Files/MATLAB/R2024b/bin/matlab.exe"

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (master.do, line 5)
  → global R      "C:/Program Files/R/R-4.4.3/bin/R.exe"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (synthetic_data_generator.do, line 643)
  → drop if drop_outliers == 1| no_het == 1| no_lagged_income == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (synthetic_data_generator.do, line 688)
  → drop if year <= 2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (synthetic_data_generator.do, line 912)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (synthetic_data_generator.do, line 913)
  → drop if no_heterogeneity_measures == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpimicrodata.do, line 44)
  → drop if year>`endyear'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpimicrodata.do, line 47)
  → drop if year<1999

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 12)
  → keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 38)
  → keep if yearly==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 58)
  → keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 91)
  → keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 123)
  → keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.cpi.do, line 155)
  → keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OCT","NOV","DEC")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 90)
  → drop if year<2013

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 110)
  → drop if year<2013

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 122)
  → drop if _n<3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 124)
  → keep if Category=="Total"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 253)
  → keep if region=="GB average"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.importenergypricecap.do, line 289)
  → drop if capperiodno<9

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.BEISMacroData.do, line 20)
  → keep if n>r(mean)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 47)
  → keep if reltohoh==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 168)
  → keep if reltohoh==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 272)
  → keep if n==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 373)
  → keep if n==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 460)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.LCFS.do, line 525)
  → keep if year == 2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.weights.do, line 35)
  → drop if ladcd==""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.weights.do, line 78)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.weights.do, line 83)
  → drop if age<16

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 28)
  → keep if year>=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 93)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 102)
  → drop if tot_bus>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 207)
  → keep if maxlikely_pp_y == 1 //keep only id-year-months in which one PP transaction is recorded

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 222)
  → drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67) //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 329)
  → drop if yrmn<min_yrmn | yrmn>max_yrmn //remove periods before or after last month in sample

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 334)
  → drop if _f==1 	   //drop all other filled in periods  i.e. keep only single month gaps

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 394)
  → drop if meanlikely_pp>=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 431)
  → keep if maxdirect_debit_yrm == 1 //keep only id-year-months in which one DD transaction is recorded

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 441)
  → drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303  & (amount>=66) & (amount<=67) //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 454)
  → drop if N>3 & N<.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 474)
  → drop if N==3 & n==1 & ratio<=0.2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 480)
  → drop if N==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 515)
  → drop if day_gap>=$thresh & n_idmm!=1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 631)
  → keep if maxdirect_debit_yrm == 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 639)
  → drop if creditdebit == 1 & yrmn>=202210 & yrmn<=202303 & (amount>=66) & (amount<=67)  //drop the refund transactions (these are cash transfers and don't necessarily correspond to energy spending)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5a.appendCSenergy.do, line 673)
  → drop if day_gap>=$thresh & n_idmm!=1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5b.appendCSallspending.do, line 44)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5b.appendCSallspending.do, line 62)
  → drop if tot_bus>0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5b.appendCSallspending.do, line 312)
  → drop if exp_cat == ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 196)
  → keep if year<=2020

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 219)
  → keep if year<=2020

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 228)
  → keep if endyear>=2021

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 288)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 292)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 297)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 307)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 429)
  → drop if ofgem_region=="United Kingdom"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 430)
  → drop if ofgem_region=="Northern Ireland"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.insheetweatherprices.do, line 476)
  → drop if yrmn == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.samples.do, line 15)
  → drop if tot_out_nondurab<=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.samples.do, line 95)
  → drop if age<=18 | age>=100

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.samples.do, line 117)
  → drop if postcode_sector == ""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (7.samples.do, line 119)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 12)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 19)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 58)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 434)
  → drop if yeartax==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 443)
  → drop if inc<1000 | inc>15000

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 454)
  → keep if year==`y'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 492)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 506)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 552)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 553)
  → drop if no_het == 1  & NI ==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (8.analysis.do, line 554)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.model.do, line 5)
  → drop if drop_outliers == 1| no_het == 1| no_lagged_income == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.model.do, line 31)
  → drop if drop_outliers == 1 | no_het == 1 | tt_toinclude2==0 | no_lagged_income == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (9.model.do, line 33)
  → drop if sample==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 13)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 14)
  → drop if no_het == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 15)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 93)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 94)
  → drop if no_het == 1  //effectively drops NI too

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 95)
  → drop if dataset==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 96)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 146)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 147)
  → drop if no_het == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 148)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 167)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 315)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 316)
  → drop if no_het == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 317)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 324)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 331)
  → keep if n==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 364)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 365)
  → drop if no_het == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 366)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 417)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 418)
  → drop if no_het == 1  & NI ==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 419)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 420)
  → drop if NI == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 547)
  → drop if n_nondur == . & n_inc == . &  n_energy == . &  n_energy_PP == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 567)
  → drop if n==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 573)
  → keep if year==2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 574)
  → drop if gor == 12

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 633)
  → drop if n_nondur == . & n_inc == . &  n_energy == .  &  n_energy_PP == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 655)
  → drop if n==.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 708)
  → keep if year==2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.summarystats.do, line 709)
  → drop if gor==12

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 15)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 16)
  → drop if no_het == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 17)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 141)
  → keep if _merge==3|_merge==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 146)
  → keep if _merge==3|_merge==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 224)
  → keep if year >=2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.macrotrends.do, line 248)
  → keep if year>=2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 13)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 14)
  → drop if no_het == 1   //drops NI too

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 15)
  → keep if year<=2020

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 222)
  → keep if year==2019

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 223)
  → drop if gor == 12

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 289)
  → drop if drop_outliers == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 290)
  → drop if no_het == 1   //drops NI too

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 291)
  → drop if year<=2018

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (4.exposure.do, line 310)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (5.priceresponse.do, line 729)
  → drop if inc_eexp_dec == .

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.MPCs.do, line 255)
  → drop if NI == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (6.MPCs.do, line 369)
  → drop if NI == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 111)
  → drop if year==2023 & month>6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 316)
  → keep if coef!=.

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 350)
  → keep if year==2023& month>9

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 361)
  → keep if year==2022& month>9

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 380)
  → keep if year==2022 & (month>3&month<10)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 421)
  → keep if ho==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 431)
  → keep if ho==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 440)
  → keep if ho==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.prepareestimation.do, line 456)
  → keep if year==2022 & (month>3&month<10)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.coefficients.do, line 24)
  → drop if drop==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 36)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 63)
  → keep if year==2023& month>9

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 111)
  → keep if year==2022& month>9

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 228)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 232)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 256)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 260)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.modelfit.do, line 287)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 16)
  → keep if (year==2022 & month>9)|(year==2023 & month<4)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 19)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 58)
  → keep if (year==2021 & month>9)|(year==2022 & month<4)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 79)
  → keep if (year==2022 & month>9)|(year==2023 & month<4)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 84)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 89)
  → drop if inc_t<r(c_1)|inc_t>r(c_2)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 102)
  → keep if keep==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (0.preparesimulation.do, line 105)
  → drop if _m==2

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.observedpolicy.do, line 57)
  → keep if gt!=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (1.observedpolicy.do, line 73)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 37)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 41)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 89)
  → keep if abs(min-W)<1e-6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 108)
  → keep if s==39

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 124)
  → keep if s==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 190)
  → keep if _n<6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 221)
  → keep if s==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (2.counterfactualpolicy.do, line 229)
  → keep if optimalSR==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.observedpolicyCI.do, line 80)
  → keep if _n==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (3.observedpolicyCI.do, line 117)
  → keep if _n==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A1.welfareweights.do, line 42)
  → drop if loss>`r(c_1)'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A1.welfareweights.do, line 44)
  → drop if EV<0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A2.pricesensitivity.do, line 42)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A2.pricesensitivity.do, line 46)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A2.pricesensitivity.do, line 65)
  → keep if s==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A2.pricesensitivity.do, line 127)
  → keep if _n<6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A3.incomeoffset.do, line 9)
  → keep if s==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A3.incomeoffset.do, line 37)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A3.incomeoffset.do, line 41)
  → keep if _m==3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A3.incomeoffset.do, line 114)
  → keep if _n<5

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A3.incomeoffset.do, line 119)
  → drop if p==1|p==3|p==5

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 54)
  → keep if _n<6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 125)
  → keep if _n<6

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 155)
  → drop if loss>`r(c_1)'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 157)
  → drop if EV<0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 178)
  → keep if s==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (A5.socialpreferences.do, line 246)
  → keep if _n<6

