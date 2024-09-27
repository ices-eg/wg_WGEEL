library(RPostgres)
library(yaml)
library(dplyr)
credentials=read_yaml("credentials_write.yml")
con=dbConnect(Postgres(),host=credentials$host, port=credentials$port,
              dbname=credentials$dbname, user=credentials$user,password=credentials$password)
dbGetQuery(con,"insert into ref.tr_model_mod values('glm_yoy','GLM used for the recruitment trend analysis in the assessment for young of the year with formula IA~site+year:area and two zones'),
                                       ('glm_older','GLM used for the recruitment trend analysis in the assessment for older migrating yellow eels with formula IA~site+year')")

series=dbReadTable(con,Id(schema="datawg",table="t_series_ser"))

export_model_year <- function(year){
  tryCatch({dbBegin(con)
  path=paste0("./R/recruitment/",year,"/data/")
  old_model <- new.env()
  #load(paste0(path,"glass_eel_yoy.Rdata"), envir=old_model)
  #load(paste0(path,"older.Rdata"), envir=old_model)
  load(paste0(path,"wger.Rdata"), envir=old_model)
  if (!"das_qal_id" %in% names(old_model$wger))
    old_model$wger$das_qal_id <- NA
  old_model$older <- old_model$wger %>% filter(lifestage=="yellow eel" & !is.na(value))
  old_model$glass_eel_yoy <- old_model$wger %>% filter(lifestage!="yellow eel" & !is.na(value))
  
  dbGetQuery(con,paste0("insert into datawg.t_modelrun_run (run_date,run_mod_nameshort,run_description) values('",year,"-09-01','glm_yoy','final GLM yoy model used for the assessment'),
                                       ('",year,"-09-01','glm_older','final GLM older model used for the assessment')"))
  
  mod_run_id=dbGetQuery(con,paste0("select run_id from datawg.t_modelrun_run where run_mod_nameshort='glm_yoy' and run_date='",year,"-09-01'"))[1]
  mod_run_older=dbGetQuery(con,paste0("select run_id from datawg.t_modelrun_run where run_mod_nameshort='glm_older' and run_date='",year,"-09-01'"))[1]
  
  
  #check that ser_id match
  merge(unique(old_model$older[,c("ser_id","site"), drop=FALSE]),
        series[,c("ser_nameshort","ser_id")],all.x=TRUE)
  
  #check that ser_id match
  merge(unique(old_model$glass_eel_yoy[,c("ser_id","site"), drop=FALSE]),
        series[,c("ser_nameshort","ser_id")],all.x=TRUE)
  
  dbWriteTable(con,Id(schema="datawg",table="t_modeldata_dat"),
               data.frame(dat_run_id=mod_run_id[1,1],
                          dat_ser_id=old_model$glass_eel_yoy[,"ser_id"],
                          dat_ser_year=old_model$glass_eel_yoy[,"year"],
                          dat_das_value=old_model$glass_eel_yoy[,"value"],
                          dat_das_qal_id=old_model$glass_eel_yoy[,"das_qal_id"]),
               append=TRUE)
  
  dbWriteTable(con,Id(schema="datawg",table="t_modeldata_dat"),
               data.frame(dat_run_id=mod_run_older[1,1],
                          dat_ser_id=old_model$older[,"ser_id"],
                          dat_ser_year=old_model$older[,"year"],
                          dat_das_value=old_model$older[,"value"],
                          dat_das_qal_id=old_model$older[,"das_qal_id"]),
               append=TRUE)
  dbCommit(con)},
  error=function(e) {
    dbRollback(con)
    print(e)
    })
  
  
  
  
}


######################################---
# year=2017 --------------
######################################---
year=2017
export_model_year(year)



######################################---
# year=2018 --------------
######################################---

year=2018

export_model_year(year)

######################################---
# year=2019 --------------
######################################---

year=2019

export_model_year(year)


######################################---
# year=2020 --------------
######################################---

year=2020
export_model_year(year)


######################################---
# year=2021 --------------
######################################---

year=2021

export_model_year(year)



######################################---
# year=2022 --------------
######################################---

year=2022

export_model_year(year)


######################################---
# year=2023 --------------
######################################---

year=2023

export_model_year(year)

dbDisconnect(con)
