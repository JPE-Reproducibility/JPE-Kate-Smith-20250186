## Filepaths Analysis Details

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/momder.m**

- Line 21, unix : G=G/N;

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/2.macrotrends.do**

- Line 33, unix : forval m = 2/12 {
- Line 38, unix : forval m = 2/12 {
- Line 79, unix : forval t = 2/60 {
- Line 85, unix : forval t = 2/20 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/4.weights.do**

- Line 8, windows : insheet using "$dataRaw\downloaded\Ward_to_Local_Authority_District_to_County_to_Region_to_Country_(May_2023)_Lookup_in_United_Kingdom.csv", comma clear
- Line 93, unix : gen count_norm = count/tot

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/A2.pricesensitivity.do**

- Line 50, unix : gen weight = Npop/Ns
- Line 53, unix : replace weight = weight/base
- Line 56, unix : replace weight=weight/hh
- Line 76, unix : replace inc=inc/100
- Line 78, unix : gen loss=EVSR/inc

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/4.exposure.do**

- Line 24, unix : gen mshr_e = mexp_energy_t_reb/mtot_out_nondurab
- Line 59, unix : forval p = 1/100 {
- Line 65, unix : forval p = 1/100 {
- Line 75, unix : forval p = 1/100 {
- Line 81, unix : forval p = 1/100 {
- Line 92, unix : forval p = 1/100 {
- Line 98, unix : forval p = 1/100 {
- Line 228, unix : gen eq_factor = hhinc_lcfs/hhequivinc
- Line 349, unix : forval q = 1/4 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/0.prepareestimation.do**

- Line 31, unix : forv z=2/10 {
- Line 34, unix : forv z=2/10 {
- Line 38, unix : forv z=2/14 {
- Line 46, unix : forv z=2/12 {
- Line 49, unix : forv x=2/10 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/1.setupWeatherR/metofficedata.R**

- Line 14, unix : source(paste0(projectdir,'Programs/1.setupWeatherR/GetTempAverages.R'))

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Counterfactualpolicy.m**

- Line 189, unix : %Subsidy and pre spending/income specific transfers

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/7.samples.do**

- Line 97, unix : forval y = 2016/2023 {
- Line 184, unix : gen weight_fullsamp = count_norm/count_sample
- Line 193, unix : gen weight_balsamp = count_norm/count_sample

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/5a.appendCSenergy.do**

- Line 31, unix : forval w = 1/52 {
- Line 58, unix : gen shr_likelypp = Nlikely_pp/N
- Line 270, unix : bys id energy_supplier creditdebit (transdate transref): replace share_regularpayments = share_regularpayments/_N
- Line 357, unix : gen shr_multiple = tot_multi_yrmn/tot_yrmn
- Line 362, unix : gen shr_supplier = N_supplier/N_userref
- Line 377, unix : forval t = 2/60 {
- Line 471, unix : gen ratio = smallest/biggest
- Line 528, unix : forval t = 2/60 {
- Line 545, unix : gen shr_chg = tot_chg_idmm/tot_idmm
- Line 588, unix : forval t = 2/60 {
- Line 686, unix : forval t = 2/60 {
- Line 710, unix : gen shr_chg = tot_chg_idmm/tot_idmm
- Line 747, unix : forval t = 2/60 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/A3.incomeoffset.do**

- Line 45, unix : gen weight = Npop/Ns
- Line 48, unix : replace weight = weight/base
- Line 51, unix : replace weight=weight/hh
- Line 55, unix : replace inc=inc/100
- Line 57, unix : gen loss=EVSTe/inc

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Counterfactualpolicy.m**

- Line 191, unix : %Subsidy and pre spending/income specific transfers

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/3.describepricecap.do**

- Line 66, unix : gen pIdx_NI_real = pIdx_NI/cpi_allitems
- Line 68, unix : gen EPGval_real = EPGval/cpi_allitems
- Line 69, unix : gen cap_real = cap/cpi_allitems
- Line 78, unix : gen proportion = CheapestSVT_Basket/min(EnergyPriceCap,EPGval)
- Line 107, unix : gen energyprice_GB_rb = CheapestSVT_Basket/r(mean)
- Line 110, unix : gen energyprice_NI_rb = pIdx_NI/r(mean)
- Line 129, unix : gen ratio_ppdd = EnergyPriceCap_Prepay/EnergyPriceCap
- Line 131, unix : gen ratio_ppdd_reb = ratio_ppdd/r(mean)

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/1.coefficients.do**

- Line 37, unix : forv z =1/10 {
- Line 46, unix : forv z =2/10 {
- Line 66, unix : forv x=0/10 {
- Line 85, unix : forv z = 2/7 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/synthetic_data_generator.do**

- Line 221, unix : forval p = 2/5 {
- Line 763, unix : forval m = 2/12 {
- Line 772, unix : forval m = 2/12 {
- Line 1094, unix : forval m = 1/12 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/8.analysis.do**

- Line 105, unix : gen qidx_energy_reb_tot = exp_energy_t_reb_nosc/pidx_energy_tot_lasp
- Line 106, unix : gen qidx_energy_reb_tot_gb = exp_energy_t_reb_nosc_gb/pidx_energy_tot_lasp_gb
- Line 107, unix : gen qidx_energy_noreb_tot = exp_energy_t_reb_nosc/pidx_energy_tot_lasp
- Line 200, unix : gen ltotexp_nondur = log(tot_out_nondurab_reb/dayspermonth)
- Line 203, unix : gen ltotexp_nondur_noreb = log(tot_out_nondurab_noreb/dayspermonth)
- Line 207, unix : gen log_inc = log(tot_in_excltrans/dayspermonth)
- Line 255, unix : gen tmin2 = tmin^2/10
- Line 256, unix : gen tmin3 = tmin^3/100
- Line 257, unix : gen tmin4 = tmin^4/1000
- Line 258, unix : gen tmin5 = tmin^5/10000
- Line 260, unix : gen tmax2 = tmax^2/10
- Line 261, unix : gen tmax3 = tmax^3/100
- Line 262, unix : gen tmax4 = tmax^4/1000
- Line 263, unix : gen tmax5 = tmax^5/10000
- Line 311, unix : forval year = 2019/2023 {
- Line 312, unix : forval m = 1/12 {
- Line 400, unix : gen mshr_e = mexp_energy_t_reb/mtot_out_nondurab
- Line 614, unix : forval m = 2/12 {
- Line 618, unix : forval m = 2/12 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/incomeadjustment.m**

- Line 49, unix : ,IP(igrp==gc,:),IY(igrp==gc,:),p0(igrp==gc),p1(igrp==gc),p2(igrp==gc),r,wc/tw);

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/1.importenergypricecap.do**

- Line 9, unix : forval i = 1/5 {
- Line 277, unix : gen EPGsubsidy_up_Elec = up_ElecSingle_Other_EPG/up_ElecSingle_Other -1
- Line 278, unix : gen EPGsubsidy_up_Gas =  up_Gas_Other_EPG/up_Gas_Other -1
- Line 282, unix : gen EPGsubsidy_up_Elec_PPM = up_ElecSingle_PPM_EPG/up_ElecSingle_PPM -1
- Line 283, unix : gen EPGsubsidy_up_Gas_PPM =  up_Gas_PPM_EPG/up_Gas_PPM -1

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/6.MPCs.do**

- Line 31, unix : scalar avdayspermonth = 365/12
- Line 208, unix : forval m = 2/12 {
- Line 212, unix : forval m = 2/12 {
- Line 284, unix : forval t = 9/20 {
- Line 310, unix : forval t = 9/20 {
- Line 381, unix : replace reb_val = reb_val/cpi_allitems
- Line 387, unix : replace col_val =col_val/cpi_allitems

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/5.priceresponse.do**

- Line 27, unix : gen inc_apr22= pidx_apr22/pidx_mar22
- Line 82, unix : forval t = 25/60 {
- Line 136, unix : forval t = 25/45 {
- Line 217, unix : gen pIdx_NI_real = (pIdx_NI/100)/cpi_allitems
- Line 570, unix : forval i = 1/25 {
- Line 597, unix : forval i = 1/5 {
- Line 598, unix : forval j = 1/5 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/A5.socialpreferences.do**

- Line 12, unix : replace inc=inc/100
- Line 14, unix : gen loss=EVSR/inc
- Line 84, unix : replace inc=inc/100
- Line 86, unix : gen loss=EVSR/inc
- Line 153, unix : gen loss=EVSR/inc
- Line 159, unix : gen t = (1/inc)
- Line 171, unix : replace inc=inc/1000
- Line 189, unix : replace inc=inc/100
- Line 191, unix : gen t = (1/inc)
- Line 197, unix : gen loss=(EVSR/inc)

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/2.modelfit.do**

- Line 40, unix : gen weight = Npop/Ns
- Line 264, unix : gen weight = Npop/Ns

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/0.setupRawData/0.cpimicrodata.do**

- Line 156, unix : qui replace newindex = newindex/sumweights
- Line 163, unix : qui replace aggnewindex = aggnewindex/sumweights
- Line 193, unix : forval gor = 1/12 {
- Line 237, unix : forval gor = 2/12 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/0.cpi.do**

- Line 29, unix : replace cpi = cpi/r(mean)
- Line 43, unix : replace cpi = cpi/r(mean)
- Line 75, unix : replace cpi_energy= cpi_energy/r(mean)
- Line 108, unix : replace cpi_electricity= cpi_electricity/r(mean)
- Line 140, unix : replace cpi_gas= cpi_gas/r(mean)
- Line 172, unix : replace cpi_food= cpi_food/r(mean)

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/5b.appendCSallspending.do**

- Line 41, unix : gen tag_agg = int(defaulttag/10000)
- Line 258, unix : forvalues y = 2019/2023 {
- Line 265, unix : forvalues c = 1/5 {

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/3.LCFS.do**

- Line 20, unix : for Y in num 1/9: gen tu0kY = agekidY==0
- Line 21, unix : for Y in num 1/9: gen tu1kY = agekidY==1
- Line 22, unix : for Y in num 1/9: gen tu2kY = agekidY==2
- Line 23, unix : for Y in num 1/9: gen tu3kY = agekidY==3
- Line 24, unix : for Y in num 1/9: gen tu4kY = agekidY==4
- Line 25, unix : for Y in num 1/9: gen tu5kY = agekidY==5
- Line 26, unix : for Y in num 1/9: gen tu6kY = agekidY==6
- Line 27, unix : for Y in num 1/9: gen tu7kY = agekidY==7
- Line 28, unix : for Y in num 1/9: gen tu8kY = agekidY==8
- Line 29, unix : for Y in num 1/9: gen tu9kY = agekidY==9
- Line 30, unix : for Y in num 1/9: gen tu10kY = agekidY==10
- Line 31, unix : for Y in num 1/9: gen tu11kY = agekidY==11
- Line 32, unix : for Y in num 1/9: gen tu12kY = agekidY==12
- Line 33, unix : for Y in num 1/9: gen tu13kY = agekidY==13
- Line 34, unix : for Y in num 1/9: gen tu14kY = agekidY==14
- Line 35, unix : for Y in num 1/9: gen tu15kY = agekidY==15
- Line 36, unix : for Y in num 1/9: gen tu16kY = agekidY==16
- Line 37, unix : for Y in num 1/9: gen tu17kY = agekidY==17
- Line 38, unix : for Y in num 1/9: gen tu18kY = agekidY==18
- Line 40, unix : for Z in num 0/18: egen ntukZ = rsum(tuZk1-tuZk9)
- Line 41, unix : for Z in num 0/18: replace ntukZ = 0 if firinbu==0
- Line 43, unix : for Z in num 0/18: egen kZ = sum(ntukZ), by(datayear hhref year)
- Line 98, unix : gen temp = tusumage/N
- Line 100, unix : gen kidage = sumage/numhhkid
- Line 257, unix : recode agehead (min/59 = .) (60/69 = 1) (70/79 = 2) (80/max = 3), gen(terage)
- Line 325, unix : for var  breadcereals- MISC  : qui gen cpiw_X = X/totexp
- Line 425, unix : gen hhequivinc = hhinc/hheqsize
- Line 482, unix : forval year = 2013/2019 {
- Line 493, unix : forval year = 2013/2019 {
- Line 494, unix : forval month = 1/12 {
- Line 509, unix : gen share_gas = exp_gas/exp_energy
- Line 550, unix : gen shrAHC = energy_lcfs/incAHC

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/1.summarystats.do**

- Line 107, unix : forval m = 1/12 {
- Line 230, unix : gen shr_`v'_pop = t1/t2
- Line 536, unix : gen density_`v'_cs = (t1/t2)/${width_cs_`v'}
- Line 552, unix : forval n = 1/99 {
- Line 621, unix : gen density_`v'_lcfs = (t1/t2)/${width_lcfs_`v'}
- Line 639, unix : forval n = 1/100 {
- Line 758, unix : forval year = 2013/2019 {
- Line 769, unix : forval year = 2013/2019 {
- Line 770, unix : forval month = 1/12 {
- Line 780, unix : gen share_gas = exp_gas/exp_energy

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/0.preparesimulation.do**

- Line 23, unix : gen weight = Npop/Ns
- Line 109, unix : gen weight = Npop/Ns
- Line 111, unix : replace inc_t=1/(inc_t/1000)
- Line 112, unix : replace xpre=xpre/100

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/1.observedpolicy.do**

- Line 67, unix : replace weight = weight/base
- Line 70, unix : replace weight=weight/hhw

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/2.counterfactualpolicy.do**

- Line 45, unix : gen weight = Npop/Ns
- Line 48, unix : replace weight = weight/base
- Line 51, unix : replace weight=weight/hh
- Line 75, unix : forv p=700/900 {
- Line 101, unix : forv z=701/900 {
- Line 140, unix : replace inc=inc/100
- Line 142, unix : gen loss=EVSR/inc

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/A1.welfareweights.do**

- Line 18, unix : gen r = AW1/AW2
- Line 31, unix : gen r = AW2/AW1
- Line 40, unix : gen loss=EVSR/inc
- Line 50, unix : replace inc=inc/1000

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/standarderrors.m**

- Line 21, windows : % Sand=(Sand\G')/W;

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/6.insheetweatherprices.do**

- Line 10, unix : forval y = 2018/2023 {
- Line 99, unix : replace pIdx_NI = pIdx_NI/100
- Line 257, unix : gen EPGsubsidy_up_Elec = up_ElecSingle_Other_EPG/up_ElecSingle_Other -1
- Line 258, unix : gen EPGsubsidy_up_Gas =  up_Gas_Other_EPG/up_Gas_Other -1
- Line 442, unix : forval i = 1/5 {
- Line 443, unix : forval j = 1/5 {
- Line 465, unix : forval i = 1/5 {
- Line 466, unix : forval j = 1/5 {
- Line 471, unix : replace pidx_energy_tot_lasp_het = pidx_energy_tot_lasp_het/cpi_allitems

