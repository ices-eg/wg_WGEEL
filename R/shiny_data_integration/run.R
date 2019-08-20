# Name : run.R
# Date : 04/07/2018
# data integeration
# Author: cedric.briand
###############################################################################
require("shiny")


# setwd("C:/workspace/gitwgeel")


#options(shiny.trace=TRUE)
runApp(paste(getwd(), '/R/shiny_data_integration/shiny_di', sep = ""), 
    launch.browser = TRUE, host = "0.0.0.0", port = 1234)
