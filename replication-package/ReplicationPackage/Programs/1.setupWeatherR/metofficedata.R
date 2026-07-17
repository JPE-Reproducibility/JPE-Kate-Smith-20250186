rm(list=ls())

library(ncdf4) # package for netcdf manipulation
library(sf) # package for geospatial analysis
library(ggplot2) # package for plotting
library(tidyverse)
library(terra)

projectdir <- 'J:/EnergyPriceCap/Replication/'
metofficedatadir <- paste0(projectdir,'data/dataRaw/downloaded/MetOffice/')
shapedir <- paste0(projectdir,'data/dataRaw/downloaded/shapefiles/infuse_lsoa_lyr_2011/infuse_lsoa_lyr_2011.shp')
outputdir <- paste0(projectdir,'data/dataRaw/')

source(paste0(projectdir,'Programs/1.setupWeatherR/GetTempAverages.R'))

# read shapes
shp <- st_read(dsn = shapedir, quiet = TRUE)

### Obtaining monthly temperatures
#years <- 2018:2023
#years <- 2018:2022
years <- 2023
#variables <- c("tasmin", "tas", "tasmax","hurs","rainfall")
#prefixes <- c("tempmin", "tempav", "tempmax","humidity","rainfall")

variables <- c("hurs")
prefixes <- c("humidity")

#variables <- "tasmax"
#prefixes <- "tempmax"
#variables <- c("tasmin")
#prefixes <- c("tempmin")

# Loop over variables and years
for (i in seq_along(variables)) {
  
  var <- variables[i]
  prefix <- prefixes[i]
  
  print(var)
  
  for (year in years) {
    
    print(paste0("Year: ",year))
    metofficefile <- sprintf("%s_hadukgrid_uk_5km_mon_%d01-%d12.nc", var, year, year)
    savefile <- paste0(outputdir, prefix, year, ".csv")
    
    GetTempAverages(
      metofficefile = metofficefile,
      metofficevar = var,
      shp = shp,
      savefile = savefile
    )
  }
}