# Main script to launch shiny app
# 
# Authors: lbeaulaton Cedric
###############################################################################
require("shiny")
source("R/utilities/set_directory.R")

# connection to database
source("R/database_interaction/database_connection.R")

source("R/utilities/load_library.R")
options(shiny.trace = TRUE)
<<<<<<< HEAD
runApp(paste0(getwd(),"/R/shiny_data_visualisation/shiny"), 
    host= "0.0.0.0", 
    port=2222,
    launch.browser = TRUE)
=======
runApp(paste(getwd(), '/R/shiny_data_visualisation/shiny', sep = ""), launch.browser = TRUE, host = "0.0.0.0", port = 1234)

>>>>>>> branch 'master' of https://github.com/ices-eg/wg_WGEEL.git
