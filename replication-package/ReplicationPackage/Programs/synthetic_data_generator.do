** =============================================================================
** SYNTHETIC DATA GENERATOR
** Replication package for:
**   "The Welfare Effects of Price Shocks and Household Relief Packages: 
***   Evidence from an Energy Crisis"
**   Levell, O'Connell & Smith, Journal of Political Economy (2026)
**
** PURPOSE:
**   Creates synthetic versions of the restricted ClearScore (ExactOne) and
**   LCFS processed datasets. The synthetic data has the same variable
**   structure and format as the real processed files, allowing all analysis
**   programs from Stage 3 onward to run and produce output. Numeric results
**   will not match the paper.
**
** INPUTS (public data, already in dataProcess):
**   - cpi_stata.dta              (ONS CPI series)
**   - unitcosts_gas_elec_yrmn.dta (Ofgem price cap data)
**   - lcfsdata_incAHC.dta        (derived LCFS look-up; included as-is)
**
** OUTPUTS (synthetic approximations of restricted files):
**   - CSenergyallspending_step5.dta
**   - CSenergyallspending_step2b_weights.dta
**   - CSenergy_step1_combine.dta
**   - heterogeneity_measures.dta
**   - lcfsdata.dta
**   - preestimationdata.dta
**
** RUN TIME: approximately 5-10 minutes on a standard workstation.
** =============================================================================

set seed 20250617
set sortseed 20250617

** ---------------------------------------------------------------------------
** PARAMETERS
** ---------------------------------------------------------------------------
local N_users = 5000   // synthetic users (real: ~244,000)
local pp_shr  = 0.25   // prepayment meter share (paper: 24.8%)
local vdd_shr = 0.065  // variable direct debit share (paper: 6.3%)
** smoothed DD = remaining ~68.5%

** Ofgem regions (14 GB regions used in unitcosts_gas_elec_yrmn.dta)
local ofgem_regions `" "East England" "East Midlands" "London" "North Wales / Cheshire" "West Midlands" "North East England" "North Scotland" "North West England" "South East England" "South Scotland" "South Wales" "South West England" "Southern England" "Yorkshire" "'


** =============================================================================
** PART 1: USER-LEVEL CHARACTERISTICS
** =============================================================================

clear
set obs `N_users'

gen userref      = _n
gen userref_orig = _n
gen dataset      = 1

** Payment type / sample (1=PP, 2=variable DD, 3=smoothed DD)
gen u_pay = runiform()
gen sample = 1 if u_pay < `pp_shr'
replace sample = 2 if u_pay >= `pp_shr' & u_pay < `pp_shr' + `vdd_shr'
replace sample = 3 if u_pay >= `pp_shr' + `vdd_shr'
drop u_pay
label define sample 1 "Prepayment" 2 "Variable direct debit" ///
    3 "Smoothed direct debit and other payment types", replace
label values sample sample

** Sample indicators
gen sample_PP                 = (sample == 1)
gen sample_variable_slack     = (sample == 2)
gen sample_variable_semistrict = (sample == 2)
gen sample_variable_strict    = (sample == 2)

** EBSS cash recipient flag (user-level):
** PP users receive EBSS as vouchers/meter top-ups — shows as energy spending (ebss_cash=1).
** ~65% of DD users received it as a cash refund to their bank account ("cash" subsample).
** ~35% had EBSS credited directly to their electricity bill ("credit" subsample, ebss_cash=0).
gen ebss_cash = 1 if sample == 1           // PP: EBSS appears as meter spending
replace ebss_cash = (runiform() < 0.65) if sample >= 2  // DD: ~65% cash, ~35% credit

** Government Office Region — approximate population-weighted shares
** Shares from ONS 2021 Census GB population by region.
gen u_gor = runiform()
gen gor = .
replace gor =  1 if u_gor < 0.044                          // North East      4.4%
replace gor =  2 if u_gor >= 0.044  & u_gor < 0.129        // North West      8.5%
replace gor =  3 if u_gor >= 0.129  & u_gor < 0.205        // Yorkshire       7.6%
replace gor =  4 if u_gor >= 0.205  & u_gor < 0.277        // East Midlands   7.2%
replace gor =  5 if u_gor >= 0.277  & u_gor < 0.363        // West Midlands   8.6%
replace gor =  6 if u_gor >= 0.363  & u_gor < 0.461        // East            9.8%
replace gor =  7 if u_gor >= 0.461  & u_gor < 0.617        // London         15.6%
replace gor =  8 if u_gor >= 0.617  & u_gor < 0.762        // South East     14.5%
replace gor =  9 if u_gor >= 0.762  & u_gor < 0.850        // South West      8.8%
replace gor = 10 if u_gor >= 0.850  & u_gor < 0.900        // Wales           5.0%
replace gor = 11 if u_gor >= 0.900                          // Scotland       10.0%
drop u_gor
label define gor 1 "North East" 2 "North West" 3 "Yorkshire" ///
    4 "East Midlands" 5 "West Midlands" 6 "East" 7 "London" ///
    8 "South East" 9 "South West" 10 "Wales" 11 "Scotland" ///
    12 "Northern Ireland", replace
label values gor gor

** Assign Ofgem region (14-region classification, mapped from gor).
gen u_subreg = runiform()
gen ofgem_region = ""
replace ofgem_region = "North East England"      if gor == 1
replace ofgem_region = "North West England"      if gor == 2
replace ofgem_region = "Yorkshire"               if gor == 3
replace ofgem_region = "East Midlands"           if gor == 4
replace ofgem_region = "West Midlands"           if gor == 5
replace ofgem_region = "East England"            if gor == 6
replace ofgem_region = "London"                  if gor == 7
** South East (14.5%): ~85% South East England, ~15% Southern England
replace ofgem_region = "South East England"      if gor == 8 & u_subreg < 0.85
replace ofgem_region = "Southern England"        if gor == 8 & u_subreg >= 0.85
replace ofgem_region = "South West England"      if gor == 9
** Wales (5.0%): ~50% North Wales / Cheshire, ~50% South Wales
replace ofgem_region = "North Wales / Cheshire"  if gor == 10 & u_subreg < 0.50
replace ofgem_region = "South Wales"             if gor == 10 & u_subreg >= 0.50
** Scotland (10.0%): ~40% North Scotland, ~60% South Scotland
replace ofgem_region = "North Scotland"          if gor == 11 & u_subreg < 0.40
replace ofgem_region = "South Scotland"          if gor == 11 & u_subreg >= 0.40
drop u_subreg

** Demographics
gen age_2021 = 20 + floor(runiform() * 60)  // ages 20-79
gen age_5band = 5 * floor(age_2021 / 5)
replace age_5band = 76 if age_5band >= 76

** Prepay households skew younger and lower income (consistent with paper)
replace age_2021 = age_2021 - 5 if sample == 1

gen sex = (runiform() < 0.5)
label define sex 0 "Male" 1 "Female", replace
label values sex sex

gen salaryrange = ceil(runiform() * 8)
label define salaryrange 1 "<£15k" 2 "£15-20k" 3 "£20-25k" 4 "£25-30k" ///
    5 "£30-40k" 6 "£40-50k" 7 "£50-70k" 8 ">£70k", replace
label values salaryrange salaryrange

** Geographic identifiers (synthetic but valid format)
gen postcode_sector   = "SW" + string(mod(_n, 9) + 1) + " " + string(mod(_n, 9) + 1) + "A"
gen postcode_district = "SW" + string(mod(_n, 9) + 1)
gen twodigitpostcode  = "SW"
gen lsoa      = "E010" + string(10000 + mod(_n, 5000))
gen mode_la   = "Synthetic LA"
gen laname    = gor * 100 + floor(runiform() * 10)

gen NI       = 0
gen balanced = 1   // all synthetic users present throughout

** User-level permanent log-income and log-energy heterogeneity.
** Energy spending is weakly positively correlated with income: β≈0.32 gives
** top-decile spending ~50% above bottom-decile and R²≈7% (matching the paper).
** Total u_energy variance is σ≈0.57 (large idiosyncratic variation conditional on income).
gen u_inc         = rnormal(log(2500), 0.50)
gen u_energy_base = rnormal(0, 0.55)     // idiosyncratic energy component (σ≈0.55)
gen u_energy      = log(90) + 0.32 * (u_inc - log(2500)) + u_energy_base
gen u_nondur      = u_inc + rnormal(-0.55, 0.20)  // correlated with income
drop u_energy_base

** Prepay users: lower income, slightly lower energy spending than DD
** (paper: PP £107.8/mo vs VDD £120.6/mo)
replace u_inc    = u_inc    - 0.30 if sample == 1
replace u_energy = u_energy - 0.10 if sample == 1

** Other user flags
gen everheatingoiluser = (runiform() < 0.05)
gen energycredits      = 0

tempfile users
save `users'


** =============================================================================
** PART 2: EXPAND TO USER × MONTH PANEL (Jan 2019 - Dec 2023 = 60 months)
** =============================================================================

use `users', clear
expand 60
bysort userref: gen seq = _n

gen year  = 2019 + floor((seq - 1) / 12)
gen month = mod(seq - 1, 12) + 1
gen yrmn  = year * 100 + month
drop seq

** Pin a unique, platform-independent row order before any further random
** draws or tie-dependent operations. userref x yrmn is unique, so this fixes
** the mapping of the (seed-fixed) random stream onto observations identically
** across operating systems and Stata flavors.
sort userref yrmn

** Update age for each year
gen age = age_2021 - (2021 - year)
replace age = max(1, age)

** Date of birth
gen doby = 2021 - age_2021
gen dobm = ceil(runiform() * 12)
gen dob  = ym(doby, dobm)
format dob %tm


** =============================================================================
** PART 3: WEATHER (REAL DATA — NATIONAL AVERAGES FROM 6.insheetweatherprices)
** =============================================================================

** Collapse LSOA-level weather to national year-month averages and merge in
preserve
	use "$dataProcess/weather", clear
	collapse (mean) rain humid tmax tmin tavg, by(year month)
	gen yrmn = year * 100 + month
	tempfile weather_ym
	save `weather_ym'
restore

merge m:1 year month using `weather_ym', keep(master match) nogenerate

** Polynomial terms
forval p = 2/5 {
    gen tmin`p' = tmin ^ `p'
    gen tmax`p' = tmax ^ `p'
}
gen tminlesstmax2 = (tmin - tmax) ^ 2


** =============================================================================
** PART 4: MERGE REAL PUBLIC TIME-SERIES (CPI, PRICE CAPS)
** =============================================================================

** CPI series (based on ONS data; Dec 2022 = 1.0 in this file)
merge m:1 year month using "$dataProcess/cpi_stata.dta", ///
    keepusing(cpi cpi_food cpi_energy cpi_electricity cpi_gas cpi_nondur_excenergy) ///
    keep(master match) nogenerate

rename cpi cpi_allitems
gen cpi_elec = cpi_electricity   // step5 has both cpi_electricity and cpi_elec
gen cpi_ener = cpi_energy        // step5 abbreviation used in 1.summarystats.do line 99

** Unit costs and price indices (Ofgem public data)
merge m:1 ofgem_region yrmn using "$dataProcess/unitcosts_gas_elec_yrmn.dta", ///
    keepusing(Gas_Other_unitprice Gas_Other_sc ElecSingle_Other_unitprice    ///
              ElecSingle_Other_sc Gas_Other_sc_gb ElecSingle_Other_sc_gb     ///
              Gas_Other_unitprice_gb ElecSingle_Other_unitprice_gb            ///
              mp_elec_idx mp_gas_idx mp_gas_idx_gb mp_elec_idx_gb             ///
              pidx_energy_tot_lasp pidx_energy_tot_lasp_gb                   ///
              pidx_energy_tot_altlasp pidx_energy_tot_paasche                ///
              pidx_energy_tot_fisher  pidx_energy_tot_altlasp_chain          ///
              pidx_energy_tot_paasche_chain pidx_energy_tot_fisher_chain     ///
              pidx_energy_tot_altlasp_gb pidx_energy_tot_paasche_gb          ///
              pidx_energy_tot_fisher_gb pidx_energy_tot_altlasp_chain_gb     ///
              pidx_energy_tot_paasche_chain_gb pidx_energy_tot_fisher_chain_gb ///
              EPGsubsidy_up_Elec EPGsubsidy_up_Gas EPGsubsidy_Energy cap_binding) ///
    keep(master match) nogenerate

** Fill in EPG subsidy variables: 0 outside EPG period (Oct 2022 - Mar 2023)
replace EPGsubsidy_up_Elec = 0 if EPGsubsidy_up_Elec == .
replace EPGsubsidy_up_Gas  = 0 if EPGsubsidy_up_Gas  == .
replace EPGsubsidy_Energy  = 0 if EPGsubsidy_Energy  == .
replace cap_binding        = 0 if cap_binding        == .

** EBSS refund: £66.66/month Oct 2022 - Mar 2023 (£400 total over 6 months)
** DD users who received EBSS as a meter credit (not cash in bank) are the
** "credit" subsample in 6.MPCs.do (everEBSScash==0). ~35% of DD users.
** EBSS_refund1: amount added to measured energy spending during the EBSS window.
** For PP: only the flypaper fraction (~0.34 = MPCE) of the £66.66 voucher shows up
**   as incremental spending — the rest accumulates as unused meter credit.
**   Using 0.34 * 0.9 * 66.66 ≈ £20.4 reproduces the paper's MPCE ≈ 0.34–0.38.
** For DD cash: the full £66.66 bank credit is used as the EBSS_refund measure.
** For DD credit: EBSS was applied to their bill (not the bank), so refund = 0.
local pp_fly_amt = 0.34 * 0.90 * 66.66   // ≈ 20.4
gen EBSS_refund1 = cond(sample == 1, `pp_fly_amt', 66.66) ///
                   * (yrmn >= 202210 & yrmn <= 202303) * ebss_cash
gen EBSS_refund2    = 0
gen EBSS_refund     = EBSS_refund1
gen EBSS_everrefund = (EBSS_refund > 0)
gen EBSS_everrefund1 = EBSS_everrefund
gen EBSS_everrefund2 = 0


** =============================================================================
** PART 5: SPENDING VARIABLES
** =============================================================================

** Re-establish the canonical unique row order after the m:1 merges above. The
** merges leave the data sorted by their (non-unique) keys; without this every
** random draw below would map to observations in a tie order that is not
** guaranteed identical across platforms/Stata flavors. userref x yrmn is unique.
sort userref yrmn

** Standing charge (monthly = annual / 12)
gen exp_energy_t_sc    = (Gas_Other_sc    + ElecSingle_Other_sc)    / 12
gen exp_energy_t_sc_gb = (Gas_Other_sc_gb + ElecSingle_Other_sc_gb) / 12
replace exp_energy_t_sc    = 20 if exp_energy_t_sc    == . | exp_energy_t_sc    < 0
replace exp_energy_t_sc_gb = 20 if exp_energy_t_sc_gb == . | exp_energy_t_sc_gb < 0

** Days per month
gen dayspermonth = 28
replace dayspermonth = 29 if month == 2 & mod(year, 4) == 0 & mod(year, 100) != 0
replace dayspermonth = 30 if inlist(month, 4, 6, 9, 11)
replace dayspermonth = 31 if inlist(month, 1, 3, 5, 7, 8, 10, 12)

** Price index (ensure positive for logs)
replace pidx_energy_tot_lasp    = 1 if pidx_energy_tot_lasp    == . | pidx_energy_tot_lasp    <= 0
replace pidx_energy_tot_lasp_gb = 1 if pidx_energy_tot_lasp_gb == . | pidx_energy_tot_lasp_gb <= 0

** Log prices
gen lprice     = log(pidx_energy_tot_lasp)
gen lprice2    = lprice ^ 2
gen lpnondur   = log(max(cpi_nondur_excenergy, 0.001))
gen lrealprice = lprice - lpnondur

** Heterogeneous price index (prepay households face small premium historically)
gen pidx_energy_tot_lasp_het = pidx_energy_tot_lasp * (1 + 0.04 * (sample == 1))
gen lprice_het = log(pidx_energy_tot_lasp_het)

** Pre-2020 interactions (for estimation using pre-crisis variation)
gen month_pre2020   = month  * (year < 2020)
gen lprice_pre2020  = lprice * (year < 2020)
gen lprice2_pre2020 = lprice2 * (year < 2020)

** ---- Variable energy spend (net of standing charge, excl rebate) ----
** log(energy_nosc) is LOG EXPENDITURE (not log quantity). For inelastic
** demand, expenditure rises with price: coeff on log(p) is +0.57.
** This implies a finite-change quantity elasticity of -0.33 for the
** April 2022 cap rise (45%): Δlog(q) = (0.57-1)*log(1.45) = -0.160,
** Δq/q = exp(-0.160)-1 ≈ -14.8%, elasticity = -14.8%/45% ≈ -0.33.
** Noise σ=0.35 gives one-year autocorrelation ≈ 0.55 pooled, which
** combined with seasonal repetition brings AC(12) near the paper's 0.74.
gen log_e_nosc = u_energy                              ///  user fixed effect
               + 0.30 * cos(2 * _pi * (month - 1) / 12)  ///  seasonal
               + 0.57 * lprice                          ///  price response (log-expenditure coeff)
               + rnormal(0, 0.35)                       //   idiosyncratic shock

gen exp_energy_t_noreb_nosc    = max(exp(log_e_nosc), 1)
gen exp_energy_t_noreb_nosc_gb = exp_energy_t_noreb_nosc
gen exp_energy_t_noreb         = exp_energy_t_noreb_nosc + exp_energy_t_sc

** Energy spend including EBSS rebate
gen exp_energy_t_reb_nosc    = exp_energy_t_noreb_nosc + EBSS_refund
gen exp_energy_t_reb_nosc_gb = exp_energy_t_reb_nosc
gen exp_energy_t_reb         = exp_energy_t_reb_nosc + exp_energy_t_sc

** Quantity index
gen qidx_energy_reb_tot    = max(exp_energy_t_reb_nosc, 0.01)  / max(pidx_energy_tot_lasp, 0.01)
gen qidx_energy_reb_tot_gb = max(exp_energy_t_reb_nosc, 0.01)  / max(pidx_energy_tot_lasp_gb, 0.01)
gen qidx_energy_noreb_tot  = max(exp_energy_t_noreb_nosc, 0.01) / max(pidx_energy_tot_lasp, 0.01)

** Log energy spending (per day)
gen lexp     = log(max(exp_energy_t_reb_nosc, 0.01)   / dayspermonth)
gen lexp_nosc = lexp
gen lexp_noreb = log(max(exp_energy_t_noreb_nosc, 0.01) / dayspermonth)
gen lexp_fullsamp     = lexp
gen lexp_fullsamp_noreb = lexp_noreb

** Log quantity (per day)
gen leqnt       = log(max(qidx_energy_reb_tot, 0.0001)   / dayspermonth)
gen leqnt_noreb = log(max(qidx_energy_noreb_tot, 0.0001)  / dayspermonth)
gen leqnt_gb    = log(max(qidx_energy_reb_tot_gb, 0.0001) / dayspermonth)

drop log_e_nosc

** ---- Income and nondurable spending ----

gen tot_in_excltrans = max(exp(u_inc + rnormal(0, 0.08)), 50)
gen tot_in           = tot_in_excltrans * 1.05

** Nondurables: correlated with income
gen tot_out_nondurab_noreb = max(exp(u_nondur + rnormal(0, 0.10)), 50)
gen tot_out_nondurab       = tot_out_nondurab_noreb
gen tot_out_nondurab_reb   = tot_out_nondurab_noreb + EBSS_refund

** Net of standing charge
gen tot_out_nondurab_reb_nosc = tot_out_nondurab_reb - exp_energy_t_sc

** Log income and nondurables (per day)
gen log_inc         = log(max(tot_in_excltrans, 0.01) / dayspermonth)
gen lnY             = log_inc
gen ltotexp_nondur  = log(max(tot_out_nondurab_reb, 0.01)    / dayspermonth)
gen ltotexp_nondur_noreb = log(max(tot_out_nondurab_noreb, 0.01) / dayspermonth)

** Energy budget share (net of SC)
gen s_ener_nosc = max(exp_energy_t_reb_nosc, 0) / max(tot_out_nondurab_reb, 1)
replace s_ener_nosc = min(1, s_ener_nosc)

** Remaining totals
gen tot_out_semidurab = exp(rnormal(log(50), 0.5))
gen tot_out_durable   = max(rnormal(50, 80), 0)
gen tot_out_housing   = max(exp(rnormal(log(600), 0.35)), 100)
gen tot_out_excltrans = tot_out_nondurab_noreb + tot_out_semidurab + tot_out_durable + tot_out_housing
gen tot_out           = tot_out_excltrans * 1.05

** Liquid assets
gen liquid_assets = max(exp(rnormal(log(500), 0.80)), 0)

** Government payments and financial indicators
gen col       = (inlist(yrmn, 202207, 202211, 202302))  // cost-of-living payments
gen wfp       = 300 * (month == 12 & age_2021 >= 65)    // winter fuel payment
gen cwp       = 25  * (inlist(month, 1, 2, 12) & gor != 7) // cold weather payment
gen reccol    = col
gen rebates   = (year == 2022 & month >= 10) | (year == 2023 & month <= 3)

gen payday_in   = (runiform() < 0.03)
gen payday_out  = (runiform() < 0.03)
gen anyloan_in  = (runiform() < 0.05)
gen anyloan_out = (runiform() < 0.05)
gen onbenefits  = (runiform() < (0.12 + 0.08 * (sample == 1)))
replace onbenefits = min(1, onbenefits)
gen disabled    = (runiform() < 0.08)
gen children    = (runiform() < 0.28)
gen numchld     = 0
replace numchld = ceil(runiform() * 3) if children == 1
gen wfh         = 0   // set correctly as time indicator after expand (Dec 2021 & Jan 2022)

** Income inflows
gen amount_in_salary    = tot_in_excltrans * (0.80 + rnormal(0, 0.10))
gen amount_in_benefit   = onbenefits * 500
gen amount_in_pension   = (age_2021 >= 65) * max(rnormal(800, 200), 0)
gen amount_in_savinc    = liquid_assets * 0.002
gen amount_in_loanfnd   = anyloan_in * max(rnormal(1000, 300), 0)
gen amount_in_other     = max(rnormal(80, 40), 0)
gen amount_in_transfers = tot_in - tot_in_excltrans

** Spending outflows (approximately add to tot_out_nondurab)
gen amount_out_grocery    = max(exp(rnormal(log(250), 0.30)), 10)
gen amount_out_fuel       = max(exp(rnormal(log(50),  0.50)), 1)
gen amount_out_energy     = exp_energy_t_noreb
gen amount_out_discret    = max(exp(rnormal(log(120), 0.50)), 5)
gen amount_out_phonetv    = max(exp(rnormal(log(55),  0.30)), 5)
gen amount_out_clothes    = max(exp(rnormal(log(45),  0.60)), 1)
gen amount_out_mortrent   = tot_out_housing * 0.90
gen amount_out_transport  = max(exp(rnormal(log(75),  0.50)), 5)
gen amount_out_amazon     = max(exp(rnormal(log(28),  0.70)), 1)
gen amount_out_online     = max(exp(rnormal(log(35),  0.65)), 1)
gen amount_out_personal   = max(exp(rnormal(log(28),  0.60)), 1)
gen amount_out_othbill    = max(exp(rnormal(log(90),  0.40)), 5)
gen amount_out_counciltax = max(exp(rnormal(log(125), 0.20)), 20)
gen amount_out_childcare  = numchld * max(rnormal(180, 50), 0)
gen amount_out_savings    = max(exp(rnormal(log(80),  0.80)), 0)
gen amount_out_loanpay    = anyloan_out * max(rnormal(180, 80), 0)
gen amount_out_homeimp    = max(exp(rnormal(log(25),  1.00)), 0)
gen amount_out_diy        = max(exp(rnormal(log(18),  1.00)), 0)
gen amount_out_bnpl       = max(exp(rnormal(log(18),  1.20)), 0)
gen amount_out_transfers  = tot_out * 0.05
gen amount_out_other      = max(rnormal(80, 40), 0)
gen amount_out_other_card = amount_out_other * 0.50


** =============================================================================
** PART 6: PAYMENT-TYPE VARIABLES
** =============================================================================

** Energy supplier (1 = British Gas, 2-8 = other major suppliers)
gen energy_supplier1 = ceil(runiform() * 8)
gen energy_supplier2 = 0
label define temp2 1 "British Gas" 2 "EDF Energy" 3 "E.ON" 4 "Npower" ///
    5 "Scottish Power" 6 "SSE" 7 "Bulb" 8 "Octopus Energy" ///
    9 "Other" 10 "Other2", replace
label values energy_supplier1 temp2
label values energy_supplier2 temp2

** Payment mode strings (checked against values used in do-file conditionals)
gen mode1 = "Direct Debit"    if sample >= 2
replace mode1 = "Prepayment"  if sample == 1
gen mode2 = ""

** Payment indicators
gen direct_debit1         = (sample >= 2)
gen direct_debit2         = 0
gen likely_pp1            = (sample == 1)
gen likely_pp2            = 0
gen variable_slack1       = (sample == 2)
gen variable_semistrict1  = (sample == 2)
gen variable_strict1      = (sample == 2)
gen variable_slack2       = 0
gen variable_semistrict2  = 0
gen variable_strict2      = 0

** Number of transactions per month (prepay top-ups)
gen ntrans1 = 0
replace ntrans1 = max(1, round(rnormal(15, 5))) if sample == 1
gen ntrans2 = 0

** Frequency (card payers)
gen freq_monthly1   = (sample == 3)
gen freq_quarterly1 = 0
gen freq_monthly2   = 0
gen freq_quarterly2 = 0

** Account-level amounts
gen amount1               = exp_energy_t_noreb
gen amount2               = 0
gen amount_energy_credit1 = EBSS_refund
gen amount_energy_credit2 = 0

** Number of accounts
gen n_accounts = 1


** =============================================================================
** PART 7: TIME INDICATORS
** =============================================================================

** Sequential time variable (group of year-month)
sort year month userref
egen t = group(year month)
gen  t2 = t ^ 2
gen  month2 = month ^ 2

** Post-policy indicators (UK price cap change dates)
replace wfh    = (yrmn == 202112 | yrmn == 202201)  // Dec 2021 & Jan 2022 only
gen postmonth  = (yrmn >= 202204)  // April 2022: large cap increase
gen postmonth2 = (yrmn >= 202210)  // Oct 2022: EPG introduced
gen postmonth3 = (yrmn >= 202304)  // April 2023
gen postmonth4 = (yrmn >= 202310)  // Oct 2023

** One-month event-study indicators (GB vs NI comparison)
gen onemonth_post = (yrmn == 202210)
gen onemonth_pre  = (yrmn == 202209)

** Estimation-period inclusion flags
** Mirrors 8.analysis.do lines 291-292 exactly:
** tt_toinclude  = price-response window (Jun 2021 - Sep 2022)
** tt_toinclude2 = MPC estimation window (Jun 2021 - Dec 2023)
gen tt_toinclude  = ((year == 2021 & month >= 6) | (year == 2022 & month < 10)) & sample <= 2
gen tt_toinclude2 = ((year == 2021 & month >= 6) | inlist(year, 2022, 2023)) & sample <= 2

** Lagged income availability flag
gen no_lagged_income = (year == 2019)

** Alternative income measure (tax-year basis; approximated from survey income)
gen yeartax   = year
gen inc_taxyr = tot_in_excltrans + rnormal(0, 50)


** =============================================================================
** PART 8: USER-LEVEL MEAN VARIABLES (collapse then merge back)
** =============================================================================

** Compute means over 2019-2020 (pre-crisis baseline period)
preserve
    keep if year <= 2020
    collapse (mean) mtot_in_excltrans = tot_in_excltrans ///
                    mexp_energy_t_reb = exp_energy_t_reb  ///
                    mtot_out_nondurab = tot_out_nondurab_noreb ///
                    mshr_e            = s_ener_nosc,  by(userref)
    tempfile user_means
    save `user_means'
restore

merge m:1 userref using `user_means', nogenerate

gen minc  = mtot_in_excltrans
gen meexp = mexp_energy_t_reb
gen msexp = mshr_e

** Tax-year income (user mean)
preserve
    collapse (mean) inc_taxyr_u = inc_taxyr, by(userref)
    tempfile inc_taxyr_u
    save `inc_taxyr_u'
restore
merge m:1 userref using `inc_taxyr_u', nogenerate


** =============================================================================
** PART 9: QUANTILE VARIABLES
** (All quantiles are computed from user-level means to be constant within user)
** =============================================================================

** Income deciles/quintiles/percentiles
xtile inc_p    = mtot_in_excltrans, nq(100)
xtile inc_dec  = mtot_in_excltrans, nq(10)
xtile inc_quint = mtot_in_excltrans, nq(5)
xtile mtot_in_excltrans_quart = mtot_in_excltrans, nq(4)

** Energy spending deciles
xtile eexp_p    = mexp_energy_t_reb, nq(100)
xtile eexp_dec  = mexp_energy_t_reb, nq(10)
xtile eexp_quint = mexp_energy_t_reb, nq(5)
xtile mexp_energy_t_reb_quart = mexp_energy_t_reb, nq(4)

** Nondurable spending deciles
xtile mtot_out_nondurab_p     = mtot_out_nondurab, nq(100)
xtile mtot_out_nondurab_dec   = mtot_out_nondurab, nq(10)
xtile mtot_out_nondurab_quint = mtot_out_nondurab, nq(5)
xtile mtot_out_nondurab_quart = mtot_out_nondurab, nq(4)

** Energy share deciles
xtile sexp_p    = mshr_e, nq(100)
xtile sexp_dec  = mshr_e, nq(10)
xtile sexp_quint = mshr_e, nq(5)
xtile mshr_e_quart = mshr_e, nq(4)

** Tax-year income quantiles
xtile inc_p_taxyr    = inc_taxyr_u, nq(100)
xtile inc_dec_taxyr  = inc_taxyr_u, nq(10)
xtile inc_quint_taxyr = inc_taxyr_u, nq(5)
drop inc_taxyr_u


** =============================================================================
** PART 10: SAMPLE FLAGS AND WEIGHTS
** =============================================================================

gen drop_outliers            = 0
gen no_heterogeneity_measures = 0   // =0: no NI users in synthetic sample
gen dropflag                 = 0

** Mark top/bottom 1% of energy spenders as outliers
xtile eexp_pct = mexp_energy_t_reb, nq(100)
replace drop_outliers = 1 if eexp_pct <= 1 | eexp_pct >= 99
drop eexp_pct

** Weights: simplified equal weights (real data reweights to age×gor distribution)
gen weight_fullsam_all    = 1.0
gen weight_balsam_all     = 1.0
gen weight_fullsam_vari1  = 1.0
gen weight_fullsam_vari1_x = 1.0
gen weight_balsam_vari1   = 1.0
gen weight_balsam_vari1_x = 1.0
gen weight_fullsam_vari2  = 1.0
gen weight_fullsam_vari2_x = 1.0
gen weight_balsam_vari2   = 1.0
gen weight_balsam_vari2_x = 1.0

** Drop construction variables
drop u_inc u_energy u_nondur


** =============================================================================
** PART 11: SAVE CSenergyallspending_step5.dta
** =============================================================================

disp as error "Saving CSenergyallspending_step5.dta ..."
sort userref yrmn
save "$dataProcess/CSenergyallspending_step5.dta", replace
disp as error "Done. N=" _N " obs, " c(k) " variables."

preserve

drop if drop_outliers == 1| no_het == 1| no_lagged_income == 1 

gen prepay=sample==1
keep userref yeartax eexp_dec inc_dec_taxyr prepay
sort userref yeartax eexp_dec inc_dec_taxyr prepay
by userref yeartax: keep if _n==1

gen Npop = 1

collapse (sum) Npop,by(inc_dec_taxyr eexp_dec prepay yeartax)

egen tot=sum(Npop),by(prepay yeartax)
su tot if prepay==1
local x = `r(mean)'
su tot if prepay==0
local y = `r(mean)'

gen rw = ($pp_shr*`y')/((1-$pp_shr)*`x')
replace Npop = int(Npop*rw+0.5) if prepay==1

drop tot rw

sa "$dataProcess/population_weights.dta", replace

restore
** =============================================================================
** PART 11b: CREATE AND SAVE CSenergyallspending_step6.dta
** Mirrors 2.setupData/8.analysis.do lines 549-649.
** Step6 = step5 with fewer variables + deseasonalised log-expenditure measures.
** The deseasonalisation uses xtreg with month dummies on 2019-2020 data;
** this runs fine on synthetic data (standard FE regression).
** =============================================================================

disp as error "Creating CSenergyallspending_step6.dta ..."

preserve

    ** sc_monthly: card payment households with monthly frequency
    gen sc_monthly = (mode1 == "Card payment" & mode2 == "" & freq_monthly1 == 1) | ///
                     (mode1 == "Card payment" & mode2 == "Card payment"           ///
                      & freq_monthly1 == 1 & freq_monthly2 == 1)

    ** Apply same sample restrictions as in 8.analysis.do
    drop if drop_outliers == 1
    drop if no_heterogeneity_measures == 1 & NI == 0
    drop if year <= 2018

    ** Keep the subset of variables used in step6
    ** Uses same wildcards as 8.analysis.do to avoid brittle explicit lists
    #delimit ;
    keep userref NI gor everheatingoiluser userref_orig yrmn inc_dec rebates
         energy_supplier1 energy_supplier2 col reccol wfh cpi_allitems
         salaryrange weight_fullsam_all weight_fullsam_vari? weight_fullsam_vari?_x
         EBSS_refund1 EBSS_everrefund1 EBSS_refund2 EBSS_everrefund2
         year month onemonth*
         exp_energy_t* sample_* sc_monthly
         tmin tmax tavg humid rain cpi_gas cpi_elec cpi_ener
         qidx_* pidx_energy_tot_lasp*
         leqnt_noreb leqnt lexp lexp_noreb lexp_nosc
         lprice lprice_het rebates tmin? tmax? tminlesstmax2
         t t2 lnY postmonth* tt_toinclude*
         sample inc_quint eexp_quint sexp_quint ofgem_region ;
    #delimit cr

    ** Supplier-change indicator (June–Dec 2021)
    isid userref yrmn
    sort userref yrmn
    by userref: gen new_supplier = ///
        ((energy_supplier1 != energy_supplier1[_n-1]) & ///
         (energy_supplier1 != energy_supplier2[_n-1])) | ///
        ((energy_supplier2 != energy_supplier2[_n-1]) & ///
         (energy_supplier2 != energy_supplier1[_n-1]))
    replace new_supplier = 0 if _n == 1

    gen temp = yrmn >= 202106 & yrmn <= 202112
    by userref: egen max_new_supplier = max(temp * new_supplier)
    drop temp

    ** DD review frequency by supplier
    gen dd_review = 99
    foreach x in 1 2 {
        decode energy_supplier`x', gen(supplier_str)
        replace dd_review = 1 if inlist(supplier_str, "Octopus Energy", "Scottish Power")
        replace dd_review = 2 if inlist(supplier_str, "E.ON", "Ovo Energy")  & dd_review == 99
        replace dd_review = 3 if inlist(supplier_str, "British Gas", "EDF Energy") & dd_review == 99
        drop supplier_str
    }

    ** EBSS receipt indicators
    gen EBSS_refund = EBSS_refund1
    replace EBSS_refund = 1 if EBSS_refund2 == 1

    by userref: egen everEBSS = max(EBSS_refund > 0)

    gen everEBSSbutnorebate_temp = 1 if everEBSS == 1 & rebates == 1 & EBSS_refund == 0
    by userref: egen everEBSSbutnorebate = min(everEBSSbutnorebate_temp)
    replace everEBSSbutnorebate = 0 if everEBSSbutnorebate == .
    drop everEBSSbutnorebate_temp

    gen everEBSScash = (everEBSS == 1) if everEBSSbutnorebate != 1

    ** Nominal log expenditure
    gen lexp_nom = log(exp(lexp) * cpi_allitems)

    ** -----------------------------------------------------------------------
    ** DESEASONALISATION (mirrors 8.analysis.do lines 612-626)
    ** Regress log outcomes on month dummies using 2019-2020 within-user FE,
    ** then subtract the month fixed effects to produce _ds and _dsw series.
    ** -----------------------------------------------------------------------

    global tempcontrols "tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2"

    foreach v in lexp lexp_nosc lexp_nom leqnt {
        gen `v'_ds  = `v'
        gen `v'_dsw = `v'
        foreach s in 1 2 3 {
            ** Without weather controls
            cap xtreg `v' i.month if sample == `s' & year < 2021 & NI != 1, ///
                i(userref) fe robust
            if _rc == 0 {
                forval m = 2/12 {
                    replace `v'_ds = `v' - _b[`m'.month] ///
                        if `m'.month == 1 & sample == `s'
                }
            }
            ** With weather controls
            cap xtreg `v' i.month $tempcontrols if sample == `s' & year < 2021 & NI != 1, ///
                i(userref) fe robust
            if _rc == 0 {
                forval m = 2/12 {
                    replace `v'_dsw = `v' - _b[`m'.month] ///
                        if `m'.month == 1 & sample == `s'
                }
            }
        }
    }

    ** Additional panel / weight variables used by 6.MPCs.do
    gen sample1 = (sample == 1)
    gen sample2 = (sample == 2)
    egen userref_sample = group(userref sample)
    egen tt = group(yrmn)

    gen weight_fullsam_vari_x = weight_fullsam_vari1_x if sample1 == 1
    replace weight_fullsam_vari_x = weight_fullsam_vari2_x if sample2 == 1

    gen weight_fullsam_vari = weight_fullsam_vari1 if sample1 == 1
    replace weight_fullsam_vari = weight_fullsam_vari2 if sample2 == 1

    tab month, gen(mm)

    isid userref year month
    sort userref year month

    save "$dataProcess/CSenergyallspending_step6.dta", replace

restore

disp as error "CSenergyallspending_step6.dta saved."


** =============================================================================
** PART 12: SAVE CSenergyallspending_step2b_weights.dta
** (User × age_5band × gor: used for regional/age reweighting)
** =============================================================================

disp as error "Saving CSenergyallspending_step2b_weights.dta ..."

preserve
    bysort userref age_5band gor: keep if _n == 1
    keep userref userref_orig age_5band gor balanced dataset

    ** Approximate population count (equal within cells for synthetic data)
    bysort age_5band gor: gen count_norm = 1 / _N
    gen weight_fullsamp = 1
    gen weight_balsamp  = 1

    save "$dataProcess/CSenergyallspending_step2b_weights.dta", replace
restore


** =============================================================================
** PART 13: SAVE CSenergy_step1_combine.dta
** (Transaction-level energy data; one row per user × month × account)
** =============================================================================

disp as error "Saving CSenergy_step1_combine.dta ..."

preserve
    keep userref year month yrmn energy_supplier1 mode1 amount1 ///
         amount_energy_credit1 likely_pp1 ntrans1 direct_debit1 ///
         variable_slack1 variable_semistrict1 variable_strict1 ///
         EBSS_refund1 EBSS_everrefund1 freq_monthly1 freq_quarterly1

    rename energy_supplier1 energy_supplier
    rename mode1             mode
    rename amount1           amount
    rename amount_energy_credit1 amount_energy_credit
    rename likely_pp1        likely_pp
    rename ntrans1           ntrans
    rename direct_debit1     direct_debit
    rename variable_slack1   variable_slack
    rename variable_semistrict1 variable_semistrict
    rename variable_strict1  variable_strict
    rename EBSS_refund1      EBSS_refund
    rename EBSS_everrefund1  EBSS_everrefund
    rename freq_monthly1     freq_monthly
    rename freq_quarterly1   freq_quarterly

    ** Generate string numbering variables present in real data
    sort userref mode yrmn
    bysort userref mode (yrmn): gen string_no     = 1
    bysort userref mode: gen string_length = _N
    gen string_6mplus = (string_length >= 6)
    gen payment_change = (runiform() < 0.05) * direct_debit
    gen filled_in = 0
    gen filled_in_onlysingles = 0

    save "$dataProcess/CSenergy_step1_combine.dta", replace
restore


** =============================================================================
** PART 14: SAVE heterogeneity_measures.dta
** (One row per user; merged into step5 for summarystats.do)
** =============================================================================

disp as error "Saving heterogeneity_measures.dta ..."

preserve
    ** Order within user by yrmn so the retained row (and hence the month-varying
    ** values such as onbenefits/children) is chosen deterministically.
    bysort userref (yrmn): keep if _n == 1
    keep userref mtot_in_excltrans mtot_out_nondurab mexp_energy_t_reb ///
         sample onbenefits children mshr_e ///
         mtot_in_excltrans_quart mtot_out_nondurab_p mtot_out_nondurab_dec ///
         mtot_out_nondurab_quint mtot_out_nondurab_quart ///
         eexp_p mexp_energy_t_reb_quart ///
         sexp_p sexp_dec sexp_quint mshr_e_quart

    ** Rename to match heterogeneity_measures variable names
    rename mtot_in_excltrans_quart     mtot_in_excltrans_quart
    rename mexp_energy_t_reb_quart     mexp_energy_t_reb_quart
    rename mtot_out_nondurab_p         mtot_out_nondurab_p

    ** Add quantiles needed by heterogeneity_measures.dta
    xtile mtot_in_excltrans_p    = mtot_in_excltrans, nq(100)
    xtile mtot_in_excltrans_dec  = mtot_in_excltrans, nq(10)
    xtile mtot_in_excltrans_quint = mtot_in_excltrans, nq(5)

    ** max of onbenefits and children over time (already collapsed to user-level)
    ** (already max within user since we took one row per user)

    sort userref
    save "$dataProcess/heterogeneity_measures.dta", replace
restore


** =============================================================================
** PART 15: SAVE preestimationdata.dta
** (Estimation-period subsample for MATLAB; produced by 9.model.do)
** =============================================================================

disp as error "Saving preestimationdata.dta ..."

preserve
    ** Keep estimation sample: samples 1 and 2, June 2021 - June 2023
    keep if sample <= 2
    keep if yrmn >= 202106 & yrmn <= 202312
    drop if drop_outliers == 1
    drop if no_heterogeneity_measures == 1

    ** Create estimation-specific variables
    gen id     = userref
    gen eexp   = mexp_energy_t_reb
    gen sexp   = mshr_e

    ** Budget shares and log prices for demand system
    gen s_ener = max(exp_energy_t_reb_nosc, 0) / max(tot_out_nondurab_reb, 1)
    replace s_ener = min(1, s_ener)
    gen s_cons = 1 - s_ener

    gen log_x  = ltotexp_nondur   // log total nondurable expenditure per day
    gen p_ener = lprice            // log energy price index (Laspeyres)
    gen p_cons = lpnondur          // log non-energy CPI

    ** Rebate and payment type indicators
    gen rebatereceived = (EBSS_refund > 0)
    gen prepay    = sample_PP
    gen cashrebate = (col == 1)
    gen fixedfee  = exp_energy_t_sc

    ** Region identifier (numeric)
    sort ofgem_region
    egen region = group(ofgem_region)

    keep id userref yeartax year month t yrmn                   ///
         eexp eexp_p eexp_dec eexp_quint                         ///
         inc_quint sexp sexp_p sexp_dec sexp_quint               ///
         inc_taxyr inc_p_taxyr inc_dec_taxyr mtot_out_nondurab_dec ///
         tot_out_nondurab_noreb s_ener s_cons log_x p_ener p_cons ///
         tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 ///
         rain humid tminlesstmax2 rebates wfh col log_inc           ///
         rebatereceived age prepay cashrebate fixedfee               ///
         cpi_allitems region

    sort userref yrmn
    save "$dataProcess/preestimationdata.dta", replace
restore


** =============================================================================
** PART 16: SYNTHETIC lcfsdata.dta
** (Simplified version of the LCFS with only variables used in analysis)
** =============================================================================

disp as error "Creating synthetic lcfsdata.dta ..."

clear
set seed 20250618
set sortseed 20250618

** LCFS: annual cross-section 2013-2021, ~10,000 households/year
local lcfs_n = 80000   // ~10k per year × 8 years (2013-2020, main years used)

set obs `lcfs_n'

gen hhref    = _n
gen datayear = 2012 + ceil(_n / (`lcfs_n' / 9))   // spread across 2013-2021
replace datayear = min(datayear, 2021)
gen year     = datayear

gen month    = ceil(runiform() * 12)
gen quarter  = ceil(month / 3)
gen yrm      = year * 100 + month

gen goregion = ceil(runiform() * 12)
gen gor      = goregion

** Equivalence scale and demographics
gen numhhkid  = floor(runiform() * 3)
gen numadmal  = (runiform() < 0.5)
gen numadfem  = (runiform() < 0.5)
gen numadRet  = (runiform() < 0.2)
gen numadern  = max(numadmal + numadfem - numadRet, 0)
gen numpeeps  = numadmal + numadfem + numhhkid
replace numpeeps = max(1, numpeeps)

gen hheqsize  = 0.67 + 0.33 * min(numadmal + numadfem - 1, 1) ///
               + 0.2 * numhhkid + 0.1 * numadRet

gen age    = 30 + floor(runiform() * 50)
gen agehead = age
gen sex    = (runiform() < 0.5)

** Family type
gen famtype = 1
replace famtype = 2 if numhhkid > 0 & numadmal > 0 & numadfem > 0
replace famtype = 3 if numadRet > 0

** Tenure
gen tenure = ceil(runiform() * 4)
label define tenure 1 "Owned outright" 2 "Owned mortgage" 3 "Rented LA" 4 "Rented private", replace
label values tenure tenure

gen housingten = tenure
gen ten1 = (tenure == 3)
gen ten2 = (tenure == 4)
gen ten3 = (tenure == 2)
gen ten4 = (tenure == 1)

** Income and spending (deflated to Dec 2022 = 1)
** Use approximate real values
gen hhinc_lcfs = max(exp(rnormal(log(2200), 0.55)), 100)
gen nondurables_lcfs = max(exp(rnormal(log(1600), 0.45)), 50)

** Energy expenditure
gen exp_gas  = max(exp(rnormal(log(50), 0.50)), 1)
gen exp_elec = max(exp(rnormal(log(50), 0.45)), 1)
gen exp_nonelecgasenergy = max(rnormal(5, 5), 0)
gen exp_energy = exp_gas + exp_elec + exp_nonelecgasenergy

** Payment method (1=DD, 2=standard credit, 3=prepay, 4+=other)
gen paymentmethod_gas  = ceil(runiform() * 3)
replace paymentmethod_gas = 3 if runiform() < 0.15  // ~15% prepay
gen paymentmethod_elec = paymentmethod_gas + floor(runiform() * 2 - 0.5)
replace paymentmethod_elec = max(1, min(3, paymentmethod_elec))
gen paymentmethod_combined = (runiform() < 0.5) * paymentmethod_gas

** Other expenditure categories
gen exp_grocery   = max(exp(rnormal(log(250), 0.30)), 10)
gen exp_fuel      = max(exp(rnormal(log(50),  0.50)), 1)
gen exp_discret   = max(exp(rnormal(log(120), 0.50)), 5)
gen exp_phonetv   = max(exp(rnormal(log(55),  0.30)), 5)
gen exp_othbill   = max(exp(rnormal(log(90),  0.40)), 5)
gen exp_transport = max(exp(rnormal(log(75),  0.50)), 5)
gen exp_personal  = max(exp(rnormal(log(28),  0.60)), 1)
gen exp_childcare = numhhkid * max(rnormal(150, 50), 0)

** Survey weights (uniform for synthetic data)
gen hhweight  = 1
gen weighta   = 1
gen weight    = 1
gen indivweight = 1

** CPI data (merge from real data)
merge m:1 year month using "$dataProcess/cpi_stata.dta", ///
    keepusing(cpi cpi_food cpi_energy cpi_electricity cpi_gas cpi_nondur_excenergy) ///
    keep(master match) nogenerate
rename cpi cpi_allitems

** Pin the unique row order after the merge (which sorts by its non-unique keys)
** so the random draws that follow map to households identically across
** platforms. hhref is unique.
sort hhref

** Additional LCFS variables expected by do files
gen kidsto16  = numhhkid
gen kids16plus = 0
gen hhequivinc = hhinc_lcfs / hheqsize
gen energy_lcfs = exp_energy
gen firinhh   = (_n == 1)
gen buno      = 1
gen persno    = 1
gen adno      = 1
gen reltohoh  = 1
gen empstat   = 1
gen hours     = 40
gen highed    = (age >= 21)
gen pens      = (age >= 65)
gen penhh     = pens
gen anypen    = pens
gen penother  = 0
gen pensingm  = (pens & sex == 0 & numadmal == 1 & numadfem == 0)
gen pensingf  = (pens & sex == 1 & numadmal == 0 & numadfem == 1)
gen pencoup   = (pens & numadmal > 0 & numadfem > 0)
gen age_oldest = age
gen male       = (sex == 0)
gen lone       = (numadmal + numadfem == 1)
gen couple     = (numadmal > 0 & numadfem > 0)
gen oocc       = (tenure == 1 | tenure == 2)
gen pubrent    = (tenure == 3)
gen prrent     = (tenure == 4)
gen meanage    = age
gen ncars      = floor(runiform() * 3)
gen nrooms     = 3 + floor(runiform() * 4)
gen cenheat    = (runiform() < 0.9)
gen washmach   = (runiform() < 0.95)
gen tv         = 1

** Month dummies
forval m = 1/12 {
    gen month`m' = (month == `m')
}

** Age group dummies (multiple categorisations expected by do files)
gen agedum = 1
replace agedum = 2 if age >= 65
replace agedum = 3 if age >= 75
replace agedum = 4 if age >= 80
gen ageb = ceil(age / 10) - 1
replace ageb = min(7, max(1, ageb))
gen bageb  = 1
replace bageb = 2 if age >= 35
replace bageb = 3 if age >= 50
replace bageb = 4 if age >= 65
gen bagebpen = (age >= 65)
gen terage = 1
replace terage = 2 if age >= 70
replace terage = 3 if age >= 80
gen ageg3 = 1
replace ageg3 = 2 if age >= 35
replace ageg3 = 3 if age >= 65

** Age dummies (60s/70s/80+)
gen age1 = (age >= 60 & age < 65)
gen age2 = (age >= 65 & age < 70)
gen age3 = (age >= 70 & age < 75)
gen age4 = (age >= 75 & age < 80)
gen age5 = (age >= 80)
gen ageb1 = (age >= 20 & age < 30)
gen ageb2 = (age >= 30 & age < 40)
gen ageb3 = (age >= 40 & age < 50)
gen ageb4 = (age >= 50 & age < 60)
gen ageb5 = (age >= 60 & age < 70)
gen ageb6 = (age >= 70 & age < 80)
gen ageb7 = (age >= 80)
gen bageb1 = (age < 35)
gen bageb2 = (age >= 35 & age < 50)
gen bageb3 = (age >= 50 & age < 65)
gen bageb4 = (age >= 65)
gen terage1 = (age >= 60 & age < 70)
gen terage2 = (age >= 70 & age < 80)
gen terage3 = (age >= 80)
gen ageg31 = (age >= 18 & age < 35)
gen ageg32 = (age >= 35 & age < 65)
gen ageg33 = (age >= 65)

** Employment status dummies
gen empstat1 = 1
gen empstat2 = 0
gen empstat3 = 0
gen numempl  = numadern
gen numself  = 0
gen numunemp = 0
gen emphead  = (numadern > 0)
gen heademp  = emphead
gen headed   = (highed == 1)
gen penhead  = pens

** Housing
gen tot_out_housing = max(exp(rnormal(log(600), 0.35)), 100)
gen rent        = tot_out_housing * (prrent | pubrent)
gen mortgageint = tot_out_housing * oocc * 0.4
gen mortgagetot = tot_out_housing * oocc
gen ratect      = 125
gen insgr       = 15
gen housingcosts = rent + mortgageint + ratect
gen tvlicen     = 13.25

** RPI and CPI expenditure totals
gen rpi_totexp    = nondurables_lcfs * 0.95
gen rpi_FUEL_LIG  = exp_energy * 0.90
gen cpi_totexp    = nondurables_lcfs
gen adstotexpnet  = nondurables_lcfs
gen adsshcarnet   = 0
gen adsTRANSPORTnet = exp_transport
gen region        = gor
gen caseno        = hhref
gen adscaseno     = hhref
gen adsmonth      = month
gen adsweek       = ceil(month * 4.3)
gen week          = adsweek
gen grosfac       = 1

** FES energy variable fields (from 2013-2019 FES extract)
gen a128 = paymentmethod_gas
gen a129 = paymentmethod_combined
gen a130 = paymentmethod_elec
gen elec_centralheating        = (runiform() < 0.10)
gen gas_centralheating         = (runiform() < 0.70)
gen oil_centralheating         = (runiform() < 0.05)
gen soildfuel_centralheating   = 0
gen oilandsolidfuel_centralheating = 0
gen calorgas_centalheating     = 0
gen othergas_centralheating    = 0
gen geperiod  = 1
gen elecperiod = 1
gen gasperiod  = 1
gen newfam     = famtype
gen exfam      = (famtype == 3)
gen famcoup    = (famtype == 2)
gen famsingm   = (numadmal == 1 & numadfem == 0 & numhhkid == 0 & famtype == 1)
gen famsingf   = (numadmal == 0 & numadfem == 1 & numhhkid == 0 & famtype == 1)
gen famother   = 1 - famcoup - famsingm - famsingf
gen tempfamcoup = famcoup
gen kidage     = numhhkid * 7   // approximate

** hhinc: plain alias needed by 1.summarystats.do line 761 (uses hhinc not hhinc_lcfs)
gen hhinc = hhinc_lcfs

** NOTE: quintinc, quintenergyspend, and share_gas are NOT included here.
** They are computed inside 3.descriptiveResults/1.summarystats.do from the
** raw variables above. Including them here would cause "variable already defined" errors.

disp as error "Saving lcfsdata.dta ..."
save "$dataProcess/lcfsdata.dta", replace



** =============================================================================
** PART 17: SYNTHETIC lcfsdata_incAHC.dta
** 1,000-row lookup table: all combinations of inc_dec × mtot_out_nondurab_dec
** × eexp_dec (each 1-10). Used in 1.summarystats.do and 1.observedpolicy.do:
**   gen incAHC = incAHC_over_nondur_pred * tot_out_nondurab_reb
** incAHC_over_nondur_pred must be positive so that incAHC > 0.
** Values here approximate the real file range (0.7-0.95).
** =============================================================================

disp as error "Creating synthetic lcfsdata_incAHC.dta ..."

clear
set obs 1000
gen n = _n

** Generate all 10×10×10 combinations of the three keys
gen inc_dec              = mod(n - 1, 10) + 1
gen mtot_out_nondurab_dec = mod(floor((n - 1) / 10), 10) + 1
gen eexp_dec             = floor((n - 1) / 100) + 1
drop n

** incAHC_over_nondur_pred: ratio of AHC income to nondurable spending.
** Declines slightly with energy share (eexp_dec) and rises with income (inc_dec).
** Real file range approx 0.70-0.95; keep positive throughout.
gen incAHC_over_nondur_pred = 0.82                       ///
    + 0.012 * (inc_dec - 5.5)  / 4.5                    ///  higher income -> higher ratio
    - 0.008 * (eexp_dec - 5.5) / 4.5                    ///  higher energy share -> lower
    + 0.004 * (mtot_out_nondurab_dec - 5.5) / 4.5       ///  higher nondur spending -> higher
    + rnormal(0, 0.005)
replace incAHC_over_nondur_pred = max(0.65, min(1.0, incAHC_over_nondur_pred))

** incAHC_over_inc_pred: ratio of AHC income to gross income (present in real
** file but not used in analysis code; included for completeness).
gen incAHC_over_inc_pred = 0.88                          ///
    - 0.010 * (inc_dec - 5.5) / 4.5                     ///
    + rnormal(0, 0.004)
replace incAHC_over_inc_pred = max(0.75, min(0.98, incAHC_over_inc_pred))

sort inc_dec mtot_out_nondurab_dec eexp_dec
save "$dataProcess/lcfsdata_incAHC.dta", replace


