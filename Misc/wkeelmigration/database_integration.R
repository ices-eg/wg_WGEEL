# 29/12/2019
# 
# Author: cedricbriandgithub
###############################################################################


# Initial read of seasonality files -------------------------------------------


# load packages
setwd("C:\\workspace\\gitwgeel\\Misc\\wkeelmigration\\")
source("..\\..\\R\\utilities\\load_library.R")
load_package("readxl")
load_package("stringr")
load_package("pool")
load_package("DBI")
load_package("RPostgreSQL")
load_package("glue")
load_package("sqldf")
load_package("tidyverse")
source("..\\..\\R\\shiny_data_integration\\shiny_di\\loading_functions.R")
source("..\\..\\R\\shiny_data_integration\\shiny_di\\database_reference.R") # extract_ref
load(file=str_c("C:\\workspace\\gitwgeel\\R\\shiny_data_integration\\shiny_di","\\common\\data\\init_data.Rdata"))  
# read data


datawd <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wkeemigration\\source\\"
fall <- list.files(datawd)
fcl <- list.files(datawd,pattern='commercial_landings')
ffc <- list.files(datawd,pattern='fishery_closure')
fsm <- list.files(datawd,pattern='seasonality_of_migration')

# load data from database
# At this stage start a tunnel to wgeel via SSH
port <- 5436 # 5435 to use with SSH, translated to 5432 on distant server
# 5436 to use in local server
host <- "localhost"#"192.168.0.100"
userwgeel <-"wgeel"
# we use isolate as we want no dependency on the value (only the button being clicked)
stopifnot(exists("passwordwgeel"))
############################################
# FIRST STEP INITIATE THE CONNECTION WITH THE DATABASE
###############################################
options(sqldf.RPostgreSQL.user = userwgeel,  
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = port)

# Define pool handler by pool on global level
pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
		dbname="wgeel",
		host=host,
		port=port,
		user= userwgeel,
		password= passwordwgeel)



query <- "SELECT column_name
		FROM   information_schema.columns
		WHERE  table_name = 't_eelstock_eel'
		ORDER  BY ordinal_position"
t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
t_eelstock_eel_fields <- t_eelstock_eel_fields$column_name

query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
list_country <- list_countryt$cou_code
names(list_country) <- list_countryt$cou_country
list_country<-list_country

query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
typ_id <- tr_typeseries_typt$typ_id
tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
names(typ_id) <- tr_typeseries_typt$typ_name
# tr_type_typ<-extract_ref('Type of series') this works also !
tr_typeseries_typt<-tr_typeseries_typt

query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel eel_cou "
the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   

query <- "SELECT name from datawg.participants"
participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
# save(participants,list_country,typ_id,the_years,t_eelstock_eel_fields, file=str_c(getwd(),"/common/data/init_data.Rdata"))
ices_division <- extract_ref("FAO area")$f_code
emus <- extract_ref("EMU")

save(ices_division, emus, the_years, tr_typeseries_typt, list_country, file=str_c(datawd,"saved_data.Rdata"))

poolClose(pool)


# test for missing files
stopifnot(length(fall[!fall%in%c(fcl,ffc,fsm)])==0)
datasource <- "wkeelmigration"
list_seasonality <- list()
for (f in fsm){
	# f <- fsm[1]
	path <- str_c(datawd,f)	
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	country <- substring(mylocalfilename,1,2)
	list_seasonality[[mylocalfilename]] <-	load_seasonality(path, datasource)
}

res <- map(list_seasonality,function(X){			X[["data"]]		}) %>% 
		bind_rows()
Hmisc::describe(res)
# correcting pb with column
#res$ser_nameshort[!is.na(as.numeric(res$das_month))]
#listviewer::jsonedit(list_seasonality)

# Correct month
unique(res$das_month)
res$das_month <- tolower(res$das_month)
res$das_month <- recode(res$das_month, okt = "oct")
res <-res[!is.na(res$das_month),]
res$das_month <- recode(res$das_month, 
		"mar"=3, 
		"apr"=4, 
		"may"=5, 
		"jun"=6,
		"jul"=7,
		"aug"=8,
		"sep"=9,
		"oct"=10,
		"nov"=11,
		"dec"=12, 
		"jan"=1, 
		"feb"=2
)

# check nameshort
ser_nameshort <- sqldf("select ser_nameshort from datawg.t_series_ser")
ser_nameshort_datacall <- unique(res$ser_nameshort)
res[is.na(res$ser_nameshort),]


res %>% group_by(ser_nameshort)