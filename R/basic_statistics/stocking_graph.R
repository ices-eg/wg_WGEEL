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
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)
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
replace_NA = function(X)
{
	X[is.na(X)] = 0
	return(X)
}

graph_stocking = function(stage)
{
	dataset = get(paste("stocking_", stage, sep = ""))
	dataset = dataset[as.numeric(rownames(dataset))>=1945,]
		
	#for the label of the X axis
	if(length(dim(dataset)) == 2) x=as.numeric(rownames(dataset))
	if(length(dim(dataset)) == 1) x=as.numeric(names(dataset))
	x_axis = x %in% pretty(x, n = min(max(x) - min(x), 20))
	
	bar = barplot(t(replace_NA(dataset)), names.arg = rownames(dataset), col = cols, legend.text = colnames(dataset), las = 2, xaxt = "n", xlab = "year", ylab = "in number (x 10^6)", main = paste("Stocking (", stage, ")"))
	axis(1, at = bar[x_axis], x[x_axis], las = 2)
}

cols<-brewer.pal(ncol(stocking_G),"Set3")

x11()
graph_stocking("G")
savePlot("stocking_G.png", type = "png")
graph_stocking("GY")
savePlot("stocking_GY.png", type = "png")
graph_stocking("QG")
savePlot("stocking_QG.png", type = "png")
graph_stocking("OG")
savePlot("stocking_OG.png", type = "png")
graph_stocking("YS")
savePlot("stocking_YS.png", type = "png")
graph_stocking("S")
savePlot("stocking_S.png", type = "png")
