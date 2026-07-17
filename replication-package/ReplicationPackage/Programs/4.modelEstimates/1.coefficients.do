
insheet using "$dataAnalysisIn/GMMcoefficients.raw",clear

rename v1 coef
rename v2 se
drop v3

gen n = _n

tempfile temp
sa `temp'

u "$dataAnalysis/startingvalues.dta",clear

rename coef coef_sv
rename se   se_sv

gen n = _n

merge 1:1 n using `temp'
drop _m n

gen drop = regexm(title,"tmax")|regexm(title,"tmin")|regexm(title,"rain")|regexm(title,"humid")|regexm(title,"wfh")|regexm(title,"mm")|regexm(title,"ps")|regexm(title,"rg")|regexm(title,"dd")
drop if drop==1
drop drop

gen     cf = "A"  if title=="constant"
replace cf = "B"  if title=="np"
replace cf = "C1" if title=="y1"
replace cf = "C2" if title=="y2"
replace cf = "D"  if title=="ynp"
replace cf = "d"  if title=="r1"

gen     it = "0" if cf!="." & cf!="d"
replace it = "1" if cf=="d"

forv z =1/10 {
	replace cf="A"   if title=="z`z'"
	replace it="`z'" if title=="z`z'"
	replace cf="B"   if title=="npz`z'"
	replace it="`z'" if title=="npz`z'"	
	replace cf="C1"  if title=="y1z`z'"
	replace it="`z'" if title=="y1z`z'"
}

forv z =2/10 {
	replace cf="d"   if title=="r`z'"	
	replace it="`z'" if title=="r`z'"	
}

drop title *_sv
reshape wide coef se,i(cf) j(it) str

gen     var="\multicolumn{2}{l}{Constant}"                          if cf=="A"
replace var="\multicolumn{2}{l}{Price}"                             if cf=="B"
replace var="\multicolumn{2}{l}{Implicit utility}"                  if cf=="C1"
replace var="\multicolumn{2}{l}{Price$\times$ Implicit utility}"    if cf=="D"
replace var="\multicolumn{2}{l}{Flypaper effect}"                   if cf=="d"

replace cf = "C_1"      if cf=="C1"
replace cf = "C_2"      if cf=="C2"
replace cf = "\delta"   if cf=="d"
replace cf = "($"+cf+"$)"
replace cf = cf+"{\color{white}XXXXXXX}" if _n==1

forv x=0/10 {
	format coef`x' se`x' %9.4f

	tostring coef`x',gen(coef`x'_s) usedisplay force
	replace coef`x'_s = "-" if (_n==4|_n==5) & `x'!=0
	
	tostring se`x',gen(se`x'_s) usedisplay force
	replace se`x'_s = "("+se`x'_s+")"
	replace se`x'_s = "" if (_n==4|_n==5) & `x'!=0
}
replace coef0_s = "-" if _n==6
replace se0_s = "" if _n==6



gen o = ""
listtab var o o o o o o o o o using "$resultsdir/coefficients.tex" if _n==1, replace rstyle(tabular)
listtab cf coef0_s coef1_s coef2_s coef3_s coef4_s coef5_s coef6_s coef7_s coef8_s coef9_s coef10_s if _n==1, appendto("$resultsdir/coefficients.tex") replace rstyle(tabular) 
listtab o se0_s se1_s se2_s se3_s se4_s se5_s se6_s se7_s se8_s se9_s se10_s if _n==1, appendto("$resultsdir/coefficients.tex") replace rstyle(tabular)
forv z = 2/7 {
	listtab var o o o o o o o o o if _n==`z', appendto("$resultsdir/coefficients.tex") replace rstyle(tabular) 	
	listtab cf coef0_s coef1_s coef2_s coef3_s coef4_s coef5_s coef6_s coef7_s coef8_s coef9_s coef10_s if _n==`z', appendto("$resultsdir/coefficients.tex") replace rstyle(tabular)
	listtab o se0_s se1_s se2_s se3_s se4_s se5_s se6_s se7_s se8_s se9_s se10_s if _n==`z', appendto("$resultsdir/coefficients.tex") replace rstyle(tabular)	
}


