clear all

global working ".../ReplicationPackage/"
global matlab "C:/Program Files/MATLAB/R2024b/bin/matlab.exe"
global R      "C:/Program Files/R/R-4.4.3/bin/R.exe"
	
cd "$working/Programs"

global synthetic "1"

ssc install confirmdir,replace
ssc install binscatter,replace
ssc install cdfplot,replace
ssc install cleanplots,replace
set scheme cleanplots
ssc install coefplot,replace
ssc install distinct,replace
ssc install estout,replace
ssc install labutil,replace
ssc install listtab,replace
ssc install numdate,replace

do _GLOBALS
cap log close 

version 18

if $synthetic==0 {
// 1. SETUP RAW FILES
	do "0.setupRawData/0.cpimicrodata.do" 
	cd "$progsdir/1.setupWeatherR"
	shell "R" -batch "run('metofficedata.R')"
	cd "$progsdir"	
}

** 2. DATA SETUP
do "2.setupData/0.cpi.do" 						
do "2.setupData/1.importenergypricecap.do" 			
do "2.setupData/2.BEISMacroData.do"   
if $synthetic==0 {
	do "2.setupData/3.LCFS.do"  						
	do "2.setupData/4.weights.do" 		
	do "2.setupData/5a.appendCSenergy.do" 			
	do "2.setupData/5b.appendCSallspending.do"	
}
do "2.setupData/6.insheetweatherprices.do"
if $synthetic==0 {
	do "2.setupData/7.samples.do" 					
	do "2.setupData/8.analysis.do" 			
	do "2.setupData/9.model.do" 	
}

*Generate synthetic data
if $synthetic==1 {
	do "synthetic_data_generator.do"
}

***********************		
** 3. DESCRIPTIVES & DIFFERENCES ESTIMATION
do "3.descriptiveResults/1.summarystats.do" 			
do "3.descriptiveResults/2.macrotrends.do" 			
do "3.descriptiveResults/3.describepricecap.do" 			
do "3.descriptiveResults/4.exposure.do" 			
do "3.descriptiveResults/5.priceresponse.do" 			
do "3.descriptiveResults/6.MPCs.do" 	

** 4. ESTIMATE MODEL
do "4.modelEstimates/0.prepareestimation.do"
shell "$matlab" -batch "cd('$progsdir/4.modelEstimates/Estimation'); run('Run.m')"
do "4.modelEstimates/1.coefficients.do"		
do "4.modelEstimates/2.modelfit.do"		
** 5. POLICY SIMULATIONS
do "5.modelSimulations/0.preparesimulation.do"
if $synthetic==0 {
	cd "$progsdir/5.modelSimulations/Simulations"
	shell "$matlab" -batch "run('Run.m')"
}
if $synthetic==1 {
	cd "$progsdir/5.modelSimulations/SimulationsSynthetic"
	shell "$matlab" -batch "run('Run.m')"
}
***********************
*Runs on model prediction
***********************
cd "$progsdir"
do "5.modelSimulations/1.observedpolicy.do"
do "5.modelSimulations/2.counterfactualpolicy.do"
do "5.modelSimulations/3.observedpolicyCI.do"
do "5.modelSimulations/4.tablesfigures.do"

** (Appendix)
if $synthetic==0 {
	cd "$progsdir/5.modelSimulations/SimulationsSynthetic"
	shell "$matlab" -batch "run('RunAppendix.m')"
	cd "$progsdir"
}
do "5.modelSimulations/A1.welfareweights.do"
global s "1"
do "5.modelSimulations/A2.pricesensitivity.do"
global s "2"
do "5.modelSimulations/A2.pricesensitivity.do"
do "5.modelSimulations/A3.incomeoffset.do"
do "5.modelSimulations/A4.revenuemin.do"
do "5.modelSimulations/A5.socialpreferences.do"
do "5.modelSimulations/A6.tablesfigures.do"