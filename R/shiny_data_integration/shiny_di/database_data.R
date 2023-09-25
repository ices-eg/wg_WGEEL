# fetch data from the WGEEL database
# 
# Author: lbeaulaton modified 2020 cedric
###############################################################################

# PostgreSQL connection (if needed)
#if(is.null(options()$sqldf.RPostgreSQL.dbname)) source("R/database_interaction/database_connection.R")

#' @title Extract data table/view from WGEEL database
#' @description Extract data from WGEEL database
#' @param quality The quality selected for view
#' @param quality_check is the view loaded using only quality needed for wgeel (discarded data excluded)
#' @examples
#' extract_data("landings")
#' extract_data("t_series_ser")
extract_data = function(table_dbname, quality = c(0,1,2,4), quality_check=TRUE, allow_NULL=FALSE)
{
  
  
  # creates a dataframe containing different names for qal column.
  # table_dbname corresponds to the name of a table or a view
  
  
  df_table = data.frame(
      table_dbname = c("landings", "aquaculture", "release", "b0", "bbest", "bcurrent", "sigmaa", 
          "sigmaf", "sigmah", "potential_available_habitat","silver_eel_equivalents", "sigmafallcat", 
          "sigmahallcat", "precodata_country", "precodata_emu","precodata_all",
          "t_dataseries_das", "t_series_ser","t_metricgroupseries_megser", "t_metricgroupsamp_megsa",
          "t_metricindseries_meiser", "t_metricindsamp_meisa","t_samplinginfo_sai","t_groupseries_grser", "t_groupsamp_grsa",
          "t_fishseries_fiser","t_fishsamp_fisa"),
      qal_column=c(rep("eel_qal_id",16), "das_qal_id", "ser_qal_id", rep("meg_qal_id",2) , rep("mei_qal_id",2), "sai_qal_id",rep("",4))
  )
  
  
  # check that the table dbname is in the list above
  if(sum(table_dbname %in% df_table$table_dbname) == 0)
    stop(paste("table_caption should be one of:", paste(df_table$table_dbname, collapse = ", ")))
  
  if (quality_check )	{
    qal_column <- df_table[df_table$table_dbname == table_dbname, "qal_column"]
    if (qal_column=="") stop(sprintf("You cannot perform quality check on table %s please use quality_check=FALSE",table_dbname))
    if (allow_NULL){
      sql_request = glue_sql(paste("SELECT * FROM datawg.", table_dbname,
              " WHERE ",qal_column," IN ({quality*}) OR ", qal_column, " IS NULL", sep = ""))
    } else {
      sql_request = glue_sql(paste("SELECT * FROM datawg.", table_dbname,
              " WHERE ",qal_column," IN ({quality*})", sep = ""))
    }
  } else {
    sql_request = paste0("SELECT * FROM datawg.",table_dbname) 
  }
  return(dbGetQuery(pool,sql_request))
  
}




