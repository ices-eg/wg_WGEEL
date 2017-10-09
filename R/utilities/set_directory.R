# function to set directories needed in other scripts
# 
# Author: lbeaulaton
###############################################################################

if(!exists("load_library")) source("R/utilities/load_library.R")

#' @title set directory variables
#' @description set directory variables to be used by other scripts
#' @param type should be one of: script, data, shp, result, reference
set_directory = function(type)
{
	if(!type %in% c("script", "data", "shp", "result", "reference")) stop("type should be one of: script, data, shp, result, reference")
	load_library("rChoiceDialogs")
	if(type == "script")
	{
		wd <<- rchoose.dir(caption = "Script directory (Root for GIT/WGEEL)")
		setwd(wd)
	} else {
		assign(x = paste(type, "_wd", sep = ""), value = rchoose.dir(caption = paste(type, " directory", sep = "")), envir = .GlobalEnv)
	}
}
