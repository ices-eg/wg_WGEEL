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
#############################
# here is where the script is working change it accordingly
##################################
wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata<-"C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2020/wgeel/datacall/"
# Finally we store the xl data in a sub chapter
########################################
dataxl<-wddata
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
options(sqldf.RPostgreSQL.user = userwgeel, 
		sqldf.RPostgreSQL.password = passwordwgeel,
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




#' function to create the series excel tables for data call
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country name, for instance "Sweden"
#' country='FR'; name="Eel_Data_Call_2020_Annex1_time_series"; ser_typ_id=1
create_datacall_file_series<-function(country, name, ser_typ_id){
	if (!is.numeric(ser_typ_id)) stop("ser_typ_id must be numeric")
	
	# series description -------------------------------------------------------
	
	t_series_ser<-sqldf(str_c("SELECT 
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
							datawg.t_series_ser
							WHERE ser_cou_code='",country,"' ",
					"AND ser_typ_id ='", ser_typ_id, "';"))
# converting some information to latin1, necessary for latin1 final user
	
	t_series_ser[,4]<-iconv(t_series_ser[,4],from="UTF8",to="latin1")
	t_series_ser[,11]<-iconv(t_series_ser[,11],from="UTF8",to="latin1")
	t_series_ser[,7]<-iconv(t_series_ser[,7],from="UTF8",to="latin1")
	
# station data ----------------------------------------------
	
	station <- sqldf("select * from ref.tr_station")
	station$Organisation <-iconv(station$Organisation,from="UTF8",to="latin1")
	station <- dplyr::left_join(t_series_ser[,"ser_nameshort",drop=F], station, by=c("ser_nameshort"="Station_Name"))
	# drop  tblCodeID Station_Code
	station <- station[,c("ser_nameshort",  "Organisation")]
	
# existing series data ----------------------------------------	
	
	dat <- sqldf(str_c("select 
							ser_nameshort, 
							das_id,
							das_ser_id,
							das_value,
							das_year,
							das_comment,
							das_effort,
							das_qal_id
							from datawg.t_dataseries_das",
					" JOIN t_series_ser ON ser_id = das_ser_id",
					" WHERE ser_typ_id=",ser_typ_id,
					" ORDER BY das_ser_id, das_year ASC"))
	
# new data ----------------------------------------------------
# extract missing data from CY-10

  newdata <- dat %>% dplyr::filter(das_year>=(CY-10)) %>%
			dplyr::select(ser_nameshort,das_year,das_value, das_comment, das_effort) %>%
			tidyr::complete(ser_nameshort,das_year=(CY-10):CY) %>%
			dplyr::filter(is.na(das_value)) %>%
			dplyr::arrange(ser_nameshort, das_year)

# biometry data existing ------------------------------------------
	
	

# biometry data new data ------------------------------------------



	
	# country names are displayed differently in this table, but Station_name correspond
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	namedestinationfile <- str_c(name,"_",country,".xlsx")	
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	s_coun<-station[station$Station_Name%in%r_coun$ser_nameshort,]
	xls.file<-str_c(dataxl,"/",country,CY,".xls")
	wb = loadWorkbook(xls.file, create = TRUE)
	createSheet(wb,"rec_info")
	writeWorksheet (wb , r_coun , sheet="rec_info" ,header = TRUE )
	createSheet(wb,"station")
	writeWorksheet (wb , s_coun , sheet="station" ,header = TRUE )
	saveWorkbook(wb)	
	wb = loadWorkbook(xls.file, create = TRUE)
	for (i in 1:length(r_coun$ser_id)){
		ser_id<-r_coun$ser_id[i]
		
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

