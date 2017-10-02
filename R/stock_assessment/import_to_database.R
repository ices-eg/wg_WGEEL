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
mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"
# you will need to put the following files there

# path to local github (or write a local copy of the files and point to them)
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")
source(str_c(getwd(),"/R/stock_assessment/check_utilities.R"))
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
# loop in directories 
# for tests/ development uncomment and run the code inside the loop
# i=1
# this code will run through the file and generate warnings to update the files
for (i in 1:length(directories)) {
  # get the name of the country
  country<- gsub("/","",gsub(mylocalfolder, "", directories[i])) 
  metadata_list[[country]]<-list() # creates an element in the list with the name of the country
  data_list[[country]]<-list() # creates an element in the list with the name of the country
  cat(str_c("-------------------------","\n"))
  cat(str_c(country,"\n"))
  cat(str_c("---------------------------","\n"))
  # most files don't have the same name, so I will search for files including file name 
  the_files<-list.files(path = directories[i],recursive = FALSE)
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
    metadata_list[[country]][["contact"]] <- as.character(metadata[1,2])
    metadata_list[[country]][["contactemail"]] <- as.character(metadata[2,2])
    metadata_list[[country]][["method_catch_landings"]] <- as.character(metadata[3,2])
  } else {
    metadata_list[[country]][["contact"]] <- NA
    metadata_list[[country]][["contactemail"]] <- NA
    metadata_list[[country]][["method_catch_landings"]] <- NA
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
  if (ncol(catch_landings)!=12) cat(str_c("number column wrong ",datacallfiles[1]," in ",country,"\n"))
  # check column names
  if (!all.equal(colnames(catch_landings),
      c("eel_typ_id","eel_year","eel_value","eel_missvaluequa","eel_emu_nameshort",
          "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
          "eel_qal_id", "eel_qal_comment","eel_comment"))) 
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
      values=c("F","T","C","MO"))
  
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
    if (ncol(restocking)!=12) cat(str_c("number column wrong ",mylocalfilename," in ",country,"\n"))
    # check column names
    if (all.equal(colnames(restocking),
        c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
            "eel_qal_id", "eel_qal_comment","eel_comment"))!=TRUE) 
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
          values=c("G","GY","Y","QG","OG","YS","S"))
      
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
          values=c("F","T","C","MO"))
      
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
    if (ncol(aquaculture)!=12) cat(str_c("number column wrong ",datacallfiles[1]," in ",country,"\n"))
    # check column names
    if (all.equal(colnames(aquaculture),
        c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
            "eel_qal_id", "eel_qal_comment","eel_comment"))!=TRUE) 
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
          values=c("G","GY","Y","YS","S","OG","QG"))
      
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
      
      data_list[[country]][["aquaculture"]]<-list()# creates an element in the list datalist with the name catch and landings
      data_list[[country]][["aquaculture"]]<-aquaculture # store the tibble in the list
    } else {
      data_list[[country]][["aquaculture"]]<-NA
    }
  } else {
    cat(str_c("String ", mylocalfilename, " not found, please check names \n"))
  }
} # end the loop

##############################
# Merging data from lists into data frame
##############################
catch_landings_final<-data.frame()
for (i in 1:length(data_list))
{
  catch_landings_final<- rbind(catch_landings_final,data_list[[i]][["catch_landings"]])
}
aquaculture_final<-data.frame()
for (i in 1:length(data_list))
{
  aquaculture_final<- rbind(aquaculture_final,data_list[[i]][["aquaculture"]])
}

restocking_final<-data.frame()
for (i in 1:length(data_list))
{
  restocking_final<- rbind(restocking_final,data_list[[i]][["restocking"]])
}


##############################
# Import into the database
##############################
# Only this step will ensure the integrity of the data. R script above should have resolved most problems, but
# still some were remaining.

# to delete everything prior to insertion
# sqldf("delete from  datawg.t_eelstock_eel")

# check what is in the database
# sqldf("select * from datawg.t_eelstock_eel")
# problem of format of some column, qal id completely void is logical should be integer
dplyr::glimpse(catch_landings_final)
catch_landings_final$eel_qal_id=as.integer(catch_landings_final$eel_qal_id)
# correcting problem for germany
catch_landings_final$eel_area_division[catch_landings_final$eel_area_division=="27.3.c, d"&
        !is.na(catch_landings_final$eel_area_division)]<-"27.3.d"
# correcting problem for Ireland
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="IE_National"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"IE_total"
options(tibble.print_max = Inf)
options(tibble.width = Inf)
print(catch_landings_final[catch_landings_final$eel_emu_nameshort=="SE_Sout"&
        !is.na(catch_landings_final$eel_emu_nameshort),],100)
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
        eel_comment)
         select * from catch_landings_final")
 aquaculture_final$eel_qal_id=as.integer(aquaculture_final$eel_qal_id)
 aquaculture_final<-aquaculture_final[!is.na(aquaculture_final$eel_year),]
 # check that those lines belong to DE
 aquaculture_final[is.na(aquaculture_final$eel_emu_nameshort),]
 aquaculture_final$eel_emu_nameshort[is.na(aquaculture_final$eel_emu_nameshort)]<-"DE_total"

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
                 eel_comment)
         select * from aquaculture_final")
 
 restocking_final$eel_qal_id=as.integer(restocking_final$eel_qal_id)
 # some years badly formed (Italy aquaculture)
 restocking_final[is.na(as.integer(restocking_final$eel_year)),]
 restocking_final$eel_value<-as.numeric(restocking_final$eel_value)
 restocking_final$eel_lfs_code[restocking_final$eel_lfs_code=="y"&!is.na(restocking_final$eel_lfs_code)]<-'Y'
 restocking_final[restocking_final$eel_area_division=="273"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
 restocking_final[restocking_final$eel_area_division=="271"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
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
         eel_comment)
         select * from restocking_final")
 
 datacall_2017<-sqldf("select * from datawg.t_eelstock_eel")
write.table(datacall_2017,file=str_c(mylocalfolder,"/datacall_2017.csv"),sep=";")



#########################
# Load data from the database
########################

landings <- sqldf(str_c("select * from  datawg.landings"))
aquaculture <- sqldf(str_c("select * from  datawg.aquaculture"))
catch_landings <- sqldf(str_c("select * from  datawg.catch_landings"))
catch <- sqldf(str_c("select * from  datawg.catch"))
stocking <- sqldf(str_c("select * from  datawg.stocking"))

# save them again as csv.....
write.table(aquaculture, file=str_c(mylocalfolder,"/aquaculture.csv"),sep=";")
write.table(landings, file=str_c(mylocalfolder,"/landings.csv"),sep=";")
write.table(catch_landings, file=str_c(mylocalfolder,"/catch_landings.csv"),sep=";")
write.table(catch, file=str_c(mylocalfolder,"/catch.csv"),sep=";")
write.table(stocking, file=str_c(mylocalfolder,"/stocking.csv"),sep=";")

lfs_code_base <- sqldf("select lfs_code from ref.tr_lifestage_lfs")[,1]
save(lfs_code_base,file=str_c(mylocalfolder,"/lfs_code.Rdata"))
