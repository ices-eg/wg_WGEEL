# Name : run.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")

#options(shiny.trace=TRUE)
runApp(shiny_data_wd,launch.browser = TRUE,
    host= "0.0.0.0", 
    port=1234)
