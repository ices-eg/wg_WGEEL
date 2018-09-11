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
  data_xls<-read_excel(
      path=path,
      sheet =3,
      skip=0)
  country=as.character(data_xls[1,6])
  data_xls <- correct_me(data_xls)
# check for the file integrity
  if (ncol(data_xls)!=13) cat(str_c("number column wrong, should have been 13 in file from ",country,"\n"))
  data_xls$eel_datasource <- datasource
# check column names
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= "&"),
            "file =",
            file,"\n")) 
  
  if (nrow(data_xls)>0) {
    
    ###### eel_typ_name ##############
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
#  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("com_landings_kg", "rec_landings_kg","other_landings_kg", "other_landings_n")))
    
    ###### eel_year ##############
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
# should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
# can have missing values if eel_missingvaluequa is filled (check later)
    
# should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
#check that there are data in missvaluequa only when there are missing value (NA) is eel_value
# and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            values=emus$emu_nameshort))
    
    ###### eel_cou_code ##############
    
# must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
# must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    
# should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","S","YS","GY","Y","AL")))
    
    ###### eel_hty_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    
# should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO","AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_area_division",
            country=country,
            type="character"))
    
# should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_area_division",
            country=country))
    
# the dataset ices_division should have been loaded there
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###### eel_qal_id ############## 
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_qal_id",
            country=country))
    
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_qal_id",
            country=country,
            values=c(0,1,2,3)))
    
    ###### eel_datasource ############## 
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_datasource",
            country=country))
    
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_datasource",
            country=country,
            values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018")))
    
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    )
    
  }
  return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata))) 
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
  data_xls<-read_excel(
      path=path,
      sheet =3,
      skip=0)
  country=as.character(data_xls[1,7])
  data_xls <- correct_me(data_xls)
  # check for the file integrity
  if (ncol(data_xls)!=11) cat(str_c("number of column wrong should have been 11 in the file for ",country,"\n"))
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  # check column names
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name","eel_year","eel_value_number", "eel_value_kg","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value_number", "eel_value_kg","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n")) 
  
  if (nrow(data_xls)>0) {
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be one of q_data__n, gee_n
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("release_n", "gee_n")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value_number ##############
    
    # can have missing values if eel_missingvaluequal is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value_number",
            country=country,
            type="numeric"))
    
    ###### eel_value_kg ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value_kg",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
    # check if there is data in eel_value_number and eel_value_kg
    # if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
    # if there is data in neither eel_value_number and eel_value_kg, check if there are data in missvaluequa 
    
    data_error= rbind(data_error, check_missvalue_release(dataset=data_xls,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","QG","OG","YS","S","AL")))
    
    ###### eel_hty_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO","AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_area_division",
            country=country,
            type="character"))
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_area_division",
            country=country))
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###  deal with eel_value_number and eel_value_kg to import to database
    
    #tibbles are weird, change to dataframe and clear NA in the first column
    data_xls <- as.data.frame(data_xls[!is.na(data_xls[,1]),])
    
    #separate data between number and kg 
    #create data for number and add eel_typ_id 9 
    release_N <- data_xls[,-4] 
    
    #release_N$eel_typ_id <- NA
    # deal with release_n or gee_n to assign the correct type id 
    for (i in 1:nrow(release_N)) { 
      if (release_N[i,1]=="release_n") { 
        #release_N[i,"eel_typ_id"] <- 9
        release_N[i,1] <- "q_release_n"
      } else { # gee
        #release_N[i,"eel_typ_id"]  <- 10
      }
    } 
    colnames(release_N)[colnames(release_N)=="eel_value_number"] <- "eel_value" 
    
    #create release for kg and add eel_typ_id 8 
    release_kg <- data_xls[,-3] 
    #release_kg$eel_typ_id <- rep(8, nrow(data_xls)) 
    release_kg$eel_typ_name <- "q_release_kg"
    colnames(release_kg)[colnames(release_kg)=="eel_value_kg"] <- "eel_value" 
    
    #Rbind data_xls in the same data frame to import in database 
    release_tot <- rbind(release_N, release_kg) 
    release_tot<-release_tot[,c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")
    ] 
    
#    #Add "ND" in eel_missvaluequal if one value is still missing 
#    for (i in 1:nrow(release_tot)) { 
#      if (is.na(release_tot[i,"eel_value"])) { 
#        release_tot[i,"eel_missvaluequal"] <- "ND" 
#      } 
#    } 
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
                    dataset=data_xls,
                    country=country) 
    )
    
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
  
  data_xls<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  data_xls <- correct_me(data_xls)
  country =as.character(data_xls[1,6])
  # check for the file integrity
  if (ncol(data_xls)!=10) cat(str_c("number column wrong ",file,"\n"))
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  # check column names
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))   
  if (nrow(data_xls)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error = rbind(data_error,  check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be q_aqua_kg
    data_error = rbind(data_error,  check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("q_aqua_kg")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequa ##############
    
    #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    
    
    ###### eel_emu_name ##############
    data_error = rbind(data_error,   check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error,  check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error,  check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,  check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    ) 
  }
  return(invisible(list(data=data_xls,error=data_error)))
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
  
  data_xls<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  # correcting an error with typ_name
  data_xls <- correct_me(data_xls)  
  country =as.character(data_xls[1,6]) #country code is in the 6th column
  
  # check for the file integrity, only 11 column in this file
  if (ncol(data_xls)!=10) cat(str_c("number column wrong should have been 10 in template for country",country,"\n"))
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  # check column names
#FIXME there is a problem with name in data_xls, here we have to use typ_name
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file = ",file,"\n")) 
  
  if (nrow(data_xls)>0){
    
    
    ###### typ_name #############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be one of 13 B0_kg  14 Bbest_kg  15 Bcurrent_kg
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("Bcurrent_kg","Bbest_kg","B0_kg")))
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequal is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=data_xls,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    )
    
  }
  return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
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
  
  data_xls<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  data_xls <- correct_me(data_xls)
  country =as.character(data_xls[1,6]) #country code is in the 6th column
  # check for the file integrity, only 10 column in this file
  if (ncol(data_xls)!=10) cat(str_c("number column wrong, should have been 10 in template, country ",country,"\n"))
  # check column names
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))     
  
  
  if (nrow(data_xls)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 17 to 25
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("SumA","SumF","SumH", "sumF_com", "SumF_rec", "SumH_hydro", "SumH_habitat", "SumH_stocking", "SumH_other", "SumH_release"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error= rbind(data_error, check_positive(dataset=data_xls,
            column="eel_value",
            country=country))
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=data_xls,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_area_division",
            country=country,
            values=ices_division))
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    )
    
  }
  return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
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
  
  data_xls<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  country =as.character(data_xls[1,6]) #country code is in the 6th column
  data_xls <- correct_me(data_xls)
  # check for the file integrity, only 10 column in this file
  if (ncol(data_xls)!=10) cat(str_c("number column wrong, should have been 10 in file for country ",country,"\n"))
  # check column names
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n"))     
  if (nrow(data_xls)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 17 to 25
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("SEE_com", "SEE_rec", "SEE_hydro", "SEE_habitat", "SEE_stocking", "SEE_other"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error =rbind(data_error, check_positive(dataset = data_xls,
            column="eel_value",
            country=country))
    
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_lfs_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_lfs_code",
            country=country,
            values=c("G","GY","Y","YS","S","OG","QG","AL")))
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    
    ###### eel_area_div ##############
    
    data_error= rbind(data_error,check_type(dataset=data_xls,
            column="eel_area_division",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_area_division",
            country=country))
    
    # the dataset ices_division should have been loaded there
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_area_division",
            country=country,
            values=ices_division))
    
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    )
    
  }
  return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
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
  
  #---------------------- hab_wet_Area sheet ---------------------------------------------
  
  # read the mortality_silver sheet
  cat("Potential available habitat \n")
  
  data_xls<-read_excel(
      path=path,
      sheet=3,
      skip=0)
  country =as.character(data_xls[1,6]) #country code is in the 6th column
  data_xls <- correct_me(data_xls)
  # check for the file integrity, only 10 column in this file
  if (ncol(data_xls)!=10) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  data_xls$eel_qal_id <- NA
  data_xls$eel_qal_comment <- NA
  data_xls$eel_datasource <- datasource
  
  if (!all(colnames(data_xls)%in%
          c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
              "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
              "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
    cat(str_c("problem in column names :",            
            paste(colnames(data_xls)[!colnames(data_xls)%in%
                        c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                            "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                            "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
            " file =",
            file,"\n")) 
  
  if (nrow(data_xls)>0){
    
    ###### eel_typ_name ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_typ_name",
            country=country))
    
    #  eel_typ_id should be 16
    data_error= rbind(data_error, check_values(dataset=data_xls,
            column="eel_typ_name",
            country=country,
            values=c("Potential_availabe_habitat_production_ha"))) 
    
    ###### eel_year ##############
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_year",
            country=country))
    
    # should be a numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_year",
            country=country,
            type="numeric"))
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_value",
            country=country,
            type="numeric"))
    
    data_error =rbind(data_error, check_positive(dataset = data_xls,
            column="eel_value",
            country=country))
    
    
    ###### eel_missvaluequal ##############
    
    #check that there are data in missvaluequal only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
            country=country))
    
    ###### eel_emu_name ##############
    
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country))
    
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_emu_nameshort",
            country=country,
            type="character"))
    
    ###### eel_cou_code ##############
    
    # must be a character
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_cou_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error, check_missing(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    # must only have one value
    data_error= rbind(data_error, check_unique(dataset=data_xls,
            column="eel_cou_code",
            country=country))
    
    ###### eel_lfs_code ##############
    
    
    
    ###### eel_hty_code ##############
    data_error= rbind(data_error, check_type(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            type="character"))
    
    # should not have any missing value
    data_error= rbind(data_error,check_missing(dataset=data_xls,
            column="eel_hty_code",
            country=country))
    
    # should only correspond to the following list
    data_error= rbind(data_error,check_values(dataset=data_xls,
            column="eel_hty_code",
            country=country,
            values=c("F","T","C","MO", "AL")))
    

    
    ###### freshwater shouldn't have area ########################
    
    data_error= rbind(data_error, check_freshwater_without_area(
            dataset=data_xls,
            country=country) 
    )
    
  }
  return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
}
############################
# function called to correct data call errors 2018
###########################
correct_me <- function(data){
  if ("eel_value_number"%in%colnames(data)){
    # release file, different structure, do nothing
  } else {
    colnames(data)[3] <-"eel_value"
    colnames(data)[4] <-"eel_missvaluequal"
    # correcting an error with typ_name
  }
  if ("typ_name"%in% colnames(data))
    data<-data%>%rename(eel_typ_name=typ_name)
  data[,1]<-tolower(data[,1]) #excel is stupid: he is not able to distinguish lower and upper case
  return(data)
}