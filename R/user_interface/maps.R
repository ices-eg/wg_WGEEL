###########################################################################
# Functions to draw maps
# Author: cedric.briand
###############################################################################

#########################
# INITS
########################
if(!require(tidyr)) install.packages("tidyr") ; require(tidyr)
if(!require(stringr)) install.packages("stringr") ; require(stringr) # text handling
if(!require(rgdal)) install.packages("rgdal") ; require(rgdal)
if(!require(rgeos)) install.packages("rgeos") ; require(rgeos)
if(!require(dplyr)) install.packages("dplyr") ; require(dplyr)
if(!require(leaflet)) install.packages("leaflet") ; require(leaflet)
if(!require(viridis)) install.packages("viridis") ; require(viridis)
if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
if(!require(stacomirtools)) install.packages("stacomirtools") ; require(stacomirtools)
if(!require(ggplot2)) install.packages("ggplot2") ; require(ggplot2)
if(!require(reshape2)) install.packages("reshape2") ; require(reshape2)
if(!require(rmapshaper)) install.packages("rmapshaper") ; require(rmapshaper)

# using join from plyr but not loaded (would mess with dplyr)
# using also stacomirtools package but not loaded_

mylocalfolder <- wg_choose.dir(caption = "Data call directory")


#########################
# Load data from csv files
########################
# TODO: use load function
aquaculture <- read.table(file=str_c(mylocalfolder,"/aquaculture.csv"),sep=";")
landings <- read.table(file=str_c(mylocalfolder,"/landings.csv"),sep=";")
stocking <- read.table(file=str_c(mylocalfolder,"/stocking.csv"),sep=";")
load(str_c(mylocalfolder,"/lfs_code.Rdata")) # lfs_code_base #TODO: should be taken in ref table directory
# Some transformation of data prior to analysis
# we can transform glass eel and quarantined glass eel in kg to number


#-----------------------------------------------
# Restocking which stages typ_id=9 (nb), =8 (kg)
#---------------------------------------------

stocking_nb <-filter(stocking,eel_typ_id%in%c(9))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
		summarize(eel_value=sum(eel_value))
stocking_kg <-filter(stocking,eel_typ_id%in%c(8))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
		summarize(eel_value=sum(eel_value))

#---------------------------------------------
# converting kg to number
#---------------------------------------------

# individual weight for one piece (kg)
GE_w=0.3e-3 
GY_w = 5e-3
Y_w=50e-3
OG_w=20e-3
QG_w=1e-3
S_w=150e-3

stocking_nb = stocking_nb%>%mutate(type="nb")
stocking_nb = stocking_nb%>%mutate(eel_value_nb = eel_value)

stocking_kg<-stocking_kg%>%mutate(type="kg")
stocking_kg<- bind_rows(
		filter(stocking_kg, eel_lfs_code=='G')%>%mutate(eel_value_nb=eel_value/GE_w)
		,
		filter(stocking_kg, eel_lfs_code=='GY')%>%mutate(eel_value_nb=eel_value/GY_w)
		,
		filter(stocking_kg, eel_lfs_code=='YS')%>%mutate(eel_value_nb=eel_value/Y_w)
		,
		filter(stocking_kg, eel_lfs_code=='OG')%>%mutate(eel_value_nb=eel_value/OG_w)
		,
		filter(stocking_kg, eel_lfs_code=='QG')%>%mutate(eel_value_nb=eel_value/QG_w)
		,
		filter(stocking_kg, eel_lfs_code=='S')%>%mutate(eel_value_nb=eel_value/S_w))

stocking = bind_rows(stocking_kg, stocking_nb)

#########################
# MAP FUNCTIONS
########################

#' @title drawing results from datacall in a leaflet map
#' @description Extracts data according to view name, creates summary 
#' @param dataset The quoted name of the dataset to analyse Default: "landings", can be one of "landings", "aquaculture", "catch", "catch_landings", "stocking"
#' @param year The year to use, Default: 2016
#' @param lfs_code A vector of lifestage codes e.g. c('Y','S','YS'), if NULL all lifestages used, Default: NULL
#' @param coeff the coefficient to multiply by when drawing map, sqrt(sum)*coeff is used, Default: 300
#' @param map the type of map to draw, Default: "country" can be "emu
#' @param lfs_code_base a vector of possible lfs code from base to check lfs code integrity
#' @return A leaflet map
#' @examples 
#' \dontrun{
#' if(interactive()){
#'   draw_leaflet("landings")
#'  }
#' }
#' @rdname draw_leaflet 
draw_leaflet<-function(dataset="landings",
    year=2016,
    lfs_code=NULL,
    coeff=300,
    map="country",
    lfs_code_base_=lfs_code_base  
){
  # first checking that lifestages codes are correct
  if (!is.null(lfs_code)){
    if (!all(lfs_code %in% lfs_code_base_)) stop (str_c("lfs_code wrong shoud be one of ",str_c(lfs_code_base,collapse=';')))
  }
  namedataset<-dataset
  dataset_<-get(dataset)
  # Summarize by country, year and stage (if stage not null), eel_cou_code is renamed to cou_code for later join
  #---------------------------------------
  # case country
  #------------------------------------
  if (map=="country"){
    if (is.null(lfs_code)) {
      cc<-  dataset_ %>% 
          group_by(eel_cou_code,eel_year) %>%
          summarize(sum=sum(eel_value)) %>%
          filter(eel_year==year &
                  !is.na(sum)) %>%
          rename(cou_code=eel_cou_code)
    } else {
      cc<-  dataset_ %>% 
          filter(eel_year==year & 
                  eel_lfs_code%in%lfs_code) %>%
          group_by(eel_cou_code,eel_year) %>%
          summarize(sum=sum(eel_value)) %>%
          filter(!is.na(sum)) %>%     
          rename(cou_code=eel_cou_code)    
    }
    # Select countries from spatialdataframe and extract coordinates
    selected_countries<-as.data.frame(country_c[country_c$cou_code%in%cc$cou_code,])
    # join with summary table
    selected_countries<- plyr::join(selected_countries,cc)
    # Get popup
    selected_countries$label<-sprintf("%s %s %i=%1.0f",namedataset,selected_countries$cou_countr,year,selected_countries$sum)
	scale = max(log10(selected_countries$sum))
    # join the two   dataset_ by common column (cou_code  
    m <- leaflet(data=selected_countries) %>%
        addProviderTiles(providers$Esri.OceanBasemap) %>% 
		addPolygons(data = country_p, weight = 2) %>% 
		fitBounds(-10, 34, 26, 65) %>%
        addCircles(
            lng=~coords.x1,
            lat=~coords.x2,
			color = "red", opacity = 1,
            weight = 1,
            radius = ~log10(sum)/scale*coeff*1E4, popup = ~label)
    #---------------------------------------
    # case emu
    #------------------------------------ 
  } else if (map=="emu"){
    if (is.null(lfs_code)) {
      cc<-  dataset_%>% group_by(eel_emu_nameshort,eel_year) %>%
          summarize(sum=sum(eel_value)) %>%
          filter(eel_year==year &
                  !is.na(sum)) %>%          
          rename(emu_nameshort = eel_emu_nameshort)
    } else {
      cc<-  dataset_ %>% 
          filter(eel_year==year &
                  eel_lfs_code %in% lfs_code)  %>%        
          group_by(eel_emu_nameshort,eel_year) %>%       
          summarize(sum=sum(eel_value))%>%
		  filter(!is.na(sum)) %>%  
          rename(emu_nameshort = eel_emu_nameshort)    
    }  
    selected_emus<-as.data.frame(emu_c[emu_c$emu_nameshort%in%cc$emu_nameshort,])
    # join with summary table
    selected_emus<- plyr::join(selected_emus,cc)
    # Get popup
    selected_emus$label<-sprintf("%s %s %i=%1.0f",namedataset,selected_emus$emu_nameshort,year,selected_emus$sum)
	scale = max(sqrt(selected_emus$sum))
    # join the two dataset by common column (cou_code  
    m <- leaflet(data=selected_emus) %>%
        addProviderTiles(providers$Esri.OceanBasemap) %>%         
		addPolygons(data = emu_p, weight = 2) %>% 
		fitBounds(-10, 34, 26, 65) %>%
		addCircles(
            lng=~coords.x1,
            lat=~coords.x2,
			color = "red", opacity = 1,
            weight = 1,
            radius = ~sqrt(sum)/scale*coeff*1E4, popup = ~label)
  } else {
    stop("map argument should be one of 'country' or 'emu'")
  }
  
  
  return(m)
}

# load data
source("R/utilities/load_data.R")
load_maps()
