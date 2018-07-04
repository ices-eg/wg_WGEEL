# function to set directories needed in other scripts
# 
# Author: lbeaulaton
###############################################################################

if(!exists("load_library")) source("R/utilities/load_library.R")
load_library("tcltk")

# adapt the choose.dir to the platform used
if(.Platform$OS.type == "unix") {
	wg_choose.dir<-tk_choose.dir
} else {
	wg_choose.dir<-choose.dir
}    

#' @title set directory variables
#' @description set directory variables to be used by other scripts
#' @param type should be one of: script, data, shp, result, reference
set_directory = function(type)
{
	if(!type %in% c("script", "data", "shp", "result", "reference","shiny_data")) stop("type should be one of: script, data, shp, result, reference")
	if(type == "script")
	{
		new_wd = wg_choose.dir(caption = "Script directory (Root for GIT/WGEEL)")
		answer = rselect.list(choices = c("Yes", "No"), preselect = "No", title = "Confirm change?")
		if(answer == "Yes")
		{
			wd <<- new_wd
			setwd(wd)
		}
	} else {
		assign(x = paste(type, "_wd", sep = ""), value = wg_choose.dir(caption = paste(type, " directory", sep = "")), envir = .GlobalEnv)
	}
}
