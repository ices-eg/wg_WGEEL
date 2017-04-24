### R code from vignette source 'recruitment_analysis.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: init
###################################################
# Password are stored in R/etc/Rprofile.site
# For the moment the database is stored locally
CY<-2016 # current year ==> don't forget to update the graphics path below
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
require("RODBC")
require("mgcv")
require("car")
require("ggplot2")
require("reshape") 
require("stacomirtools") # for ODBC connections
require("stringr")
require("Hmisc")
require("xtable")
require("grid")
require("sqldf") 
require("RPostgreSQL") 
require("RColorBrewer")
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
# It is necessary to create a folder, your code is currently stored in
#--------------------------------------------------
# FOLDER>WGEELgit>R>recruitment>recruitment_analysis.Rnw
#---------------------------------------------------
# This will be automatically set when pulling code from git
# WGEELgit is the local name you have chosen for the git repository,
# FOLDER is the directory where you have stored the git code
# So you need to create a directory to store data and figures besides this 
# directory, like this
# FOLDER>datawgeel>recruitement>2016>data
# FOLDER>datawgeel>recruitement>2016>image
# FOLDER>datawgeel>recruitement>2016>table
# here 2016 is the current year of recruitment (I have several folders one for each year)
# the reason for this is that we don't want to put data or figures in the git.
#--------------------------------
if(getUsername() == 'cedric.briand')
{
	# I have two password in the R.site of c:/program files/R... so I don't need no prompt
	password<-passworddistant
	baseODBC=c("wgeel","postgres",passwordlocal) #"w3.eptb-vilaine.fr" "localhost" "wgeel" "wgeel_distant" 
	options(sqldf.RPostgreSQL.user = "postgres", 
			sqldf.RPostgreSQL.password = passwordlocal,
			sqldf.RPostgreSQL.dbname = "wgeel",
			sqldf.RPostgreSQL.host = "localhost", # "localhost"
			sqldf.RPostgreSQL.port = 5432)
	setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/recruitment")
	
	wd<-getwd()
	wddata<-gsub("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R","F:/workspace/wgeeldata",wd)
	datawd<-str_c(wddata,"/",CY,"/data")
	imgwd<-str_c(wddata,"/",CY,"/image")
	tabwd<-str_c(wddata,"/",CY,"/table")
	shpwd=str_c("F:/workspace/wgeeldata/shp") 
}
if(getUsername() == 'lbeaulaton')
{
	password <- function(prompt = "Password:"){
		cat(prompt)
		pass <- system('stty -echo && read ff && stty echo && echo $ff && ff=""',
				intern=TRUE)
		cat('\n')
		invisible(pass)
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
	setwd("E:/Mes documents/Mes dossiers/eclipse workspace/projets/wgeel_cb/sweave")
	wd<-getwd()
	datawd<-str_c(wddata,"/",CY,"/data")
	imgwd<-str_c(wddata,"/",CY,"/image")
	tabwd<-str_c(wddata,"/",CY,"/table")
	shpwd=str_c(wddata,"/wgeel2013/emu") 
	shpwd="E:/Mes documents/Mes dossiers/eclipse workspace/projets/wgeel_cb/wgeel2013/emu" # where I store the shape file
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
	
	datawd<-str_c(wddata,"/",CY,"/data")
	imgwd<-str_c(wddata,"/",CY,"/image")
	tabwd<-str_c(wddata,"/",CY,"/table")
	shpwd=str_c(wddata,"/wgeel2013/emu") 
}
# some of the functions used later in that scrit :
source('utility_functions.R')
graphics.off() # close all graphics devices
# the results will be stored in a list, when I first run the program,
# on the second run this list will be loaded and I can avoid some steps in the calculation
# by setting the chunks as eval=FALSE
vv<-list()


###################################################
### code chunk number 2: load_database
###################################################
# In this chunk everything will be loaded. 
# The data selection is made tranparently later in the chunk "select_series"
# This chunks uses the RequeteODBC connection object from stacomirtools and sqldf
# an odbc link must be configured to the database : i.e. you must have the postgres
# database available, and an ODBC link pointing to the database.
# If you don't and still want to run this script, ask Cédric cedric.briand@eptb-vilaine.fr
# he will send you the Rdata saved during this chunk.


##########################"
# Description of the series
##########################
query=new("RequeteODBC")
query@baseODBC<-baseODBC
query@sql='select * from datawg.t_series_ser 
		left join ref.tr_station on ser_tblcodeid=tr_station."tblCodeID"
		left join ref.tr_country_cou on cou_code=ser_cou_code 
		left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
		left join ref.tr_faoareas on ser_area_division=f_division
		where ser_typ_id=1'
query=connect(query)
R_stations=query@query

##########################
# Main data from the series
##########################
query=new("RequeteODBC")
query@baseODBC<-baseODBC
query@sql='SELECT 
		das_id,
		das_value,       
		das_year,
		das_comment,
		/* 
		-- below those are data on effort, not used yet
		
		das_effort, 
		ser_effort_uni_code,       
		das_last_update,
		*/
		/* 
		-- this is the id on quality, not used yet but plans to use later
		-- to remove the data with problems on quality from the series
		-- see WKEEKDATA (2017)
		das_qal_id,
		*/ 
		ser_id,            
		ser_order,
		ser_nameshort,
		ser_area_division,
		f_subarea,
		lfs_code,          
		lfs_name
		from datawg.t_dataseries_das 
		join datawg.t_series_ser on das_ser_id=ser_id
		left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
		left join ref.tr_faoareas on ser_area_division=f_division
		where ser_typ_id=1' 
query=connect(query)
wger=query@query # (wge)el (r)ecruitment data
wger<-chnames(wger,
		c("das_id","das_value","das_year","ser_nameshort","ser_area_division","lfs_name"),
		c("id","value","year","site","area_division","lifestage"))
############################################################################
# Rebuilding areas used by wgeel (North Sea, Elswhere Europe) from area_divisions
# See Ices (2008) for the reason why we need to do that
# We cannot use just one series, as the series from the North Sea have dropped more
# rapidly than the others, and are now at a much lower level.
# Some of that drop might be explained by decreasing catch in some of the semi-commercial
# catch and trap and transport series (Ems, Vidaa) but it also concerns fully scientific
# Estimates....
###############################################################################
wger[,"area"]<-NA
# below these are area used in some of the scripts see wgeel 2008 and Willem's Analysis 
# but currently wgeel only uses two areas so the following script is kept for memory
# but mostly useless
wger$area[wger$f_subarea%in%'27.4']<-"North Sea"
wger$area[wger$f_subarea%in%'27.3']<-"Baltic"
wger$area[wger$f_subarea%in%c('27.6','27.7','27.8','27.9')]<-"Atlantic"
wger$area[wger$f_subarea%in%c('37.1','37.2','37.3')]<-"Mediterranean Sea"
wger[wger$area%in%c("Atlantic","Mediterranean Sea"),"area"]<-"Elsewhere Europe"
# We consider that the series of glass eel recruitment in the Baltic are influenced
# similarly in the Baltic and North Sea. This has no effect on Baltic data
wger[wger$area%in%c("Baltic"),"area"]<-"North Sea"

wger$area<-as.factor(wger$area)
# We will also need this for summary tables per recruitment site, here we go straight to 
# the result
R_stations[,"area"]<-NA
R_stations$area[R_stations$f_subarea%in%c('27.4','27.3')]<-"North Sea"
stopifnot(all(!is.na(R_stations$f_subarea)))
# the rest (currently NA) are Elwhere Europe
R_stations$area[is.na(R_stations$area)]<-"Elsewhere Europe"
# Check that there was no error in the query (while joining foreign table)
stopifnot(all(!duplicated(wger$id)))
# creates some variables
wger$decade=factor(trunc(wger$year/10)*10)
wger$year_f=factor(wger$year)
wger$decade=factor(wger$decade,level=sort(unique(as.numeric(as.character(wger$decade)))))
wger$ldata=log(wger$value)
wger$lifestage=as.factor(wger$lifestage)

# This is a view (like the result of a query) showing a summary of each series, including first year, last year,
# and duration
statseries<-sqldf("select * from datawg.series_summary")
save(wger,R_stations,file=str_c(datawd,"/wger.Rdata"))
save(statseries,file=str_c(datawd,"/statseries.Rdata"))


###################################################
### code chunk number 3: load_rdata
###################################################
# In this rchunk we load the data even if there is no connection to the database
load(file=str_c(datawd,"/wger.Rdata"))
load(file=str_c(datawd,"/statseries.Rdata"))


###################################################
### code chunk number 4: select_series
###################################################
#########################################################################
#We no longer want to use Severn HRMC 
##########################################################################
# Comments from Alan : the HMRC dataset is based on a guesstimate of distribution
#of nett trade data between glass vs yellow/silver until about 2008 and then much better
#EA sales data in more recent years  so a mix of two methods of collecting data,
#one of which is of uncertain quality. The Severn EA dataset is the catches reported 
#by fishermen  we know there was under reporting in old years but it is better now, 
#so there are quality issues too but at least the data source is consistent over time
## HMRC is ser_id 8
# wgerinit is used to keep the "whole" dataset, just in case we mess with it afterwards
wgerinit<-wger
vv$nb_series_init<-length(unique(wger$site)) # this is the true number at the beginning
wger<-wger[wger$ser_id!=8,]
statseries<-statseries[statseries$site!='SeHM',]

#########################################################################
# standardizing with 2000-2010
# this was a question asked by ACFM ? 2014 ?
# so it's still done, we produce a graph but don't show it
# as it might confuse the reader
##########################################################################

mdata=wger[wger$year>=2000 & wger$year<2010,]
std_site<-unique(mdata$site[order(mdata$site)])
# length(std_site) 
site<-unique(wger$site[order(wger$site)])
# length(site)  #52
unused_series_2000_2009 = site[!site%in%std_site] # "Vida" "YFS1"
vv$sc_2000_2009_unused_series<-unused_series_2000_2009
vv$sc_2000_2009_nb<-vv$nb_series_init-length(vv$sc_2000_2009_unused_series)
#add a column to R_station for flagging unused series
R_stations$unused_2000_2009 = FALSE
R_stations[R_stations$rec_nameshort %in% unused_series_2000_2009, "unused_2000_2009"] = TRUE
#ex(std_site)
# Inag and Maig left out from the analysis 
mean_site=data.frame(mean_2000_2009=as.numeric(tapply(mdata$value,mdata$ser_id,mean,na.rm=TRUE)))
mean_site$site=tapply(mdata$site,mdata$ser_id,function(X)unique(X))
wger=merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) # here we loose the two stations Inag and Maig and also Frémur
wger$value_std_2000_2009=wger$value/wger$mean_2000_2009

#########################################################################
#standardizing with mean from 1979-1994
##########################################################################

mdata=wger[wger$year>=1979 & wger$year<1994,]
std_site<-unique(mdata$site[order(mdata$site)])
# length(std_site) # 45
site<-unique(wger$site[order(wger$site)])
# length(site) #49
unused_series_1979_1994 = site[!site%in%std_site] # "Bres" "Fre"  "Inag" "Klit" "Maig" "Nors" "Sle"  "Vac"
vv$sc_1979_1994_unused_series<-unused_series_1979_1994
vv$sc_1979_1994_nb=vv$nb_series_init-length(vv$sc_1979_1994_unused_series)
#add a column to R_station for flagging unused series
R_stations$unused_1979_1994 = FALSE
R_stations[R_stations$rec_nameshort %in% unused_series_1979_1994, "unused_1979_1994"] = TRUE
mean_site=data.frame(mean_1979_1994=as.numeric(tapply(mdata$value,mdata$ser_id,mean,na.rm=TRUE)))
mean_site$site=tapply(mdata$site,mdata$ser_id,function(X)unique(X))
wger=merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) 
wger$value_std_1979_1994=wger$value/wger$mean_1979_1994

#########################################################################
#standardizing with mean (all data)
##########################################################################

mean_site=data.frame(mean=as.numeric(tapply(wger$value,wger$ser_id,mean,na.rm=TRUE)))
mean_site$site=tapply(wger$site,wger$ser_id,function(X)unique(X))
wger=merge(wger,mean_site,by="site",all.x=TRUE,all.y=FALSE) 
wger$value_std=wger$value/wger$mean


#########################################################################
#separating glass eel and yellow eels
##########################################################################


glass_eel_yoy=wger[wger$lifestage!="yellow eel" & wger$year>1959,] #glass eel and yoy
older=wger[wger$lifestage=="yellow eel" & wger$year>1959,] 

##########################################################################
# Some statistics for later use, nb of year per series
#########################################################################

nb_year=colSums(ftable(xtabs(formula = value_std_1979_1994~year+site,data=wger))>0)
names(nb_year)=colnames(xtabs(formula = value_std_1979_1994~year+site,data=wger))

###############################################################
# some other statistics used there
###############################################################

nb_series_glass_eel<-length(unique(glass_eel_yoy$site)) # this will be reported in the pdf later
vv$nb_series_glass_eel<-nb_series_glass_eel
nb_series_older<-length(unique(older$site)) # this will be reported in the pdf later
vv$nb_series_older<-nb_series_older
nb_series_final=nb_series_glass_eel+nb_series_older
vv$nb_series_final<-nb_series_final


###############################################################
# Finally saving the data
###############################################################

save(wger,file=paste(datawd,"wger.Rdata",sep="\\"))
save(older,file=paste(datawd,"older.Rdata",sep="\\"))
save(glass_eel_yoy,file=paste(datawd,"glass_eel_yoy.Rdata",sep="\\"))
write.table(glass_eel_yoy,file=str_c(datawd,"/glass_eel_yoy.csv"),sep=";")
write.table(older,file=str_c(datawd,"/older.csv"),sep=";")


###################################################
### code chunk number 5: table_series
###################################################
last_year<-tapply(wger$year,wger$site,function(X) max(X))
#stations updated to",CY
R_stations$areashort<-"EE"
R_stations$areashort[R_stations$area=="North Sea"]<-"NS"
series_CY<-R_stations[R_stations$ser_nameshort%in%names(last_year[last_year==CY]),c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division","ser_order")]
series_CY<-series_CY[order(series_CY$ser_order),-ncol(series_CY)]
vv$nCY<-nrow(series_CY) # number of series updated to the current year (for later use)
vv$nCYg<-nrow(series_CY[grepl("G",series_CY$ser_lfs_code),]) # number of series with glass eel updated to the current year
vv$nCYy<-nrow(series_CY[series_CY$ser_lfs_code=="Y",]) # number of series with yellow eel (only) updated to the current year

#"stations updated to",CY-1
series_CYm1<-R_stations[R_stations$ser_nameshort%in%names(last_year[last_year==CY-1]),c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division","ser_order")]
series_CYm1<-series_CY[order(series_CYm1$ser_order),-ncol(series_CYm1)]
vv$nCYm1<-nrow(series_CYm1) # number series updated last year only (and not this year)
vv$nCYm1g<-nrow(series_CYm1[grepl("G",series_CYm1$ser_lfs_code),]) # same for glass eel 
vv$nCYm1y<-nrow(series_CYm1[series_CYm1$ser_lfs_code=="Y",]) # same for yellow eel only
lost_ones<-last_year[last_year<CY-1] # Series that have not been updated for two years
d_lost_ones<-data.frame("site"=names(lost_ones),"year"=lost_ones) # data frame
series_lost<-merge(
		R_stations[R_stations$ser_nameshort%in%names(lost_ones),c(c("ser_nameshort","ser_namelong","cou_code","ser_lfs_code","areashort","ser_area_division"))],
		d_lost_ones,
		by.y="site",by.x="ser_nameshort")
series_lost<-series_lost[order(series_lost$year),]
vv$nseries_lost<-nrow(series_lost) # number of series not updated for the two last years
vv$nseries_lostg<-nrow(series_lost[grepl("G",series_lost$ser_lfs_code),])
vv$nseries_losty<-nrow(series_lost[series_lost$ser_lfs_code=="Y",])
#xtable of current year series


#------------------------------------------------------
# we use xtable to transform the table to a latex format
#------------------------------------------------------
colnames(series_CY)<-str_c("\\scshape{",c("Site","Name","Coun.","Stage","Area","Division"),"}")

xseries_CY <- xtable(x = series_CY,
		label = "table_seriesCY",
		caption = str_c("Series updated to ",CY),
		align=c("p{0cm}","p{1.3cm}","p{6.5cm}","p{1cm}","p{1cm}","p{1cm}","p{1.4cm}"))
print(xseries_CY, file = str_c(	tabwd,"/table_seriesCY.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		tabular.environment="tabularx",
		width="\\textwidth",
		include.rownames=FALSE
)
#------------------------------------------------------
# xtable of series current year minus one
#------------------------------------------------------
colnames(series_CYm1)<-str_c("\\scshape{",c("Site","Name","Coun.","Stage","Area","Division"),"}")
xseries_CYm1 <- xtable(x = series_CYm1,
		label = str_c("table_seriesCYm1"),
		caption = str_c("Series updated to ",CY-1),
		align=c("p{0cm}","p{1.3cm}","p{6.5cm}","p{1cm}","p{1cm}","p{1cm}","p{1.4cm}"))

print(xseries_CYm1, 
		file = str_c(tabwd,"/table_seriesCYm1.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		tabular.environment="tabularx",
		width="\\textwidth",
		include.rownames=FALSE
)
#------------------------------------------------------
# xtable of series that have not been udpated
#------------------------------------------------------
colnames(series_lost)<-str_c("\\scshape{",c("Site","Name","Coun.","Stage","Area","Division","Last Year"),"}")
xseries_lost <- xtable(x = series_lost,
		label = str_c("table_serieslost"),
		caption = str_c("Series stopped or not updated to ",CY-1),
		align=c("p{0cm}","p{1.3cm}","p{6.5cm}","p{1cm}","p{1cm}","p{1cm}","p{1.4cm}","p{1.2cm}"))
print(xseries_lost, 
		file = str_c(tabwd,"/table_serieslost.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		tabular.environment="tabularx",
		width="\\textwidth",
		include.rownames=FALSE
)
# number of series per area per year
area_year=table(glass_eel_yoy$year,glass_eel_yoy$area)
# number of series per stage per year
n_y_lfs<-reshape2::dcast(wger,year~lifestage,length,value.var="year")
n_y_lfs$sum<-rowSums(n_y_lfs[,c(2:4)])
colnames(n_y_lfs)<-c("year","glass","glass+yellow","yellow","sum")
rownames(n_y_lfs)<-n_y_lfs$"year"
#xn_y_lfs <- xtable(x = n_y_lfs, 
#		label = "table_n_y_lfs",
#		caption = str_c("Numer of series per stage per year"))
#print(xn_y_lfs, file = str_c(tabwd,"/table_n_y_lfs.tex"), 
#		table.placement = "htbp",
#		caption.placement = "top",
#		NA.string = ".")

#n_area_styp<-reshape2::dcast(wger,area~sampling_type,length,value.var="area")
#n_y_area<-reshape2::dcast(wger,year~area,length,value.var="area")
#n_y_area$sum<-rowSums(n_y_area[,c(2,3)])
#rownames(n_y_area)<-n_y_area$year
##xn_y_area <- xtable(x = n_y_area, 
##		label = str_c("table_n_y_area"),
##		caption = str_c("Number of series per geographical area per year"),
##		digits=0)
##print(xn_y_area, 
##		file = str_c(tabwd,"/table_n_y_area.tex"), 
##		table.placement = "htbp",
##		caption.placement = "top",
##		NA.string = ".")
printstatseries<-statseries[,c(1,3,4,5,6,7,8,9,10,11)]
printstatseries$sampling_type[printstatseries$sampling_type=="scientific estimate"]<-"sci. surv."
printstatseries$sampling_type[grep("trap",printstatseries$sampling_type)]<-"trap"
printstatseries$sampling_type[printstatseries$sampling_type=="commercial catch"]<-"com. catch"
printstatseries$sampling_type[printstatseries$sampling_type=="commercial CPUE"]<-"com. cpue"
column_to_import<-R_stations[,c("ser_nameshort","areashort")]
printstatseries<-merge(printstatseries,column_to_import,by.x="site",by.y="ser_nameshort")
printstatseries<-printstatseries[order(printstatseries$order),c(1,11,2:9)]
colnames(printstatseries)<-
		c("code","area","min","max","n+","n-", "life stage",      
				"sampling type","unit","habitat")
xstatseries <- xtable(x = printstatseries[1:20,], 
		label = str_c("statseries"),
		caption = str_c("Short description of the recruitment sites"),
		align=c("p{0cm}","p{1cm}","p{1cm}","p{1cm}","p{1cm}","p{0.8cm}","p{0.8cm}","p{1.5cm}","p{2.5cm}","p{2cm}","p{2cm}"),
		digits=0)
print(xstatseries , 
		file = str_c(tabwd,"/table_statseries.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		include.rownames=FALSE
)
xstatseries <- xtable(x = printstatseries[21:40,], 
		label = str_c("statseries"),
		caption = str_c("Short description of the recruitment sites (continued)"),
		align=c("p{0cm}","p{1cm}","p{1cm}","p{1cm}","p{1cm}","p{0.8cm}","p{0.8cm}","p{1.5cm}","p{2.5cm}","p{2cm}","p{2cm}"),
		digits=0)
print(xstatseries , 
		file = str_c(tabwd,"/table_statseries1.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		include.rownames=FALSE
)
xstatseries1 <- xtable(x = printstatseries[41:nrow(printstatseries),], 
		label = str_c("statseries"),
		caption = str_c("Short description of the recruitment sites (continued-yellow eel series) "),
		align=c("p{0cm}","p{1cm}","p{1cm}","p{1cm}","p{1cm}","p{0.8cm}","p{0.8cm}","p{1.5cm}","p{2.5cm}","p{2cm}","p{2cm}"),
		digits=0)
print(xstatseries1 , 
		file = str_c(tabwd,"/table_statseries2.tex"),
		table.placement = "htbp",
		caption.placement = "top",
		sanitize.colnames.function=function(x){x}, # otherwise \\ are escaped
		NA.string = ".",
		include.rownames=FALSE
)
################################################################
# some additional stats for the report
#################################################################
# in which year has there been the largest number of glass eel (or apparented) series ?
yearmaxglasseel<-n_y_lfs$year[which(max(n_y_lfs$"glass"+n_y_lfs$"glass+yellow")==n_y_lfs$"glass"+n_y_lfs$"glass+yellow")]
# and for how long ?
nbmaxglasseel<-max(n_y_lfs$"glass"+n_y_lfs$"glass+yellow")
# storing this in our nice list
vv$yearmaxglasseel<-yearmaxglasseel
vv$nbmaxglasseel<-nbmaxglasseel
# same for yellow eel
yearmaxyellow<-n_y_lfs$year[which(max(n_y_lfs$"yellow")==n_y_lfs$"yellow")]
nbmaxyellow<-max(n_y_lfs$"yellow")
vv$yearmaxyellow<-yearmaxyellow
vv$nbmaxyellow<-nbmaxyellow



###################################################
### code chunk number 6: figure_series
###################################################

figure2<-function(){
	par(mar=c(4,4,0,0)+.5)
	matplot(rownames(table(wger$year,wger$lifestage)),table(wger$year,wger$lifestage),type="b",lty=c(1,2,3),pch=c(16,17,18),col=c("black","black","grey"),xlab="year",ylab="number of series")
	legend("topleft",legend=colnames(table(wger$year,wger$lifestage)),lty=c(1,2,3),pch=c(16,17,18),col=c("black","black","grey"))
}

figname<-"figure2"
# {{{{{{{{{{{{{{{{{{{{{{{{{
jpeg(filename = paste(imgwd,"/",figname,".jpeg",sep="")) #, width =480, height = 600
figure2()
rien<-dev.off()
# {{{{{{{{{{{{{{{{{{{{{{{{{
bmp(filename = paste(imgwd,"/",figname,".bmp",sep=""))
figure2()
rien<-dev.off()
# {{{{{{{{{{{{{{{{{{{{{{{{{
png(filename = paste(imgwd,"/",figname,".png",sep=""))
figure2()
rien<-dev.off()
# {{{{{{{{{{{{{{{{{{{{{{{{{




###################################################
### code chunk number 7: tableswgeel (eval = FALSE)
###################################################
## # THIS R CHUNCK IS USED ONCE AT THE END TO GENERATE THE TABLES.
## ## This will fail if saved twice, run at the end of the working group to generate the table of values
## dat<-wger[order(wger$ser_order,wger$year),]
## dat$year=as.factor(dat$year)
## stopifnot(length(unique(dat$ser_order))== length(unique(dat$ser_id)))
## # this will create the table to export to excel with all raw data
## tab1<-reshape2::dcast(dat,year~ser_order,value.var="value")
## tab1[,2:ncol(tab1)]=round(tab1[,2:ncol(tab1)],2)
## colnames(tab1)<-c("year",statseries$site)
## 
## 
## createxl<-function(data=tab1,sheet="recruitment_series"){
## 	library("XLConnect")
## 	xls.file<-str_c(datawd,"/","table_rec2016.xls")
## 	wb = loadWorkbook(xls.file, create = TRUE)
## 	createSheet(wb,sheet)
## 	writeWorksheet (wb , data , sheet=sheet ,header = TRUE )
## 	saveWorkbook(wb)
## 	#cat("travail terminé\n")
## }
## createxl(data=tab1,sheet="recruitment_series")
## createxl(data=statseries,sheet="series_description")
## 


###################################################
### code chunk number 8: generation_of_plot_data
###################################################
###################################################
# Generation of the dataframes used to plot the data
# two similar dataframe are created
# with the new ggplot2 it is no longer necessary but code was developped earlier at
# the time when such format was still necessary
# we will create a first dataframe (scal) with all the series together, this was
# the initial analysis built by Wgeel, and it is kept for historical consistency
# later on the geomean have been added , and the graph add a bootstrap calculation of the mean (bootscal)
# At some point the wgeel discussed that it might make more sense to separate
# glass eel (scalgeel) and yellow eel (scalyellow), so this graph is showing all, the geomean on all series, the
# trend for glass eel and the trend for yellow eel. This graph shows "unprocessed" data,
# as the wgeel recruitment index uses a glm index to rebuilt a consistent series.
# At some point ACFM asked to use a different scaling period and we complied but the graph
# is no longer shown as it is a bit confusing.
###################################################
scal=data.frame("year"=as.numeric(names(tapply(wger$value_std_1979_1994,wger$year,min,na.rm=TRUE))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(wger$value_std_1979_1994,wger$year,min,na.rm=TRUE),
		"ymax"=tapply(wger$value_std_1979_1994,wger$year,max,na.rm=TRUE),
		"mean"=tapply(wger$value_std_1979_1994,wger$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(wger$value_std_1979_1994,wger$year,geomean,na.rm=TRUE)))
li_cl_boot=tapply(wger$value_std_1979_1994,wger$year,smean.cl.boot)
bootscal=data.frame("year"=as.numeric(names(li_cl_boot)),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"=unlist(lapply(li_cl_boot,function(X)X["Lower"])),
		"ymax"=unlist(lapply(li_cl_boot,function(X)X["Upper"])),
		"mean"=unlist(lapply(li_cl_boot,function(X)X["Mean"])),
		"geomean"=NA)
# creating a subset with all data (glass_eel_yoy is limited in its timeframe)
datageel=subset(wger,wger$lifestage!="yellow eel")
scalgeel=data.frame(
		"year"=as.numeric(names(tapply(datageel$value_std_1979_1994,datageel$year,min,na.rm=TRUE))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(datageel$value_std_1979_1994,datageel$year,min,na.rm=TRUE),
		"ymax"=	tapply(datageel$value_std_1979_1994,datageel$year,max,na.rm=TRUE),	
		"mean"=tapply(datageel$value_std_1979_1994,datageel$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(datageel$value_std_1979_1994,datageel$year,geomean,na.rm=TRUE))
)
datayellow=subset(wger,wger$lifestage=="yellow eel")
scalyellow=data.frame(
		"year"=as.numeric(names(tapply(datayellow$value_std_1979_1994,datayellow$year,min,na.rm=TRUE))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(datayellow$value_std_1979_1994,datayellow$year,min,na.rm=TRUE),
		"ymax"=	tapply(datayellow$value_std_1979_1994,datayellow$year,max,na.rm=TRUE),	
		"mean"=tapply(datayellow$value_std_1979_1994,datayellow$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(datayellow$value_std_1979_1994,datayellow$year,geomean,na.rm=TRUE)))
scaldata=wger[,c("year","value_std_1979_1994","value_std","site","lifestage")]
################################################################
# With scaling 2000-2010
##############################################################

scal_2000_2009=data.frame("year"=as.numeric(names(tapply(wger$value_std_2000_2009,wger$year,min,na.rm=TRUE))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(wger$value_std_2000_2009,wger$year,min,na.rm=TRUE),
		"ymax"=tapply(wger$value_std_2000_2009,wger$year,max,na.rm=TRUE),
		"mean"=tapply(wger$value_std_2000_2009,wger$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(wger$value_std_2000_2009,wger$year,geomean)))
li_cl_boot=tapply(wger$value_std_2000_2009,wger$year,smean.cl.boot)
bootscal_2000_2009=data.frame("year"=as.numeric(names(li_cl_boot)),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"=unlist(lapply(li_cl_boot,function(X)X["Lower"])),
		"ymax"=unlist(lapply(li_cl_boot,function(X)X["Upper"])),
		"mean"=unlist(lapply(li_cl_boot,function(X)X["Mean"])),
		"geomean"=NA)

scalgeel_2000_2009=data.frame(
		"year"=as.numeric(names(tapply(datageel$value_std_2000_2009,datageel$year,min))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(datageel$value_std_2000_2009,datageel$year,min,na.rm=TRUE),
		"ymax"=	tapply(datageel$value_std_2000_2009,datageel$year,max,na.rm=TRUE),	
		"mean"=tapply(datageel$value_std_2000_2009,datageel$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(datageel$value_std_2000_2009,datageel$year,geomean))
)

scalyellow_2000_2009=data.frame(
		"year"=as.numeric(names(tapply(datayellow$value_std_2000_2009,datayellow$year,min,na.rm=TRUE))),
		"value_std"=NA,
		"name"=NA,
		"lifestage"=NA,
		"ymin"= tapply(datayellow$value_std_2000_2009,datayellow$year,min,na.rm=TRUE),
		"ymax"=	tapply(datayellow$value_std_2000_2009,datayellow$year,max,na.rm=TRUE),	
		"mean"=tapply(datayellow$value_std_2000_2009,datayellow$year,mean,na.rm=TRUE),
		"geomean"=unlist(tapply(datayellow$value_std_2000_2009,datayellow$year,geomean,na.rm=TRUE)))
scaldata_2000_2009=wger[,c("year","value_std_2000_2009","site","lifestage")]

#########################
# for Miran
# exporting the geomeans 
########################
print("simple geomeans for glass eel, asked by Miran")
round(unlist(tapply(datageel$value_std_1979_1994,datageel$year,geomean)),3)
print ("simple geomeans for yellow eels")
round(unlist(tapply(datayellow$value_std_1979_1994,datayellow$year,geomean)),3)

########################################
# FIGURE 3 WITHOUT LOG SCALE
# normalscale + geomean+ bootstrap scaled mean and confidence interval
#########################################

g<-ggplot(scaldata)
g1<-g+geom_point(aes(x=year, y=value_std_1979_1994,colour=site,shape=lifestage),size=1.5)+
		geom_line(aes(x=year, y=value_std_1979_1994,colour=site,lty=lifestage),size=0.4)+
		ylab("scaled 1979-1994 values")+
		geom_pointrange(data=bootscal,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="black")+
		geom_line(data=scal,aes(x=year,y=geomean),colour="red",size=1.2)+
		theme(legend.position = "none")

figure3withoutlogscale<-g1+	scale_x_continuous(breaks=c(1900,1930,1950,1970,1980,1990,2000,2010),minor_breaks=seq(from=min(scaldata$year),to=max(scaldata$year),by=2))+
		scale_y_continuous(limits=c(0,10))+annotate("rect",xmin=1900,ymin=0,xmax=1960,ymax=10,fill="grey",alpha=0.5)
x11(800,600)

print(figure3withoutlogscale)
dev.off()
# {{{{{{{{{{{{{{{{{{{{{{{{{
save_figure("figure3withoutlogscale",figure3withoutlogscale,800,600)
# {{{{{{{{{{{{{{{{{{{{{{{{{
# scaldata[scaldata$year>2000&scaldata$value_std>1,]
########################################
# FIGURE 3 WITH LOG SCALE
# All series 1979-1994 +
#  geomean+ bootstrap scaled mean and confidence interval
#########################################

figure3<-g1+
		scale_y_log10(name="scaled 1979-1994 values log scale",limits=c(0.001,30),breaks=c(0.01,0.1,1,10),labels=c("1%","10%","100%","1000%"))+
		#ylab()
		
		scale_x_continuous(breaks=c(1900,1930,1950,1970,1980,1990,2000,2010),
				minor_breaks=seq(from=min(scaldata$year),to=max(scaldata$year),by=2))+
		annotate("rect",xmin=1900,ymin=0,xmax=1960,ymax=30,fill="grey",alpha=0.5)
x11(800,600)
print(figure3)
# {{{{{{{{{{{{{{{{{{{{{{{{{
save_figure(figname="figure3",figure3,800,600)

########################################
# FIGURE 3 WITH LOG SCALE {{BLACK}}
# All series 1979-1994 +
#  geomean+ bootstrap scaled mean and confidence interval
#########################################

g<-ggplot(scaldata)
figure3black<-g+geom_point(aes(x=year, y=value_std_1979_1994,colour=site,shape=lifestage),size=1.5,show.legend=FALSE)+
		geom_line(aes(x=year, y=value_std_1979_1994,colour=site,lty=lifestage),size=0.4,show.legend=FALSE)+
		#ylab("scaled 1979-1994 values")+
		geom_pointrange(data=bootscal,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="beige")+
		geom_line(data=scal,aes(x=year,y=geomean),colour="red",size=1.2)+
		scale_y_log10(name="percentage of 1979-1994",limits=c(0.005,10),breaks=c(0.01,0.1,1,10),labels=c("1%","10%","100%","1000%"))+
		scale_x_continuous(breaks=c(1930,1950,1970,1980,1990,2000,2010),
				minor_breaks=seq(from=min(scaldata$year),to=max(scaldata$year),by=2),limits=c(1930,CY))+
		theme_black()
x11(800,600)
print(figure3black)
# {{{{{{{{{{{{{{{{{{{{{{{{{
save_figure(figname="figure3black",figure3black,800,600)

# {{{{{{{{{{{{{{{{{{{{{{{{{
##########################################
## Same graph for presentation but labels are in French
##########################################
#g<-ggplot(scaldata)
#g+geom_point(aes(x=year, y=value_std,colour=site,shape=lifestage),size=1.5,legend=FALSE)+
#		geom_line(aes(x=year, y=value_std,colour=site,lty=lifestage),size=0.4,legend=FALSE)+
#		opts(title="Tendance du recrutement Europeen")+
#		#ylab("scaled 1979-1994 values")+
#		geom_pointrange(data=bootscal,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="beige")+
#		scale_y_log10(name="% de 1979-1994",limits=c(0.005,10),breaks=c(0.01,0.1,1,10),labels=c("1%","10%","100%","1000%"))+
#		scale_x_continuous(name="Annee",breaks=c(1930,1950,1970,1980,1990,2000,2010),
#				minor_breaks=seq(from=min(scaldata$year),to=max(scaldata$year),by=2),limits=c(1930,2010))+theme_dark()
########################################
# FIGURE 4 
# limited graph with scale
########################################
scallog<-scal
scallog[scallog$ymin<1e-2,"ymin"]<-1e-2
scallog[scallog$ymax>30,"ymax"]<-30
g<-ggplot(scallog)
figure4<-g+geom_ribbon(aes(x=year,ymin=ymin,ymax=ymax),fill="grey",data=scallog)+
		ylab("scaled 1979-1994 values log scale")+
		geom_line(aes(x=year,y=mean),data=scalgeel,colour="darkblue",size=1)+
		geom_line(aes(x=year,y=mean),data=scalyellow,colour="darkorange4",size = 1)+
		geom_pointrange(data=bootscal,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="black")+
		scale_y_log10(limits=c(0.01,30),breaks=c(0.01,0.1,1,10,100,1000),labels=c("0.01","0.1","1","10","100","1000"))+
		annotate("rect",xmin=1930,ymin=0.01,xmax=1960,ymax=30,fill="white",alpha=0.7)+
		scale_x_continuous(limits=c(1930,CY))
x11(800,600)
print(figure4)
save_figure(figname="figure4",figure4,800,600)

########################################
# FIGURE 4 
# BUT WITH REFERENCE 2000-2010 !
########################################
scallog<-scal_2000_2009
scallog[scallog$ymin<1e-1,"ymin"]<-1e-1
scallog[scallog$ymax>1000,"ymax"]<-1000
g<-ggplot(scallog)
figure42000_2009<-g+geom_ribbon(aes(x=year,ymin=ymin,ymax=ymax),fill="grey")+
		#ggtitle("Recruitment European overview")+
		ylab("scaled to 2000-2010, log scale")+
		geom_line(aes(x=year,y=mean),data=scalgeel_2000_2009,colour="darkblue",size=1)+
		geom_line(aes(x=year,y=mean),data=scalyellow_2000_2009,colour="darkorange4",size = 1)+
		geom_pointrange(data=bootscal_2000_2009,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="black")+
		geom_abline( intercept = 0,slope=0,	alpha = .4,col="red")+
		geom_abline( intercept = 2,slope=0,	alpha = .4,col="red")+
		scale_y_log10(limits=c(1e-1,1000),breaks=c(0.01,0.1,1,10,100,1000),labels=c("0.01","0.1","1","10","100","1000"))+		
		scale_x_continuous(limits=c(1930,CY))+
		annotate("rect",xmin=1930,ymin=1e-1,xmax=1960,ymax=1000,fill="white",alpha=0.7)+
		annotate("rect", xmin = 2000, xmax = 2009, ymin = 0.3, ymax = 3,
				alpha = .2,fill="blue")

x11(800,600)
print(figure42000_2009)
# {{{{{{{{{{{{{{{{{{{{{{{{{
save_figure(figname="figure4_2000_2009",figure42000_2009,800,600)

########################################
# FIGURE NOTHING 
# JUST TO CHECK 
########################################
x11()
xg<-unlist(tapply(datageel$value_std,datageel$year,geomean))
rxg<-as.numeric(names(xg))
xy<-unlist(tapply(datayellow$value_std,datayellow$year,geomean))
rxy<-as.numeric(names(xy))
plot(rxg,
		xg,
		type="b",
		main="a simple graph to check that ggplot's running fine")
points(rxy,xy,type="l",col="green")
legend("topright",legend=c("glass","yellow"),col=c("black","green"),lty=1)

# additional figure to check log scaled
x11()
plot(rxy,
		xy,log="y",
		type="b",col="green")
points(rxg,xg,type="l")
#tapply(wger$value_std,wger$year,mean_cl_boot)


########################################
# Figure to put forward recent changes in the series
# WITH REFERENCE 2000-2010 !
########################################
figure_check_one_series<-function(site='Katw',limits=c(1900,CY)){
	g<-ggplot(scaldata_2000_2009)
	g<-g+geom_point(aes(x=year, y=value_std_2000_2009),col="grey",size=1.5)+
			geom_line(aes(x=year, y=value_std_2000_2009),col="grey",size=0.4)+
			geom_point(aes(x=year, y=value_std_2000_2009),colour="blue",size=1,data=scaldata_2000_2009[scaldata_2000_2009$site==site,])+
			geom_line(aes(x=year, y=value_std_2000_2009),colour="blue",size=1,data=scaldata_2000_2009[scaldata_2000_2009$site==site,])+
			ylab("scaled 1979-1994 values")+
			geom_pointrange(data=bootscal_2000_2009,aes(x=year,y=mean,ymin=ymin,ymax=ymax),size=0.5,colour="black")+
			geom_line(data=scal_2000_2009,aes(x=year,y=geomean),colour="red",size=1.2)+
			theme(legend.position = "none")+
			scale_x_continuous(limits=limits,breaks=c(1900,1930,1950,1970,1980,1990,2000,2010),minor_breaks=seq(from=min(scaldata_2000_2009$year),to=max(scaldata_2000_2009$year),by=2))+
			scale_y_continuous(limits=c(0,20))+
			annotate("rect",xmin=1900,ymin=0,xmax=1960,ymax=10,fill="grey",alpha=0.5)
	return(g)
}
figure_check_one_series("Katw",limits=c(1960,2016))


###################################################
### code chunk number 9: model_for_glass_eel_and_yellow_eel
###################################################
glass_eel_yoy$site<-as.factor(glass_eel_yoy$site)

model_ge_area=glm(value_std~year_f:area+site,
		data=glass_eel_yoy[glass_eel_yoy$value>0 & glass_eel_yoy$year>1959,],
		family=Gamma(link=log), maxit=300)
print("Analysis for glass eel")
print("data available")
(area_year=table(glass_eel_yoy$year,glass_eel_yoy$area))
print("number of sites finally selected for glass eel glm")
vv$modelge<-list()
vv$modelge$site<-as.character(model_ge_area$xlevels$site)
vv$modelge$nbsite<-length(vv$modelge$site)
vv$modelge$excluded<-unique(glass_eel_yoy$site)[!unique(glass_eel_yoy$site)%in%vv$modelge$site]
vv$modelge$value_excluded_zero<-glass_eel_yoy[glass_eel_yoy$value==0&!is.na(glass_eel_yoy$value),
		c("value_std","site","year","lifestage","das_comment","area")]

model_older=glm(value_std~year_f+as.factor(site),data=older,family=Gamma(link=log),
		subset=older$value>0 & older$year>1949  ,maxit=300)
vv$modelolder<-list()
vv$modelolder$site<-as.numeric(as.character(model_older$xlevels$`as.factor(site)`))
vv$modelolder$nbsite<-length(vv$modelolder$site)
vv$modelolder$excluded<-unique(older$site)[!unique(older$site)%in%vv$modelolder$site]
vv$modelolder$excludedsite<-unique(older[older$site%in%vv$modelolder$excluded,"site"])
vv$modelolder$excludedsite<-unique(older[older$site%in%vv$modelolder$excluded,"site"])
vv$modelolder$value_excluded_zero<-older[older$value==0,
		c("value_std","site","year","lifestage","das_comment","area")]

xt_a<-xtable(anova(model_ge_area,test="F"),
		caption=c("Anova for glass eel recruitment model",
				label="table_anova"))

o<-print(xt_a, file = str_c(tabwd,"/table_anova.tex"), 
		table.placement = "htbp",
		caption.placement = "top",
		NA.string = "",
		include.rownames=TRUE,
		tabular.environment="tabularx",
		width="0.8\\textwidth",
		sanitize.colnames.function=function(x){x})	

#plot(model_ge_area)


###################################################
### code chunk number 10: model_for_glass_eel_graph_and_predictions
###################################################
# using expand.grid to build a complete grid for predictions
data_bis=expand.grid(year_f=model_ge_area$xlevels$year_f,area=model_ge_area$xlevels$area,
		site=model_ge_area$xlevels$site)
data_bis$year<-as.numeric(as.character(data_bis$year_f))
#deleting area/year not avalaible
for(area in as.character(unique(glass_eel_yoy$area))){
	data_bis[data_bis$area==area,"nb_site"]=
			area_year[as.character(data_bis[data_bis$area==area,"year"]),area]
}
data_bis=data_bis[data_bis$nb_site>0,]


#predicting
data_bis$p=predict(model_ge_area,newdata=data_bis[,],type="response")
se=predict(model_ge_area,newdata=data_bis[,],type="response",se.fit=TRUE)
data_bis$se=se[["se.fit"]]
#standardising prediction to 1960-1980 level
# 2 options mean or geomean
if (opt_calculation=="geomean") {
	mean_1960_1970=data.frame(mean=unlist(
					tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p"],
							data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
							geomean)
	))
} else {
	mean_1960_1970=data.frame(mean=unlist(
					tapply(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p"],
							data_bis[data_bis$year>=1960 & data_bis$year<1980,"area"],
							mean)
	))
}
mean_1960_1970$area=rownames(mean_1960_1970)
data_bis=merge(data_bis,mean_1960_1970,by="area")
data_bis$p_std_1960_1970=data_bis$p/data_bis$mean

# cannot show no se on average value, se is on each individual value !
#data_bis$se_std_1960_1970=data_bis$se/data_bis$geomean 
#data_bis$ymin<-data_bis$p_std_1960_1970-data_bis$se_std_1960_1970
#data_bis$ymax<-data_bis$p_std_1960_1970+data_bis$se_std_1960_1970
# geomean does not return a "nice" numeric, hence the trick below
if (opt_calculation=="geomean") {
	synthesis=as.data.frame(tapply(data_bis[,"p_std_1960_1970"],
					list(data_bis[,"year_f"],data_bis[,"area"]),
					function(X) {Y=geomean(X) ;
						return(as.numeric(Y))}))
} else {
	synthesis=as.data.frame(tapply(data_bis[,"p_std_1960_1970"],
					list(data_bis[,"year_f"],data_bis[,"area"]),mean,na.rm=TRUE))
}

resy=function(data,valcol){
	data$time=rownames(data)
	data1=melt(data,id.vars=ncol(data))
	colnames(data1)=c("year","area",valcol)
	data1$year=as.Date(strptime(paste(data1$year,"-01-01",sep=""),format="%Y-%m-%d"))
	return(data1)
}
dat=resy(synthesis,"p_std_1960_1970")


##plotting
#with(synthesis,matplot(time,log(synthesis[,-dim(synthesis)[2]]),type="l"))
#legend("topright",legend=names(synthesis)[-dim(synthesis)[2]],lty=1:5,col=1:6)
#abline(v=seq(1950,2005,5),lty=2,col="gray")
#abline(v=seq(1950,2005,10))

#tat_sum_single <- function(fun, geom="point", ...) { 
#   stat_summary(fun.y=fun, colour="red", geom=geom, size = 3, ...) 
# } 
# 

g<-ggplot(dat,aes(x=year,y=p_std_1960_1970))

figure5_without_logscale<-g+geom_line(aes(colour=area,lty=area),lwd=1)+ 
		scale_colour_brewer(name="area",palette="Set1")+
		scale_y_continuous("standardized glm predictions \n mean 1960-1979")+
		theme_bw()+
		geom_hline(yintercept=1,linetype=2)+
		theme(legend.box =NULL,
				legend.key = element_rect(colour = NA, fill = 'white'),
				legend.text = element_text(size = 10, colour = 'black'), 
				legend.background = element_rect(colour = NA, fill = 'white'),
				legend.position = c(.8, .8))
X11(300,250)
figure5_without_logscale
save_figure("figure5_without_logscale",figure5_without_logscale,400,300)

# function similar to theme_dark() but allows legends
# black and white plot ====
figure5_without_logscale_black<-g+geom_line(aes(colour=area,lty=area),lwd=1)+
		scale_colour_manual(name="area",values=c("yellow","lawngreen"))+
		scale_y_continuous("standardized glm predictions \n mean 1960-1979")+
		theme_black()

X11()
figure5_without_logscale_black
save_figure("figure5_without_logscale_black",figure5_without_logscale_black,600,480)


#====
#+geom_smooth(aes(ymin = min, ymax = max,fill=area),stat="identity")+facet_grid( ~ area) 
datEE<-dat[dat$area=="Elsewhere Europe",]
datNS<-dat[dat$area=="North Sea",]
labelEE<-100*round(datEE$p_std_1960_1970[length(datEE$p_std_1960_1970)],3)
labelNS<-100*round(datNS$p_std_1960_1970[length(datNS$p_std_1960_1970)],3)

figure5<-g+geom_line(aes(colour=area,lty=area),lwd=1.3)+geom_point(aes(colour=area,fill=area,shape=area),size=3)+
		#ggtitle("Recruitment overview glass eel series")+
		scale_colour_brewer(name="area",palette="Set1")  +
		#annotate("text",x=dat$year[length(dat$year)-2],y=datEE$p_std_1960_1970[length(datEE$p_std_1960_1970)],size=5,label=labelEE)+
		#annotate("text",x=dat$year[length(dat$year)-2],y=datNS$p_std_1960_1970[length(datNS$p_std_1960_1970)],size=5,label=labelNS)+		
		scale_y_log10(name="standardized glm predictions \n mean 1960-1979-log scale",
				#limits=c(0.005,10),
				breaks=c(0.01,0.1,1,10),
				labels=c("1%","10%","100%","1000%"))+
		theme_bw()+
		theme(legend.box =NULL,
				legend.key = element_rect(colour = NA, fill = 'white'),
				legend.text = element_text(size = 10, colour = 'black'), 
				legend.background = element_rect(colour = NA, fill = 'white'),
				legend.position=c(.8,.9))

X11()
figure5
save_figure("figure5",figure5,400,300)
#figure5danish<-g+geom_line(aes(colour=area,lty=area),lwd=1.3)+
#		geom_point(aes(colour=area,fill=area,shape=area),size=3)+
#		ggtitle("title="Glasaal data fra hele Europa")+
#		scale_colour_brewer(name="area",palette="Set1")  +
#		xlab("Aar")+
#		scale_y_log10(name="Linear model forudsigelser/ gennemsnit 1960-1979",
#				#limits=c(0.005,10),
#				breaks=c(0.01,0.1,1,10),
#				labels=c("1%","10%","100%","1000%"))
#figure5danish

#levels(dat$area)<-c (
#		iconv("Andre steder i Europa","UTF8"),
#		iconv("Nordsjøen","UTF8"))#
#g<-ggplot(dat,aes(x=year,y=p_std_1960_1970))
#figure5norvegiean<-g+
#		geom_line(aes(colour=area,lty=area),lwd=1.3)+
#		geom_point(aes(colour=area,shape=area),size=3)+
#		ggtitle(label=iconv("Indeks av glassålrekruttering","UTF8"))+
#		scale_colour_brewer(name=iconv("Området","UTF8"),palette="Set1")  +
#		scale_shape(name=iconv("Området","UTF8"))+
#		scale_linetype(name=iconv("Området","UTF8"))+
#		xlab(iconv("År","UTF8"))+
#		scale_y_log10(name=iconv("Standardiserte GLM-prognoser (i prosent av
#		1960-1979-gjennomsnitt)","UTF8"), #limits=c(0.005,10),
#				breaks=c(0.01,0.1,1,10),
#				labels=c("1%","10%","100%","1000%"))
#save_figure("figure5norvegiean",figure5norvegiean,600,480)
#pdf("images/2013/figure5norvegiean.pdf")
#figure5norvegiean
#dev.off()
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
g<-ggplot(dat,aes(x=year,y=p_std_1960_1970))

#figure5bw<-g+geom_line(aes(colour=area,lty=area),wd=1.3)+
#		geom_point(aes(colour=area,fill=area,shape=area),size=3)+
#		#ggtitle("Recruitment overview glass eel series")+
#		scale_colour_manual(name="area",values=c("black","grey40"))  +
#		#annotate("text",x=dat$year[length(dat$year)-2],y=datEE$p_std_1960_1970[length(datEE$p_std_1960_1970)],size=5,label=labelEE)+
#		#annotate("text",x=dat$year[length(dat$year)-2],y=datNS$p_std_1960_1970[length(datNS$p_std_1960_1970)],size=5,label=labelNS)+		
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



#######################
## graphique presentation Vilaine
##########################
#dat1<-dat
#levels(dat1$area)=c("Europe","Vilaine")
#dat$year1=as.numeric(strftime(dat1$year,"%Y"))
#dat1$p_std_1960_1970
#vil<-wger[wger$ser_id==17,c("value_std","year")]
#vil<-vil[order(as.numeric(vil$year)),]
#vil<-rbind(cbind("value_std"=NA,"year"=1950:1970),vil,cbind("value_std"=NA,"year"=2012))
#mean(vil$value_std[vil$year>=1979 & vil$year<1994])#1
#sca<-mean(dat1$p_std_1960_1970[dat1$area=="Europe"&dat1$year1>=1979 & dat1$year1<1994]) #0.62
#vil$value_std<-vil$value_std*sca
#vil[16:21,"value_std"]<-c(5,4,9,12,10,8)*vil$value_std[vil$year==1971]/44
##vilpred<-data_bis[data_bis$site==17&data_bis$area=="Elsewhere Europe",c("p_std_1960_1970","year")]
##vilpred<-vilpred[order(as.numeric(vilpred$year)),]
#dat1[dat1$area=="Vilaine","p_std_1960_1970"]<-vil$value_std
#colsitees(dat1)[2]<-"zone"
#g1<-ggplot(dat1,aes(x=year,y=p_std_1960_1970))+xlab("")
#base_size<-12

#figure5_without_logscale_black_vilaine<-g1+
#		geom_line(aes(colour=zone,lty=zone),lwd=1.3)+
#		geom_point(aes(colour=zone,shape=zone),size=3)+
#		ggtitle(title="")+
#		scale_colour_manual(name="zone",values=c("black","deepskyblue")) +
#		scale_y_continuous(name="")+
##		scale_y_log10(name="",
##				#limits=c(0.005,10),
##				breaks=c(0.01,0.1,1,10),
##				labels=c("1%","10%","100%","1000%"))+
#		scale_x_date(major= "10 years",minor= "5 years")+
#		opts(axis.line = theme_blank(), 
#				axis.text.x = theme_text(size = base_size *	1.2, lineheight = 0.9, colour = "black", vjust = 1), 
#				axis.text.y = theme_text(size = base_size * 1.2, lineheight = 0.9, colour = "black", hjust = 1), 
#				axis.ticks = theme_segment(colour = "black"), 
#				axis.title.x = theme_text(size = base_size, vjust = 0.5,colour = "white"), 
#				axis.title.y = theme_text(size = base_size, angle = 90, 
#						vjust = 0.5,colour = "black"), axis.ticks.length = unit(0.15, "cm"), 
#				axis.ticks.margin = unit(0.1, "cm"), 
#				legend.background = theme_blank(), 
#				legend.key =  theme_blank(), 
#				legend.text = theme_text(size = base_size , lineheight = 0.9, colour = "black", vjust = 1),
#				panel.background = theme_blank(),
#				panel.border = theme_rect(colour = "black"),
#				plot.background=theme_blank(), # the background
#				panel.grid.major = theme_line(colour = "black"), 
#				panel.grid.minor = theme_line(colour = "grey"), 
#				panel.margin = unit(0.25, "lines"), 
#				strip.background = theme_rect(fill = "black", colour = NA), # bordures droites et gauche
#				strip.label = function(variable, value) value, strip.text.x = theme_text(size = base_size * 
#								0.8), strip.text.y = theme_text(size = base_size * 
#								0.8, angle = -90),				 
#				plot.title = theme_text(size = base_size * 1.5,colour="black"), #"#BE81F7" violet
#				plot.margin = unit(c(1, 1, 0.5, 0.5), "lines"))
#x11()
#figure5_without_logscale_black_vilaine
#save_figure("figure5_without_logscale_black_vilaine",figure5_without_logscale_black,600,480)


# ===========
#scale_y_continuous("standardized predictions",limits=c(0,10)) 




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
gg0<-synthesis[as.character(1960:CY),c("Elsewhere Europe","North Sea")]
colnames(gg0)<-c("EE","NS")

gg<-split_per_decade_ge(gg0)
gg[,1:8]<-100*round(gg[,1:8],2)
gg[,9:ncol(gg)]<-100*round(gg[,9:ncol(gg)],3)
nothing<-latex(gg,
		rowlabel="",
		rowlabel.just="c",
		where="hptb",
		cgroup=cgroupdecade,
		n.cgroup=rep(ncol(gg0),length(cgroupdecade)),
		collabel.just=strsplit("c c c c c c c c c c c c c c c", " ")[[1]],	
		col.just     =strsplit("c c c c c c c c c c c c c c c", " ")[[1]],
		#landscape=TRUE,
		label="table_glm_glass_eel",
		caption=str_c("GLM $glass~eel \\sim year:area + site $ geometric means of predicted values for ",vv$nb_series_glass_eel," glass eel series, values given in percentage of the 1960-1979 period."),	
		file= str_c(tabwd,"/table_glm_glass_eel.tex"))


#decades results
decA<-tapply(synthesis$"North Sea",synthesis$decade,mean,na.rm=T)
decE<-tapply(synthesis$"Elsewhere Europe",synthesis$decade,mean,na.rm=T)
#decA[(length(decA)-1):length(decA)]
#decE[(length(decE)-1):length(decE)]



write.table(synthesis,file=str_c(datawd,"/glm_results_glass.csv"),sep=";")

#plot(log(synthesis[synthesis$year>1979,"Elsewhere Europe"]))
trend<-synthesis[synthesis$year>1979,]
trend$EE<-trend$"Elsewhere Europe"
trend$lEE<-log(trend$EE)

trend$lNS<-log(trend$"North Sea")
#round(lm(lEE~year,data=trend)$coefficient[2],4) # -0.098
#round(lm(lNS~year,data=trend)$coefficient[2],4) # -0.098 North Sea -0129

test1=lm(lEE~year+pmax(year,2011),data=trend)
anova(test1)
sgipee_test_for_change_ee<-summary(test1)$coefficients[3,4]
if (sgipee_test_for_change_ee<=0.05) {
	test_sgipee_char_ee<-"significant"
}else {
	test_sgipee_char_ee<-"not significant"
}

test=lm(lNS~year+pmax(year,2011),data=trend)
anova(test)
sgipee_test_for_change_ns<-summary(test)$coefficients[3,4]
if (sgipee_test_for_change_ns<=0.05) {
	test_sgipee_char_ns<-"significant"
}else {
	test_sgipee_char_ns<-"not significant"
}


###################################################
### code chunk number 11: model_diagnostics (eval = FALSE)
###################################################
## require(car)
## require(sp)
## require(maptools)
## require(maps)
## require(boot)
## # summary(model_ge_area)
## # influence_plot
## gey<-glass_eel_yoy[glass_eel_yoy$value>0 & glass_eel_yoy$year>1959&!is.na(glass_eel_yoy$value_std),]
## gey$E<-resid(model_ge_area) # working residuals
## gey$P=predict(model_ge_area)
## plot(coefficients(model_ge_area)[grep("North Sea",names(coefficients(model_ge_area)))],type="l")
## points(log(datNS$p_std_1960_1970)+4,type="l",col="red")
## plot(gey$E~gey$P)
## 
## # Three ways of getting the diagnostic graph of residuals
## glm.diag.plots(model_ge_area)
## plot(model_ge_area,which=1)
## panel.smooth(gey$P,gey$E,col="black",col.smooth="red")
## library(lattice)
## panel.smoother <- function(x, y) {
## 	panel.xyplot(x, y) # show points 
## 	panel.loess(x, y,col.line="red")  # show smoothed line 
## 	panel.abline(h=0)
## }
## panel.smoother2 <- function(x, y) {
## 	panel.xyplot(x, y) # show points 
## 	panel.loess(x, y,col.line="red")  # show smoothed line 
## 	panel.abline(h=-0.2)
## }
## mga_diag<-glm.diag(model_ge_area)
## gey$res<-mga_diag$res
## show.settings()
## 
## xyplot(res~P, data=gey,scales=list(cex=.8, col="black"),
## 		panel=panel.smoother,
## 		xlab="Predicted", ylab="residuals", 
## 		main="Jacknife deviance residuals agains the fitted value")
## xyplot(res~year, data=gey,scales=list(cex=.8, col="black"),
## 		panel=panel.smoother2,
## 		xlab="Predicted", ylab="residuals", 
## 		main="Jacknife deviance residuals agains the fitted value")
## abline(h=0)
## xyplot(res~P|area, data=gey,scales=list(cex=.8, col="black"),
## 		panel=panel.smoother,
## 		xlab="Predicted", ylab="residuals", 
## 		main="Jacknife deviance residuals agains the fitted value")
## xyplot(res~P|site, data=gey,scales=list(cex=.8, col="black"),
## 		panel=panel.smoother,
## 		xlab="Predicted", ylab="residuals", 
## 		main="Jacknife deviance residuals agains the fitted value")
## # un résidu / carte par annee
## 
## 
## # pour aller chercher les stations en 3035
## locxy_3035<-sqldf("select ser_id,st_x(the_geom) as X, st_y(the_geom) as Y from ts.t_location_loc where loc_tyl_code='Recruit'")
## gey<-merge(gey,locxy_3035,by="ser_id",all.x=TRUE,all.y=FALSE)
## Gey<-gey #spatial data frame
## coordinates(Gey)<-c("x","y")
## # dev.size("px") to check right dimensions
## #png(file=str_c(imgwd,"/resid_bretagne.png"), width=672,height= 389)
## 
## #bb<-elargit(bb,0.01,0.01)
## 
## #frequire(latticeExtra) # a + as.layer(b) pour mettre deux graphiques
## # but for now I don't have missing data there
## emu_c=readShapePoints(str_c(shpwd,"/","t_emuagreg_ema_point_3035.shp")) # a spatial object of class sp
## # this corresponds to the center of each emu.
## wisesp=readShapePoly(str_c(shpwd,"/","rbd_f1v3_3035.shp")) # a spatial object of class sp
## # this is the map showing the "missing parts", to be placed behind the others
## country_c=readShapePoints(str_c(shpwd,"/","t_country_coun_3035"))# a spatial object of class sp
## # this is the map of coutry centers, to overlay points for each country
## emusp0=readShapePoly(str_c(shpwd,"/","t_emuagreg_ema_3035")) # a spatial object of class sp
## years<-1960:2016
## bb<-bbox(emusp0)
## # loop to create all the graphs
## for (year in years){
## 	#trellis.device(device="png",filename=str_c(imgwd,"/resids/",year,".png"))
## 	png(filename=str_c(imgwd,"/resids/",year,".png"),width=600, height=500)
## 	bb<-bubble(Gey[Gey@data$year==year,], "E",col=c("red","green"),main=str_c(year),
## 			xlab="",ylab="",
## 			do.sqrt = FALSE,
## 			sp.layout=list("sp.polygons", emusp0,    first = FALSE)
## 	) 		
## 	print(bb)
## 	dev.off()
## }
## # 
## require(lme4)
## model_ge_area<-gls(value_std~year_f:area+site,data=glass_eel_yoy,family=Gamma(link=log),
## 		subset=glass_eel_yoy$value>0 & glass_eel_yoy$year>1959 ,maxit=300)
## 
## lmer(value_std~year_f:area+site,data=glass_eel_yoy,family=Gamma(link=log),
## 		subset=glass_eel_yoy$value>0 & glass_eel_yoy$year>1959)
## 
## #library(nlme)
## library(lme4)
## library(MASS)
## glass_eel_yoy$lvalue_std=log(glass_eel_yoy$value_std)
## M.lm <- gls(lvalue_std~site,data=glass_eel_yoy)
## 
## vf1Fixed <- 
## 		
## 		M.gls1 <-glmmPQL(value_std~year_f:area+site,
## 				data=glass_eel_yoy[glass_eel_yoy$value>0 & glass_eel_yoy$year>1959,],
## 				random = ~ 1 | site,
## 				weights = varIdent (form = ~ 1 | site) ,
## 				family=Gamma(link=log)
## 		)
## M.gls1 <-glmmPQL(value_std~year_f:area+site,
## 		data=glass_eel_yoy[glass_eel_yoy$value>0 & glass_eel_yoy$year>1959,],
## 		random = ~ 1 | site,
## 		family=Gamma(link=log)
## )
## # prediction for lough neagh
## # historical data
## glass_eel_yoy2=wger[wger$lifestage!="yellow eel" ,] #glass eel and yoy
## model_ge_area2=glm(value_std~year_f:area+site,data=glass_eel_yoy2[glass_eel_yoy2$value>0 ,],
## 		family=Gamma(link=log), maxit=300)
## 
## newdata<-expand.grid(year_f=levels(glass_eel_yoy2$year_f),site="Bann",area="Elsewhere Europe")
## newdata<-newdata[as.numeric(as.character(newdata$year_f))>1922,]
## newdata$P=predict(model_ge_area2,type="response",newdata=newdata)
## newdata$year<-as.numeric(as.character(newdata$year_f))
## 
## plot(newdata$year,newdata$P, type="b",col="blue")
## gey2<-glass_eel_yoy2[glass_eel_yoy2$site=='Bann',]
## gey2<-gey2[order(gey2$year),]
## points(gey2$year,gey2$value_std, type="b",col="red",pch=18)
## write.table(gey2,file=str_c(datawd,"/Bann_data.csv"),sep=";")
## write.table(newdata,file=str_c(datawd,"/Bann_predictions.csv"),sep=";")


###################################################
### code chunk number 12: model_for_yellow_eel
###################################################
# 2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~
######################################"
#~yellow eel migrant analysis
######################################"~
# 2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~2~~~
print("Analysis for yellow eel")
area_year_older=table(older$year,older$area)
vv$nb_for_yellow_eel_glm<-length(unique(older$site))
table(older$geo)
print("stations selected for analysis")
unique(older$site)
model_older=glm(value_std~year_f+as.factor(site),
		data=older,
		family=Gamma(link=log),
		subset=older$value>0 &
				older$year>1949,
		maxit=300)
# parteen was removed but is no longer among the series
summary(model_older)
#plot(model_older)
anova(model_older,test="F")

data_bis=expand.grid(year_f=unique(model_older$xlevels$year_f),
		site=model_older$xlevels$`as.factor(site`)
data_bis$year=as.numeric(as.character(data_bis$year))

#predicting
data_bis$p=predict(model_older,newdata=data_bis,type="response")

#standardising prediction to 1960-1970 level
# 2 options mean or geomean
if (opt_calculation=="geomean") {
	mean_1960_1970=as.numeric(geomean(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p"]))
} else {
	mean_1960_1970=mean(data_bis[data_bis$year>=1960 & data_bis$year<1980,"p"])
}
data_bis$p_std_1960_1970=data_bis$p/mean_1960_1970

if (opt_calculation=="geomean") {
	synthesis=data.frame("yellow_eel"=unlist(tapply(data_bis[,"p_std_1960_1970"],list(data_bis[,"year_f"]),geomean)))
} else {
	synthesis=data.frame("yellow_eel"=unlist(tapply(data_bis[,"p_std_1960_1970"],list(data_bis[,"year_f"]),mean)))
}

synthesis$time=rownames(synthesis)
synthesis$decade=trunc(as.numeric(synthesis$time)/5)*5
if (opt_calculation=="geomean") {
	five_year_avg_yellow<-data.frame("yellow_eel"=tapply(
					synthesis$"yellow_eel",synthesis$decade,
					function(X){Y=geomean(X) ;return(as.numeric(Y))}))
}else{
	five_year_avg_yellow<-data.frame("yellow_eel"=tapply(
					synthesis$"yellow_eel",synthesis$decade,
					mean,na.rm=T))
}
synthesis$rebour<-nrow(synthesis):1
rownames(five_year_avg_yellow)[nrow(five_year_avg_yellow)]<-"last"

(decY<-tapply(synthesis$"yellow_eel",synthesis$decade,mean,na.rm=T))
synthesis$rebour<-nrow(synthesis):1
last<-synthesis$rebour<=5
mean(synthesis[last,c("yellow_eel") ],na.rm=TRUE)
rownames(synthesis)<-synthesis$time

#xfive_year_avg_yellow <- xtable(x = five_year_avg_yellow, 
#		label = "table_five_year_avg_yellow",
#		caption = str_c("GLM estimates for glass eel series, averaged every five years"))
#print(xfive_year_avg_yellow,
#		file = str_c(tabwd,"/table_five_year_avg_yellow.tex"),
#		table.placement = "htbp",
#		caption.placement = "top",
#		NA.string = ".")
yy0<-synthesis[,"yellow_eel",drop = FALSE]


yy<-split_per_decade(data=yy0)
yy<-100*round(yy,2)
nothing<-latex(yy,
		rowlabel="",
		rowlabel.just="c",
		where="hptb",
		col.just     =strsplit("c c c c c c c c c c c c c c c", " ")[[1]],
		landscape=FALSE,
		label="table_glm_yellow",
		caption=str_c("GLM $yellow~eel \\sim year + site $ geometric means of predicted values for ",vv$nb_series_older, " yellow eel series, values given in percentage of the 1960-1979 period."),	
		file= str_c(tabwd,"/table_glm_yellow.tex"))



synthesis$year=as.Date(strptime(paste(synthesis$time,"-01-01",sep=""),format="%Y-%m-%d"))
g<-ggplot(synthesis,aes(x=year,y=yellow_eel)) 
figure6_without_log_scale<-g+geom_line(lwd=1)+ geom_point()+
		scale_y_continuous("standardized glm predictions/ mean 1960-1979")+
		theme_bw()+
		geom_hline(yintercept=1,linetype=2)+
		theme(legend.box =NULL,
				legend.key = element_rect(colour = NA, fill = 'white'),
				legend.text = element_text(size = 8, colour = 'black'), 
				legend.background = element_rect(colour = NA, fill = 'white'))#+
#stat_smooth(method="lm",formula=y ~ ns(x,4),lty=2, size=0.8,alpha=0.3,col="grey20")
save_figure("figure6_without_log_scale",figure6_without_log_scale,400,300)
figure6_without_log_scale
figure6_without_log_scale_black<-g+geom_line(lwd=1,color="white")+ geom_point(color="white")+
		scale_y_continuous("standardized glm predictions/ mean 1960-1979")+
		#stat_smooth(method="lm",formula=y ~ ns(x,4),lty=2, size=0.8,alpha=0.3,col="turquoise1") +
		theme_black()
figure6_without_log_scale_black
save_figure("figure6_without_log_scale_black",figure6_without_log_scale_black,400,300)
figure6<-g+geom_line(lwd=1)+geom_point()+
		scale_y_log10(name="standardized glm predictions/ mean 1960-1979-log scale",
				#limits=c(0.005,10),
				breaks=c(0.01,0.1,1,10),
				labels=c("1%","10%","100%","1000%")) +
		theme_bw()+
		theme(legend.box =NULL,
				legend.key = element_rect(colour = NA, fill = 'white'),
				legend.text = element_text(size = 8, colour = 'black'), 
				legend.background = element_rect(colour = NA, fill = 'white'))
#stat_smooth(method="lm",formula=y ~ ns(x,4), lty=2, size=0.8,alpha=0.3,col="grey20")
figure6
save_figure("figure6",figure6,400,300)

write.table(synthesis,file=str_c(datawd,"/glm_results_yellow.csv"),sep=";")


