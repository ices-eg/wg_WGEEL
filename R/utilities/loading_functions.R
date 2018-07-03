# Name : loading_functions.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################

############# CATCH AND LANDINGS #############################################

#---------------------- METADATA sheet ---------------------------------------------
# path<-file.choose()
load_catch_landings<-function(path){
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
# read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4)
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
          path=path,
          sheet =3,
          skip=0)
  country=as.character(catch_landings[1,6])
# check for the file integrity
  if (ncol(catch_landings)!=13) cat(str_c("number column wrong ",file,"\n"))
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
  return(catch_landings) 
}



