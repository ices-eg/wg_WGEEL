# general configuration for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################
# debug tool
#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")

# retrieve reference tables needed
# the shiny is launched from shiny_data_integration/shiny thus we need the ../

if(!exists("load_library")) source("../../utilities/load_library.R")
load_library(c("shiny", "leaflet", "reshape2", "dplyr","shinyWidgets","shinyjs"))
jscode <- "shinyjs.closeWindow = function() { window.close(); }"
if(is.null(options()$sqldf.RPostgreSQL.user)) source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")
source("../../stock_assessment/preco_diagram.R")

habitat_ref = extract_ref("Habitat type")
lfs_code_base = extract_ref("Life stage")
country_ref = extract_ref("Country")
country_ref = country_ref[order(country_ref$cou_order), ]
country_ref$cou_code = factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)


landings = extract_data("Landings")
aquaculture = extract_data("Aquaculture")
stocking = extract_data("Release")
precodata = extract_precodata()
CY = as.numeric(format(Sys.time(), "%Y"))
#########################
# functions
########################
filter_data = function(dataset, life_stage = NULL, country = NULL, habitat=NULL, year_range = 1900:2100)
{
  if(is.null(country)) country = as.character(country_ref$cou_code)
  if(is.null(life_stage)) life_stage = as.character(lfs_code_base$lfs_code)
  if (is.null(habitat)) {
    dataset$hty_code[is.na(dataset$hty_code)]<-"NA"
    hty=c(habitat_ref$hty_code, NA)
  }
  if(dataset == "precodata")
  {
	filtered_data = dplyr::filter(get(dataset), eel_cou_code%in% country, eel_year %in% year_range)
  } else {
	filtered_data = dplyr::filter(get(dataset), eel_lfs_code%in%life_stage, eel_cou_code%in% country, eel_year %in% year_range, eel_hty_code %in% hty) 
  }
  
  filtered_data = merge(filtered_data, country_ref[, c("cou_code", "cou_order")], by.x = "eel_cou_code", by.y = "cou_code")
  filtered_data = merge(filtered_data, habitat_ref[, c("hty_code", "hty_description")], by.x = "eel_hty_code", by.y = "hty_code")
  filtered_data = filtered_data[order(filtered_data$cou_order), ]
  filtered_data$eel_hty_code = factor(filtered_data$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL", "NA")))
  
  return(filtered_data)
}

group_data <- function(dataset, geo="country", habitat=FALSE, lfs=FALSE){
  if (!geo %in% c("country","emu")) stop ("geo should be country or emu")
  if (habitat & lfs){
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset %>%
          dplyr::group_by(eel_emu_name,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
      
    }
    
  } else if (habitat){ 
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset %>%
          dplyr::group_by(eel_emu_name,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    }
      
    } else if (lfs) {
           # filtered by habitat and lfs
          if (geo=="country") {
              # by country
              dataset %>%
                      dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code) %>%
	                  summarize(eel_value=sum(eel_value,na.rm=TRUE))
          } else {
              # by emu
              dataset %>%
                      dplyr::group_by(eel_emu_name,eel_year,eel_lfs_code) %>%
	                  summarize(eel_value=sum(eel_value,na.rm=TRUE))
          }    
      
    } else {
    # not filtered by habitat nor lfs
    if (geo=="country") {
      # by country
      dataset %>%
          dplyr::group_by(eel_cou_code,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset %>%
          dplyr::group_by(eel_emu_name,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
      
    }
  }
  return(dataset)
}  

