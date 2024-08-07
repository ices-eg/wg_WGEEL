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

if (!exists("cred")){
cred=read_yaml("../../../credentials.yml")
}
host=cred$host
port=cred$port
user=cred$user
dbname=cred$dbname
password=cred$password
if (is.null(password)) password=getPass("pass for wgeel")

  options(sqldf.RPostgreSQL.user = user,  
          sqldf.RPostgreSQL.password = password,
          sqldf.RPostgreSQL.dbname = dbname,
          sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
          sqldf.RPostgreSQL.port = port)


# options for PostgresSQL



