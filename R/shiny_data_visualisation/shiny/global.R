# general configuration for shiny
# 
# Author: lbeaulaton
###############################################################################
# debug tool
#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")

# retrieve reference tables needed
# the shiny is launched from shiny_data_integration/shiny thus we need the ../

if(!exists("load_library")) source("../../utilities/load_library.R")
if(is.null(options()$sqldf.RPostgreSQL.user)) source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")
source("../../stock_assessment/preco_diagram.R")

lfs_code_base = extract_ref("Life stage")
country_ref = extract_ref("Country")
country_ref = country_ref[order(country_ref$cou_order), ]
country_ref$cou_code = factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)
landings = extract_data("Landings")
aquaculture = extract_data("Aquaculture")
stocking = extract_data("Release")
precodata = extract_precodata()

#########################
# functions
########################
filter_data = function(dataset, life_stage = NULL, country = NULL, year_range = 1900:2100)
{
	if(is.null(country)) country = as.character(country_ref$cou_code)
	if(is.null(life_stage)) life_stage = as.character(lfs_code_base$lfs_code)
	
	if(dataset == "precodata")
	{
		extracted_data = dplyr::filter(get(dataset), eel_cou_code%in% country, eel_year %in% year_range)
	} else {
		extracted_data = dplyr::filter(get(dataset), eel_lfs_code%in%life_stage, eel_cou_code%in% country, eel_year %in% year_range)%>%dplyr::group_by(eel_cou_code,eel_year)%>%
			summarize(eel_value=sum(eel_value,na.rm=TRUE))
	}
	
	extracted_data = merge(extracted_data, country_ref[, c("cou_code", "cou_order")], by.x = "eel_cou_code", by.y = "cou_code")
	
	extracted_data = extracted_data[order(extracted_data$cou_order), ]
	return(extracted_data)
}

data_to_display = function(input)
{
	if(input$dataset == "precodata"){
		to_display = filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$yearmin:input$yearmax)
		to_display = to_display[order(to_display$cou_order, to_display$eel_year), ]
	} else {
		if(dim(filter_data(input$dataset, life_stage = input$lfs, country = input$country, year_range = input$yearmin:input$yearmax))[1] == 0) # handle empty dataframe
		{
			to_display = filter_data(input$dataset, life_stage = input$lfs, country = input$country, year_range = input$yearmin:input$yearmax)
		} else {
			to_display = dcast(filter_data(input$dataset, life_stage = input$lfs, country = input$country, year_range = input$yearmin:input$yearmax), eel_year~eel_cou_code, value.var = "eel_value", options = list(dom = 'lftp', pageLength = 10))
		}
		
		#ordering the column accordign to country order
		country_to_order = names(to_display)[-1]
		n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
		to_display = to_display[, c(1, n_order+1)]
	}
	return(to_display)
}