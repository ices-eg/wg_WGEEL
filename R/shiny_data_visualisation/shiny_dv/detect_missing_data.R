creating_missing_file_dc <- function(cou="FR",minyear=2000,maxyear=2019,host="localhost",dbname="wgeel",user="wgeel",port=5432) {
  load_library("getPass")
  load_library("RPostgreSQL")
  load_library("dplyr")
  load_library("sqldf")
  load_library("xlsx")
  
  con_wgeel<-dbConnect(PostgreSQL(),host=host,dbname=dbname,user=user,port=port,password=getPass())
  hty_emus<-unique(dbGetQuery(con_wgeel,paste("select eel_hty_code,eel_emu_nameshort,eel_cou_code,eel_area_division from datawg.t_eelstock_eel where eel_typ_id=16 and eel_cou_code in ('",paste(cou,collapse="','",sep=""),"')",sep="")))
  
  all_comb <- merge(expand.grid(eel_lfs_code=c("G","Y","S"),
                          eel_year=minyear:maxyear,
                          eel_typ_id=4),
                    hty_emus)
  complete<-dbGetQuery(con_wgeel,paste(paste("select eel_typ_id,eel_hty_code,eel_year,eel_emu_nameshort,eel_lfs_code,eel_cou_code from datawg.t_eelstock_eel where eel_year>=",minyear," and eel_year<=",maxyear," and eel_typ_id=4 and eel_cou_code='",cou,"'",sep="")))
  missing_comb <- anti_join(all_comb, complete)
  missing_comb$id <- 1:nrow(missing_comb)
  found_matches <- sqldf("select id,c.eel_emu_nameshort from missing_comb m inner join complete c on c.eel_cou_code=m.eel_cou_code and
                                                            c.eel_year=m.eel_year and
                                                            c.eel_typ_id=m.eel_typ_id and
                                                            c.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and c.eel_hty_code like '%'||m.eel_hty_code||'%' 
                                                            and (c.eel_emu_nameshort=m.eel_emu_nameshort or
                                                                c.eel_emu_nameshort=substr(m.eel_emu_nameshort,1,3)||'total')",drv = "SQLite")
  #looks for missing combinations
  missing_comb <- missing_comb %>%
    filter(!missing_comb$id %in% found_matches$id)%>%
    select(-id) %>%
    arrange(eel_cou_code,eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code,eel_year)
  
  missing_comb$eel_hty_code=as.character(missing_comb$eel_hty_code)
  missing_comb$eel_lfs_code=as.character(missing_comb$eel_lfs_code)
  missing_comb$eel_emu_nameshort =as.character(missing_comb$eel_emu_nameshort)
  missing_comb$eel_cou_code =as.character(missing_comb$eel_cou_code)
  missing_comb$eel_typ_name="com_landings"
  missing_comb$eel_value=NA
  missing_comb$eel_missvaluequal=missing_comb$eel_qal_id=missing_comb$eel_qal_comment=missing_comb$eel_comment=missing_comb$eel_datasource=NA
  
  missing_comb<-  missing_comb%>% select(eel_typ_name,
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
                           eel_comment,
                           eel_datasource)%>%
      arrange(eel_cou_code,
              eel_emu_nameshort,
              eel_hty_code,
              eel_lfs_code,
              eel_year)
  
  write.xlsx(missing_comb,sheetName="landings",file=paste("missing",cou,".xlsx"),showNA=FALSE)
    
}
