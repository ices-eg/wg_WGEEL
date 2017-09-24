###########################################################################
# Functions to draw maps
# Author: cedric.briand
###############################################################################

#########################
# INITS
########################

library(stringr) # text handling
library(rgdal)
library(rgeos)
library(dplyr)
library(leaflet)
# using also stacomirtools package but not loaded

mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"

# path to local github (or write a local copy of the files and point to them)
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")
# path to shapes on the sharepoint
shpwd <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/shp"
emu_c=rgdal::readOGR(str_c(shpwd,"/","emu_centre_4326.shp")) # a spatial object of class spatialpointsdataframe
emu_c@data <- stacomirtools::chnames(emu_c@data,"emu_namesh","emu_nameshort") # names have been trucated
# this corresponds to the center of each emu.
country_p=rgdal::readOGR(str_c(shpwd,"/","country_polygons_4326.shp"))# a spatial object of class sp
# this is the map of coutry centers, to overlay points for each country
emu_p=rgdal::readOGR(str_c(shpwd,"/","emu_polygons_4326.shp")) # a spatial object of class sp
# this is the map of the emu.
country_c=rgdal::readOGR(str_c(shpwd,"/","country_centre_4326.shp"))
# transform spatial point dataframe to 

#########################
# Load data from the database
########################

landings <- sqldf(str_c("select * from  datawg.landings"))
aquaculture <- sqldf(str_c("select * from  datawg.aquaculture"))
catch_landings <- sqldf(str_c("select * from  datawg.catch_landings"))
catch <- sqldf(str_c("select * from  datawg.catch"))
stocking <- sqldf(str_c("select * from  datawg.stocking"))

# save them again as csv.....
write.table(aquaculture, file=str_c(mylocalfolder,"/aquaculture.csv"),sep=";")
write.table(landings, file=str_c(mylocalfolder,"/landings.csv"),sep=";")
write.table(catch_landings, file=str_c(mylocalfolder,"/catch_landings.csv"),sep=";")
write.table(catch, file=str_c(mylocalfolder,"/catch.csv"),sep=";")
write.table(stocking, file=str_c(mylocalfolder,"/stocking.csv"),sep=";")



#########################
# Load data from csv files
########################
aquaculture <- read.table(file=str_c(mylocalfolder,"aquaculture.csv"),sep=";")
landings <- read.table(file=str_c(mylocalfolder,"landings.csv"),sep=";")
catch_landings <- read.table(file=str_c(mylocalfolder,"catch_landings.csv"),sep=";")
catch <- read.table(file=str_c(mylocalfolder,"catch.csv"),sep=";")
stocking <- read.table(file=str_c(mylocalfolder,"stocking.csv"),sep=";")
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
    map="country"  
){
  # first checking that lifestages codes are correct
  lfs_code_base <- sqldf("select lfs_code from ref.tr_lifestage_lfs")[,1]
  if (!is.null(lfs_code)){
    if (!all(lfs_code %in% lfs_code_base)) stop (str_c("lfs_code wrong shoud be one of ",str_c(lfs_code_base,collapse=';')))
  }
  namedataset<-dataset
  dataset<-get(dataset)
  # Summarize by country, year and stage (if stage not null), eel_cou_code is renamed to cou_code for later join
  #---------------------------------------
  # case country
  #------------------------------------
  if (map=="country"){
    if (is.null(lfs_code)) {
      cc<-dataset %>% 
          group_by(eel_cou_code,eel_year) %>%
          summarize(sum=sum(eel_value)) %>%
          filter(eel_year==year &
                  !is.na(sum)) %>%
          rename(cou_code=eel_cou_code)
    } else {
      cc<-dataset %>% 
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
    selected_countries<- join(selected_countries,cc)
    # Get popup
    selected_countries$label<-sprintf("%s %s %i=%1.0f",namedataset,selected_countries$cou_countr,year,selected_countries$sum)
    # join the two dataset by common column (cou_code  
    m <- leaflet(data=selected_countries) %>%
        addProviderTiles(providers$OpenStreetMap) %>%         
        addCircles(
            lng=~coords.x1,
            lat=~coords.x2,
            weight = 1,
            radius = ~sqrt(sum)*coeff, popup = ~label)
    #---------------------------------------
    # case emu
    #------------------------------------ 
  } else if (map=="emu"){
    if (is.null(lfs_code)) {
      cc<-dataset%>% group_by(eel_emu_nameshort,eel_year) %>%
          summarize(sum=sum(eel_value)) %>%
          filter(eel_year==year &
                  !is.na(sum)) %>%          
          rename(emu_nameshort = eel_emu_nameshort)
    } else {
      cc<-dataset %>% 
          filter(eel_year==year &
                          eel_lfs_code %in% lfs_code)  %>%        
          group_by(eel_emu_nameshort,eel_year) %>%
          filter(!is.na(sum)) %>%         
          summarize(sum=sum(eel_value))%>%
          rename(emu_nameshort = eel_emu_nameshort)    
    }  
    selected_emus<-as.data.frame(emu_c[emu_c$emu_nameshort%in%cc$emu_nameshort,])
    # join with summary table
    selected_emus<- join(selected_emus,cc)
    # Get popup
    selected_emus$label<-sprintf("%s %s %i=%1.0f",namedataset,selected_emus$emu_nameshort,year,selected_emus$sum)
    # join the two dataset by common column (cou_code  
    m <- leaflet(data=selected_emus) %>%
        addProviderTiles(providers$OpenStreetMap) %>%         
        addCircles(
            lng=~coords.x1,
            lat=~coords.x2,
            weight = 1,
            radius = ~sqrt(sum)*coeff, popup = ~label)
  } else {
    stop("map argument should be one of 'country' or 'emu'")
  }
  
  
  return(m)
}




#########################
# Examples run
########################
# map of landings in 2016, all stages, per country
draw_leaflet()
# map of glass eel landings in 2016, per emu
# as yet no code to distinguish commercial and recreational
draw_leaflet(dataset="landings",
    year=2015,
    lfs_code='G',
    coeff=600,
    map="emu")
# map of glass eel catch and landings
draw_leaflet(dataset="catch_landings",
    year=2015,
    lfs_code='G',
    coeff=600,
    map="emu")



