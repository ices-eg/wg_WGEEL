# connection to WGEEL database
# 
# Author: lbeaulaton 
###############################################################################
# needs to be run from source
# load requested packages

load_library(c("sqldf", "RPostgreSQL", "getPass"))
# to save time (not repeating again and again the password)
# I save variables in Rprofile.site as following
# this will be launched with R
#------------------------------
# R\R-X.X.X\etc\Rprofile.site
#.First <- function(){
#userlocal<<-"xxxx"
#passwordlocal<<-"xxxxxx"
#passworddistant<<-"xxxxxx"
#cat("Created passwords passwordlocal passworddistant", date(), "\n") 
#}
#-------------------------------
# uncomment to loose time and gain portability
user<-userlocal
pwd<-passwordlocal
#if (exists("userlocal")) user<-userlocal else user<-getPass("Enter the USER: ")
#if (exists("passwordlocal")) pwd<-passwordlocal else pwd<-getPass()
# options for PostgresSQL
options(sqldf.RPostgreSQL.user = user,  
		sqldf.RPostgreSQL.password = pwd,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost", #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = 5432)


