# import_to_database.R
# Script to read the different files in the datacall and write the results to the database
# Status development
###############################################################################


# Look at the README file for instructions on how to use this script on your computer

# here is a list of the required packages
library("readxl") # to read xls files
library("stringr") # this contains utilities for strings
library("sqldf") 
library("RPostgreSQL") 
options(sqldf.RPostgreSQL.user = "postgres", 
	sqldf.RPostgreSQL.password = passwordlocal,
	sqldf.RPostgreSQL.dbname = "wgeel",
	sqldf.RPostgreSQL.host = "localhost", # "localhost"
	sqldf.RPostgreSQL.port = 5432)

# this is the folder where you will store the files prior to upload
# don't forget to put an / at the end of the string
#mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"
mylocalfolder <-"C:/temp/wgeel/datacall"
#mylocalfolder <- "C:/Users/pohlmann/Desktop/WGEEL/WGEEL 2017/Task 1/06. Data/datacall"
# you will need to put the following files there
datawd<-mylocalfolder
# path to local github (or write a local copy of the files and point to them)
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")
#setwd("C:/Users/pohlmann/Desktop/WGEEL/WGEEL 2017/Task 1")
source(str_c(getwd(),"/R/utilities/check_utilities.R"))
# list the current folders in C:/temps to run into the loop

directories<-list.dirs(path = mylocalfolder, full.names = TRUE, recursive = FALSE)
datacallfiles<-c("Eel_Data_Call_Annex2_Catch_and_Landings.xlsx",
    "Eel_Data_Call_Annex3_Stocking.xlsx",
    "Eel_Data_Call_Annex4_Aquaculture_Production.xlsx")


# to get ices division list but just once, this is out from the loop
# the ices division are extracted from the datacall itself
ices_squares<-read_excel(
    path=str_c(directories[1],"/",datacallfiles[1]),"tr_faoareas",
    skip=0)
ices_division<-as.character(ices_squares$f_code)

# inits before entering the loop
metadata_list<-list() # A list to store the data from metadata
data_list<-list() # A list to store data)
############### begin function###################
# sinew::makeOxygen(check_directories) 
#' @title function to check the datacall files in directories
#' @description This functions runs in a loop, each table is stored in a list with 
#' the country names, a
#' @param i the order of the folder, Default: NULL
#' @return A list with each list level being one country and containing all tables extracted
#' @details This function essentially runs through a loop in all directories,
#' and checks the details of the datacall using functions developped in check utilities.
#' These will print output on screen indicating which problem arise in data and at what line they happen.
#' When i is NULL the function runs the whole loop. On first launches, this should be avoided
#' as problems of structures in the datasheets make the program crash so one has to be able to
#' launch the function directory per directory
#' @note This function will have to be adapted to new data standards for the next datacall
#' @examples 
#' \dontrun{
#' # these objects are needed by the program
#' 

#'  # launch with only one directory
#'   country<- gsub("/","",gsub(mylocalfolder, "", directories[i=1])) 
#'   data_list<-check_directories(i=1)
#'  # launch with all directories
#'  
#'  
#' }
check_directories<-function(i=NULL){
  {
    
    check_one_directory<-function(i,country){
      # get the name of the country
      
      cat(str_c("-------------------------","\n"))
      cat(str_c(country,"\n"))
      cat(str_c("---------------------------","\n"))
      # most files don't have the same name, so I will search for files including file name 
      the_files<-list.files(path = directories[i],recursive = FALSE)
      the_files<-the_files[!grepl("~", the_files)]
      the_metadata<-list()
      the_data<-list()
      
      
      ############# CATCH AND LANDINGS #############################################
      
      #---------------------- METADATA sheet ---------------------------------------------
      mylocalfilename<-gsub(".xlsx","",datacallfiles[1])
      if (length(grep(mylocalfilename,the_files))==1){
        mylocalfilename<-the_files[grep(mylocalfilename,the_files)]
      } else {
        cat(str_c("String ", mylocalfilename, " not found, please check names \n "))
      }
      # read the metadata sheet
      metadata<-read_excel(path=str_c(directories[i],"/",mylocalfilename),"metadata" , skip=4)
      # check if no rows have been added
      if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
      # store the content of metadata in a list
      if (ncol(metadata)>1){   
        the_metadata[["contact"]] <- as.character(metadata[1,2])
        the_metadata[["contactemail"]] <- as.character(metadata[2,2])
        the_metadata[["method_catch_landings"]] <- as.character(metadata[3,2])
      } else {
        the_metadata[["contact"]] <- NA
        the_metadata[["contactemail"]] <- NA
        the_metadata[["method_catch_landings"]] <- NA
      }
      # end loop for directories
      
      #---------------------- catch_landings sheet ---------------------------------------------
      
      # read the catch_landings sheet
      cat("catch and landings \n")
# here we have already seached for catch and landings above.
      catch_landings<-read_excel(
          path=str_c(directories[i],"/",mylocalfilename),"catch_landings",
          skip=0)
      # check for the file integrity
      if (ncol(catch_landings)!=13) cat(str_c("number column wrong ",datacallfiles[1]," in ",country,"\n"))
      # check column names
# colnames(catch_landings)%in%
#              c("eel_typ_id","eel_year","eel_value","eel_missvaluequa","eel_emu_nameshort",
#                      "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
#                      "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")
      if (!all.equal(colnames(catch_landings),
          c("eel_typ_id","eel_year","eel_value","eel_missvaluequa","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))==TRUE) 
        cat(str_c("problem in column names",
                datacallfiles[1]," in ",
                country,"\n")) 
      colnames(catch_landings)[4]<-"eel_missvaluequal" # there is a problem in catch and landings sheet
      #TODO treat OG_ replace with OG 
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
          values=c("G","S","YS","GY","Y","AL"))
      
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
          values=c("F","T","C","MO","AL"))
      
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
      
      ###### eel_qal_id ############## 
      check_missing(dataset=catch_landings,
          column="eel_qal_id",
          country=country)
      
      check_values(dataset=catch_landings,
          column="eel_qal_id",
          country=country,
          values=c(0,1,2,3))
      ###### eel_datasource ############## 
      check_missing(dataset=catch_landings,
          column="eel_datasource",
          country=country)
      
      check_values(dataset=catch_landings,
          column="eel_datasource",
          country=country,
          values=c("dc_2017","wgeel_2016","wgeel_2017"))
      
      the_data[["catch_landings"]]<-catch_landings # store the tibble in the list
      
      
      ############# RESTOCKING #############################################
      
      #---------------------- METADATA sheet ---------------------------------------------
      cat("Restocking \n")
      mylocalfilename<-gsub(".xlsx","",datacallfiles[2])
      if (length(grep(mylocalfilename,the_files))==1){
        mylocalfilename<-the_files[grep(mylocalfilename,the_files)]
        
        # read the metadata sheet
        metadata<-read_excel(path=str_c(directories[i],"/",mylocalfilename),"metadata" , skip=4)
        # check if no rows have been added
        if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[2]," in ",country,"\n"))
        # if there is no value in the cells then the tibble will only have one column
        if (ncol(metadata)>1){
          metadata_list[[country]][["method_restocking"]] <- as.character(metadata[3,2])
        } else {
          metadata_list[[country]][["method_restocking"]]  <-NULL
        }
        
        # end loop for directories
        
        #---------------------- restocking sheet ---------------------------------------------
        
        
        restocking<-read_excel(
            path=str_c(directories[i],"/",mylocalfilename),"restocking",
            skip=0)
        
        # check for the file integrity
        if (ncol(restocking)!=13) cat(str_c("number column wrong ",mylocalfilename," in ",country,"\n"))
        # check column names
        if (all.equal(colnames(restocking),
            c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))!=TRUE) 
          cat(str_c("problem in column names",
                  mylocalfilename," in ",
                  country,"\n")) 
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
              values=c("G","GY","Y","QG","OG","YS","S","AL"))
          
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
              values=c("F","T","C","MO","AL"))
          
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
          ###### eel_qal_id ############## 
          check_missing(dataset=restocking,
              column="eel_qal_id",
              country=country)
          
          check_values(dataset=restocking,
              column="eel_qal_id",
              country=country,
              values=c(0,1,2,3))
          ###### eel_datasource ############## 
          check_missing(dataset=restocking,
              column="eel_datasource",
              country=country)
          check_values(dataset=restocking,
              column="eel_datasource",
              country=country,
              values=c("dc_2017","wgeel_2016","wgeel_2017"))
          
          the_data[["restocking"]]<-list()# creates an element in the list datalist with the name catch and landings
          the_data[["restocking"]]<-restocking # store the tibble in the list
        } else {
          the_data[["restocking"]]<-NA 
        }
      } else {
        cat(str_c("String ", mylocalfilename, " not found, please check names \n"))
      }
      ############# AQUACULTURE PRODUCTION #############################################
      
      #---------------------- METADATA sheet ---------------------------------------------
      cat("Aquaculture \n")
      mylocalfilename<-gsub(".xlsx","",datacallfiles[3])
      if (length(grep(mylocalfilename,the_files))==1){
        mylocalfilename<-the_files[grep(mylocalfilename,the_files)]
        
        # read the metadata sheet
        metadata<-read_excel(path=str_c(directories[i],"/",mylocalfilename),"metadata" , skip=4)
        # check if no rows have been added
        if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country),"\n")
        # if there is no value in the cells then the tibble will only have one column
        if (ncol(metadata)>1){
          metadata_list[[country]][["method_aquaculture_production"]] <- as.character(metadata[3,2])
        } else {
          metadata_list[[country]][["method_aquaculture_production"]] <-NULL
        }
        # end loop for directories
        
        #---------------------- aquaculture sheet ---------------------------------------------
        
        
        aquaculture<-read_excel(
            path=str_c(directories[i],"/",mylocalfilename),"aquaculture",
            skip=0)
        
        # check for the file integrity
        if (ncol(aquaculture)!=13) cat(str_c("number column wrong ",datacallfiles[3]," in ",country,"\n"))
        # check column names
        if (all.equal(colnames(aquaculture),
            c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))!=TRUE) 
          cat(str_c("problem in column names",
                  mylocalfilename," in ",
                  country,"\n")) 
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
              values=c("G","GY","Y","YS","S","OG","QG","AL"))
          
          ###### eel_hty_code ##############
# habitat makes no sense there      
#      check_type(dataset=aquaculture,
#          column="eel_hty_code",
#          country=country,
#          type="character")
#      # should not have any missing value
#      check_missing(dataset=aquaculture,
#          column="eel_hty_code",
#          country=country)
#      # should only correspond to the following list
#      check_values(dataset=aquaculture,
#          column="eel_hty_code",
#          country=country,
#          values=c("F","T","C","MO"))
          
          ###### eel_area_div ##############
# same no need for a division in aquaculture sheet      
#      check_type(dataset=aquaculture,
#          column="eel_area_division",
#          country=country,
#          type="character")
#      # should not have any missing value
#      check_missing(dataset=aquaculture,
#          column="eel_area_division",
#          country=country)
#      # the dataset ices_division should have been loaded there
#      check_values(dataset=aquaculture,
#          column="eel_area_division",
#          country=country,
#          values=ices_division)
          ###### eel_qal_id ############## 
          check_missing(dataset=aquaculture,
              column="eel_qal_id",
              country=country)
          check_values(dataset=aquaculture,
              column="eel_qal_id",
              country=country,
              values=c(0,1,2,3))
          ###### eel_datasource ############## 
          check_missing(dataset=aquaculture,
              column="eel_datasource",
              country=country)
          check_values(dataset=aquaculture,
              column="eel_datasource",
              country=country,
              values=c("dc_2017","wgeel_2016","wgeel_2017"))        
          the_data[["aquaculture"]]<-list()# creates an element in the list datalist with the name catch and landings
          the_data[["aquaculture"]]<-aquaculture # store the tibble in the list
        } else {
          the_data[["aquaculture"]]<-NA
        }
      } else {
        cat(str_c("String ", mylocalfilename, " not found, please check names \n"))
      }
      # assigns the metadatalist in globalEnv (the user's env) and returns data_list
      return(list("the_data"=the_data,"the_metadata"=the_metadata))
    } # end the loop
  }# end check_one_directory
  ####################
  # Here two options, either we laucnch for a number, ie a directory or we launch and load the whole set of files
  if (is.null(i)){
    for (i in 1:length(directories)){
      country<- gsub("/","",gsub(mylocalfolder, "", directories[i])) 
      metadata_list[[country]]<-list() # creates an element in the list with the name of the country
      data_list[[country]]<-list() # creates an element in the list with the name of the country
      the_list<- check_one_directory(i,country)
      data_list[[country]][["aquaculture"]]<-the_list[["the_data"]][["aquaculture"]]
      data_list[[country]][["restocking"]]<-the_list[["the_data"]][["restocking"]]
      data_list[[country]][["catch_landings"]]<-the_list[["the_data"]][["catch_landings"]]
    }
    ##############################
# Merging data from lists into data frame
    ##############################
    
    return(data_list)
  } else { # i is provided as an argument to the function
    data_list<- check_one_directory(i,country)
    return(data_list)
  }
}
############### end function###################

directories


# launch for all directories
data_list<-check_directories()
# unfold the data from the lists
catch_landings_final<-data.frame()
for (j in 1:length(data_list))
{
  catch_landings_final<- rbind(catch_landings_final,data_list[[j]][["catch_landings"]])
}
aquaculture_final<-data.frame()
for (j in 1:length(data_list))
{
  aquaculture_final<- rbind(aquaculture_final,data_list[[j]][["aquaculture"]])
}

restocking_final<-data.frame()
for (j in 1:length(data_list))
{
  restocking_final<- rbind(restocking_final,data_list[[j]][["restocking"]])
}

show_datacall<-function(dataset,
    typ_id=NULL,  
    year=NULL,
    cou_code=NULL,
    value=NULL, # ">0
    missvaluequal=NULL,
    emu_nameshort=NULL,
    lfs_code=NULL,   
    hty_code=NULL, 
    area_division=NULL,
    qal_id=NULL,        
    datasource=NULL){
  #dataset<-as.data.frame(dataset)
  if (!is.character(typ_id) & !is.null(typ_id)) stop("typ_id should be a character")
  if (!is.numeric(year) & !is.null(year)) stop("year should be a numeric")
  if (!is.character(cou_code) & !is.null(cou_code)) stop("cou_code should be a character")
  if (!is.character(value) & !is.null(value)) stop("value should be a character string like '>1000' or '==0'")
  if (!is.character(missvaluequal) & !is.null(missvaluequal)) stop("missvaluequal should be a character")
  if (!is.character(emu_nameshort) & !is.null(emu_nameshort)) stop("emu_nameshort should be a character")
  if (!is.character(lfs_code) & !is.null(lfs_code)) stop("lfs_code should be a character")
  if (!is.character(hty_code) & !is.null(hty_code)) stop("hty_code should be a character")
  if (!is.character(area_division) & !is.null(area_division)) stop("area_division should be a character")
  if (!is.numeric(qal_id) & !is.null(qal_id)) stop("qal_id should be a numeric")
  if (!is.numeric(datasource) & !is.null(datasource)) stop("datasource should be a character")
  
  
  if (! is.null(typ_id)) condition1=str_c("dataset$eel_typ_id=='",typ_id,"'&") else condition1=""
  if (! is.null(year)) condition2=str_c("dataset$eel_year==",year,"&") else condition2=""
  if (! is.null(cou_code)) condition3=str_c("dataset$eel_cou_code=='",cou_code,"'&") else condition3=""
  if (! is.null(value)) condition4=str_c("dataset$eel_value",value,"&") else condition4=""
  if (! is.null(missvaluequal)) condition5=str_c("dataset$eel_missvaluequal=='",missvaluequal,"'&") else condition5=""
  if (! is.null(emu_nameshort)) condition6=str_c("dataset$eel_emu_nameshort=='",emu_nameshort,"'&") else condition6=""
  if (! is.null(lfs_code)) condition7=str_c("dataset$lfs_code=='",lfs_code,"'&") else condition7=""
  if (! is.null(hty_code)) condition8=str_c("dataset$hty_code=='",hty_code,"'&") else condition8=""
  if (! is.null(area_division)) condition9=str_c("dataset$eel_area_division=='",area_division,"'&") else condition9=""
  if (! is.null(qal_id)) condition10=str_c("dataset$eel_qal_id==",qal_id,"&") else condition10=""
  if (! is.null(datasource)) condition11=str_c("dataset$eel_datasource=='",datasource,"'&") else condition11=""
  
  condition=str_c(condition1,condition2,condition3,condition4,condition5,condition6,condition7,condition8,condition9,condition10,condition11)
  condition<-substring(condition,1,nchar(condition)-1)
  return(dataset[ eval(parse(text=condition)),])
}
show_datacall(dataset=catch_landings_final,cou_code="FR") 
show_datacall(dataset=catch_landings_final,cou_code="IT") 
show_datacall(dataset=catch_landings_final,value=">3000")

##############################
# Import into the database
##############################
# Only this step will ensure the integrity of the data. R script above should have resolved most problems, but
# still some were remaining.
#-----------------------------------------------------
# to delete everything prior to insertion
# don't run this unless you are reloading everything
# sqldf("delete from  datawg.t_eelstock_eel")
# delete only catches and landings from the database
# sqldf("delete from  datawg.t_eelstock_eel where eel_typ_id in (4,5,6,7)")
# check what is in the database
# sqldf("select * from datawg.t_eelstock_eel")
# problem of format of some column, qal id completely void is logical should be integer
#dplyr::glimpse(catch_landings_final)
catch_landings_final$eel_qal_id=as.integer(catch_landings_final$eel_qal_id)
# correcting problem for germany

#catch_landings_final$eel_area_division[catch_landings_final$eel_area_division=="27.3.c, d"&
#        !is.na(catch_landings_final$eel_area_division)]<-"27.3.d"
# correcting problem for Ireland
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="IE_National"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"IE_total"
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="IE_Total"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"IE_total"
options(tibble.print_max = Inf)
options(tibble.width = Inf)

# transforming catch into landings and only using landings 
catch_landings_final$eel_typ_id[catch_landings_final$eel_typ_id==5]<-4
catch_landings_final$eel_typ_id[catch_landings_final$eel_typ_id==7]<-6
catch_landings_final$eel_value<-as.numeric(catch_landings_final$eel_value)
# removing zeros from the database
#catch_landings_final<-catch_landings_final[!catch_landings_final$eel_value==0&!is.na(catch_landings_final$eel_value),]
# removing area division from freshwater sites
catch_landings_final[catch_landings_final$eel_hty_code=='F'&
        !is.na(catch_landings_final$eel_hty_code)&
        !is.na(catch_landings_final$eel_area_division),"eel_area_division"]<-NA
# Denmark and Norway are in tons
catch_landings_final[catch_landings_final$eel_cou_code %in% c("NO","DK"),"eel_value"]<-
    catch_landings_final[catch_landings_final$eel_cou_code %in% c("NO","DK"),"eel_value"]*1000

sqldf("insert into datawg.t_eelstock_eel (
        eel_typ_id,
        eel_year ,
        eel_value  ,
        eel_missvaluequal,
        eel_emu_nameshort,
        eel_cou_code,
        eel_lfs_code,
        eel_hty_code,
        eel_area_division,
        eel_qal_id,
        eel_qal_comment,
        eel_comment,
		eel_datasource)
        select * from catch_landings_final")
################"
# aquaculture
#################

aquaculture_final$eel_qal_id=as.integer(aquaculture_final$eel_qal_id)
aquaculture_final<-aquaculture_final[!is.na(aquaculture_final$eel_year),]
# check that those lines belong to DE
aquaculture_final[is.na(aquaculture_final$eel_emu_nameshort),]
aquaculture_final$eel_emu_nameshort[is.na(aquaculture_final$eel_emu_nameshort)]<-"DE_total"
aquaculture_final$eel_value<-as.numeric(aquaculture_final$eel_value)
sqldf("insert into datawg.t_eelstock_eel (
        eel_typ_id,
        eel_year ,
        eel_value  ,
        eel_missvaluequal,
        eel_emu_nameshort,
        eel_cou_code,
        eel_lfs_code,
        eel_hty_code,
        eel_area_division,
        eel_qal_id,
        eel_qal_comment,
        eel_comment,
		eel_datasource)
        select * from aquaculture_final")

restocking_final$eel_qal_id=as.integer(restocking_final$eel_qal_id)
# some years badly formed (Italy aquaculture)
restocking_final[is.na(as.integer(restocking_final$eel_year)),]
restocking_final$eel_value<-as.numeric(restocking_final$eel_value)
restocking_final$eel_year<-as.numeric(restocking_final$eel_year)
restocking_final[is.na(restocking_final$eel_year),]
restocking_final$eel_lfs_code[restocking_final$eel_lfs_code=="y"&!is.na(restocking_final$eel_lfs_code)]<-'Y'
restocking_final[restocking_final$eel_area_division=="273"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
restocking_final[restocking_final$eel_area_division=="271"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
# temporarily removing Spain
#restocking_final<-restocking_final[!restocking_final$eel_cou_code=="ES",]
sqldf("insert into datawg.t_eelstock_eel (
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
		eel_datasource)
        select * from restocking_final")

datacall_2017<-sqldf("select * from datawg.t_eelstock_eel")
write.table(datacall_2017,file=str_c(mylocalfolder,"/datacall_2017.csv"),sep=";")



#########################
# Load data from the database
########################

landings <- sqldf(str_c("select * from  datawg.landings"))
aquaculture <- sqldf(str_c("select * from  datawg.aquaculture"))
stocking <- sqldf(str_c("select * from  datawg.stocking"))

show_datacall(dataset=landings,cou_code="IT") 

# save them again as csv.....
write.table(aquaculture, file=str_c(mylocalfolder,"/aquaculture.csv"),sep=";")
write.table(landings, file=str_c(mylocalfolder,"/landings.csv"),sep=";")
write.table(stocking, file=str_c(mylocalfolder,"/stocking.csv"),sep=";")

lfs_code_base <- sqldf("select lfs_code from ref.tr_lifestage_lfs")[,1]
save(lfs_code_base,file=str_c(mylocalfolder,"/lfs_code.Rdata"))
