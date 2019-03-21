# Name : load_data_from_database.R
# Date : 21/03/2019
# Author: cedric.briand
###############################################################################


load_package("RPostgreSQL")
load_package("sqldf")
load_package("glue")
if(is.null(options()$sqldf.RPostgreSQL.user)) 
source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")