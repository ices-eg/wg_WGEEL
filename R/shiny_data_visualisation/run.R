# Main script to launch shiny app
# 
# Authors: lbeaulaton Cedric
###############################################################################

#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\")
require("shiny")
source("R/utilities/set_directory.R")

# connection to database
#source("R/database_interaction/database_connection.R")

source("R/utilities/load_library.R")
#options(shiny.trace = TRUE)

runApp(paste(getwd(), '/R/shiny_data_visualisation/shiny', sep = ""), launch.browser = TRUE, host = "0.0.0.0", port = 1235)

