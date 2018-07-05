# connection to WGEEL database
# 
# Author: lbeaulaton
###############################################################################
# needs to be run from source
# load requested packages
if(!exists("load_library")) source("R/utilities/load_library.R")
load_library(c("sqldf", "RPostgreSQL", "getPass"))

# a fonction to get information
#getInformation = function(prompt)
#{
#	print(prompt)
#	return(info = scan(what = character(), n = 1, quiet=TRUE))
#}

#user = getInformation("PostgreSQL user")

# options for PostgresSQL
options(sqldf.RPostgreSQL.user = "postgres",#getPass("Enter the USER: "),  
		sqldf.RPostgreSQL.password = "postgres",#getPass(),
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost", #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = 5432)


