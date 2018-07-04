###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
CY<-2018
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
#############################
# here is where the script is working change it accordingly
##################################
setwd("C:/workspace/wgeel/sweave")
wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata<-"C:/workspace/wgeeldata/recruitment"
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
      t_series_ser.ser_order, 
      t_series_ser.ser_nameshort, 
      t_series_ser.ser_namelong, 
      t_series_ser.ser_typ_id, 
      t_series_ser.ser_effort_uni_code, 
      t_series_ser.ser_comment, 
      t_series_ser.ser_uni_code, 
      t_series_ser.ser_lfs_code, 
      t_series_ser.ser_hty_code, 
      t_series_ser.ser_habitat_name, 
      t_series_ser.ser_emu_nameshort, 
      t_series_ser.ser_cou_code, 
      t_series_ser.ser_area_division, 
      t_series_ser.ser_tblcodeid, 
      t_series_ser.ser_x, 
      t_series_ser.ser_y, 
      t_series_ser.ser_sam_id
        FROM 
datawg.t_series_ser;")
# converting some information to latin1, necessary for latin1 final user

t_series_ser[,4]<-iconv(t_series_ser[,4],from="UTF8",to="latin1")
t_series_ser[,11]<-iconv(t_series_ser[,11],from="UTF8",to="latin1")
t_series_ser[,7]<-iconv(t_series_ser[,7],from="UTF8",to="latin1")


#' function to create the recuitment sheet 
#' 
#' @note this function writes the xl sheet for each country
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country name, for instance "Sweden"
createxl<-function(country){
	r_coun<-t_series_ser[t_series_ser$ser_cou_code==country,]
	xls.file<-str_c(dataxl,"/",country,CY,".xls")
	wb = loadWorkbook(xls.file, create = TRUE)
	createSheet(wb,"rec_info")
	writeWorksheet (wb , r_coun , sheet="rec_info" ,header = TRUE )
	saveWorkbook(wb)	
	wb = loadWorkbook(xls.file, create = TRUE)
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

