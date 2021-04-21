###################################################################################"
# File create to build excel files sent to persons responsible for mortalities data
# Author Cedric Briand - modified by Laurent Beaulaton
# This script will create an excel sheet per country that currently have mortalities series
#######################################################################################
# put the current year there
setwd("C:/workspace\\gitwgeel\\")
CY<-2021
# and the annex name / type of data
name_annex <- "Eel_Data_Call_Annex_9_Mortality rates"
eel_typ_id_annex <- 17:25

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
###################################
# you must set the user and pwd for the database HERE
# userwgeel = ""
# passwordwgeel = ""
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
				typ_name
				FROM datawg.t_eelstock_eel 
				LEFT JOIN ref.tr_quality_qal on eel_qal_id=tr_quality_qal.qal_id 
				LEFT JOIN ref.tr_typeseries_typ on eel_typ_id=typ_id;")

#tr_eel_typ<- sqldf("SELECT typ_id, typ_name FROM ref.tr_typeseries_typ")

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
create_datacall_file <- function(country, eel_typ_id, name, ...){  

	#create a folder for the country , names for source and destination files
	dir.create(str_c(wddata,country), showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name, ".xlsx")
	templatefile <- file.path(wddata, "00template", nametemplatefile)
	namedestinationfile <- str_c(name, "_",country,".xlsx")	
	destinationfile <- file.path(wddata, country, namedestinationfile)		

	# limit dataset to country
	r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% eel_typ_id,]
	r_coun <- r_coun[,c(1,18,3:17)]
	wb = loadWorkbook(templatefile)
	
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
		cat("ok")
# openxlsx METHODS
		openxlsx::writeData(wb, sheet = "existing_discarded", data_disc, startRow = 1)
		openxlsx::writeData(wb, sheet = "existing_kept", data_kept, startRow = 1)		
	} else {
		cat("No data for country", country, "\n")
	}
	
	saveWorkbook(wb, file = destinationfile, overwrite = TRUE)	

}

# TESTS -----------------

eel_typ_id_annex <-17:25
eel_typ_id_annex <- "Eel_Data_Call_Annex_9_Mortality rates"
name_annex <-  "Eel_Data_Call_Annex_9_Mortality rates"
create_datacall_file ( 
		country <- "FR",
		eel_typ_id <- eel_typ_id_annex,
		name <- name_annex)

# END TEST -------------------------------------------

# CLOSE EXCEL FILE FIRST
cou_code<-unique(t_eelstock_eel$eel_cou_code[!is.na(t_eelstock_eel$eel_cou_code)])

# create an excel file for each of the countries
#cou <-"EE"
for (cou in cou_code){	
	country <- cou
	cat("country: ",country,"\n")
	create_datacall_file ( 
			country <- cou,
			eel_typ_id <- eel_typ_id_annex, 
			name <- name_annex)
	cat("work finished\n")
}
