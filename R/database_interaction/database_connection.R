# connection to WGEEL database
# 
# Author: lbeaulaton
###############################################################################
# needs to be run from source
# load requested packages
if(!exists("load_library")) source("R/utilities/load_library.R")
load_library(c("sqldf", "RPostgreSQL", "getPass"))

# options for PostgresSQL
options(sqldf.RPostgreSQL.user = getPass("Enter the USER: "),  
		sqldf.RPostgreSQL.password = getPass(),
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost", #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = 5432)


