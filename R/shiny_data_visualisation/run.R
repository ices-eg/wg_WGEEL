# Main script to launch shiny app
# 
# Author: lbeaulaton
###############################################################################

source("R/utilities/set_directory.R")
set_directory("shiny_data") # shiny_data_wd will be created

source("R/utilities/load_library.R")
load_library(c("shiny", "leaflet", "reshape2", "dplyr"))

runApp(shiny_data_wd, port = 5555,launch.browser = TRUE)

