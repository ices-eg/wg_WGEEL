# standard 2019 file for integration
###############################################################################

country = "FRA" # name of the folder

#--------------------------------
# Yellow
#--------------------------------
type_series = "Yellow_Eel"
print(type_series)

country_data = retrieve_data(country = country, type_series = type_series)

#-------------
# check and integrate series
#-------------
print("check and integrate series")

chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid) %>% mutate(ser_x = as.numeric(ser_x), ser_y = as.numeric(ser_y)), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))

# if you need to update
updated_series = check_series_update(series = country_data$series_info %>% semi_join(chk_series$existing_series), ser_db)
(show_updated_series = show_series_update(updated_series))

update_series(series_info = country_data$series_info %>% inner_join(chk_series$existing_series) %>% select(- ser_tblcodeid, - nrow), show_updated_series = show_updated_series, all = TRUE) 
# no ser_sam_id in the template for yellow eel
# %>% mutate(ser_sam_id = as.numeric(ser_sam_id))

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

#-------------
# check and integrate dataseries
#-------------
print("check and integrate dataseries")

if(nrow(country_data$data) > 0)
{
	chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)
	
	chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow) %>% mutate_at(c("das_value", "das_effort"), convert_round))
	
# if you need to update
	updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
# TODO: create a function to visualise data to be updated
	update_dataseries(dataseries = updated_dataseries)
} else
	print("No dataseries!")


#-------------
# check and integrate biometry data
#-------------
print("check and integrate biometry data")
if(nrow(country_data$biom)>0)
{
	chk_biom = check_biometry(biometry = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$biom), ser_biom, stage = type_series)
	
	chk_biom$to_be_created_series$bio_id = insert_biometry(biometry = chk_biom$to_be_created_series %>% select(-nrow, - ser_nameshort) %>% mutate_if(colnames(.) != "bio_comment", convert_round), stage = type_series)
	# TODO: design a function for checking and updating data
} else
	print("No biometry data!")

#--------------------------------
# Silver
#--------------------------------
type_series = "Silver_Eel"
print(type_series)

country_data = retrieve_data(country = country, type_series = type_series)

#-------------
# check and integrate series
#-------------
print("check and integrate series")

chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid) %>% mutate(ser_sam_id = as.numeric(ser_sam_id)), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))

# if you need to update
updated_series = check_series_update(series = country_data$series_info %>% semi_join(chk_series$existing_series), ser_db)
(show_updated_series = show_series_update(updated_series))

update_series(series_info = country_data$series_info %>% inner_join(chk_series$existing_series) %>% select(- ser_tblcodeid, - nrow) %>% mutate(ser_sam_id = as.numeric(ser_sam_id)), show_updated_series = show_updated_series, all = TRUE)

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

#-------------
# check and integrate dataseries
#-------------
print("check and integrate dataseries")

if(nrow(country_data$data) > 0)
{
	chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)
	
	chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow) %>% mutate_at(c("das_value", "das_effort"), as.numeric) %>% mutate_at(c("das_value", "das_effort"), convert_round))

# if you need to update
	updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
	update_dataseries(dataseries = updated_dataseries)
} else
	print("No dataseries!")

#-------------
# check and integrate biometry data
#-------------
if(nrow(country_data$biom)>0)
{
	chk_biom = check_biometry(biometry = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$biom), ser_biom, stage = type_series)
	
	chk_biom$to_be_created_series$bio_id = insert_biometry(biometry = chk_biom$to_be_created_series %>% select(-nrow, - ser_nameshort) %>% mutate_if(colnames(.) != "bio_comment", convert_round), stage = type_series)
	# TODO: design a function for checking and updating data
} else
	print("No biometry data!")
