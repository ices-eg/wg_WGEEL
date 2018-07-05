# general configuration for shiny
# 
# Author: lbeaulaton
###############################################################################

# retrieve reference tables needed
# the shiny is launched from shiny_data_integration/shiny thus we need the ../
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")
source("../../stock_assessment/preco_diagram.R")

lfs_code_base = extract_ref("Life stage")
country_ref = extract_ref("Country")
landings = extract_data("Catches and landings")
aquaculture = extract_data("Aquaculture")
stocking = extract_data("Restocking")
precodata = extract_precodata()

#########################
# functions
########################
filter_data = function(dataset, life_stage, country = NULL)
{
	if(is.null(country)) country = as.character(country_ref$cou_code)
	if(dataset == "precodata")
	{
		extracted_data = dplyr::filter(get(dataset), eel_cou_code%in% country)
	} else {
		extracted_data = dplyr::filter(get(dataset), eel_lfs_code%in%life_stage, eel_cou_code%in% country)%>%dplyr::group_by(eel_cou_code,eel_year)%>%
			summarize(eel_value=sum(eel_value,na.rm=TRUE))
	}
	return(extracted_data)
}