# integration Sweden 2019
###############################################################################

country = "SE"

#--------------------------------
# Sweden - Yellow
#--------------------------------
type_series = "Yellow_Eel"

country_data = retrieve_data(country = country, type_series = type_series)
#no file

#--------------------------------
# Sweden - Silver
#--------------------------------

type_series = "Silver_Eel"

country_data = retrieve_data(country = country, type_series = type_series)

# check and integrate series
chk_series = check_series(country_data$series_info, ser_db)

chk_series$to_be_created_series$ser_id = create_series(series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid) %>% mutate(ser_sam_id = as.numeric(ser_sam_id)), meta = country_data$meta %>% semi_join(chk_series$to_be_created_series))

# gather new and existing series
series_info = gather_series(chk_series$existing_series, chk_series$to_be_created_series)

# check and integrate dataseries
chk_dataseries = check_dataseries(dataseries = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$data) %>% select(das_value, ser_id, das_year, das_comment, das_effort), ser_data)

chk_dataseries$to_be_created_series$das_id = insert_dataseries(dataseries = chk_dataseries$to_be_created_series %>% select(-nrow) %>% mutate_at(c("das_value", "das_effort"), convert_round))

updated_dataseries = check_dataseries_update(dataseries = chk_dataseries$existing_series)
update_dataseries(dataseries = updated_dataseries)

# check and integrate biometry data
if(nrow(country_data$biom)>0)
{
	chk_biom = check_biometry(biometry = series_info %>% select(ser_id, ser_nameshort) %>% inner_join(country_data$biom), ser_biom, stage = type_series)
	
	chk_biom$to_be_created_series$bio_id = insert_biometry(biometry = chk_biom$to_be_created_series %>% select(-nrow, - ser_nameshort) %>% mutate_if(colnames(.) != "bio_comment", convert_round), stage = type_series)
}