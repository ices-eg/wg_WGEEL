# Name : compare_with_database.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################



#' @title compare with database
#' @description This function loads the data from the database and compare it with data
#' loaded from excel, the 
#' @param data_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @return A list with two dataset, one is duplicate the other new, they correspond 
#' to duplicates values that have to be checked by wgeel and when a new value
#' is selected the database data has to be removed and the new lines needs to be qualified.
#' THe other dataset (new) contains new value, these also will need to be qualified by wgeel
#' @details There are various checks to ensure there is no problem at this turn, the tr_type_typ reference dataset will be loaded if absent,
#' To extract duplicates, this function does a merge of excel and base values using inner join,
#' and adds a column keep_new_value where the user will have to select whether to replace conflicting 
#' values with the new (TRUE) or discard it and keep the old value (FALSE).
#' @examples 
#' \dontrun{
#' if(interactive()){
#' data_from_excel<-load_catch_landings(wg_file.choose())$data
#' data_from_base<-extract_data("Landings")
#' list_comp<-compare_with_database(data_from_excel,data_from_base)
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{filter}},\code{\link[dplyr]{select}},\code{\link[dplyr]{inner_join}},\code{\link[dplyr]{right_join}}
#' @rdname compare_with_database
#' @importFrom dplyr filter select inner_join right_join
compare_with_database<-function(data_from_excel, data_from_base){
  #tr_type_typ should have been loaded by global.R in the program in the shiny app
  if (!exists("tr_type_typ")) {
    extract_ref('Type of series')
  }
  # data integrity checks
  if(nrow(data_from_excel)==0) stop ("There are no data coming from the excel file")
  if (nrow(data_from_base)==0) stop ("No data in the file coming from the database") 
  current_cou_code<-unique(data_from_excel$eel_cou_code)
  if(length(current_cou_code)!=1) stop("There is more than one country code, this is wrong")
  current_typ_name<-unique(data_from_excel$eel_typ_name)
  if (!all(current_typ_name%in%tr_type_typ$typ_name)) stop ("There is a mismatch between typ_names and typ_id, merging back to id impossible, context compare_from_database")
  # extract subset suitable for merge
  tr_type_typ_for_merge<-tr_type_typ[,c("typ_id","typ_name")]
  colnames(tr_type_typ_for_merge)<-c("eel_typ_id","eel_typ_name")  
  data_from_excel<-merge(data_from_excel,tr_type_typ_for_merge,by="eel_typ_name")
  current_typ_id<-unique(data_from_excel$eel_typ_id)
  if (!all(current_typ_id%in%data_from_base$eel_typ_id)) stop(paste("There is a mismatch between selected typ_id",paste0(current_typ_id,collapse=";"),"and the dataset loaded from base", paste0(unique(data_from_base$eel_typ_id),collapse=";"),"did you select the right File type ?"))
  # Can't join on 'eel_area_division' x 'eel_area_division' because of incompatible types (character / logical)
  data_from_excel$eel_area_division<-as.character(data_from_excel$eel_area_division)
  
  eel_colnames<-colnames(data_from_base)[grepl("eel",colnames(data_from_base))]
  # duplicates are inner_join
  # eel_cou_code added to the join just to avoid duplication
  duplicates<-data_from_base%>%
      dplyr::filter(eel_typ_id%in%current_typ_id&eel_cou_code==current_cou_code)%>%
      dplyr::select(eel_colnames)%>%
      #dplyr::select(-eel_cou_code)%>%
      dplyr::inner_join(data_from_excel,by=c("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_cou_code","eel_hty_code", "eel_area_division"),
          suffix=c(".base", ".xls"))
  duplicates$keep_new_value<-vector("logical",nrow(duplicates))
  duplicates<-duplicates[,c(
          "eel_id",
          "eel_typ_id",
          "eel_typ_name",
          "eel_year",
          "eel_value.base",
          "eel_value.xls",
          "keep_new_value",
          "eel_qal_id.xls",
          "eel_qal_comment.xls",
          "eel_qal_id.base",          
          "eel_qal_comment.base",
          "eel_missvaluequal.base",
          "eel_missvaluequal.xls",
          "eel_emu_nameshort",
          "eel_cou_code",
          "eel_lfs_code",         
          "eel_hty_code",
          "eel_area_division",          
          eel_comment.base, 
          "eel_comment.xls",                        
          "eel_datasource.base", 
          "eel_datasource.xls")]
  new<-dplyr::anti_join(data_from_excel,
      data_from_base,
      by=c("eel_typ_id","eel_year", "eel_lfs_code","eel_emu_nameshort", "eel_hty_code", "eel_area_division","eel_cou_code"),
      suffix=c(".base", ".xls"))
  new<-new[,c(
          "eel_typ_id",
          "eel_typ_name",          
          "eel_year",
          "eel_value",
          "eel_missvaluequal",
          "eel_emu_nameshort",
          "eel_cou_code",
          "eel_lfs_code",
          "eel_hty_code",
          "eel_area_division",
          "eel_qal_id",
          "eel_qal_comment",            
          "eel_datasource",
          "eel_comment")] 
  return(list("duplicates"=duplicates,"new"=new))  
}


#' @title write duplicated results into the database
#' @description Values kept from the datacall will be inserted, old values from the database
#' will be qualified with a number corresponding to the wgeel datacall (e.g. eel_qal_id=5 for 2018).
#' Values not selected from the datacall will be also be inserted with eel_qal_id=5
#' @param path path to file (collected from shiny button)
#' @param qualify_code code to insert the data into the database, Default: 5
#' @return message indicating success or failure at data insertion
#' @details 
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  path<-wg_file.choose() 
#'  #path<-"C:\\Users\\cedric.briand\\Desktop\\06. Data\\datacall(wgeel_2018)\\duplicates_catch_landings_2018-07-08 (1).xlsx"
#'  # qualify_code is 18 for wgeel2018
#'  write_duplicates(path,qualify_code=18)
#' sqldf("delete from datawg.t_eelstock_eel where eel_qal_comment='dummy_for_test'")
#'  }
#' }
#' @rdname write_duplicate
write_duplicates<-function(path,qualify_code=18){
  duplicates2<-read_excel(
      path=path,
      sheet =1,
      skip=1)
  # the user might select a wrong file, or modify the file
  # the following check should ensure file integrity
  validate(
      need(ncol(duplicates2)==22, "number column wrong (should be 22) \n")
  )         
  validate(
      need(all(colnames(duplicates2)%in%
                  c(
                      "eel_id",
                      "eel_typ_id",
                      "eel_typ_name",
                      "eel_year",
                      "eel_value.base",
                      "eel_value.xls",
                      "keep_new_value",
                      "eel_qal_id.xls",
                      "eel_qal_comment.xls",
                      "eel_qal_id.base",          
                      "eel_qal_comment.base",
                      "eel_missvaluequal.base",
                      "eel_missvaluequal.xls",
                      "eel_emu_nameshort",
                      "eel_cou_code",
                      "eel_lfs_code",         
                      "eel_hty_code",
                      "eel_area_division",          
                      "eel_comment.base", 
                      "eel_comment.xls",                        
                      "eel_datasource.base", 
                      "eel_datasource.xls")),
          "Error in replicated dataset : column name changed")) 
  # select values to be replaced
  # passing through excel does not get keep_new_value with logical R value
  # here I'm testing various mispelling
  duplicates2$keep_new_value[duplicates2$keep_new_value=="1"]<-"true"
  duplicates2$keep_new_value[duplicates2$keep_new_value=="0"]<-"false"
  duplicates2$keep_new_value<-toupper(duplicates2$keep_new_value)
  duplicates2$keep_new_value[duplicates2$keep_new_value=="YES"]<-"true"
  duplicates2$keep_new_value[duplicates2$keep_new_value=="NO"]<-"false"
  if(!all(duplicates2$keep_new_value%in%c("TRUE","FALSE"))) stop ("value in keep_new_value should be false or true")
  duplicates2$keep_new_value<-as.logical(toupper(duplicates2$keep_new_value))
  #########################"
  # Duplicates values
  #########################

    replaced<-duplicates2[duplicates2$keep_new_value,]
    if (nrow(replaced)>0){
    validate(
        need(all(!is.na(replaced$eel_qal_id.xls)), "All values with true in keep_new_value column should have a value in eel_qal_id \n"))
    
    ###############
    # first deprecate old values in the database
    ################
    replaced$eel_comment.base[is.na(replaced$eel_comment.base)]<-""
    replaced$eel_comment.base<-paste0(replaced$eel_comment.base," Value ",replaced$eel_value.base," replaced by value ",replaced$eel_value.xls," for datacall ",format(Sys.time(), "%Y"))
    
    query <-
        paste0("update datawg.t_eelstock_eel set (eel_qal_id,eel_comment)=(",
            qualify_code,",'",replaced$eel_comment.base,"') where eel_id=",replaced$eel_id)
    sqldf(query)
    
      ################################################
      # second insert the new lines into the database
      ###############################################"
      replaced<-replaced[,c(          
                      "eel_typ_id",       
                      "eel_year",
                      "eel_value.xls",
                      "eel_missvaluequal.xls",
                      "eel_emu_nameshort",
                      "eel_cou_code",
                      "eel_lfs_code",
                      "eel_hty_code",
                      "eel_area_division",
                      "eel_qal_id.xls",
                      "eel_qal_comment.xls",            
                      "eel_datasource.xls",
                      "eel_comment.xls")]
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
                      eel_datasource,
                      eel_comment) 
                      select * from replaced")
  }
  ################################
  # Values not chosen, but we store them in the database
  ############################### 

      not_replaced<-duplicates2[duplicates2$keep_new_value,]
      if (nrow(not_replaced)>0){
      not_replaced$eel_comment.xls[is.na(not_replaced$eel_comment.xls)]<-""
      not_replaced$eel_comment.xls<-paste0(not_replaced$eel_comment.xls," Value ",not_replaced$eel_value.xls," not used, value from the database ",not_replaced$eel_value.base," kept instead for datacall ",format(Sys.time(), "%Y"))
      not_replaced$eel_qal_id<-qualify_code   
      not_replaced<-not_replaced[,c(          
              "eel_typ_id",       
              "eel_year",
              "eel_value.xls",
              "eel_missvaluequal.xls",
              "eel_emu_nameshort",
              "eel_cou_code",
              "eel_lfs_code",
              "eel_hty_code",
              "eel_area_division",
              "eel_qal_id.xls",
              "eel_qal_comment.xls",            
              "eel_datasource.xls",
              "eel_comment.xls")]      
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
              eel_datasource,
              eel_comment) 
              select * from not_replaced")

  }
  message<-sprintf("For duplicates %s values replaced in the database (old values kept with code eel_qal_id=%s), %s values not replaced (values from current datacall stored with code eel_qal_id %s)", nrow(replaced),qualify_code,nrow(not_replaced),qualify_code)
  return(message)
}

write_new<-function(path){
  
  # TODO 
  return(message)
}