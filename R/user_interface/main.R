# main script to run shiny app
# 
# Author: lbeaulaton
###############################################################################

if(!require(rJava)) install.packages("rJava") ; require(rJava)
if(!require(rChoiceDialogs)) install.packages("rChoiceDialogs") ; require(rChoiceDialogs)


if(.Platform$OS.type == "unix") {
  wg_choose.dir<-tk_choose.dir
} else {
  wg_choose.dir<-choose.dir
}


# path to local github (or write a local copy of the files and point to them)
setwd(wg_choose.dir(caption = "GIT directory", default = 'C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/user_interface'))
# setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/user_interface")
# load map function
source("maps.R")

# load shiny configuration
source("server.R")

# Launch shiny and open your browser
shinyApp(ui, server, option =  list(port = 1235, launch.browser = T)) #local version
shinyApp(ui, server, option =  list(port = 1234, host = "0.0.0.0", launch.browser = T)) #public version
