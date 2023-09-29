
CY <- 2023


#####------------------------------------ 2. CREATE METADATA (.bib file) ------------------------------------#####

#create metadata for script
draft.data(
    originator = "wgeel",
    year = CY,
    title = "Recruitment stations data, series and data j",
    period = str_c("1900-",CY),
    access = "Public",
    source = "file",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "R_stations.Rdata",  
    append = FALSE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Statistics for series used in the recruitment index",
    period = str_c("1900-",CY),
    access = "Public",
    source = "file",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "statseries.Rdata",  
    append = TRUE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Table of the series as in t_series_ser in the dabase",
    period = str_c("1900-",CY),
    access = "Public",
    source = "file",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "t_series_ser.Rdata",  
    append = TRUE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Statistics for series used in the recruitment index",
    period = str_c("1900-",CY),
    access = "Public",
    source = "file",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "wger_init.Rdata",  
    append = TRUE
)

##################. source scripts for data formatting, moldel/analyses, generationg output and report ################## 

# remove all folders (including what's in them, that were created by the scripts below)
#clean()
#
## delete everything from the R environment
#rm(list = ls())
#
## run the scripts
#source("data.R")
#source("model.R")
#source("output.R")
#source("report.R")
#
##sourceAll()
