# Name : loading_functions.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################



############# CATCH AND LANDINGS #############################################

# path<-file.choose()
load_catch_landings<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4)
# check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
# store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
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
  catch_landings$eel_datasource <- datasource
# check column names
  if (!all(colnames(catch_landings)%in%
      c("eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
          "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
          "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names",            
            paste(colnames(catch_landings)[!colnames(catch_landings)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= "&"),
            "file =",
            file,"\n")) 
  
  if (nrow(catch_landings)>0) {
    
    ###### eel_typ_name ##############
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_typ_name",
            country=country))
    
#  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_typ_name",
            country=country,
            values=c("com_landings_kg", "rec_landings_kg")))
    
    ###### eel_year ##############
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_year",
            country=country))
# should be a numeric
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
# can have missing values if eel_missingvaluequa is filled (check later)
    
# should be numeric
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
#check that there are data in missvaluequa only when there are missing value (NA) is eel_value
# and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=catch_landings,
            country=country))
    
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
# must be a character
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_cou_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_cou_code",
            country=country))
    
# must only have one value
    data_error= rbind(data_error, check_unique(dataset=catch_landings,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_lfs_code",
            country=country))
    
# should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_lfs_code",
            country=country,
            values=c("G","S","YS","GY","Y","AL")))
    
    ###### eel_hty_code ##############
    
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_hty_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_hty_code",
            country=country))
    
# should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO","AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error, check_type(dataset=catch_landings,
            column="eel_area_division",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_area_division",
            country=country))
    
# the dataset ices_division should have been loaded there
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###### eel_qal_id ############## 
    
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_qal_id",
            country=country))
    
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_qal_id",
            country=country,
            values=c(0,1,2,3)))
    
    ###### eel_datasource ############## 
    
    data_error= rbind(data_error, check_missing(dataset=catch_landings,
            column="eel_datasource",
            country=country))
    
    data_error= rbind(data_error, check_values(dataset=catch_landings,
            column="eel_datasource",
            country=country,
            values=c("dc_2017","wgeel_2016","wgeel_2017")))
    
  }
  return(invisible(list(data=catch_landings,error=data_error,the_metadata=the_metadata))) 
}


############# RELEASES #############################################

# path<-file.choose()
load_release<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  #---------------------- METADATA sheet ---------------------------------------------
  ## It is no necessary for database
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4)
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- release sheet ---------------------------------------------
  
  cat("release \n")
  # here we have already seached for catch and landings above.
  release<-read_excel(
      path=path,
      sheet =3,
      skip=0)
  country=as.character(release[1,7])
  
  # check for the file integrity
  if (ncol(release)!=11) cat(str_c("number column wrong ",file,"\n"))
  release$eel_qal_id <- NA
  release$eel_qal_comment <- NA
  release$eel_datasource <- datasource
  # check column names
  if (!all(colnames(release)%in%
          c("eel_typ_name","eel_year","eel_value_number", "eel_value_kg","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(release)[!colnames(release)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n")) 
  
  if (nrow(release)>0) {
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be one of q_release_n, gee_n
    data_error= rbind(data_error, check_values(dataset=release,
            column="eel_typ_name",
            country=country,
            values=c("release_n", "gee_n")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value_number ##############
    
    # can have missing values if eel_missingvaluequal is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_value_number",
            country=country,
            type="numeric"))
    
    ###### eel_value_kg ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_value_kg",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
    # check if there is data in eel_value_number and eel_value_kg
    # if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
    # if there is data in neither eel_value_number and eel_value_kg, check if there are data in missvaluequa 
    
    data_error= rbind(data_error, check_missvalue_release(dataset=release,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_cou_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_cou_code",
            country=country))
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=release,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_lfs_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_lfs_code",
            country=country))
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=release,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","QG","OG","YS","S","AL")))
    
    ###### eel_hty_code ##############
    
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_hty_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_hty_code",
            country=country))
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=release,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO","AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error, check_type(dataset=release,
            column="eel_area_division",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=release,
            column="eel_area_division",
            country=country))
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error, check_values(dataset=release,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###  deal with eel_value_number and eel_value_kg to import to database
    
    #tibbles are weird, change to dataframe and clear NA in the first column
    release <- as.data.frame(release[!is.na(release[,1]),])
    
    #separate data between number and kg 
    #create data for number and add eel_typ_id 9 
    release_N <- release[,c(1,2,3,5,6,7,8,9,10,11)] 
    
    release_N$eel_typ_id <- NA
    # deal with release_n or gee_n to assign the correct type id 
    for (i in 1:nrow(release_N)) { 
      if (release_N[i,1]=="release_n") { 
        release_N[i,11] <- 9
        release_N[i,1] <- "q_release_n"
      } else {
        release_N[i,11]  <- 10
      }
    } 
    colnames(release_N)[colnames(release_N)=="eel_value_number"] <- "eel_value" 
    
    #create data for kg and add eel_typ_id 8 
    release_kg <- release[,c(1,2,4,5,6,7,8,9,10,11)] 
    release_kg$eel_typ_id <- rep(8, nrow(release)) 
    release_kg$eel_typ_name <- "q_release_kg"
    colnames(release_kg)[colnames(release_kg)=="eel_value_kg"] <- "eel_value" 
    
    #Rbind data in the same data frame to import in database 
    release_tot <- rbind(release_N, release_kg) 
    release_tot<-release_tot[,c(11,1,2,3,4,5,6,7,8,9,10)] 
    
    #Add "ND" in eel_missvaluequal if one value is still missing 
    for (i in 1:nrow(release_tot)) { 
      if (is.na(release_tot[i,4])) { 
        release_tot[i,5] <- "ND" 
      } 
    } 
    
  }
  return(invisible(list(data=release_tot,error=data_error,the_metadata=the_metadata)))
}


############# AQUACULTURE PRODUCTION #############################################

# path <- file.choose()
load_aquaculture<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
#---------------------- METADATA sheet ---------------------------------------------
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- aquaculture sheet ---------------------------------------------
  
  # read the aquaculture sheet
  cat("aquaculture \n")
  
  aquaculture<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  
  country =as.character(aquaculture[1,6])
  
  # check for the file integrity
  if (ncol(aquaculture)!=10) cat(str_c("number column wrong ",file,"\n"))
  aquaculture$eel_qal_id <- NA
  aquaculture$eel_qal_comment <- NA
  aquaculture$eel_datasource <- datasource
  # check column names
  if (!all(colnames(aquaculture)%in%
          c("eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(aquaculture)[!colnames(aquaculture)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))   
  if (nrow(aquaculture)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error = rbind(data_error,  check_missing(dataset=aquaculture,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be q_aqua_kg
    data_error = rbind(data_error,  check_values(dataset=aquaculture,
            column="eel_typ_name",
            country=country,
            values=c("q_aqua_kg")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=aquaculture,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=aquaculture,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=aquaculture,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
    #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=aquaculture,
            country=country))
    
    
    
    ###### eel_emu_name ##############
    data_error = rbind(data_error,   check_missing(dataset=aquaculture,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error,  check_type(dataset=aquaculture,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error,  check_type(dataset=aquaculture,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,  check_missing(dataset=aquaculture,
            column="eel_cou_code",
            country=country))
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=aquaculture,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    data_error= rbind(data_error, check_type(dataset=aquaculture,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=aquaculture,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=aquaculture,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    
  }
  return(invisible(list(data=aquaculture,error=data_error)))
}


############# BIOMASS INDICATORS #############################################
# path <- file.choose()
load_biomass<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
#---------------------- METADATA sheet ---------------------------------------------
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- biomass_indicators sheet ---------------------------------------------
  
  # read the biomass_indicators sheet
  cat("biomass_indicators \n")
  
  biomass_indicators<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  
  country =as.character(biomass_indicators[1,6]) #country code is in the 6th column
  
  # check for the file integrity, only 11 column in this file
  if (ncol(biomass_indicators)!=10) cat(str_c("number column wrong ",file,"\n"))
  biomass_indicators$eel_qal_id <- NA
  biomass_indicators$eel_qal_comment <- NA
  biomass_indicators$eel_datasource <- datasource
  # check column names
#FIXME there is a problem with name in biomass_indicators, here we have to use typ_name
  if (!all(colnames(biomass_indicators)%in%
          c("typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",
            paste(colnames(biomass_indicators)[!colnames(biomass_indicators)%in%
                        c("typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file = ",file,"\n")) 
  
  if (nrow(biomass_indicators)>0){
    
    
    ###### typ_name #############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=biomass_indicators,
            column="typ_name",
            country=country))
    
    #  eel_typ_id should be one of 13 B0_kg  14 Bbest_kg  15 Bcurrent_kg
    data_error= rbind(data_error, check_values(dataset=biomass_indicators,
            column="typ_name",
            country=country,
            values=c("Bcurrent_kg","Bbest_kg","B0_kg")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=biomass_indicators,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequal is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=biomass_indicators,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=biomass_indicators,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=biomass_indicators,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=biomass_indicators,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=biomass_indicators,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=biomass_indicators,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=biomass_indicators,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=biomass_indicators,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=biomass_indicators,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=biomass_indicators,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=biomass_indicators,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=biomass_indicators,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
  }
  return(invisible(list(data=biomass_indicators,error=data_error,the_metadata=the_metadata)))
}



############# MORTALITY RATES #############################################

# path <- file.choose()
load_mortality_rates<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  #---------------------- METADATA sheet ---------------------------------------------
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- mortality_rates_Sigma sheet ---------------------------------------------
  
  # read the mortality_rates sheet
  cat("mortality_rates \n")
  
  mortality_rates<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  country =as.character(mortality_rates[1,6]) #country code is in the 6th column
  
  # check for the file integrity, only 10 column in this file
  if (ncol(mortality_rates)!=10) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  mortality_rates$eel_qal_id <- NA
  mortality_rates$eel_qal_comment <- NA
  mortality_rates$eel_datasource <- datasource
  if (!all(colnames(mortality_rates)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(mortality_rates)[!colnames(mortality_rates)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))     
  
  
  if (nrow(mortality_rates)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_rates,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 17 to 25
    data_error= rbind(data_error, check_values(dataset=mortality_rates,
            column="eel_typ_name",
            country=country,
            values=c("SumA","SumF","SumH", "sumF_com", "SumF_rec", "SumH_hydro", "SumH_habitat", "SumH_stocking", "SumH_other"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_rates,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error= rbind(data_error, check_positive(dataset=mortality_rates,
            column="eel_value",
            country=country))
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=mortality_rates,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=mortality_rates,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_rates,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=mortality_rates,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_rates,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=mortality_rates,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=mortality_rates,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=mortality_rates,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=mortality_rates,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=mortality_rates,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=mortality_rates,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=mortality_rates,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
  }
  return(invisible(list(data=mortality_rates,error=data_error,the_metadata=the_metadata)))
}


############# MORTALITY SILVER EQUIVALENT BIOMASS #############################################

# path <- file.choose()
load_mortality_silver<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  #---------------------- METADATA sheet ---------------------------------------------
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- mortality_silver sheet ---------------------------------------------
  
  # read the mortality_silver sheet
  cat("mortality_silver \n")
  
  mortality_silver<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  country =as.character(mortality_silver[1,6]) #country code is in the 6th column
  
  # check for the file integrity, only 10 column in this file
  if (ncol(mortality_silver)!=10) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  mortality_silver$eel_qal_id <- NA
  mortality_silver$eel_qal_comment <- NA
  mortality_silver$eel_datasource <- datasource
  if (!all(colnames(mortality_silver)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(mortality_silver)[!colnames(mortality_silver)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))     
  if (nrow(mortality_silver)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_silver,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 17 to 25
    data_error= rbind(data_error, check_values(dataset=mortality_silver,
            column="eel_typ_name",
            country=country,
            values=c("SEE_com", "SEE_rec", "SEE_hydro", "SEE_habitat", "SEE_stocking", "SEE_other"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_silver,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error =rbind(data_error, check_positive(dataset = mortality_silver,
            column="eel_value",
            country=country))
    
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=mortality_silver,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=mortality_silver,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_silver,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=mortality_silver,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=mortality_silver,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=mortality_silver,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=mortality_silver,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=mortality_silver,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=mortality_silver,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=mortality_silver,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=mortality_silver,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=mortality_silver,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
  }
  return(invisible(list(data=mortality_silver,error=data_error,the_metadata=the_metadata)))
}


load_potential_available_habitat<-function(path,datasource){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  #---------------------- METADATA sheet ---------------------------------------------
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method"]] <- NA
  }
  # end loop for directories
  
  #---------------------- mortality_silver sheet ---------------------------------------------
  
  # read the mortality_silver sheet
  cat("potential_available_habitat \n")
  
  potential_available_habitat<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  country =as.character(potential_available_habitat[1,6]) #country code is in the 6th column
  
  # check for the file integrity, only 10 column in this file
  if (ncol(potential_available_habitat)!=10) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  potential_available_habitat$eel_qal_id <- NA
  potential_available_habitat$eel_qal_comment <- NA
  potential_available_habitat$eel_datasource <- datasource
  if (!all(colnames(potential_available_habitat)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(potential_available_habitat)[!colnames(potential_available_habitat)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n")) 
  
  if (nrow(potential_available_habitat)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=potential_available_habitat,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 16
    data_error= rbind(data_error, check_values(dataset=potential_available_habitat,
            column="eel_typ_name",
            country=country,
            values=c("Potential_availabe_habitat_production_ha"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=potential_available_habitat,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=potential_available_habitat,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=potential_available_habitat,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error =rbind(data_error, check_positive(dataset = potential_available_habitat,
            column="eel_value",
            country=country))
    
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=potential_available_habitat,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=potential_available_habitat,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=potential_available_habitat,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=potential_available_habitat,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=potential_available_habitat,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=potential_available_habitat,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=potential_available_habitat,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=potential_available_habitat,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=potential_available_habitat,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    
    
  }
  return(invisible(list(data=potential_available_habitat,error=data_error,the_metadata=the_metadata)))
}