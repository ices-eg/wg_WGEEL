# Short script with examples of how to download some data from RDBES
# This example from the perspective of Sweden, but should be similar for other countreis
# Eirik Åsheim, Sept 2026 (WGEEL 2026 workshop)

# Some good references: 
# RDBES homepage: https://rdbes.ices.dk/
# the icesRDBES package (has a nice introduction and examples): https://github.com/ices-tools-prod/icesRDBES
# the RDBES github repo:  https://github.com/ices-tools-dev/RDBES
# the RDBES documentation: https://github.com/ices-tools-dev/RDBES/blob/master/Documents/RDBES%20Documentation%20of%20the%20Data%20Model.docx

# Some RDBES tables (data types): 
# "CL" - Commercial landings table
# "CE" - Commercial effort table
# "CS" - Sampling data
# "SL" - Species list

# formats: “SingleCsvFile” or “CsvFilePerTable”.
# Note: the SingleCsvFile format does not include column names. If you choose "SingleCsvFile", and the data you request involves multiple different tables, all those tables will be included into a single csv file without column names. This format is similar to what gets submitted to RDBES, but might for most users be less helpfull than using "CsvFilePerTable"
# "CsvFilePerTable" gives you "normal" csv files for each table

# The following are the filters for each data type:
# CL: clVesselFlagCountry (mandatory), clYear (optional), clArea (optional), and clSpeciesCode (optional).
# CE: ceVesselFlagCountry (mandatory), ceYear (optional), and ceArea (optional).
# CS: sdCountry (mandatory), deYear (optional), deSamplingScheme (optional), deStratumName (optional), saSpeciesCode (optional), foArea (optional), and leArea (optional).
# SL: slCountry (mandatory), slYear (optional), slSpeciesListName (optional), and slCatchFraction (optional).
# VD: vdCountry (mandatory) and vdYear (optional).



#### 1: Load icesRDBES ------------------------------------------------------------------
# To install icesRDBES, use:
# install.packages('icesRDBES', repos = c('https://ices-tools-prod.r-universe.dev', 'https://cloud.r-project.org'))

library(icesRDBES)
library(tidyverse) # (for getting readr and ggplot)

#### 2: Download commeercial landings ---------------------------------------------------
# Test downloading CL for sweden, specifically for eel (species code 126281)
# downloads a file, saves it, and returns the filename of the zipped data

filename_cl_zipped <- 
  rdbes_download_data(list(
    dataType = "CL",
    format = "CsvFilePerTable",
    hierarchies = list("HCL"),
    clFilters = list(
      clVesselFlagCountry = list("SE"),
      clSpeciesCode = list("126281")
    )
  ))

#### 3: Quick test, plot data ----------------------------------------------------------- 
# Here, we unzip the downloaded data
# then read the unzipped .csv file
# then make a simple plot 

unzip(filename_cl_zipped, exdir = "data/rdbes-landings-SE/")

tb_landings_sweden <- read_delim("data/rdbes-landings-SE/CommercialLanding.csv")

ggplot(tb_landings_sweden) +
  aes(x = CLyear, y=CLofficialWeight) +
  labs(title = "Total yearly landings (kg) reported in RDBES for Sweden") +
  geom_col()


#### 4: Examples of some other data -----------------------------------------------------

# Species list data
rdbes_download_data(list(
  dataType = "SL",
  format = "CsvFilePerTable",
  hierarchies = list("HSL"),
  slFilters = list(
    slCountry = list("SE")
  )
))

# Sampling data
rdbes_download_data(list(
  dataType = "CS",
  format = "SingleCsvFile",
  hierarchies = list("H1"),
  csFilters = list(
    sdCountry = list("SE")
  )
))


