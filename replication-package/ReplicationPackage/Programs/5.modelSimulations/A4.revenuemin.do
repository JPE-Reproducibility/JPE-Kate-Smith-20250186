

insheet using "$dataAnalysisIn/counterfactualpolicy_appendix.raw",clear

rename v1 R_bar
rename v2 R_Te
rename v3 R_Ty
rename v4 R_Ts
rename v5 R_Tys
rename v6 R_STe
rename v7 R_STy
rename v8 R_STs
rename v9 R_STys
drop v10

foreach v in Te Ty Ts Tys STe STy STs STys {
	replace R_`v'=-100*(R_`v'-R_bar)/R_bar
}

replace R_bar=R_bar*$S

format R_bar %9.2f 
format R_Te R_Ty R_Ts R_Tys R_STe R_STy R_STs R_STys %9.1f

tostring R_bar,gen(R_bar_s) usedisplay force
replace R_bar_s = "\pounds"+R_bar_s+"bn"

foreach v in Te Ty  {
	tostring R_`v',gen(R_`v'_s) usedisplay force
	replace R_`v'_s = R_`v'_s+"\%"
}

foreach v in Ts Tys STe STy STs STys  {
	tostring R_`v',gen(R_`v'_s) usedisplay force
	replace R_`v'_s = "+"+R_`v'_s+"\%"
}

sa "$dataAnalysis/revenuemin.dta",replace
