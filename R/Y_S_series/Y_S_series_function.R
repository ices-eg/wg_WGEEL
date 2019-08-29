# Y_S_series_function.R
# provisional script to integrated 2019 data call yellow and silver eel series
# TODO: to integrate this in the shiny app
###############################################################################

#' extract data from the excel file
#' 
#' @param country the name of the country folder
#' @param type_series name of the life stage you want to examine. Should be one of: "Yellow_Eel", "Silver_Eel"
#'
#' @return a list containing tibbles for data (meta, series_info, data and biom)
retrieve_data = function(country, type_series = "wrong")
{
	# check the type_series
	if(!(type_series %in% c("Yellow_Eel", "Silver_Eel")))
		stop("Chose right series' type")
	
	# check for existing files
	country_file = list.files(str_c(wd_file_folder, "/", country), type_series)
	if(length(country_file) == 0)
	{
		warning("No Yellow eel file")
		return(NULL)
	}
	
	country_data = list()
	# read the file
	country_data$meta = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="metadata", range = "B10:C50", col_names = FALSE) # I put a rather large range
	colnames(country_data$meta) = c("ser_nameshort", "ser_comment")
	country_data$meta = country_data$meta %>% filter(!is.na(ser_nameshort)) # I adjust to availaible data
	country_data$series_info = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="series_info")
	country_data$data = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="data")
	country_data$biom = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="biometry")
	
	return(country_data)
}

#' check if the series have already been created
#' 
#' @param series_info the tibble from the excel file
#' @paral ser_db list of series in the database
#'
#' @return a list with existing series (incl. the database ser_id) and series to be created
check_series = function(series_info, ser_db)
{
	# serie type ?
	ser_typ = series_info %>% select(ser_typ_id) %>% distinct() %>% pull()
	# check for unique type
	if(length(ser_typ) > 1)
		stop("You have different type of series in your file")
	
	# add row number to series_info
	series_info = series_info %>% mutate(nrow = row_number())
	
	#chek for already existing series
	existing_series = inner_join(series_info %>% select(nrow, ser_typ_id, ser_lfs_code, ser_nameshort), ser_db %>% select(ser_id, ser_typ_id, ser_lfs_code, ser_nameshort))
	to_be_created_series = anti_join(series_info %>% select(nrow, ser_typ_id, ser_lfs_code, ser_nameshort), ser_db %>% select(ser_id, ser_typ_id, ser_lfs_code, ser_nameshort))
	
	print(str_c("existing series: ", nrow(existing_series)))
	print(str_c("series to be created: ", nrow(to_be_created_series)))
	
	return(list(existing_series = existing_series, to_be_created_series = to_be_created_series))
}

#' create new series
#' 
#' @param series_info the tibble from the excel file
#' @param meta metadata associated to the series
#'
#' @return the ser_id of the new series
create_series = function(series_info, meta)
{
	if(nrow(series_info) == 0)
	{
		stop("No series to insert!")
	}
		
	
	series_info$ser_comment = str_c(meta$ser_comment, " | ", series_info$ser_comment)
	
	# insert data in the database 
	sqldf('INSERT INTO datawg.t_series_ser (ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y, ser_order) SELECT *, 999 FROM series_info;')
	
	
	# retrieve le ser_id for further use
	new_ser_id = sqldf("SELECT ser_id FROM datawg.t_series_ser JOIN series_info USING(ser_nameshort)")
	
	# update geom column
	sqldf("UPDATE datawg.t_series_ser SET geom = ST_GeomFromText('POINT('||ser_x||' '||ser_y||')',4326) FROM new_ser_id WHERE t_series_ser.ser_id = new_ser_id.ser_id;")
	
	
	return(new_ser_id %>% pull())
}

#' gather old and new series
#' 
#' @param old_series
#' @param new_series
#'
#' @return the gatehred series
gather_series = function(old_series, new_series)
{
	if(nrow(old_series) == 0)
		return(new_series)
	if(nrow(new_series) == 0)
		return(old_series)
	return(dplyr::union(old_series, new_series))
}

#' check if data series have already been created
#' 
#' @param dataseries the tibble from the excel file
#' @paral ser_data list of data series in the database
#'
#' @return a list with existing data series (incl. the database das_id) and data series to be created
check_dataseries = function(dataseries, ser_data)
{
	# add row number to dataseries
	dataseries = dataseries %>% mutate(nrow = row_number())
	
	#chek for already existing series
	existing_data = inner_join(dataseries, ser_data %>% select(das_id, das_ser_id, das_year, das_value, das_effort, das_comment), by = c("ser_id" = "das_ser_id", "das_year" = "das_year"), suffix = c(".xl", ".base"))
	to_be_created_data = anti_join(dataseries, ser_data %>% select(das_ser_id, das_year), by = c("ser_id" = "das_ser_id", "das_year" = "das_year"))
	
	print(str_c("existing series: ", nrow(existing_data)))
	print(str_c("series to be created: ", nrow(to_be_created_data)))
	
	return(list(existing_series = existing_data, to_be_created_series = to_be_created_data))
}

#' check if data series should be updated
#' 
#' @param dataseries the tibble from the excel file
#' @paral ser_data list of data series in the database
#'
#' @return data to be updated
check_dataseries_update = function(dataseries)
{
	#chek for das_value
	updated_dataseries = dataseries %>% mutate(updated_value = das_value.xl != das_value.base, updated_effort = das_effort.xl != das_effort.base, updated_comment = das_comment.xl != das_comment.base)
	
	print(str_c("updated value: ", sum(updated_dataseries$updated_value)))
	print(str_c("updated effort: ", sum(updated_dataseries$updated_effort)))
	print(str_c("updated comment: ", sum(updated_dataseries$updated_comment)))
	
	return(list(updated_value = updated_dataseries %>% filter(updated_value), updated_effort = updated_dataseries %>% filter(updated_effort), updated_comment = updated_dataseries %>% filter(updated_comment)))
}

#' insert new data series
#' 
#' @param dataseries the tibble from the excel file
#'
#' @return the das_id of the new dataseries
insert_dataseries = function(dataseries)
{
	# insert data in the database 
	sqldf('INSERT INTO datawg.t_dataseries_das (das_value, das_ser_id, das_year, das_comment, das_effort) SELECT * FROM dataseries;')
	
	# retrieve le ser_id for further use
	return(sqldf("SELECT das_id FROM datawg.t_dataseries_das, dataseries WHERE das_ser_id = ser_id AND t_dataseries_das.das_year = dataseries.das_year") %>% pull())
}


