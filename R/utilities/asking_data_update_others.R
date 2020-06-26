###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
setwd("C:/workspace\\gitwgeel\\")
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
load_library("openxlsx")
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
wddata<-"C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2020/wgeel/datacall/"
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"

source("R/database_interaction/database_connection.R")
source("R/utilities/detect_missing_data.R")

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
# Table storing information from the database
##################################
t_eelstock_eel<-sqldf("SELECT 
				eel_id,
				eel_typ_id,
				eel_year,
				eel_value,
				eel_emu_nameshort,
				eel_cou_code,
				eel_lfs_code,
				eel_hty_code,
				eel_area_division,
				eel_qal_id,
				eel_qal_comment,
				eel_comment,
				eel_datelastupdate,
				eel_missvaluequal,
				eel_datasource,
				eel_dta_code,
				qal_kept,
				typ_name
				FROM datawg.t_eelstock_eel 
				left join ref.tr_quality_qal on eel_qal_id=tr_quality_qal.qal_id 
				left join ref.tr_typeseries_typ on eel_typ_id=typ_id;")

tr_eel_typ<- sqldf("SELECT * from ref.tr_typeseries_typ")

#' function to create the data sheet 
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param code of the country, for instance "FR"
#' @param name name of the annex file
#' @param eel_typ_id the type to be included in the annex
#' @param ... arguments  cou,	minyear, maxyear, host, dbname, user, and port passed to missing_data
#' 
#'  country <- "FR" ; name <- "Eel_Data_Call_2020_Annex4_Landings" ; eel_typ_id <- c(4,6) ;
#' xls.file_final <- str_c(dataxl, name, "_",country,".xls")
#' 
#' d
# 
create_datacall_file <- function(country, eel_typ_id, templatefiles, destinationfile, ...){  
	
	#create a folder for the country  
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% eel_typ_id,]
	r_coun <- data.frame(eel_typ_name=r_coun[,ncol(r_coun)], r_coun[,3:17])
	## separate sheets for discarded and kept data  
	data_kept <- r_coun[r_coun$qal_kept,]
	data_kept <- data_kept[,-ncol(r_coun)]
	
	data_disc <- r_coun[!r_coun$qal_kept,]
	data_disc <- data_disc[,-ncol(r_coun)]
	
	data_missing <- detect_missing_data(cou=country)
	data_missing <- data_missing[,-match(c("eel_qal_id","eel_qal_comment"),colnames(data_missing))]
	data
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"template_files",nametemplatefile)
	namedestinationfile <- str_c(name,"_",country,".xlsx")	
	destinationfile <- file.path(wddata, country, namedestinationfile)

	wb = openxlsx::loadWorkbook(templatefile)
	sheets <- sheets(wb)
	if ("existing_discarded"%in% sheets) removeWorksheet(wb,"existing_discarded")
	if ("existing_kept"%in% sheets) removeWorksheet(wb,"existing_kept")
	if ("new_data"%in% sheets) removeWorksheet(wb,"new_data")
	openxlsx::addWorksheet(wb=wb, 
			sheetName= "existing_discarded",
			tabColour="orange")
	openxlsx::addWorksheet(wb=wb, 
			sheetName= "existing_kept",
			tabColour="green")
	openxlsx::addWorksheet(wb=wb, 
			sheetName= "new_data",
			tabColour="red")
	style <- "TableStyleMedium7"
	writeDataTable(wb, data_disc, sheet = "existing_discarded",tableStyle=style, withFilter = TRUE)
	writeDataTable(wb, data_kept, sheet = "existing_kept",tableStyle=style, withFilter = TRUE)
	writeData(wb, data_missing, sheet = "new_data",  startRow=2)
	worksheetOrder(wb) <- c(1,2,3,12,13,4:11)
	saveWorkbook(wb, file = destinationfile, overwrite = TRUE)
}




openXL(wb)
## Not run: saveWorkbook(wb, file = "tableStylesGallery.xlsx", overwrite = TRUE)

	cat("work finished",country," and ",eel_typ,"\n")

#select the data
if (eel_typ %in% c(4,5,6,7)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(4,5,6,7),]
	data_type<-"landings"
	
}else if (eel_typ %in% c(8,9,10)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(8,9,10),]
	data_type<-"releases"
	
}else if (eel_typ %in% c(11,12)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(11,12),]
	data_type<-"aquaculture"
	
}else if (eel_typ %in% c(13,14,15)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(13,14,15),]
	data_type<-"biomass_indicators"
}else if (eel_typ %in% c(17:25)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(17:25),]
	data_type<-"mortality_rate"
	
}else if (eel_typ %in% c(26:31)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(26:31),]
	data_type<-"mortality_see"
	
}else if (eel_typ %in% c(32:33)){
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(32:33),]
	data_type<-"other_landings"
	
}else{
	
	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id==16,]
	data_type<-"habitats"
	
}

# if no data available for these type of data then we don't create a file
if (nrow(r_coun)==0){print(paste("data are not available for eel_typ_id ",eel_typ," and ",country, sep=""))
	
}else{
	
	## reorder data columns so type names is next to eel_type_id      
	
}
}	

# lselect the countries and the typ_id you have
cou_code<-unique(t_eelstock_eel$eel_cou_code)
typ_id<-unique(t_eelstock_eel$eel_typ_id)

# create an excel file for each of the countries and each typ_id

for (i in cou_code){
	
	for (j in typ_id){
		
		createx_all(i,j)
	}
}


