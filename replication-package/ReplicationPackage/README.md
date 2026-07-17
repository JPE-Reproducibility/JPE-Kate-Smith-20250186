# Replication Package

## "The Welfare Effects of Price Shocks and Household Relief Packages: Evidence from an Energy Crisis"

**Peter Levell, Martin O'Connell and Kate Smith**  
*Journal of Political Economy*, 2026

---

## Overview

This replication package contains all programs required to reproduce the tables and figures in the paper and its online appendix. The analysis uses two types of input data: (i) publicly available data on energy prices, macroeconomic aggregates, weather, and household surveys; and (ii) a proprietary dataset of bank transaction records (ExactOne) from Clear Score Technology Ltd. that is not publicly available.

- **`Programs/`** contains the full code used to produce the results in the paper. Because the ExactOne data cannot be shared, the package takes a two-track approach:
- setting synthetic=1 (line 9 of master.do) leads to a fully self-contained replication path that runs end-to-end using a synthetic data generator in place of the restricted ExactOne records. All public data inputs are included. The MATLAB estimation and simulation steps are also automated. Output tables and figures will be produced but the results will not numerically match those in the paper.
- setting synthetic=0 leads to a replication path that produces the results in the paper, including all data preparation steps that operate on the restricted ExactOne data. This path cannot be run without access to the restricted datasets (see Data Availability section).

Pre-computed MATLAB outputs from the restricted-data run are included in `dataInput/dataAnalysis/`. These are the outputs that underlie the paper's results tables and figures, and they are used by `Programs/master.do` in the policy simulation stage (Stage 5).

---

## Data Availability and Provenance

### Summary

| Dataset | Availability | Location in package |
|---|---|---|
| ExactOne bank transaction data | **Not publicly available** — apply to Clear Score Technology Ltd | Not included |
| Living Costs and Food Survey (LCFS) | Safeguarded — apply via UK Data Service | Not included |
| ONS CPI microdata | Publicly available  |  `dataInput/dataRaw/`  |
| ONS CPI (energy prices and overall index) | Publicly available  | `dataInput/dataRaw/downloaded/`  |
| ONS population data | Publicly available | `dataInput/dataRaw/downloaded/` |
| Ofgem price cap data | Publicly available | `dataInput/dataRaw/downloaded/` |
| BEIS energy unit cost and expenditure data | Publicly available | `dataInput/dataRaw/downloaded/` |
| Met Office weather data | Publicly available | `dataInput/dataRaw/` |
| ONS consumer trends (energy quantities) | Publicly available | `dataInput/dataRaw/downloaded/` |
| ONS geographic lookup files | Publicly available from https://geoportal.statistics.gov.uk/ | `dataInput/dataRaw/downloaded/` |
| Pre-computed MATLAB outputs | Derived from restricted data; included | `dataInput/dataAnalysis/` |

Processed intermediate datasets derived from the restricted ExactOne and LCFS data are not included. Researchers with access to those underlying datasets can regenerate these files by running `Programs/2.setupData/` (see Instructions below).

Formal data citations for each source are listed under **Data Citations** at the end of this section.

### Data Descriptions

**ExactOne bank transaction data ("ExactOne").** A proprietary dataset of anonymised current account bank transaction records for a large sample of UK households, covering January 2019–December 2023. The dataset identifies energy payments, amounts, payment method (prepayment, direct debit, card payment), income, and a broad range of non-energy expenditure categories. The data are held by Clear Score Technology Ltd and shared with the Institute for Fiscal Studies with a non-disclosure agreement. Clear Score can be contacted at
Email: help@clearscore.com 
Address: Clear Score Technology Limited, Vox Studios, VG 203, 1-45 Durham Street, London, SE11 5JHS, UNITED KINGDOM. 

**Living Costs and Food Survey (LCFS).** Annual cross-sectional survey of household expenditure, income, and demographics, covering 2001–2021. Accessed via the UK Data Service (the IFS derived LCFS files SN 8583). Access requires UKDS registration and is subject to their End User Licence agreement. Researchers in and outside the UK can register an account with the UKDS using their institutional email address, create a project (with a short description of the intended purpose), add these datasets to a project and then download the data. 

**ONS CPI.** All-items Consumer Price Index for the UK from the ONS (series D7BT). The CPI sub-index for energy is series DK9U. These data are saved in `dataInput/dataRaw/downloaded/cpi.xlsx`.

**ONS CPI microdata.** Item-level price index data from the ONS Consumer Prices Indices microdata research service. Used to construct a non-durable goods price index excluding energy. This data is downloadable from the ONS at https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes. Stata files of this data are saved in `dataInput/dataRaw/downloaded/cpiitemindices` and the output is saved as `dataInput/dataRaw/cpinondurables_exenergy.dta`.

**ONS Population data.** This provides UK population estimates by age band and region used to construct population weight for 2021. Downloaded from https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland. Stored as `dataInput/dataRaw/downloaded/ukpopestimatesmid2021on2021geographyfinal`.

**Ofgem price cap data.** Unit rates, standing charges, and cap levels for electricity and gas by payment method and Ofgem region, April 2015 onwards. Energy Price Guarantee (EPG) rates from BEIS/DESNZ. Downloaded from https://www.ofgem.gov.uk/check-if-energy-price-cap-affects-you. Stored as `availabletariffs_Ofgem.xlsx` and `Default_tariff_cap_level_v1.20.xlsx` and `EPGrates.xlsx` in `dataInput/dataRaw/downloaded/`.

**BEIS energy unit cost and expenditure data.** Regional average unit costs for gas and electricity from BEIS downloaded from https://www.gov.uk/government/statistical-data-sets/annual-domestic-energy-price-statistics ``Average unit costs and fixed costs for electricity for UK regions (QEP 2.2.4)'' and ``Average unit costs and fixed costs for gas for GB regions (QEP 2.3.4)''. Stored as `beis_averageunitcosts_elec.xlsx` and `beis_averageunitcosts_gas.xlsx` in `dataInput/dataRaw/downloaded/`. 

**Department for Energy Security and Net Zero data.** Quarterly consumption of electricity and gas downloaded from UK Energy Trends available at https://www.gov.uk/government/statistics/energy-trends-june-2024. Stored in `dataInput/dataRaw/downloaded/energyquantities.xlsx`.

**Met Office weather data.** Monthly temperature (min, max, mean), rainfall, and humidity by Lower Super Output Area (LSOA), 2018–2023. This is taken from the HADUK-Grid dataset (ids: tasmax, tasmin, tas, rainfall and hurs). This data has been processed and assigned to lower super output areas to merge with the ExactOne data  by the files in 1.setupWeather.R. Stored in `dataInput/dataRaw/` as `humidityXXXX.csv`, `rainfallXXXX.csv`,`tempavXXXX.csv`,`tempmaxXXXX.csv` and `tempminXXXX.csv`.

**Geographic lookup files.** Postcode-district-to-Ofgem-region lookup table. Stored as `dataInput/dataRaw/downloaded/postcodedistricts2ofgemregions_expanded.csv`. 

**ONS Consumer trends data.** ONS consumer expenditure series (series ZWUQ) taken from https://www.ons.gov.uk/economy/nationalaccounts/satelliteaccounts/timeseries/zwuq/ct. The data on the web may change as the ONS periodically revises its methodology. The data we used is stored in `dataInput/dataRaw/downloaded/` as `energyspend_consumertrends_elec_nsa.xlsx`, `energyspend_consumertrends_elec_sa.xlsx`, `energyspend_consumertrends_ener_nsa.xlsx`, `energyspend_consumertrends_ener_sa.xlsx`,`energyspend_consumertrends_gas_nsa.xlsx`, and `energyspend_consumertrends_gas_sa.xlsx`.

**Pre-computed MATLAB outputs.** The `.raw` files in `dataInput/dataAnalysis/` are the outputs of the MATLAB estimation (Stage 4) and policy simulation (Stage 5) steps, produced using the restricted ClearScore data. They include GMM coefficient estimates, 100 bootstrap draws used for confidence intervals, and policy simulation results. These files are included so that the Stata post-processing steps (which produce the paper's tables and figures) can be run without re-estimating the model.

### Data Citations

- Clear Score Technology Ltd. *ExactOne current account bank transaction records, January 2019–December 2023* [restricted-access dataset]. Provided to the Institute for Fiscal Studies under a Data Processing Agreement. Not publicly available.
- Office for National Statistics. *Living Costs and Food Survey* [data collection], IFS-derived files. UK Data Service, SN 8583. Distributed by the UK Data Service under an End User Licence. [accessed: 10/12/2025].
- Office for National Statistics. *Consumer Price Inflation time series* — all-items CPI (series D7BT) and energy sub-index (series DK9U). ONS. [accessed: 10/3/2024].
- Office for National Statistics. *Consumer price indices (CPI and RPI) item indices and price quotes* [microdata]. ONS. https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes. [accessed: 10/3/2024].
- Office for National Statistics. *Population estimates for the UK, England and Wales, Scotland and Northern Ireland, mid-2021.* ONS. https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland. [accessed: 6/8/2023].
- Ofgem. *Energy price cap: unit rates, standing charges and cap levels* (with Energy Price Guarantee rates from BEIS/DESNZ). Ofgem. https://www.ofgem.gov.uk/check-if-energy-price-cap-affects-you. [accessed: 5/14/2024].
- Department for Business, Energy and Industrial Strategy. *Annual domestic energy price statistics* — average unit and fixed costs for electricity (QEP 2.2.4) and gas (QEP 2.3.4). BEIS. https://www.gov.uk/government/statistical-data-sets/annual-domestic-energy-price-statistics. [accessed: 5/21/2023].
- Department for Energy Security and Net Zero. *Energy Trends: June 2024* — quarterly electricity and gas consumption. DESNZ. https://www.gov.uk/government/statistics/energy-trends-june-2024. [accessed: 6/19/2024].
- Met Office; Hollis, D.; McCarthy, M.; et al. *HadUK-Grid gridded climate observations* (variables tasmax, tasmin, tas, rainfall, hurs), 2018–2023. Met Office / Centre for Environmental Data Analysis (CEDA). [accessed: 9/17/2025].
- Office for National Statistics / Open Geography Portal. *Geographic lookup files* (postcode-district to Ofgem-region). Contains OS data © Crown copyright and database right. https://geoportal.statistics.gov.uk/. [accessed: 5/14/2022].
- Office for National Statistics. *Consumer trends: household final consumption expenditure* (series ZWUQ). ONS. https://www.ons.gov.uk/economy/nationalaccounts/satelliteaccounts/timeseries/zwuq/ct. [accessed: 4/24/2024].

---

## Statement of Rights

The authors of this paper had legitimate access to and permission to use all underlying data. The ExactOne data were accessed under a Data Processing Agreement between the Institute for Fiscal Studies and Clear Score Technology Ltd. The LCFS were used under a registered research project via the UK Data Service.

---

## License

The **code** in this package is released under the **BSD 3-Clause License** (see the `LICENSE` file in the package root).

Data are governed by separate terms:

- **Publicly available data** redistributed in `dataInput/dataRaw/` (ONS, Ofgem, BEIS/DESNZ, and Met Office sources) are used under the **UK Open Government Licence v3.0**. Attribution: "Contains public sector information licensed under the Open Government Licence v3.0." The ONS geographic lookup files additionally contain Ordnance Survey data © Crown copyright and database right, and the Met Office HadUK-Grid data are cited as required by the Met Office / CEDA.
- **Synthetic data** produced by `Programs/synthetic_data_generator.do`, and other author-created files, are released under the **Creative Commons Attribution 4.0 International (CC-BY-4.0)** licence.
- The restricted **ExactOne** (Clear Score Technology Ltd) and **LCFS** (UK Data Service, SN 8583) data are **not redistributed** in this package and remain subject to the terms of their respective providers.

---

## Software Requirements

- **Stata** version 18 or later (used for all data preparation, descriptive analysis, and post-processing of model outputs)
  - Non-standard packages (installed automatically by `master.do`): `binscatter`, `cdfplot`, `cleanplots`, `coefplot`, `confirmdir`, `distinct`, `estout`, `labutil`, `listtab`, `numdate`

- **MATLAB** R2024b (used for GMM estimation and policy simulations; called automatically from `master.do` via `shell`)
  - Required toolbox: Optimization Toolbox
  - The path to the MATLAB executable must be set in `Programs/master.do` (see Step 1 below)

- **R** version 4.4.3 (used only on the restricted-data path, synthetic=0, to process raw Met Office weather data; called from `master.do` via `shell`)
  - Required packages: `tidyverse`, `sf`, `readxl`
  - The path to the R executable must be set in `Programs/master.do` (see Step 1 below)
  - Not required for the synthetic-data path (Option A), which reads pre-processed weather files from `dataInput/dataRaw/`

- **Approximate run time (synthetic data path):** Under 1 hour for Stages 2–3 (public data setup and descriptive results) on a standard workstation. Under 1 hour for MATLAB estimation (Stage 4) and simulations (Stage 5). The synthetic data generator itself runs in 5–10 minutes.

- **Storage:** The synthetic panel dataset is approximately 300 MB. Total working storage required is under 5 GB.

---

## Directory Structure

```
ReplicationPackage/
├── README.md                              This file
│
├── Programs/                              All code for both replication paths
│   ├── master.do                          Master script — set global working here (line 3)
│   ├── _GLOBALS.do                        Remaining path and parameter definitions
│   │                                        set global matlab here (last line)
│   ├── synthetic_data_generator.do        Generates synthetic ClearScore and LCFS data
│   ├── 0.setupRawData/                    Raw data extraction (requires restricted data)
│   ├── 1.setupWeatherR/                   R scripts for weather data (requires raw Met Office data)
│   │   └── metofficedata
│   ├── 2.setupData/                       Data cleaning and setup 
│   │   ├── 0.cpi.do
│   │   ├── 1.importenergypricecap.do
│   │   ├── 2.BEISMacroData.do
│   │   ├── 3.LCFS.do
│   │   ├── 4.weights.do
│   │   ├── 5a.appendCSenergy.do
│   │   ├── 5b.appendCSallspending.do
│   │   ├── 6.insheetweatherprices.do
│   │   ├── 7.samples.do
│   │   ├── 8.analysis.do
│   │   └── 9.model.do
│   ├── 3.descriptiveResults/
│   │   ├── 1.summarystats.do
│   │   ├── 2.macrotrends.do
│   │   ├── 3.describepricecap.do
│   │   ├── 4.exposure.do
│   │   ├── 5.priceresponse.do
│   │   └── 6.MPCs.do
│   ├── 4.modelEstimates/
│   │   ├── 0.prepareestimation.do
│   │   ├── 1.coefficients.do
│   │   ├── 2.modelfit.do
│   │   └── Estimation/                    MATLAB GMM estimation — set working here
│   │       ├── dataprepareestimate.m
│   │       ├── EngelCurves.m
│   │       ├── Estimate.m
│   │       ├── GMM.m
│   │       ├── GMMobj.m
│   │       ├── Hicksian.m
│   │       ├── Holdout.m
│   │       ├── Marshallian.m
│   │       ├── momder.m
│   │       ├── parammap.m
│   │       ├── Priceeffects.m
│   │       ├── Restrictions.m
│   │       ├── standarderrors.m
│   │       └── Run.m
│   └── 5.modelSimulations/
│       ├── 0.preparesimulation.do
│       ├── 1.observedpolicy.do
│       ├── 2.counterfactualpolicy.do
│       ├── 3.observedpolicyCI.do
│       ├── 4.tablesfigures.do
│       ├── A1.welfareweights.do
│       ├── A2.pricesensitivity.do
│       ├── A3.incomeoffset.do
│       ├── A4.revenuemin.do
│       ├── A5.socialpreferences.do
│       ├── A6.tablesfigures.do
│       ├── Simulations/                    MATLAB policy simulations — set working here
│       │   ├── Behavioural.m
│       │   ├── Classical.m
│       │   ├── CompVar.m
│       │   ├── Counterfactualpolicy.m
│       │   ├── dataprepare.m
│       │   ├── drawcoefficients.m
│       │   ├── equivpubliccost.m
│       │   ├── equivrebate.m
│       │   ├── equivtransfer.m
│       │   ├── firstbest.m
│       │   ├── Hicksian.m
│       │   ├── Marshallian.m
│       │   ├── Marshbehave.m
│       │   ├── MPCE.m
│       │   ├── Observedpolicy.m
│       │   ├── parammap.m
│       │   ├── rebatesort.m
│       │   └── Run.m
│       ├── Simulations_Appendix/           MATLAB appendix simulations 
│       │   ├── Counterfactualpolicyincadj.m
│       │   ├── equivpubliccostincadj.m
│       │   ├── incomeadjustment.m
│       │   ├── RevEffect.m
│       │   ├── sensitivityadjustment.m
│       │   ├── sensitivityanalysis.m
│       │   ├── Wdiff.m
│       │   └── RunAppendix.m
│       └── SimulationsSynthetic/           MATLAB policy simulations — set working here (synthetic run)
│           ├── Behavioural.m
│           ├── Classical.m
│           ├── CompVar.m
│           ├── Counterfactualpolicy.m
│           ├── dataprepare.m
│           ├── drawcoefficients.m
│           ├── equivpubliccost.m
│           ├── equivrebate.m
│           ├── equivtransfer.m
│           ├── firstbest.m
│           ├── Hicksian.m
│           ├── Marshallian.m
│           ├── Marshbehave.m
│           ├── MPCE.m
│           ├── Observedpolicy.m
│           ├── parammap.m
│           ├── rebatesort.m
│           └── Run.m
│
├── dataInput/
│   ├── dataRaw/                           Starting raw public data files
│   │   └── downloaded/                    Downloaded source files (Ofgem, BEIS, ONS, etc.)
│   └── dataAnalysis/                      Pre-computed MATLAB outputs from restricted-data run
│
├── dataOutput/
│   ├── dataProcessed/                     Created at run time by 2.setupData programs
│   └── dataAnalysis/                      MATLAB outputs written during synthetic run
│
└── Results/                               Tables and figures
```

---

## Instructions to Replicators

### Option A — Using synthetic data (no access to restricted datasets required)

This is the primary replication path. Running `Programs/master.do` with synthetic=1 (line 9 of master.do) executes all stages from start to finish. The only prerequisites are the starting files already included in `dataInput/`.

**Step 1 — Set the working directory path**

Two files contain a path that must be changed to match your system:

1. **`Programs/master.do`**, line 3-5:
```stata
global working ".../ReplicationPackage/"
global matlab "C:/Program Files/MATLAB/R2024b/bin/matlab.exe"
global R      "C:/Program Files/R/R-4.4.3/bin/R.exe"
```
Change `.../ReplicationPackage/` to the root directory where you have placed the package (use forward slashes and include a trailing slash).
Change `C:/Program Files/MATLAB/R2024b/bin/matlab.exe` and `C:/Program Files/R/R-4.4.3/bin/R.exe` to the full path of your MATLAB and R executable. 

In addition, the MATLAB scripts called by `master.do` each contain a `working` variable near the top that must match:

2. **`Programs/4.modelEstimates/Estimation/Run.m`**
3. **`Programs/5.modelSimulations/SimulationsSynthetic/Run.m`**

Set `working` at the top of each to the same root path as in step 1.

**Step 2 — Run master.do**

Open Stata, then:

```stata
do "YOUR_PATH\Programs\master.do"
```

This runs the following stages in sequence:

| Stage | Programs | Description |
|---|---|---|
| 2a | `2.setupData/0.cpi.do` | CPI series from ONS data |
| 2b | `2.setupData/1.importenergypricecap.do` | Ofgem price cap data |
| 2c | `2.setupData/2.BEISMacroData.do` | BEIS unit costs and macro aggregates |
| 2d | `2.setupData/6.insheetweatherprices.do` | Weather data and unit cost price indices |
| Synth | `synthetic_data_generator.do` | Generates synthetic individual-level datasets |
| 3 | `3.descriptiveResults/1–6.do` | Descriptive tables and figures |
| 4a | `4.modelEstimates/0.prepareestimation.do` | Prepares data for MATLAB estimation |
| 4b | MATLAB: `4.modelEstimates/Estimation/Run.m` | GMM estimation (called via `shell`) |
| 4c | `4.modelEstimates/1.coefficients.do`, `2.modelfit.do` | Coefficient tables and model fit |
| 5a | `5.modelSimulations/0.preparesimulation.do` | Prepares simulation inputs |
| 5b | MATLAB: `5.modelSimulations/SimulationsSynthetic/Run.m` | Policy simulations (called via `shell`) |
| 5c | `5.modelSimulations/1–4.do`, `A1–A6.do` | Welfare tables and figures |

**Notes on the synthetic data run:**

- Synthetic data is generated using the same variable structure as the restricted Clear Score and LCFS data but with randomly drawn values. Output tables and figures will be structurally correct but will not reproduce the paper's numerical results.
- **Reproducibility of the synthetic data.** `synthetic_data_generator.do` fixes both the random-number stream (`set seed`) and the sort ordering (`set sortseed`), and it sorts on unique keys before each block of random draws. This makes the generated synthetic datasets numerically identical across runs, machines, and operating systems (Stata 18+). Note that the resulting `.dta` files are not byte-for-byte identical because Stata embeds a creation timestamp in each file; the data content and all downstream results are identical.
- Weather variables in the synthetic panel use real Met Office data (national monthly averages), not synthetic values.
- The pre-computed MATLAB outputs in `dataInput/dataAnalysis/` are from the restricted-data run. If MATLAB estimation and simulation are run on synthetic data, the resulting `.raw` files will be saved to `dataOutput/dataAnalysis/`. To preserve the paper's results for the Stata post-processing stage, do not overwrite the files in `dataInput/dataAnalysis/` — `master.do` reads the Stata post-processing inputs from that location.
- The MATLAB simulation files contain four modifications made to ensure convergence on synthetic data: (i) a loosened tolerance in the Marshallian demand solver; (ii) a loosened tolerance for computing the first best; (iii) a check to set any imaginary numbers to real numbers when computing the first best; and (iv) `Counterfactualpolicy.m` evaluates a single counterfactual tax rate (39 percent) rather than looping over the full grid used in the paper. These modifications are marked with comments in the relevant `.m` files and have no effect on the paper's results, which are reproduced from the pre-computed outputs. The folder `5.modelSimulations/Simulations` contains the files used to generate the results in the paper. 
- The appendix simulation step (`RunAppendix.m`) is not called from `master.do` as it does not converge reliably on synthetic data. The appendix tables and figures (`A1–A6`) are produced from the pre-computed outputs in `dataInput/dataAnalysis/`, which are read directly by the Stata post-processing files.

---

### Option B — Using restricted data (full replication)

Researchers who obtain access to the ClearScore, LCFS, and ONS CPI microdata can run the full pipeline via `Programs/master.do`, setting synthetic=0.

**Step 1 — Configure paths**

First set the package root, MATLAB, and R paths in `Programs/master.do`, lines 3–5, exactly as in Option A:

```stata
global working "YOUR_PATH/"
global matlab  "C:/.../MATLAB/R2024b/bin/matlab.exe"
global R       "C:/.../R/R-4.4.3/bin/R.exe"
```

In addition, the restricted-data stages read their inputs through the following globals, which are **not** pre-defined in the package and must be set by the researcher (e.g., near the top of `master.do`) to point to the locations of the restricted datasets:

```stata
global dataCS       "PATH_TO_CLEARSCORE_DATA"   // ExactOne bank transaction files (Transaction*, user)
global dataLCFS     "PATH_TO_LCFS_DATA"         // UK Data Service LCFS extract (Demographics/, Expenditure/, FESPcodeIncome/)
global cpipricesdir "PATH_TO_ONS_CPI_MICRODATA" // ONS CPI item indices (itemindices)
global pricesdir    "PATH_TO_ONS_CPI_MICRODATA" // as above, used by the chaining routine
```

Finally, set the `working` path at the top of each MATLAB `Run.m` to the same package root:

- **`Programs/4.modelEstimates/Estimation/Run.m`**
- **`Programs/5.modelSimulations/Simulations/Run.m`** (the restricted-data path uses `Simulations/`, not `SimulationsSynthetic/`)

**Step 2 — Run stages in order**

*Stage 0 — Raw data extraction* (requires ClearScore and ONS CPI microdata):
```stata
do "Programs/0.setupRawData/0.cpimicrodata.do"
```

*Stage 1 — Weather data* (requires R with `tidyverse`, `sf`, `readxl`):  
Run `Programs/1.setupWeatherR/metofficedata.R`.

*Stage 2 — Data preparation* (requires all restricted datasets):
```stata
do "Programs/2.setupData/0.cpi.do"
do "Programs/2.setupData/1.importenergypricecap.do"
// ... through 9.model.do (run files 0–9 in order)
```

*Stages 3–5* are identical to Option A from this point. Run `Programs/master.do` from the Stage 3 section onward, or run programs individually as listed there.

---

## List of Tables and Figures

### Main Paper 

| Output file | Program | Description |
|---|---|---|
| `FIG_energypricecap_epg_cheapest.pdf` | `3.descriptiveResults/3.describepricecap.do` | Figure 2.1: Energy price cap, energy price guarantee and cheapest available pricing plans |
| `FIG_x_ener_Vs_inc_2019_20.pdf` + `FIG_shr_ener_Vs_inc_2019_20.pdf` | `3.descriptiveResults/4.exposure.do` | Figure 3.1: Energy spending across the income distribution |
| `FIG_lx_ds.pdf` | `3.descriptiveResults/5.priceresponse.do` | Figure 4.1: Log energy spending over the crisis |
| `TAB_elas_apr22.tex` + `TAB_elas_apr22_se.tex` + `TAB_qchg_apr22.tex` + `TAB_qchg_apr22_se.tex` | `3.descriptiveResults/5.priceresponse.do` | Table 4.1: Energy price elasticities |
| `FIG_elas_apr22_hom.pdf` | `3.descriptiveResults/5.priceresponse.do` | Figure 4.2: Heterogeneity in energy price elasticities, by pre-shock energy spending and income |
| `FIG_lx_ds_rebates_qtr_PP_realvsfitted.pdf` | `3.descriptiveResults/6.MPCs.do` | Figure 4.3: Energy spending over the transfer period, prepayment households |
| `TAB_MPCrebates_PP.tex` + `TAB_MPCrebates_PP_N.tex` | `3.descriptiveResults/6.MPCs.do` | Table 4.2: Marginal propensity to consume energy out of transfers |
| `FIG_outinsample_exp.pdf` + `FIG_outinsample_inc.pdf` | `4.modelEstimates/2.modelfit.do` | Figure 5.2: Winter energy demand in and out of sample |
| `FIG_Loss_level.pdf` + `FIG_Loss_proportional.pdf` | `5.modelSimulations/4.tablesfigures.do` | Figure 6.1: Distribution of household losses by income |
| `losses.tex` + `poverty.tex` | `5.modelSimulations/4.tablesfigures.do` | Table 6.1: Average losses |
| `efficiency.tex` | `5.modelSimulations/4.tablesfigures.do` | Table 6.2: Efficiency costs |
| `FIG_optimal_frontier_W.pdf` + `FIG_optimal_decomp.pdf` | `5.modelSimulations/4.tablesfigures.do` | Figure 6.2: Counterfactual policy responses |

### Appendix 

| Output file | Program | Description |
|---|---|---|
| `FIG_energypricecap_epg_prepay.pdf` | `3.descriptiveResults/3.describepricecap.do` | Appendix Figure A.1: Energy price cap, energy price guarantee and cheapest available price plans for prepay consumers |
| `FIG_paymenttypes_season.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure A.2: Seasonality of energy spending by payment type |
| `FIG_sample_gor.pdf` + `FIG_sample_age.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure A.3: Age and geographic sample composition |
| `FIG_lcfsvscs_nondur.pdf` + `FIG_lcfsvscs_energy.pdf` + `FIG_rankrank_energyvsnondur_LCFS.pdf` + `FIG_rankrank_energyvsnondur_CS.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure A.4: Non-durable and energy spending in ExactOne and Living Costs and Food Survey |
| `FIG_sample_inc_distr.pdf` + `FIG_sample_eexp_distr.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure A.5: Income and energy spend, by payment type |
| `FIG_NAvsCS_spend.pdf` | `3.descriptiveResults/2.macrotrends.do` | Appendix Figure A.6: Trends in energy spending in ExactOne data and National Accounts |
| `FIG_x_ener_Vs_inc_2019.pdf` + `FIG_x_ener_Vs_texp.pdf` | `3.descriptiveResults/4.exposure.do` | Appendix Figure B.1: Energy spending across the income and total expenditure distributions |
| `TAB_r2_LCFS_expcats.tex` | `3.descriptiveResults/4.exposure.do` | Table B.1: Explanatory power of household income and demographics, by spending categories |
| `TAB_exp_AR.tex` | `3.descriptiveResults/4.exposure.do` | Table B.2: Persistence of energy spending |
| `TAB_exp_AR_prebyinc.tex` | `3.descriptiveResults/4.exposure.do` | Appendix Table B.3: Persistence of energy spending by income quartile, 2019-20 |
| `TAB_exp_AR_crisisbyinc.tex` | `3.descriptiveResults/4.exposure.do` | Appendix Table B.4: Persistence of energy spending by income quartile, 2019-23 |
| `FIG_shr_elec.pdf` | `3.descriptiveResults/2.macrotrends.do` | Appendix Figure C.1: Quantity share of total energy from electricity |
| `FIG_altpriceindexes.pdf` | `3.descriptiveResults/3.describepricecap.do` | Appendix Figure C.2: Alternative price indexes |
| `FIG_sharegas_byincandexp.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure C.3: Share of energy spending on gas, by income quintile and energy spending quintile |
| `FIG_energypriceNI.pdf` + `FIG_lx_GBvsNI.pdf` | `3.descriptiveResults/3.describepricecap.do; 5.priceresponse.do` | Appendix Figure C.4: Energy prices and spending in Northern Ireland relative to the rest of the UK |
| `FIG_elas_apr22_het.pdf` | `3.descriptiveResults/5.priceresponse.do` | Appendix Figure C.5: Heterogeneity in elasticities, estimated using pre-shock energy spending and income specific price index weights |
| `TAB_qchg_apr22_app.tex` + `TAB_qchg_apr22_se_app.tex` + `TAB_elas_apr22_app.tex` + `TAB_elas_apr22_se_app.tex` + `TAB_N_apr22_app.tex` | `3.descriptiveResults/5.priceresponse.do` | Table C.1: Energy price elasticities, robustness |
| `FIG_lx_ds_rebates_qtr_DD_realvsfitted.pdf` + `FIG_lx_ds_rebates_qtr_noPP.pdf` | `3.descriptiveResults/6.MPCs.do` | Appendix Figure C.6: Energy spending over the transfer period, direct-debit households |
| `TAB_MPCrebates_DD.tex` + `TAB_MPCrebates_DD_N.tex` | `3.descriptiveResults/6.MPCs.do` | Table C.2: MPCE estimates for transfers (households paying by direct debit) |
| `coefficients.tex` | `4.modelEstimates/1.coefficients.do` | Table D.1: Parameter estimates |
| `FIG_elashet_model.pdf` | `4.modelEstimates/2.modelfit.do` | Appendix Figure D.1: Heterogeneity in elasticities, model-based estimates |
| `FIG_Engelcurve.pdf` | `4.modelEstimates/2.modelfit.do` | Appendix Figure D.2: Heterogeneity in Engel curves |
| `FIG_insample_inc.pdf` + `FIG_outofsample_inc.pdf` | `4.modelEstimates/2.modelfit.do` | Appendix Figure D.3: Winter energy demand jointly by income and pre-shock energy spending |
| `FIG_flyvalid.pdf` | `4.modelEstimates/2.modelfit.do` | Appendix Figure D.4: Hold-out sample validation of flypaper effect |
| `FIG_incAHC_byinc.pdf` + `FIG_energypov_bydecile.pdf` | `3.descriptiveResults/1.summarystats.do` | Appendix Figure E.1: After-housing-costs income and energy poverty |
| `FIG_lossfunctionww.pdf` + `FIG_standardww.pdf` + `FIG_legend_ww_ed.png` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.2: Level set of average welfare weights |
| `FIG_optimal_frontier_s1.pdf` + `FIG_optimal_frontier_s2.pdf` + `FIG_optimal_frontier_W_legend_ed.png` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.3: Efficiency–targeting trade-off, under more/less elastic energy demand |
| `FIG_optimal_decomp_s.pdf` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.4: Social loss-minimizing policy, under more/less elastic energy demand |
| `FIG_optimal_frontier_W_incadj.pdf` + `FIG_optimal_decomp_incadj.pdf` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.5: Counterfactual policy responses, allowing for offsetting income-based transfers |
| `Wequiv.tex` | `5.modelSimulations/A6.tablesfigures.do` | Table E.1: Public resource costs of reaching W(P0) under alternative policies |
| `FIG_psi_sub.pdf` + `FIG_psi_W.pdf` + `FIG_psi_W_nosub.pdf` + `FIG_optimal_frontier_W_legend_ed.png` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.6: Variation in optimal policy with $\psi$ |
| `FIG_optimal_frontier_W_incweight.pdf` + `FIG_optimal_decomp_incweight.pdf` | `5.modelSimulations/A6.tablesfigures.do` | Appendix Figure E.7: Counterfactual policy responses, vertical equity weighting |


### Log files (statistics cited in text)

| Output file | Program | Description |
|---|---|---|
| `LOG_numusers.log` | `3.descriptiveResults/1.summarystats.do` | Sample size and payment type counts |
| `LOG_likelyPP_bysupplier.log` | `3.descriptiveResults/1.summarystats.do` | Prepayment identification by supplier |
| `LOG_energy_poverty.log` | `3.descriptiveResults/1.summarystats.do` | Energy poverty rate (2019) |
| `LOG_LCFS_ppshr.log` | `3.descriptiveResults/1.summarystats.do` | LCFS prepayment share statistics |
| `sharecombinedbills_LCFS.txt` | `3.descriptiveResults/1.summarystats.do` | Combined gas/electricity bill prevalence |
| `LOG_realpriceincreases.log` | `3.descriptiveResults/3.describepricecap.do` | Real energy price increase statistics |
| `LOG_exposurebyincome.log` | `3.descriptiveResults/4.exposure.do` | Exposure to price shocks by income |
| `LOG_pvar_byregion.log` | `3.descriptiveResults/5.priceresponse.do` | Price variation across Ofgem regions |
| `LOG_MPCsendofrebates.txt` | `3.descriptiveResults/6.MPCs.do` | MPC statistics at end of rebate period |

---

## Key Global Parameters

The following parameters are defined in `_GLOBALS.do` and correspond to values described in the paper:

| Global | Value | Description |
|---|---|---|
| `$pp_shr` | 0.15 | Prepayment meter share (15%) |
| `$HH` | 28.4 | Number of UK households (millions) |
| `$S` | `6*28.4/1000` | Scaling factor (6 months × households, in billions) |
| `$E` | `0.059*1.24` | Marginal carbon externality (£ per kWh) |
| `$REPS` | 100 | Bootstrap replications for confidence intervals |

---

## Notes

- The graph scheme `cleanplots` must be installed for figures to render as in the paper. It is installed automatically by `master.do`.
- MATLAB is called directly from `master.do` via Stata's `shell` command, which waits for MATLAB to finish before continuing. The MATLAB executable path must be set in `master.do` (see Step 1 above).
- MATLAB estimation (Stage 4) produces `GMMcoefficients.raw` and related files. The bootstrap in `Simulations/Run.m` draws 100 coefficient vectors, producing `confidenceinterval1.raw` through `confidenceinterval100.raw`, which are aggregated in `3.observedpolicyCI.do`.
- Several do files use a `/* ... */` block convention to separate sequential analysis sections that share a working dataset in memory. These are not dead code.

---

*README prepared July 2026.*
