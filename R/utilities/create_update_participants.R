# Name : create_update_participants.R
# see issue https://github.com/ices-eg/wg_WGEEL/issues/20
# need a login for particpants
# Date : 30/07/2018
# Author: cedric.briand
###############################################################################
load_package <- function(x)
{
  if (!is.character(x)) stop("Package should be a string")
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}
load_package("RPostgreSQL")
load_package("sqldf")
options(sqldf.RPostgreSQL.user = "postgres", 
	sqldf.RPostgreSQL.password = passwordlocal,
	sqldf.RPostgreSQL.dbname = "wgeel",
	sqldf.RPostgreSQL.host = "localhost", # "localhost"
	sqldf.RPostgreSQL.port = 5432)
library(readxl)
participants <- read_excel("C:/Users/cedric.briand/Desktop/06. Data/datacall(wgeel_2018)/participants.xlsx")
sqldf("create table datawg.participants as select * from participants")
