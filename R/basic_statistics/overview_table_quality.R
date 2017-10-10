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


wd = tk_choose.dir(caption = "Results directory")
datawd = tk_choose.dir(caption = "Data directory", default = wd)

setwd(wd)

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

landings <-read.table(str_c(datawd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
aquaculture <-read.table(str_c(datawd,"/aquaculture.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
stocking <-read.table(str_c(datawd,"/stocking.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings$table<-"landings"
aquaculture$table<-"aquaculture"
stocking$table<-"stocking"
final<-union(union(landings,aquaculture),stocking)
write.table(dcast(final,eel_qal_id ~ table),file="summary_quality.csv")
