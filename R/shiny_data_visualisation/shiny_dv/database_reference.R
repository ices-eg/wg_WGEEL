# Fetch reference tables from the database
# 
# Author: lbeaulaton
###############################################################################

# PostgreSQL connection (if needed)
#if(is.null(options()$sqldf.RPostgreSQL.dbname)) source("R/database_interaction/database_connection.R")

#' @title Extract reference table from WGEEL database
#' @description Extract reference table from WGEEL database to be sure to used the very last reference codes
#' @param table_caption the table you need to extract
#' @examples
#' extract_ref("Life stage")
extract_ref = function(table_caption)
{
	# give the correspondance by "human readable" name and table name in the database
	list_ref_table = data.frame(table_caption =c("Country", "EMU", "FAO area", "Habitat type", "ICES ecoregion", "Life stage", "Quality", "Sampling type", "Sea", "Station", "Type of series", "Unit") , table_dbname = c("tr_country_cou", "tr_emu_emu", "tr_faoareas", "tr_habitattype_hty", "tr_ices_ecoregions", "tr_lifestage_lfs", "tr_quality_qal", "tr_samplingtype_sam", "tr_sea_sea", "tr_station", "tr_typeseries_typ", "tr_units_uni"))
	list_ref_table = list_ref_table[order(list_ref_table$table_caption), ]
	
	# check that the caption is recognised
	if(sum(table_caption %in% list_ref_table$table_caption) == 0)
		stop(paste("table_caption should be one of: ", paste(list_ref_table$table_caption, collapse = ", ")))
	sql_request = paste("SELECT * FROM ref.", list_ref_table[list_ref_table$table_caption == table_caption, "table_dbname"], sep = "")
	data_to_return = dbGetQuery(con_wgeel,sql_request)
	
	# deleting the geom column
	if(sum(names(data_to_return) %in% "geom") > 0)
		data_to_return = data_to_return[,!(names(data_to_return) %in% "geom")]
	return(data_to_return)
}
