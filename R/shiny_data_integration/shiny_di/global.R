# Name : global.R
# Date : 03/07/2018
# Author: cedric.briand
# DON'T FORGET TO SET THE qualify_code for eel_qal_id (this will be use to discard duplicates)
###############################################################################

#########################
# loads shiny packages 
########################
# the shiny is launched from shiny_data_integration/shiny
# debug tool
#setwd("C:\\workspace\\gitwgeel\\R\\shiny_data_integration\\shiny_di")
source("load_library.R")
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
load_package("shinyjs")
load_package("shinydashboard")
load_package("shinyWidgets")
load_package("shinyBS")
load_package("sqldf")

#----------------------
# Graphics
#----------------------
load_package("viridis")
load_package("ggplot2")
load_package("plotly")

jscode <- "shinyjs.closeWindow = function() { window.close(); }"

if(packageVersion("DT")<"0.2.30"){
  message("Inline editing requires DT version >= 0.2.30. Installing...")
  devtools::install_github('rstudio/DT')
}

if(packageVersion("glue")<"1.2.0.9000"){
  message("String interpolation implemented in glue version 1.2.0 but this version doesn't convert NA to NULL. Requires version 1.2.0.9000. Installing....")
  devtools::install_github('tidyverse/glue')
}

#source("database_connection.R")

load(file=str_c(getwd(),"/common/data/init_data.Rdata"))
# liste des champs permettant de charger l'interface


# below dbListFields from R postgres doesn't work, so I'm extracting the colnames from 
# the table to be edited there



source("loading_functions.R")
source("check_utilities.R")
source("database_data.R") #function extract_data
source("database_reference.R") # function extract_ref

# Local shiny files ---------------------------------------------------------------------------------

source("database_tools.R")
source("graphs.R")
options(shiny.maxRequestSize=15*1024^2) #15 MB for excel files
#pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="postgres",
#		host="localhost",
#		port=5432,
#		user= "test",
#		password= "test")
onStop(function() {
			poolClose(pool)
		}) # important!
# VERY IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -------------------------------------------------
##########################
# CHANGE THIS LINE AT THE NEXT DATACALL AND WHEN TEST IS FINISHED
# BEFORE WGEEL sqldf('delete from datawg.t_eelstock_eel where eel_datasource='test')
# BEFORE WGEEL sqldf('delete from datawg.t_eelstock_eel where eel_datasource='test')
########################
qualify_code<-20 # change this code here and in tr_quality_qal for next wgeel
the_eel_datasource <- "test" # change to dc_2020
#the_eel_datasource <- "dc_2019"
