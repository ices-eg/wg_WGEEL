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
#'  toto<-load_catch_landings(Eel_Data_Call_Annex2_Catch_and_Landings.xlsx")
#'data_from_excel<-toto$data
#'data_from_base<-extract_data("Catches and landings")
#'list_comp<-compare_with_database(data_from_excel,data_from_base)
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
  # duplicates are inner_join
  eel_colnames<-colnames(data_from_base)[grepl("eel",colnames(data_from_base))]
  # eel_cou_code added to the join just to avoid duplication
  # other necessary in the merge but check what to do with area_division
  duplicates<-data_from_base%>%
      dplyr::filter(eel_typ_id%in%current_typ_id&eel_cou_code==current_cou_code)%>%
      dplyr::select(eel_colnames)%>%
      #dplyr::select(-eel_cou_code)%>%
      dplyr::inner_join(data_from_excel,by=c("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_cou_code","eel_hty_code", "eel_area_division"),
          suffix=c(".base", ".xls"))
  duplicates$keep_new_value<-vector("logical",nrow(duplicates))
  duplicates<-duplicates[,c(
          "eel_typ_id",
          "eel_typ_name",
          "eel_year",
          "eel_value.base",
          "eel_value.xls",
          "keep_new_value",
          "eel_missvaluequal.base",
          "eel_missvaluequal.xls",
          "eel_emu_nameshort",
          "eel_cou_code",
          "eel_lfs_code",         
          "eel_hty_code",
          "eel_area_division",
          "eel_qal_id.base",
          "eel_qal_id.xls",
          "eel_qal_comment.base",
          "eel_qal_comment.xls",
          "eel_comment.base", 
          "eel_comment.xls",                        
          "eel_datasource.base", 
          "eel_datasource.xls")]
  new<-data_from_base%>%
      dplyr::filter(eel_typ_id%in%current_typ_id&eel_cou_code==current_cou_code)%>%
      dplyr::select("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort","eel_cou_code", "eel_hty_code", "eel_area_division")%>%
      dplyr::right_join(data_from_excel,by=c("eel_typ_id","eel_year", "eel_lfs_code","eel_emu_nameshort", "eel_hty_code", "eel_area_division","eel_cou_code"),
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
          "eel_datasource")] 
  return(list("dupicates"=duplicates,"new"=new))  
}
