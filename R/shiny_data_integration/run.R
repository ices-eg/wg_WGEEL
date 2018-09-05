# Name : run.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")

#options(shiny.trace=TRUE)
runApp(paste(getwd(), '/R/shiny_data_integration/shiny', sep = ""),launch.browser = TRUE)
