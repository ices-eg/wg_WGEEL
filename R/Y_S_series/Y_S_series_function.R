# Y_S_series_function.R
# provisional script to integrated 2019 data call yellow and silver eel series
# TODO: to integrate this in the shiny app
###############################################################################

#' customize identical function to test line by line
#' 
#' @param x, y the 2 vectors to compare
#'
#' @return boolean
f_identical = function(x, y, ...){
	if(length(x) != length(y)) stop("No the same length")
	result = logical(length(x))
	for(i in 1:length(x))
		result[i] = identical(x[i], y[i], ...)
	return(result)
}


#' convert to numeric and round it
#' 
#' @param x
#' @param nb of decimal
#'
#' @return the numeric
convert_round = function(x, digits = 6)
{
	return(as.numeric(round(x, digits)))
}


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
		warning(str_c("No ", type_series, " file"))
		return(NULL)
	}
	
	if(length(country_file) > 1)
	{
		warning(str_c("Too many ", type_series, " file"))
		return(NULL)
	}
	
	country_data = list()
	# read the file
	country_data$meta = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="metadata", range = "B10:C120", col_names = FALSE) # I put a rather large range
	colnames(country_data$meta) = c("ser_nameshort", "ser_comment")
	country_data$meta = country_data$meta %>% filter(!is.na(ser_nameshort)) # I adjust to availaible data
	
	country_data$series_info = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="series_info")
	country_data$series_info = country_data$series_info %>% filter(!is.na(ser_nameshort)) # I adjust to availaible data
	
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

#' check if series should be updated
#' 
#' @param dataseries the tibble from the excel file
#' @paral ser_db list of data series in the database
#'
#' @return data to be updated
check_series_update = function(series, ser_db)
{
	#chek for das_value
	# use identical instead of == because of NA
	updated_series = inner_join(series, ser_db, by = "ser_nameshort", suffix = c("_xl", "_base"))
	result = list()
	for(col_name in colnames(series %>% select(-ser_nameshort)))
	{
		vars = str_c(col_name, c("_xl", "_base"))
		result[["by_column"]][[col_name]] = updated_series %>% select(vars) %>%	mutate_all(as.character) %>%	mutate_all(type.convert, as.is = TRUE) %>%	mutate(!!str_c("updated_", col_name) := !f_identical(.data[[vars[1]]], .data[[vars[2]]], ))
	}
	
	result[["synthesis"]] = unlist(lapply(result[["by_column"]], function(x) {sum(as.numeric(x[,3] %>% pull()))>0}))
	
	return(result)
}

#' show column the can be updated
#' 
#' @param updated_series from check_series_update
#'
#' @return nice table
show_series_update = function(updated_series){
	
	if(nrow(updated_series[["by_column"]][[1]]) == 1)
	{
		result = matrix(unlist(lapply(updated_series[["by_column"]], function(x) x[, c(1,2)])), ncol = 2, byrow = TRUE)[updated_series$synthesis,]
		row.names(result) = names(updated_series$synthesis)[updated_series$synthesis]
		colnames(result) = c("xl", "base")
	} else {
		n_series = nrow(updated_series[["by_column"]][[1]])
		nom_series = updated_series[["by_column"]][[1]][,2] %>% pull()
		col_names = names(updated_series[["by_column"]])[updated_series[["synthesis"]]]
		result = array(dim = c(length(col_names), 3, n_series), dimnames = list(col_names, c("xl", "base", "updated"), nom_series))
		for(var in col_names)
			result[var, ,] = t(updated_series[["by_column"]][[var]] %>% mutate_all(as.character))
	}
	
	return(result)
}

#' update series
#' 
#' @param updated_series
#'
#' @return just update the series
update_series = function(series_info, show_updated_series = NULL, all = FALSE, icountry = country){
# TODO: add a parameter to select line / column to update (in case you don't want to update all)
	column_to_update = dimnames(show_updated_series)[[1]]
	if(all){
		query_set = paste(column_to_update, " = temp_", tolower(icountry), "_series_info.", column_to_update, sep = "", collapse = ", ")
		wgeel_execute(str_c("UPDATE DATAWG.t_series_ser SET ", query_set, " FROM temp_", tolower(icountry), "_series_info WHERE t_series_ser.ser_id = temp_", tolower(icountry), "_series_info.ser_id;"), extra_data = "series_info",  country = tolower(icountry), environment = environment())
		
		# check for update on coordinate 
		if((sum(grepl("ser_x", column_to_update)) + sum(grepl("ser_y", column_to_update))) > 0)
		{
			new_ser_id = wgeel_query(str_c("SELECT t_series_ser.ser_id FROM datawg.t_series_ser JOIN temp_", tolower(icountry), "_series_info USING(ser_nameshort)"))
			wgeel_execute(str_c("UPDATE datawg.t_series_ser SET geom = ST_GeomFromText('POINT('||ser_x||' '||ser_y||')',4326) FROM temp_", tolower(icountry), "_new_ser_id WHERE t_series_ser.ser_id = temp_", tolower(icountry), "_new_ser_id.ser_id;"), extra_data = "new_ser_id",  country = tolower(icountry), environment = environment())
		}
	} else
		stop("not yet implemented")
}


#' create new series
#' 
#' @param series_info the tibble from the excel file
#' @param meta metadata associated to the series
#' @param icountry
#'
#' @return the ser_id of the new series
create_series = function(series_info, meta, icountry = country)
{
	if(nrow(series_info) == 0)
	{
		stop("No series to insert!")
	}
		
	
	series_info$ser_comment = str_c(meta$ser_comment, " | ", series_info$ser_comment)
	
	# insert data in the database 
	wgeel_execute(str_c("INSERT INTO datawg.t_series_ser (ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y, ", ifelse(type_series == "Silver_Eel", " ser_sam_id,", ""), "ser_order) SELECT *, 999 FROM temp_", tolower(icountry), "_series_info;"), extra_data = "series_info",  country = tolower(icountry), environment = environment())
	
	# retrieve le ser_id for further use
	new_ser_id = wgeel_query(str_c("SELECT ser_id FROM datawg.t_series_ser JOIN temp_", tolower(icountry), "_series_info USING(ser_nameshort)"))
	
	# update geom column
	wgeel_execute(str_c("UPDATE datawg.t_series_ser SET geom = ST_GeomFromText('POINT('||ser_x||' '||ser_y||')',4326) FROM temp_", tolower(icountry), "_new_ser_id WHERE t_series_ser.ser_id = temp_", tolower(icountry), "_new_ser_id.ser_id;"), extra_data = "new_ser_id",  country = tolower(icountry), environment = environment())
	
	
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
check_dataseries = function(dataseries, ser_data = ser_data)
{
	# add row number to dataseries
	dataseries = dataseries %>% mutate(nrow = row_number())
	
	#chek for already existing series
	existing_data = inner_join(dataseries, ser_data %>% select(das_id, das_ser_id, das_year, das_value, das_effort, das_comment), by = c("ser_id" = "das_ser_id", "das_year" = "das_year"), suffix = c("_xl", "_base"))
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
	# use identical instead of == because of NA
	updated_dataseries = dataseries  %>% mutate_all(as.character) %>% mutate_all(type.convert, as.is = TRUE) %>% mutate(updated_value = !f_identical(das_value_xl, das_value_base), updated_effort = !f_identical(das_effort_xl, das_effort_base), updated_comment = !f_identical(das_comment_xl, das_comment_base))
	
	print(str_c("updated value: ", sum(updated_dataseries$updated_value, na.rm = TRUE)))
	print(str_c("updated effort: ", sum(updated_dataseries$updated_effort, na.rm = TRUE)))
	print(str_c("updated comment: ", sum(updated_dataseries$updated_comment, na.rm = TRUE)))
	
	return(list(updated_value = updated_dataseries %>% filter(updated_value) %>% select(nrow, das_id, ser_id, das_value_xl, das_value_base), updated_effort = updated_dataseries %>% filter(updated_effort) %>% select(nrow, das_id, ser_id, das_effort_xl, das_effort_base), updated_comment = updated_dataseries %>% filter(updated_comment) %>% select(nrow, das_id, ser_id, das_comment_xl, das_comment_base)))
}

#' insert new data series
#' 
#' @param dataseries the tibble from the excel file
#'
#' @return the das_id of the new dataseries
insert_dataseries = function(dataseries, icountry = country)
{
	if(nrow(dataseries) == 0)
	{
		stop("No dataseries to insert!")
	}
	# insert data in the database 
	wgeel_execute(str_c("INSERT INTO datawg.t_dataseries_das (das_value, das_ser_id, das_year, das_comment, das_effort) SELECT * FROM temp_", tolower(icountry), "_dataseries;"), extra_data = "dataseries",  country = tolower(icountry), environment = environment())
	
	# retrieve le das_id for further use
	return(wgeel_query(str_c("SELECT das_id FROM datawg.t_dataseries_das, temp_", tolower(icountry), "_dataseries WHERE das_ser_id = ser_id AND t_dataseries_das.das_year = temp_", tolower(icountry), "_dataseries.das_year")) %>% pull())
}


#' update data series
#' 
#' @param dataseries the tibble from the excel file
#'
#' @return nothing
update_dataseries = function(dataseries, icountry = country)
{
	# TODO: add a parameter to select line / column to update (in case you don't want to update all)
	for(to_update in c("updated_value", "updated_effort", "updated_comment"))
	{
		if(nrow(dataseries[[to_update]])>0)
		{
			assign(to_update, dataseries[[to_update]], envir = environment())
			# insert data in the database 
			wgeel_execute(str_c("UPDATE datawg.t_dataseries_das SET ", 
					case_when(
						to_update == "updated_value" ~ "das_value = das_value_xl",
						to_update == "updated_effort" ~ "das_effort = das_effort_xl",
						to_update == "updated_comment" ~ "das_comment = das_comment_xl")
			, " FROM temp_", tolower(icountry), "_", to_update, " WHERE t_dataseries_das.das_id = temp_", tolower(icountry), "_", to_update, ".das_id;"), extra_data = to_update,  country = tolower(icountry), environment = environment())
		} else {
			print(str_c("No ", to_update, "!"))
		}
	}
}


#' check if biometry series have already been created
#' 
#' @param biometry the tibble from the excel file
#' @paral ser_biom list of biometry data in the database
#'
#' @return a list with existing biometry data (incl. the database bio_id) and data series to be created
check_biometry = function(biometry, ser_biom, stage)
{
	# check the stage
	if(!(type_series %in% c("Yellow_Eel", "Silver_Eel")))
		stop("Chose right stage")
	
	stage = case_when(
		stage == "Yellow_Eel" ~ "Y",
		stage == "Silver_Eel" ~ "S"
	)
	
	# add row number to dataseries
	biometry = biometry %>% mutate(nrow = row_number())
	
	#chek for already existing series
	existing_biom = inner_join(biometry, ser_biom %>% filter(bio_lfs_code == stage) %>% select(bio_id, bis_ser_id, bio_year, bio_length, bio_weight, bio_age, bio_comment), by = c("ser_id" = "bis_ser_id", "bio_year" = "bio_year"), suffix = c("_xl", "_base"))
	to_be_created_biom = anti_join(biometry, ser_biom %>% filter(bio_lfs_code == stage) %>% select(bis_ser_id, bio_year), by = c("ser_id" = "bis_ser_id", "bio_year" = "bio_year"))
	
	print(str_c("existing biometry: ", nrow(existing_biom)))
	print(str_c("biometry to be created: ", nrow(to_be_created_biom)))
	
	return(list(existing_series = existing_biom, to_be_created_series = to_be_created_biom))
}

#' insert new data series
#' 
#' @param biometry the tibble from the excel file
#' @param stage
#' @param country
#'
#' @return the bio_id of the new biometry
insert_biometry = function(biometry, stage, icountry = country)
{
	if(nrow(biometry) == 0)
	{
		stop("No biometry to insert!")
	}
	
	# check the stage
	if(!(type_series %in% c("Yellow_Eel", "Silver_Eel")))
		stop("Chose the right stage")
	
	stage = case_when(
		stage == "Yellow_Eel" ~ "Y",
		stage == "Silver_Eel" ~ "S"
	)
	
	# insert data in the database 
	additional_var = ifelse(stage == "S", "bio_sex_ratio, bio_length_f, bio_weight_f, bio_age_f, bio_length_m, bio_weight_m, bio_age_m,", "")
	wgeel_execute(str_c("INSERT INTO datawg.t_biometry_series_bis (bis_ser_id, bio_year, bio_length, bio_weight, bio_age, ", additional_var, " bio_comment, bio_lfs_code) SELECT *, '", stage,"' FROM temp_", tolower(icountry), "_biometry;"), extra_data = "biometry",  country = tolower(icountry), environment = environment())
	
	# retrieve le bio_id for further use
	return(wgeel_query(str_c("SELECT bio_id FROM datawg.t_biometry_series_bis, temp_", country, "_biometry WHERE bis_ser_id = ser_id AND t_biometry_series_bis.bio_year = temp_", country, "_biometry.bio_year")) %>% pull())
}
