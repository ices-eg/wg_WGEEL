### R code from vignette source 'recruitment_analysis.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: init
###################################################
# Password are stored in R/etc/Rprofile.site
# For the moment the database is stored locally
CY<-2019 # current year ==> don't forget to update the graphics path below
# ----------------------------------
# wgeel2016 discussed that the correct way of 
# calculating average of predictions was to use geomean
# the option below can be changed from geomean to mean to change calculations
# it will change the average in model of glass eel graph and prediction
#----------------------------------------------------------
opt_calculation="geomean" # "geomean" or "mean"
opt_std="all" #"1979-1994" or "2000-2009" or "all"

options(width=90) # this sets the width of the output
#--------------------------------
# packages used by this script
#--------------------------------
#if(!require(RODBC)) install.packages("RODBC") ; require(RODBC)
if(!require(mgcv)) install.packages("mgcv") ; require(mgcv)
if(!require(car)) install.packages("car") ; require(car)
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
if(!require(reshape)) install.packages("reshape") ; require(reshape)
if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(stacomirtools)) install.packages("stacomirtools") ; require(stacomirtools) # for ODBC connections
if(!require(stringr)) install.packages("stringr") ; require(stringr)
if(!require(Hmisc)) install.packages("Hmisc") ; require(Hmisc)
if(!require(xtable)) install.packages("xtable") ; require(xtable)
if(!require(grid)) install.packages("grid") ; require(grid)
if(!require(sqldf)) install.packages("sqldf") ; require(sqldf)
if(!require(RPostgreSQL)) install.packages("RPostgreSQL") ; require(RPostgreSQL)
if(!require(RColorBrewer)) install.packages("RColorBrewer") ; require(RColorBrewer)
if(!require(stacomiR)) install.packages("stacomiR") ; require(stacomiR)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(sp)) install.packages("sp") ; require(sp)
if(!require(maptools)) install.packages("maptools") ; require(maptools)
if(!require(maps)) install.packages("maps") ; require(maps)
if(!require(boot)) install.packages("boot") ; require(boot)
if(!require(MASS)) install.packages("MASS") ; require(MASS)
if(!require(lme4)) install.packages("lme4") ; require(lme4)
if(!require(multcomp)) install.packages("multcomp") ; require(multcomp)
#--------------------------------
# get your current name
#--------------------------------
getUsername <- function(){
	name <- Sys.info()[["user"]]
	return(name)
}
#--------------------------------
# the code below is adapted to the three persons who currently 
# load this script
# TODO: be more generic
# It is necessary to create a folder, your code is currently stored in
#--------------------------------------------------
# FOLDER>WGEELgit>R>recruitment>recruitment_analysis.Rnw
#---------------------------------------------------
# This will be automatically set when pulling code from git
# WGEELgit is the local name you have chosen for the git repository,
# FOLDER is the directory where you have stored the git code
# So you need to create a directory to store data and figures besides this 
# directory, like this
# FOLDER>datawgeel>recruitement>2019>data
# FOLDER>datawgeel>recruitement>2019>image
# FOLDER>datawgeel>recruitement>2019>table
# here 2019 is the current year of recruitment (I have several folders one for each year)
# the reason for this is that we don't want to put data or figures in the git.
#--------------------------------

if(getUsername() == 'cedric.briand')
{
  # I have two password in the R.site of c:/program files/R... so I don't need no prompt

  #baseODBC=c("wgeel","wgeel",passwordwgeel) #"w3.eptb-vilaine.fr" "localhost" "wgeel" "wgeel_distant" 
  options(sqldf.RPostgreSQL.user = "wgeel", 
	  sqldf.RPostgreSQL.password = passwordwgeel,
	  sqldf.RPostgreSQL.dbname = "wgeel",
	  sqldf.RPostgreSQL.host = "localhost", # "localhost"
	  sqldf.RPostgreSQL.port = 5435) # 5435 launch the ssh tunnel
  setwd("C:/workspace/gitwgeel/R/recruitment")
  
  wd <- getwd()
  wddata <- gsub("C:/workspace/gitwgeel/R","C:/workspace/wgeeldata",wd)
  datawd <- str_c(wddata,"/",CY,"/data/")
  imgwd <- str_c(wddata,"/",CY,"/image/")
  tabwd <- str_c(wddata,"/",CY,"/table/")
  shpwd <- str_c("C:/workspace/wgeeldata/shp/") 
  shinywd <- "C:/workspace/gitwgeel/R/shiny_data_visualisation/shiny_dv/data/recruitment/"
}
if(getUsername() == 'lbeaulaton')
{
  getpassword<-function(){  
	require(tcltk);  
	wnd<-tktoplevel();tclVar("")->passVar;  
	#Label  
	tkgrid(tklabel(wnd,text="Enter password:"));  
	#Password box  
	tkgrid(tkentry(wnd,textvariable=passVar,show="*")->passBox);  
	#Hitting return will also submit password  
	tkbind(passBox,"<Return>",function() tkdestroy(wnd));  
	#OK button  
	tkgrid(tkbutton(wnd,text="OK",command=function() tkdestroy(wnd)));  
	#Wait for user to click OK  
	tkwait.window(wnd);  
	password<-tclvalue(passVar);  
	return(password);  
  }  
  if (!exists("password"))  { 
	password<-getpassword()
  }
  #baseODBC=c("wgeel","postgres",password)
  options(sqldf.RPostgreSQL.user = "lolo", 
	  sqldf.RPostgreSQL.password = password,
	  sqldf.RPostgreSQL.dbname = "wgeel_ices",
	  sqldf.RPostgreSQL.host = "localhost", 
	  sqldf.RPostgreSQL.port = 5432)
  
  setwd(str_c(getwd(), "/R/recruitment"))
  wd=getwd()
  
  wddata <- "/home/lbeaulaton/Documents/ANGUILLE/ICES/WGEEL/Ranalysis"
  datawd<-str_c(wddata,"/",CY,"/data/")
  imgwd<-str_c(wddata,"/",CY,"/image/")
  tabwd<-str_c(wddata,"/",CY,"/table/")
  shpwd="/home/lbeaulaton/Documents/ANGUILLE/ICES/WGEEL/SIG/" # emu, rbd, country
}


if(getUsername() == 'hilaire.drouineau')
{
  # I have two password in the R.site of c:/program files/R... so I don't need no prompt
  m=dbDriver("PostgreSQL")
  con=dbConnect(m,host="localhost",user="hilaire",dbname="wgeel",port=5432)
  
  baseODBC=c("wgeel","hilaire",passwordwgeel) #"w3.eptb-vilaine.fr" "localhost" "wgeel" "wgeel_distant" 
  options(sqldf.RPostgreSQL.user = "hilaire", 
          sqldf.RPostgreSQL.password = passwordwgeel,
          sqldf.RPostgreSQL.dbname = "wgeel",
          sqldf.RPostgreSQL.host = "localhost", # "localhost"
          sqldf.RPostgreSQL.port = 5432) # 5435 launch the ssh tunnel
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")

  
  wd <- getwd()
  wddata <- "~/Documents/Bordeaux/migrateurs/WGEEL/wgeel_data"
  datawd <- str_c(wddata,"/",CY,"/data/")
  imgwd <- str_c(wddata,"/",CY,"/image/")
  tabwd <- str_c(wddata,"/",CY,"/table/")
}



if(getUsername() == 'EDIAZ')
{
  getpassword<-function(){  
	require(tcltk);  
	wnd<-tktoplevel();tclVar("")->passVar;  
	#Label  
	tkgrid(tklabel(wnd,text="Enter password:"));  
	#Password box  
	tkgrid(tkentry(wnd,textvariable=passVar,show="*")->passBox);  
	#Hitting return will also submit password  
	tkbind(passBox,"<Return>",function() tkdestroy(wnd));  
	#OK button  
	tkgrid(tkbutton(wnd,text="OK",command=function() tkdestroy(wnd)));  
	#Wait for user to click OK  
	tkwait.window(wnd);  
	password<-tclvalue(passVar);  
	return(password);  
  }  
  if (!exists("password"))  { 
	password<-getpassword()
  }
  baseODBC=c("wgeel","postgres",password)
  options(sqldf.RPostgreSQL.user = "postgres", 
	  sqldf.RPostgreSQL.password = password,
	  sqldf.RPostgreSQL.dbname = "wgeel",
	  sqldf.RPostgreSQL.host = "w3.eptb-vilaine.fr", 
	  sqldf.RPostgreSQL.port = 5432)
  setwd("C:/Users/ediaz/workspace/wgeel/sweave")
  wd<-getwd()
  wddata<-gsub("wgeel","wgeeldata",wd) # replacing the path to wgeel by wgeeldata ...
  
  datawd<-str_c(wddata,"/",CY,"/data/")
  imgwd<-str_c(wddata,"/",CY,"/image/")
  tabwd<-str_c(wddata,"/",CY,"/table/")
  shpwd=str_c(wddata,"/wgeel2013/emu/") 
}
# some of the functions used later in that script :
source('utilities.R')
graphics.off() # close all graphics devices
# the results will be stored in a list, when I first run the program,
# on the second run this list will be loaded and I can avoid some steps in the calculation
# by setting the chunks as eval=FALSE
vv<-list()




load(paste(datawd,"glass_eel_yoy.Rdata",sep=""))
glass_eel_yoy$site<-as.factor(glass_eel_yoy$site)
glass_eel_yoy=glass_eel_yoy[glass_eel_yoy$value>0 & glass_eel_yoy$year>1959,]

##########################
# Main data from the series -------------------------------
##########################
query='SELECT 
	ser_id,            
	ser_nameshort,
	case when ser_namelong ~* \'commercial\' or ser_nameshort in (\'Vil\',\'Ebro\') then \'commercial\' else \'independent\' end as fishery_based
	from datawg.t_series_ser 
	where ser_typ_id=1'

fishery_type=sqldf(query) # (wge)el (r)ecruitment data
glass_eel_yoy=merge(glass_eel_yoy,fishery_type)


glass_eel_yoy$site<-as.factor(glass_eel_yoy$site)
fishery_ser=unique(glass_eel_yoy$ser_id[glass_eel_yoy$fishery_based=="commercial"])
length(na.omit(fishery_ser))
fishery_ind=unique(glass_eel_yoy$ser_id[glass_eel_yoy$fishery_based!="commercial"])
unique(glass_eel_yoy$site[glass_eel_yoy$fishery_based!="commercial"])
length(na.omit(fishery_ind))
R_stations[R_stations$ser_id%in%fishery_ser,"ser_nameshort"]

dev.off()
png(paste(imgwd,"number_series.png",sep=""),height=10/2.54,width=16/2.54,res=150,units="in")
par(mgp=c(1.5,.5,0),mar=c(2.5,2.5,.5,.5))
matplot(rownames(table(glass_eel_yoy$year,glass_eel_yoy$fishery_based)),table(glass_eel_yoy$year,glass_eel_yoy$fishery_based),type="b",lty=c(1,2),pch=1:2,,xlab="year",ylab="number of series",col=c("black","grey"))
legend("topleft",legend=c("fishery based","fishery independent"),pch=1:2,lty=1,col=c("black","grey"))
dev.off()

tmp=rowSums(table(glass_eel_yoy$year,glass_eel_yoy$fishery_based))
sweep(table(glass_eel_yoy$year,glass_eel_yoy$fishery_based),MARGIN=1,tmp,"/")


###fist year of the data series
length(sapply(unique(glass_eel_yoy$ser_id[glass_eel_yoy$fishery_based=="independent"]),function(id) min(glass_eel_yoy$year[glass_eel_yoy$ser_id==id])))
sum(sapply(unique(glass_eel_yoy$ser_id[glass_eel_yoy$fishery_based=="independent"]),function(id) min(glass_eel_yoy$year[glass_eel_yoy$ser_id==id]))<1980)
sum(sapply(unique(glass_eel_yoy$ser_id[glass_eel_yoy$fishery_based=="independent"]),function(id) min(glass_eel_yoy$year[glass_eel_yoy$ser_id==id]))>1999)


library(sf)
fish_location=st_read(con,query=paste("select ser_id,geom from datawg.t_series_ser where ser_id in (",paste(c(fishery_ser,fishery_ind),collapse=","),')'))
europe=st_read("/mnt/SIG/01-REFERENTIELS/LIMITES_ADMINISTRATIVES_monde/european_countries_WGS84.shp")


#spatial distribution of glass eel time series used in the assessment
png(paste(imgwd,"map_glass_eel.png",sep=""),res=150,width=10/2.54,height=10/2.54,units="in")
par(mgp=c(1.5,.5,0),mar=c(.5,.5,.5,.5))
plot(st_geometry(fish_location),col=1+fish_location$ser_id %in%fishery_ser,pch=NA)
plot(st_geometry(europe),col='white',add=TRUE,border="grey")
plot(st_geometry(st_jitter(fish_location,amount=.3)),col=ifelse(fish_location$ser_id %in%fishery_ser,"red","blue"),pch=19,add=TRUE,,cex=.5)
legend("right",legend=c("fishery based","independent"),pch=19,col=c("red","blue"))
dev.off()


################
# sensitivity analysis of GLM
# running the GLM on three distinct datasets
################

full_data=glass_eel_yoy
nofishery_data=subset(full_data,full_data$fishery_based!="commercial")
nofishery_2010_data=subset(full_data,full_data$fishery_based!="commercial" | full_data$year<2011)


#summary of available data for the datasets
summ_full_data=unique(na.omit(full_data[,c("area","ser_id","fishery_based")]))
table(summ_full_data[,c(1,3)])

summ_nofishery_data=unique(na.omit(nofishery_data[,c("area","ser_id","fishery_based")]))
table(summ_nofishery_data[,c(1,3)])

summ_nofishery2010_data=unique(na.omit(nofishery_2010_data[,c("area","ser_id","fishery_based")]))
table(summ_nofishery2010_data[,c(1,3)])

summ_full_dataCY=unique(full_data[full_data$year==CY,c("area","ser_id","fishery_based")])
table(summ_full_dataCY[,c(1,3)])

summ_nofishery_dataCY=unique(nofishery_data[nofishery_data$year==CY,c("area","ser_id","fishery_based")])
table(summ_nofishery_dataCY[,c(1,3)])

summ_nofishery2010_dataCY=unique(nofishery_2010_data[nofishery_2010_data$year==CY,c("area","ser_id","fishery_based")])
table(summ_nofishery2010_dataCY[,c(1,3)])


model_ge_area=glm(value_std~year_f:area+site,
		data=full_data,
		family=Gamma(link=log), maxit=300)
model_ge_area_no_fishery=glm(value_std~year_f:area+site,
                             data=nofishery_data,
                             family=Gamma(link=log), maxit=300)
model_ge_area_no_fishery_2010=glm(value_std~year_f:area+site,
                             data=nofishery_2010_data,
                             family=Gamma(link=log), maxit=300)



anova_full<-anova(model_ge_area,test="F")
anova_full$Deviance/anova_full$`Resid. Dev`[1]*100
anova_nofishery<-anova(model_ge_area_no_fishery,test="F")
anova_nofishery$Deviance/anova_nofishery$`Resid. Dev`[1]*100
anova_nofishery_2010<-anova(model_ge_area_no_fishery_2010,test="F")
anova_nofishery_2010$Deviance/anova_nofishery_2010$`Resid. Dev`[1]*100




###################################################
### code chunk number 10: model_for_glass_eel_graph_and_predictions
###################################################
# using expand.grid to build a complete grid for predictions
data_bis=expand.grid(year_f=model_ge_area$xlevels$year_f,area=model_ge_area$xlevels$area,
		site=model_ge_area$xlevels$site)
data_bis$fishery_based=glass_eel_yoy$fishery_based[match(data_bis$site,glass_eel_yoy$site)]
data_bis$year<-as.numeric(as.character(data_bis$year_f))


#predicting
data_bis$p_full=predict(model_ge_area,newdata=data_bis[,],type="response")
data_bis$se_full=predict(model_ge_area,newdata=data_bis[,],type="response",se.fit=TRUE)[["se.fit"]]

data_bis$p_nofishery=data_bisse_nofishery=NA
data_bis$p_nofishery[data_bis$fishery_based!="commercial"]=predict(model_ge_area_no_fishery,newdata=data_bis[data_bis$fishery_based!="commercial",],type="response")
data_bis$se_nofishery[data_bis$fishery_based!="commercial"]=predict(model_ge_area_no_fishery,newdata=data_bis[data_bis$fishery_based!="commercial",],type="response",se.fit=TRUE)[["se.fit"]]

data_bis$p_nofishery2010=predict(model_ge_area_no_fishery_2010,newdata=data_bis,type="response")
data_bis$se_nofishery2010=predict(model_ge_area_no_fishery_2010,newdata=data_bis,type="response",se.fit=TRUE)[["se.fit"]]




#standardising prediction to 1960-1980 level
# 2 options mean or geomean
if (opt_calculation=="geomean") {
	mean_1960_1979_full=data.frame(mean=unlist(
					tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p_full"],
							data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
							geomean)
	))
	mean_1960_1979_nofishery=data.frame(mean=unlist(
	  tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p_nofishery"],
	         data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
	         geomean)
	))
	mean_1960_1979_nofishery2010=data.frame(mean=unlist(
	  tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p_nofishery2010"],
	         data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
	         geomean)
	))
} else {
	mean_1960_1979=data.frame(mean=unlist(
					tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p"],
							data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
							mean)
	))
}
mean_1960_1979=cbind.data.frame(mean_1960_1979_full,mean_1960_1979_nofishery,mean_1960_1979_nofishery2010)
names(mean_1960_1979)=c("full","nofishery","nofishery2010")
mean_1960_1979$area=rownames(mean_1960_1979)
data_bis=merge(data_bis,mean_1960_1979,by="area")
data_bis$p_std_1960_1979_full=data_bis$p_full/data_bis$full
data_bis$p_std_1960_1979_nofishery=data_bis$p_nofishery/data_bis$nofishery
data_bis$p_std_1960_1979_nofishery2010=data_bis$p_nofishery2010/data_bis$nofishery2010

# A tapply to calculate either geom mean or mean of series ------------------------------------------

# cannot show any se on average value, se is on each individual value !
#data_bis$se_std_1960_1979=data_bis$se/data_bis$geomean 
#data_bis$ymin<-data_bis$p_std_1960_1979-data_bis$se_std_1960_1979
#data_bis$ymax<-data_bis$p_std_1960_1979+data_bis$se_std_1960_1979
# geomean does not return a "nice" numeric, hence the trick below
if (opt_calculation=="geomean") {
  synthesis_full=as.data.frame(tapply(data_bis[,"p_std_1960_1979_full"],
                                 list(data_bis[,"year_f"],data_bis[,"area"]),
                                 function(X) {Y=geomean(X) ;
                                 return(as.numeric(Y))}))
  synthesis_nofishery=as.data.frame(tapply(data_bis[,"p_std_1960_1979_nofishery"],
                                      list(data_bis[,"year_f"],data_bis[,"area"]),
                                      function(X) {Y=geomean(X) ;
                                      return(as.numeric(Y))}))
  synthesis_nofishery2010=as.data.frame(tapply(data_bis[,"p_std_1960_1979_nofishery2010"],
                                           list(data_bis[,"year_f"],data_bis[,"area"]),
                                           function(X) {Y=geomean(X) ;
                                           return(as.numeric(Y))}))
} else {
  synthesis=as.data.frame(tapply(data_bis[,"p_std_1960_1979"],
                                 list(data_bis[,"year_f"],data_bis[,"area"]),mean,na.rm=TRUE))
}

# Save data_bis as glass_eel_pred for shiny ----------------------------------------------
glass_eel_pred <- data_bis
save(glass_eel_pred,file=str_c(datawd,"glass_eel_pred.Rdata"))
resy=function(data,valcol){
  data$time=rownames(data)
  data1=melt(data,id.vars=ncol(data))
  colnames(data1)=c("year","area",valcol)
  data1$year=as.Date(strptime(paste(data1$year,"-01-01",sep=""),format="%Y-%m-%d"))
  return(data1)
}
dat_full=resy(synthesis_full,"p_std_1960_1979")
dat_nofishery=resy(synthesis_nofishery,"p_std_1960_1979")
dat_nofishery2010=resy(synthesis_nofishery2010,"p_std_1960_1979")


##plotting
#with(synthesis,matplot(time,log(synthesis[,-dim(synthesis)[2]]),type="l"))
#legend("topright",legend=names(synthesis)[-dim(synthesis)[2]],lty=1:5,col=1:6)
#abline(v=seq(1950,2005,5),lty=2,col="gray")
#abline(v=seq(1950,2005,10))

#tat_sum_single <- function(fun, geom="point", ...) { 
#   stat_summary(fun.y=fun, colour="red", geom=geom, size = 3, ...) 
# } 
# 

dat_full$dataset="full"
dat_nofishery$dataset="nofishery"
dat_nofishery2010$dataset="nofishery2010"
dat=rbind.data.frame(dat_full,dat_nofishery,dat_nofishery2010)

dat$isno2010=ifelse(dat$dataset=="nofishery2010",TRUE,FALSE)

g<-ggplot(dat,aes(x=year,y=p_std_1960_1979))

figure5_without_logscale<-g+geom_line(aes(colour=area,lty=dataset),lwd=1)+ 
  scale_colour_brewer(name="area",palette="Set1")+
  scale_y_continuous(expression(frac(p,bar(p)[1960-1979])))+
  theme_bw()+
  geom_hline(yintercept=1,linetype=2)+
  theme(legend.box =NULL,
        legend.key = element_rect(colour = NA, fill = 'white'),
        legend.text = element_text(size = 10, colour = 'black'), 
        legend.background = element_rect(colour = NA, fill = 'white'),
        legend.position = c(.8, .8))
X11(300,250)
figure5_without_logscale
save_figure("figure5_without_logscale",figure5_without_logscale,600,480)

# function similar to theme_dark() but allows legends
# black and white plot ====
figure5_without_logscale_black<-g+geom_line(aes(colour=area,lty=dataset),lwd=1)+
  scale_colour_manual(name="area",values=c("yellow","lawngreen"))+
  scale_y_continuous(expression(frac(p,bar(p)[1960-1979])))+
  theme_black()

X11()
figure5_without_logscale_black
save_figure("figure5_without_logscale_black",figure5_without_logscale_black,600,480)


#====
#+geom_smooth(aes(ymin = min, ymax = max,fill=area),stat="identity")+facet_grid( ~ area) 
datEE<-dat[dat$area=="Elsewhere Europe",]
datNS<-dat[dat$area=="North Sea",]
labelEE<-100*round(datEE$p_std_1960_1979[length(datEE$p_std_1960_1979)],3)
labelNS<-100*round(datNS$p_std_1960_1979[length(datNS$p_std_1960_1979)],3)

figure5<-g+geom_line(aes(colour=dataset,lty=isno2010),lwd=1)+
  #ggtitle("Recruitment overview glass eel series")+
  scale_colour_brewer(name="dataset",palette="Set1")  +
  #annotate("text",x=dat$year[length(dat$year)-2],y=datEE$p_std_1960_1979[length(datEE$p_std_1960_1979)],size=5,label=labelEE)+
  #annotate("text",x=dat$year[length(dat$year)-2],y=datNS$p_std_1960_1979[length(datNS$p_std_1960_1979)],size=5,label=labelNS)+		
  scale_y_log10(name=expression(frac(p,bar(p)[1960-1979])~' log scale'),
                #limits=c(0.005,10),
                breaks=c(0.01,0.1,1,10),
                labels=c("1%","10%","100%","1000%"))+
  theme_bw()+
  theme(legend.box =NULL,
        legend.key = element_rect(colour = NA, fill = 'white'),
        legend.text = element_text(size = 10, colour = 'black'), 
        legend.background = element_rect(colour = NA, fill = 'white'),
        legend.position=c(.25,.6))+guides(lty=FALSE)+facet_grid(area~.)

x11(width=16/2.54,height=12/2.54)
figure5
ggsave(paste(imgwd,"logR.png",sep=""),dpi=150,width=16/2.54,height=12/2.54,units="in")
save_figure("figure5",figure5,600,480)
save_figure("figure5",figure5,600,480)
#save_figure("figure5danish",figure5danish,600,480)

#figure5danish<-g+geom_line(aes(colour=area,lty=area),lwd=1.3)+
#		geom_point(aes(colour=area,fill=area,shape=area),size=3)+
#		ggtitle("title="Glasaal data fra hele Europa")+
#		scale_colour_brewer(name="area",palette="Set1")  +
#		xlab("Aar")+
#		scale_y_log10(name="Linear model forudsigelser/ gennemsnit 1960-1979",
#				#limits=c(0.005,10),
#				breaks=c(0.01,0.1,1,10),
#				labels=c("1%","10%","100%","1000%"))
levels(dat$area)=c("EE","NS")
g<-ggplot(dat,aes(x=year,y=p_std_1960_1979))

#figure5bw<-g+geom_line(aes(colour=area,lty=area),wd=1.3)+
#		geom_point(aes(colour=area,fill=area,shape=area),size=3)+
#		#ggtitle("Recruitment overview glass eel series")+
#		scale_colour_manual(name="area",values=c("black","grey40"))  +
#		#annotate("text",x=dat$year[length(dat$year)-2],y=datEE$p_std_1960_1979[length(datEE$p_std_1960_1979)],size=5,label=labelEE)+
#		#annotate("text",x=dat$year[length(dat$year)-2],y=datNS$p_std_1960_1979[length(datNS$p_std_1960_1979)],size=5,label=labelNS)+		
#		scale_y_log10(name="standardized glm predictions \n mean 1960-1979-log scale",
#				#limits=c(0.005,10),
#				breaks=c(0.01,0.1,1,10),
#				labels=c("1%","10%","100%","1000%"))+
#		theme_bw()+
#		theme(legend.box =NULL,
#				legend.key = element_rect(colour = NA, fill = 'white'),
#				legend.text = element_text(size = 8, colour = 'black'), 
#				legend.background = element_rect(colour = NA, fill = 'white'))
#print(figure5bw)
#save_figure("figure5bw",figure5bw,600,480)

synthesis$year=as.numeric(rownames(synthesis))
synthesis$decade=trunc(as.numeric(synthesis$year)/5)*5
five_year_avg_glass<-data.frame("Elsewhere Europe"=tapply(synthesis$"Elsewhere Europe",synthesis$decade,mean,na.rm=T),
                                "North Sea"=tapply(synthesis$"North Sea",synthesis$decade,mean,na.rm=T))
synthesis$rebour<-nrow(synthesis):1
last<-synthesis$rebour<=5
five_year_avg_glass<-rbind(five_year_avg_glass,apply(synthesis[last,c("Elsewhere Europe","North Sea") ],2,mean))
rownames(five_year_avg_glass)[nrow(five_year_avg_glass)]<-"last"

#xfive_year_avg_glass <- xtable(x = five_year_avg_glass,
#		label = "table_five_year_avg_glass",
#		caption = str_c("GLM estimates for glass eel series, averaged every five years"))
#print(xfive_year_avg_glass, 
#		file = str_c(tabwd,"/table_five_year_avg_glass.tex"),
#		table.placement = "htbp",
#		caption.placement = "top", 
#		NA.string = ".")
gg0full<-synthesis_full[as.character(1960:CY),c("Elsewhere Europe","North Sea")]
colnames(gg0full)<-c("EE","NS")

gg_full<-split_per_decade_ge(gg0full)
gg_full[,1:8]<-100*round(gg_full[,1:8],2)
gg_full[,9:ncol(gg_full)]<-100*round(gg_full[,9:ncol(gg_full)],3)

gg0nofishery<-synthesis_nofishery[as.character(1960:CY),c("Elsewhere Europe","North Sea")]
colnames(gg0nofishery)<-c("EE","NS")
gg_nofishery<-split_per_decade_ge(gg0nofishery)
gg_nofishery[,1:8]<-100*round(gg_nofishery[,1:8],2)
gg_nofishery[,9:ncol(gg_nofishery)]<-100*round(gg_nofishery[,9:ncol(gg_nofishery)],3)


gg0nofishery2010<-synthesis_nofishery2010[as.character(1960:CY),c("Elsewhere Europe","North Sea")]
colnames(gg0nofishery2010)<-c("EE","NS")
gg_nofishery2010<-split_per_decade_ge(gg0nofishery2010)
gg_nofishery2010[,1:8]<-100*round(gg_nofishery2010[,1:8],2)
gg_nofishery2010[,9:ncol(gg_nofishery2010)]<-100*round(gg_nofishery2010[,9:ncol(gg_nofishery2010)],3)


#decades results
decA<-tapply(synthesis$"North Sea",synthesis$decade,mean,na.rm=T)
decE<-tapply(synthesis$"Elsewhere Europe",synthesis$decade,mean,na.rm=T)
#decA[(length(decA)-1):length(decA)]
#decE[(length(decE)-1):length(decE)]



write.table(synthesis_full,file=paste(datawd,"glm_results_glass_full.csv",sep=""),sep=";")
write.table(synthesis_nofishery,file=paste(datawd,"glm_results_glass_nofishery.csv",sep=""),sep=";")
write.table(synthesis_nofishery2010,file=paste(datawd,"glm_results_glass_nofishery2010.csv",sep=""),sep=";")

save(dat_full, file="dat_ge_full.Rdata")
save(dat_nofishery, file="dat_ge_nofishery.Rdata")
save(dat_nofishery2010, file="dat_ge_nofishery2010.Rdata")


full_data$year_f=factor(full_data$year_f)



ny=length(levels(full_data$year_f))
contrast_matrix=matrix(0,nrow=ny,ncol=ny-1)
years=1960:CY
contrast_matrix[1,1:length(1961:1979)]=rep(-1,length(1961:1979))
for (i in 2:ny){
    contrast_matrix[i,i-1]=1
}
rownames(contrast_matrix)=levels(full_data$year_f)
colnames(contrast_matrix)=rownames(contrast_matrix)[-1]
contrasts(full_data$year_f)=contrast_matrix


model_ge_area=glm(value_std~year_f:area+site,
                  data=full_data,
                  family=Gamma(link=log), maxit=300)
coeff_model=as.data.frame(summary(model_ge_area)$coefficients)
abundance_indices=expand.grid(area=c("Elsewhere Europe","North Sea"),year_f=as.character(1961:CY))
predictions=apply(abundance_indices,1,function(x){
  area=x[1];year=x[2]
  eff_name=paste("year_f",year,":area",area,sep="")
  ieff=which(rownames(coeff_model)==eff_name)
  prediction=exp(coeff_model$Estimate[ieff])
  min_prediction=exp(coeff_model$Estimate[ieff]-1.96*coeff_model$`Std. Error`[ieff])
  max_prediction=exp(coeff_model$Estimate[ieff]+1.96*coeff_model$`Std. Error`[ieff])
  c(prediction,min_prediction,max_prediction)
})




###################################################
### code chunk number 10: model_for_glass_eel_graph_and_predictions
###################################################
# using expand.grid to build a complete grid for predictions
data_ter=expand.grid(year_f=model_ge_area$xlevels$year_f,area=model_ge_area$xlevels$area,
                     site=model_ge_area$xlevels$site[1])
data_ter$year<-as.numeric(as.character(data_ter$year_f))


#predicting
data_ter$p=predict(model_ge_area,newdata=data_ter)
data_ter$se=predict(model_ge_area,newdata=data_ter,se.fit=TRUE)[["se.fit"]]


#in the logscale we removed the arithmetic mean to standardise prediction relatively to
#1960-1980
mean_1960_1979=aggregate(data_ter[data_ter$year<1980,"p"],list(data_ter[data_ter$year<1980,"area"]),mean)
names(mean_1960_1979)=c("area","mean")

data_ter=merge(data_ter,mean_1960_1979,by="area")
data_ter$p_std_1960_1979=exp(data_ter$p-data_ter$mean)
data_ter$p_std_1960_1979_min=exp(data_ter$p-data_ter$mean-1.96*data_ter$se)
data_ter$p_std_1960_1979_max=exp(data_ter$p-data_ter$mean+1.96*data_ter$se)

ggplot(data_ter,aes(x=year,y=p_std_1960_1979))+geom_line(aes(col=area))+geom_ribbon(aes(ymin=p_std_1960_1979_min,ymax=p_std_1960_1979_max,fill=area),alpha=.3)

ggplot(data_ter,aes(x=year,y=p_std_1960_1979))+geom_line(aes(col=area))+geom_ribbon(aes(ymin=p_std_1960_1979_min,ymax=p_std_1960_1979_max,fill=area),alpha=.3)+
  scale_y_log10(name=expression(frac(p,bar(p)[1960-1979])~' log scale'),
                #limits=c(0.005,10),
                breaks=c(0.01,0.1,1,10),
                labels=c("1%","10%","100%","1000%"))


#indices that were updated in 2019
updated_ser=unique(full_data$ser_id[full_data$year==CY])

###get residuals of last year for those series
residuals_CY_1=data.frame(residuals=residuals(model_ge_area)[model_ge_area$data$ser_id %in% updated_ser & model_ge_area$data$year %in% ((CY-5):(CY-1))],
                           site=model_ge_area$data$site[model_ge_area$data$ser_id %in% updated_ser & model_ge_area$data$year %in% ((CY-5):(CY-1))],
                           year=model_ge_area$data$year[model_ge_area$data$ser_id %in% updated_ser & model_ge_area$data$year %in% ((CY-5):(CY-1))],
                           row.names=(which(model_ge_area$data$ser_id %in% updated_ser & model_ge_area$data$year %in% ((CY-5):(CY-1)))))

ggplot(residuals_CY_1,aes(y=residuals,x=site))+geom_bar(stat="identity")+geom_abline(intercept=0,slope=0)+facet_grid(year~.)+theme_bw()
ggsave(paste(imgwd("residuals.png",sep=""),height=16/2.54,width=16/2.54,dpi=150,units="in")



model_ge_area=glm(value_std~year_f:area+site,
                  data=full_data,
                  family=Gamma(link=log), maxit=300,weights=varIdent(form=~site))

