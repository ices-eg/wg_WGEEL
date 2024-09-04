###################################################################################"
# File create to build excel files sent to persons responsible for mortalities data
# Author Cedric Briand - modified by Laurent Beaulaton & Hilaire Drouineau
# This script will create an excel sheet per country that currently have mortalities series
#######################################################################################
# put the current year there
#setwd("C:/workspace\\gitwgeel\\")
CY<-2024 # put the current year there, CY-1 will be used
# and the annex name / type of data
type_of_data <- c("mortalities", "biomass")
name_annex <- c("Eel_Data_Call_Annex11_Mortality_rates", "Eel_Data_Call_Annex10_Biomass_Indicators")
names(name_annex) <- type_of_data
eel_typ_id_annex <- list(17:19,13:15)
names(eel_typ_id_annex) <- type_of_data

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
load_library("RPostgreSQL")
load_library("stacomirtools")
load_library("stringr")
load_library("openxlsx")
load_library("dplyr")
load_library("getPass")
load_library("yaml")
load_library("DBI")
load_library("tidyr")

#############################
# here is where the script is working change it accordingly
##################################
#setwd("C:/workspace\\gitwgeel\\R\\shiny_data_visualisation\\shiny_dv\\")
#wd<-getwd()



#############################
# here is where the script is working change it accordingly
# one must be at the head of wgeel git 
##################################
if(Sys.info()["user"]=="hdrouineau"){
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/")
} else if(Sys.info()["user"]=="cedric.briand"){
  setwd("C:/workspace/wg_WGEEL")
} else {
  setwd("~")
}
source("R/utilities/detect_missing_data.R")
cred=read_yaml("credentials_write.yml")
source("R/utilities/update_referential_sheets.R")
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata = paste0(getwd(), "/data/datacall_template/")
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################
library(yaml)
host <- cred$host
userwgeel <- cred$user
passwordwgeel <- cred$password


con = dbConnect(RPostgres::Postgres(), 
    dbname=cred$dbname,
    host=cred$host,
    port=cred$port,
    user=cred$user, 
    password=cred$password)


#############################
# Table storing information from the database
##################################
t_eelstock_eel<- DBI::dbGetQuery(con, "SELECT 
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
				typ_name eel_type_name,
				perc_f,
				perc_t,
				perc_c,
				perc_mo
				FROM datawg.t_eelstock_eel left join datawg.t_eelstock_eel_percent on eel_id=percent_id 
				left join ref.tr_quality_qal on eel_qal_id=tr_quality_qal.qal_id 
				left join ref.tr_typeseries_typ on eel_typ_id=typ_id;")


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
#'  country <- "FR" ; type <- "biomass" ;
create_datacall_file_biom_morta <- function(country, type = type_of_data[1], ...){  
	if(!(type %in% type_of_data)) stop(paste0("'type' should be one of: ", paste(type_of_data, collapse = " or ")))
	
	name <- name_annex[type]
	eel_typ_id <- eel_typ_id_annex[[type]]
	
	#create a folder for the country , names for source and destination files
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	namedestinationfile <- str_c(CY,"_",name,"_",country,".xlsx")	
  sheetnames <- openxlsx::getSheetNames(templatefile)
  ref_sheets <- sheetnames[grep("tr_", sheetnames)]
  wb = openxlsx::loadWorkbook(templatefile)
  # wb= XLConnect::loadWorkbook(templatefile)
  
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	# limit dataset to country
	r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% eel_typ_id,]
	r_coun <- r_coun[,c(1,18,3:7,19:22,8:17)]
#	r_coun <-
#	  rename_with(r_coun,function(x) paste("biom", x, sep = "_"), starts_with("perc"))
	r_coun <- r_coun %>% select(-eel_area_division)

	if (nrow(r_coun) >0) {
		## separate sheets for discarded and kept data  
		## this year special treatment we remove everything, but still need original
		## values in the database (ie we have not applied eel_qal_id=20) because we need the view for detect_missing
	
    data_kept <- r_coun[r_coun$eel_qal_id  %in% c(1,2,3,4),]
		data_disc <- r_coun[!r_coun$eel_qal_id  %in% c(1,2,3,4),]
    
#		data_disc <- data_disc[,]
		
		
		# pre-fill new data and missing for landings 

# openxlsx METHODS
		openxlsx::writeData(wb, sheet = "existing_discarded", data_disc, startRow = 2, colNames = FALSE)
		#XLConnect::writeWorksheet(wb, data_disc, "existing_discarded", startRow=2, header=FALSE)
		
		
		# was removed for 2021	
		openxlsx::writeData(wb, sheet = "existing_kept", data_kept, startRow = 1)	
		#		writeWorksheet(wb, data_kept,  sheet = "existing_kept",header=FALSE,startRow=2)
		
	} else {
		cat("No data for country", country, "\n")
	}
  
	data_missing <- detect_missing_biom_morta(
      cou=country,
      typ=type, 
      ...) 
	data_missing %<>% 
			mutate(eel_missvaluequal = NA) %>%
			select(eel_typ_name, 
					eel_year, 
					eel_value,
					eel_missvaluequal,
					eel_emu_nameshort,
					eel_cou_code) %>%
			mutate(perc_F=0,
					perc_T=0,
					perc_C=0,
					perc_MO=0) %>%
			rename_with(function(x) paste(type, x, sep="_"),starts_with("perc")) %>%
			arrange(eel_emu_nameshort, eel_typ_name, eel_year)
	openxlsx::writeData(wb,  sheet = "new_data", data_missing, startRow = 2, colNames = FALSE)
	#XLConnect::writeWorksheet(wb, data=data_missing, sheet = "new_data",  startRow = 2, header = FALSE)
	
	openxlsx::saveWorkbook(wb, file = destinationfile, overwrite = TRUE)	
	#XLConnect::saveWorkbook(wb, destinationfile)
	
}


# TESTS -------------------------------------------
create_datacall_file_biom_morta(
    country = "GB", 
    type = "biomass", 
    con=con, 
    minyear=2007, 
    maxyear=2023,
    eel_typ_id=c(13:15,34),
    datasource="dc_2024")
create_datacall_file_biom_morta(country = "GB", 
    type = "mortalities", 
    con=con, 
    minyear=2007, 
    maxyear=2023, 
    eel_typ_id = c(17:19),
    datasource="dc_2024")
# END TEST -------------------------------------------

# CLOSE EXCEL FILE FIRST
cou_code<-unique(t_eelstock_eel$eel_cou_code[!is.na(t_eelstock_eel$eel_cou_code)])

# warning I didn't do in 2024, because the order in the sheets is wrong...
#update_referential_sheet(con, name="Eel_Data_Call_Annex10_Biomass_Indicators")
#update_referential_sheet(con, name="Eel_Data_Call_Annex11_Mortality_rates")
# create an excel file for each of the countries
cou_code<-cou_code[order(cou_code)]
for (cou in cou_code){	
	country <- cou
	cat("country: ",country,"\n")
	create_datacall_file_biom_morta(country = cou, 
      type = "biomass",
      con=con, 
      minyear=2007, 
      maxyear=2023,
      eel_typ_id=c(13:15,34),
      datasource="dc_2024")
	create_datacall_file_biom_morta(country <- cou,
      type = "mortalities",
      con=con, 
      minyear=2007, 
      maxyear=2023,
      eel_typ_id=c(17:19),
      datasource="dc_2024")
	cat("work finished\n")
}
