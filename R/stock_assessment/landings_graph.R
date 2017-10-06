# Produce graph for landings and reconstruct landings
# 2011
# Author: cedric.briand
###############################################################################
require(ggplot2)
require(reshape)
setwd("/home/lbeaulaton/Documents/ANGUILLE/ICES/WGEEL/WGEEL 2016 Cordoue/task data")
datawd=("/home/lbeaulaton/Documents/ANGUILLE/ICES/WGEEL/WGEEL 2016 Cordoue/task data")
wd<-getwd()
la<-read.table("landings.csv",sep=";",header=TRUE, na.strings = "", dec = ",")
colnames(la)<-c("year",colnames(la)[2:length(colnames(la))])
la<-melt(la,id.vars="year")
colnames(la)<-c("year","country","landings")
# excluding country with no data
la = la[!la$country %in% c("BE", "ME"),]
la$country = as.factor(as.character(la$country))
g<-ggplot(la)
g+geom_area(aes(x=year,y=landings,fill=country),position='stack')
#g+stat_density(aes(x=year,y=landings,fill=country),position='stack')
la[la==0&!is.na(la)]<-0.1
la$llandings<-log(la$landings)
library(lattice)
densityplot(la$llandings[!is.na(la$llandings)])
la$year<-as.factor(la$year)
glm_la<-glm(llandings~year+country,data=la)
newdat<-expand.grid("year"=levels(la$year),"country"=levels(la$country))
newdat$pred=predict(glm_la,newdat=newdat,type="response")
la2<-newdat
y=1945
c="NO"
# BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
for (y in unique(la$year)){
	for (c in levels(la$country)){
		if (is.na(la[la$year==y&la$country==c,"landings"])){
			la2[la2$year==y&la2$country==c,"landings"]<-exp(newdat[newdat$year==y&newdat$country==c,"pred"])
			la2[la2$year==y&la2$country==c,"predicted"]<-TRUE
		} else {
			# we replace by actual value
			la2[la2$year==y&la2$country==c,"landings"]<-la[la$year==y&la$country==c,"landings"]
			la2[la2$year==y&la2$country==c,"predicted"]<-FALSE
		}
	}
}
la2$year<-as.numeric(as.character(la2$year))

#export data
write.table(round(xtabs(landings~year+country, data = la2)), file = "landings_extrapolate.csv", sep = ";")


library(RColorBrewer)
cols<-c(brewer.pal(12,"Set3"),brewer.pal(5,"Set1"))



g<-ggplot(la2)
g1<-g+geom_area(aes(x=year,y=landings,fill=country),position='stack')+
		opts(title="Landings from national report (corrected)",labels = c(x = "year", y = "Landings (tons)",countries="countries"))+
		annotate("text",x = 1975, y = 12000, label = "I",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1975, y = 8500, label = "FR",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1982, y = 5800, label = "GB",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1950, y = 9000, label = "NL",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1960, y = 5000, label = "DK",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1980, y = 1800, label = "PL",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1960, y = 1000, label = "SE",  parse = T, vjust = 0, hjust = 0)+
		annotate("text",x = 1965, y = 0, label = "NO",  parse = T, vjust = 0, hjust = 0)+
		ylim(c(0,22000))+
		scale_fill_manual(values=cols)+
		theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
		opts(plot.margin=unit(c(1,1,1.5,1.5), "lines"), # respectively: top, right, bottom, left; refers to margin *outside* labels; default is c(1,1,0.5,0.5)
				panel.margin=unit(0.25,"lines"), # default: what does it do?
				axis.ticks.margin=unit(0.25,"lines"), # default: gap between axis ticks and axis labels
				axis.title.x = theme_text(face="bold", size=12, vjust=-1), # use vjust to move text away from the axis
				axis.title.y = theme_text(face="bold", size=12, angle=90, vjust=0), # likewise
				panel.grid.major = theme_blank(),
				panel.grid.minor = theme_blank(),
				legend.position = c(0.5,0.9),
				legend.title = theme_blank(),
				legend.text = theme_text(size=8),
				legend.key.size = unit(1, "lines"),
				legend.key = theme_blank(), # switch off the rectangle around symbols in the legend,
				legend.direction = "horizontal"
		)

x11()
subplot <- function(x, y) viewport(layout.pos.col=x, layout.pos.row=y)
vplayout <- function(x, y) {
	grid.newpage()
	pushViewport(viewport(layout=grid.layout(y,x)))
}
# graphic without transform
la$year=as.numeric(as.character(la$year))
g2<-ggplot(la)
g2<-g2+geom_area(aes(x=year,y=landings,fill=country,legend = FALSE),position='stack')+
		opts(title="uncorrected",labels = c(x = "year", y = "Landings (tons)",countries="countries"))+
		scale_fill_manual(values=cols)+
		theme_bw() + # make the theme black-and-white rather than grey (do this before font changes, or it overrides them)
		ylim(c(0,22000))+
		opts(plot.margin=unit(c(1,1,1.5,1.5), "lines"), # respectively: top, right, bottom, left; refers to margin *outside* labels; default is c(1,1,0.5,0.5)
				panel.margin=unit(0.25,"lines"), # default: what does it do?
				axis.ticks.margin=unit(0.25,"lines"), # default: gap between axis ticks and axis labels
				axis.title.x = theme_blank(), 
				axis.title.y = theme_blank(),
				axis.text.y = theme_blank(),
				axis.title.y=theme_blank(),
				panel.grid.major = theme_blank(),
				panel.grid.minor = theme_blank(),
				legend.position = "none" # no legend
		)

vplayout(8,8)
print(g1, vp=subplot(c(1:8),c(1:8)))
print(g2, vp=subplot(c(6,8),c(2,4)))

