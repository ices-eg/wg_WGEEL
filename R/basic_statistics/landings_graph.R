# Produce graph for landings and reconstruct landings
# 2011
# Author: cedric.briand
###############################################################################

#########################
# INITS
#########################
#TODO: setwd to GIT repository
source("R/utilities/load_library.R")
load_library(c("ggplot2", "reshape", "rJava", "reshape2", "stringr", "dplyr", "lattice", "RColorBrewer", "grid"))

source("R/utilities/set_directory.R")
set_directory("result")
set_directory("data")

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

# load data
landings_complete <-read.table(str_c(data_wd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)
landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))

# ----------------------------------------------------------------
# commercial fisheries Y+S
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and yellow + silver
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code != "G", ] 
landings_habitat = com_landings  %>% filter(eel_year>1995 & eel_year<CY) %>% group_by(eel_year, eel_hty_code, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE))
landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")

# excluding the current year and year before 1945
landings = landings[landings$year != CY & landings$year>=1945,]
landings$country = as.factor(landings$country)

#########################
# reconstruction
#########################
landings$llandings<-log(landings$landings+0.001) #introduce +0.001 to use 0 data
landings$year<-as.factor(landings$year)
glm_la<-glm(llandings~year+country,data=landings)
summary(glm_la) # check fit
landings2<-expand.grid("year"=levels(landings$year),"country"=levels(landings$country))
landings2$pred=predict(glm_la,newdat=landings2,type="response")

# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(landings$year)){
  for (c in levels(landings$country)){
	if (length(landings[landings$year==y&landings$country==c,"landings"])==0){ # no data ==> replace by predicted
	  landings2[landings2$year==y&landings2$country==c,"landings"]<-round(exp(landings2[landings2$year==y&landings2$country==c,"pred"]))
	  landings2[landings2$year==y&landings2$country==c,"predicted"]<-TRUE
	} else {
	  # use actual value
	  landings2[landings2$year==y&landings2$country==c,"landings"]<-round(landings[landings$year==y&landings$country==c,"landings"])
	  landings2[landings2$year==y&landings2$country==c,"predicted"]<-FALSE
	}
  }
}
landings2$year<-as.numeric(as.character(landings2$year))

landings$year = as.numeric(as.character(landings$year))

#export data
write.table(round(xtabs(landings~year+country, data = landings2)), file = str_c(result_wd, "/com_landings_YS_extrapolate.csv"), sep = ";")
write.table(round(xtabs(predicted~year+country, data = landings2)), file = str_c(result_wd, "/com_landings_YS_extrapolate_yn.csv"), sep = ";")
write.table(round(dcast(year~country, data = landings[,-4])), file = str_c(result_wd, "/com_landings_YS_raw.csv"), sep = ";", row.names = FALSE)

#########################
# graph
#########################
cols<-c(brewer.pal(12,"Set3"),brewer.pal(length(levels(landings2$country))-12,"Set1"))

# reconstructed
g_reconstructed_landings <- ggplot(landings2) + geom_col(aes(x=year,y=landings,fill=country),position='stack')+
	ggtitle("Commercial Landings (Y+S) corrected") + scale_x_continuous(breaks = seq(1950, 2030, 10))+ xlab("Year") + ylab("Landings (tons)")+
	coord_cartesian(expand = FALSE, ylim = c(0, 25000)) + #TODO: change 25000 for max*1.1
	scale_fill_manual(values=cols)+
	theme_bw()  

# raw
g_raw_landings <- ggplot(landings) + geom_col(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
	ggtitle("Commercial Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
	xlim(c(1945, CY))

# percentage of original data
g_percentage_reconstructed <- ggplot(landings2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
    #ggtitle("Landings (Y+S) recontructed from missing or original") +
    xlab("") + 
    ylab("")+
    xlim(c(1945, CY)) +
    scale_fill_manual(name = "Original data", values=c("black","grey"))+
    theme_bw()+    
    theme(legend.position="top")

x11()
print(g_reconstructed_landings)
savePlot(str_c(result_wd, "/landings_YS_corrected.png"), type = "png")
print(g_raw_landings)
savePlot(str_c(result_wd, "/landings_YS_raw.png"), type = "png")
print(g_percentage_reconstructed)
savePlot(str_c(result_wd, "/landings_YS_proportion_corrected.png"), type = "png")
g3_grob <- ggplotGrob(g_percentage_reconstructed)
g_combined_reconstructed <- g_reconstructed_landings+annotation_custom(g3_grob, xmin=1980, xmax=2016, ymin=12000, ymax=22000)
print(g_combined_reconstructed)
savePlot(str_c(result_wd, "/landings_YS_corrected_and_proportion.png"), type = "png")

# Other way to represent missing data and size of landings per year / country
ggplot(landings2, aes(y = country, x = year)) + geom_tile(aes(fill = !predicted)) + theme_bw() + scale_fill_manual(values = c("black", "lightblue"), name = "Reporting")
#ggplot(landings2, aes(y = country, x = year)) + geom_tile() + aes(fill = landings*(1-(predicted & NA)))+ theme_bw() + scale_fill_gradient2(low="blue", mid = "green", high="red", name = "Landings (t)", midpoint = 1500, na.value = "black")
savePlot(str_c(result_wd, "/landings_YS_reporting country.png"), type = "png")

# share by type of habitat
# by country
ggplot(landings_habitat) + aes(x = eel_cou_code, y = eel_value, fill = eel_hty_code) + geom_col(position = "fill") + theme_bw() + scale_fill_discrete(labels = levels(landings_complete$eel_hty_code), name = c("Habitat")) + theme(legend.position = "right") + xlab("Country") + ylab("Proportion") + coord_cartesian(expand = FALSE)
savePlot(str_c(result_wd, "/landings_YS_habitat_country.png"), type = "png")
# by year
ggplot(landings_habitat) + aes(x = eel_year, y = eel_value, fill = eel_hty_code) + geom_col(position = "fill") + theme_bw() + scale_fill_discrete(labels = levels(landings_complete$eel_hty_code), name = c("Habitat")) + theme(legend.position = "right") + xlab("Year") + ylab("Proportion") + coord_cartesian(expand = FALSE)
savePlot(str_c(result_wd, "/landings_YS_habitat_year.png"), type = "png")

# close all graph devices
graphics.off()

# ----------------------------------------------------------------
# commercial fisheries G
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code == "G", ] 
landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")
landings<-landings[landings$landings>0,]

# only use data when France starts to have
landings = landings[landings$year >= min(landings[landings$country == "FR", "year"]), ] 
#dcast(landings, year ~ country)

landings$country = as.factor(landings$country)
#########################
# reconstruction
#########################

landings$llandings<-log(landings$landings)
landings<-landings[landings$year!=2017,]
landings$year<-as.factor(landings$year)
glm_la<-glm(llandings~year+country,data=landings)
summary(glm_la)
landings2<-expand.grid("year"=levels(landings$year),"country"=levels(landings$country))
landings2$pred=predict(glm_la,newdat=landings2,type="response")

# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(landings$year)){
  for (c in levels(landings$country)){
	if (length(landings[landings$year==y&landings$country==c,"landings"])==0){
	  landings2[landings2$year==y&landings2$country==c,"landings"]<-round(exp(landings2[landings2$year==y&landings2$country==c,"pred"]))
	  landings2[landings2$year==y&landings2$country==c,"predicted"]<-TRUE
	} else {
	  # we replace by actual value
	  landings2[landings2$year==y&landings2$country==c,"landings"]<-round(landings[landings$year==y&landings$country==c,"landings"])
	  landings2[landings2$year==y&landings2$country==c,"predicted"]<-FALSE
	}
  }
}
landings2$year<-as.numeric(as.character(landings2$year))
landings$year = as.numeric(as.character(landings$year))

#export data
write.table(round(xtabs(landings~year+country, data = landings2)), file = str_c(result_wd, "/com_landings_G_extrapolate.csv"), sep = ";")
write.table(round(xtabs(predicted~year+country, data = landings2)), file = str_c(result_wd, "/com_landings_G_extrapolate_yn.csv"), sep = ";")
write.table(round(dcast(year~country, data = landings[,-4]), 1), file = str_c(result_wd, "/com_landings_G_raw.csv"), sep = ";", row.names = FALSE)

#########################
# graph
#########################
cols<-rev(brewer.pal(length(levels(landings2$country)),"Set3"))

# reconstructed
g<-ggplot(landings2)
g_reconstructed_landings<-g+geom_col(aes(x=year,y=landings,fill=country),position='stack')+
		ggtitle("Commercial Landings (G) corrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw()

# raw
g_raw_landings<-ggplot(landings)
g_raw_landings<-g_raw_landings+geom_col(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
		ggtitle("Commercial Landings (G) uncorrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw()

# percentage of original data
g_percentage_reconstructed<-ggplot(landings2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
		xlab("") + 
		ylab("")+
		scale_fill_manual(name = "Original data", values=c("black","grey"))+
		theme_bw()+
        theme(legend.position="top")

x11()
print(g_reconstructed_landings)
savePlot(str_c(result_wd, "/landings_G_corrected.png"), type = "png")
print(g_raw_landings)
savePlot(str_c(result_wd, "/landings_G_raw.png"), type = "png")
print(g_percentage_reconstructed)
savePlot(str_c(result_wd, "/landings_G_proportion_corrected.png"), type = "png")
g3_grob <- ggplotGrob(g_percentage_reconstructed)
g_combined_reconstructed <- g_reconstructed_landings+annotation_custom(g3_grob, xmin=1985, xmax=2016, ymin=800, ymax=2000)
print(g_combined_reconstructed)
savePlot(str_c(result_wd, "/landings_G_corrected_and_proportion.png"), type = "png")

# Other way to represent missing data and size of landings per year / country
x11(width = 9, height = 1.5)
ggplot(landings2, aes(y = country, x = year)) + geom_tile(aes(fill = !predicted)) + theme_bw() + scale_fill_manual(values = c("black", "lightblue"), name = "Reporting")
#ggplot(landings2, aes(y = country, x = year)) + geom_tile() + aes(fill = landings*(1-(predicted & NA)))+ theme_bw() + scale_fill_gradient2(low="blue", mid = "green", high="red", name = "Landings (t)", midpoint = 1500, na.value = "black")
savePlot(str_c(result_wd, "/landings_G_reporting country.png"), type = "png")

# close all graph devices
graphics.off()

# ----------------------------------------------------------------
# recreational fisheries Y+S
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
rec_landings = landings_complete[landings_complete$typ_name == "rec_landings_kg"  & landings_complete$eel_lfs_code != "G", ] 
landings = as.data.frame(rec_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")

#landings$country = as.factor(landings$country)

#dcast(landings, year ~ country)

#########################
# graph
#########################
cols<-brewer.pal(length(unique(landings$country)),"Set3")

landings$country = factor(landings$country, levels = sort(unique(landings$country), decreasing = TRUE))

# graphic without transform
g_raw_landings<-ggplot(landings, aes(x=year, y=landings, fill = country))
g_raw_landings = g_raw_landings+geom_bar(stat="identity", position="stack") + ggtitle("Recreational Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw()

x11()
print(g_raw_landings)
savePlot(str_c(result_wd, "/landings_recrYS_raw.png"), type = "png")

write.table(round(dcast(year~country, data = landings[,-4])), file = str_c(result_wd, "/recr_landings_YS_raw.csv"), sep = ";", row.names = FALSE)

# close all graph devices
graphics.off()

# ----------------------------------------------------------------
# recreational fisheries G
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and glass eel
rec_landings = landings_complete[landings_complete$typ_name == "rec_landings_kg"  & landings_complete$eel_lfs_code == "G", ] 
landings = as.data.frame(rec_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(landings)<-c("year","country","landings")

#landings$country = as.factor(landings$country)

#dcast(landings, year ~ country)

#########################
# graph
#########################
cols<-brewer.pal(length(unique(landings$country)),"Set1")

landings$country = factor(landings$country, levels = sort(unique(landings$country), decreasing = TRUE))

# graphic without transform
g_raw_landings<-ggplot(landings, aes(x=year, y=landings, fill = country))
g_raw_landings = g_raw_landings+geom_bar(stat="identity", position="stack") + ggtitle("Recreational Landings (G) uncorrected") + xlab("year") + ylab("Landings (tons)")+
	scale_fill_manual(values=cols)+
	theme_bw()

x11()
print(g_raw_landings)
savePlot(str_c(result_wd, "/landings_recrG_raw.png"), type = "png")

write.table(round(dcast(year~country, data = landings[,-4])), file = str_c(result_wd, "/recr_landings_G_raw.csv"), sep = ";", row.names = FALSE)

# close all graph devices
graphics.off()