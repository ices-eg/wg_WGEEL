# Name : global.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################

#########################
# loads shiny packages
########################
if(!require(shiny)) install.packages("shiny") ; require(shiny)
if(!require(DT)) install.packages("DT") ; require(DT)
if(!require("readxl")) install.packages("readxl") ; require(readxl)
if(!require("stringr")) install.packages("stringr") ; require(stringr)
# the shiny is launched from shiny_data_integration/shiny
source("../../utilities/loading_functions.R")
source("../../utilities/check_utilities.R")

