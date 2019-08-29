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

# read the folder to have all names
countries = list.dirs(wd_file_folder, full.names = FALSE, recursive = FALSE)

country_data = retrieve_data(country = "FRA", type_series = "Yellow_Eel")

chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)

chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow))

updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
# TODO: design a function for updating data

# TODO: biometrie

## sql function to delete inserted data
#wgeel_query("delete from datawg.t_dataseries_das where das_last_update = '2019-08-28'")
#wgeel_query("delete from datawg.t_series_ser where ser_order = 999")

# to close the connection to the db
pool::poolClose(dbpool)