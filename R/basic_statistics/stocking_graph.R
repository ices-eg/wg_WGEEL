# produce graph and table for stocking
# 
# Author: lbeaulaton
###############################################################################

#########################
# INITS
#########################
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
#if(!require(reshape)) install.packages("reshape") ; require(reshape)
if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(tidyr)) install.packages("tidyr") ; require(tidyr)
#if(!require(lattice)) install.packages("lattice") ; require(lattice)
#if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)
#if(!require(grid)) install.packages("grid") ; require(grid)


wd = tk_choose.dir(caption = "Working directory")
datawd = tk_choose.dir(caption = "Data directory", default = wd)
setwd(wd)

# load data
stocking <-read.table(str_c(datawd,"/stocking.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)


#---------------------------------------------
# synthesis by stage
#---------------------------------------------
stocking_synthesis = round(tapply(stocking_total$eel_value_nb, list(stocking_total$eel_year, stocking_total$eel_cou_code, stocking_total$eel_lfs_code), sum)/1E6, 2)

stocking_stage = function(stage) with(stocking_total %>% filter(eel_lfs_code == stage), round(tapply(eel_value_nb, list(eel_year, eel_cou_code), sum)/1E6, 2))

stocking_G = stocking_stage("G")
stocking_GY = stocking_stage("GY")
stocking_QG = stocking_stage("QG")
stocking_OG = stocking_stage("OG")
stocking_YS = stocking_stage("YS")
stocking_S = stocking_stage("S")


write.table(stocking_G, file = "stocking_G_in_million.csv", sep = ";")
write.table(stocking_GY, file = "stocking_GY_in_million.csv", sep = ";")
write.table(stocking_QG, file = "stocking_QG_in_million.csv", sep = ";")
write.table(stocking_OG, file = "stocking_OG_in_million.csv", sep = ";")
write.table(stocking_YS, file = "stocking_YS_in_million.csv", sep = ";")
write.table(stocking_S, file = "stocking_S_in_million.csv", sep = ";")

#---------------------------------------------
# graph by stage
#---------------------------------------------

