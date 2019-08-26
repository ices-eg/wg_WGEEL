# main script to run shiny app
# 
# Author: lbeaulaton
###############################################################################

if(!require(rJava)) install.packages("rJava") ; require(rJava)
if(!require(rChoiceDialogs)) install.packages("rChoiceDialogs") ; require(rChoiceDialogs)

source("R/utilities/set_directory.R")


# path to local github (or write a local copy of the files and point to them)
setwd(wg_choose.dir(caption = "GIT directory", default = 'C:/workspace/gitwgeel/R/user_interface'))

# load map function
source("R/user_interface/maps.R")

# load shiny configuration

source("R/user_interface/global.R")
source("R/user_interface/server.R")

# Launch shiny and open your browser
shinyApp(ui, server, option =  list(port = 1235, launch.browser = T)) #local version
shinyApp(ui, server, option =  list(port = 1234, host = "0.0.0.0", launch.browser = T)) #public version
