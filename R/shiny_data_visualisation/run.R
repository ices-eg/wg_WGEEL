# Main script to launch shiny app
# 
# Authors: lbeaulaton Cedric
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")
#set_directory("shiny_data") # shiny_data_wd will be created
shiny_data_wd<-"C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_visualisation\\shiny"
# temporarily setting connection variables
userlocal<-"postgres"
passwordlocal<-"postgres"
source("R/utilities/load_library.R")

options(shiny.trace = TRUE)
runApp(shiny_data_wd, 
    host= "0.0.0.0", 
    port=1234,
    launch.browser = TRUE)

