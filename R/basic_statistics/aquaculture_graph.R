# produce graph and table for aquaculture
# 
# Author: lbeaulaton
###############################################################################

#########################
# INITS
#########################
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(viridis)) install.packages("viridis") ; require(viridis)
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)

wd = tk_choose.dir(caption = "Results directory")
datawd = tk_choose.dir(caption = "Data directory", default = wd)
setwd(wd)

# load data
aquaculture <-read.table(str_c(datawd,"/aquaculture.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
aquaculture$eel_value<-as.numeric(aquaculture$eel_value)
aquaculture$eel_value = aquaculture$eel_value / 1000 
aquaculture[is.na(aquaculture$eel_value),]
#---------------------------------
# aquaculture per country
# 11 kg
# 12 n number
#----------------------------
table(aquaculture$eel_typ_id)
#TODO: cope with 2 DK aquaculture in number ==> import or stocking thus ignore
#filter(aquaculture,eel_typ_id==12&eel_value!=0)


write.table(round(xtabs(eel_value~eel_year+eel_cou_code, data = aquaculture)), file = "aquaculture.csv", sep = ";")
#round(xtabs(eel_value~eel_year+eel_lfs_code, data = aquaculture))

country_order = names(sort(tapply(aquaculture$eel_year, aquaculture$eel_cou_code, min), decreasing = TRUE))
aquaculture$eel_cou_code = factor(aquaculture$eel_cou_code, levels = country_order) 

a1<-aquaculture%>%dplyr::group_by(eel_cou_code,eel_year)%>%filter(eel_typ_id==11)%>%
		summarize(eel_value=sum(eel_value,na.rm=TRUE))

cols<-brewer.pal(length(unique(aquaculture$eel_cou_code)),"Set3")
x11()
ggplot(a1)+geom_col(aes(x=eel_year,y=eel_value,fill=eel_cou_code))+
		ggtitle("Aquaculture") + xlab("year") + ylab("Production (tons)")+
		scale_fill_manual(values=cols)+
		scale_y_continuous(breaks = seq(0,10000, 2000))+
		theme_bw()
savePlot("aquaculture.png", type = "png")

#filter(aquaculture, eel_cou_code == "DK" & eel_year == 2016)