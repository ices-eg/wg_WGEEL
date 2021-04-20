
#passwordwgeel <- getPass()


detect_missing_data <- function(cou="FR",
		minyear=2000,
		maxyear=2020, #maxyear corresponds to the current year where we have to fill data
		host="localhost",
		dbname="wgeel",
		user="wgeel",
		port=5432,
		datasource="dc_2020") {
  #browser()


  con_wgeel<-dbConnect(PostgreSQL(),host=host,dbname=dbname,user=user,port=port,password=passwordwgeel)
  
  #theoretically this one is the best solution but the table is not well filled
  emus <- unique(dbGetQuery(con_wgeel,paste("select emu_nameshort eel_emu_nameshort,emu_cou_code
 eel_cou_code, emu_wholecountry  from ref.tr_emu_emu
                                          where emu_cou_code in ('",paste(cou,collapse="','",sep=""),"')",sep="")))
  complete <- dbGetQuery(con_wgeel,paste(paste("select eel_typ_id,eel_hty_code,eel_year,eel_emu_nameshort,eel_lfs_code,eel_cou_code,eel_value,eel_missvaluequal,max(eel_area_division) eel_area_division from datawg.t_eelstock_eel where eel_qal_id in (0,1,2,4) and eel_year>=",minyear," and eel_year<=",maxyear," and eel_typ_id in (4,6) and eel_cou_code='",cou,"'
                                               group by eel_typ_id,eel_hty_code,eel_year,eel_emu_nameshort,eel_lfs_code,eel_cou_code,eel_value,eel_missvaluequal",sep="")))
  used_emus=unique(complete$eel_emu_nameshort)
  
  #in Sweeden, there are historical subidivisions thate we do not take into account
  emus=emus[!grepl("_.._",emus$eel_emu_nameshort),]
  
  
	# in some cases there is just one total, otherwise remove total											
	if (nrow(emus)>2 & cou!="DK"){ #for Denmark, total EMUs as a different meanings that for other countries
		emus <- emus[!emus$emu_wholecountry,c(1,2)]		
	} else if (nrow(emus)==2) {
	  emus = subset(emus, emus$eel_emu_nameshort %in% used_emus)[,c(1,2)]
	} 
  else {
		emus <- emus[,c(1,2)]				
	}
  
  hty_emus <- c("F","T","C","MO")  
  all_comb <- merge(expand.grid(eel_lfs_code=c("G","Y","S"),
                          eel_year=minyear:maxyear,
                          eel_typ_id=c(4,6),
                          eel_hty_code=hty_emus),
                    emus)
  ranges<-dbGetQuery(con_wgeel,paste(paste("select max(eel_area_division) eel_area_division,eel_typ_id,eel_hty_code,eel_emu_nameshort,eel_lfs_code,eel_cou_code,min(eel_year) as first_year,max(eel_year) last_year from datawg.t_eelstock_eel where eel_value >0 and eel_qal_id in (0,1,2,4) and eel_year>=",minyear," and eel_year<=",maxyear," and eel_typ_id in (4,6) and eel_cou_code='",cou,"' group by eel_typ_id,eel_hty_code,eel_emu_nameshort,eel_lfs_code,eel_cou_code",sep="")))
	options(warn=-1)
  missing_comb <- suppressMessages(anti_join(all_comb, complete))

  
	options(warn=0)
  missing_comb$id <- 1:nrow(missing_comb)
 # searching for aggregations at the upper level
  found_matches <- sqldf("select id,c.eel_emu_nameshort from missing_comb m inner join complete c on c.eel_cou_code=m.eel_cou_code and
                                                            c.eel_year=m.eel_year and
                                                            c.eel_typ_id=m.eel_typ_id and
                                                            c.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and (c.eel_hty_code like '%'||m.eel_hty_code||'%' or c.eel_hty_code='AL')
                                                            and (c.eel_emu_nameshort=m.eel_emu_nameshort or
                                                                c.eel_emu_nameshort=substr(m.eel_emu_nameshort,1,3)||'total')",drv = "SQLite")
  # remove upper level aggregations
  missing_comb <- missing_comb %>%
    filter(!missing_comb$id %in% found_matches$id)%>%
    arrange(eel_cou_code,eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code,eel_year)

  # append the range years to the dataset
  missing_comb <- sqldf("select m.*, min(first_year) first_year,max(last_year) last_year,max(eel_area_division) eel_area_division from missing_comb m left join ranges r on m.eel_cou_code=r.eel_cou_code and
                                                            m.eel_typ_id=r.eel_typ_id and
                                                            r.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and (r.eel_hty_code like '%'||m.eel_hty_code)
                                                            and m.eel_emu_nameshort=r.eel_emu_nameshort
                        group by id",drv = "SQLite")
  missing_comb <- missing_comb %>%
    select(-id)
  
  missing_comb$eel_hty_code=as.character(missing_comb$eel_hty_code)
  missing_comb$eel_lfs_code=as.character(missing_comb$eel_lfs_code)
  missing_comb$eel_emu_nameshort =as.character(missing_comb$eel_emu_nameshort)
  missing_comb$eel_cou_code =as.character(missing_comb$eel_cou_code)
  eel_typ_name=dbGetQuery(con_wgeel,"select typ_id,typ_name as eel_typ_name from ref.tr_typeseries_typ where typ_id in (4,6)")
  missing_comb <- merge(missing_comb,eel_typ_name)
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
  
  ###for last year, we look for the last level of aggregation
  found_matches_last_year <- sqldf(paste("select m.*,c.eel_lfs_code last_lfs,c.eel_hty_code last_hty,c.eel_emu_nameshort last_emu,c.eel_year last_year from all_comb m left join complete c on c.eel_cou_code=m.eel_cou_code and
                                                            c.eel_typ_id=m.eel_typ_id and
                                                            c.eel_lfs_code like '%'||m.eel_lfs_code||'%'
                                                            and (c.eel_hty_code like '%'||m.eel_hty_code||'%' or c.eel_hty_code='AL')
                                                            and (c.eel_emu_nameshort=m.eel_emu_nameshort) where m.eel_year=",maxyear),drv = "SQLite")
  found_matches_last_year <-found_matches_last_year %>% group_by(eel_lfs_code,eel_typ_id,eel_hty_code,eel_emu_nameshort,eel_cou_code) %>%
    mutate(rank=rank(-last_year)) %>%
    filter(rank==1)
  
  missing_comb2 <- missing_comb %>% #this is the row that should be filled for this year
    filter(eel_year == 2020 & is.na(eel_missvaluequal))
  
  missing_comb <- missing_comb %>%
    filter(eel_year != 2020 | !is.na(eel_missvaluequal))
  
  missing_comb2 <- merge(missing_comb2,na.omit(found_matches_last_year),all.x=TRUE)
  missing_comb2$eel_lfs_code[!is.na(missing_comb2$last_lfs)] <- missing_comb2$last_lfs[!is.na(missing_comb2$last_lfs)]
  missing_comb2$eel_hty_code[!is.na(missing_comb2$last_hty)] <- missing_comb2$last_hty[!is.na(missing_comb2$last_hty)]
  missing_comb2 <- missing_comb2 %>%
    distinct_at(vars(-eel_area_division)) %>%
    select(-last_lfs,-last_hty,-last_year,-last_emu)
  missing_comb <- bind_rows(missing_comb,missing_comb2)
  
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








detect_missing_biom_morta <- function(cou="FR",
                                      typ="biom",
                                minyear=2000,
                                maxyear=2021, #maxyear corresponds to the current year where we have to fill data
                                host="localhost",
                                dbname="wgeel",
                                user="wgeel",
                                port=5432,
                                datasource="dc_2021") {
  #browser()
  
  eel_typ_id=13:15
  if(typ=="morta") eel_typ_id = 17:19
  con_wgeel<-dbConnect(PostgreSQL(),host=host,dbname=dbname,user=user,port=port,password=passwordwgeel)
  
  #theoretically this one is the best solution but the table is not well filled
  emus <- unique(dbGetQuery(con_wgeel,paste("select emu_nameshort eel_emu_nameshort,emu_cou_code
 eel_cou_code, emu_wholecountry  from ref.tr_emu_emu
                                          where emu_cou_code in ('",paste(cou,collapse="','",sep=""),"')",sep="")))
  #in Sweeden, there are historical subidivisions thate we do not take into account
  emus=emus[!grepl("_.._",emus$eel_emu_nameshort),]
  
  # in some cases there is just one total, otherwise remove total											
  if (nrow(emus)>2 & cou!="DK"){ #for Denmark, total EMUs as a different meanings that for other countries
    emus <- emus[!emus$emu_wholecountry,c(1,2)]		
  } else if (nrow(emus)==2) {
    emus = subset(emus, emus$eel_emu_nameshort %in% used_emus)[,c(1,2)]
  } else {
    emus <- emus[,c(1,2)]				
  }
  
  
  complete <- dbGetQuery(con_wgeel,"select eel_cou_code,eel_year,eel_emu_nameshort,b0,bbest,bcurrent,suma,sumf,sumh from datawg.precodata_emu") %>%
    pivot_longer(cols=all_of(c("b0","bbest","bcurrent","suma","sumf","sumh")),names_to="eel_typ_name",values_to="eel_value") %>%
    filter(!is.na(eel_value)) %>%
    filter(eel_cou_code == cou) %>%
    mutate(eel_typ_id=case_when(eel_typ_name == "b0" ~ 13,
                                eel_typ_name == "bbest" ~ 14,
                                eel_typ_name == "bcurrent" ~ 15,
                                eel_typ_name == "suma" ~ 17,
                                eel_typ_name == "sumf" ~ 18,
                                eel_typ_name == "sumh" ~ 19
                                )) %>%
    distinct() %>%
    mutate(eel_year=ifelse(eel_typ_id==13,0,eel_year))
  
  ##we check that's there only one B0 
  complete <- complete %>% 
    group_by(eel_cou_code, eel_year, eel_emu_nameshort,eel_typ_name,eel_typ_id) %>%
    summarize(n=n_distinct(eel_value),eel_value=mean(eel_value,na.rm=TRUE)) %>%
    filter(n==1)
  


  

  
  hty_emus <- c("AL")  
  all_comb <- merge(expand.grid(eel_lfs_code=c("S"),
                                eel_year=minyear:maxyear,
                                eel_typ_id= eel_typ_id[eel_typ_id != 13],
                                eel_hty_code=hty_emus),
                    emus) 
  if (type=="biom") all_comb <- all_comb %>%
    bind_rows(merge(expand.grid(eel_lfs_code=c("S"),
                                eel_year=0,
                                eel_typ_id=13,
                                eel_hty_code=hty_emus),
                    emus))
  options(warn=-1)
  if (nrow(complete) == 0 || maxyear==2021){
    missing_comb <- all_comb
  } else {
    missing_comb <- suppressMessages(anti_join(all_comb, complete))
  }
  
  options(warn=0)

  missing_comb$eel_year = as.integer(missing_comb$eel_year)
  
  missing_comb <- base::merge(missing_comb,complete[,c("eel_year","eel_emu_nameshort","eel_value","eel_typ_id")],
                              all.x=TRUE)

  return(missing_comb)
}

