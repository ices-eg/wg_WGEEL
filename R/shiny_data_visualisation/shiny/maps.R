###########################################################################
# Functions to draw maps
# Author: cedric.briand
###############################################################################


#########################
# MAP FUNCTIONS
########################
# -------------------------------------------------------------------------------------------------
#' @title drawing results from datacall in a leaflet map
#' @description Extracts data according to view name, creates summary 
#' @param dataset The quoted name of the dataset to analyse Default: "landings", can be one of "landings",
#'  "aquaculture", "catch", "catch_landings", "stocking"
#' @param year The year to use, Default: 2016
#' @param lfs_code A vector of lifestage codes e.g. c('Y','S','YS'), if NULL all lifestages used, 
#' Default: NULL
#' @param coeff the coefficient to multiply by when drawing map, sqrt(sum)*coeff is used, Default: 300
#' @param map the type of map to draw, Default: "country" can be "emu
#' @return A leaflet map
#' @examples #' 
#' draw_leaflet("landings")
#' draw_leaflet("landings",map="emu")
#'  }
#' }
#' @rdname draw_leaflet 
draw_leaflet<-function(
    dataset = "landings",
    year = 2016,
    lfs_code = NULL,
    coeff = 10,
    typ = NULL,
    map = "country"  
){
  # Extract data-------------------------------------------------------------------------------------

  cc <-  filter_data(dataset,typ=typ,life_stage=lfs_code,habitat=NULL,year_range=c(year,year))
  cc <- group_data(cc, geo= map,habitat=FALSE, lfs=FALSE)
  
  # Extract data all time ----------------------------------------------------------------------------
  
  ccall <-  filter_data(dataset,typ=typ,life_stage=lfs_code,habitat=NULL,year_range=c(1920:CY))
  ccall <- group_data(ccall, geo= map,habitat=FALSE, lfs=FALSE)
  
  # value in tons  -----------------------------------------------------------------------------------
  if (dataset %in% c("landings","aquaculture")){
     cc$eel_value <- round(cc$eel_value / 1000,digits=1)
     ccall$eel_value <- round(ccall$eel_value / 1000,digits=1)
   }
   
  # country case --------------------------------------------------------------------------------------
  if (map=="country"){ 
    
  # join with spatial dataframe ------------------------------------------------------------------------
  selected_countries<-as.data.frame(country_c[country_c$cou_code%in%cc$eel_cou_code,])
  selected_countries$eel_cou_code=as.character(selected_countries$cou_code)
  selected_countries<- dplyr::inner_join(selected_countries, cc, by=c("eel_cou_code"))
  
  # Get popup ------------------------------------------------------------------------------------------
    
  selected_countries$label<-sprintf("%s %s %i=%1.0f",dataset, selected_countries$cou_countr, 
      year, selected_countries$eel_value, 'tons')
  
  # get scales (scales set on full dataset (from) using 1000 km as maximum radius on the map -----------
    
  selected_countries$value <- scales::rescale(selected_countries$eel_value,
      to=c(0,1000000),
      from=range(ccall$eel_value)) 
 
  # leaflet ---------------------------------------------------------------------------------------------
    
  m <- leaflet(data=selected_countries) %>%
      addProviderTiles(providers$Esri.OceanBasemap) %>% 
	  addPolygons(data = country_p, weight = 2) %>% 
	  fitBounds(-10, 34, 26, 65) %>%
      addCircles(
          lng=~coords.x1,
          lat=~coords.x2,
		  color = "red", opacity = 1,
          weight = 1,
          radius = selected_countries$value, 
          popup = ~label)

  # emu case ----------------------------------------------------------------------------------------

} else if (map=="emu"){
        
          selected_emus<-as.data.frame(emu_c[emu_c$emu_namesh%in%cc$eel_emu_nameshort,])
          selected_emus <- rename(selected_emus,"eel_emu_nameshort"="emu_namesh")
          selected_emus$eel_emu_nameshort <- as.character(selected_emus$eel_emu_nameshort) 
          selected_emus<- dplyr::inner_join(selected_emus,cc,by="eel_emu_nameshort")
          selected_emus$label<-sprintf("%s %s %i=%1.0f",dataset,selected_emus$eel_emu_nameshort,year,selected_emus$eel_value)
	      selected_emus$value <- scales::rescale(selected_emus$eel_value,to=c(0,500000),from=range(ccall$eel_value)) 
          m <- leaflet(data=selected_emus) %>%
                  addProviderTiles(providers$Esri.OceanBasemap) %>%         
		          addPolygons(data = emu_p, weight = 2) %>% 
		          fitBounds(-10, 34, 26, 65) %>%
		          addCircles(
                          lng=~coords.x1,
                          lat=~coords.x2,
			              color = "red", opacity = 1,
                          weight = 1,
                          radius = selected_emus$value, 
                          popup = ~label)
      } else {
          stop("map argument should be one of 'country' or 'emu'")
      }


return(m)
}


#' @title load maps
#' @description load needed maps for shiny App (EMU, country)
#' @param full_load should the maps be loaded from source file? if not from Rdata file
#' @param to_save should maps be save into a Rdata file to ease the loading next time
#' @details this is now saved in data/shapefiles, it is added to the ignore list, so ask for it in your own git
load_maps = function(full_load = FALSE, to_save = FALSE)
{
  if(!require(stringr)) install.packages("stringr") ; require(stringr)
  if(!require(sp)) install.packages("sp") ; require(sp)
  if(full_load)
  {
	if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
	if(!require(stacomirtools)) install.packages("stacomirtools") ; require(stacomirtools)
	#path to shapes on the sharepoint
	shpwd = wg_choose.dir(caption = "Shapefile directory")
	emu_c <- rgdal::readOGR(str_c(shpwd,"/","emu_centre_4326.shp")) # a spatial object of class spatialpointsdataframe
	emu_c@data <- stacomirtools::chnames(emu_c@data,"emu_namesh","emu_nameshort") # names have been trucated
	emu_c <<- emu_c
	# this corresponds to the center of each emu.
	country_p <<- rmapshaper::ms_simplify(rgdal::readOGR(str_c(shpwd,"/","country_polygons_4326.shp")), keep = 0.01)# a spatial object of class sp, symplified to be displayed easily
	# this is the map of coutry centers, to overlay points for each country
	# beware this takes ages ...
	emu_p <<- rmapshaper::ms_simplify(rgdal::readOGR(str_c(shpwd,"/","emu_polygons_4326.shp")), keep = 0.7) # a spatial object of class sp, symplified to be displayed easily
	# this is the map of the emu.
	country_c <<- rgdal::readOGR(str_c(shpwd,"/","country_centre_4326.shp"))
	# transform spatial point dataframe to 
	if(to_save) save(emu_c,country_p,emu_p,country_c,file=str_c(data_directory,"/maps_for_shiny.Rdata")) # TODO: should be taken in ref table directory
  } else 
  {
	if(!exists("data_directory")) 
	  data_directory <- wg_choose.dir(caption = "Data directory")
	load(file=str_c(data_directory,"/maps_for_shiny.Rdata"), envir = .GlobalEnv)
  }
}

#load_maps()