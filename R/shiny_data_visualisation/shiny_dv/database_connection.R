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


port <- 5435
host <- "localhost"#"192.168.0.100"

# remove this so as not to upset Laurent
if (Sys.info()[["user"]]!="cedric.briand"){
	stop("please change lines in database_connection lines 31 32,
					this connection is currently set to Cedric to save his time")
} else {
	userwgeel <-"wgeel"
	passwordwgeel<-"wgeel"
}

if (exists("userwgeel")) 
{ #Cedric's special configuration
	user <-userwgeel
	if (!exists("passwordwgeel")) stop("There should be a passwordwgeel")
	pwd <- passwordwgeel
	options(sqldf.RPostgreSQL.user = user,  
			sqldf.RPostgreSQL.password = pwd,
			sqldf.RPostgreSQL.dbname = "wgeel",
			sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
			sqldf.RPostgreSQL.port = port)
} else {
	user<-getPass("Enter the USER: ")
	pwd<-getPass()
	options(sqldf.RPostgreSQL.user = user,  
			sqldf.RPostgreSQL.password = pwd,
			sqldf.RPostgreSQL.dbname = "wgeel",
			sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
			sqldf.RPostgreSQL.port = port)
}

# options for PostgresSQL



