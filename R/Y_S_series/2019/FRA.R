# integration France 2019
###############################################################################

country = "FRA"

#--------------------------------
# France - Yellow
#--------------------------------
type_series = "Yellow_Eel"

country_data = retrieve_data(country = country, type_series = type_series)

# check and integrate series
chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))
# TODO: should we plan an update process?

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

# check and integrate dataseries
chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)

chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow))

updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
# TODO: design a function for updating data

# check and integrate biometry data
chk_biom = check_biometry(biometry = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$biom), ser_biom, stage = "Yellow_Eel")

chk_biom$to_be_created_series$bio_id = insert_biometry(biometry = chk_biom$to_be_created_series %>% select(-nrow, - ser_nameshort) %>% mutate(bio_length = as.numeric(bio_length), bio_weight = as.numeric(bio_weight), bio_age = as.numeric(bio_age)), stage = "Yellow_Eel")


#--------------------------------
# France - Silver
#--------------------------------
type_series = "Silver_Eel"

country_data = retrieve_data(country = country, type_series = type_series)

# check and integrate series
chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))
# TODO: should we plan an update process?

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

# check and integrate dataseries
chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)

chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow))

updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
update_dataseries(dataseries = updated_dataseries)
# TODO: design a function for updating data

# check and integrate biometry data
chk_biom = check_biometry(biometry = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$biom), ser_biom, stage = "Yellow_Eel")

chk_biom$to_be_created_series$bio_id = insert_biometry(biometry = chk_biom$to_be_created_series %>% select(-nrow, - ser_nameshort) %>% mutate(bio_length = as.numeric(bio_length), bio_weight = as.numeric(bio_weight), bio_age = as.numeric(bio_age)), stage = "Yellow_Eel")
# TODO: design a function for checking and updating data