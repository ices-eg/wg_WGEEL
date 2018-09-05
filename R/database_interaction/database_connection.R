# connection to WGEEL database
# 
# Author: lbeaulaton 
###############################################################################
# include the following in your script if you want to have a propoer connection to the WGEEL database
#source("/R/database_interaction/database_connection.R")

# needs to be run from source
# load requested packages

load_library("getPass")
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
if(Sys.info()[["user"]] == "cedric.briand")
{ #Cedric's special configuration
	user<-userlocal
	pwd<-passwordlocal
} else {
	if (exists("userlocal")) user<-userlocal else user<-getPass("Enter the USER: ")
	if (exists("passwordlocal")) pwd<-passwordlocal else pwd<-getPass()
}

# options for PostgresSQL
options(sqldf.RPostgreSQL.user = user,  
		sqldf.RPostgreSQL.password = pwd,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost", #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = 5432)


