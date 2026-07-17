	
	global dataRaw        "$working/dataInput/dataRaw"
	global dataProcess    "$working/dataOutput/dataProcessed"
	global dataAnalysisIn "$working/dataInput/dataAnalysis"
	global dataAnalysis   "$working/dataOutput/dataAnalysis"
	
	global progsdir "$working/Programs"

	global resultsdir "$working/Results"
	

	confirmdir "$working/dataOutput"
	if `r(confirmdir)'!=0 {
		mkdir "$working/dataOutput"
	}

	confirmdir "$resultsdir"
	if `r(confirmdir)'!=0 {
		mkdir "$resultsdir"
	}	
	
	confirmdir "$dataProcess"
	if `r(confirmdir)'!=0 {
		mkdir "$dataProcess"
	}		
		
	confirmdir "$dataAnalysis"
	if `r(confirmdir)'!=0 {
		mkdir "$dataAnalysis"
	}	
	
	**COMMON GLOBALS
	global pp_shr = 0.15       //prepay share
	global HH   "28.4"         //No. of households
	global S    "6*28.4/1000"  //No. of households*6 months
	global E    "0.059*1.24"   //Marginal carbon externality
	global REPS "100"		   //Bootstrap replications

