# Main script to launch shiny app
# 
# Authors: lbeaulaton Cedric
###############################################################################

#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\")
require("shiny")


#options(shiny.trace = TRUE)

runApp(paste(getwd(), '/R/shiny_data_visualisation/shiny_dv', sep = ""), launch.browser = TRUE, host = "0.0.0.0", port = 1235)

