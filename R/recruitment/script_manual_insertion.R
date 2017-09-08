# script_manual_insertion.R
# Use this script if you have a lot of data to put to the database
###############################################################################


# here is a list of the required packages
library(readxl) # to read xls files
library(stringr) # this contains utilities for strings
require(sqldf) # to run queries
require(RPostgreSQL)# to run queries to the postgres database

# clean up directory except for my password
obj<-ls(all=TRUE)
obj<-obj[!obj%in%c("passworddistant","passwordlocal")]
rm(list=obj) 

# set working directory
 setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/stock_assessment/")


options(warn=-1)
options(sqldf.RPostgreSQL.user = "postgres", 
	sqldf.RPostgreSQL.password = passwordlocal,
	sqldf.RPostgreSQL.dbname = "wama",
	sqldf.RPostgreSQL.host = "localhost",
	sqldf.RPostgreSQL.port = 5432)

# this is where I store the xl files
datawd<-"C:/workspace/wgeeldata/recruitment/2017/xl/"

