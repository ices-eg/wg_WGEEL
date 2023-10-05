# This script creates a table of the number of data, either submitted or changed in the database, per annex.
# The table is located in schema tempo.
# The query excludes reporting or NR or NP in the t_eelstock_eel table.
# An excel file of the results is created after passing to wide format.


# CHANGE THIS NEXT YEAR
dc <- "dc_2023"
nametable <- "datacall_stats_2023"
# function to load packages if not available
load_library=function(necessary) {
  if(!all(necessary %in% installed.packages()[, 'Package']))
    install.packages(necessary[!necessary %in% installed.packages()[, 'Package']], dep = T)
  for(i in 1:length(necessary))
    library(necessary[i], character.only = TRUE)
}


###########################
# Loading necessary packages
############################

load_library("RPostgres")
load_library("DBI")
load_library("stringr")
load_library("getPass")
load_library("dplyr")
load_library("tidyr")
load_library("glue")
load_library("openxlsx")

#############################
# here is where the script is working change it accordingly
# one must be at the head of wgeel git 
##################################
if(Sys.info()["user"]=="hdrouineau"){
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/")
} else{
  setwd("C:/workspace/wg_WGEEL")
}
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata = paste0(getwd(), "/data/datacall_result/")
dir.create(wddata, showWarnings = FALSE)


###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
#if( !exists("pois")) pois <- getPass(msg="main password")
# host <- decrypt_string(hostdistant,pois)
library(yaml)
cred=read_yaml("credentials_write.yml")
host <- cred$host
userwgeel <- cred$user
passwordwgeel <-getPass("give password to db")
con=dbConnect(RPostgres::Postgres(), 		
    dbname=cred$dbname, 		
    host=host,
    port=cred$port, 		
    user= userwgeel, 		
    password= passwordwgeel)

dbExecute(con, glue_sql("DROP TABLE IF EXISTS  tempo.{`nametable`};", .con=con))
dbExecute(con, glue_sql("
CREATE TABLE tempo.{`nametable`} AS(
WITH everything AS (

-- Annex 1
SELECT ser_cou_code cou, 'Annex 1 1-series' annex , count(*) AS n FROM datawg.t_series_ser
WHERE ser_dts_datasource ={dc} AND ser_typ_id =1 
GROUP BY ser_cou_code
UNION
SELECT ser_cou_code cou, 'Annex 1 2-data' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_dataseries_das ON das_ser_id= ser_id
WHERE das_dts_datasource ={dc} AND ser_typ_id =1
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 1 3-group metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_groupseries_grser ON grser_ser_id=ser_id
LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id=gr_id
WHERE gr_dts_datasource ={dc} AND ser_typ_id =1
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 1 4-individual metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_fishseries_fiser ON fiser_ser_id=ser_id
LEFT JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE fi_dts_datasource ={dc} AND ser_typ_id =1
GROUP BY ser_cou_code
--Annex2
UNION
SELECT ser_cou_code cou, 'Annex 2 1-series' annex , count(*) AS n FROM datawg.t_series_ser
WHERE ser_dts_datasource ={dc} AND ser_typ_id =2
GROUP BY ser_cou_code
UNION
SELECT ser_cou_code cou, 'Annex 2 2-data' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_dataseries_das ON das_ser_id= ser_id
WHERE das_dts_datasource ={dc} AND ser_typ_id =2
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 2 3-group metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_groupseries_grser ON grser_ser_id=ser_id
LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id=gr_id
WHERE gr_dts_datasource ={dc} AND ser_typ_id =2
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 2 4-individual metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_fishseries_fiser ON fiser_ser_id=ser_id
LEFT JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE fi_dts_datasource ={dc} AND ser_typ_id =2
GROUP BY ser_cou_code
--Annex 3
UNION
SELECT ser_cou_code cou, 'Annex 3 1-series' annex , count(*) AS n FROM datawg.t_series_ser
WHERE ser_dts_datasource ={dc} AND ser_typ_id =3
GROUP BY ser_cou_code
UNION
SELECT ser_cou_code cou, 'Annex 3 2-data' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_dataseries_das ON das_ser_id= ser_id
WHERE das_dts_datasource ={dc} AND ser_typ_id =3
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 3 3-group metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_groupseries_grser ON grser_ser_id=ser_id
LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id=gr_id
WHERE gr_dts_datasource ={dc} AND ser_typ_id =3
GROUP BY ser_cou_code
UNION 
SELECT ser_cou_code cou, 'Annex 3 4-individual metrics' annex , count(*) AS n FROM datawg.t_series_ser
LEFT JOIN datawg.t_fishseries_fiser ON fiser_ser_id=ser_id
LEFT JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE fi_dts_datasource ={dc} AND ser_typ_id =3
GROUP BY ser_cou_code
UNION
SELECT  eel_cou_code cou, 'Annex 4 commercial landings' annex, count(*) AS n  FROM datawg.t_eelstock_eel 
WHERE eel_datasource ={dc}
AND eel_typ_id = 4 
AND eel_qal_id IN (1,3,4)
AND eel_missvaluequal IS NULL
GROUP BY eel_cou_code
UNION
SELECT  eel_cou_code cou, 'Annex 5 recreational landing' annex, count(*) AS n  FROM datawg.t_eelstock_eel 
WHERE eel_datasource ={dc}
AND eel_typ_id = 6
AND eel_qal_id IN (1,3,4)
AND eel_missvaluequal IS NULL
GROUP BY eel_cou_code
UNION
SELECT  eel_cou_code cou, 'Annex 6 other landings' annex, count(*) AS n  FROM datawg.t_eelstock_eel 
WHERE eel_datasource ={dc}
AND eel_typ_id IN (32,33)
AND eel_qal_id IN (1,3,4)
AND eel_missvaluequal IS NULL
GROUP BY eel_cou_code
UNION
SELECT  eel_cou_code cou, 'Annex 7 releases' annex, count(*) AS n FROM datawg.t_eelstock_eel 
WHERE eel_datasource ={dc}
AND eel_typ_id IN (8,9,10)
AND eel_qal_id IN (1,3,4)
AND eel_missvaluequal IS NULL
GROUP BY eel_cou_code
UNION
SELECT  eel_cou_code cou, 'Annex 8 aquaculture' annex, count(*) AS n  FROM datawg.t_eelstock_eel 
WHERE eel_datasource ={dc}
AND eel_typ_id =11
AND eel_qal_id IN (1,3,4)
AND eel_missvaluequal IS NULL
GROUP BY eel_cou_code
UNION 
--Annex 10
SELECT sai_cou_code cou, 'Annex 10 1-sampling info' AS annex, count(*) AS n  FROM datawg.t_samplinginfo_sai 
WHERE sai_dts_datasource ={dc}
GROUP BY sai_cou_code, sai_dts_datasource
UNION
SELECT sai_cou_code cou, 'Annex 10 2-group metric' AS annex, count(*) AS n  FROM datawg.t_samplinginfo_sai 
LEFT JOIN datawg.t_groupsamp_grsa ON grsa_sai_id=sai_id
LEFT JOIN datawg.t_metricgroupsamp_megsa ON meg_gr_id=gr_id
WHERE gr_dts_datasource = {dc}
GROUP BY sai_cou_code
UNION
SELECT sai_cou_code cou, 'Annex 10 3-individual metric' AS annex, count(*) AS n  FROM datawg.t_samplinginfo_sai 
LEFT JOIN datawg.t_fishsamp_fisa  ON fisa_sai_id = sai_id
LEFT JOIN datawg.t_metricindsamp_meisa ON mei_fi_id=fi_id
WHERE sai_dts_datasource ={dc}
OR fi_dts_datasource={dc}
OR mei_dts_datasource= {dc}
GROUP BY sai_cou_code)
SELECT cou, annex, n FROM everything  order by 1,2);", .con=con)) --191

# datacall  statistics
dcstat <- dbGetQuery(con, glue_sql("SELECT * FROM tempo.datacall_stats_2023",.con=con))

dcstatw <-dcstat %>% tidyr::pivot_wider(id_cols=cou, names_from=annex,values_from=n)
cc <- colnames(dcstatw)
cc1 <- cc[cc!="cou"]
cc <- c("cou",sort(cc1))
dcstatw <- dcstatw[,cc]

openxlsx::write.xlsx(dcstatw, file = file.path(wddata,"datacall_stats.xlsx"))