# Name : run.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")
#set_directory("shiny_data") # shiny_data_wd will be created
shiny_data_wd<-"C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny"
runApp(shiny_data_wd,launch.browser = TRUE)
