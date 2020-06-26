
#passwordwgeel <- getPass()


detect_missing_data <- function(cou="FR",
		minyear=2000,
		maxyear=2020, #maxyear corresponds to the current year where we have to fill data
		host="localhost",
		dbname="wgeel",
		user="wgeel",
		port=5432,
		datasource) {
  #browser()


  con_wgeel<-dbConnect(PostgreSQL(),host=host,dbname=dbname,user=user,port=port,password=passwordwgeel)
  
  #theoretically this one is the best solution but the table is not well filled
  emus<-unique(dbGetQuery(con_wgeel,paste("select emu_nameshort eel_emu_nameshort,emu_cou_code eel_cou_code from ref.tr_emu_emu
                                          where emu_wholecountry=false and emu_cou_code in ('",paste(cou,collapse="','",sep=""),"')",sep="")))
  
  hty_emus <- c("F","T","C","MO")  
  all_comb <- merge(expand.grid(eel_lfs_code=c("G","Y","S"),
                          eel_year=minyear:maxyear,
                          eel_typ_id=c(4,6),
                          eel_hty_code=hty_emus),
                    emus)
  complete<-dbGetQuery(con_wgeel,paste(paste("select eel_typ_id,eel_hty_code,eel_year,eel_emu_nameshort,eel_lfs_code,eel_cou_code,eel_value,eel_missvaluequal,eel_area_division from datawg.t_eelstock_eel where eel_qal_id in (0,1,2,4) and eel_year>=",minyear," and eel_year<=",maxyear," and eel_typ_id in (4,6) and eel_cou_code='",cou,"'",sep="")))
  last_year <- subset(complete,complete$eel_year == maxyear -1)
  ranges<-dbGetQuery(con_wgeel,paste(paste("select eel_area_division,eel_typ_id,eel_hty_code,eel_emu_nameshort,eel_lfs_code,eel_cou_code,min(eel_year) as first_year,max(eel_year) last_year from datawg.t_eelstock_eel where eel_qal_id in (0,1,2,4) and eel_year>=",minyear," and eel_year<=",maxyear," and eel_typ_id in (4,6) and eel_cou_code='",cou,"' group by eel_area_division,eel_typ_id,eel_hty_code,eel_emu_nameshort,eel_lfs_code,eel_cou_code",sep="")))
  missing_comb <- anti_join(all_comb, complete)
  missing_comb$id <- 1:nrow(missing_comb)
  found_matches <- sqldf("select id,c.eel_emu_nameshort from missing_comb m inner join complete c on c.eel_cou_code=m.eel_cou_code and
                                                            c.eel_year=m.eel_year and
                                                            c.eel_typ_id=m.eel_typ_id and
                                                            c.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and (c.eel_hty_code like '%'||m.eel_hty_code||'%' or c.eel_hty_code='AL')
                                                            and (c.eel_emu_nameshort=m.eel_emu_nameshort or
                                                                c.eel_emu_nameshort=substr(m.eel_emu_nameshort,1,3)||'total')",drv = "SQLite")
  #looks for missing combinations
  missing_comb <- missing_comb %>%
    filter(!missing_comb$id %in% found_matches$id)%>%
    select(-id) %>%
    arrange(eel_cou_code,eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code,eel_year)
  
  
  missing_comb <- sqldf("select m.*, first_year,last_year,eel_area_division from missing_comb m left join ranges r on m.eel_cou_code=r.eel_cou_code and
                                                            m.eel_typ_id=r.eel_typ_id and
                                                            r.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and (r.eel_hty_code like '%'||m.eel_hty_code)
                                                            and m.eel_emu_nameshort=r.eel_emu_nameshort",drv = "SQLite")
  
  missing_comb$eel_hty_code=as.character(missing_comb$eel_hty_code)
  missing_comb$eel_lfs_code=as.character(missing_comb$eel_lfs_code)
  missing_comb$eel_emu_nameshort =as.character(missing_comb$eel_emu_nameshort)
  missing_comb$eel_cou_code =as.character(missing_comb$eel_cou_code)
  missing_comb$eel_typ_name="com_landings"
  missing_comb$eel_value=NA
  
  missing_comb$eel_comment <- mapply(function(y,f,l){
    if (is.na(f) & is.na(l)){
      return("no landing ever recorded in the db")
    } else if (!is.na(l) & (y > l) & l<maxyear-3){
      return (paste("landings ended in",l))
    } else {
      return (paste("landings recorded in",l))
    }
  }, missing_comb$eel_year,missing_comb$first_year,missing_comb$last_year)
  
  missing_comb$eel_missvaluequal=sapply(missing_comb$eel_comment,function(c){
    if (startsWith(c,"no landing")) return("NP")
    if (startsWith(c,"landings ended")) return ("NP")
    if (startsWith(c, "landings recorded")) return("NC")
  })
  missing_comb$eel_qal_id <- ifelse(missing_comb$eel_missvaluequal=="NC",0,2)
  missing_comb$eel_qal_comment <- "autofilled by missing data detection procedure"
  missing_comb$eel_datasource <- str_c(datasource,"_missing")
  
  ####For ongoing year, we leave NP but removes the other
  missing_comb$eel_comment[missing_comb$eel_year==maxyear] <- NA
  missing_comb$eel_qal_comment[missing_comb$eel_year==maxyear] <- NA
  missing_comb$eel_qal_id[missing_comb$eel_year==maxyear & missing_comb$eel_missvaluequal == "NC"] <- NA
  missing_comb$eel_datasource[missing_comb$eel_year==maxyear] <- datasource
  missing_comb$eel_missvaluequal[missing_comb$eel_year==maxyear & missing_comb$eel_missvaluequal == "NC"] <- NA
  
  
  
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
	dbDisconnect(con_wgeel)
  return(missing_comb)
    
}
