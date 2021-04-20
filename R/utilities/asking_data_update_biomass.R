###################################################################################"
# File create to build excel files sent to persons responsible for mortalities data
# Author Cedric Briand - modified by Laurent Beaulatob
# This script will create an excel sheet per country that currently have mortalities series
#######################################################################################
# put the current year there
setwd("C:/workspace\\gitwgeel\\")
CY<-2021
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
#load_library("XLConnect") ==> switch to openxlsx beacause I have problem with rJava
load_library("openxlsx")
load_library("dplyr")
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
#wddata<-"C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2020/wgeel/datacall/"
wddata = paste0(getwd(), "/data/datacall_template/")
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"


source("R/utilities/detect_missing_data.R")

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
# Table storing information from the database
##################################
t_eelstock_eel<-sqldf("SELECT 
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
				typ_name,
				perc_f,
				perc_t,
				perc_c,
				perc_mo
				FROM datawg.t_eelstock_eel left join datawg.t_eelstock_eel_percent on eel_id=percent_id 
				left join ref.tr_quality_qal on eel_qal_id=tr_quality_qal.qal_id 
				left join ref.tr_typeseries_typ on eel_typ_id=typ_id;")

#tr_eel_typ<- sqldf("SELECT * from ref.tr_typeseries_typ")

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
#'  country <- "FR" ; name <- "Eel_Data_Call_Annex_9_Mortality rates" ; eel_typ_id <- 17:25 ;


create_datacall_file_biom_morta <- function(country, name, type="biom", ...){  
	eel_typ_id = c(13, 14, 15)
	if (type == "morta") eel_typ_id=17:19
	
	#create a folder for the country , names for source and destination files
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	namedestinationfile <- str_c(name,"_",country,".xlsx")	
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	# limit dataset to country
	r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% eel_typ_id,]
	r_coun <- r_coun[,c(1,18,3:7,19:22,8:17)]
	r_coun <-
	  rename_with(r_coun,function(x) paste("biom", x, sep = "_"), starts_with("perc"))
	wb = loadWorkbook(templatefile)
	r_coun <- r_coun %>%
	  select(-eel_area_division)
	
	if (nrow(r_coun) >0) {
		## separate sheets for discarded and kept data  
		data_kept <- r_coun[r_coun$qal_kept,]
		data_kept <- data_kept[,-ncol(r_coun)]
		
		data_disc <- r_coun[!r_coun$qal_kept,]
		data_disc <- data_disc[,-ncol(r_coun)]
		

		# pre-fill new data and missing for landings 
# XLConnect METHOD	
#		writeWorksheet(wb, data_disc,  sheet = "existing_discarded",header=FALSE, startRow=2)
#		writeWorksheet(wb, data_kept,  sheet = "existing_kept",header=FALSE,startRow=2)
		
# openxlsx METHODS
		openxlsx::writeData(wb, sheet = "existing_discarded", data_disc, startRow = 1)
		
		
	#removed for 2021	
	#openxlsx::writeData(wb, sheet = "existing_kept", data_kept, startRow = 1)	
		openxlsx::removeWorksheet(wb,"existing_kept")
	} else {
		cat("No data for country", country, "\n")
	}
	
	data_missing <- detect_missing_biom_morta(cou=country,typ=type,...)
	data_missing %>% 
	  mutate(eel_missvaluequal = NA) %>%
	  select(typ_name, 
	         eel_year, 
	         eel_value,
	         eel_missvaluequal,
	         eel_emu_nameshort,
	         eel_cou_code) %>%
	  mutate(perc_F=0,
	         perc_T=0,
	         perc_C=0,
	         perc_MO=0) %>%
	  rename_with(function(x) paste(type, x, sep="_"),starts_with("perc"))
	openxlsx::writeData(wb,  sheet = "new_data", data_missing, startCol=1, startRow=1)
	
	
	saveWorkbook(wb, file = destinationfile, overwrite = TRUE)	

}


# TESTS -------------------------------------------
# note passwordwgeel must be set and exist
# passwordwgeel <- XXXXXXXX
country <- "NO";eel_typ_id <- 4; name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial";minyear=2000;
maxyear=2021;host="localhost";dbname="wgeel";user="wgeel";port=5432;datasource="dc_2020";
#test
create_datacall_file ( 
		country <- "MA",
		eel_typ_id <- 4, 
		name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial",
		minyear=2000,
		maxyear=2020, #maxyear corresponds to the current year where we have to fill data
		host="localhost",
		dbname="wgeel",
		user="wgeel",
		port=5432,
		datasource="dc_2020")


create_datacall_file ( 
		country <- "MA",
		eel_typ_id <- 4, 
		name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial",
		minyear=2000,
		maxyear=2020, #maxyear corresponds to the current year where we have to fill data
		host="localhost",
		dbname="wgeel",
		user="wgeel",
		port=5432,
		datasource="dc_2020")

# END TEST -------------------------------------------

# CLOSE EXCEL FILE FIST
cou_code<-unique(t_eelstock_eel$eel_cou_code[!is.na(t_eelstock_eel$eel_cou_code)])

# create an excel file for each of the countries and each typ_id
# LANDINGS COMMERCIAL AND RECREATIONAL
# problems with "NO", "TR", "HR" 
cou <-"EE"
for (cou in cou_code){	
	country <- cou
	cat("country: ",country,"\n")
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- 4, 
			name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial",
			minyear=2000,
			maxyear=2020, #maxyear corresponds to the current year where we have to fill data
			host="localhost",
			dbname="wgeel",
			user="wgeel",
			port=5432,
			datasource="dc_2020")
	cat("work finished\n")
}

for (cou in cou_code){		
	country <- cou
	cat("country: ",country,"\n")
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- 6, 
			name <- "Eel_Data_Call_2020_Annex5_Landings_Recreational",
			minyear=2000,
			maxyear=2020, #maxyear corresponds to the current year where we have to fill data
			host="localhost",
			dbname="wgeel",
			user="wgeel",
			port=5432,
			datasource="dc_2020")
	cat("work finished",country,"\n")
}

# OTHER LANDINGS

for (cou in cou_code){				
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(32,33), 
			name <- "Eel_Data_Call_2020_Annex6_Landings_Other",
			minyear=2000,
			maxyear=2020, #maxyear corresponds to the current year where we have to fill data
			host="localhost",
			dbname="wgeel",
			user="wgeel",
			port=5432,
			datasource="dc_2020")
	cat("work finished",country,"\n")
}



for (cou in cou_code){
	
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(8,9,10), 
			name <- "Eel_Data_Call_2020_Annex7_Releases",
			minyear=2000,
			maxyear=2020, #maxyear corresponds to the current year where we have to fill data
			host="localhost",
			dbname="wgeel",
			user="wgeel",
			port=5432,
			datasource="dc_2020")
	cat("work finished",country,"\n")
	
}




cou_code_aqua<-unique(t_eelstock_eel$eel_cou_code[t_eelstock_eel$eel_typ_id%in%c(11)])

cou <-"MA"

for (cou in cou_code_aqua){
	
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- c(11), 
			name <- "Eel_Data_Call_2020_Annex8_Aquaculture",
			minyear=2000,
			maxyear=2020, #maxyear corresponds to the current year where we have to fill data
			host="localhost",
			dbname="wgeel",
			user="wgeel",
			port=5432,
			datasource="dc_2020")
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
	
