library(yaml)
library(dplyr)
library(RPostgres)
library(openxlsx)
library(glue)

wdpath="Misc/wklandeel/"

cred=read_yaml("credentials.yml")
con=dbConnect(Postgres(), dbname=cred$dbname, user=cred$user,port=cred$port,
              host=cred$host,password=cred$password)

cou_code=dbGetQuery(con,"select distinct eel_cou_code from datawg.t_eelstock_eel where eel_qal_id in (0,1,2,4) and eel_typ_id in (4,6)")

find_match <- function(data, year, lfs_code, total=TRUE){
  sapply(year, function(y){
    nrow(data %>% filter(!is.na(eel_value) & 
                           endsWith(eel_emu_nameshort, "total")==total &
                           eel_lfs_code %in% lfs_code &
                           eel_year == y)) > 0
  })
}



create_table = function(subdata, alldata, lfs_code, total=TRUE){
  data_lfs <- subdata %>%
    filter(eel_lfs_code==lfs_code) %>%
    right_join(expand.grid(eel_year=1980:2022, eel_lfs_code=lfs_code)) %>%
    arrange(eel_year) 
  
  aggregated_lfs=switch(lfs_code,
                        "G"="none",
                        "Y"="YS",
                        "S"="YS",
                        "YS"=c("Y","S"))
  
  if (total){
    data_lfs <- data_lfs %>%
      mutate(status=ifelse((find_match(alldata,eel_year,lfs_code,FALSE) | 
                              find_match(alldata,eel_year,aggregated_lfs,FALSE) |
                              find_match(alldata,eel_year,aggregated_lfs,TRUE)) & is.na(eel_value),
                           "data aggregated/disaggregated elsewhere (stage, country)",
                           ""),
             aggregated_elsewhere = ifelse((find_match(alldata,eel_year,lfs_code,FALSE) | 
                                              find_match(alldata,eel_year,aggregated_lfs,FALSE) |
                                              find_match(alldata,eel_year,aggregated_lfs,TRUE)) & is.na(eel_value),
                                           paste("by", ifelse(find_match(alldata,eel_year,lfs_code,FALSE) | 
                                                                find_match(alldata,eel_year,aggregated_lfs,FALSE),
                                                              "emu",""),
                                                 ifelse(find_match(alldata,eel_year,aggregated_lfs,FALSE) |
                                                          find_match(alldata,eel_year,aggregated_lfs,TRUE),
                                                        "stage","")),
                                           ""))
  } else {
    data_lfs <- data_lfs %>%
      mutate(status=ifelse((find_match(alldata,eel_year,lfs_code,TRUE) | 
                              find_match(alldata,eel_year,aggregated_lfs,TRUE) |
                              find_match(subdata,eel_year,aggregated_lfs,FALSE)) & is.na(eel_value),
                           "data aggregated/disaggregated elsewhere (stage, country)",
                           ""),
             aggregated_elsewhere = ifelse((find_match(alldata,eel_year,lfs_code,TRUE) | 
                                              find_match(alldata,eel_year,aggregated_lfs,TRUE) |
                                              find_match(subdata,eel_year,aggregated_lfs,FALSE)) & is.na(eel_value),
                                           paste("by", 
                                                 ifelse(find_match(alldata,eel_year,lfs_code,TRUE) | 
                                                          find_match(alldata,eel_year,aggregated_lfs,TRUE),
                                                        "country",""),
                                                 ifelse(find_match(alldata,eel_year,aggregated_lfs,TRUE) |
                                                          find_match(subdata,eel_year,aggregated_lfs,FALSE),
                                                        "stage",
                                                        "")),
                                           ""))
  }
  data_lfs %>%
    mutate(all_fishers_are_included=ifelse(aggregated_elsewhere!="","","TRUE"),
           no_significant_underreporting=ifelse(aggregated_elsewhere!="","","TRUE"),
           comments_missing_data=NA) %>%
    select(all_of(c("eel_year","eel_value","arising_from","status",
                    "aggregated_elsewhere","missing_data_habitat",
                    "all_fishers_are_included","no_significant_underreporting",
                    "comments_missing_data"))) %>%
    arrange(eel_year)
  
}


generate_table = function(typ_id=4, cou="FR"){
  print(paste("##########", cou))
  wb = loadWorkbook(paste0(wdpath,"template.xlsx"))
  data=dbGetQuery(con,glue_sql("select eel_value,
                               eel_year,
                               eel_hty_code,
                               eel_lfs_code,
                               eel_missvaluequal,
                               eel_emu_nameshort
                               from datawg.t_eelstock_eel where
                               eel_cou_code={cou} and eel_typ_id={typ_id}
                               and eel_qal_id in (0,1,2,4)", .con=con))
  
  emus=unique(data$eel_emu_nameshort)
  emus=sort(emus)
  emus=c(emus[grepl("total$", emus)],emus[!grepl("total$",emus)])
  
  for (e in emus){
    print(paste("#", e))
    cloneWorksheet(wb,e,"template")
    dataValidation(wb, e, cols = 7:8, rows = 3:10000, type = "list", value = "'list_values'!$B$2:$B3")
    dataValidation(wb, e, cols = 16:17, rows = 3:10000, type = "list", value = "'list_values'!$B$2:$B3")
    dataValidation(wb, e, cols = 25:26, rows = 3:10000, type = "list", value = "'list_values'!$B$2:$B3")
    dataValidation(wb, e, cols = 34:33, rows = 3:10000, type = "list", value = "'list_values'!$B$2:$B3")
    
    dataValidation(wb, e, cols = 4, rows = 3:10000, type = "list", value = "'list_values'!$A$2:$A$7")
    dataValidation(wb, e, cols = 13, rows = 3:10000, type = "list", value = "'list_values'!$A$2:$A$7")
    dataValidation(wb, e, cols = 22, rows = 3:10000, type = "list", value = "'list_values'!$A$2:$A$7")
    dataValidation(wb, e, cols = 31, rows = 3:10000, type = "list", value = "'list_values'!$A$2:$A$7")
    
    sum_na <- function(x){
      if (all(is.na(x))) return(NA)
      return(sum(x,na.rm=TRUE))
    }
    
    data_emu <- data %>%
      filter(eel_emu_nameshort==e) %>%
      group_by(eel_lfs_code,eel_year) %>%
      summarise(eel_value=sum_na(eel_value),
                arising_from=paste(sort(setdiff(unique(ifelse(!is.na(eel_missvaluequal),
                                                              "empty",
                                                              eel_hty_code)),
                                                "empty")),
                                   collapse=","),
                missing_data_habitat = paste(sort(setdiff(unique(ifelse(eel_missvaluequal %in% c("NR", "NC"),
                                                                        eel_hty_code,
                                                                        "empty")),
                                                          "empty")),
                                             collapse=",")) %>%
      ungroup()
    
    data_G <- create_table(data_emu, data, "G", endsWith(e, "total"))
    writeData(wb,e,data_G %>% mutate(across(everything(),~as.character(.x))),1,3,colNames=FALSE)
    data_Y <- create_table(data_emu, data, "Y", endsWith(e, "total"))
    writeData(wb,e,data_Y %>% mutate(across(everything(),~as.character(.x))),10,3,colNames=FALSE)
    data_S <- create_table(data_emu, data, "S", endsWith(e, "total"))
    writeData(wb,e,data_S %>% mutate(across(everything(),~as.character(.x))),19,3,colNames=FALSE)
    data_YS <- create_table(data_emu, data, "YS", endsWith(e, "total"))
    writeData(wb,e,data_YS %>% mutate(across(everything(),~as.character(.x))),28,3,colNames=FALSE)
    freezePane(
      wb,
      e,
      firstActiveRow = 3,
      firstActiveCol = 2)
    
    
    
  }
  order_sheet <- worksheetOrder(wb)
  worksheetOrder(wb) <- c(order_sheet[- (2:3)], 2:3)
  activeSheet(wb) <- worksheetOrder(wb)[1]
  saveWorkbook(wb,paste0(wdpath,cou,"_",ifelse(typ_id==4,"com","rec"),"_template.xlsx"),overwrite=TRUE)
}

library(dplyr, warn.conflicts = FALSE)
options(dplyr.summarise.inform = FALSE)
comb=expand.grid(eel_typ_id=c(4,6),cou=cou_code[,1])
mapply(generate_table, typ_id=comb$eel_typ_id,cou=comb$cou)
dbDisconnect(con)