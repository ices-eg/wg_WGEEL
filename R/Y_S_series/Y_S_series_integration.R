# Y_S_series_integration.R
# provisional script to integrated 2019 data call yellow and silver eel series
# TODO: to integrate this in the shiny app
###############################################################################

source("R/utilities/load_library.R")

# here is a list of the required packages
load_library("readxl") # to read xls files
load_library("stringr") # this contains utilities for strings
load_library("sqldf") # to run queries
load_library("RPostgreSQL") # to run queries to the postgres database

# path to the folder where all files where stored
wd_file = "/home/lbeaulaton/Documents/Documents sur Donnees/ANGUILLE/ICES/WGEEL/WGEEL 2019 Bergen/data call/all_countries/03 Data Submission 2019"


