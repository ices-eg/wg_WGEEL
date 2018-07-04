# Name : loading_functions.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################



############# CATCH AND LANDINGS #############################################

#---------------------- METADATA sheet ---------------------------------------------
# path<-file.choose()
load_catch_landings<-function(path){
  the_metadata<-list()
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
                      file," in ",
                      country,"\n")) 
  colnames(catch_landings)[4]<-"eel_missvaluequal" # there is a problem in catch and landings sheet
  if (nrow(catch_landings)>0) {
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
  }
  return(catch_landings) 
}


############# RESTOCKING #############################################

#---------------------- METADATA sheet ---------------------------------------------

# path<-file.choose()
load_restocking<-function(path){
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
## It is no necessary for database
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4)
# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method_restocking"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method_restocking"]] <- NA
	}
# end loop for directories
	
	#---------------------- restocking sheet ---------------------------------------------
	
	cat("restocking \n")
# here we have already seached for catch and landings above.
	restocking<-read_excel(
			path=path,
			sheet =3,
			skip=0)
	country=as.character(restocking[1,6])
	
	# check for the file integrity
	if (ncol(restocking)!=13) cat(str_c("number column wrong ",file,"\n"))
	# check column names
	if (all.equal(colnames(restocking),
			c("eel_typ_id","eel_year","eel_value_number", "eel_value_kg","eel_missvaluequal","eel_emu_nameshort",
					"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
					"eel_qal_id", "eel_qal_comment","eel_comment"))!=TRUE) 
		cat(str_c("problem in column names",
						file," in ",
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
		
		###### eel_value_number ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		check_type(dataset=restocking,
				column="eel_value_number",
				country=country,
				type="numeric")
		
		###### eel_value_kg ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		check_type(dataset=restocking,
		           column="eel_value_kg",
		           country=country,
		           type="numeric")
		
		###### eel_missvaluequa ##############
		
		# check if there is data in eel_value_number and eel_value_kg
		# if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
		# if there is data in neither eel_value_number and eel_value_kg, check if there are data in missvaluequa 
	
		check_missvalue_restocking(dataset=restocking,
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
		 
		}
		return(restocking)
}


############# AQUACULTURE PRODUCTION #############################################

#---------------------- METADATA sheet ---------------------------------------------
# path <- file.choose()

load_aquaculture<-function(path){
  data_error <- data.frame(nline = NULL, error_message = NULL)
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method_aquaculture"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method_aquaculture"]] <- NA
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
  if (ncol(aquaculture)!=13) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  if (all.equal(colnames(aquaculture),
                c("eel_typ_id","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
                  "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                  "eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))!=TRUE) 
    cat(str_c("problem in column names",
              file," in ",
              country,"\n")) 
  
  if (nrow(aquaculture)>0){
    ###### eel_typ_id ##############
    
    # should not have any missing value
    check_missing(dataset=aquaculture,
                  column="eel_typ_id",
                  country=country)
    
    data_error = rbind(data_error,  check_missing(dataset=aquaculture,
                                     column="eel_typ_id",
                                     country=country))
    #  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
    check_values(dataset=aquaculture,
                 column="eel_typ_id",
                 country=country,
                 values=c(11,13))
    
    data_error = rbind(data_error,  check_values(dataset=aquaculture,
                                                 column="eel_typ_id",
                                                 country=country,
                                                 values=c(11,12)))
    
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
    
    rbind(data_error,   check_missing(dataset=aquaculture,
                  column="eel_emu_nameshort",
                  country=country))

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
  }
  return(invisible(list(data=aquaculture,error=data_error)))
}


############# BIOMASS INDICATORS #############################################

#---------------------- METADATA sheet ---------------------------------------------
# path <- file.choose()

load_biomass<-function(path){
  the_metadata<-list()
  dir<-dirname(path)
  file<-basename(path)
  mylocalfilename<-gsub(".xlsx","",file)
  
  # read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , skip=4) 
  # check if no rows have been added
  if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
  # if there is no value in the cells then the tibble will only have one column
  # store the content of metadata in a list
  if (ncol(metadata)>1){   
    the_metadata[["contact"]] <- as.character(metadata[1,2])
    the_metadata[["contactemail"]] <- as.character(metadata[2,2])
    the_metadata[["method_biomass"]] <- as.character(metadata[3,2])
  } else {
    the_metadata[["contact"]] <- NA
    the_metadata[["contactemail"]] <- NA
    the_metadata[["method_biomass"]] <- NA
  }
  # end loop for directories
  
  #---------------------- biomass_indicators sheet ---------------------------------------------
  
  # read the biomass_indicators sheet
  cat("biomass_indicators \n")
  
  biomass_indicators<-read_excel(
    path=path,
    sheet=3,
    skip=0)
  country =as.character(biomass_indicators[1,7]) #country code is in the 7th column
  
  # check for the file integrity, only 11 column in this file
  if (ncol(biomass_indicators)!=11) cat(str_c("number column wrong ",file,"\n"))
  # check column names
  if (all.equal(colnames(biomass_indicators),
                c("eel_typ_id","typ_name", "eel_year","eel_value","eel_missvaluequa","eel_emu_nameshort",
                  "eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
                  "eel_comment"))!=TRUE) 
    cat(str_c("problem in column names",
              file," in ",
              country,"\n")) 
  colnames(biomass_indicators)[5]<-"eel_missvaluequal" # there is a problem in biomass_indicators sheet
  if (nrow(biomass_indicators)>0){
    
    ###### eel_typ_id ##############
    
    # should not have any missing value
    check_missing(dataset=biomass_indicators,
                  column="eel_typ_id",
                  country=country)
    #  eel_typ_id should be one of 13 B0_kg  14 Bbest_kg  15 Bcurrent_kg
    check_values(dataset=biomass_indicators,
                 column="eel_typ_id",
                 country=country,
                 values=c(13,14,15))
    
    ###### typ_name #############
    
    # should not have any missing value
    check_missing(dataset=biomass_indicators,
                  column="typ_name",
                  country=country)
    
    
    ###### eel_year ##############
    
    # should not have any missing value
    check_missing(dataset=biomass_indicators,
                  column="eel_year",
                  country=country)
    # should be a numeric
    check_type(dataset=biomass_indicators,
               column="eel_year",
               country=country,
               type="numeric")
    
    ###### eel_value ##############
    
    # can have missing values if eel_missingvaluequa is filled (check later)
    
    # should be numeric
    check_type(dataset=biomass_indicators,
               column="eel_value",
               country=country,
               type="numeric")
    
    ###### eel_missvaluequa ##############
    
    #check that there are data in missvaluequa only when there are missing value (NA) is eel_value
    # and also that no missing values are provided without a comment is eel_missvaluequa
    check_missvaluequa(dataset=biomass_indicators,
                       country=country)
    
    ###### eel_emu_name ##############
    
    check_missing(dataset=biomass_indicators,
                  column="eel_emu_nameshort",
                  country=country)
    
    check_type(dataset=biomass_indicators,
               column="eel_emu_nameshort",
               country=country,
               type="character")
    
    ###### eel_cou_code ##############
    
    # must be a character
    check_type(dataset=biomass_indicators,
               column="eel_cou_code",
               country=country,
               type="character")
    # should not have any missing value
    check_missing(dataset=biomass_indicators,
                  column="eel_cou_code",
                  country=country)
    # must only have one value
    check_unique(dataset=biomass_indicators,
                 column="eel_cou_code",
                 country=country)
    
    ###### eel_lfs_code ##############
    
    check_type(dataset=biomass_indicators,
               column="eel_lfs_code",
               country=country,
               type="character")
    # should not have any missing value
    check_missing(dataset=biomass_indicators,
                  column="eel_lfs_code",
                  country=country)
    # should only correspond to the following list
    check_values(dataset=biomass_indicators,
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
  }
  return(aquaculture)
}
