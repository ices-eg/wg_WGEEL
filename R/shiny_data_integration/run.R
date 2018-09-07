# Name : run.R
# Date : 04/07/2018
# data integeration
# Author: cedric.briand
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")

# setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")


#options(shiny.trace=TRUE)
runApp(paste(getwd(), '/R/shiny_data_integration/shiny', sep = ""), launch.browser = TRUE, host = "0.0.0.0", port = 1234)
