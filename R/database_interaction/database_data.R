# fetch data from the WGEEL database
# 
# Author: lbeaulaton
###############################################################################

# PostgreSQL connection (if needed)
if(options()$sqldf.RPostgreSQL.dbname != "wgeel") source("R/database_interaction/database_connection.R")

#' @title Extract data table/view from WGEEL database
#' @description Extract data from WGEEL database
#' @param table_caption
#' @examples
#' extract_data("Catches and landings")
extract_data = function(data_needed)
{
	# give the correspondance by "human readable" name and table/view name
	list_data_table = data.frame(data_needed = c("Catches and landings", "Aquaculture", "Restocking"), table_dbname = c("catch_landings", "aquaculture", "stocking"))
	
	# check that the caption is recognised
	if(sum(data_needed %in% list_data_table$data_needed) == 0)
		stop(paste("table_caption should be one of: ", list_data_table$data_needed))
	sql_request = paste("SELECT * FROM datawg.", list_data_table[list_data_table$data_needed == data_needed, "table_dbname"], sep = "")
	return(sqldf(sql_request))
}