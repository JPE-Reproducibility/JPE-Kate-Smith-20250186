

u "$dataProcess/CSenergyallspending_step5", clear

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

u "$dataProcess/CSenergyallspending_step5", clear

drop if drop_outliers == 1 | no_het == 1 | tt_toinclude2==0 | no_lagged_income == 1 

drop if sample==3

drop drop_outliers no_het dataset tt_toinclude2 

rename meexp eexp
rename msexp sexp

gen     log_x   = log(tot_out_nondurab_reb_nosc)
replace log_inc = log(tot_in_excltrans)

gen rebatereceived = exp_energy_t_reb - exp_energy_t_noreb
egen max = max(rebater),by(yrmn)
replace rebatereceived = max if rebatereceived==0 & rebates==1
drop max

gen prepay     = sample==1
gen cashrebate = EBSS_everrefund==1

replace rebates = 1 if year==2023 & month==4

rename s_ener_nosc s_ener
rename exp_energy_t_sc fixedfee

egen region = group(ofgem_region)

keep  userref yeartax  year month yrmn eexp eexp_p eexp_dec eexp_quint inc_quint sexp sexp_p sexp_dec sexp_quint inc_taxyr inc_p_taxyr inc_dec_taxyr mtot_out_nondurab_dec tot_out_nondurab_noreb s_ener log_x lprice lpnondur tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 rebates wfh col log_inc rebatereceived age prepay cashrebate fixedfee cpi_all region
order userref yeartax  year month yrmn eexp eexp_p eexp_dec eexp_quint inc_quint sexp sexp_p sexp_dec sexp_quint inc_taxyr inc_p_taxyr inc_dec_taxyr mtot_out_nondurab_dec tot_out_nondurab_noreb s_ener log_x lprice lpnondur tmin tmin2 tmin3 tmin4 tmin5 tmax tmax2 tmax3 tmax4 tmax5 rain humid tminlesstmax2 rebates wfh col log_inc rebatereceived age prepay cashrebate fixedfee cpi_all region

egen id = group(userref)
egen t = group(year month)
 
gen s_cons = 1 - s_ener
rename lprice p_ener  
rename lpnondur p_cons 

order id,before(userref)
order t,after(month)
order s_cons,after(s_ener)

sa "$dataProcess/preestimationdata.dta", replace

