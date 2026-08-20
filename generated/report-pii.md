## Potential Personal Identifiable Information (PII)

⚠️ We found the following instances of potentially personally identifying information. This may be completely legitimate but might be worth checking. *As a reminder, privacy legislation in many countries (e.g. GDPR in EU) prohibits the dissemination of personal identifiable information without prior (and documented) consent of individuals.* If indeed you want to publish such information with your replication package, you should probably have obtained IRB approval for this - please check!

**Summary:**
- Data files with PII indicators: 0
- Variables flagged in data: 0
- Code files with PII references: 62
- PII references in code: 1005

### Summary of Flagged Files

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
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
| Code | `Run.m` | 7 | name, lat |
| Code | `Run.m` | 7 | name, lat |
| Code | `Run.m` | 29 | name, city |
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

*See [Appendix](report-pii-appendix.md) for detailed listing of all flagged instances.*
