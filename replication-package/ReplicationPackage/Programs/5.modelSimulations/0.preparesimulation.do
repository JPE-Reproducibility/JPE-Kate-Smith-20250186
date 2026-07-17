
***************************************
**Outsheet for observed policy analysis
***************************************

u "$dataAnalysis/estimationdata.dta",clear

gen temp = p1 if year==2021 & month<10
egen p_cf = mean(temp),by(region)
drop temp

gen temp = fixedfee if year==2021 & month<10
egen fixedfee_cf = mean(temp),by(region)
drop temp

keep if (year==2022 & month>9)|(year==2023 & month<4)

merge m:1 yeartax eexp_dec inc_dec_t prepay using "$dataProcess/population_weights.dta"
drop if _m==2
drop _m

bysort inc_dec_t eexp_dec prepay: gen Ns = _N
gen weight = Npop/Ns

keep  id t x p_e p_co z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 wfh mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm9 mm10 mm11 mm12 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 ddr ddpr r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 p_cf weight rebatere fixedfee fixedfee_cf inc_t
order id t x p_e p_co z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 wfh mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm9 mm10 mm11 mm12 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 ddr ddpr r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 p_cf weight rebatere fixedfee fixedfee_cf inc_t 

sort id t
outsheet using "$dataAnalysis/observedpolicydata.raw",comma non replace

***************************************
**Outsheet for counterfactual analysis
***************************************

insheet using "$dataAnalysis/restrictions.raw",clear

rename v1  id
rename v2  t  
rename v3  s1_hat
rename v4  concavity
rename v5  monotonicity
drop   v6  

keep id t s1_hat

gen n = _n

tempfile temp
sa `temp'

u "$dataAnalysis/estimationdata.dta",clear

gen n = _n

merge 1:1 n using `temp'
drop _m

keep if (year==2021 & month>9)|(year==2022 & month<4)

bysort id: keep if _N>4

gen xpre = s1_hat*exp(x)/exp(p1)

collapse (mean) xpre,by(id)

tempfile temp
sa `temp'

u "$dataAnalysis/estimationdata.dta",clear

gen temp = p1 if year==2021 & month<10
egen p_cf = mean(temp),by(region)
drop temp

gen temp = fixedfee if year==2021 & month<10
egen fixedfee_cf = mean(temp),by(region)
drop temp

keep if (year==2022 & month>9)|(year==2023 & month<4)

bysort id: keep if _N>4

merge m:1 id using  `temp'
keep if _m==3
drop _m

bysort id: gen n = _n
centile inc_t if n==1,centile(0.5 99.5)
drop if inc_t<r(c_1)|inc_t>r(c_2)
drop n

sort id t
by id: gen n=1 if _n==1
sort n eexp_dec inc_dec_t prepay id
set seed 654
drawnorm dr
sort n eexp_dec inc_dec_t prepay dr
by n eexp_dec inc_dec_t prepay: gen temp = 1 if _n<=100 & n==1

egen keep = min(temp),by(id)

keep if keep==1

merge m:1 yeartax eexp_dec inc_dec_t prepay using "$dataProcess/population_weights.dta"
drop if _m==2
drop _m

bysort inc_dec eexp_dec prepay: gen Ns = _N
gen weight = Npop/Ns

replace inc_t=1/(inc_t/1000)
replace xpre=xpre/100
gen xpreinc=xpre*inc_t
sort id t

keep  id t x p_e p_co z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 wfh mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm9 mm10 mm11 mm12 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 ddr ddpr r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 p_cf weight rebatere fixedfee fixedfee_cf inc_t xpre xpreinc inc_p
order id t x p_e p_co z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 ps1 ps2 ps3 ps4 ps5 ps6 ps7 ps8 ps9 tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 wfh mm2 mm3 mm4 mm5 mm6 mm7 mm8 mm9 mm10 mm11 mm12 rg2 rg3 rg4 rg5 rg6 rg7 rg8 rg9 rg10 rg11 rg12 rg13 rg14 ddr ddpr r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 p_cf weight rebatere fixedfee fixedfee_cf inc_t xpre xpreinc inc_p

sort id t
outsheet using "$dataAnalysis/simulationdata.raw",comma non replace
