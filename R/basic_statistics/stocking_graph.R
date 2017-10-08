# produce graph and table for stocking
# 
# Author: lbeaulaton
###############################################################################

#########################
# INITS
#########################
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(tidyr)) install.packages("tidyr") ; require(tidyr)
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)

wd = tk_choose.dir(caption = "Results directory")
datawd = tk_choose.dir(caption = "Data directory", default = "C:/temp/wgeel/datacall")
setwd(wd)

# load data
stocking <-read.table(str_c(datawd,"/stocking.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
stocking$eel_value<-as.numeric(stocking$eel_value)
stocking[is.na(stocking$eel_value),]
#-----------------------------------------------
# Restocking which stages typ_id=9 (nb), =8 (kg)
#---------------------------------------------

stocking_nb <-filter(stocking,eel_typ_id%in%c(9))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
		summarize(eel_value=sum(eel_value))
stocking_kg <-filter(stocking,eel_typ_id%in%c(8))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
		summarize(eel_value=sum(eel_value))

#---------------------------------------------
# converting kg to number
#---------------------------------------------

# individual weight for one piece (kg)
GE_w=0.3e-3 
GY_w = 5e-3
Y_w=50e-3
OG_w=20e-3
QG_w=1e-3
S_w=150e-3

stocking_nb = stocking_nb%>%mutate(type="nb")
stocking_nb = stocking_nb%>%mutate(eel_value_nb = eel_value)

stocking_kg<-stocking_kg%>%mutate(type="kg")
stocking_kg<- bind_rows(
		filter(stocking_kg, eel_lfs_code=='G')%>%mutate(eel_value_nb=eel_value/GE_w)
		,
		filter(stocking_kg, eel_lfs_code=='GY')%>%mutate(eel_value_nb=eel_value/GY_w)
		,
		filter(stocking_kg, eel_lfs_code=='YS')%>%mutate(eel_value_nb=eel_value/Y_w)
		,
		filter(stocking_kg, eel_lfs_code=='OG')%>%mutate(eel_value_nb=eel_value/OG_w)
		,
		filter(stocking_kg, eel_lfs_code=='QG')%>%mutate(eel_value_nb=eel_value/QG_w)
		,
		filter(stocking_kg, eel_lfs_code=='S')%>%mutate(eel_value_nb=eel_value/S_w)
        ,
        filter(stocking_kg, eel_lfs_code=='Y')%>%mutate(eel_value_nb=eel_value/Y_w))
stocking = bind_rows(stocking_kg, stocking_nb)
# unique(stocking$eel_cou_code)

#
#---------------------------------------------
# synthesis by stage
#---------------------------------------------
stocking_synthesis = round(tapply(stocking$eel_value_nb, list(stocking$eel_year, stocking$eel_cou_code, stocking$eel_lfs_code), sum)/1E6, 2)
round(tapply(stocking$eel_value_nb, list(stocking$eel_year, stocking$eel_cou_code), sum)/1E6, 2)

stocking_stage = function(stage) with(stocking %>% filter(eel_lfs_code == stage), round(tapply(eel_value_nb, list(eel_year, eel_cou_code), sum)/1E6, 2))

stocking_G = stocking_stage("G")
stocking_GY = stocking_stage("GY")
stocking_QG = stocking_stage("QG")
stocking_OG = stocking_stage("OG")
stocking_YS = stocking_stage("YS")
stocking_S = stocking_stage("S")
stocking_Y = stocking_stage("Y")


write.table(stocking_G, file = "stocking_G_in_million.csv", sep = ";")
if(nrow(stocking_GY)>0) write.table(stocking_GY, file = "stocking_GY_in_million.csv", sep = ";")
write.table(stocking_QG, file = "stocking_QG_in_million.csv", sep = ";")
write.table(stocking_OG, file = "stocking_OG_in_million.csv", sep = ";")
if(nrow(stocking_YS)>0) write.table(stocking_YS, file = "stocking_YS_in_million.csv", sep = ";")
write.table(stocking_S, file = "stocking_S_in_million.csv", sep = ";")
write.table(stocking_Y, file = "stocking_Y_in_million.csv", sep = ";")
#---------------------------------------------
# graph by stage
#---------------------------------------------
replace_NA = function(X)
{
	X[is.na(X)] = 0
	return(X)
}

graph_stocking = function(stage,xlegend="top")
{
	dataset = get(paste("stocking_", stage, sep = ""))
	dataset = dataset[as.numeric(rownames(dataset))>=1945,]
	
	annee = matrix(rep(as.numeric(rownames(dataset)), ncol(dataset)), ncol = ncol(dataset)) * !is.na(dataset)
	annee[annee==0] = 3000
	
	country_order = order(apply(annee, 2, min), decreasing = FALSE)
	dataset = dataset[, country_order]
		
	#for the label of the X axis
	if(length(dim(dataset)) == 2) x=as.numeric(rownames(dataset))
	if(length(dim(dataset)) == 0) x=as.numeric(names(dataset))
	x_axis = x %in% pretty(x, n = min(max(x) - min(x), 20))
	
	bar = barplot(t(replace_NA(dataset)), names.arg = rownames(dataset), col = cols,
         legend.text = colnames(dataset), las = 2, xaxt = "n", xlab = "year",
          ylab = "in number (x 10^6)", main = paste("Stocking (", stage, ")"),
          args.legend=list(x=xlegend))
	axis(1, at = bar[x_axis], x[x_axis], las = 2)
}

cols<-brewer.pal(ncol(stocking_G),"Set3")

x11()
graph_stocking("G","topright")
savePlot("stocking_G.png", type = "png")
if(nrow(stocking_GY)>0)
{
	graph_stocking("GY","topright")
	savePlot("stocking_GY.png", type = "png")
}
graph_stocking("QG")
savePlot("stocking_QG.png", type = "png")
graph_stocking("OG")
savePlot("stocking_OG.png", type = "png")
graph_stocking("S", "topleft")
savePlot("stocking_S.png", type = "png")
graph_stocking("Y", "topright")
savePlot("stocking_Y.png", type = "png")
if(nrow(stocking_GY)>0)
{
	graph_stocking("YS")
	savePlot("stocking_YS.png", type = "png")
}