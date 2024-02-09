
# files are copied to the saved folder before being changed, check there if you need a backup
update_referential_sheet <- function(con, name="Eel_Data_Call_2022_Annex4_Landings_Commercial"){
  nametemplatefile <- str_c(name,".xlsx")
  templatefile <- file.path(wddata,"00template",nametemplatefile)
  dir.create(str_c(wddata,"/00template/saved"),showWarnings = FALSE)
  file.copy(from= templatefile, file.path(wddata,"/00template/saved/",nametemplatefile))
  sheetnames <- openxlsx::getSheetNames(templatefile)
  ref_sheets <- sheetnames[grep("tr_", sheetnames)]
  wb = openxlsx::loadWorkbook(templatefile)
  fn_load_ref <- function(ref_table, con.=con){    
    #we avoid to load geom type ("USER DEFINED)

    current_tab = readxl::read_excel(templatefile,ref_table)
    columns=dbGetQuery(con.,paste0("SELECT  column_name,  data_type  FROM information_schema.columns
                WHERE data_type!='USER-DEFINED' and table_schema = 'ref' AND  table_name = '",ref_table,"' ;"))
  
    tab <- DBI::dbGetQuery(con.,  paste0("SELECT ",
            paste(columns$column_name,collapse=","),
            " FROM ref.",
            ref_table))
    cat("loaded",ref_table,"\n")
    if ("geom" %in% colnames(tab))   tab <- tab %>% select(starts_with("g")) %>% arrange(1)
    
    #we know sort table keeping the order of the raw files
    new_rows=which(!tab[,1] %in% (current_tab[,1] %>% pull()))
    tab <- bind_rows(tab[match(current_tab[,1] %>% pull(), tab[,1]),],
                     tab[new_rows,,drop=FALSE])
    
    openxlsx::writeData(wb, sheet = ref_table, tab)
  }
  list_ref <- mapply(fn_load_ref,ref_sheets)
  wb = openxlsx::saveWorkbook(wb, templatefile, overwrite=TRUE)
  cat("end of refer loading\n")
}

#update_referential_sheet(name="Eel_Data_Call_Annex4_Landings_Commercial")
# needs reformating anyways....
#update_referential_sheet(name="Eel_Data_Call_Annex_Time_Series")
