# fetch data from the WGEEL database
# 
# Author: lbeaulaton
###############################################################################

# PostgreSQL connection (if needed)
if(is.null(options()$sqldf.RPostgreSQL.dbname)) source("R/database_interaction/database_connection.R")

#' @title Extract data table/view from WGEEL database
#' @description Extract data from WGEEL database
#' @param table_caption
#' @param from_database should the data be loaded from the database? if not from a csv file
#' @examples
#' extract_data("Landings")
extract_data = function(data_needed, from_database=TRUE, quality = c(1,2,4), quality_check=TRUE)
{
  	
	
    if (from_database){
	# give the correspondance by "human readable" name and table/view name
	list_data_table = data.frame(data_needed = 
            c("Landings", "Aquaculture", "Release", "B0", "Bbest", "Bcurrent", "Sigma A",
                 "Sigma F", "Sigma H", "Potential available habitat", "Mortality in Silver Equivalents", 
                 "Sigma F all", "Sigma H all", "PrecoData Country", "PrecoData EMU","PrecoData All"), 
         table_dbname = c("landings", "aquaculture", "release", "b0", "bbest", "bcurrent", "sigmaa", 
             "sigmaf", "sigmah", "potential_available_habitat","silver_eel_equivalents", "sigmafallcat", 
             "sigmahallcat", "precodata_country", "precodata_emu","precodata_all"))
	
	# check that the caption is recognised
	if(sum(data_needed %in% list_data_table$data_needed) == 0)
		stop(paste("table_caption should be one of:", paste(list_data_table$data_needed, collapse = ", ")))
	if (quality_check)	{
	sql_request = glue_sql(paste("SELECT * FROM datawg.", list_data_table[list_data_table$data_needed == data_needed, "table_dbname"], " WHERE eel_qal_id IN ({quality*})", sep = ""))
  } else {
	  sql_request = paste0("SELECT * FROM datawg.", list_data_table[list_data_table$data_needed == data_needed, "table_dbname"]) 
  }
		return(sqldf(sql_request))
  } else {
    if(!exists(data_directory)) 
	  data_directory <- tk_choose.dir(caption = "Data directory", default = mylocalfolder)
	data <- read.table(file=str_c(data_directory,"/",list_data_table[list_data_table$data_needed == data_needed, "table_dbname"],".csv"),sep=";")
  }  
}