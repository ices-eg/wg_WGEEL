# script_manual_insertion.R
# Use this script if you have a lot of data to put to the database
# here it is adapted to insert historical series from germany
###############################################################################


# here is a list of the required packages
library(readxl) # to read xls files
library(stringr) # this contains utilities for strings
require(sqldf) # to run queries
require(RPostgreSQL)# to run queries to the postgres database

# clean up directory except for my password
# which is generated while launching R in Rprofile.site
# http://www.statmethods.net/interface/customizing.html
obj<-ls(all=TRUE)
obj<-obj[!obj%in%c("passworddistant","passwordlocal")]
rm(list=obj) 

# set working directory
setwd("C:/workspace/gitwgeel/R/stock_assessment/")
wd<-getwd()


options(sqldf.RPostgreSQL.user = "postgres", 
		sqldf.RPostgreSQL.password = passwordlocal,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5432)

# this is where I store the xl files
datawd<-"C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/Recruitment/"

# read data from xl file
series_info<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_Scot.xlsx"), sheet="series_info")

# series are ordered from North to South
# series is currently 17
# so I'm inserting 3 new numbers....
# RUN ONCE ONLY
#DEPRECATED NO LONGER USED LFS
#sqldf("update datawg.t_series_ser set ser_order=ser_order+3 where ser_order>17;")
series_info$ser_order <- 18:20

series_info$ser_tblcodeid<-NULL
nchar(series_info$ser_namelong) # manual correction to avoid length > 50
series_info$ser_qal_id <- c(1,0,0)
series_info$ser_qal_comment <- c("Series > 10 years","Too short","Too short")
# insert new series
# dplyr::glimpse(series_info)
sqldf("INSERT INTO  datawg.t_series_ser(
				ser_order, 
				ser_nameshort, 
				ser_namelong, 
				ser_typ_id, 
				ser_effort_uni_code, 
				ser_comment, 
				ser_uni_code, 
				ser_lfs_code, 
				ser_hty_code, 
				ser_locationdescription, 
				ser_emu_nameshort, 
				ser_cou_code, 
				ser_area_division,
				--ser_tblcodeid,
				ser_x, 
				ser_y, 
				ser_sam_id,
				ser_qal_id,
				ser_qal_comment) SELECT   
				ser_order, 
				ser_nameshort, 
				ser_namelong, 
				ser_typ_id, 
				ser_effort_uni_code, 
				ser_comment, 
				ser_uni_code, 
				ser_lfs_code, 
				ser_hty_code, 
				ser_locationdescription, 
				ser_emu_nameshort, 
				ser_cou_code, 
				ser_area_division,
				--ser_tblcodeid,
				ser_x, 
				ser_y, 
				ser_sam_id,
				ser_qal_id,
				ser_qal_comment from series_info;")

#---------------------------
# script to integrate series one by one (only one saved)
#-------------------------------------
sqldf("select ser_nameshort from datawg.t_series_ser where ser_cou_code='GB'")
ShiF
Girn
ShiM
series<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_Scot.xlsx"), sheet="ShiM")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='ShiM'")
series$das_ser_id<-as.numeric(ser_id)
series$das_value<-as.numeric(series$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment
				FROM series;")


#---------------------------
# script for bann to remove pre-existing data in the series
#-------------------------------------
bann<-bann[!is.na(bann$das_year),]
#>  str(bann)
#Classes 'tbl_df', 'tbl' and 'data.frame':	86 obs. of  8 variables:
#     $ das_id         : num  NA NA NA NA NA NA NA NA NA NA ...
#$ das_value      : num  NA 3333 5200 6767 7567 ...
#$ das_ser_id     : num  NA NA NA NA NA NA NA NA NA NA ...
#$ das_year       : num  NA 1933 1934 1935 1936 ...
#$ das_comment    : chr  "Inserted 2017 by Evans  6/9/17" NA NA NA ...
#$ das_effort     : logi  NA NA NA NA NA NA ...
#$ das_last_update: logi  NA NA NA NA NA NA ...
#$ das_qal_id     : logi  NA NA NA NA NA NA ...

bann_database<-sqldf("SELECT 
				das_id,
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_effort,
				das_last_update,
				das_qal_id
				FROM datawg.t_dataseries_das 
				JOIN datawg.t_series_ser ON ser_id=das_ser_id
				where ser_nameshort='bann'
				order by das_year")
#what are the years in the excel table that are already in the database
index_remove <- !bann$das_year%in%germ_database$das_year
# selecting the rows to import
germ<-germ[index_remove,]

sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment
				) SELECT 
				das_value,
				4 as das_ser_id,
				das_year,
				'Inserted 2017 Derek Evans' as das_comment
				FROM bann;")


#---------------------------
# script to integrate 8 new series from the UK one by one (only one saved)
#-------------------------------------
datawd<-"C:/Users/cedric.briand/Documents/projets/GRISAM/2018/datacall/datacallfiles/Eel_Data_Call_Great_Brittain/"
station<-read_excel(path=str_c(datawd,"station.xlsx"), sheet="Feuil1")
station$EndYear <- as.numeric(station$EndYear)
sqldf("insert into ref.tr_station select * from station")


series_info<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB.xlsx"), sheet="series_info")

# series are ordered from North to South
# last series from UK currently 20
# I'm inserting 8 new numbers....
# RUN ONCE ONLY
#sqldf("update datawg.t_series_ser set ser_order=ser_order+8 where ser_order>20;")
series_info$ser_namelong
# series_info$ser_order <- 21:28
# Manual edition of values to be inserted.... 
#series_info$ser_tblcodeid<-c(170072,170073,170074,170075,170076,170077,170078,170079)
nchar(series_info$ser_namelong) # manual correction to avoid length > 50

# insert new series
# dplyr::glimpse(series_info)

sqldf("INSERT INTO  datawg.t_series_ser(
				ser_order, 
				ser_nameshort, 
				ser_namelong, 
				ser_typ_id, 
				ser_effort_uni_code, 
				ser_comment, 
				ser_uni_code, 
				ser_lfs_code, 
				ser_hty_code, 
				ser_locationdescription, 
				ser_emu_nameshort, 
				ser_cou_code, 
				ser_area_division,
				ser_tblcodeid,
				ser_x, 
				ser_y, 
				ser_sam_id,
				ser_qal_id,
				ser_qal_comment) SELECT   
				ser_order, 
				ser_nameshort, 
				ser_namelong, 
				ser_typ_id, 
				ser_effort_uni_code, 
				ser_comment, 
				ser_uni_code, 
				ser_lfs_code, 
				ser_hty_code, 
				ser_locationdescription, 
				ser_emu_nameshort, 
				ser_cou_code, 
				ser_area_division,
				ser_tblcodeid,
				ser_x, 
				ser_y, 
				ser_sam_id,
				ser_qal_id,
				ser_qal_comment from series_info;")


# FlaG
dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB.xlsx"),
		sheet="Data_Flatford_GE_<80mm")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='FlaG'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment
				FROM dat;")
# In fact there are only 8 years available
sqldf("update datawg.t_series_ser set (ser_qal_id,ser_qal_comment) = 
				(0, 'series too short 8 years') where ser_nameshort='FlaG'")

# FlaE

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="Data_Flatford_Elvers_>80<120mm")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='FlaE'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id,
				das_qal_comment
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id,
				das_qal_comment
				FROM dat;")

# BeeG

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="BeeG")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='BeeG'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment      
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment       
				FROM dat;")

# BroG

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="BroG")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='BroG'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)

#qal comments used there
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				FROM dat;")

# BroE

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="BroE")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='BroE'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)

#qal comments used there
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				FROM dat;")

# BroY

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="BroY")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='BroY'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)

#qal comments used there
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment,
				das_qal_id
				FROM dat;")

# Grey

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="Grey")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='Grey'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment
				FROM dat;")

# BroY is a yellow eel series, it comes after glass eel series in order
# RUN ONCE ONLY
# insert line at 136
#sqldf("update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=136;")
# 25 corresponds to BroY
# sqldf("update datawg.t_series_ser set ser_order=136 where ser_order=25;")


# Strangford

dat<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment_GB_cor.xlsx"),
		sheet="Stra")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='Stra'")
dat$das_ser_id<-as.numeric(ser_id)
dat$das_value<-as.numeric(dat$das_value)
sqldf("INSERT INTO datawg.t_dataseries_das(
				das_value,
				das_ser_id,
				das_year,
				das_comment
				) SELECT 
				das_value,
				das_ser_id,
				das_year,
				das_comment
				FROM dat;")


###################################################################
#---------------- 2019 --------------------------------------------
###################################################################

library(readxl) # to read xls files
library(stringr) # this contains utilities for strings
require(sqldf) # to run queries
require(RPostgreSQL)# to run queries to the postgres database

# clean up directory except for my password
# which is generated while launching R in Rprofile.site
# http://www.statmethods.net/interface/customizing.html
obj<-ls(all=TRUE)
obj<-obj[!obj%in%c("userwgeel","passwordwgeel")]
rm(list=obj) 

# set working directory
setwd("C:/workspace/gitwgeel/R/recruitment/")
wd<-getwd()

# going to the server database with a ssh tunnel in localhost (check putty)

options(sqldf.RPostgreSQL.user = userwgeel, 
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5435)




country <-"UK"
path <- str_c("\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\02 Recuitment Submission 2019",
		country,"_Eel_Data_Call_Annex1_Recruitment.xlsx")


###########################
# INTEGRATING BIOMETRY
##########################

biom<-read_excel(path,sheet="biometry")

##############################
# COLNAMES IN EXCEL TABLE
##############################
# colnames(biom)
#"ser_nameshort" "bio_year"      "bio_length"    "bio_weight"   
# "bio_age"       "bio_g_in_gy"   "bio_comment"  
##############################
# COLNAMES IN TARGET TABLE
##############################
#database_biom <- sqldf("SELECT * FROM datawg.t_biometry_series_bis") # nothing yet
## bio_id => this is a serial no insertion
# bio_lfs_code 
# bio_year 
# bio_length 
# bio_weight 
# bio_age
# bio_perc_female
# bio_length_f 
# bio_weight_f 
# bio_age_f 
# bio_length_m 
# bio_weight_m 
# bio_age_m 
# bio_comment
# bio_last_update => not kept
# bio_qal_id 
# bis_g_in_gy 
# bis_ser_id 


# life stage needs to be collected from series
ser <- sqldf("SELECT * FROM datawg.t_series_ser")
ser <- ser %>% dplyr::select(ser_id,ser_lfs_code,ser_nameshort)

biom2 <- dplyr::inner_join(ser, biom, by="ser_nameshort")
# check that all names are joined by
stopifnot (nrow(biom2)==nrow(biom))
biom2$bio_age <-as.numeric(biom2$bio_age) # all lines empty this creates a crash later
biom3 <- data.frame(# bio_id .... ignored
		bio_lfs_code = biom2$ser_lfs_code,
		bio_year = biom2$bio_year,
		bio_length = biom2$bio_length ,
		bio_weight = biom2$bio_weight ,
		bio_age = biom2$bio_age,
		bio_perc_female = as.numeric(NA),
		bio_length_f = as.numeric(NA),
		bio_weight_f = as.numeric(NA),
		bio_age_f = as.numeric(NA),
		bio_length_m = as.numeric(NA),
		bio_weight_m = as.numeric(NA),
		bio_age_m =as.numeric(NA),
		bio_comment = biom2$bio_comment,
		#bio_last_update 
		bio_qal_id = 19, # until it's validated during wgeel
		bis_g_in_gy = biom2$bio_g_in_gy,
		bis_ser_id  = biom2$ser_id)

# CREATE TEMPORARY TABLE ON THE SERVER
sqldf( str_c("DROP TABLE if exists temp_t_biometry_bio_", country))
sqldf( str_c("CREATE TABLE temp_t_biometry_bio_", country, " AS SELECT * FROM biom3"))

sqldf("INSERT INTO datawg.t_biometry_series_bis(
				bio_lfs_code,
				--bio_id
				bio_year,
				bio_length,
				bio_weight,
				bio_age,
				bio_perc_female,
				bio_length_f,
				bio_weight_f,
				bio_age_f,
				bio_length_m,
				bio_weight_m,
				bio_age_m,
				bio_comment,
				--bio_last_update 
				bio_qal_id, 
				bis_g_in_gy, 
				bis_ser_id) 
				SELECT * FROM temp_t_biometry_bio_UK;")

# ---------------------------------------------------------------------------------------------------------


options(sqldf.RPostgreSQL.user = userwgeel, 
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5435)	
country <-"PT"
path <- str_c("\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\02 Recuitment Submission 2019/",
		country,"_PORT_Eel_Data_Call_Annex1_Recruitment.xlsx")


###########################
# INTEGRATING BIOMETRY
##########################

biom<-read_excel(path,sheet="biometry")

##############################
# COLNAMES IN EXCEL TABLE
##############################
# colnames(biom)
#"ser_nameshort" "bio_year"      "bio_length"    "bio_weight"   
# "bio_age"       "bio_g_in_gy"   "bio_comment"  
##############################
# COLNAMES IN TARGET TABLE
##############################
#database_biom <- sqldf("SELECT * FROM datawg.t_biometry_series_bis") # nothing yet
## bio_id => this is a serial no insertion
# bio_lfs_code 
# bio_year 
# bio_length 
# bio_weight 
# bio_age
# bio_perc_female
# bio_length_f 
# bio_weight_f 
# bio_age_f 
# bio_length_m 
# bio_weight_m 
# bio_age_m 
# bio_comment
# bio_last_update => not kept
# bio_qal_id 
# bis_g_in_gy 
# bis_ser_id 


# life stage needs to be collected from series
ser <- sqldf("SELECT * FROM datawg.t_series_ser")
ser <- ser %>% dplyr::select(ser_id,ser_lfs_code,ser_nameshort)

biom2 <- dplyr::inner_join(ser, biom, by="ser_nameshort")
# check that all names are joined by
stopifnot (nrow(biom2)==nrow(biom))
biom2$bio_age <-as.numeric(biom2$bio_age) # all lines empty this creates a crash later
biom3 <- data.frame(# bio_id .... ignored
		bio_lfs_code = biom2$ser_lfs_code,
		bio_year = biom2$bio_year,
		bio_length = biom2$bio_length ,
		bio_weight = biom2$bio_weight ,
		bio_age = biom2$bio_age,
		bio_perc_female = as.numeric(NA),
		bio_length_f = as.numeric(NA),
		bio_weight_f = as.numeric(NA),
		bio_age_f = as.numeric(NA),
		bio_length_m = as.numeric(NA),
		bio_weight_m = as.numeric(NA),
		bio_age_m =as.numeric(NA),
		bio_comment = biom2$bio_comment,
		#bio_last_update 
		bio_qal_id = 19, # until it's validated during wgeel
		bis_g_in_gy = biom2$bio_g_in_gy,
		bis_ser_id  = biom2$ser_id)

# CREATE TEMPORARY TABLE ON THE SERVER
sqldf( str_c("DROP TABLE if exists temp_t_biometry_bio_", country))
sqldf( str_c("CREATE TABLE temp_t_biometry_bio_", country, " AS SELECT * FROM biom3"))

sqldf(str_c("INSERT INTO datawg.t_biometry_series_bis(
						bio_lfs_code,
						--bio_id
						bio_year,
						bio_length,
						bio_weight,
						bio_age,
						bio_perc_female,
						bio_length_f,
						bio_weight_f,
						bio_age_f,
						bio_length_m,
						bio_weight_m,
						bio_age_m,
						bio_comment,
						--bio_last_update 
						bio_qal_id, 
						bis_g_in_gy, 
						bis_ser_id) 
						SELECT * FROM temp_t_biometry_bio_",country,";"))

country <-"PT"
path <- str_c("\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\02 Recuitment Submission 2019/",
		country,"_MINHO_Eel_Data_Call_Annex1_Recruitment.xlsx")


###########################
# INTEGRATING BIOMETRY
##########################

biom<-read_excel(path,sheet="biometry")

##############################
# COLNAMES IN EXCEL TABLE
##############################
# colnames(biom)
#"ser_nameshort" "bio_year"      "bio_length"    "bio_weight"   
# "bio_age"       "bio_g_in_gy"   "bio_comment"  
##############################
# COLNAMES IN TARGET TABLE
##############################
#database_biom <- sqldf("SELECT * FROM datawg.t_biometry_series_bis") # nothing yet
## bio_id => this is a serial no insertion
# bio_lfs_code 
# bio_year 
# bio_length 
# bio_weight 
# bio_age
# bio_perc_female
# bio_length_f 
# bio_weight_f 
# bio_age_f 
# bio_length_m 
# bio_weight_m 
# bio_age_m 
# bio_comment
# bio_last_update => not kept
# bio_qal_id 
# bis_g_in_gy 
# bis_ser_id 


# life stage needs to be collected from series
ser <- sqldf("SELECT * FROM datawg.t_series_ser")
ser <- ser %>% dplyr::select(ser_id,ser_lfs_code,ser_nameshort)

biom2 <- dplyr::inner_join(ser, biom, by="ser_nameshort")
# check that all names are joined by
stopifnot (nrow(biom2)==nrow(biom))
biom2$bio_age <-as.numeric(biom2$bio_age) # all lines empty this creates a crash later
biom2$bio_g_in_gy <-as.numeric(biom2$bio_g_in_gy)
biom3 <- data.frame(# bio_id .... ignored
		bio_lfs_code = biom2$ser_lfs_code,
		bio_year = biom2$bio_year,
		bio_length = biom2$bio_length ,
		bio_weight = biom2$bio_weight ,
		bio_age = biom2$bio_age,
		bio_perc_female = as.numeric(NA),
		bio_length_f = as.numeric(NA),
		bio_weight_f = as.numeric(NA),
		bio_age_f = as.numeric(NA),
		bio_length_m = as.numeric(NA),
		bio_weight_m = as.numeric(NA),
		bio_age_m =as.numeric(NA),
		bio_comment = biom2$bio_comment,
		#bio_last_update 
		bio_qal_id = 19, # until it's validated during wgeel
		bis_g_in_gy = biom2$bio_g_in_gy,
		bis_ser_id  = biom2$ser_id)

# CREATE TEMPORARY TABLE ON THE SERVER
sqldf( str_c("DROP TABLE if exists temp_t_biometry_bio_", country))
sqldf( str_c("CREATE TABLE temp_t_biometry_bio_", country, " AS SELECT * FROM biom3"))

sqldf(str_c("INSERT INTO datawg.t_biometry_series_bis(
						bio_lfs_code,
						--bio_id
						bio_year,
						bio_length,
						bio_weight,
						bio_age,
						bio_perc_female,
						bio_length_f,
						bio_weight_f,
						bio_age_f,
						bio_length_m,
						bio_weight_m,
						bio_age_m,
						bio_comment,
						--bio_last_update 
						bio_qal_id, 
						bis_g_in_gy, 
						bis_ser_id) 
						SELECT * FROM temp_t_biometry_bio_",country,";"))

# ---------------------------------------------------------------------------------------------------------
country <-"ES"
path <- str_c("\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\02 Recuitment Submission 2019/",
		country,"_Eel_Data_Call_Annex1_Recruitment.xlsx")


###########################
# INTEGRATING BIOMETRY
##########################

biom<-read_excel(path,sheet="biometry")

##############################
# COLNAMES IN EXCEL TABLE
##############################
# colnames(biom)
#"ser_nameshort" "bio_year"      "bio_length"    "bio_weight"   
# "bio_age"       "bio_g_in_gy"   "bio_comment"  
##############################
# COLNAMES IN TARGET TABLE
##############################
#database_biom <- sqldf("SELECT * FROM datawg.t_biometry_series_bis") # nothing yet
## bio_id => this is a serial no insertion
# bio_lfs_code 
# bio_year 
# bio_length 
# bio_weight 
# bio_age
# bio_perc_female
# bio_length_f 
# bio_weight_f 
# bio_age_f 
# bio_length_m 
# bio_weight_m 
# bio_age_m 
# bio_comment
# bio_last_update => not kept
# bio_qal_id 
# bis_g_in_gy 
# bis_ser_id 


# life stage needs to be collected from series
ser <- sqldf("SELECT * FROM datawg.t_series_ser")
ser <- ser %>% dplyr::select(ser_id,ser_lfs_code,ser_nameshort)

biom2 <- dplyr::inner_join(ser, biom, by="ser_nameshort")
# check that all names are joined by
stopifnot (nrow(biom2)==nrow(biom))
biom2$bio_age <-as.numeric(biom2$bio_age) # all lines empty this creates a crash later
biom2$bio_g_in_gy <-as.numeric(biom2$bio_g_in_gy)
biom3 <- data.frame(# bio_id .... ignored
		bio_lfs_code = biom2$ser_lfs_code,
		bio_year = biom2$bio_year,
		bio_length = biom2$bio_length ,
		bio_weight = biom2$bio_weight ,
		bio_age = biom2$bio_age,
		bio_perc_female = as.numeric(NA),
		bio_length_f = as.numeric(NA),
		bio_weight_f = as.numeric(NA),
		bio_age_f = as.numeric(NA),
		bio_length_m = as.numeric(NA),
		bio_weight_m = as.numeric(NA),
		bio_age_m =as.numeric(NA),
		bio_comment = biom2$bio_comment,
		#bio_last_update 
		bio_qal_id = 19, # until it's validated during wgeel
		bis_g_in_gy = biom2$bio_g_in_gy,
		bis_ser_id  = biom2$ser_id)

# CREATE TEMPORARY TABLE ON THE SERVER
sqldf( str_c("DROP TABLE if exists temp_t_biometry_bio_", country))
sqldf( str_c("CREATE TABLE temp_t_biometry_bio_", country, " AS SELECT * FROM biom3"))

sqldf(str_c("INSERT INTO datawg.t_biometry_series_bis(
						bio_lfs_code,
						--bio_id
						bio_year,
						bio_length,
						bio_weight,
						bio_age,
						bio_perc_female,
						bio_length_f,
						bio_weight_f,
						bio_age_f,
						bio_length_m,
						bio_weight_m,
						bio_age_m,
						bio_comment,
						--bio_last_update 
						bio_qal_id, 
						bis_g_in_gy, 
						bis_ser_id) 
						SELECT * FROM temp_t_biometry_bio_",country,";"))



#	2020 INSERTION OF STATIONS : Esti & Cedric
#----------------------------------------------------

#first run global.R shiny data integration
require(getPass)
path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wgeel\\stations.xlsx"
station <- read_excel(path,sheet=2)
con_wgeel=dbConnect(PostgreSQL(),
		dbname="wgeel",
		host="localhost",
		port=5435,
		user= getPass(msg="username"),
		password= getPass())
query='SELECT * FROM ref.tr_station'
stationdb = dbGetQuery(con_wgeel,query)
stationdb$Station_Name %in%station$ser_nameshort
stationdb$Station_Name[!stationdb$Station_Name %in%station$ser_nameshort]
query = 'SELECT t_series_ser.*, cou_country FROM datawg.t_series_ser JOIN ref.tr_country_cou on cou_code=ser_cou_code '
series <- dbGetQuery(con_wgeel,query)

station$ser_nameshort[!station$ser_nameshort %in%stationdb$Station_Name]
query = "SELECT ser_id, 
		ser_nameshort, ser_namelong, ser_typ_id, 
		ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code,
		ser_locationdescription, ser_emu_nameshort, ser_cou_code,
		ser_area_division,  ser_x, ser_y, 
		cou_country, 
		min(das_year) as StartYear
		FROM datawg.t_series_ser 
		JOIN ref.tr_country_cou on cou_code=ser_cou_code
		LEFT JOIN datawg.t_dataseries_das on das_ser_id=ser_id
		group by ser_id, 
		ser_nameshort, ser_namelong, ser_typ_id, 
		ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code,
		ser_locationdescription, ser_emu_nameshort, ser_cou_code,
		ser_area_division,  ser_x, ser_y, 
		cou_country"


series <- dbGetQuery(con_wgeel,query)

station2 <- left_join(station,series, by="ser_nameshort")

new <- anti_join(station2,stationdb,by=c("ser_nameshort"="Station_Name"))
# remove missing ones

str(stationdb)
str(new)
new$tblCodeID <- seq(from=18000,by=1,length.out=nrow(new))
new$Station_Code <- NA
new$Country <-toupper(new$cou_country)
new[is.na(new$Country),]
new$Lat <- new$ser_y
new$Lon <- new$ser_x
new$PURPM <- 'S~T'
new$WLTYP<- NA
new$Notes <- new$ser_comment
new$Station_Name <- new$ser_nameshort
new$StartYear <- new$startyear
new$EndYear <- NA
stationtemp <- new[,c("tblCodeID", "Station_Code", "Country", "Organisation", "Station_Name", "WLTYP", 
						"Lat", "Lon", "StartYear", "EndYear", "PURPM", "Notes" )]
dbExecute(con_wgeel,"drop table if exists stationtemp")
dbWriteTable(con_wgeel, "stationtemp", stationtemp) 


# run this straight in sql see database_edition_2020
dbExecute(con_wgeel,'
INSERT INTO ref.tr_station(
		"tblCodeID",  "Country", "Organisation", "Station_Name", "WLTYP", 
		"Lat", "Lon", "StartYear",  "PURPM", "Notes"
)

SELECT 
"tblCodeID",  "Country", "Organisation", "Station_Name", "WLTYP", 
"Lat", "Lon", "StartYear",  "PURPM", "Notes"
FROM stationtemp;


UPDATE datawg.t_series_ser SET ser_tblcodeid = "tblCodeID"
FROM ref.tr_station
WHERE tr_station."Station_Name"=ser_nameshort; ')

# remaining series without station :
dbGetQuery(con_wgeel,"SELECT * FROM datawg.t_series_ser WHERE ser_tblcodeid IS NULL;")




#2021------------------------
require(getPass)
library(readxl) # to read xls files
library(stringr) # this contains utilities for strings
require(sqldf) # to run queries
require(RPostgreSQL)# to run queries to the postgres database

path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2021\\WGEEL\\series_inclusion.xlsx"
series_inclusion <- read_excel(path,sheet=1)
con_wgeel=dbConnect(PostgreSQL(),
		dbname="wgeel",
		host=getPass(msg="host"),
		port=5432,
		user= getPass(msg="username"),
		password= getPass(msg="pwd"))
dbExecute(con_wgeel,"DROP table series_inclusion_temp")
dbWriteTable(con_wgeel,'series_inclusion_temp',series_inclusion)
dbExecute(con_wgeel,"UPDATE datawg.t_seriesglm_sgl s set sgl_year= st.sgl_year FROM
series_inclusion_temp st
where s.sgl_ser_id=st.sgl_ser_id
")#93
