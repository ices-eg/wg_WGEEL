# Name : run.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")
# this is removed to avoid
# TODO remove those lines when project is finished
# temporarily setting connection variables
userlocal<-"postgres"
passwordlocal<-"postgres"
shiny_data_wd<-"C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny"
#TODO uncomment this line once project is finished
#set_directory("shiny_data") # shiny_data_wd will be created
runApp(shiny_data_wd,launch.browser = TRUE)
