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
load_library("dplyr") # to manipulate data

source("R/Y_S_series/Y_S_series_connection.R")
source("R/Y_S_series/Y_S_series_function.R")

#--------------------------------
# Start integration
#--------------------------------
# series in the database
ser_db = wgeel_query("SELECT * FROM datawg.t_series_ser")
ser_data = wgeel_query("SELECT * FROM datawg.t_dataseries_das")
ser_biom = wgeel_query("SELECT * FROM datawg.t_biometry_series_bis")

# read the folder to have all names
countries = list.dirs(wd_file_folder, full.names = FALSE, recursive = FALSE)

source("R/Y_S_series/2019/DE.R")
source("R/Y_S_series/2019/FRA.R")

## sql function to delete inserted data
#wgeel_query("delete from datawg.t_dataseries_das where das_last_update = '2019-08-28'")
#wgeel_query("delete from datawg.t_series_ser where ser_order = 999")

# to close the connection to the db
pool::poolClose(dbpool)