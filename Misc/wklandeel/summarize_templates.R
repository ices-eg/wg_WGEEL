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
    
    # if (all(is.na(g$amount)) & all(is.na(g$status)) & all(as.logical(g$all_fishers_are_included)) & all(as.logical(g$no_significant_underreporting)))
    #   g$status = "complete (all fishers, no underreporting)"
    y=all[,10:18] %>% 
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code='Y')
    # if (all(is.na(y$amount)) & all(is.na(y$status)) & all(as.logical(y$all_fishers_are_included)) & all(as.logical(y$no_significant_underreporting)))
    #   y$status = "complete (all fishers, no underreporting)"
    s=all[,19:27]  %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code='S')
    # if (all(is.na(s$amount)) & all(is.na(s$status)) & all(as.logical(s$all_fishers_are_included)) & all(as.logical(s$no_significant_underreporting)))
    #   s$status = "complete (all fishers, no underreporting)"
    ys=all[,28:36]  %>%
      row_to_names(1, remove_rows_above = TRUE) %>%
      mutate(eel_lfs_code="YS")
    # if (all(is.na(ys$amount)) & all(is.na(ys$status)) & all(as.logical(ys$all_fishers_are_included)) & all(as.logical(ys$no_significant_underreporting)))
    #   ys$status = "complete (all fishers, no underreporting)"
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
      summarise(eel_value=sum_na(eel_value),
                all_NP=all(eel_missvaluequal=="NP")) %>%
      ungroup()
    
    

}
library(dplyr, warn.conflicts = FALSE)
options(dplyr.summarise.inform = FALSE)
commercial_db=Reduce(bind_rows,lapply(cou_code[,1], getdbdata, typ_id=4))
recreational_db=Reduce(bind_rows,lapply(cou_code[,1], getdbdata, typ_id=6))


recreational=left_join(recreational_db,recreational,by=c("eel_year","eel_lfs_code","eel_emu_nameshort"),suffix=c(".db","")) %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) 
commercial=left_join(commercial_db,commercial,by=c("eel_year","eel_lfs_code","eel_emu_nameshort"),suffix=c(".db","")) %>%
  mutate(status=ifelse(is.na(status),"unknown",status)) 

library(ggplot2)


scale=c("complete (all fishers, no underreporting)"="green4",
        "partial but minor part missing"="palegreen",
        "partial and significant part missing"="yellow",
        "unknown"="grey",
        "missing and data does not exist"="red3",
        "missing but data might exist"="red")



commercial %>%
  filter(status!="data aggregated/disaggregated elsewhere (stage, country)" & !eel_lfs_code=="AL") %>%
  group_by(eel_year,status,eel_lfs_code) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value/1000))+geom_area(aes(fill=status)) +
  scale_fill_manual("",values=scale)+
  ylab("landings (t)") + xlab("")+
  theme_bw() + facet_wrap(~eel_lfs_code, scales="free_y") +
  ggtitle("commerical landings") +
  xlim(1980,2024)


recreational  %>%
  filter(status!="data aggregated/disaggregated elsewhere (stage, country)" & eel_lfs_code!="AL") %>%
  group_by(eel_year,status,eel_lfs_code) %>%
  summarise(eel_value=sum_na(eel_value.db)) %>%
  mutate(status=factor(status,levels=c("complete (all fishers, no underreporting)",
                                       "partial but minor part missing",
                                       "partial and significant part missing",
                                       "unknown",
                                       "missing and data does not exist",
                                       "missing but data might exist"))) %>%
  ggplot(aes(x=eel_year,y=eel_value/1000))+geom_area(aes(fill=status)) +
  scale_fill_manual("",values=scale)+
  ylab("landings (t)") + xlab("")+
  theme_bw()+ facet_wrap(~eel_lfs_code, scales="free_y") +
  ggtitle("recreational landings") +
  xlim(1980,2024)







commercial %>%
  group_by(eel_emu_nameshort,eel_lfs_code) %>%
  filter(status %in% c("complete (all fishers, no underreporting)",
                       "partial but minor part missing")) %>%
  summarize(first_year=min(eel_year),
            last_year=max(eel_year),
            nb_year=n(),
            missing=max(eel_year)-min(eel_year)+1-n()) %>%
  ungroup() %>%
  arrange(eel_lfs_code,eel_emu_nameshort) %>%
  write.table("commercial.csv",col.names=TRUE,row.names=FALSE) +
  xlim(1980,2024)




recreational %>%
  group_by(eel_emu_nameshort,eel_lfs_code) %>%
  filter(status %in% c("complete (all fishers, no underreporting)",
                       "partial but minor part missing")) %>%
  summarize(first_year=min(eel_year),
            last_year=max(eel_year),
            nb_year=n(),
            missing=max(eel_year)-min(eel_year)+1-n()) %>%
  ungroup()%>%
  arrange(eel_lfs_code,eel_emu_nameshort) %>%
  write.table("recreational.csv",col.names=TRUE,row.names=FALSE) +
  xlim(1980,2024)




commercial %>%
  group_by(eel_emu_nameshort,eel_lfs_code) %>%
  filter((!status %in% c("complete (all fishers, no underreporting)",
                         "partial but minor part missing","unknown")) &
           (!startsWith(status,"data aggregated"))) %>%
  summarize(first_year=min(eel_year),
            last_year=max(eel_year),
            nb_year=n()) %>%
  ungroup() %>%
  arrange(eel_lfs_code,eel_emu_nameshort) %>%
  write.table("commercial_bad.csv",col.names=TRUE,row.names=FALSE) +
  xlim(1980,2024)



recreational %>%
  group_by(eel_emu_nameshort,eel_lfs_code) %>%
  filter((!status %in% c("complete (all fishers, no underreporting)",
                       "partial but minor part missing","unknown")) &
           (!startsWith(status,"data aggregated"))) %>%
  summarize(first_year=min(eel_year),
            last_year=max(eel_year),
            nb_year=n()) %>%
  ungroup() %>%
  arrange(eel_lfs_code,eel_emu_nameshort) %>%
  write.table("recreational_bad.csv",col.names=TRUE,row.names=FALSE)



library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
world <- ne_countries(continent=c("Europe","Africa"),scale=50)

sf_use_s2(FALSE)
emu=st_read(con,query="select emu_nameshort,geom from ref.tr_emu_emu tee where emu_nameshort not like '_o$' and deprec=FALSE")
answered=st_centroid(emu %>%
  filter(emu_nameshort %in% unique(commercial$eel_emu_nameshort[commercial$status!="unknown"]))) %>%
  mutate(x=st_coordinates(.)[,1],
         y=st_coordinates(.)[,2]) %>%
  st_drop_geometry()
ggplot(emu) + 
  geom_sf(data=world,fill="grey")+
  geom_sf(aes(fill=ifelse(emu_nameshort %in% unique(commercial$eel_emu_nameshort[commercial$status!="unknown"]),"1",
              ifelse(startsWith(emu_nameshort,"GB") | startsWith(emu_nameshort,"LT"),"2","0"))), show.legend=FALSE) +
  scale_fill_viridis_d() + 
  theme_bw() +
  ggrepel::geom_text_repel(data=answered,aes(label=emu_nameshort,x=x,y=y),cex=2) +
  xlim(-15,30)+ylim(30,72)+
  xlab("")+ylab("")
dbDisconnect(con)


commercial %>% 
     filter(is.na(eel_value.db)& is.na(`aggregated/dissagregated where`) & all_NP & (startsWith(status,"partial") | startsWith(status,"missing"))) %>% write.table("errors.csv",row.names=FALSE,col.names=TRUE,sep=";")
