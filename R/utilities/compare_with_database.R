# Name : compare_with_database.R
# Date : 04/07/2018
# Author: cedric.briand
###############################################################################

#data_from_excel<-load_catch_landings("C:/Users/cedric.briand/Desktop/06. Data/datacall/France/Eel_Data_Call_Annex2_Catch_and_Landings.xlsx")
#data_from_base<-catch_landings
#compare_with_database(data_from_excel,data_from_base)
compare_with_database<-function(data_from_excel, data_from_base){
  # data integrity checks
  if(nrow(data_from_excel)==0) stop ("There are no data coming from the excel file")
  if (nrow(data_from_base)==0) stop ("No data in the file coming from the database") 
  current_cou_code<-unique(data_from_excel$eel_cou_code)
  stopifnot(length(cou_code)==1)
  current_typ_id<-unique(data_from_excel$eel_typ_id)
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
      dplyr::inner_join(data_from_excel,by=c("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_typ_id", "eel_hty_code", "eel_area_division","eel_cou_code"),
          suffix=c(".base", ".xls"))
  duplicates$keep_new_value<-vector("logical",nrow(duplicates))
  duplicates<-duplicates[,c(3,13,20,1,2,5,6,7,8,4,9:12,14:19)]
  new<-data_from_base%>%
      dplyr::filter(eel_typ_id%in%current_typ_id&eel_cou_code==current_cou_code)%>%
      dplyr::select("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_typ_id", "eel_hty_code", "eel_area_division","eel_cou_code")%>%
      dplyr::right_join(data_from_excel,by=c("eel_typ_id","eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_typ_id", "eel_hty_code", "eel_area_division","eel_cou_code"),
          suffix=c(".base", ".xls"))
  # todo extract new 
  return(list("dupicates"=duplicates,"new"=new))  
}
