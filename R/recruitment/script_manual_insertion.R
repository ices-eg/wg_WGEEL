# script_manual_insertion.R
# Use this script if you have a lot of data to put to the database
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
datawd<-"C:/workspace/wgeeldata/recruitment/2017/xl/"

# read data from xl file
bann<-read_excel(path=str_c(datawd,"GB2017 D Evans plus historic.xls"), sheet="Bann")
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
	        where ser_nameshort='Bann'
			order by das_year")
#TODO finish here....
index_remove <- curennt
sqldf("")
