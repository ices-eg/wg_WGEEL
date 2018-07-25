# Name : global.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################

#########################
# loads shiny packages
########################
load_package <- function(x)
{
  if (!is.character(x)) stop("Package should be a string")
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}
load_package("shiny")
load_package("shinythemes")
load_package("DT")
load_package("readxl")
load_package("stringr")
load_package("htmltools")

#-----------------
# Data correction table
#-----------------
load_package("pool")
load_package("DBI")
load_package("RPostgreSQL")
load_package("dplyr")
load_package("glue")

if(packageVersion("DT")<"0.2.30"){
  message("Inline editing requires DT version >= 0.2.30. Installing...")
  devtools::install_github('rstudio/DT')
}

if(packageVersion("glue")<"1.2.0.9000"){
  message("String interpolation implemented in glue version 1.2.0 but this version doesn't convert NA to NULL. Requires version 1.2.0.9000. Installing....")
  devtools::install_github('tidyverse/glue')
}

# Define pool handler by pool on global level
pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
    dbname="wgeel",
    host="localhost",
    user= userlocal,
    password=passwordlocal)

onStop(function() {
        poolClose(pool)
    }) # important!
# below dbListFields from R postgres doesn't work, so I'm extracting the colnames from 
# the table to be edited there
query <- "SELECT column_name
        FROM   information_schema.columns
        WHERE  table_name = 't_eelstock_eel'
        ORDER  BY ordinal_position"
t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
t_eelstock_eel_fields <- t_eelstock_eel_fields$column_name
# the shiny is launched from shiny_data_integration/shiny
# debug tool
#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")
source("../../utilities/load_library.R")
source("../../utilities/loading_functions.R")
source("../../utilities/check_utilities.R")
source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_reference.R")
source("database_tools.R")
tr_type_typ<-extract_ref('Type of series')
qualify_code<-18 # change this code here and in tr_quality_qal for next wgeel

# TODO change this in shiny by selecting country, data type, range of years
sel_country="VA"