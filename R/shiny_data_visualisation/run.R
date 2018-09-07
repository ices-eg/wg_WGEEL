# Main script to launch data visualisation app
# 
# Authors: lbeaulaton Cedric
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")

# connection to database
source("R/database_interaction/database_connection.R")


source("R/utilities/load_library.R")

options(shiny.trace = TRUE)
runApp(paste0(getwd(),"/R/shiny_data_visualisation/shiny"), 
    host= "0.0.0.0", 
    port=2222,
    launch.browser = TRUE)