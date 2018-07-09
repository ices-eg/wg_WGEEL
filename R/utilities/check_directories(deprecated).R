# Name : check_directories(deprecated).R
# Date : Date
# Author: cedric.briand
###############################################################################


############### begin function###################
# sinew::makeOxygen(check_directories) 
#' THIS FUNCTION IS DEPRECATED
#' @title function to check the datacall files in directories used for wgeel2017
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
    # TODO: treat OG_ replace with OG 
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
  } # end check_one_directory
  
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

