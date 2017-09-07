# import_to_database.R
# Script to read the different files in the datacall and write the results to the database
# Status development
###############################################################################




# here is a list of the required packages
library(readxl) # to read xls files
library(stringr) # this contains utilities for strings

# PRELIMINARY NOTES
# There is no easy way to get data directly from the sharepoint as it is https and requires authentification.
# There is possibility to read one file in R directly but only when it’s http.
# One way around would be to use onedrive, but I didn’t manage to make it work; I think this will require to have the office365 buisness which I don’t have.
# So in the end I will program it from a local folder where we will download the files



# this is the folder where you will store the files prior to upload
# don't forget to put an / at the end of the string
mylocalfolder <- "C:/temp/wgeel/"
# you will need to put the following files there

# path to local github
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")
source(str_c(getwd(),"/R/stock_assessment/check_utilities.R"))
# list the current folders in C:/temps to run into the loop

directories<-list.dirs(path = mylocalfolder, full.names = TRUE, recursive = FALSE)
datacallfiles<-c("Eel_Data_Call_Annex2_Catch_and_Landings.xlsx",
    "Eel_Data_Call_Annex3_Stocking.xlsx",
    "Eel_Data_Call_Annex4_Aquaculture_Production.xlsx")


# to get ices division list but just once, this is out from the loop
ices_squares<-read_excel(
    path=str_c(directories[1],"/",datacallfiles[1]),"tr_faoareas",
    skip=0)
ices_division<-as.character(ices_squares$f_code)

# inits before entering the loop
metadata_list<-list() # A list to store the data from metadata
data_list<-list() # A list to store data)
# loop in directories 
# for tests/ development uncomment and run the code inside the loop
# i=1
# this code will run through the file and generate warnings to update the files
for (i in 1:length(directories)) {
  # get the name of the country
  country<- gsub("/","",gsub(mylocalfolder, "", directories[i])) 
  metadata_list[[country]]<-list() # creates an element in the list with the name of the country
  data_list[[country]]<-list() # creates an element in the list with the name of the country
  cat(str_c(country,"\n"))
  
  ############# CATCH AND LANDINGS #############################################
  
  #---------------------- METADATA sheet ---------------------------------------------
  
  # read the metadata sheet
  metadata<-read_excel(path=str_c(directories[i],"/",datacallfiles[1]),"metadata" , skip=4)
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") warning(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country))
  # store the content of metadata in a list
  metadata_list[[country]][["contact"]] <- as.character(metadata[1,2])
  metadata_list[[country]][["contactemail"]] <- as.character(metadata[2,2])
  metadata_list[[country]][["method_catch_landings"]] <- as.character(metadata[3,2])
  # end loop for directories
  
  #---------------------- catch_landings sheet ---------------------------------------------
  # read the catch_landings sheet
  catch_landings<-read_excel(
      path=str_c(directories[i],"/",datacallfiles[1]),"catch_landings",
      skip=0)
  # check for the file integrity
  if (ncol(catch_landings)!=12) warning(str_c("number column wrong ",datacallfiles[1]," in ",country))
  # check column names
  if (!all.equal(colnames(catch_landings),
      c("eel_typ_id","eel_year","eel_value","eel_missvaluequa","eel_emu_nameshort",
          "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
          "eel_qal_id", "eel_qal_comment","eel_comment"))) 
    warning(str_c("problem in column names",
            datacallfiles[1]," in ",
            country)) 
  colnames(catch_landings)[4]<-"eel_missvaluequal" # there is a problem in catch and landings sheet
  
  ###### eel_typ_id ##############
  
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_typ_id",
      country=country)
  #  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
  check_values(dataset=catch_landings,
      column="eel_typ_id",
      country=country,
      values=c(4,5,6,7))
  
  ###### eel_year ##############
  
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_year",
      country=country)
  # should be a numeric
  check_type(dataset=catch_landings,
      column="eel_year",
      country=country,
      type="numeric")
  
  ###### eel_value ##############
  
  # can have missing values if eel_missingvaluequa is filled (check later)
  
  # should be numeric
  check_type(dataset=catch_landings,
      column="eel_value",
      country=country,
      type="numeric")
  
  ###### eel_missvaluequa ##############
  
  #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
  # and also that no missing values are provided without a comment is eel_missvaluequa
  check_missvaluequa(dataset=catch_landings,
      country=country)
  
  ###### eel_emu_name ##############
  
  check_missing(dataset=catch_landings,
      column="eel_emu_nameshort",
      country=country)
  
  check_type(dataset=catch_landings,
      column="eel_emu_nameshort",
      country=country,
      type="character")
  
  ###### eel_cou_code ##############
  
  # must be a character
  check_type(dataset=catch_landings,
      column="eel_cou_code",
      country=country,
      type="character")
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_cou_code",
      country=country)
  # must only have one value
  check_unique(dataset=catch_landings,
      column="eel_cou_code",
      country=country)
  
  ###### eel_lfs_code ##############
  
  check_type(dataset=catch_landings,
      column="eel_lfs_code",
      country=country,
      type="character")
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_lfs_code",
      country=country)
  # should only correspond to the following list
  check_values(dataset=catch_landings,
      column="eel_lfs_code",
      country=country,
      values=c("G","S","YS","GY","Y"))
  
  ###### eel_hty_code ##############
  
  check_type(dataset=catch_landings,
      column="eel_hty_code",
      country=country,
      type="character")
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_hty_code",
      country=country)
  # should only correspond to the following list
  check_values(dataset=catch_landings,
      column="eel_hty_code",
      country=country,
      values=c("F","R","C","MO"))
  
  ###### eel_area_div ##############
  
  check_type(dataset=catch_landings,
      column="eel_area_division",
      country=country,
      type="character")
  # should not have any missing value
  check_missing(dataset=catch_landings,
      column="eel_area_division",
      country=country)
  # the dataset ices_division should have been loaded there
  check_values(dataset=catch_landings,
      column="eel_area_division",
      country=country,
      values=ices_division)
  
  data_list[[country]][["catch_landings"]]<-catch_landings # store the tibble in the list
  
  
  ############# RESTOCKING #############################################
  
  #---------------------- METADATA sheet ---------------------------------------------
  
  # read the metadata sheet
  metadata<-read_excel(path=str_c(directories[i],"/",datacallfiles[2]),"metadata" , skip=4)
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") warning(str_c("The structure of metadata has been changed ",datacallfiles[2]," in ",country))
  metadata_list[[country]][["method_restocking"]] <- as.character(metadata[3,2])
  # end loop for directories
  
  #---------------------- restocking sheet ---------------------------------------------
  
  
  restocking<-read_excel(
      path=str_c(directories[i],"/",datacallfiles[2]),"restocking",
      skip=0)
  # check for the file integrity
  if (ncol(restocking)!=12) warning(str_c("number column wrong ",datacallfiles[1]," in ",country))
  # check column names
  if (all.equal(colnames(restocking),
      c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
          "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
          "eel_qal_id", "eel_qal_comment","eel_comment"))!=TRUE) 
    warning(str_c("problem in column names",
            datacallfiles[1]," in ",
            country)) 
  if (nrow(restocking)>0) {
      ###### eel_typ_id ##############
      
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_typ_id",
              country=country)
      #  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
      check_values(dataset=restocking,
              column="eel_typ_id",
              country=country,
              values=c(8,9))
      
      ###### eel_year ##############
      
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_year",
              country=country)
      # should be a numeric
      check_type(dataset=restocking,
              column="eel_year",
              country=country,
              type="numeric")
      
      ###### eel_value ##############
      
      # can have missing values if eel_missingvaluequa is filled (check later)
      
      # should be numeric
      check_type(dataset=restocking,
              column="eel_value",
              country=country,
              type="numeric")
      
      ###### eel_missvaluequa ##############
      
      #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
      # and also that no missing values are provided without a comment is eel_missvaluequa
      check_missvaluequa(dataset=restocking,
              country=country)
      
      ###### eel_emu_name ##############
      
      check_missing(dataset=restocking,
              column="eel_emu_nameshort",
              country=country)
      
      check_type(dataset=restocking,
              column="eel_emu_nameshort",
              country=country,
              type="character")
      
      ###### eel_cou_code ##############
      
      # must be a character
      check_type(dataset=restocking,
              column="eel_cou_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_cou_code",
              country=country)
      # must only have one value
      check_unique(dataset=restocking,
              column="eel_cou_code",
              country=country)
      
      ###### eel_lfs_code ##############
      
      check_type(dataset=restocking,
              column="eel_lfs_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_lfs_code",
              country=country)
      # should only correspond to the following list
      check_values(dataset=restocking,
              column="eel_lfs_code",
              country=country,
              values=c("G","GY","Y"))
      
      ###### eel_hty_code ##############
      
      check_type(dataset=restocking,
              column="eel_hty_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_hty_code",
              country=country)
      # should only correspond to the following list
      check_values(dataset=restocking,
              column="eel_hty_code",
              country=country,
              values=c("F","R","C","MO"))
      
      ###### eel_area_div ##############
      
      check_type(dataset=restocking,
              column="eel_area_division",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=restocking,
              column="eel_area_division",
              country=country)
      # the dataset ices_division should have been loaded there
      check_values(dataset=restocking,
              column="eel_area_division",
              country=country,
              values=ices_division)
      
      data_list[[country]][["restocking"]]<-list()# creates an element in the list datalist with the name catch and landings
      data_list[[country]][["restocking"]]<-restocking # store the tibble in the list
  } else {
    data_list[[country]][["restocking"]]<-NA 
  }
  ############# AQUACULTURE PRODUCTION #############################################
  
  #---------------------- METADATA sheet ---------------------------------------------
  
  # read the metadata sheet
  metadata<-read_excel(path=str_c(directories[i],"/",datacallfiles[3]),"metadata" , skip=4)
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") warning(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country))
  metadata_list[[country]][["method_aquaculture_production"]] <- as.character(metadata[3,2])
  # end loop for directories
  
  #---------------------- aquaculture sheet ---------------------------------------------
  
  
  aquaculture<-read_excel(
      path=str_c(directories[i],"/",datacallfiles[3]),"aquaculture",
      skip=0)
  # check for the file integrity
  if (ncol(aquaculture)!=12) warning(str_c("number column wrong ",datacallfiles[1]," in ",country))
  # check column names
  if (all.equal(colnames(aquaculture),
      c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
          "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
          "eel_qal_id", "eel_qal_comment","eel_comment"))!=TRUE) 
    warning(str_c("problem in column names",
            datacallfiles[3]," in ",
            country)) 
  if (nrow(aquaculture)>0){
      ###### eel_typ_id ##############
      
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_typ_id",
              country=country)
      #  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
      check_values(dataset=aquaculture,
              column="eel_typ_id",
              country=country,
              values=c(11,12))
      
      ###### eel_year ##############
      
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_year",
              country=country)
      # should be a numeric
      check_type(dataset=aquaculture,
              column="eel_year",
              country=country,
              type="numeric")
      
      ###### eel_value ##############
      
      # can have missing values if eel_missingvaluequa is filled (check later)
      
      # should be numeric
      check_type(dataset=aquaculture,
              column="eel_value",
              country=country,
              type="numeric")
      
      ###### eel_missvaluequa ##############
      
      #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
      # and also that no missing values are provided without a comment is eel_missvaluequa
      check_missvaluequa(dataset=aquaculture,
              country=country)
      
      ###### eel_emu_name ##############
      
      check_missing(dataset=aquaculture,
              column="eel_emu_nameshort",
              country=country)
      
      check_type(dataset=aquaculture,
              column="eel_emu_nameshort",
              country=country,
              type="character")
      
      ###### eel_cou_code ##############
      
      # must be a character
      check_type(dataset=aquaculture,
              column="eel_cou_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_cou_code",
              country=country)
      # must only have one value
      check_unique(dataset=aquaculture,
              column="eel_cou_code",
              country=country)
      
      ###### eel_lfs_code ##############
      
      check_type(dataset=aquaculture,
              column="eel_lfs_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_lfs_code",
              country=country)
      # should only correspond to the following list
      check_values(dataset=aquaculture,
              column="eel_lfs_code",
              country=country,
              values=c("G","GY","Y"))
      
      ###### eel_hty_code ##############
      
      check_type(dataset=aquaculture,
              column="eel_hty_code",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_hty_code",
              country=country)
      # should only correspond to the following list
      check_values(dataset=aquaculture,
              column="eel_hty_code",
              country=country,
              values=c("F","R","C","MO"))
      
      ###### eel_area_div ##############
      
      check_type(dataset=aquaculture,
              column="eel_area_division",
              country=country,
              type="character")
      # should not have any missing value
      check_missing(dataset=aquaculture,
              column="eel_area_division",
              country=country)
      # the dataset ices_division should have been loaded there
      check_values(dataset=aquaculture,
              column="eel_area_division",
              country=country,
              values=ices_division)
      
      data_list[[country]][["aquaculture"]]<-list()# creates an element in the list datalist with the name catch and landings
      data_list[[country]][["aquaculture"]]<-aquaculture # store the tibble in the list
  } else {
    data_list[[country]][["aquaculture"]]<-NA
  }
  
} # end the loop

