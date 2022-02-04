library(RPostgres)
library(sf)
library(getPass)
library(ggforce)
library(ggplot2)
library(flextable)
library(tidyverse)
library(yaml)
cred=read_yaml("../../credentials.yml")
con = dbConnect(Postgres(), dbname=cred$dbname,host=cred$host,port=cred$port,user=cred$user, password=getPass())

indicator <- dbGetQuery(con,"select eel_year, eel_cou_code,eel_emu_nameshort, b0,bbest,bcurrent, suma,sumf, sumh from datawg.precodata_emu ")
landings_releases <- dbGetQuery(con, "select typ_name,eel_year,eel_emu_nameshort,sum(case when eel_missvaluequal = 'NP' then 0 else eel_value end) eel_value,eel_lfs_code from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id
                                where eel_typ_id in (4,6,9) and eel_qal_id in (1,4) and eel_year >=2000
                                group by typ_name,eel_year,eel_emu_nameshort,eel_lfs_code ") %>%
  pivot_wider(names_from=c("typ_name","eel_lfs_code"),values_from="eel_value",names_sort=TRUE)

write.table(merge(indicator,landings_releases),"/tmp/indicators_landings_releases.csv",col.names=TRUE,row.names=FALSE,sep=";")
