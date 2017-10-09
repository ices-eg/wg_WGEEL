# Produce graph for landings and reconstruct landings
# 2011
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

# load data
landings_complete <-read.table(str_c(datawd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings_complete$eel_value<-as.numeric(landings_complete$eel_value)
# ----------------------------------------------------------------
# commercial fisheries Y+S
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and yellow + silver
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code != "G", ] 
la = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(la)<-c("year","country","landings")

# excluding the current year and year before 1945
la = la[la$year != CY & la$year>=1945,]
la$country = as.factor(la$country)
la$landings = la$landings / 1000 # conversion from kg into tons

#########################
# reconstruction
#########################
la$llandings<-log(la$landings+0.001)
la$year<-as.factor(la$year)
glm_la<-glm(llandings~year+country,data=la)
summary(glm_la)
la2<-expand.grid("year"=levels(la$year),"country"=levels(la$country))
la2$pred=predict(glm_la,newdat=la2,type="response")

# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(la$year)){
  for (c in levels(la$country)){
	if (length(la[la$year==y&la$country==c,"landings"])==0){
	  la2[la2$year==y&la2$country==c,"landings"]<-round(exp(la2[la2$year==y&la2$country==c,"pred"]))
	  la2[la2$year==y&la2$country==c,"predicted"]<-TRUE
	} else {
	  # we replace by actual value
	  la2[la2$year==y&la2$country==c,"landings"]<-round(la[la$year==y&la$country==c,"landings"])
	  la2[la2$year==y&la2$country==c,"predicted"]<-FALSE
	}
  }
}
la2$year<-as.numeric(as.character(la2$year))

la$year = as.numeric(as.character(la$year))

#export data
write.table(round(xtabs(landings~year+country, data = la2)), file = "com_landings_YS_extrapolate.csv", sep = ";")
write.table(round(xtabs(predicted~year+country, data = la2)), file = "com_landings_YS_extrapolate_yn.csv", sep = ";")
write.table(round(dcast(year~country, data = la[,-4])), file = "com_landings_YS_raw.csv", sep = ";", row.names = FALSE)


#+ scale_fill_gradient(low="white", high="blue") 

#########################
# graph
#########################
cols<-c(brewer.pal(12,"Set3"),brewer.pal(length(levels(la2$country))-12,"Set1"))

# reconstructed
g<-ggplot(la2)
g1<-g+geom_area(aes(x=year,y=landings,fill=country),position='stack')+
	ggtitle("Commercial Landings (Y+S) corrected") + xlab("year") + ylab("Landings (tons)")+
	xlim(c(1945, CY)) +
	scale_fill_manual(values=cols)+
	theme_bw() 

# raw
g2<-ggplot(la)
g2<-g2+geom_area(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
	ggtitle("Commercial Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
	xlim(c(1945, CY))


# percentage of original data
g3<-ggplot(la2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
    #ggtitle("Landings (Y+S) recontructed from missing or original") +
     xlab("") + 
     ylab("")+
    xlim(c(1945, CY)) +
    scale_fill_manual(name = "Original data", values=c("black","grey"))+
    theme_bw()+    
    theme(legend.position="top")

x11()
print(g1)
savePlot("landings_YS_corrected.png", type = "png")
print(g2)
savePlot("landings_YS_raw.png", type = "png")
print(g3)
savePlot("landings_YS_proportion_corrected.png", type = "png")
g3_grob <- ggplotGrob(g3)
g4 <- g1+annotation_custom(g3_grob, xmin=1980, xmax=2016, ymin=12000, ymax=22000)
print(g4)
savePlot("landings_G_corrected_and_proportion.png", type = "png")
# ----------------------------------------------------------------
# commercial fisheries G
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code == "G", ] 
la = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(la)<-c("year","country","landings")
la<-la[la$landings>0,]
la$landings = la$landings / 1000 # conversion from kg into tons

# only use data when France starts to have
la = la[la$year >= min(la[la$country == "FR", "year"]), ] 
#dcast(la, year ~ country)

la$country = as.factor(la$country)
#########################
# reconstruction
#########################

la$llandings<-log(la$landings)
la<-la[la$year!=2017,]
la$year<-as.factor(la$year)
glm_la<-glm(llandings~year+country,data=la)
summary(glm_la)
la2<-expand.grid("year"=levels(la$year),"country"=levels(la$country))
la2$pred=predict(glm_la,newdat=la2,type="response")

# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(la$year)){
  for (c in levels(la$country)){
	if (length(la[la$year==y&la$country==c,"landings"])==0){
	  la2[la2$year==y&la2$country==c,"landings"]<-round(exp(la2[la2$year==y&la2$country==c,"pred"]))
	  la2[la2$year==y&la2$country==c,"predicted"]<-TRUE
	} else {
	  # we replace by actual value
	  la2[la2$year==y&la2$country==c,"landings"]<-round(la[la$year==y&la$country==c,"landings"])
	  la2[la2$year==y&la2$country==c,"predicted"]<-FALSE
	}
  }
}
la2$year<-as.numeric(as.character(la2$year))
la$year = as.numeric(as.character(la$year))

#export data
write.table(round(xtabs(landings~year+country, data = la2)), file = "com_landings_G_extrapolate.csv", sep = ";")
write.table(round(xtabs(predicted~year+country, data = la2)), file = "com_landings_G_extrapolate_yn.csv", sep = ";")
write.table(round(dcast(year~country, data = la[,-4])), file = "com_landings_G_raw.csv", sep = ";", row.names = FALSE)

#TODO: graph the available/missing data

#########################
# graph
#########################
cols<-rev(brewer.pal(length(levels(la2$country)),"Set3"))

# reconstructed
g<-ggplot(la2)
g1<-g+geom_area(aes(x=year,y=landings,fill=country),position='stack')+
		ggtitle("Commercial Landings (G) corrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw()

# raw
g2<-ggplot(la)
g2<-g2+geom_area(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
		ggtitle("Commercial Landings (G) uncorrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw()

# percentage of original data
g3<-ggplot(la2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
		xlab("") + 
		ylab("")+
		scale_fill_manual(name = "Original data", values=c("black","grey"))+
		theme_bw()+
        theme(legend.position="top")

x11()
print(g1)
savePlot("landings_G_corrected.png", type = "png")
print(g2)
savePlot("landings_G_raw.png", type = "png")
print(g3)
savePlot("landings_G_proportion_corrected.png", type = "png")
g3_grob <- ggplotGrob(g3)
g4 <- g1+annotation_custom(g3_grob, xmin=1985, xmax=2016, ymin=800, ymax=2000)
print(g4)
savePlot("landings_G_corrected_and_proportion.png", type = "png")
# ----------------------------------------------------------------
# recreational fisheries Y+S
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
rec_landings = landings_complete[landings_complete$typ_name == "rec_landings_kg"  & landings_complete$eel_lfs_code != "G", ] 
la = as.data.frame(rec_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(la)<-c("year","country","landings")

#la$country = as.factor(la$country)
la$landings = la$landings / 1000 # conversion from kg into tons

#dcast(la, year ~ country)

#########################
# graph
#########################
cols<-brewer.pal(length(unique(la$country)),"Set3")

la$country = factor(la$country, levels = sort(unique(la$country), decreasing = TRUE))

# graphic without transform
g2<-ggplot(la, aes(x=year, y=landings, fill = country))
g2 = g2+geom_bar(stat="identity", position="stack") + ggtitle("Recreational Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw()

x11()
print(g2)
savePlot("landings_recrYS_raw.png", type = "png")

write.table(round(dcast(year~country, data = la[,-4])), file = "recr_landings_YS_raw.csv", sep = ";", row.names = FALSE)

# ----------------------------------------------------------------
# recreational fisheries G
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
rec_landings = landings_complete[landings_complete$typ_name == "rec_landings_kg"  & landings_complete$eel_lfs_code == "G", ] 
la = as.data.frame(rec_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(la)<-c("year","country","landings")

#la$country = as.factor(la$country)
la$landings = la$landings / 1000 # conversion from kg into tons

#dcast(la, year ~ country)

#########################
# graph
#########################
cols<-brewer.pal(length(unique(la$country)),"Set1")

la$country = factor(la$country, levels = sort(unique(la$country), decreasing = TRUE))

# graphic without transform
g2<-ggplot(la, aes(x=year, y=landings, fill = country))
g2 = g2+geom_bar(stat="identity", position="stack") + ggtitle("Recreational Landings (G) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw()

x11()
print(g2)
savePlot("landings_recrG_raw.png", type = "png")

write.table(round(dcast(year~country, data = la[,-4])), file = "recr_landings_G_raw.csv", sep = ";", row.names = FALSE)
