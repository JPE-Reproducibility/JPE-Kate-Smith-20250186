## Appendix: Detailed PII Detection Results

*Generated on 2026-07-17 16:12:34*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Full Summary Table

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `availabletariffs_Ofgem.xlsx` | 1 | son |
| Data | `humidity2018.csv` | 1 | name |
| Data | `humidity2019.csv` | 1 | name |
| Data | `humidity2020.csv` | 1 | name |
| Data | `humidity2021.csv` | 1 | name |
| Data | `humidity2022.csv` | 1 | name |
| Data | `humidity2023.csv` | 1 | name |
| Data | `postcodedistricts2ofgemregions_expanded.csv` | 1 | district |
| Data | `rainfall2018.csv` | 1 | name |
| Data | `rainfall2019.csv` | 1 | name |
| Data | `rainfall2020.csv` | 1 | name |
| Data | `rainfall2021.csv` | 1 | name |
| Data | `rainfall2022.csv` | 1 | name |
| Data | `rainfall2023.csv` | 1 | name |
| Data | `tempav2018.csv` | 1 | name |
| Data | `tempav2019.csv` | 1 | name |
| Data | `tempav2020.csv` | 1 | name |
| Data | `tempav2021.csv` | 1 | name |
| Data | `tempav2022.csv` | 1 | name |
| Data | `tempav2023.csv` | 1 | name |
| Data | `tempmax2018.csv` | 1 | name |
| Data | `tempmax2019.csv` | 1 | name |
| Data | `tempmax2020.csv` | 1 | name |
| Data | `tempmax2021.csv` | 1 | name |
| Data | `tempmax2022.csv` | 1 | name |
| Data | `tempmax2023.csv` | 1 | name |
| Data | `tempmin2018.csv` | 1 | name |
| Data | `tempmin2019.csv` | 1 | name |
| Data | `tempmin2020.csv` | 1 | name |
| Data | `tempmin2021.csv` | 1 | name |
| Data | `tempmin2022.csv` | 1 | name |
| Data | `tempmin2023.csv` | 1 | name |
| Data | `ukpopestimatesmid2021on2021geographyfinal.xls` | 1 | lat |
| Code | `0.cpi.do` | 81 | name, lat, city |
| Code | `0.cpimicrodata.do` | 37 | loc, son, lat, lon |
| Code | `0.prepareestimation.do` | 8 | loc, sex, lat, name |
| Code | `0.preparesimulation.do` | 5 | name, city |
| Code | `1.coefficients.do` | 4 | name |
| Code | `1.importenergypricecap.do` | 41 | loc, name, lon, second |
| Code | `1.observedpolicy.do` | 24 | lat, name |
| Code | `1.summarystats.do` | 30 | house, loc, son, sex, lat, name, lon |
| Code | `2.BEISMacroData.do` | 5 | loc, name |
| Code | `2.counterfactualpolicy.do` | 32 | name, social, loc |
| Code | `2.macrotrends.do` | 7 | son, sex, city, name |
| Code | `2.modelfit.do` | 43 | name, city |
| Code | `3.LCFS.do` | 45 | son, sex, lon, dob, house, mother, name, child, city, phone |
| Code | `3.describepricecap.do` | 21 | name, loc, lat |
| Code | `3.observedpolicyCI.do` | 19 | name |
| Code | `4.exposure.do` | 23 | child, lat, sex, son, house |
| Code | `4.tablesfigures.do` | 3 | house, lon |
| Code | `4.weights.do` | 3 | loc, lon |
| Code | `5.priceresponse.do` | 23 | lat, loc, son, city, name, lon |
| Code | `5a.appendCSenergy.do` | 5 | lat, city, name |
| Code | `5b.appendCSallspending.do` | 42 | loc, lat, child, son, phone |
| Code | `6.MPCs.do` | 68 | name, loc, lname, son |
| Code | `6.insheetweatherprices.do` | 24 | lon, city, loc, name, district, son, lname |
| Code | `7.samples.do` | 13 | lon, loc, name, dob, lat |
| Code | `8.analysis.do` | 29 | district, lon, country, name, loc, child, sex, son |
| Code | `9.model.do` | 11 | loc, lat, name, sex |
| Code | `A1.welfareweights.do` | 6 | loc |
| Code | `A2.pricesensitivity.do` | 27 | name, loc |
| Code | `A3.incomeoffset.do` | 16 | name, loc |
| Code | `A4.revenuemin.do` | 9 | name |
| Code | `A5.socialpreferences.do` | 14 | loc, social |
| Code | `A6.tablesfigures.do` | 13 | lon, social, loc, lat |
| Code | `Counterfactualpolicy.m` | 2 | name |
| Code | `Counterfactualpolicy.m` | 2 | name |
| Code | `Counterfactualpolicyincadj.m` | 2 | name |
| Code | `EngelCurves.m` | 1 | name |
| Code | `Estimate.m` | 5 | name, dob |
| Code | `GMM.m` | 4 | lon |
| Code | `GetTempAverages.R` | 4 | name |
| Code | `Holdout.m` | 3 | name |
| Code | `MPCE.m` | 1 | name |
| Code | `MPCE.m` | 1 | name |
| Code | `Observedpolicy.m` | 3 | name |
| Code | `Observedpolicy.m` | 3 | name |
| Code | `Priceeffects.m` | 1 | name |
| Code | `Restrictions.m` | 3 | name, city |
| Code | `RevEffect.m` | 7 | name, house, loc, lat |
| Code | `Run.m` | 29 | name, city |
| Code | `Run.m` | 7 | name, lat |
| Code | `Run.m` | 7 | name, lat |
| Code | `RunAppendix.m` | 11 | lat, name |
| Code | `_GLOBALS.do` | 2 | house |
| Code | `dataprepare.m` | 19 | name, lat |
| Code | `dataprepare.m` | 19 | name, lat |
| Code | `dataprepareestimate.m` | 16 | name, lat |
| Code | `firstbest.m` | 1 | lat |
| Code | `firstbest.m` | 1 | lat |
| Code | `master.do` | 16 | lat, social |
| Code | `metofficedata.R` | 1 | lon |
| Code | `momder.m` | 4 | lon |
| Code | `sensitivityanalysis.m` | 2 | city |
| Code | `synthetic_data_generator.do` | 97 | house, minute, loc, lon, city, lat, sex, district, name, birth, dob, son, child, phone, mother |

### Data Files

**/replication-package/ReplicationPackage/dataInput/dataRaw/downloaded/availabletariffs_Ofgem.xlsx**

- Variable: `Retail price comparison by company and tariff type: Domestic (GB)`
  - Matched terms: son
  - Sample values: 2012-01-28T00:00:00, 2012-02-28T00:00:00, 2012-03-28T00:00:00

**/replication-package/ReplicationPackage/dataInput/dataRaw/downloaded/postcodedistricts2ofgemregions_expanded.csv**

- Variable: `postcode_district`
  - Matched terms: district
  - Sample values: AB 10, AB 11, AB 12

**/replication-package/ReplicationPackage/dataInput/dataRaw/downloaded/ukpopestimatesmid2021on2021geographyfinal.xls**

- Variable: `Mid-Year Population Estimates, UK, June 2021`
  - Matched terms: lat
  - Sample values: This spreadsheet contains a selection of the data tables published alongside the Office for National Statistics' Mid-Year Population Estimates June 2021., Mid-Year Population Estimates, UK, June 2021, Publication dates

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2018.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2019.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2020.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2021.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2022.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/humidity2023.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2018.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2019.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2020.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2021.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2022.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/rainfall2023.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2018.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2019.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2020.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2021.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2022.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempav2023.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2018.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2019.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2020.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2021.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2022.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmax2023.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2018.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2019.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2020.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2021.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2022.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

**/replication-package/ReplicationPackage/dataInput/dataRaw/tempmin2023.csv**

- Variable: `name`
  - Matched terms: name
  - Sample values: Newham 035D, Horsham 002D, Tendring 002C

### Code Files

**/replication-package/ReplicationPackage/Programs/0.setupRawData/0.cpimicrodata.do**

- Line 30: loc
  ```
  di in red "Warning: key items (local authority rents in E&W and NI) are missing for rental index"
  ```
- Line 56: loc
  ```
  local region gor_region
  ```
- Line 57: loc
  ```
  local regioncondminus1 "& gor_region==gor_region[_n-1]"
  ```
- Line 58: loc
  ```
  local regioncondminus12 "& gor_region==gor_region[_n-12]"
  ```
- Line 59: loc
  ```
  local regioncondminus13 "& gor_region==gor_region[_n-13]"
  ```
- Line 69: loc, son
  ```
  local startyearminusone = `startyear' - 1
  ```
- Line 71: loc
  ```
  local numberofcoicopcodes= wordcount("`coicopindex'")
  ```
- Line 74: loc
  ```
  local thiscoicopindex = word("`coicopindex'",`i')
  ```
- Line 76: loc
  ```
  local dppos = strpos("`thiscoicopindex'",".")
  ```
- Line 77: loc
  ```
  local afterdp = substr("`thiscoicopindex'",`dppos',.)
  ```
- Line 78: loc
  ```
  local afterdp = subinstr("`afterdp'",".","",.)
  ```
- Line 80: loc
  ```
  local ndigit`i' = 2
  ```
- Line 83: loc
  ```
  local ndigit`i' = strlen("`afterdp'") + 2
  ```
- Line 86: loc
  ```
  local ndigitlist "`ndigit`i''"
  ```
- Line 89: loc
  ```
  local ndigitlist "`ndigitlist',`ndigit`i''"
  ```
- Line 94: loc
  ```
  local minndigitlist = min(`ndigitlist')
  ```
- Line 95: loc
  ```
  local maxndigitlist = max(`ndigitlist')
  ```
- Line 104: loc
  ```
  local minndigitlist =`ndigit1'
  ```
- Line 105: loc
  ```
  local maxndigitlist =`ndigit1'
  ```
- Line 108: lat
  ```
  ***** If year < 2018 calculate indices at 4 digit COICOP level first ******
  ```
- Line 165: son
  ```
  qui keep if inrange(year,`startyearminusone',`endyear')
  ```
- Line 175: lat
  ```
  *We have duplicated 2017 to calculate item indices within 5 digit COICOP codes. Here divide Jan 2017
  ```
- Line 197: loc
  ```
  local lastjanvalue = r(mean)
  ```
- Line 199: loc
  ```
  local lastdecvalue = r(mean)
  ```
- Line 201: loc
  ```
  local lastjanchainvalue = `lastjanvalue'
  ```
- Line 202: loc
  ```
  local lastdecchainvalue = `lastdecvalue'
  ```
- Line 211: lat
  ```
  *chain relative to previous january
  ```
- Line 219: loc
  ```
  local lastjanchainvalue = r(mean)
  ```
- Line 222: loc
  ```
  local lastdecchainvalue = r(mean)
  ```
- Line 252: lon
  ```
  legend(order(1 "London" 2 "SE" 3 "SW" 4 "East Anglia" 5 "East Midlands" 6 "West Midlands" 7 "Yorks &
  ```
- Line 262: loc
  ```
  local lastjanvalue = r(mean)
  ```
- Line 264: loc
  ```
  local lastdecvalue = r(mean)
  ```
- Line 266: loc
  ```
  local lastjanchainvalue = `lastjanvalue'
  ```
- Line 267: loc
  ```
  local lastdecchainvalue = `lastdecvalue'
  ```
- Line 276: lat
  ```
  *chain relative to previous january
  ```
- Line 284: loc
  ```
  local lastjanchainvalue = r(mean)
  ```
- Line 287: loc
  ```
  local lastdecchainvalue = r(mean)
  ```

**/replication-package/ReplicationPackage/Programs/1.setupWeatherR/GetTempAverages.R**

- Line 16: name
  ```
  # rename months if 12 layers
  ```
- Line 17: name
  ```
  lyr_cols <- setdiff(names(temp_means), "ID")
  ```
- Line 19: name
  ```
  names(temp_means)[match(lyr_cols, names(temp_means))] <-
  ```
- Line 25: name
  ```
  write.csv(out_df, file = savefile, row.names = FALSE)
  ```

**/replication-package/ReplicationPackage/Programs/1.setupWeatherR/metofficedata.R**

- Line 35: lon
  ```
  for (i in seq_along(variables)) {
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/0.cpi.do**

- Line 6: name
  ```
  rename Value cpi
  ```
- Line 8: name
  ```
  gen monthname = substr(Period,6,3)
  ```
- Line 12: name
  ```
  keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OC
  ```
- Line 14: name
  ```
  gen month = 1 if monthname=="JAN"
  ```
- Line 15: name
  ```
  replace month = 2 if monthname=="FEB"
  ```
- Line 16: name
  ```
  replace month = 3 if monthname=="MAR"
  ```
- Line 17: name
  ```
  replace month = 4 if monthname=="APR"
  ```
- Line 18: name
  ```
  replace month = 5 if monthname=="MAY"
  ```
- Line 19: name
  ```
  replace month = 6 if monthname=="JUN"
  ```
- Line 20: name
  ```
  replace month = 7 if monthname=="JUL"
  ```
- Line 21: name
  ```
  replace month = 8 if monthname=="AUG"
  ```
- Line 22: name
  ```
  replace month = 9 if monthname=="SEP"
  ```
- Line 23: name
  ```
  replace month = 10 if monthname=="OCT"
  ```
- Line 24: name
  ```
  replace month = 11 if monthname=="NOV"
  ```
- Line 25: name
  ```
  replace month = 12 if monthname=="DEC"
  ```
- Line 34: lat
  ```
  ** make annual cpi for deflating USoc (which is average spending over the last year)
  ```
- Line 41: name
  ```
  rename Value cpi
  ```
- Line 52: name
  ```
  rename Value cpi_energy
  ```
- Line 54: name
  ```
  gen monthname = substr(Period,6,3)
  ```
- Line 58: name
  ```
  keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OC
  ```
- Line 60: name
  ```
  gen month = 1 if monthname=="JAN"
  ```
- Line 61: name
  ```
  replace month = 2 if monthname=="FEB"
  ```
- Line 62: name
  ```
  replace month = 3 if monthname=="MAR"
  ```
- Line 63: name
  ```
  replace month = 4 if monthname=="APR"
  ```
- Line 64: name
  ```
  replace month = 5 if monthname=="MAY"
  ```
- Line 65: name
  ```
  replace month = 6 if monthname=="JUN"
  ```
- Line 66: name
  ```
  replace month = 7 if monthname=="JUL"
  ```
- Line 67: name
  ```
  replace month = 8 if monthname=="AUG"
  ```
- Line 68: name
  ```
  replace month = 9 if monthname=="SEP"
  ```
- Line 69: name
  ```
  replace month = 10 if monthname=="OCT"
  ```
- Line 70: name
  ```
  replace month = 11 if monthname=="NOV"
  ```
- Line 71: name
  ```
  replace month = 12 if monthname=="DEC"
  ```
- Line 85: city, name
  ```
  rename Value cpi_electricity
  ```
- Line 87: name
  ```
  gen monthname = substr(Period,6,3)
  ```
- Line 91: name
  ```
  keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OC
  ```
- Line 93: name
  ```
  gen month = 1 if monthname=="JAN"
  ```
- Line 94: name
  ```
  replace month = 2 if monthname=="FEB"
  ```
- Line 95: name
  ```
  replace month = 3 if monthname=="MAR"
  ```
- Line 96: name
  ```
  replace month = 4 if monthname=="APR"
  ```
- Line 97: name
  ```
  replace month = 5 if monthname=="MAY"
  ```
- Line 98: name
  ```
  replace month = 6 if monthname=="JUN"
  ```
- Line 99: name
  ```
  replace month = 7 if monthname=="JUL"
  ```
- Line 100: name
  ```
  replace month = 8 if monthname=="AUG"
  ```
- Line 101: name
  ```
  replace month = 9 if monthname=="SEP"
  ```
- Line 102: name
  ```
  replace month = 10 if monthname=="OCT"
  ```
- Line 103: name
  ```
  replace month = 11 if monthname=="NOV"
  ```
- Line 104: name
  ```
  replace month = 12 if monthname=="DEC"
  ```
- Line 107: city
  ```
  su cpi_electricity if year==2022 & month==12
  ```
- Line 108: city
  ```
  replace cpi_electricity= cpi_electricity/r(mean)
  ```
- Line 117: name
  ```
  rename Value cpi_gas
  ```
- Line 119: name
  ```
  gen monthname = substr(Period,6,3)
  ```
- Line 123: name
  ```
  keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OC
  ```
- Line 125: name
  ```
  gen month = 1 if monthname=="JAN"
  ```
- Line 126: name
  ```
  replace month = 2 if monthname=="FEB"
  ```
- Line 127: name
  ```
  replace month = 3 if monthname=="MAR"
  ```
- Line 128: name
  ```
  replace month = 4 if monthname=="APR"
  ```
- Line 129: name
  ```
  replace month = 5 if monthname=="MAY"
  ```
- Line 130: name
  ```
  replace month = 6 if monthname=="JUN"
  ```
- Line 131: name
  ```
  replace month = 7 if monthname=="JUL"
  ```
- Line 132: name
  ```
  replace month = 8 if monthname=="AUG"
  ```
- Line 133: name
  ```
  replace month = 9 if monthname=="SEP"
  ```
- Line 134: name
  ```
  replace month = 10 if monthname=="OCT"
  ```
- Line 135: name
  ```
  replace month = 11 if monthname=="NOV"
  ```
- Line 136: name
  ```
  replace month = 12 if monthname=="DEC"
  ```
- Line 149: name
  ```
  rename Value cpi_food
  ```
- Line 151: name
  ```
  gen monthname = substr(Period,6,3)
  ```
- Line 155: name
  ```
  keep if inlist(monthname,"JAN","FEB","MAR","APR","MAY","JUN")|inlist(monthname,"JUL","AUG","SEP","OC
  ```
- Line 157: name
  ```
  gen month = 1 if monthname=="JAN"
  ```
- Line 158: name
  ```
  replace month = 2 if monthname=="FEB"
  ```
- Line 159: name
  ```
  replace month = 3 if monthname=="MAR"
  ```
- Line 160: name
  ```
  replace month = 4 if monthname=="APR"
  ```
- Line 161: name
  ```
  replace month = 5 if monthname=="MAY"
  ```
- Line 162: name
  ```
  replace month = 6 if monthname=="JUN"
  ```
- Line 163: name
  ```
  replace month = 7 if monthname=="JUL"
  ```
- Line 164: name
  ```
  replace month = 8 if monthname=="AUG"
  ```
- Line 165: name
  ```
  replace month = 9 if monthname=="SEP"
  ```
- Line 166: name
  ```
  replace month = 10 if monthname=="OCT"
  ```
- Line 167: name
  ```
  replace month = 11 if monthname=="NOV"
  ```
- Line 168: name
  ```
  replace month = 12 if monthname=="DEC"
  ```
- Line 179: name
  ```
  order Period year month monthname cpi cpi_*
  ```
- Line 186: name
  ```
  rename chainedindex cpi_nondur_excenergy
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/1.importenergypricecap.do**

- Line 11: loc
  ```
  if `i'==1 local sheet "Oct - Dec"
  ```
- Line 12: loc
  ```
  if `i'==2 local sheet "Jan - Mar"
  ```
- Line 13: loc
  ```
  if `i'==3 local sheet "Apr - Jun"
  ```
- Line 14: loc
  ```
  if `i'==4 local sheet "Jul - Sep"
  ```
- Line 15: loc
  ```
  if `i'==5 local sheet "Oct 23 - Dec 23"
  ```
- Line 22: name
  ```
  rename `var' `var'_EPG
  ```
- Line 79: name
  ```
  rename CreditAveragevariableunitpr ElecSingle_SC_unitprice
  ```
- Line 80: name
  ```
  rename CreditAveragefixedcostye ElecSingle_SC_standingcharge
  ```
- Line 81: name
  ```
  rename DirectdebitAveragevariableu ElecSingle_Other_unitprice
  ```
- Line 82: name
  ```
  rename DirectdebitAveragefixedcost ElecSingle_Other_standingcharge
  ```
- Line 83: name
  ```
  rename PrepaymentAveragevariableuni ElecSingle_PPM_unitprice
  ```
- Line 84: name
  ```
  rename PrepaymentAveragefixedcost ElecSingle_PPM_standingcharge
  ```
- Line 85: name
  ```
  rename OverallAveragevariableunitp ElecSingle_All_unitprice
  ```
- Line 86: name
  ```
  rename OverallAveragefixedcosty ElecSingle_All_standingcharge
  ```
- Line 88: name
  ```
  rename Year year
  ```
- Line 89: name
  ```
  rename RegionNote1 region
  ```
- Line 99: name
  ```
  rename CreditAveragevariableunitpr Gas_SC_unitprice
  ```
- Line 100: name
  ```
  rename CreditAveragefixedcostye Gas_SC_standingcharge
  ```
- Line 101: name
  ```
  rename DirectdebitAveragevariableu Gas_Other_unitprice
  ```
- Line 102: name
  ```
  rename DirectdebitAveragefixedcost Gas_Other_standingcharge
  ```
- Line 103: name
  ```
  rename PrepaymentAveragevariableuni Gas_PPM_unitprice
  ```
- Line 104: name
  ```
  rename PrepaymentAveragefixedcost Gas_PPM_standingcharge
  ```
- Line 105: name
  ```
  rename OverallAveragevariableunitp Gas_All_unitprice
  ```
- Line 106: name
  ```
  rename OverallAveragefixedcosty Gas_All_standingcharge
  ```
- Line 108: name
  ```
  rename Year year
  ```
- Line 109: name
  ```
  rename LDZarea region
  ```
- Line 123: name
  ```
  rename B Category
  ```
- Line 126: name
  ```
  rename D region
  ```
- Line 131: loc
  ```
  local i = 0
  ```
- Line 133: loc
  ```
  local ++i
  ```
- Line 135: loc
  ```
  local l`i' : variable label `var'
  ```
- Line 136: name
  ```
  rename `var' stub`i'
  ```
- Line 139: lon
  ```
  reshape long stub, i(region) j(j)
  ```
- Line 145: name
  ```
  rename stub `sheet'
  ```
- Line 190: second
  ```
  gen secondperiod = substr(period,endyearstring,.)
  ```
- Line 191: second
  ```
  gen startyearstring2 = strpos(secondperiod,"2")
  ```
- Line 193: second
  ```
  gen endyear = substr(secondperiod,startyearstring2,4)
  ```
- Line 194: second
  ```
  gen endsecondmonthstring = startyearstring2 -1
  ```
- Line 195: second
  ```
  gen endmonth = substr(secondperiod,1,endsecondmonthstring)
  ```
- Line 203: second
  ```
  drop startyearstring endyearstring endfirstmonthstring startyearstring2 endyearstring2 secondperiod 
  ```
- Line 205: name
  ```
  rename j capperiodno
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/2.BEISMacroData.do**

- Line 8: loc
  ```
  local i = 1
  ```
- Line 31: name
  ```
  if "`v'" == "IDEF" rename Value `x'_defl_`z'
  ```
- Line 32: name
  ```
  if "`v'" == "CVM" rename Value `x'_vol_`z'
  ```
- Line 33: name
  ```
  if "`v'" == "CP" rename Value `x'_exp_`z'
  ```
- Line 40: loc
  ```
  local i = `i'+1
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/3.LCFS.do**

- Line 6: son
  ```
  global startyearplusone = $startyear + 1
  ```
- Line 59: son
  ```
  forvalues i = $startyearplusone / $endyear {
  ```
- Line 71: sex
  ```
  keep hhref datayear year week goregion numadmal numadfem numadRet numadern numhhkid kids0 - kids1718
  ```
- Line 75: lon
  ```
  label define newregion 1 "North" 2 "Yorks + Humbs" 3 "E. Mids" 4 "W. Mids" 5 "S. East + E. Ang" 6 "G
  ```
- Line 79: dob
  ```
  gen dob         = year - age
  ```
- Line 80: dob
  ```
  gen yrlefted    = dob + ageced
  ```
- Line 85: dob
  ```
  drop dob yrlefted alev coll csl ageced
  ```
- Line 92: sex
  ```
  replace temp = ((age>=60 & sex==2)|(age>=65 & sex==1))*(reltohoh==0)
  ```
- Line 127: lon
  ```
  gen lone    = lfamtype==2|lfamtype==4
  ```
- Line 140: sex
  ```
  gen male = sex==1
  ```
- Line 142: house
  ```
  *PENSIONER HOUSEHOLD TYPES
  ```
- Line 143: sex
  ```
  gen pens = ((age>=60 & sex==2)|(age>=65 & sex==1))
  ```
- Line 152: sex
  ```
  gen pensingm = pens==1 & sex==1 & lfamtype==1
  ```
- Line 153: sex
  ```
  gen pensingf = pens==1 & sex==2 & lfamtype==1
  ```
- Line 158: sex
  ```
  gen oldestawoman_temp = age==age_oldest & sex==2
  ```
- Line 163: mother
  ```
  gen famother = lfamtype~=1 & lfamtype ~=5
  ```
- Line 164: sex
  ```
  gen famsingm = sex==1 & lfamtype==1
  ```
- Line 165: sex
  ```
  gen famsingf = sex==2 & lfamtype==1
  ```
- Line 172: house
  ```
  label var penhh    "Pensioner Household"
  ```
- Line 181: mother
  ```
  label var famother "Family Type Other"
  ```
- Line 184: mother
  ```
  replace famtype=1 if famother==1
  ```
- Line 193: sex
  ```
  replace newfam=1 if lfamtype==1 & sex==1
  ```
- Line 194: sex
  ```
  replace newfam=2 if lfamtype==1 & sex==2
  ```
- Line 205: lon
  ```
  label define newfam 1 "Single Male" 2 "Single Female" 3 "Lone Parent" 4 "Couple, no kids"
  ```
- Line 280: son
  ```
  forval X = $startyearplusone / $endyear {
  ```
- Line 298: name
  ```
  rename * ads*
  ```
- Line 299: name
  ```
  rename adshhref hhref
  ```
- Line 300: name
  ```
  rename adsdatayear datayear
  ```
- Line 301: name
  ```
  rename adsyear year
  ```
- Line 320: son
  ```
  forval X =  $startyearplusone / $endyear {
  ```
- Line 329: name
  ```
  for var  breadcereals- MISC  : rename X cpix_X
  ```
- Line 332: name
  ```
  rename totexp cpi_totexp
  ```
- Line 344: name
  ```
  rename totexp rpi_totexp
  ```
- Line 345: name
  ```
  rename FUEL_LIG rpi_FUEL_LIG
  ```
- Line 351: son
  ```
  forval X =  $startyearplusone / $endyear {
  ```
- Line 381: son
  ```
  forval X = $startyearplusone / $endyear {
  ```
- Line 434: child
  ```
  gen exp_childcare	= cpix_EDUCATION
  ```
- Line 436: city
  ```
  gen exp_elec 		= cpix_electricity
  ```
- Line 439: city
  ```
  gen exp_energy 		= cpix_electricity+ cpix_gas
  ```
- Line 443: son
  ```
  gen exp_personal 	= cpix_MEDICAL+cpix_PERSCARE
  ```
- Line 444: phone
  ```
  gen exp_phonetv 	= cpix_PHONE + tvlicen
  ```
- Line 448: child, phone, son
  ```
  gen nondurables_lcfs = exp_childcare + exp_discret + exp_energy + exp_fuel + exp_grocery + exp_othbi
  ```
- Line 462: name
  ```
  drop Period monthname
  ```
- Line 491: son
  ```
  *do within month to account for seasonal effects
  ```
- Line 505: house
  ```
  *Ask households to consult combined statements
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/4.weights.do**

- Line 68: loc
  ```
  local z = 0
  ```
- Line 71: loc
  ```
  local z = `z'+1
  ```
- Line 74: lon
  ```
  reshape long count, i(Code) j(age)
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/5a.appendCSenergy.do**

- Line 88: lat
  ```
  **Step 1: isolate energy spending.
  ```
- Line 113: city
  ```
  **keep gas and electricity tag
  ```
- Line 161: name
  ```
  **some payments are for boiler insurance etc. or for arenas named after energy companies
  ```
- Line 178: city
  ```
  **look by periodicity and month
  ```
- Line 234: city
  ```
  **use periodicity in payments to further eliminate direct debits
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/5b.appendCSallspending.do**

- Line 11: loc
  ```
  local numbatches = 4
  ```
- Line 12: loc
  ```
  local batchsize = int(130/`numbatches')
  ```
- Line 14: loc
  ```
  local batchsize`b' = `batchsize'
  ```
- Line 16: loc
  ```
  local batchsize`numbatches' = `batchsize`numbatches'' + (130 - `batchsize'*`numbatches')
  ```
- Line 20: loc
  ```
  local u = 0
  ```
- Line 26: loc
  ```
  local u = `u' + `batchsize`b2''
  ```
- Line 33: loc
  ```
  local u = `u'+1
  ```
- Line 84: lat
  ```
  gen bnpl = (merchant == 244 | merchant == 613 )  //buy now pay later: clearpay; klarna
  ```
- Line 90: child
  ```
  replace exp_cat = "_out_childcare" 	if exp_cat=="" & ((defaulttag >= 130100 & defaulttag <=130303 ))
  ```
- Line 91: son
  ```
  replace exp_cat = "_out_personal" 	if exp_cat=="" & (defaulttag >= 100300 & defaulttag <= 100500  ) 
  ```
- Line 97: phone
  ```
  replace exp_cat = "_out_phonetv"  	if exp_cat=="" & ((defaulttag >= 110600 & defaulttag <=110700 ) |
  ```
- Line 107: lat
  ```
  replace exp_cat = "_out_bnpl" 		if exp_cat=="" &  bnpl == 1  //buy now pay later: clearpay; klarna
  ```
- Line 140: child
  ```
  | exp_cat == "_out_childcare"
  ```
- Line 142: son
  ```
  | exp_cat == "_out_personal"
  ```
- Line 143: phone
  ```
  | exp_cat == "_out_phonetv"
  ```
- Line 235: child
  ```
  gen children = benefit == 15 | ((defaulttag >= 130100 & defaulttag <=130303 ))
  ```
- Line 239: child
  ```
  ** Declare first child amounts
  ```
- Line 240: loc
  ```
  local cbfc_2019 = 20.70
  ```
- Line 241: loc
  ```
  local cbfc_2020 = 21.05
  ```
- Line 242: loc
  ```
  local cbfc_2021 = 21.15
  ```
- Line 243: loc
  ```
  local cbfc_2022 = 21.80
  ```
- Line 244: loc
  ```
  local cbfc_2023 = 24.00
  ```
- Line 246: child
  ```
  ** Declare subsequent children amounts
  ```
- Line 247: loc
  ```
  local cbsc_2019 = 13.70
  ```
- Line 248: loc
  ```
  local cbsc_2020 = 13.95
  ```
- Line 249: loc
  ```
  local cbsc_2021 = 14.00
  ```
- Line 250: loc
  ```
  local cbsc_2022 = 14.45
  ```
- Line 251: loc
  ```
  local cbsc_2023 = 15.90
  ```
- Line 253: child
  ```
  ** Create number of children variable
  ```
- Line 257: lat
  ```
  ** Populate variable
  ```
- Line 264: child
  ```
  ** Code currently looks for up to 6 children
  ```
- Line 267: loc
  ```
  local refamount = `cbfc_`y'' + (`c'*`cbsc_`y'')
  ```
- Line 271: loc
  ```
  local refamount = `refamount'*4
  ```
- Line 279: lat
  ```
  **later payments in 2023 might be harder to identify as closer to a round number (£300
  ```
- Line 300: child
  ```
  collapse (sum) amount_updated (mean) n_accounts payday_in payday_out anyloan_in anyloan_out onbenefi
  ```
- Line 305: child
  ```
  foreach v of var   tot_in* tot_out* payday_in payday_out anyloan_in anyloan_out onbenefits numchld c
  ```
- Line 316: child
  ```
  order userref year $time_vars n_accounts payday_in payday_out anyloan_in anyloan_out onbenefits disa
  ```
- Line 329: child
  ```
  label var children 		"=1 if children present"
  ```
- Line 353: child
  ```
  label var amount_out_childcare  "Amount flowing out: childcare"
  ```
- Line 361: son
  ```
  label var amount_out_personal  	"Amount flowing out: personal services"
  ```
- Line 362: phone
  ```
  label var amount_out_phonetv  	"Amount flowing out: phone and TV"
  ```
- Line 371: lat
  ```
  label var amount_out_bnpl		"Amount flowing out: buy now pay later"
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/6.insheetweatherprices.do**

- Line 31: lon
  ```
  reshape long m@, i(lsoa) j(month)
  ```
- Line 70: city
  ```
  **it is the electricity & gas composite price series
  ```
- Line 116: loc
  ```
  local fixedweight = r(mean)
  ```
- Line 119: loc
  ```
  local fixedweight = .4251503
  ```
- Line 149: name
  ```
  rename A date
  ```
- Line 171: district
  ```
  bys ofgem_region postcode_district: keep if _n==1
  ```
- Line 172: lon
  ```
  *in two ofgem regions - put in London
  ```
- Line 173: district
  ```
  drop if ofgem_region=="East England" & postcode_district=="N 8"
  ```
- Line 174: district
  ```
  replace postcode_district = subinstr(postcode_district," ","",.)
  ```
- Line 176: district
  ```
  sa "$dataProcess/postcodedistricts2ofgemregions_expanded", replace
  ```
- Line 183: name
  ```
  rename region ofgem_region
  ```
- Line 206: name
  ```
  rename region ofgem_region
  ```
- Line 232: name
  ```
  rename region ofgem_region
  ```
- Line 272: lon
  ```
  bys year month: replace ofgem_region = "London" if _n==3
  ```
- Line 316: city
  ```
  ren cpi_electricity cpi_elec
  ```
- Line 389: son
  ```
  bys ofgem_region (yrmn): gen qtminusone_`var' = smoothDomestic_`var'_sa[_n-1]
  ```
- Line 390: son
  ```
  bys ofgem_region (yrmn): gen ptminusone_`var' = mp_`var'[_n-1]
  ```
- Line 394: son
  ```
  bys ofgem_region (yrmn): replace pidx_energy_tot_altlasp_chain = pidx_energy_tot_altlasp_chain[_n-1]
  ```
- Line 398: son
  ```
  bys ofgem_region (yrmn): replace pidx_energy_tot_paasche_chain = pidx_energy_tot_paasche_chain[_n-1]
  ```
- Line 402: son
  ```
  bys ofgem_region (yrmn): replace pidx_energy_tot_fisher_chain = pidx_energy_tot_fisher_chain[_n-1]*(
  ```
- Line 409: loc
  ```
  local lbl : variable label `v'
  ```
- Line 414: son
  ```
  drop p0* q0* smoothDomestic_gas_sa smoothDomestic_elec_sa  qtminusone* ptminusone*
  ```
- Line 448: name
  ```
  matrix rownames gasshare = "quintinc1" "quintinc2" "quintinc3" "quintinc4" "quintinc5"
  ```
- Line 449: lname, name
  ```
  matrix colnames gasshare =  "quintexp1" "quintexp2" "quintexp3" "quintexp4" "quintexp5"
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/7.samples.do**

- Line 22: lon
  ```
  **drop strings that are less than 6 months long
  ```
- Line 80: loc
  ```
  label var lsoa "Local Super Outout Area"
  ```
- Line 82: loc, name
  ```
  label var laname "Local Authority"
  ```
- Line 84: dob
  ```
  gen doby = yofd(dofm(dob))
  ```
- Line 85: dob
  ```
  gen dobm = month(dofm(dob))
  ```
- Line 93: dob
  ```
  gen age = year - doby
  ```
- Line 154: lat
  ```
  **Step 1: reweight to match the population based on gor and age band
  ```
- Line 172: lat
  ```
  label var count_norm   "Normalised population of 5-year age band in gor"
  ```
- Line 185: lat
  ```
  label var weight_fullsamp "Weight to adjust to population by age band and gor, full sample"
  ```
- Line 194: lat
  ```
  label var weight_balsamp "Weight to adjust to population by age band and gor, balanced sample"
  ```
- Line 307: lon
  ```
  label var dataset "Indicator for which dataset the user belongs to"
  ```
- Line 317: lat
  ```
  label var weight_fullsamp "Weight to adjust to population by age band and gor, full sample"
  ```
- Line 318: lat
  ```
  label var weight_balsamp "Weight to adjust to population by age band and gor, balanced sample"
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/8.analysis.do**

- Line 16: district
  ```
  gen postcode_district = substr(postcode_sector,1,strpos(postcode_sector, " "))
  ```
- Line 17: district
  ```
  replace postcode_district = subinstr(postcode_district," ","",.)
  ```
- Line 22: district
  ```
  gen twodigitpostcode = substr(postcode_district,1,2)
  ```
- Line 25: lon
  ```
  replace ofgem_region = "London" if _merge==1 & ofgem_region == "" & inlist(twodigitpostcode,"WC","SW
  ```
- Line 40: country
  ```
  **some users don't have lsoa identifiers - use mean across country for them
  ```
- Line 47: name
  ```
  drop geo_label name
  ```
- Line 53: name
  ```
  drop Period monthname
  ```
- Line 152: name
  ```
  // Check if the variable name contains any of the specified substrings
  ```
- Line 161: loc
  ```
  local current_label: variable label `var'
  ```
- Line 394: child
  ```
  collapse (mean) mtot_in_excltrans mtot_out_nondurab  mexp_energy_t_reb  sample (max) onbenefits chil
  ```
- Line 439: name
  ```
  rename tot_in_excltrans  inc
  ```
- Line 449: loc
  ```
  local mn = `r(min)'
  ```
- Line 450: loc
  ```
  local mx = `r(max)'
  ```
- Line 467: loc
  ```
  local mn = `mn'+1
  ```
- Line 510: name
  ```
  rename mtot_in_excltrans_quint inc_quint
  ```
- Line 511: name
  ```
  rename mexp_energy_t_reb_quint eexp_quint
  ```
- Line 512: name, sex
  ```
  rename mshr_e_quint			   sexp_quint
  ```
- Line 514: name
  ```
  rename mtot_in_excltrans_dec inc_dec
  ```
- Line 515: name
  ```
  rename mexp_energy_t_reb_dec eexp_dec
  ```
- Line 516: name, sex
  ```
  rename mshr_e_dec 			 sexp_dec
  ```
- Line 518: name
  ```
  rename mtot_in_excltrans_p inc_p
  ```
- Line 519: name
  ```
  rename mexp_energy_t_reb_p eexp_p
  ```
- Line 520: name, sex
  ```
  rename mshr_e_p 		   sexp_p
  ```
- Line 523: name
  ```
  rename mtot_in_excltrans minc
  ```
- Line 524: name
  ```
  rename mexp_energy_t_reb meexp
  ```
- Line 525: name, sex
  ```
  rename mshr_e 			 msexp
  ```
- Line 543: son
  ```
  **CREATE ANALYSIS DATASET WITH FEWER VARIABLES AND DESEASONALISED MEASURES
  ```
- Line 563: sex
  ```
  lprice rebates tmin? tmax? tminlesstmax2 t t2 lnY postmonth* tt_toinclude* sample  inc_quint eexp_qu
  ```
- Line 627: son
  ```
  **now regress deseasonalised measure on year-month dummies
  ```

**/replication-package/ReplicationPackage/Programs/2.setupData/9.model.do**

- Line 18: loc
  ```
  local x = `r(mean)'
  ```
- Line 20: loc
  ```
  local y = `r(mean)'
  ```
- Line 27: lat
  ```
  sa "$dataProcess/population_weights.dta", replace
  ```
- Line 37: name
  ```
  rename meexp eexp
  ```
- Line 38: name, sex
  ```
  rename msexp sexp
  ```
- Line 53: name
  ```
  rename s_ener_nosc s_ener
  ```
- Line 54: name
  ```
  rename exp_energy_t_sc fixedfee
  ```
- Line 58: sex
  ```
  keep  userref yeartax  year month yrmn eexp eexp_p eexp_dec eexp_quint inc_quint sexp sexp_p sexp_de
  ```
- Line 59: sex
  ```
  order userref yeartax  year month yrmn eexp eexp_p eexp_dec eexp_quint inc_quint sexp sexp_p sexp_de
  ```
- Line 65: name
  ```
  rename lprice p_ener
  ```
- Line 66: name
  ```
  rename lpnondur p_cons
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/1.summarystats.do**

- Line 31: house
  ```
  ** shr of DD households that are fixed
  ```
- Line 33: loc
  ```
  local num_fixedDD = r(ndistinct)
  ```
- Line 35: loc
  ```
  local num_varDD = r(ndistinct)
  ```
- Line 40: house
  ```
  **number of top ups per pp household per month
  ```
- Line 46: loc
  ```
  local msc = r(mean)
  ```
- Line 48: loc
  ```
  local mexp = r(mean)
  ```
- Line 88: son
  ```
  ** SEASONALITY OF VARIABLE SPENDING
  ```
- Line 99: sex
  ```
  keep userref userref_orig yrmn  rebates energy_supplier1 energy_supplier2 salaryrange year month  ex
  ```
- Line 125: lat
  ```
  ytitle("Log energy spending (relative to January)") xtitle("")
  ```
- Line 128: son
  ```
  graph export "$resultsdir/FIG_paymenttypes_season.pdf", replace
  ```
- Line 151: sex
  ```
  keep userref yrmn  rebates year month age_2021  exp_energy_t_noreb exp_energy_t_reb sample_* age age
  ```
- Line 204: name
  ```
  gen sample_name = "Smoothed direct debit \& other payment modes" if sample == 3
  ```
- Line 205: name
  ```
  replace sample_name = "Variable direct debit" if sample == 2
  ```
- Line 206: name
  ```
  replace sample_name = "Prepayment" if sample == 1
  ```
- Line 262: lon
  ```
  7 "London"
  ```
- Line 274: lat
  ```
  legend(label(1 "Prepayment") label(2 "Variable direct debit") label (3 "Smoothed direct debit and ot
  ```
- Line 277: house
  ```
  ytitle("% households")
  ```
- Line 302: lat
  ```
  legend(label(1 "Prepayment") label(2 "Variable direct debit") label (3 "Smoothed direct debit and ot
  ```
- Line 305: house
  ```
  ytitle("% households")
  ```
- Line 320: sex
  ```
  keep userref yrmn  rebates year month age_2021  exp_energy_t_noreb exp_energy_t_reb sample_* age age
  ```
- Line 385: house
  ```
  disp as error "number of households in fuel poverty in 2019: $num_fuelpov"
  ```
- Line 401: house
  ```
  graph twoway bar menergy_poverty inc_dec if f==1, barw(0.8) xlabel(1(1)10) ylabel(0(0.1)0.5) yscale(
  ```
- Line 424: sex
  ```
  keep userref yrmn  rebates year month age_2021 no_lagged_income exp_energy_t_noreb exp_energy_t_reb 
  ```
- Line 450: lon
  ```
  reshape long nobs_ nuser_, i(i) j(period) s
  ```
- Line 513: lat
  ```
  **spearman's rank correlation
  ```
- Line 515: loc
  ```
  local spearman_energy_`var' = r(rho)
  ```
- Line 587: lat
  ```
  *spearman's rank correlation
  ```
- Line 589: loc
  ```
  local spearman_energy_`var' = r(rho)
  ```
- Line 753: house
  ```
  *Ask households to consult combined statements
  ```
- Line 767: son
  ```
  *do within month to account for seasonal effects
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/2.macrotrends.do**

- Line 10: son
  ```
  ** DESEASONALISE  CLEARSCORE DATA
  ```
- Line 20: sex
  ```
  keep userref userref_orig yrmn  year month onemonth* cpi_allitems inc_dec onemonth* salaryrange weig
  ```
- Line 206: city
  ```
  ** STABLE GAS VS ELECTRICITY SHARE OVER TIME
  ```
- Line 217: name
  ```
  rename Domestic BEIS_domestic_sa
  ```
- Line 218: name
  ```
  rename Domestic_nas BEIS_domestic_nsa
  ```
- Line 219: name
  ```
  rename Domestic_gas_sa BEIS_gas_sa
  ```
- Line 220: name
  ```
  rename Domestic_elec_sa BEIS_elec_sa
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/3.describepricecap.do**

- Line 15: name
  ```
  rename A date
  ```
- Line 23: name
  ```
  rename Largelegacysuppliersdirectd CheapestDD_Large
  ```
- Line 24: name
  ```
  rename  Largelegacysuppliersstandard  CheapestSC_Large
  ```
- Line 25: name
  ```
  rename  Largelegacysuppliersprepayme  CheapestPPM_Large
  ```
- Line 26: name
  ```
  rename Marketdirectdebit CheapestDD_Market
  ```
- Line 27: name
  ```
  rename Marketstandardcredit CheapestSC_Market
  ```
- Line 28: name
  ```
  rename  Marketprepayment CheapestPPM_Market
  ```
- Line 36: name
  ```
  rename A date
  ```
- Line 43: name
  ```
  rename Averagestandardvariabletariff AvSVT_Large
  ```
- Line 44: name
  ```
  rename C AvSVT_Other
  ```
- Line 45: name
  ```
  rename Averagefixedtariff AvFixed
  ```
- Line 46: name
  ```
  rename CheapesttariffLargelegacysu CheapestSVT_Large
  ```
- Line 47: name
  ```
  rename CheapesttariffAllsuppliers  CheapestSVT_All
  ```
- Line 48: name
  ```
  rename CheapesttariffBasket  CheapestSVT_Basket
  ```
- Line 49: name
  ```
  rename Defaulttariffcaplevel EnergyPriceCap
  ```
- Line 76: name
  ```
  rename cap_prepay EnergyPriceCap_Prepay
  ```
- Line 80: loc
  ```
  local start = ym(2019,1)
  ```
- Line 81: loc
  ```
  loca end = ym(2023, 12)
  ```
- Line 113: loc
  ```
  local start = ym(2021,1)
  ```
- Line 114: loc
  ```
  local end = ym(2022, 9)
  ```
- Line 120: lat
  ```
  graphr(color(white)) lpattern(solid solid solid dash dash dash)  xtitle("") ytitle("Change relative 
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/4.exposure.do**

- Line 21: child
  ```
  collapse (mean) mliquid_assets = liquid_assets mtot_in_excltrans = tot_in_excltrans  mtot_out_nondur
  ```
- Line 55: lat
  ```
  **relationship w.r.t income
  ```
- Line 71: lat
  ```
  **relationship w.r.t total expenditure
  ```
- Line 88: lat
  ```
  **relationship w.r.t income, just for 2019
  ```
- Line 107: sex
  ```
  sa "$dataAnalysis/CSexposuremeasures", replace
  ```
- Line 109: sex
  ```
  u "$dataAnalysis/CSexposuremeasures", clear
  ```
- Line 283: lat
  ```
  **CORRELATION IN ENERGY SPENDING OVER TIME
  ```
- Line 294: sex
  ```
  keep userref userref_orig yrmn inc_dec rebates energy_supplier1 energy_supplier2 col reccol wfh cpi_
  ```
- Line 297: son
  ```
  gen season = month>=10 | month<=3
  ```
- Line 298: son
  ```
  replace season = 2 if season == 0
  ```
- Line 300: son
  ```
  gen year_season = year*100 + season
  ```
- Line 301: son
  ```
  replace year_season = (year+1)*100 + season  if month>=10
  ```
- Line 306: son
  ```
  collapse (mean) exp_energy_t_reb (sum) nmonth, by(userref sample year_season )
  ```
- Line 318: son
  ```
  sort userref sample year_season
  ```
- Line 328: son
  ```
  reg lexp lexp_lag2 if nmonth==6 & nmonth_lag2==6 & year_season<=202101, robust
  ```
- Line 334: son
  ```
  reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6
  ```
- Line 338: son
  ```
  pcorr lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6
  ```
- Line 346: house
  ```
  **all households
  ```
- Line 347: son
  ```
  reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6
  ```
- Line 352: son
  ```
  reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & mtot_in_excltrans_quart == `q'
  ```
- Line 357: son
  ```
  pcorr lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & mtot_in_excltrans_quart == `q'
  ```
- Line 361: son
  ```
  reg lexp lexp_lag2 i.year_season if nmonth==6 & nmonth_lag2==6 & year_season<=202101 & mtot_in_exclt
  ```
- Line 385: lat
  ```
  gen beta_lab = "Autocorrelation coefficient, $\hat{\rho}_1$"
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/5.priceresponse.do**

- Line 29: lat
  ```
  **note: relative prices across the regions are the same in March 2022 because they are indexed to Ja
  ```
- Line 30: lat
  ```
  **		no changes in the relative price caps over this period
  ```
- Line 84: loc
  ```
  local yrmn = r(mean)
  ```
- Line 115: son
  ```
  xtitle("") ytitle("Log spending (deseasonalised)")
  ```
- Line 138: loc
  ```
  local yrmn = r(mean)
  ```
- Line 163: lat
  ```
  xtitle("") ytitle("Change in log spending relative to June 2021")
  ```
- Line 276: city, lat
  ```
  ** Calculate elasticity program
  ```
- Line 607: loc
  ```
  local lppost = ${lp_post`v'}
  ```
- Line 608: loc
  ```
  if "`v'" == "Oct21" local lpbase = $lp_base
  ```
- Line 609: loc
  ```
  if "`v'" == "Apr22" local lpbase = $lp_postOct21
  ```
- Line 648: loc
  ```
  local j1 = 5
  ```
- Line 649: loc
  ```
  local j2 = 1
  ```
- Line 664: loc
  ```
  local lppost_j1 = ${lp1_post`v'}
  ```
- Line 665: loc
  ```
  local lppost_j2 = ${lp2_post`v'}
  ```
- Line 666: loc
  ```
  if "`v'" == "Oct21" local lpbase_j1 = $lp1_base
  ```
- Line 667: loc
  ```
  if "`v'" == "Oct21" local lpbase_j2 = $lp2_base
  ```
- Line 668: loc
  ```
  if "`v'" == "Apr22" local lpbase_j1 = $lp1_postOct21
  ```
- Line 669: loc
  ```
  if "`v'" == "Apr22" local lpbase_j2 = $lp2_postOct21
  ```
- Line 776: city
  ```
  gen e_lab = "Own-price elasticity"
  ```
- Line 811: name
  ```
  rename e_x_* elas_*
  ```
- Line 812: name
  ```
  rename elas_* =_inc
  ```
- Line 877: city
  ```
  ytitle("Price elasticity associated" "with April 2022 increase")
  ```
- Line 889: lon
  ```
  reshape long elas_hom_Oct21_inc elas_hom_Apr22_inc, i(eexp_quint) j(inc_quint)
  ```

**/replication-package/ReplicationPackage/Programs/3.descriptiveResults/6.MPCs.do**

- Line 12: name
  ```
  syntax, tabname(string) varlist(varlist) [noprice(string)] [postrebates(string) lagleadprices(string
  ```
- Line 17: name
  ```
  tempname duan meanrebatesvalue meancolvalue beta beta_variance estimates beta_variance_diag dydx
  ```
- Line 21: loc
  ```
  local N = e(N)
  ```
- Line 22: loc
  ```
  local Ng = e(N_g)
  ```
- Line 23: loc
  ```
  local depvar = e(depvar)
  ```
- Line 43: loc
  ```
  local meanlprice_rebates =  r(mean)
  ```
- Line 46: loc
  ```
  local meanlprice_post3qtr =  r(mean)
  ```
- Line 49: loc
  ```
  local meanlprice_post_qtr = r(mean)
  ```
- Line 52: loc
  ```
  local meanlprice_post_month = r(mean)
  ```
- Line 57: loc
  ```
  local mean = r(mean)
  ```
- Line 58: loc
  ```
  local tempmean_`period' = "`tempmean_`period'' `var'=`mean'"
  ```
- Line 64: loc
  ```
  local month_rebates = "month=11"
  ```
- Line 65: loc
  ```
  local month_postrebates_3qtr = "month=7"
  ```
- Line 66: loc
  ```
  local month_postrebates_qtr = "month=6"
  ```
- Line 67: loc
  ```
  local month_postrebates_month = "month=4"
  ```
- Line 71: loc
  ```
  local lagleadterms "lag_lprice=`meanlprice_rebates' lead_lprice=`meanlprice_rebates'"
  ```
- Line 72: loc
  ```
  local lagleadterms_post3quarters "lag_lprice=`meanlprice_post3quarters' lead_lprice=`meanlprice_post
  ```
- Line 73: loc
  ```
  local lagleadterms_postqtr "lag_lprice=`meanlprice_post_qtr' lead_lprice=`meanlprice_post_qtr'"
  ```
- Line 74: loc
  ```
  local lagleadterms_postmonth "lag_lprice=`meanlprice_post_month' lead_lprice=`meanlprice_post_month'
  ```
- Line 78: loc
  ```
  local i = 1
  ```
- Line 83: loc
  ```
  local meanvalue = `mean`var'value'
  ```
- Line 136: loc, name
  ```
  local varnames "`varnames' `var'"
  ```
- Line 137: loc
  ```
  local ++i
  ```
- Line 142: lname, name
  ```
  matrix colnames `beta' = `varnames'
  ```
- Line 143: lname, name
  ```
  matrix colnames `beta_variance' = `varnames'
  ```
- Line 144: name
  ```
  matrix rownames `beta_variance' = `varnames'
  ```
- Line 151: loc
  ```
  ereturn local depvar = "`depvar'"
  ```
- Line 152: loc, name
  ```
  ereturn local cmd "`tabname'"
  ```
- Line 163: name
  ```
  tempname b V
  ```
- Line 165: loc
  ```
  local N = e(N)
  ```
- Line 166: loc
  ```
  local N_g = e(N_g)
  ```
- Line 167: loc
  ```
  local r2 = e(r2)
  ```
- Line 168: loc
  ```
  local depvar = e(depvar)
  ```
- Line 181: lname, loc, name
  ```
  local bcolnames "`bcolnames' `yrmn'.yrmn#1.`interactvar'";
  ```
- Line 182: loc, name
  ```
  local Vrownames "`Vrownames' `yrmn'.yrmn#1.`interactvar'";
  ```
- Line 186: lname, name
  ```
  matrix colnames `b' = `bcolnames'
  ```
- Line 187: name
  ```
  matrix rownames `V' = `Vrownames'
  ```
- Line 191: loc
  ```
  ereturn local depvar = "`depvar'"
  ```
- Line 195: loc, son
  ```
  ereturn local cmd "results_season"
  ```
- Line 200: son
  ```
  *deasonalise
  ```
- Line 201: son
  ```
  cap prog drop deseason
  ```
- Line 202: son
  ```
  program deseason
  ```
- Line 286: loc
  ```
  local yrqn = r(mean)
  ```
- Line 297: loc
  ```
  local lagsandleadsofprices "c.lag_lprice c.lead_lprice"
  ```
- Line 312: loc
  ```
  local yrqn = r(mean)
  ```
- Line 338: son
  ```
  xtitle("") ytitle("Log spending (deseasonalised)");
  ```
- Line 348: son
  ```
  xtitle("") ytitle("Log spending (deseasonalised)");
  ```
- Line 358: son
  ```
  xtitle("") ytitle("Log spending (deseasonalised)");
  ```
- Line 399: loc
  ```
  local ppmean = r(mean)
  ```
- Line 401: loc
  ```
  local varddmean = r(mean)
  ```
- Line 436: name
  ```
  duansmearing, tabname("MPC") varlist(rebates col2months) postrebates("qtr") lagleadprices("yes")
  ```
- Line 440: name
  ```
  duansmearing, tabname("MPC") varlist(rebates col2months)
  ```
- Line 444: name
  ```
  duansmearing, tabname("MPC") varlist(rebates col2months) postrebates("month")
  ```
- Line 452: son
  ```
  *deseasonalise separately for those who receive EBSS vs not (absolute cash spending)
  ```
- Line 454: son
  ```
  deseason, v(lx_ener) newv("x_ener_ds_everEBSS")
  ```
- Line 464: loc
  ```
  local N = e(N)
  ```
- Line 465: loc
  ```
  local Ng = e(N_g)
  ```
- Line 466: loc
  ```
  local r2 = e(r2)
  ```
- Line 467: loc
  ```
  local depvar = e(depvar)
  ```
- Line 477: lname, name
  ```
  matrix colnames b = "rebates"
  ```
- Line 478: lname, name
  ```
  matrix colnames V = "rebates"
  ```
- Line 479: name
  ```
  matrix rownames V = "rebates"
  ```
- Line 481: loc
  ```
  local N = e(N)
  ```
- Line 482: loc
  ```
  local Ng = e(N_g)
  ```
- Line 483: loc
  ```
  local r2 = e(r2)
  ```
- Line 484: loc
  ```
  local depvar = e(depvar)
  ```
- Line 487: loc
  ```
  ereturn local depvar = "`depvar'"
  ```
- Line 491: loc, son
  ```
  ereturn local cmd "results_season"
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/0.prepareestimation.do**

- Line 35: loc
  ```
  local x=`z'-1
  ```
- Line 36: sex
  ```
  g ps`x'=sexp_dec==`z'
  ```
- Line 86: lat
  ```
  *Relative price
  ```
- Line 204: name
  ```
  svmat crit_test_mat, names(temp)
  ```
- Line 279: name
  ```
  svmat crit_test_mat, names(temp)
  ```
- Line 307: loc
  ```
  local l = 2
  ```
- Line 312: loc
  ```
  local l = `l'+1
  ```
- Line 409: loc
  ```
  local Ns = `r(N)'
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/1.coefficients.do**

- Line 4: name
  ```
  rename v1 coef
  ```
- Line 5: name
  ```
  rename v2 se
  ```
- Line 15: name
  ```
  rename coef coef_sv
  ```
- Line 16: name
  ```
  rename se   se_sv
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/2.modelfit.do**

- Line 18: name
  ```
  rename v1  hh
  ```
- Line 19: name
  ```
  rename v2  t
  ```
- Line 20: name
  ```
  rename v3  s1_hat
  ```
- Line 21: name
  ```
  rename v4  concavity
  ```
- Line 22: city, name
  ```
  rename v5  monotonicity
  ```
- Line 23: name
  ```
  rename v6  belas
  ```
- Line 27: city
  ```
  gen failmonotonicity = monotonicity<0
  ```
- Line 30: city
  ```
  tab failmonotonicity
  ```
- Line 51: name
  ```
  rename v1  id
  ```
- Line 52: name
  ```
  rename v2  t
  ```
- Line 53: name
  ```
  rename v3  s1_hat
  ```
- Line 78: name
  ```
  rename s1     s1_ho_e
  ```
- Line 79: name
  ```
  rename s1_hat s1_hp_e
  ```
- Line 80: name
  ```
  rename eexp_p p
  ```
- Line 90: name
  ```
  rename s1     s1_ho_i
  ```
- Line 91: name
  ```
  rename s1_hat s1_hp_i
  ```
- Line 92: name
  ```
  rename inc_p p
  ```
- Line 99: name
  ```
  rename v1  id
  ```
- Line 100: name
  ```
  rename v2  t
  ```
- Line 101: name
  ```
  rename v3  s1_hat
  ```
- Line 127: name
  ```
  rename s1     s1_io_e
  ```
- Line 128: name
  ```
  rename s1_hat s1_ip_e
  ```
- Line 129: name
  ```
  rename eexp_p p
  ```
- Line 138: name
  ```
  rename s1     s1_io_i
  ```
- Line 139: name
  ```
  rename s1_hat s1_ip_i
  ```
- Line 140: name
  ```
  rename inc_p p
  ```
- Line 199: name
  ```
  rename v1  hh
  ```
- Line 200: name
  ```
  rename v2  t
  ```
- Line 201: name
  ```
  rename v3  s1_hat1
  ```
- Line 212: name
  ```
  rename v1  hh
  ```
- Line 213: name
  ```
  rename v2  t
  ```
- Line 214: name
  ```
  rename v3  s1_hat2
  ```
- Line 246: name
  ```
  rename v1  id
  ```
- Line 247: name
  ```
  rename v2  t
  ```
- Line 248: name
  ```
  rename v3  pS
  ```
- Line 249: name
  ```
  rename v4  pNS
  ```
- Line 250: name
  ```
  rename v5  x
  ```
- Line 251: name
  ```
  rename v6  qS
  ```
- Line 252: name
  ```
  rename v7  qNS
  ```
- Line 272: city
  ```
  line mn_Marshallian eexp_quint if inc_quint==1,lcolor(gs12) || line mn_Marshallian eexp_quint if inc
  ```
- Line 281: name
  ```
  rename v1  id
  ```
- Line 282: name
  ```
  rename v2  t
  ```
- Line 283: name
  ```
  rename v3  w
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/EngelCurves.m**

- Line 7: name
  ```
  [id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Estimate.m**

- Line 3: name
  ```
  p=append(OutputFileName,'.raw');
  ```
- Line 5: name
  ```
  p=append(OutputFileName,'.mat');
  ```
- Line 8: name
  ```
  p=append(CoefFileName,'.raw');
  ```
- Line 13: name
  ```
  [hh,~,x,p,IC,IP,IY,w,Z,~]=dataprepareestimate(InDir,DataFileName,...
  ```
- Line 16: dob
  ```
  options = optimoptions('fmincon','display','iter', 'GradObj', 'on', 'FiniteDifferenceType', 'central
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/GMM.m**

- Line 8: lon
  ```
  epsilon = 1e-8;
  ```
- Line 13: lon
  ```
  theta1(i) = theta1(i) + epsilon;
  ```
- Line 15: lon
  ```
  theta2(i) = theta2(i) - epsilon;
  ```
- Line 20: lon
  ```
  dg(i) = (1/N)*(obj1 - obj2) / (2 * epsilon);
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Holdout.m**

- Line 3: name
  ```
  p=append(CoefFileName,'.mat');
  ```
- Line 8: name
  ```
  [id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
  ```
- Line 15: name
  ```
  p=append(OutputFileName,'.raw');
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Priceeffects.m**

- Line 7: name
  ```
  [id,t,x,p,IC,IP,IY,~,~,pNS]=dataprepareestimate(InDir,DataFileName,...
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Restrictions.m**

- Line 7: name
  ```
  [id,t,x,p,IC,IP,IY,~,~,~]=dataprepareestimate(InDir,DataFileName,...
  ```
- Line 15: city
  ```
  [mono]=monotonicity(y,r,p,IY,C0,Ci,D);
  ```
- Line 29: city
  ```
  function [mono]=monotonicity(y,r,p,IY,c0,ci,d)
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/Run.m**

- Line 18: name
  ```
  CoefFileName='startingvalues';
  ```
- Line 19: name
  ```
  DataFileName='estimationdata';
  ```
- Line 20: name
  ```
  OutputFileName='GMMcoefficients';
  ```
- Line 21: name
  ```
  Estimate(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 23: city
  ```
  %Check concavity and monotonicity
  ```
- Line 24: name
  ```
  DataFileName='estimationdata';
  ```
- Line 25: name
  ```
  Restrictions(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 28: name
  ```
  CoefFileName='GMMcoefficients';
  ```
- Line 29: name
  ```
  DataFileName='holdoutdata';
  ```
- Line 30: name
  ```
  OutputFileName='holdoutpredictions';
  ```
- Line 31: name
  ```
  Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 32: name
  ```
  DataFileName='insampledata';
  ```
- Line 33: name
  ```
  OutputFileName='insamplepredictions';
  ```
- Line 34: name
  ```
  Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 37: name
  ```
  CoefFileName='startingvalues';
  ```
- Line 38: name
  ```
  DataFileName='flyvalid_estimationdata';
  ```
- Line 39: name
  ```
  OutputFileName='Valdcoefficients';
  ```
- Line 40: name
  ```
  Estimate(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 41: name
  ```
  CoefFileName='Valdcoefficients';
  ```
- Line 42: name
  ```
  DataFileName='flyvalid_holdoutdata1';
  ```
- Line 43: name
  ```
  OutputFileName='flyvalidpredictions1';
  ```
- Line 44: name
  ```
  Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 45: name
  ```
  DataFileName='flyvalid_holdoutdata2';
  ```
- Line 46: name
  ```
  OutputFileName='flyvalidpredictions2';
  ```
- Line 47: name
  ```
  Holdout(CoefFileName,DataFileName,OutputFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 50: name
  ```
  DataFileName='priceeffectsdata';
  ```
- Line 51: name
  ```
  Priceeffects(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```
- Line 54: name
  ```
  DataFileName='engelcurvesdata';
  ```
- Line 55: name
  ```
  EngelCurves(DataFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP)
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/dataprepareestimate.m**

- Line 1: name
  ```
  function [hh,t,x,p,IC,IP,IY,w,Z,pcf]=dataprepareestimate(Dir,DataFileName,...
  ```
- Line 4: name
  ```
  p=append(DataFileName,'.raw');
  ```
- Line 6: lat
  ```
  population=load(DataFile);
  ```
- Line 8: lat
  ```
  N=length(population);
  ```
- Line 10: lat
  ```
  hh=population(:,1);
  ```
- Line 11: lat
  ```
  t=population(:,2);
  ```
- Line 13: lat
  ```
  x=population(:,3);
  ```
- Line 14: lat
  ```
  p=population(:,4:5);
  ```
- Line 16: lat
  ```
  ZC=population(:,6:5+nZC);
  ```
- Line 17: lat
  ```
  ZY=population(:,6:5+nZY);
  ```
- Line 18: lat
  ```
  IP=population(:,6:5+nZP);
  ```
- Line 21: lat
  ```
  R=population(:,s+1:s+nRC);
  ```
- Line 22: lat
  ```
  RY=population(:,s+1:s+nRY);
  ```
- Line 32: lat
  ```
  w=population(:,end-1);
  ```
- Line 33: lat
  ```
  y=population(:,end);
  ```
- Line 45: lat
  ```
  pcf=population(:,end);
  ```

**/replication-package/ReplicationPackage/Programs/4.modelEstimates/Estimation/momder.m**

- Line 2: lon
  ```
  epsilon = 1e-8;
  ```
- Line 7: lon
  ```
  theta1(i) = theta1(i) + epsilon;
  ```
- Line 8: lon
  ```
  theta2(i) = theta2(i) - epsilon;
  ```
- Line 18: lon
  ```
  G(:, i) = (m1 - m2) / (2 * epsilon);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/0.preparesimulation.do**

- Line 37: name
  ```
  rename v1  id
  ```
- Line 38: name
  ```
  rename v2  t
  ```
- Line 39: name
  ```
  rename v3  s1_hat
  ```
- Line 40: name
  ```
  rename v4  concavity
  ```
- Line 41: city, name
  ```
  rename v5  monotonicity
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/1.observedpolicy.do**

- Line 3: lat
  ```
  ****Insheet policy simulations
  ```
- Line 7: name
  ```
  rename v1  id
  ```
- Line 8: name
  ```
  rename v2  t
  ```
- Line 9: name
  ```
  rename v3  weight
  ```
- Line 10: name
  ```
  rename v4  s
  ```
- Line 11: name
  ```
  rename v5  R
  ```
- Line 12: name
  ```
  rename v6  q0
  ```
- Line 13: name
  ```
  rename v7  qLF
  ```
- Line 14: name
  ```
  rename v8  qSR
  ```
- Line 15: name
  ```
  rename v9  qST
  ```
- Line 16: name
  ```
  rename v10 pS
  ```
- Line 17: name
  ```
  rename v11 gt
  ```
- Line 18: name
  ```
  rename v12 FOSR
  ```
- Line 19: name
  ```
  rename v13 FOLF
  ```
- Line 20: name
  ```
  rename v14 EVSR
  ```
- Line 21: name
  ```
  rename v15 EVLF
  ```
- Line 22: name
  ```
  rename v16 CVLF
  ```
- Line 23: name
  ```
  rename v17 EVTt
  ```
- Line 24: name
  ```
  rename v18 EVTl
  ```
- Line 25: name
  ```
  rename v19 EVST
  ```
- Line 26: name
  ```
  rename v20 EVSTe
  ```
- Line 27: name
  ```
  rename v21 tag
  ```
- Line 75: name
  ```
  rename inc_t inc
  ```
- Line 78: name
  ```
  rename inc_dec_taxyr inc_dec
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/2.counterfactualpolicy.do**

- Line 8: name
  ```
  rename v1  id
  ```
- Line 9: name
  ```
  rename v2  t
  ```
- Line 10: name
  ```
  rename v3  pLF
  ```
- Line 11: name
  ```
  rename v4  tFB
  ```
- Line 12: name
  ```
  rename v5  EVFB
  ```
- Line 13: name
  ```
  rename v6  s
  ```
- Line 14: name
  ```
  rename v7  tSR
  ```
- Line 15: name
  ```
  rename v8  tSTe
  ```
- Line 16: name
  ```
  rename v9  tSTy
  ```
- Line 17: name
  ```
  rename v10 tSTs
  ```
- Line 18: name
  ```
  rename v11 tSTys
  ```
- Line 19: name
  ```
  rename v12 qSR
  ```
- Line 20: name
  ```
  rename v13 qST
  ```
- Line 21: name
  ```
  rename v14 qSTe
  ```
- Line 22: name
  ```
  rename v15 qSTy
  ```
- Line 23: name
  ```
  rename v16 qSTs
  ```
- Line 24: name
  ```
  rename v17 qSTys
  ```
- Line 25: name
  ```
  rename v18 EVSR
  ```
- Line 26: name
  ```
  rename v19 EVST
  ```
- Line 27: name
  ```
  rename v20 EVSTe
  ```
- Line 28: name
  ```
  rename v21 EVSTy
  ```
- Line 29: name
  ```
  rename v22 EVSTs
  ```
- Line 30: name
  ```
  rename v23 EVSTys
  ```
- Line 31: name
  ```
  rename v24 tag
  ```
- Line 58: social
  ```
  ***Infer social preferences
  ```
- Line 77: loc
  ```
  local psi=(`p')/1000
  ```
- Line 180: loc
  ```
  local i=1
  ```
- Line 186: loc
  ```
  local i=`i'+1
  ```
- Line 233: loc
  ```
  local e=`r(mean)'
  ```
- Line 235: loc
  ```
  local t=`r(mean)'
  ```
- Line 237: loc
  ```
  local w=`r(mean)'
  ```
- Line 238: loc
  ```
  local sl = (`w'-`t')/(-`e')
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/3.observedpolicyCI.do**

- Line 5: name
  ```
  rename v1  inc
  ```
- Line 6: name
  ```
  rename v2  FOSR
  ```
- Line 7: name
  ```
  rename v3  FOLF
  ```
- Line 8: name
  ```
  rename v4  EVSR
  ```
- Line 9: name
  ```
  rename v5  EVLF
  ```
- Line 10: name
  ```
  rename v6  CVLF
  ```
- Line 11: name
  ```
  rename v7  EVTt
  ```
- Line 12: name
  ```
  rename v8  EVTl
  ```
- Line 13: name
  ```
  rename v9  EVST
  ```
- Line 14: name
  ```
  rename v10 EVSTe
  ```
- Line 15: name
  ```
  rename v11 FOSRy
  ```
- Line 16: name
  ```
  rename v12 FOLFy
  ```
- Line 17: name
  ```
  rename v13 EVSRy
  ```
- Line 18: name
  ```
  rename v14 EVLFy
  ```
- Line 19: name
  ```
  rename v15 CVLFy
  ```
- Line 20: name
  ```
  rename v16 EVTty
  ```
- Line 21: name
  ```
  rename v17 EVTly
  ```
- Line 22: name
  ```
  rename v18 EVSTy
  ```
- Line 23: name
  ```
  rename v19 EVSTey
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/4.tablesfigures.do**

- Line 64: house
  ```
  replace x="Number of households"
  ```
- Line 91: lon
  ```
  twoway  rarea bd tr ec if ec<=0,color(gs12%30)|| line tarSR ecSR,color(red) lpattern(dash)|| line  t
  ```
- Line 94: lon
  ```
  line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || li
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A1.welfareweights.do**

- Line 9: loc
  ```
  local EVm=`r(p50)'
  ```
- Line 12: loc
  ```
  local linc = `r(max)'
  ```
- Line 14: loc
  ```
  local hinc = `r(max)'
  ```
- Line 23: loc
  ```
  local incm = `r(max)'
  ```
- Line 26: loc
  ```
  local lEV=`r(p25)'
  ```
- Line 27: loc
  ```
  local uEV=`r(p75)'
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A2.pricesensitivity.do**

- Line 12: name
  ```
  rename v1  id
  ```
- Line 13: name
  ```
  rename v2  t
  ```
- Line 14: name
  ```
  rename v3  pLF
  ```
- Line 15: name
  ```
  rename v4  tFB
  ```
- Line 16: name
  ```
  rename v5  EVFB
  ```
- Line 17: name
  ```
  rename v6  FOSR
  ```
- Line 18: name
  ```
  rename v7  s
  ```
- Line 19: name
  ```
  rename v8  tSR
  ```
- Line 20: name
  ```
  rename v9  tSTe
  ```
- Line 21: name
  ```
  rename v10  tSTy
  ```
- Line 22: name
  ```
  rename v11 tSTs
  ```
- Line 23: name
  ```
  rename v12 tSTys
  ```
- Line 24: name
  ```
  rename v13 qSR
  ```
- Line 25: name
  ```
  rename v14 qST
  ```
- Line 26: name
  ```
  rename v15 qSTe
  ```
- Line 27: name
  ```
  rename v16 qSTy
  ```
- Line 28: name
  ```
  rename v17 qSTs
  ```
- Line 29: name
  ```
  rename v18 qSTys
  ```
- Line 30: name
  ```
  rename v19 EVSR
  ```
- Line 31: name
  ```
  rename v20 EVST
  ```
- Line 32: name
  ```
  rename v21 EVSTe
  ```
- Line 33: name
  ```
  rename v22 EVSTy
  ```
- Line 34: name
  ```
  rename v23 EVSTs
  ```
- Line 35: name
  ```
  rename v24 EVSTys
  ```
- Line 36: name
  ```
  rename v25 tag
  ```
- Line 116: loc
  ```
  local i=1
  ```
- Line 122: loc
  ```
  local i=`i'+1
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A3.incomeoffset.do**

- Line 20: name
  ```
  rename v1  id
  ```
- Line 21: name
  ```
  rename v2  t
  ```
- Line 22: name
  ```
  rename v3  pLF
  ```
- Line 23: name
  ```
  rename v4  tFB
  ```
- Line 24: name
  ```
  rename v5  EVFB
  ```
- Line 25: name
  ```
  rename v6  s
  ```
- Line 26: name
  ```
  rename v7  tSTe
  ```
- Line 27: name
  ```
  rename v8  tSTs
  ```
- Line 28: name
  ```
  rename v9  qSTe
  ```
- Line 29: name
  ```
  rename v10 qSTs
  ```
- Line 30: name
  ```
  rename v11 EVSTe
  ```
- Line 31: name
  ```
  rename v12 EVSTs
  ```
- Line 76: name
  ```
  rename optimal`v' optimal`v'b
  ```
- Line 98: loc
  ```
  local i=1
  ```
- Line 104: loc
  ```
  local i=`i'+1
  ```
- Line 109: loc
  ```
  local i=`i'+1
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A4.revenuemin.do**

- Line 5: name
  ```
  rename v1 R_bar
  ```
- Line 6: name
  ```
  rename v2 R_Te
  ```
- Line 7: name
  ```
  rename v3 R_Ty
  ```
- Line 8: name
  ```
  rename v4 R_Ts
  ```
- Line 9: name
  ```
  rename v5 R_Tys
  ```
- Line 10: name
  ```
  rename v6 R_STe
  ```
- Line 11: name
  ```
  rename v7 R_STy
  ```
- Line 12: name
  ```
  rename v8 R_STs
  ```
- Line 13: name
  ```
  rename v9 R_STys
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A5.socialpreferences.do**

- Line 6: loc
  ```
  local z = 0
  ```
- Line 9: loc
  ```
  local z = `z'+1
  ```
- Line 44: loc
  ```
  local i=1
  ```
- Line 51: loc
  ```
  local i=`i'+1
  ```
- Line 75: social
  ```
  sa "$dataAnalysis/socialpreferences.dta",replace
  ```
- Line 78: loc
  ```
  local z = 0
  ```
- Line 81: loc
  ```
  local z = `z'+1
  ```
- Line 118: loc
  ```
  local i=2
  ```
- Line 122: loc
  ```
  local i=`i'+1
  ```
- Line 146: social
  ```
  sa "$dataAnalysis/socialpreferences_nosub.dta",replace
  ```
- Line 161: loc
  ```
  local sl =`r(mean)'
  ```
- Line 166: loc
  ```
  local y=100*`v'
  ```
- Line 236: loc
  ```
  local i=1
  ```
- Line 242: loc
  ```
  local i=`i'+1
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/A6.tablesfigures.do**

- Line 19: lon
  ```
  line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || li
  ```
- Line 25: lon
  ```
  line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || li
  ```
- Line 57: social
  ```
  u "$dataAnalysis/socialpreferences.dta",clear
  ```
- Line 60: loc
  ```
  local x=`r(mean)'
  ```
- Line 61: lat, lon, social
  ```
  line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)||
  ```
- Line 66: loc
  ```
  local x=`r(mean)'
  ```
- Line 67: lon, social
  ```
  line ops psi if p==1,color(red)  lpattern(dash) || line ops psi if p==2,color(navy)  lpattern(shortd
  ```
- Line 71: social
  ```
  u "$dataAnalysis/socialpreferences_nosub.dta",clear
  ```
- Line 74: loc
  ```
  local x=`r(mean)'
  ```
- Line 75: lat, lon, social
  ```
  line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)||
  ```
- Line 80: loc
  ```
  local x=`r(mean)'
  ```
- Line 81: lat, lon, social
  ```
  line W psi if p==1,color(red)  lpattern(dash)|| line W psi if p==2,color(navy) lpattern(shortdash)||
  ```
- Line 89: lon
  ```
  line tarSR ecSR,color(red) lpattern(dash)|| line  tarSTe ecSTe,color(navy) lpattern(shortdash) || li
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Counterfactualpolicy.m**

- Line 8: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
  ```
- Line 240: name
  ```
  OutFile=fullfile(OutDir,OutFileName);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/MPCE.m**

- Line 4: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,Inc]=dataprepare(InDir,DataFileName,...
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Observedpolicy.m**

- Line 4: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,Inc]=dataprepare(InDir,DataFileName,...
  ```
- Line 146: name
  ```
  filename =[ 'confidenceinterval', int2str(ci), '.raw'];
  ```
- Line 148: name
  ```
  OutFile=fullfile(OutDir,filename);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/Run.m**

- Line 24: name
  ```
  DataFileName='observedpolicydata';
  ```
- Line 26: name
  ```
  Observedpolicy(DataFileName,InDir,OutDir,thetahat,r,nZC,nRC,nZY,nRY,nZP,s,ci)
  ```
- Line 29: lat, name
  ```
  DataFileName='simulationdata';
  ```
- Line 30: name
  ```
  OutFileName='counterfactualpolicy.raw';
  ```
- Line 34: name
  ```
  Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,
  ```
- Line 37: name
  ```
  DataFileName='observedpolicydata';
  ```
- Line 41: name
  ```
  Observedpolicy(DataFileName,InDir,OutDir,thetehatdraws(ci,:)', ...
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/dataprepare.m**

- Line 1: name
  ```
  function [id,t,x,p,ZC,R,ZP,ZY,RY,pcf,wgt,T,F,Fcf,v]=dataprepare(Dir,DataFileName,...
  ```
- Line 4: name
  ```
  p=append(DataFileName,'.raw');
  ```
- Line 6: lat
  ```
  population=load(DataFile);
  ```
- Line 8: lat
  ```
  id=population(:,1);
  ```
- Line 9: lat
  ```
  t=population(:,2);
  ```
- Line 11: lat
  ```
  x=population(:,3);
  ```
- Line 12: lat
  ```
  p=population(:,4:5);
  ```
- Line 14: lat
  ```
  ZC=population(:,6:5+nZC);
  ```
- Line 15: lat
  ```
  ZY=population(:,6:5+nZY);
  ```
- Line 16: lat
  ```
  ZP=population(:,6:5+nZP);
  ```
- Line 19: lat
  ```
  R=population(:,s+1:s+nRC);
  ```
- Line 20: lat
  ```
  RY=population(:,s+1:s+nRY);
  ```
- Line 23: lat
  ```
  pcf=population(:,s+1);
  ```
- Line 24: lat
  ```
  wgt=population(:,s+2)./mean(population(:,s+2));
  ```
- Line 25: lat
  ```
  T=population(:,s+3);
  ```
- Line 26: lat
  ```
  F=population(:,s+4);
  ```
- Line 27: lat
  ```
  Fcf=population(:,s+5);
  ```
- Line 29: lat
  ```
  v=population(:,s+6);
  ```
- Line 31: lat
  ```
  v=[ones(size(id)) population(:,s+6:end)];
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations/firstbest.m**

- Line 11: lat
  ```
  %Initialize proportional loss based on constant flat transfer
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Counterfactualpolicy.m**

- Line 8: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
  ```
- Line 242: name
  ```
  OutFile=fullfile(OutDir,OutFileName);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/MPCE.m**

- Line 4: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,Inc]=dataprepare(InDir,DataFileName,...
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Observedpolicy.m**

- Line 4: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,Inc]=dataprepare(InDir,DataFileName,...
  ```
- Line 146: name
  ```
  filename =[ 'confidenceinterval', int2str(ci), '.raw'];
  ```
- Line 148: name
  ```
  OutFile=fullfile(OutDir,filename);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/Run.m**

- Line 24: name
  ```
  DataFileName='observedpolicydata';
  ```
- Line 26: name
  ```
  Observedpolicy(DataFileName,InDir,OutDir,thetahat,r,nZC,nRC,nZY,nRY,nZP,s,ci)
  ```
- Line 29: lat, name
  ```
  DataFileName='simulationdata';
  ```
- Line 30: name
  ```
  OutFileName='counterfactualpolicy.raw';
  ```
- Line 34: name
  ```
  Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,
  ```
- Line 37: name
  ```
  % DataFileName='observedpolicydata';
  ```
- Line 41: name
  ```
  %     Observedpolicy(DataFileName,InDir,OutDir,thetehatdraws(ci,:)', ...
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/dataprepare.m**

- Line 1: name
  ```
  function [id,t,x,p,ZC,R,ZP,ZY,RY,pcf,wgt,T,F,Fcf,v]=dataprepare(Dir,DataFileName,...
  ```
- Line 4: name
  ```
  p=append(DataFileName,'.raw');
  ```
- Line 6: lat
  ```
  population=load(DataFile);
  ```
- Line 8: lat
  ```
  id=population(:,1);
  ```
- Line 9: lat
  ```
  t=population(:,2);
  ```
- Line 11: lat
  ```
  x=population(:,3);
  ```
- Line 12: lat
  ```
  p=population(:,4:5);
  ```
- Line 14: lat
  ```
  ZC=population(:,6:5+nZC);
  ```
- Line 15: lat
  ```
  ZY=population(:,6:5+nZY);
  ```
- Line 16: lat
  ```
  ZP=population(:,6:5+nZP);
  ```
- Line 19: lat
  ```
  R=population(:,s+1:s+nRC);
  ```
- Line 20: lat
  ```
  RY=population(:,s+1:s+nRY);
  ```
- Line 23: lat
  ```
  pcf=population(:,s+1);
  ```
- Line 24: lat
  ```
  wgt=population(:,s+2)./mean(population(:,s+2));
  ```
- Line 25: lat
  ```
  T=population(:,s+3);
  ```
- Line 26: lat
  ```
  F=population(:,s+4);
  ```
- Line 27: lat
  ```
  Fcf=population(:,s+5);
  ```
- Line 29: lat
  ```
  v=population(:,s+6);
  ```
- Line 31: lat
  ```
  v=[ones(size(id)) population(:,s+6:end)];
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/SimulationsSynthetic/firstbest.m**

- Line 11: lat
  ```
  %Initialize proportional loss based on constant flat transfer
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/Counterfactualpolicyincadj.m**

- Line 7: name
  ```
  [id,t,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
  ```
- Line 140: name
  ```
  OutFile=fullfile(OutDir,OutFileName);
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/RevEffect.m**

- Line 24: name
  ```
  [id,~,xS,p,Z,R,IP,ZY,RY,pNS,weight,T,F,Fcf,v]=dataprepare(InDir,DataFileName,...
  ```
- Line 55: house
  ```
  hhw = zeros(size(unique_ids)); % For household weights
  ```
- Line 56: house
  ```
  ww = zeros(size(id)); % For within-household weights
  ```
- Line 57: loc
  ```
  inc = zeros(size(unique_ids)); % Preallocate for inc
  ```
- Line 61: house
  ```
  hhw(i) = sum(weight(id == individual_id)); % Sum weight for each household
  ```
- Line 69: house
  ```
  hhw=hhw./sum(hhw);  %Normalize household weights (sum to 1)
  ```
- Line 105: lat
  ```
  % Calculate L and inc for each individual
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/RunAppendix.m**

- Line 4: lat
  ```
  addpath(fullfile(fileparts(pwd), 'Simulations'));
  ```
- Line 24: lat, name
  ```
  DataFileName='simulationdata';
  ```
- Line 27: name
  ```
  OutFileName='sensitivity1.raw';
  ```
- Line 31: name
  ```
  Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,
  ```
- Line 34: name
  ```
  OutFileName='sensitivity2.raw';
  ```
- Line 38: name
  ```
  Counterfactualpolicy(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s,maxs,sensitivity,
  ```
- Line 41: lat, name
  ```
  DataFileName='simulationdata';
  ```
- Line 42: name
  ```
  OutFileName='counterfactualpolicy_incadj.raw';
  ```
- Line 43: name
  ```
  Counterfactualpolicyincadj(DataFileName,OutFileName,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)
  ```
- Line 46: lat, name
  ```
  DataFileName='simulationdata';
  ```
- Line 49: name
  ```
  RevEffect(DataFileName,SPFile,OSFile,InDir,OutDir,r,nZC,nRC,nZY,nRY,nZP,s)
  ```

**/replication-package/ReplicationPackage/Programs/5.modelSimulations/Simulations_Appendix/sensitivityanalysis.m**

- Line 20: city
  ```
  %Mean response elasticity at true parameters
  ```
- Line 34: city
  ```
  %Verying adjusted elasticity is approximate half or double original one
  ```

**/replication-package/ReplicationPackage/Programs/_GLOBALS.do**

- Line 34: house
  ```
  global HH   "28.4"         //No. of households
  ```
- Line 35: house
  ```
  global S    "6*28.4/1000"  //No. of households*6 months
  ```

**/replication-package/ReplicationPackage/Programs/master.do**

- Line 72: lat
  ```
  ** 5. POLICY SIMULATIONS
  ```
- Line 73: lat
  ```
  do "5.modelSimulations/0.preparesimulation.do"
  ```
- Line 75: lat
  ```
  cd "$progsdir/5.modelSimulations/Simulations"
  ```
- Line 79: lat
  ```
  cd "$progsdir/5.modelSimulations/SimulationsSynthetic"
  ```
- Line 86: lat
  ```
  do "5.modelSimulations/1.observedpolicy.do"
  ```
- Line 87: lat
  ```
  do "5.modelSimulations/2.counterfactualpolicy.do"
  ```
- Line 88: lat
  ```
  do "5.modelSimulations/3.observedpolicyCI.do"
  ```
- Line 89: lat
  ```
  do "5.modelSimulations/4.tablesfigures.do"
  ```
- Line 93: lat
  ```
  cd "$progsdir/5.modelSimulations/SimulationsSynthetic"
  ```
- Line 97: lat
  ```
  do "5.modelSimulations/A1.welfareweights.do"
  ```
- Line 99: lat
  ```
  do "5.modelSimulations/A2.pricesensitivity.do"
  ```
- Line 101: lat
  ```
  do "5.modelSimulations/A2.pricesensitivity.do"
  ```
- Line 102: lat
  ```
  do "5.modelSimulations/A3.incomeoffset.do"
  ```
- Line 103: lat
  ```
  do "5.modelSimulations/A4.revenuemin.do"
  ```
- Line 104: lat, social
  ```
  do "5.modelSimulations/A5.socialpreferences.do"
  ```
- Line 105: lat
  ```
  do "5.modelSimulations/A6.tablesfigures.do"
  ```

**/replication-package/ReplicationPackage/Programs/synthetic_data_generator.do**

- Line 4: house
  ```
  **   "The Welfare Effects of Price Shocks and Household Relief Packages:
  ```
- Line 28: minute
  ```
  ** RUN TIME: approximately 5-10 minutes on a standard workstation.
  ```
- Line 37: loc
  ```
  local N_users = 5000   // synthetic users (real: ~244,000)
  ```
- Line 38: loc
  ```
  local pp_shr  = 0.25   // prepayment meter share (paper: 24.8%)
  ```
- Line 39: loc
  ```
  local vdd_shr = 0.065  // variable direct debit share (paper: 6.3%)
  ```
- Line 43: loc, lon
  ```
  local ofgem_regions `" "East England" "East Midlands" "London" "North Wales / Cheshire" "West Midlan
  ```
- Line 76: city
  ```
  ** ~35% had EBSS credited directly to their electricity bill ("credit" subsample, ebss_cash=0).
  ```
- Line 80: lat
  ```
  ** Government Office Region — approximate population-weighted shar
  ```
- Line 90: lon
  ```
  replace gor =  7 if u_gor >= 0.461  & u_gor < 0.617        // London         15.6%
  ```
- Line 97: lon
  ```
  4 "East Midlands" 5 "West Midlands" 6 "East" 7 "London" ///
  ```
- Line 111: lon
  ```
  replace ofgem_region = "London"                  if gor == 7
  ```
- Line 129: house
  ```
  ** Prepay households skew younger and lower income (consistent with paper)
  ```
- Line 132: sex
  ```
  gen sex = (runiform() < 0.5)
  ```
- Line 133: sex
  ```
  label define sex 0 "Male" 1 "Female", replace
  ```
- Line 134: sex
  ```
  label values sex sex
  ```
- Line 143: district
  ```
  gen postcode_district = "SW" + string(mod(_n, 9) + 1)
  ```
- Line 147: name
  ```
  gen laname    = gor * 100 + floor(runiform() * 10)
  ```
- Line 153: lat
  ```
  ** Energy spending is weakly positively correlated with income: β≈0.32 gi
  ```
- Line 159: lat
  ```
  gen u_nondur      = u_inc + rnormal(-0.55, 0.20)  // correlated with income
  ```
- Line 188: lat
  ```
  ** Pin a unique, platform-independent row order before any further random
  ```
- Line 198: birth
  ```
  ** Date of birth
  ```
- Line 199: dob
  ```
  gen doby = 2021 - age_2021
  ```
- Line 200: dob
  ```
  gen dobm = ceil(runiform() * 12)
  ```
- Line 201: dob
  ```
  gen dob  = ym(doby, dobm)
  ```
- Line 202: dob
  ```
  format dob %tm
  ```
- Line 234: city
  ```
  keepusing(cpi cpi_food cpi_energy cpi_electricity cpi_gas cpi_nondur_excenergy) ///
  ```
- Line 237: name
  ```
  rename cpi cpi_allitems
  ```
- Line 238: city
  ```
  gen cpi_elec = cpi_electricity   // step5 has both cpi_electricity and cpi_elec
  ```
- Line 268: lat
  ```
  **   as incremental spending — the rest accumulates as unused meter credi
  ```
- Line 272: loc
  ```
  local pp_fly_amt = 0.34 * 0.90 * 66.66   // ≈ 20
  ```
- Line 289: lat
  ```
  ** guaranteed identical across platforms/Stata flavors. userref x yrmn is unique.
  ```
- Line 314: house
  ```
  ** Heterogeneous price index (prepay households face small premium historically)
  ```
- Line 326: city
  ```
  ** This implies a finite-change quantity elasticity of -0.33 for the
  ```
- Line 328: city
  ```
  ** Δq/q = exp(-0.160)-1 ≈ -14.8%, elasticity = -14.8%/45% ≈ -
  ```
- Line 329: lat
  ```
  ** Noise σ=0.35 gives one-year autocorrelation ≈ 0.55 pooled, wh
  ```
- Line 330: son
  ```
  ** combined with seasonal repetition brings AC(12) near the paper's 0.74.
  ```
- Line 332: son
  ```
  + 0.30 * cos(2 * _pi * (month - 1) / 12)  ///  seasonal
  ```
- Line 369: lat
  ```
  ** Nondurables: correlated with income
  ```
- Line 411: child
  ```
  gen children    = (runiform() < 0.28)
  ```
- Line 413: child
  ```
  replace numchld = ceil(runiform() * 3) if children == 1
  ```
- Line 430: phone
  ```
  gen amount_out_phonetv    = max(exp(rnormal(log(55),  0.30)), 5)
  ```
- Line 436: son
  ```
  gen amount_out_personal   = max(exp(rnormal(log(28),  0.60)), 1)
  ```
- Line 439: child
  ```
  gen amount_out_childcare  = numchld * max(rnormal(180, 50), 0)
  ```
- Line 518: son
  ```
  ** One-month event-study indicators (GB vs NI comparison)
  ```
- Line 556: sex
  ```
  gen msexp = mshr_e
  ```
- Line 591: sex
  ```
  xtile sexp_p    = mshr_e, nq(100)
  ```
- Line 592: sex
  ```
  xtile sexp_dec  = mshr_e, nq(10)
  ```
- Line 593: sex
  ```
  xtile sexp_quint = mshr_e, nq(5)
  ```
- Line 656: loc
  ```
  local x = `r(mean)'
  ```
- Line 658: loc
  ```
  local y = `r(mean)'
  ```
- Line 665: lat
  ```
  sa "$dataProcess/population_weights.dta", replace
  ```
- Line 671: son
  ```
  ** Step6 = step5 with fewer variables + deseasonalised log-expenditure measures.
  ```
- Line 672: son
  ```
  ** The deseasonalisation uses xtreg with month dummies on 2019-2020 data;
  ```
- Line 680: house
  ```
  ** sc_monthly: card payment households with monthly frequency
  ```
- Line 704: sex
  ```
  sample inc_quint eexp_quint sexp_quint ofgem_region ;
  ```
- Line 748: son
  ```
  ** DESEASONALISATION (mirrors 8.analysis.do lines 612-626)
  ```
- Line 815: lat
  ```
  ** Approximate population count (equal within cells for synthetic data)
  ```
- Line 837: name
  ```
  rename energy_supplier1 energy_supplier
  ```
- Line 838: name
  ```
  rename mode1             mode
  ```
- Line 839: name
  ```
  rename amount1           amount
  ```
- Line 840: name
  ```
  rename amount_energy_credit1 amount_energy_credit
  ```
- Line 841: name
  ```
  rename likely_pp1        likely_pp
  ```
- Line 842: name
  ```
  rename ntrans1           ntrans
  ```
- Line 843: name
  ```
  rename direct_debit1     direct_debit
  ```
- Line 844: name
  ```
  rename variable_slack1   variable_slack
  ```
- Line 845: name
  ```
  rename variable_semistrict1 variable_semistrict
  ```
- Line 846: name
  ```
  rename variable_strict1  variable_strict
  ```
- Line 847: name
  ```
  rename EBSS_refund1      EBSS_refund
  ```
- Line 848: name
  ```
  rename EBSS_everrefund1  EBSS_everrefund
  ```
- Line 849: name
  ```
  rename freq_monthly1     freq_monthly
  ```
- Line 850: name
  ```
  rename freq_quarterly1   freq_quarterly
  ```
- Line 874: child
  ```
  ** values such as onbenefits/children) is chosen deterministically.
  ```
- Line 877: child
  ```
  sample onbenefits children mshr_e ///
  ```
- Line 881: sex
  ```
  sexp_p sexp_dec sexp_quint mshr_e_quart
  ```
- Line 883: name
  ```
  ** Rename to match heterogeneity_measures variable names
  ```
- Line 884: name
  ```
  rename mtot_in_excltrans_quart     mtot_in_excltrans_quart
  ```
- Line 885: name
  ```
  rename mexp_energy_t_reb_quart     mexp_energy_t_reb_quart
  ```
- Line 886: name
  ```
  rename mtot_out_nondurab_p         mtot_out_nondurab_p
  ```
- Line 893: child
  ```
  ** max of onbenefits and children over time (already collapsed to user-level)
  ```
- Line 918: sex
  ```
  gen sexp   = mshr_e
  ```
- Line 941: sex
  ```
  inc_quint sexp sexp_p sexp_dec sexp_quint               ///
  ```
- Line 965: house
  ```
  ** LCFS: annual cross-section 2013-2021, ~10,000 households/year
  ```
- Line 966: loc
  ```
  local lcfs_n = 80000   // ~10k per year × 8 years (2013-2020, main years used
  ```
- Line 996: sex
  ```
  gen sex    = (runiform() < 0.5)
  ```
- Line 1014: lat
  ```
  ** Income and spending (deflated to Dec 2022 = 1)
  ```
- Line 1036: phone
  ```
  gen exp_phonetv   = max(exp(rnormal(log(55),  0.30)), 5)
  ```
- Line 1039: son
  ```
  gen exp_personal  = max(exp(rnormal(log(28),  0.60)), 1)
  ```
- Line 1040: child
  ```
  gen exp_childcare = numhhkid * max(rnormal(150, 50), 0)
  ```
- Line 1050: city
  ```
  keepusing(cpi cpi_food cpi_energy cpi_electricity cpi_gas cpi_nondur_excenergy) ///
  ```
- Line 1052: name
  ```
  rename cpi cpi_allitems
  ```
- Line 1055: house
  ```
  ** so the random draws that follow map to households identically across
  ```
- Line 1056: lat
  ```
  ** platforms. hhref is unique.
  ```
- Line 1076: sex
  ```
  gen pensingm  = (pens & sex == 0 & numadmal == 1 & numadfem == 0)
  ```
- Line 1077: sex
  ```
  gen pensingf  = (pens & sex == 1 & numadmal == 0 & numadfem == 1)
  ```
- Line 1080: sex
  ```
  gen male       = (sex == 0)
  ```
- Line 1081: lon
  ```
  gen lone       = (numadmal + numadfem == 1)
  ```
- Line 1197: mother
  ```
  gen famother   = 1 - famcoup - famsingm - famsingf
  ```

