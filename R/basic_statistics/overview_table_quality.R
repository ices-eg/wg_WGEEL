# Produce a simple table giving the proportion of data per quality
# 2017
# Author: cedric.briand
###############################################################################

#########################
# INITS
#########################
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
if(!require(reshape)) install.packages("reshape") ; require(reshape)
if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(lattice)) install.packages("lattice") ; require(lattice)
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)
if(!require(grid)) install.packages("grid") ; require(grid)


source("R/utilities/set_directory.R")
set_directory("result")
set_directory("data")

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

landings <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings$eel_value<-as.numeric(landings$eel_value)
aquaculture <-read.table(str_c(data_wd,"/aquaculture.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
stocking <-read.table(str_c(data_wd,"/stocking.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings$table<-"landings"
aquaculture$table<-"aquaculture"
stocking$table<-"stocking"
final<-union(union(landings,aquaculture),stocking)
write.table(dcast(final,eel_qal_id ~ table),file=str_c(result_wd, "/summary_quality.csv"), sep = ";", row.names = FALSE)
