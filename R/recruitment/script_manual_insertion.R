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
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/stock_assessment/")
wd<-getwd()


options(sqldf.RPostgreSQL.user = "postgres", 
	sqldf.RPostgreSQL.password = passwordlocal,
	sqldf.RPostgreSQL.dbname = "wgeel",
	sqldf.RPostgreSQL.host = "localhost",
	sqldf.RPostgreSQL.port = 5432)

# this is where I store the xl files
datawd<-"C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall/Germany/"

# read data from xl file
series_info<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment.xlsx"), sheet="series_info")
series_info<-series_info[!series_info$ser_nameshort=='Ems',] # remove ems already in
# series are ordered from North to South
# Ems is currently 19
# so I'm inserting 14 new numbers....
# RUN ONCE ONLY
#sqldf("update datawg.t_series_ser set ser_order=ser_order+14 where ser_order>19;")

series_info$ser_order=20:33
series_info<-series_info[,c(19,1:18)]
series_info$ser_tblcodeid<-NULL
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
  ser_habitat_name, 
  ser_emu_nameshort, 
  ser_cou_code, 
  ser_area_division,
  --ser_tblcodeid,
  ser_x, 
  ser_y, 
  ser_sam_id,
  ser_qal_id,
  ser_qal_comment) SELECT * from series_info;")

#---------------------------
# script to integrate series one by one (only one saved)
#-------------------------------------
sqldf("select ser_nameshort from datawg.t_series_ser where ser_cou_code='DE'")
#1            Emsx
#2           Verlx
#3            HHKx
#4            HoSx
#5           Brokx
#6           Langx
#7           WaSGx
#8           WaSEx
#9           Farpx
#10          WiFGx
#11          WisWx
#12          DoFpx
#13          DoElx
#14          EmsHx
#15          EmsBx
series<-read_excel(path=str_c(datawd,"Eel_Data_Call_Annex1_Recruitment.xlsx"), sheet="data_EmsB")
ser_id<-sqldf("select ser_id from datawg.t_series_ser where ser_nameshort='EmsB'")
series$das_ser_id<-as.numeric(ser_id)
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

