# connection to WGEEL database
# 
# Author: lbeaulaton
###############################################################################

# load requested packages
if(!exists("load_library")) source("R/utilities/load_library.R")
load_library(c("sqldf", "RPostgreSQL", "getPass"))

# a fonction to get information
getInformation = function(prompt)
{
	print(prompt)
	return(info = scan(what = character(), n = 1, quiet=TRUE))
}

user = getInformation("PostgreSQL user")

# changement vers la base de donnees
options(sqldf.RPostgreSQL.user = user,  
		sqldf.RPostgreSQL.password = getPass(),
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost", #getInformation("PostgreSQL host: if local ==> localhost"), 
		sqldf.RPostgreSQL.port = 5432)


