###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
if(Sys.info()["user"]=="hilaire.drouineau"){
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/")
} else{
  setwd("C:/workspace\\wg_WGEEL\\")
}
CY<-2023
datasource="dc_2023"


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
#load_library("sqldf")
load_library("RPostgreSQL")
load_library("stacomirtools")
load_library("stringr")
#load_library("XLConnect")
#Sys.setenv("JAVA_HOME"="C:\\Program Files\\Java\\jdk-18.0.1.1")
#.jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
load_library("openxlsx")
load_library("dplyr")
load_library("getPass")
load_library("yaml")
load_library("DBI")
cred=read_yaml("credentials.yml")


#############################
# here is where the script is working change it accordingly
##################################
#setwd("C:/workspace\\gitwgeel\\R\\shiny_data_visualisation\\shiny_dv\\")
#wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata = paste0(getwd(), "/data/datacall_template/")
load(str_c(getwd(),"/data/ccm_seaoutlets.rdata")) #polygons off ccm seaoutlets WGS84
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"


source("R/utilities/detect_missing_data.R")
library(yaml)
host <- cred$host
userwgeel <- cred$user
passwordwgeel <- cred$password

###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
#options(sqldf.RPostgreSQL.user = cred$user, 
#		sqldf.RPostgreSQL.password = getPass(),
#		sqldf.RPostgreSQL.dbname = cred$dbname,
#		sqldf.RPostgreSQL.host = cred$host,
#		sqldf.RPostgreSQL.port = cred$port)
con = dbConnect(RPostgres::Postgres(), 
    dbname=cred$dbname,
    host=cred$host,
    port=cred$port,
    user=cred$user, 
    password=cred$password)
#############################
# Table storing information from the database
##################################
t_eelstock_eel<-dbGetQuery(con, "SELECT 
				eel_id,
				eel_typ_id,
				eel_year,
				eel_value,
				eel_missvaluequal,
				eel_emu_nameshort,
				eel_cou_code,
				eel_lfs_code,
				eel_hty_code,
				eel_area_division,
				eel_qal_id,
				eel_qal_comment,
				eel_comment,
				eel_datelastupdate,				
				eel_datasource,
				eel_dta_code,
				qal_kept,
				typ_name
				FROM datawg.t_eelstock_eel 
				left join ref.tr_quality_qal on eel_qal_id=tr_quality_qal.qal_id 
				left join ref.tr_typeseries_typ on eel_typ_id=typ_id;")


save(t_eelstock_eel, file=str_c(wddata,"t_eelstock_eel.Rdata"))
# load(str_c(wddata,"t_eelstock_eel.Rdata"))
#tr_eel_typ<- sqldf("SELECT * from ref.tr_typeseries_typ")


# files are copied to the saved folder before being changed, check there if you need a backup
update_referential_sheet <- function(name="Eel_Data_Call_2022_Annex4_Landings_Commercial"){
  nametemplatefile <- str_c(name,".xlsx")
  templatefile <- file.path(wddata,"00template",nametemplatefile)
  dir.create(str_c(wddata,"saved"),showWarnings = FALSE)
  file.copy(templatefile, file.path(wddata,"saved",nametemplatefile))
  sheetnames <- openxlsx::getSheetNames(templatefile)
  ref_sheets <- sheetnames[grep("tr_", sheetnames)]
  wb = openxlsx::loadWorkbook(templatefile)
  fn_load_ref <- function(ref_table){    
    #we avoid to load geom type ("USER DEFINED)
    columns=dbGetQuery(con,paste0("SELECT  column_name,  data_type  FROM information_schema.columns
                      WHERE data_type!='USER-DEFINED' and table_schema = 'ref' AND  table_name = '",ref_table,"' ;"))
    
    tab <- DBI::dbGetQuery(con,  paste0("SELECT ",
                                        paste(columns$column_name,collapse=","),
                                        " FROM ref.",
                                        ref_table))
    cat("loaded",ref_table,"\n")
    if ("geom" %in% colnames(tab))   tab <- tab %>% select(starts_with("g")) %>% arrange(1)
    openxlsx::writeData(wb, sheet = ref_table, tab)
  }
  list_ref <- mapply(fn_load_ref,ref_sheets)
  wb = openxlsx::saveWorkbook(wb, templatefile, overwrite=TRUE)
  cat("end of refer loading")
}

#update_referential_sheet(name="Eel_Data_Call_Annex4_Landings_Commercial")
# needs reformating anyways....
#update_referential_sheet(name="Eel_Data_Call_Annex_Time_Series")



#' function to create the data sheet 
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' A good reason for bug is if the source datacall file template is open
#' NOTE THAT FOR R4.0.1 openXLSX created a column at 480000 something, and everything was repared
#' when opening and dropped. This might have been linked to validation checks.
#' 
#' @param code of the country, for instance "FR"
#' @param name name of the annex file
#' @param eel_typ_id the type to be included in the annex
#' @param ... arguments  cou,	minyear, maxyear, host, dbname, user, and port passed to missing_data
#' 
#'  country <- "FR" ; name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial" ; eel_typ_id <- c(4,6) ;


create_datacall_file <- function(country, eel_typ_id, name, ...){  
	
	
	#create a folder for the country , names for source and destination files
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	namedestinationfile <- str_c(CY,"_",name,"_",country,".xlsx")	
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	# limit dataset to country
	r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% eel_typ_id,]
	r_coun <- r_coun[,c(1,18,3:17)]
	wb = openxlsx::loadWorkbook(templatefile)
	
	if (nrow(r_coun) >0) {
		## separate sheets for discarded and kept data  
		data_kept <- r_coun[r_coun$qal_kept,]
		data_kept <- data_kept[,-ncol(r_coun)]
		
		data_disc <- r_coun[!r_coun$qal_kept,]
		data_disc <- data_disc[,-ncol(r_coun)]
		
		# pre-fill new data and missing for landings 
    openxlsx::writeData(wb, data_disc,  sheet = "existing_discarded",colNames=FALSE, startRow=2)
    openxlsx::writeData(wb, data_kept,  sheet = "existing_kept",colNames=FALSE,startRow=2)
	} else {
		cat("No data for country", country, "\n")
	}
	
# XLConnect METHOD	
#	createSheet(wb, name= "existing_discarded")
#	setSheetColor(wb,"existing_discarded",color=XLC$COLOR.ORANGE)
#	sheets <- getSheets(wb)
#openxlsx METHODS
#if ("existing_discarded"%in% sheets) removeSheet(wb,"existing_discarded")
#	openxlsx::addWorksheet(wb=wb, 
#			name= "existing_kept",
#			tabColour="green")
#	openxlsx::cloneWorksheet(wb=wb, 
#			sheetName= "data_new",
#			clonedSheet= "new_data")
	
	
	if (any(eel_typ_id%in%c(4,6))) datatype <- "landings" 	else datatype <-"other"
	if (datatype=="landings") {
		data_missing <- detect_missing_data(cou=country, ...)
		data_typ_id=ifelse(startsWith(data_missing$eel_typ_name,"com"),4,6)
		# here filter if there is only 4 or 6, detect missing returns all combinations for 4 and 6
		data_missing <- data_missing[data_typ_id%in%eel_typ_id,]
		#we know ask for eel_qal_id and eel_qal_comment
		#data_missing <- data_missing[,-match(c("eel_qal_id","eel_qal_comment"),colnames(data_missing))]
		#print(data_missing)
		writeData(wb, x=data_missing,  sheet = "new_data")
	} 
	saveWorkbook(wb, file = destinationfile, overwrite=TRUE)	
	
	#openXL(wb)
}


# TESTS -------------------------------------------
# note passwordwgeel must be set and exist
# passwordwgeel <- XXXXXXXX
country <- "NO";eel_typ_id <- 4; name <- "Eel_Data_Call_2022_Annex4_Landings_Commercial";minyear=2000;
maxyear=2020;# host="localhost";dbname="wgeel";user="wgeel";port=5432;
#test
create_datacall_file ( 
		country <- "FR",
		eel_typ_id <- 4, 
		name <- "Eel_Data_Call_Annex4_Landings_Commercial",
		minyear=2000,
		maxyear=CY, #maxyear corresponds to the current year where we have to fill data
		host=cred$host,
		dbname=cred$dbname,
		user=cred$user,
		port=cred$port,
		passwordwgeel=cred$password,
		datasource=datasource)

# 
# create_datacall_file ( 
# 		country <- "MA",
# 		eel_typ_id <- 4, 
# 		name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial",
# 		minyear=2000,
# 		maxyear=2020, #maxyear corresponds to the current year where we have to fill data
# 		host="localhost",
# 		dbname="wgeel",
# 		user="wgeel",
# 		port=5432,
# 		datasource="dc_2020")
# 
# END TEST -------------------------------------------

# CLOSE EXCEL FILE FIST
cou_code<-unique(t_eelstock_eel$eel_cou_code[!is.na(t_eelstock_eel$eel_cou_code)])

# create an excel file for each of the countries and each typ_id
# LANDINGS COMMERCIAL AND RECREATIONAL
# problems with "NO", "TR", "HR" 
options(java.parameters = "-Xmx8000m")
for (cou in cou_code){	
	country <- cou
	cat("country: ",country,"\n")
	gc()
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- 4, 
			name <- "Eel_Data_Call_Annex4_Landings_Commercial",
			minyear=2000,
			maxyear=CY, #maxyear corresponds to the current year where we have to fill data
			host=cred$host,
			dbname=cred$dbname,
			user=cred$user,
			port=cred$port,
			passwordwgeel=cred$password,
			datasource=datasource)
	cat("work finished\n")
}

for (cou in cou_code){
  gc()
	country <- cou
	cat("country: ",country,"\n")
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(6), 
			name <- "Eel_Data_Call_Annex5_Landings_Recreational",
			minyear=2000,
			maxyear=CY, #maxyear corresponds to the current year where we have to fill data
			host=cred$host,
			dbname=cred$dbname,
			user=cred$user,
			port=cred$port,
			passwordwgeel=cred$password,
			datasource=datasource)
	cat("work finished",country,"\n")
}

# OTHER LANDINGS

for (cou in cou_code){	
  gc()
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(32,33), 
			name <- "Eel_Data_Call_Annex6_Landings_Other",
			minyear=2000,
			maxyear=CY, #maxyear corresponds to the current year where we have to fill data
			datasource=datasource)
	cat("work finished",country,"\n")
}



for (cou in cou_code){
	gc()
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(8,9,10), 
			name <- "Eel_Data_Call_Annex7_Releases",
			minyear=2000,
			maxyear=CY, #maxyear corresponds to the current year where we have to fill data
			datasource=datasource)
	cat("work finished",country,"\n")
	
}




cou_code_aqua<-unique(t_eelstock_eel$eel_cou_code[t_eelstock_eel$eel_typ_id%in%c(11)])

#cou <-"MA"

for (cou in cou_code_aqua){
	gc()
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(11), 
			name <- "Eel_Data_Call_Annex8_Aquaculture",
			minyear=2000,
			maxyear=CY, #maxyear corresponds to the current year where we have to fill data
			datasource=datasource)
	cat("work finished",country,"\n")
	
}





## Not run: saveWorkbook(wb, file = "tableStylesGallery.xlsx", overwrite = TRUE)



# lselect the countries and the typ_id you have


#
#
#
#	
#}else if (eel_typ %in% c(11,12)){
#	
#	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(11,12),]
#	data_type<-"aquaculture"
#	
#}else if (eel_typ %in% c(13,14,15)){
#	
#	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(13,14,15),]
#	data_type<-"biomass_indicators"
#}else if (eel_typ %in% c(17:25)){
#	
#	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(17:25),]
#	data_type<-"mortality_rate"
#	
#}else if (eel_typ %in% c(26:31)){
#	
#	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(26:31),]
#	data_type<-"mortality_see"
#	
#}else if (eel_typ %in% c(32:33)){
#	
#	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(32:33),]
#	data_type<-"other_landings"
	
