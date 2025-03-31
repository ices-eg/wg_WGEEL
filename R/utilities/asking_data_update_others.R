################################################################################### "
# File create to build excel files sent to persons responsible for recruitment data
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
if (Sys.info()["user"] %in% c("hilaire.drouineau", "hdrouineau")) {
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/")
} else if (Sys.info()["user"] == "cedric.briand") {
  setwd("C:/workspace/wg_WGEEL")
} else {
  setwd("~")
}
CY <- 2025
datasource <- "dc_2025"


# function to load packages if not available
load_library <- function(necessary) {
  if (!all(necessary %in% installed.packages()[, "Package"])) {
    install.packages(necessary[!necessary %in% installed.packages()[, "Package"]], dep = T)
  }
  for (i in 1:length(necessary)) {
    library(necessary[i], character.only = TRUE)
  }
}


###########################
# Loading necessary packages
############################
# load_library("sqldf")
load_library("RPostgres")
load_library("stacomirtools")
load_library("stringr")
# load_library("XLConnect")
# Sys.setenv("JAVA_HOME"="C:\\Program Files\\Java\\jdk-18.0.1.1")
# .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
load_library("openxlsx")
load_library("dplyr")
load_library("getPass")
load_library("yaml")
load_library("DBI")
load_library("sqldf") # for sqlite
cred <- read_yaml("credentials.yml")


#############################
# here is where the script is working change it accordingly
##################################
# setwd("C:/workspace\\gitwgeel\\R\\shiny_data_visualisation\\shiny_dv\\")
# wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user
##################################
wddata <- paste0(getwd(), "/data/datacall_template/")
load(str_c(getwd(), "/data/ccm_seaoutlets.rdata")) # polygons off ccm seaoutlets WGS84
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
################################### "


source("R/utilities/detect_missing_data.R")
source("R/utilities/update_referential_sheets.R")
library(yaml)
host <- cred$host
userwgeel <- cred$user
passwordwgeel <- cred$password


#############################
# Table storing information from the database
##################################

con <- dbConnect(RPostgres::Postgres(),
  dbname = cred$dbname,
  host = cred$host,
  port = cred$port,
  user = cred$user,
  password = cred$password
)
t_eelstock_eel <- dbGetQuery(con, "SELECT
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


save(t_eelstock_eel, file = str_c(wddata, "t_eelstock_eel.Rdata"))
# load(str_c(wddata,"t_eelstock_eel.Rdata"))
# tr_eel_typ<- sqldf("SELECT * from ref.tr_typeseries_typ")





#' function to create the data sheet
#'
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' A good reason for bug is if the source datacall file template is open
#' NOTE THAT FOR R4.0.1 openXLSX created a column at 480000 something, and everything was repared
#' when opening and dropped. This might have been linked to validation checks.
#'
#' @param country the country
#' @param eel_typ_id the type to be included in the annex
#' @param name : the name of the sheet (in template)
#' @param ... arguments  cou,	minyear, maxyear, con passed to missing_data
#'
#'  country <- "FR" ; name <- "Eel_Data_Call_2020_Annex4_Landings_Commercial" ; eel_typ_id <- c(4,6) ;

create_datacall_file <- function(country, eel_typ_id, name, ...) {
  cat("country: ", country, "\n")
  # create a folder for the country , names for source and destination files
  dir.create(str_c(wddata, country), showWarnings = FALSE) # show warning= FALSE will create if not exist
  nametemplatefile <- str_c(name, ".xlsx")
  templatefile <- file.path(wddata, "00template", nametemplatefile)
  namedestinationfile <- str_c(CY, "_", name, "_", country, ".xlsx")
  destinationfile <- file.path(wddata, country, namedestinationfile)

  # limit dataset to country
  r_coun <- t_eelstock_eel[t_eelstock_eel$eel_cou_code == country & t_eelstock_eel$eel_typ_id %in% eel_typ_id, ]
  r_coun <- r_coun[, c(1, 18, 3:17)]
  wb <- openxlsx::loadWorkbook(templatefile)

  if (nrow(r_coun) > 0) {
    ## separate sheets for discarded and kept data
    data_kept <- r_coun[r_coun$qal_kept, ]
    data_kept <- data_kept[, -ncol(r_coun)]

    data_disc <- r_coun[!r_coun$qal_kept, ]
    data_disc <- data_disc[, -ncol(r_coun)]

    # pre-fill new data and missing for landings
    openxlsx::writeData(wb, data_disc,
      sheet = "existing_discarded",
      colNames = FALSE,
      startRow = 2
    )
    openxlsx::writeData(wb, data_kept,
      sheet = "existing_kept",
      colNames = FALSE,
      startRow = 2
    )
  } else {
    cat("No data for country", country, "\n")
  }


  if (any(eel_typ_id %in% c(4, 6))) datatype <- "landings" else datatype <- "other"
  if (datatype == "landings") {
    data_missing <- detect_missing_data(cou = country, typ_id = eel_typ_id, ...)
    data_typ_id <- ifelse(startsWith(data_missing$eel_typ_name, "com"), 4, 6)
    # here filter if there is only 4 or 6, detect missing returns all combinations for 4 and 6
    data_missing <- data_missing[data_typ_id %in% eel_typ_id, ]
    # we know ask for eel_qal_id and eel_qal_comment
    # data_missing <- data_missing[,-match(c("eel_qal_id","eel_qal_comment"),colnames(data_missing))]
    # print(data_missing)
    openxlsx::writeData(wb, x = data_missing, sheet = "new_data")
  }
  saveWorkbook(wb, file = destinationfile, overwrite = TRUE)
  cat(sprintf("created %s\n", destinationfile))
}


# TESTS -------------------------------------------
# con = dbConnect(RPostgres::Postgres(),
#    dbname=cred$dbname,
#    host=cred$host,
#    port=cred$port,
#    user=cred$user,
#    password=cred$password)
# update_referential_sheet(con=con,"Eel_Data_Call_Annex4_Landings_Commercial")
# create_datacall_file (
# 		country <- "FR",
# 		eel_typ_id <- 4,
# 		name <- "Eel_Data_Call_Annex4_Landings_Commercial",
# 		minyear=2000,
# 		maxyear=CY, #maxyear corresponds to the current year where we have to fill data
#    con = con,
# 		datasource=datasource)
# dbDisconnect(con)

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


create_annex_0 <- function(country, EU_call = FALSE) {
  cat("country: ", country, "\n")

  # create a folder for the country , names for source and destination files
  dir.create(str_c(wddata, country), showWarnings = FALSE) # show warning= FALSE will create if not exist
  name <- "Eel_Data_Call_Annex0_Summary"
  nametemplatefile <- str_c(name, ".xlsx")
  templatefile <- file.path(wddata, "00template", nametemplatefile)
  namedestinationfile <- str_c(CY, "_", name, "_", country, ".xlsx")
  destinationfile <- file.path(wddata, country, namedestinationfile)

  # limit dataset to country
  wb <- openxlsx::loadWorkbook(templatefile)

  summary <- openxlsx::read.xlsx(wb, sheet = "Summary")

  for (annex in 1:9) {
    # summary$country_code[annex] <- country
    openxlsx::writeData(wb, sheet = "Summary", country, startRow = annex + 1, startCol = 4)
  }
  if (EU_call) {
    for (annex in 10:17) {
      # summary$country_code[annex] <- country
      openxlsx::writeData(wb, sheet = "Summary", country, startRow = annex + 1, startCol = 4)
    }
  } else {
    # summary <- summary[-(10:17), ]
    openxlsx::deleteData(wb, sheet = "Summary", rows = 1 + (10:17), cols = 1:ncol(summary), gridExpand = TRUE)
  }
  # openxlsx::removeWorksheet(wb, "Summary")
  # s <- openxlsx::createStyle(fgFill = "#bfbfbf")
  # openxlsx::addWorksheet(wb, "Summary")
  # openxlsx::writeData(wb, "Summary", summary)
  # openxlsx::addStyle(wb, sheet = "Summary", style = s, rows = 1, cols = 1:ncol(summary))
  # openxlsx::worksheetOrder(wb) <- c(1, 3, 2)



  saveWorkbook(wb, file = destinationfile, overwrite = TRUE)
  cat(sprintf("created %s\n", destinationfile))
}


# CLOSE EXCEL FILE FIST
cou_code <- unique(t_eelstock_eel$eel_cou_code[!is.na(t_eelstock_eel$eel_cou_code)])
cou_code <- sort(cou_code)

## Annex 0
for (cou in cou_code) {
  gc()
  create_annex_0(
    country = cou,
    EU_call = FALSE
  )
  cat("work finished\n")
}



# create an excel file for each of the countries and each typ_id
# LANDINGS COMMERCIAL AND RECREATIONAL

con <- dbConnect(RPostgres::Postgres(),
  dbname = cred$dbname,
  host = cred$host,
  port = cred$port,
  user = cred$user,
  password = cred$password
)

# update_referential_sheet(con=con,"Eel_Data_Call_Annex4_Landings_Commercial")
for (cou in cou_code) {
  gc()
  create_datacall_file(
    country = cou,
    eel_typ_id = 4,
    name = "Eel_Data_Call_Annex4_Landings_Commercial",
    minyear = 2000,
    maxyear = CY - 1, # maxyear corresponds to the current year where we have to fill data
    con = con,
    datasource = datasource
  )
  cat("work finished\n")
}
# update_referential_sheet(con=con,name= "Eel_Data_Call_Annex5_Landings_Recreational")
for (cou in cou_code) {
  gc()

  #  if (! cou %in% c("GB")) { #GB has no recreational fisheries
  create_datacall_file(
    country = cou,
    eel_typ_id = c(6),
    name = "Eel_Data_Call_Annex5_Landings_Recreational",
    minyear = 2000,
    maxyear = CY - 1, # maxyear corresponds to the current year where we have to fill data
    con = con,
    datasource = datasource
  )

  # }
}

# OTHER LANDINGS
# update_referential_sheet(con=con, name ="Eel_Data_Call_Annex6_Landings_Other")
for (cou in cou_code) {
  gc()
  create_datacall_file(
    country = cou,
    eel_typ_id = c(32, 33),
    name = "Eel_Data_Call_Annex6_Landings_Other",
    minyear = 2000,
    maxyear = CY - 1, # maxyear corresponds to the current year where we have to fill data
    datasource = datasource
  )
}
# do not update release, there is a cell
# update_referential_sheet(con=con, name= "Eel_Data_Call_Annex7_Releases")
for (cou in cou_code) {
  gc()
  create_datacall_file(
    country = cou,
    eel_typ_id = c(8, 9, 10),
    name = "Eel_Data_Call_Annex7_Releases",
    minyear = 2000,
    maxyear = CY - 1, # maxyear corresponds to the current year where we have to fill data
    datasource = datasource
  )
}




cou_code_aqua <- unique(t_eelstock_eel$eel_cou_code[t_eelstock_eel$eel_typ_id %in% c(11)])

# cou <-"MA"
# update_referential_sheet(con = con, name="Eel_Data_Call_Annex8_Aquaculture")
for (cou in cou_code_aqua) {
  gc()
  create_datacall_file(
    country = cou,
    eel_typ_id = c(11),
    name = "Eel_Data_Call_Annex8_Aquaculture",
    minyear = 2000,
    maxyear = CY - 1, # maxyear corresponds to the current year where we have to fill data
    datasource = datasource
  )
}


dbDisconnect(con)



## Not run: saveWorkbook(wb, file = "tableStylesGallery.xlsx", overwrite = TRUE)



# lselect the countries and the typ_id you have


#
#
#
#
# }else if (eel_typ %in% c(11,12)){
#
# 	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(11,12),]
# 	data_type<-"aquaculture"
#
# }else if (eel_typ %in% c(13,14,15)){
#
# 	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(13,14,15),]
# 	data_type<-"biomass_indicators"
# }else if (eel_typ %in% c(17:25)){
#
# 	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(17:25),]
# 	data_type<-"mortality_rate"
#
# }else if (eel_typ %in% c(26:31)){
#
# 	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(26:31),]
# 	data_type<-"mortality_see"
#
# }else if (eel_typ %in% c(32:33)){
#
# 	r_coun<-t_eelstock_eel[t_eelstock_eel$eel_cou_code==country & t_eelstock_eel$eel_typ_id %in% c(32:33),]
# 	data_type<-"other_landings"
