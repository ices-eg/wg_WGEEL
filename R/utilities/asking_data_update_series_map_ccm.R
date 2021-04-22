###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# 
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
CY<-2020
# function to load packages if not available
load_library=function(necessary) {
  if(!all(necessary %in% installed.packages()[, 'Package']))
    install.packages(necessary[!necessary %in% installed.packages()[, 'Package']], dep = T)
  for(i in 1:length(necessary))
    library(necessary[i], character.only = TRUE)
}
###########################
# Loading necessary packages
############################
load_library("sqldf")
load_library("RPostgreSQL")
load_library("stacomirtools")
load_library("stringr")
load_library("XLConnect")
load_library("sf")
load_library("ggmap")

#############################
# here is where the script is working change it accordingly
##################################
wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata<-"C:/workspace/wgeeldata/recruitment"
load(str_c(wddata,"/","ccm_seaoutlets.rdata")) #polygons off ccm seaoutlets WGS84
#####################################
# Finally we store the xl data in a sub chapter
########################################
dataxl<-str_c(wddata,"/",CY,"/xl")
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
options(sqldf.RPostgreSQL.user = "postgres", 
        sqldf.RPostgreSQL.password = passwordlocal,
        sqldf.RPostgreSQL.dbname = "wgeel",
        sqldf.RPostgreSQL.host = "localhost",
        sqldf.RPostgreSQL.port = 5432)

#############################
# Table storing information from the recruitment series
##################################
t_series_ser<-sqldf("SELECT 
          t_series_ser.ser_id, 
      t_series_ser.ser_nameshort, 
      t_series_ser.ser_namelong, 
      t_series_ser.ser_typ_id, 
      t_series_ser.ser_effort_uni_code, 
      t_series_ser.ser_comment, 
      t_series_ser.ser_uni_code, 
      t_series_ser.ser_lfs_code, 
      t_series_ser.ser_hty_code, 
      t_series_ser.ser_locationdescription, 
      t_series_ser.ser_emu_nameshort, 
      t_series_ser.ser_cou_code, 
      t_series_ser.ser_area_division, 
      t_series_ser.ser_tblcodeid, 
      t_series_ser.ser_x, 
      t_series_ser.ser_y, 
      t_series_ser.ser_sam_id,
      t_series_ser.ser_qal_id,
      t_series_ser.ser_qal_comment

        FROM 
datawg.t_series_ser;")
# converting some information to latin1, necessary for latin1 final user

t_series_ser[,4]<-iconv(t_series_ser[,4],from="UTF8",to="latin1")
t_series_ser[,11]<-iconv(t_series_ser[,11],from="UTF8",to="latin1")
t_series_ser[,7]<-iconv(t_series_ser[,7],from="UTF8",to="latin1")

#############################
# Table storing station
##################################
station <- sqldf("select * from ref.tr_station")
station$Organisation <-iconv(station$Organisation,from="UTF8",to="latin1")
#let's assume we have a ccm_wso_id
            #station$ser_ccm_wso_id=291111

#' function to create the recuitment sheet 
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country name, for instance "Sweden"
createxl<-function(country){
  r_coun<-t_series_ser[t_series_ser$ser_cou_code==country,]
  # country names are displayed differently in this table, but Station_name correspond
  s_coun<-station[station$Station_Name%in%r_coun$ser_nameshort,]
  xls.file<-str_c(dataxl,"/",country,CY,".xls")
  wb = loadWorkbook(xls.file, create = TRUE)
  createSheet(wb,"rec_info")
  writeWorksheet (wb , r_coun , sheet="rec_info" ,header = TRUE )
  createSheet(wb,"station")
  writeWorksheet (wb , s_coun , sheet="station" ,header = TRUE )
  createSheet(wb,"station_map")
  for (i in 1:nrow(s_coun)){
    #turn a pgsql array into an R vector for ccm_wso_id
    pols_id=eval(parse(text=paste("c(",gsub(pattern="\\{|\\}",replacement='',s_coun$ser_ccm_wso_id[i]),")")))
    print(s_coun$Station_Code[i])
    createName(wb, name = paste("station_map_",i,sep=""), formula = paste("station_map!$B$",(i-1)*40+1,sep=""))
    pol=subset(ccm,ccm$wso_id %in% pols_id)
    if (nrow(pol)>0){
      bounds <- matrix(st_bbox(pol),2,2)
      bounds[,1]=pmin(bounds[,1],c(s_coun$Lon[i],s_coun$Lat[i]))-0.5
      bounds[,2]=pmax(bounds[,2],c(s_coun$Lon[i],s_coun$Lat[i]))+0.5
      my_map=get_map(bounds, maptype = "terrain")
      g=ggmap(my_map) + geom_sf(data=pol, inherit.aes = FALSE,fill=NA,color="red")+geom_point(data=s_coun[i,],aes(x=Lon,y=Lat),col="red")+ggtitle(s_coun$Station_Name[i])+
        xlab("")+ylab("")
    } else{
      bounds <- rbind(rep(s_coun$Lon[i],2), rep(s_coun$Lat[i],2))
      bounds[,1]=bounds[,1]-1
      bounds[,2]=bounds[,2]+1
      my_map=get_map(bounds, maptype = "terrain")
      pol=st_crop(ccm,xmin=bounds[1,1],ymin=bounds[2,1],xmax=bounds[1,2],ymax=bounds[2,2])
      g=ggmap(my_map) + geom_point(data=s_coun[i,],aes(x=Lon,y=Lat),col="red")+ggtitle(s_coun$Station_Name[i])+
        xlab("")+ylab("")+geom_sf(data=pol, inherit.aes = FALSE,fill=NA,color="black")
    }
    ggsave(paste(tempdir(),"/",s_coun$Station_Name[i],".png",sep=""),g,width=20/2.54,height=16/2.54,units="in",dpi=150)
    addImage(wb,paste(tempdir(),"/",s_coun$Station_Name[i],".png",sep=""),name=paste("station_map_",i,sep=""),originalSize=TRUE)
  }
#  saveWorkbook(wb)	
#  wb = loadWorkbook(xls.file, create = TRUE)
  for (i in 1:length(r_coun$ser_id)){
    ser_id<-r_coun$ser_id[i]
    dat<-sqldf(str_c("select * from datawg.t_dataseries_das where das_ser_id=",ser_id,
                     " order by das_year ASC"))
    createSheet(wb, name = r_coun$ser_nameshort[i])
    writeWorksheet (wb , dat , sheet=r_coun$ser_nameshort[i] ,header = TRUE)	
  }
  saveWorkbook(wb)
  cat("work finished\n")
}
# launch this to see how many countries you have
unique(t_series_ser$ser_cou_code)
#  "SE" "NL" "IE" "FR" "DE" "DK" "ES" "GB" "PT" "IT" "BE" "NO"
t_series_ser <- t_series_ser[!is.na(t_series_ser$ser_cou_code), ]
# create an excel file for each of the countries
createxl(country="SE")
createxl("NL")
createxl("IE")
createxl("FR")
createxl("DE")
createxl("DK")
createxl("ES")
createxl("GB")
createxl("PT")
createxl("IT")
createxl("BE")
createxl("NO")
createxl("PL")

