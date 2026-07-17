## Potentially Hardcoded Numeric Constants


We found the following set of hard coded numbers. This may be completely legitimate (parameter input, thresholds for computations, etc), and is hence only for information.

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/_GLOBALS.do**

- Line 36, : global E    "0.059*1.24"   //Marginal carbon externality

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/MPCE.m**

- Line 24, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/Counterfactualpolicyincadj.m**

- Line 29, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound
- Line 74, : range=[(0:0.01:0.52) 0.525];

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/0.prepareestimation.do**

- Line 11, : global conv_crit "0.000000001"

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Observedpolicy.m**

- Line 24, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/RevEffect.m**

- Line 17, : % cap=7.74536;
- Line 18, : % psi=0.8395;
- Line 46, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Counterfactualpolicy.m**

- Line 30, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound
- Line 89, : maxss=maxs+0.005;

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Counterfactualpolicy.m**

- Line 30, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound
- Line 89, : %maxss=maxs+0.005;

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Observedpolicy.m**

- Line 24, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/synthetic_data_generator.do**

- Line 39, : local vdd_shr = 0.065  // variable direct debit share (paper: 6.3%)
- Line 84, : replace gor =  1 if u_gor < 0.044                          // North East      4.4%
- Line 85, : replace gor =  2 if u_gor >= 0.044  & u_gor < 0.129        // North West      8.5%
- Line 86, : replace gor =  3 if u_gor >= 0.129  & u_gor < 0.205        // Yorkshire       7.6%
- Line 87, : replace gor =  4 if u_gor >= 0.205  & u_gor < 0.277        // East Midlands   7.2%
- Line 88, : replace gor =  5 if u_gor >= 0.277  & u_gor < 0.363        // West Midlands   8.6%
- Line 89, : replace gor =  6 if u_gor >= 0.363  & u_gor < 0.461        // East            9.8%
- Line 90, : replace gor =  7 if u_gor >= 0.461  & u_gor < 0.617        // London         15.6%
- Line 91, : replace gor =  8 if u_gor >= 0.617  & u_gor < 0.762        // South East     14.5%
- Line 92, : replace gor =  9 if u_gor >= 0.762  & u_gor < 0.850        // South West      8.8%
- Line 93, : replace gor = 10 if u_gor >= 0.850  & u_gor < 0.900        // Wales           5.0%
- Line 94, : replace gor = 11 if u_gor >= 0.900                          // Scotland       10.0%
- Line 311, : gen lpnondur   = log(max(cpi_nondur_excenergy, 0.001))
- Line 327, : ** April 2022 cap rise (45%): Δlog(q) = (0.57-1)*log(1.45) = -0.160,
- Line 328, : ** Δq/q = exp(-0.160)-1 ≈ -14.8%, elasticity = -14.8%/45% ≈ -0.33.
- Line 358, : gen leqnt       = log(max(qidx_energy_reb_tot, 0.0001)   / dayspermonth)
- Line 359, : gen leqnt_noreb = log(max(qidx_energy_noreb_tot, 0.0001)  / dayspermonth)
- Line 360, : gen leqnt_gb    = log(max(qidx_energy_reb_tot_gb, 0.0001) / dayspermonth)
- Line 420, : gen amount_in_savinc    = liquid_assets * 0.002
- Line 1238, : + 0.012 * (inc_dec - 5.5)  / 4.5                    ///  higher income -> higher ratio
- Line 1239, : - 0.008 * (eexp_dec - 5.5) / 4.5                    ///  higher energy share -> lower
- Line 1240, : + 0.004 * (mtot_out_nondurab_dec - 5.5) / 4.5       ///  higher nondur spending -> higher
- Line 1241, : + rnormal(0, 0.005)
- Line 1247, : - 0.010 * (inc_dec - 5.5) / 4.5                     ///
- Line 1248, : + rnormal(0, 0.004)

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/1.importenergypricecap.do**

- Line 280, : gen EPGsubsidy_Energy =  EPGsubsidy_up_Elec*(1-0.4821) + EPGsubsidy_up_Gas*0.4821
- Line 284, : gen EPGsubsidy_Energy_PPM =  EPGsubsidy_up_Elec_PPM*(1-0.4821) + EPGsubsidy_up_Gas_PPM*0.4821

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/3.descriptiveResults/6.MPCs.do**

- Line 472, : lincom 1- ((202210.yrmn#1.everEBSS + 202211.yrmn#1.everEBSS + 202212.yrmn#1.everEBSS + 202301.yrmn#1.everEBSS + 202302.yrmn#1.everEBSS + 202303.yrmn#1.everEBSS + 202304.yrmn#1.everEBSS + 202305.yrmn#1.everEBSS + 202306.yrmn#1.everEBSS + 202307.yrmn#1.everEBSS + 202308.yrmn#1.everEBSS + 202309.yrmn#1.everEBSS + 202310.yrmn#1.everEBSS + 202311.yrmn#1.everEBSS + 202312.yrmn#1.everEBSS)/342.73059);

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Estimate.m**

- Line 26, : if thetahat<theta0-0.099*abs(theta0)
- Line 30, : if thetahat>theta0+0.099*abs(theta0)

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/5b.appendCSallspending.do**

- Line 281, : replace col = 1 if inrange(amount,325.999,326.001) & inrange(transdate,td(14jul2022),td(31jul2022)) & creditdebit==1
- Line 282, : replace col = 1 if inrange(amount,323.999,324.001) & inrange(transdate,td(8nov2022),td(23nov2022)) & creditdebit==1
- Line 283, : replace col = 1 if inrange(amount,300.999,301.001) & inrange(transdate,td(25apr2023),td(17may2023)) & creditdebit==1
- Line 284, : replace col = 1 if inrange(amount,299.999,300.001) & inrange(transdate,td(31oct2023),td(19nov2023)) & creditdebit==1

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/MPCE.m**

- Line 24, : ext=0.059*1.24*mean(exp(pS));     %Externality per pound

**/Users/florianoswald/actions-runner/_work/JPE-Kate-Smith-20250186/JPE-Kate-Smith-20250186/replication-package/ReplicationPackage/Programs/2.setupData/6.insheetweatherprices.do**

- Line 77, : gen pIdx_NI = 106.626			if yrmn == 202101
- Line 78, : replace pIdx_NI = 106.981		if yrmn == 202102
- Line 79, : replace pIdx_NI = 108.009		if yrmn == 202103
- Line 80, : replace pIdx_NI = 110.237		if yrmn == 202104
- Line 81, : replace pIdx_NI = 110.237		if yrmn == 202105
- Line 82, : replace pIdx_NI = 110.237		if yrmn == 202106
- Line 83, : replace pIdx_NI = 115.235		if yrmn == 202107
- Line 85, : replace pIdx_NI = 125.776 		if yrmn == 202109
- Line 86, : replace pIdx_NI = 125.776		if yrmn == 202110
- Line 89, : replace pIdx_NI = 144.218		if yrmn == 202201
- Line 93, : replace pIdx_NI = 165.021		if yrmn == 202205
- Line 94, : replace pIdx_NI = 171.336		if yrmn == 202206

