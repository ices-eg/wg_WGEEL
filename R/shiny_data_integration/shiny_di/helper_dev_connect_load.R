# this script mimics what the shiny loads, usefull to test loading_functions without stepping into the shiny
# Author: cedricbriandgithub 2022
###############################################################################

setwd("C:\\workspace\\wg_WGEEL\\R\\shiny_data_integration\\shiny_di")
source("global.R")
# Define pool handler by pool on global level these are defined in global.R
pool <- pool::dbPool(drv = RPostgres::Postgres(),
		dbname="wgeel",
		host=host,
		port=port,
		user= userwgeel,
		password= passwordwgeel,
		bigint="integer",
		minSize = 0,
		maxSize = 2)

load_database <- function(){

					query <- "SELECT column_name
							FROM   information_schema.columns
							WHERE  table_name = 't_eelstock_eel'
							ORDER  BY ordinal_position"
					t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
					t_eelstock_eel_fields <<- t_eelstock_eel_fields$column_name
					
					query <- "SELECT column_name
							FROM   information_schema.columns
							WHERE  table_name = 't_dataseries_das'
							ORDER  BY ordinal_position"
					t_dataseries_das_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
					t_dataseries_das_fields <<- t_dataseries_das_fields$column_name
					
					query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
					list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
					list_country <- list_countryt$cou_code
					names(list_country) <- list_countryt$cou_country
					list_country<<-list_country
					
					query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
					tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
					typ_id <- tr_typeseries_typt$typ_id
					
					
					
					query <- "SELECT distinct ser_nameshort from datawg.t_series_ser"
					tr_series_list <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   

					tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
					names(typ_id) <- tr_typeseries_typt$typ_name

					# tr_type_typ<-extract_ref('Type of series') this works also !
					tr_typeseries_typt<<-tr_typeseries_typt
					
#					#205-shiny-integration-for-dcf-data TODO CHECK IF USED
#					query <- "SELECT distinct sai_id FROM datawg.t_samplinginfo_sai"
#					tr_sai_list <- dbGetQuery(pool, sqlInterpolate(ANSI(), query)) 
#					isolate({data$sai_list <- tr_sai_list$ser_id})
#					
#					#205-shiny-integration-for-dcf-data
#					query <- "SELECT * from ref.tr_metricstype_mty"
#					tr_metricstype_mty <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))
#					
					#205-shiny-integration-for-dcf-data

					query <- "SELECT * from ref.tr_units_uni"
					tr_units_uni <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
					
					
					query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel"
					the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
				
					
					query <- "SELECT name from datawg.participants order by name asc"
					participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
					
					ices_division <<- suppressWarnings(extract_ref("FAO area", pool)$f_code)
# TODO CEDRIC 2021 remove geom from extract_ref function so as not to get a warning						
					emus <<- suppressWarnings(extract_ref("EMU", pool))
# TODO CEDRIC 2021 remove geom from extract_ref function so as not to get a warning			
}
load_database()