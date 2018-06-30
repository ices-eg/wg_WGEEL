# main script to run shiny app
# 
# Author: lbeaulaton
###############################################################################

if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)

# path to local github (or write a local copy of the files and point to them)
setwd(tk_choose.dir(caption = "GIT directory", default = "C:/Users/cedric.briand/Documents/GitHub/WGEEL"))

# load map function
source("R/user_interface/maps.R")

# load shiny configuration
source("R/user_interface/shiny_test_maps.R")

# Launch shiny and open your browser
shinyApp(ui, server, option =  list(port = 1235, launch.browser = T)) #local version
shinyApp(ui, server, option =  list(port = 1234, host = "0.0.0.0", launch.browser = T)) #public version
