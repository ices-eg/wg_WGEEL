setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/Misc/wklandeel/filled_templates/")
library(readxl)
library(dplyr)
library(tibble)
library(tidyr)
library(janitor)

commercial_files=list.files(".",pattern="_com_")
recreational_files=list.files(".",pattern="_rec_")

if(!file.exists("filled_templates.rdata")){
import_template=function(file){
  emus=setdiff(excel_sheets(file),c("README","template","list_values"))
  Reduce(bind_rows,lapply(emus, function(e){
    print(e)
    all=read_excel(file,sheet=e) 
    g=all[,1:9] %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code='G')
    y=all[,10:18] %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code='Y')
    s=all[,11:19]  %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code='S')
    ys=all[,20:28]  %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code="YS")
    bind_rows(g,y,s,ys) %>%
      rename(eel_value=amount) %>%
    mutate(eel_emu_nameshort=e,
           eel_typ_id=4) %>%
      mutate(eel_missvalue_equal=ifelse(startsWith(eel_value,"N"),
                                        eel_value,
                                        NA),
             eel_value=ifelse(startsWith(eel_value,"N"),
                              NA,
                              as.numeric(eel_value)))
  }))
  
}


commercial=Reduce(bind_rows,lapply(commercial_files, import_template))

recreational=Reduce(bind_rows,lapply(recreational_files, import_template))

save(commercial,recreational,file="filled_templates.rdata")

} else{
  load("filled_templates.rdata")
}
recreational <- recreational %>%
  mutate(eel_year=as.numeric(eel_year))
commercial <- commercial %>%
  mutate(eel_year=(as.numeric(eel_year)))
library(yaml)
library(RPostgres)
cred=read_yaml("../../../credentials.yml")
con=dbConnect(Postgres(), dbname=cred$dbname, user=cred$user,port=cred$port,
              host=cred$host,password=cred$password)

cou_code=dbGetQuery(con,"select distinct eel_cou_code from datawg.t_eelstock_eel where eel_qal_id in (0,1,2,4) and eel_typ_id in (4,6)")
sum_na <- function(x){
  if (all(is.na(x))) return(NA)
  return(sum(x,na.rm=TRUE))
}

find_match <- function(data, year, lfs_code, total=TRUE){
  sapply(year, function(y){
    nrow(data %>% filter(!is.na(eel_value) & 
                           endsWith(eel_emu_nameshort, "total")==total &
                           eel_lfs_code %in% lfs_code &
                           eel_year == y)) > 0
  })
}



library(glue)
getdbdata = function(typ_id=4, cou="FR"){
  print(paste("##########", cou))
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
  

    
    data %>%
      group_by(eel_lfs_code,eel_year,eel_emu_nameshort) %>%
      summarise(eel_value=sum_na(eel_value)) %>%
      ungroup()
    
    

}
library(dplyr, warn.conflicts = FALSE)
options(dplyr.summarise.inform = FALSE)
commercial_db=Reduce(bind_rows,lapply(cou_code[,1], getdbdata, typ_id=4))
recreational_db=Reduce(bind_rows,lapply(cou_code[,1], getdbdata, typ_id=6))


recreational=left_join(recreational_db,recreational,by=c("eel_year","eel_lfs_code","eel_emu_nameshort"),suffix=c(".db",""))
commercial=left_join(commercial_db,commercial,by=c("eel_year","eel_lfs_code","eel_emu_nameshort"),suffix=c(".db",""))

library(ggplot2)
commercial  %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) %>%
  filter(eel_lfs_code=="G" & status!="data aggregated/disaggregated elsewhere (stage, country)") %>%
  group_by(eel_year,status) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value))+geom_area(aes(fill=status)) +
  ggtitle("com G")

commercial  %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) %>%
  filter(eel_lfs_code=="Y" & status!="data aggregated/disaggregated elsewhere (stage, country)") %>%
  group_by(eel_year,status) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value))+geom_area(aes(fill=status)) +
  ggtitle("com Y")


commercial  %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) %>%
  filter(eel_lfs_code=="S" & status!="data aggregated/disaggregated elsewhere (stage, country)") %>%
  group_by(eel_year,status) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value))+geom_area(aes(fill=status)) +
  ggtitle("com S")


commercial  %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) %>%
  filter(eel_lfs_code=="YS" & status!="data aggregated/disaggregated elsewhere (stage, country)") %>%
  group_by(eel_year,status) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value))+geom_area(aes(fill=status)) +
  ggtitle("com YS")


recreational  %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) %>%
  filter(eel_lfs_code=="G" & status!="data aggregated/disaggregated elsewhere (stage, country)") %>%
  group_by(eel_year,status) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value))+geom_area(aes(fill=status)) +
  ggtitle("rec G")
