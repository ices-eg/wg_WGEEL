# Name : global.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################

#########################
# loads shiny packages
########################

if(!require(shiny)) install.packages("shiny") ; require(shiny)
if(!require(shinythemes)) install.packages("shinythemes") ; require(shinythemes)
if(!require(DT)) install.packages("DT") ; require(DT)
if(!require("readxl")) install.packages("readxl") ; require(readxl)
if(!require("stringr")) install.packages("stringr") ; require(stringr)
if(!require("htmltools")) install.packages("htmltools") ; require(htmltools)
# the shiny is launched from shiny_data_integration/shiny
# debug tool
#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")
source("../../utilities/load_library.R")
source("../../utilities/loading_functions.R")
source("../../utilities/check_utilities.R")
source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_reference.R")
source("../../utilities/compare_with_database.R")
tr_type_typ<-extract_ref('Type of series')
