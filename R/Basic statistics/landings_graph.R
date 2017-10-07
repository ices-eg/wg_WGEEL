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


wd = tk_choose.dir(caption = "Working directory")
datawd = tk_choose.dir(caption = "Data directory", default = wd)
setwd(wd)

CY = as.numeric(format(Sys.time(), "%Y")) # year of work

# load data
landings_complete <-read.table(str_c(datawd,"/landings.csv"),sep=";",header=TRUE, na.strings = "", dec = ".", stringsAsFactors = FALSE)

# ----------------------------------------------------------------
# commercial fisheries Y+S
# ----------------------------------------------------------------

#########################
# Formatting data
#########################

# work only on commercial fisheries and yellow + silver
com_landings = landings_complete[landings_complete$typ_name == "com_landings_kg" & landings_complete$eel_lfs_code != "G", ] 
la = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code) %>% summarise(eel_value=sum(eel_value,na.rm=TRUE)))
colnames(la)<-c("year","country","landings")

# excluding the current year and year before 1945
la = la[la$year != CY & la$year>=1945,]
la$country = as.factor(la$country)
la$landings = la$landings / 1000 # conversion from kg into tons

#########################
# reconstruction
#########################
la$llandings<-log(la$landings)
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
write.table(round(xtabs(landings~year+country, data = la2)), file = "landings_YS_extrapolate.csv", sep = ";")
write.table(round(xtabs(predicted~year+country, data = la2)), file = "landings_YS_extrapolate_yn.csv", sep = ";")

#TODO: graph the available/missing data

#########################
# graph
#########################
cols<-c(brewer.pal(12,"Set3"),brewer.pal(length(levels(la2$country))-12,"Set1"))

#TODO: see if we update the deprecated opts

g<-ggplot(la2)
g1<-g+geom_area(aes(x=year,y=landings,fill=country),position='stack')+
		ggtitle("Commercial Landings (Y+S) corrected") + xlab("year") + ylab("Landings (tons)")+
#		annotate("text",x = 1975, y = 12000, label = "I",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1975, y = 8500, label = "FR",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1982, y = 5800, label = "GB",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1950, y = 9000, label = "NL",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1960, y = 5000, label = "DK",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1980, y = 1800, label = "PL",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1960, y = 1000, label = "SE",  parse = T, vjust = 0, hjust = 0)+
#		annotate("text",x = 1965, y = 0, label = "NO",  parse = T, vjust = 0, hjust = 0)+
		ylim(c(0,22000))+ xlim(c(1945, CY)) +
		scale_fill_manual(values=cols)+
		theme_bw() #+ # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
#		opts(plot.margin=unit(c(1,1,1.5,1.5), "lines"), # respectively: top, right, bottom, left; refers to margin *outside* labels; default is c(1,1,0.5,0.5)
#				panel.margin=unit(0.25,"lines"), # default: what does it do?
#				axis.ticks.margin=unit(0.25,"lines"), # default: gap between axis ticks and axis labels
#				axis.title.x = theme_text(face="bold", size=12, vjust=-1), # use vjust to move text away from the axis
#				axis.title.y = theme_text(face="bold", size=12, angle=90, vjust=0), # likewise
#				panel.grid.major = theme_blank(),
#				panel.grid.minor = theme_blank(),
#				legend.position = c(0.5,0.9),
#				legend.title = theme_blank(),
#				legend.text = theme_text(size=8),
#				legend.key.size = unit(1, "lines"),
#				legend.key = theme_blank(), # switch off the rectangle around symbols in the legend,
#				legend.direction = "horizontal"
#		)


# graphic without transform
g2<-ggplot(la)
g2<-g2+geom_area(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
		ggtitle("Commercial Landings (Y+S) uncorrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
		ylim(c(0,22000)) + xlim(c(1945, CY))#+
#		opts(plot.margin=unit(c(1,1,1.5,1.5), "lines"), # respectively: top, right, bottom, left; refers to margin *outside* labels; default is c(1,1,0.5,0.5)
#				panel.margin=unit(0.25,"lines"), # default: what does it do?
#				axis.ticks.margin=unit(0.25,"lines"), # default: gap between axis ticks and axis labels
#				axis.title.x = theme_blank(), 
#				axis.title.y = theme_blank(),
#				axis.text.y = theme_blank(),
#				axis.title.y=theme_blank(),
#				panel.grid.major = theme_blank(),
#				panel.grid.minor = theme_blank(),
#				legend.position = "none" # no legend
#		)

x11()
print(g1)
savePlot("landings_YS_corrected.png", type = "png")
print(g2)
savePlot("landings_YS_raw.png", type = "png")

# TODO: the following doesn't work properly due to the depreacted opts (see above)
#x11()
#subplot <- function(x, y) viewport(layout.pos.col=x, layout.pos.row=y)
#vplayout <- function(x, y) {
#	grid.newpage()
#	pushViewport(viewport(layout=grid.layout(y,x)))
#}
#vplayout(8,8)
#print(g1, vp=subplot(c(1:8),c(1:8)))
#print(g2, vp=subplot(c(6,8),c(2,4)))

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

la$country = as.factor(la$country)
la$landings = la$landings / 1000 # conversion from kg into tons

# only use data when France starts to have
la = la[la$year >= min(la[la$country == "FR", "year"]), ] 
#dcast(la, year ~ country)

#########################
# reconstruction
#########################
la$llandings<-log(la$landings)
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
write.table(round(xtabs(landings~year+country, data = la2)), file = "landings_G_extrapolate.csv", sep = ";")
write.table(round(xtabs(predicted~year+country, data = la2)), file = "landings_G_extrapolate_yn.csv", sep = ";")

#TODO: graph the available/missing data

#########################
# graph
#########################
cols<-brewer.pal(length(levels(la2$country)),"Set3")

g<-ggplot(la2)
g1<-g+geom_area(aes(x=year,y=landings,fill=country),position='stack')+
		ggtitle("Commercial Landings (G) corrected") + xlab("year") + ylab("Landings (tons)")+
		ylim(c(0,2500))+ 
		scale_fill_manual(values=cols)+
		theme_bw()

# graphic without transform
g2<-ggplot(la)
g2<-g2+geom_area(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
		ggtitle("Commercial Landings (G) uncorrected") + xlab("year") + ylab("Landings (tons)")+
		scale_fill_manual(values=cols)+
		theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
		ylim(c(0,2500))


x11()
print(g1)
savePlot("landings_G_corrected.png", type = "png")
print(g2)
savePlot("landings_G_raw.png", type = "png")

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
