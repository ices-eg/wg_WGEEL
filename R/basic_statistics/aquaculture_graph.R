# produce graph and table for aquaculture
# 
# Author: lbeaulaton
###############################################################################

#########################
# INITS
#########################
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
#if(!require(reshape)) install.packages("reshape") ; require(reshape)
#if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(viridis)) install.packages("viridis") ; require(viridis)
#if(!require(tidyr)) install.packages("tidyr") ; require(tidyr)
#if(!require(lattice)) install.packages("lattice") ; require(lattice)
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)
#if(!require(grid)) install.packages("grid") ; require(grid)


wd = tk_choose.dir(caption = "Working directory")
datawd = tk_choose.dir(caption = "Data directory", default = wd)
setwd(wd)

# load data
aquaculture <-read.table(str_c(datawd,"/aquaculture.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
aquaculture$eel_value = aquaculture$eel_value / 1000 

#---------------------------------
# aquaculture per country
# 11 kg
# 12 n number
#----------------------------
table(aquaculture$eel_typ_id)
#TODO: cope with 3 SP and DK aquaculture in number
#filter(aquaculture,eel_typ_id==12&eel_value!=0)

write.table(round(xtabs(eel_value~eel_year+eel_cou_code, data = aquaculture)), file = "aquaculture.csv", sep = ";")

a1<-aquaculture%>%dplyr::group_by(eel_cou_code,eel_year)%>%
		summarize(eel_value=sum(eel_value,na.rm=TRUE))

cols<-brewer.pal(length(unique(aquaculture$eel_cou_code)),"Set3")
x11()
ggplot(a1)+geom_col(aes(x=eel_year,y=eel_value,fill=eel_cou_code))+
		ggtitle("Aquaculture") + xlab("year") + ylab("Production (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw()
savePlot("aquaculture.png", type = "png")


filter(aquaculture,eel_cou_code == "GR")