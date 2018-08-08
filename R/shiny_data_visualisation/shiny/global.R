# general configuration for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################
# debug tool
#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_integration\\shiny")

# retrieve reference tables needed
# the shiny is launched from shiny_data_integration/shiny thus we need the ../

if(!exists("load_library")) source("../../utilities/load_library.R")
load_library(c("shiny", "leaflet", "reshape2", "dplyr","shinyWidgets","shinyjs", "RColorBrewer", "shinydashboard",
        "shinyWidgets","shinyBS"))
jscode <- "shinyjs.closeWindow = function() { window.close(); }"
if(is.null(options()$sqldf.RPostgreSQL.user)) source("../../database_interaction/database_connection.R")
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")
source("../../stock_assessment/preco_diagram.R")
source("graphs.R")
habitat_ref <- extract_ref("Habitat type")
lfs_code_base <- extract_ref("Life stage")
lfs_code_base <- lfs_code_base[!lfs_code_base$lfs_code %in% c("OG","QG"),]
country_ref <- extract_ref("Country")
country_ref <- country_ref[order(country_ref$cou_order), ]
country_ref$cou_code <- factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)


landings = extract_data("Landings")
aquaculture = extract_data("Aquaculture")
stocking = extract_data("Release")
precodata = extract_precodata()
CY = as.numeric(format(Sys.time(), "%Y"))
#########################
# functions
########################
#' @title Filtering function
#' @description This will filter according to user choice
#' @param dataset A character value, one of 'landings', 'aquaculture', 'stocking', 'precodata' pre loaded in the app
#' @param life_stage The life stage, Default: NULL
#' @param country The country, Default: NULL
#' @param habitat The habitat, one of c("MO", "C", "T", "F", "AL", "NA"), Default: NULL
#' @param year_range A vector of years, Default: 1900:2100
#' @return filtered dataset
#' @details ...
#' @examples 
#' \dontrun{
#' filter_data(dataset='landings',life_stage = NULL, country = NULL, habitat=NULL, year_range=2010:2018)
#' filter_data(dataset = "precodata",life_stage = NULL, country = levels(country_ref$cou_code),year_range=2000:2018) 
#' }
#' @seealso 
#'  \code{\link[dplyr]{filter}}
#' @rdname filter_data
#' @importFrom dplyr filter
filter_data = function(dataset, eel_typ_id=NULL, life_stage = NULL, country = NULL, habitat=NULL, year_range = 1900:2100)
{
  data. <- get(dataset)
  if(is.null(country)) country = as.character(country_ref$cou_code)
  
  if(dataset == "precodata"){
	filtered_data = dplyr::filter(data., eel_cou_code%in% country, eel_year %in% year_range)
  } else {
    if(is.null(life_stage)) life_stage = as.character(lfs_code_base$lfs_code)   
    if (is.null(habitat)) {
      data.$eel_hty_code[is.na(data.$eel_hty_code)]<-"NA"
      habitat=c(habitat_ref$hty_code, "NA")
    }
    if (is.null(eel_typ_id)) eel_typ_id=unique(data.$eel_typ_id)
    
	filtered_data = dplyr::filter(data., eel_lfs_code%in%life_stage, eel_typ_id%in% eel_typ_id, eel_cou_code%in% country, eel_year %in% year_range, eel_hty_code %in% habitat) 
    filtered_data$eel_hty_code = factor(filtered_data$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL", "NA")))
  }
  return(filtered_data)
}
#' @title function to group data
#' @description Data are grouped in the simplest way (year, country) or also by habitat or life stage, 
#' the grouping can be by emu or country
#' @param dataset the data
#' @param geo One of 'country' or 'emu', Default: 'country'
#' @param habitat Do you want result split per habitat, Default: FALSE
#' @param lfs Do you want results split by life stage, Default: FALSE
#' @return A grouped dataset
#' @details ...
#' @examples 
#' \dontrun{  
#'  filtered_data <- filter_data(dataset='landings',life_stage = NULL, country = NULL, habitat=NULL, year_range=2010:1011)
#'  grouped_data <- group_data(filtered_data, geo="country", habitat=FALSE, lfs=FALSE)
#' }
#' @seealso 
#'  \code{\link[dplyr]{group_by}}
#' @rdname group_data
#' @importFrom dplyr group_by
group_data <- function(dataset, geo="country", habitat=FALSE, lfs=FALSE){
  if (!geo %in% c("country","emu")) stop ("geo should be country or emu")
  if (habitat & lfs){
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_name,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
      
    }
    
  } else if (habitat){ 
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_name,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    }
    
  } else if (lfs) {
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_name,eel_year,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    }    
    
  } else {
    # not filtered by habitat nor lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_name,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=TRUE))
      
    }
  }
  return(dataset)
}  
#TODO swith to gam for years.... issue #40
#' @title Predict missing values for landings
#' @description Use simple glm with factors year and countries to make predictions
#' @param landings The dataset of landings
#' @return Landings with missing values filled with predictions
#' @details Use a loop not very efficient
#' @examples 
#' \dontrun{
#' landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
#' landings$eel_value <- as.numeric(landings$eel_value) / 1000
#' landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
#' pred_landings <- predict_missing_values(landings, verbose=TRUE) 
#' }
#' @rdname predict_missing_values
#' @export 
predict_missing_values <- function(landings, verbose=FALSE){
  landings$lvalue<-log(landings$eel_value+0.001) #introduce +0.001 to use 0 data
  landings$eel_year<-as.factor(landings$eel_year)
  glm_la<-glm(lvalue~eel_year+eel_cou_code,data=landings)
  if (verbose)  print(summary(glm_la)) # check fit
  landings2<-expand.grid("eel_year"=levels(landings$eel_year),"eel_cou_code"=levels(landings$eel_cou_code))
  landings2$pred=predict(glm_la,newdat=landings2,type="response")
  # BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
  for (y in unique(landings$eel_year)){
    for (c in levels(landings$eel_cou_code)){
      if (dim(landings[landings$eel_year==y&landings$eel_cou_code==c,"eel_value"])[1]==0){ 
        # no data ==> replace by predicted
        landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"eel_value"]<-round(exp(landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"pred"]))
        landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"predicted"]<-TRUE
      } else {
        # use actual value
        landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"eel_value"]<-round(landings[landings$eel_year==y&landings$eel_cou_code==c,"eel_value"])
        landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"predicted"]<-FALSE
      }
    }
  }
  landings2$eel_year<-as.numeric(as.character(landings2$eel_year))  
  return(landings2)  
}



#TODO create better colors

values=c(RColorBrewer::brewer.pal(12,"Set3"),
    RColorBrewer::brewer.pal(12, "Paired"), 
    RColorBrewer::brewer.pal(8,"Accent"),
    RColorBrewer::brewer.pal(8, "Dark2"))
color_countries = setNames(values,country_ref$cou_code)