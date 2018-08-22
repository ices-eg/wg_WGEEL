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
#'  "aquaculture",  "release"
#' @param years Two years, the first year will be used to calculate historical data range year[1]:CY where
#' CY is current year, the second year will be used to filter to the dataset displayed on the map, the dataset is limited to 
#' filter_data(...,year_range=c(year[2],year[2]))
#' @param lfs_code A vector of lifestage codes e.g. c('Y','S','YS'), if NULL all lifestages used, 
#' Default: NULL
#' @param typ the type of data used, Default : NULLe
#' @param map the type of map to draw, Default: "country" can be "emu
#' @return A leaflet map
#' @details https://github.com/kvistrup/neo_fireball_tracking/blob/master/server.R was of great help, thanks
#' to its author ....
#' @examples #' 
#' datacall_map("landings")
#' datacall_map("landings",map="emu")
#' datacall_map("landings",map="emu", typ=c(4,6))
#' datacall_map("aquaculture",map="country", typ=c(11))
#'  }
#' }
#' @rdname datacall_map 
datacall_map<-function(
    dataset = "landings",
    years = c(1990,2016),
    lfs_code = NULL,
    typ = NULL,
    map = "country"  
){
  # Extract data-------------------------------------------------------------------------------------
  
  cc <-  filter_data(dataset,typ=typ,life_stage=lfs_code,habitat=NULL,year_range=c(years[2],years[2]))
  cc <- group_data(cc, geo= map,habitat=FALSE, lfs=FALSE)
  
  # Extract data all time ----------------------------------------------------------------------------
  
  ccall <-  filter_data(dataset,typ=typ,life_stage=lfs_code,habitat=NULL,year_range=c(years[1]:CY))
  ccall <- group_data(ccall, geo= map,habitat=FALSE, lfs=FALSE)
  
  # value in tons when necessary and unit for the legend ---------------------------------------------
  # typ is null at init, but the leaflet will by default be loaded with landings
  if (is.null(typ)) {
    cc$eel_value <- round(cc$eel_value / 1000,digits=1) 
    ccall$eel_value <- round(ccall$eel_value / 1000,digits=1)
    unit <- "in tons"
  } else if (4 %in% typ || 6 %in% typ || 11 %in% typ ){
    cc$eel_value <- round(cc$eel_value / 1000,digits=1)
    ccall$eel_value <- round(ccall$eel_value / 1000,digits=1)
    unit = "in tons"
  } else if (9 %in% typ || 12 %in% typ) { unit = "in numbers"
  } else if (8 %in% typ) {
    unit = "in kg"
  } else if (10 %in% typ) {
    unit = "in glass eel equivalents"
  }
  #################
  # I. country case --------------------------------------------------------------------------------
  #################
  
  if (map=="country"){ 
    
    # join with spatial dataframe ------------------------------------------------------------------
    
    selected_countries <- as.data.frame(country_c[ country_c$cou_code %in% cc$eel_cou_code, ])
    selected_countries$eel_cou_code <- as.character( selected_countries$cou_code )
    selected_countries <- dplyr::inner_join(selected_countries, cc, by=c("eel_cou_code"))
    value <- selected_countries$eel_value
    
    # create an id as eg : GR_2016 ------------------------------------------------------------------
    
    selected_countries <- tidyr::unite(selected_countries,id,eel_cou_code, eel_year)
    
    # Get popup ------------------------------------------------------------------------------------
    
    selected_countries$label<-sprintf("%s %s %i=%1.0f",dataset, selected_countries$cou_countr, 
        years[2], selected_countries$eel_value, 'tons')
    
    # get scales (scales set on full dataset (from) a circle marker in pixels  --------------------
    
    selected_countries$rescaled_value <- 100*scales::rescale(selected_countries$eel_value,
        from=range(ccall$eel_value)) 
    
    # color palette -------------------------------------------------------------------------------
    
    color_pal <- colorBin("viridis", ccall$eel_value, 10,  pretty = TRUE) # reverse=TRUE,
    
    # legend --------------------------------------------------------------------------------------
    
    legend.title <- paste(dataset, unit)  
    
    # leaflet -------------------------------------------------------------------------------------
    
    m <- leaflet(data=selected_countries) %>%
        
        addProviderTiles(providers$Esri.OceanBasemap) %>% 
        
	    addPolygons(data = country_p, weight = 2, opacity=0.3, fillOpacity =0.1) %>% 
        
	    fitBounds(-10, 34, 26, 65) %>%
        
        addCircleMarkers(
            lng = ~coords.x1,
            lat = ~coords.x2,
		    color = ~color_pal(value),
            fillColor = ~color_pal(value),
            fillOpacity = 0.5,
            opacity = 0.9,            
            weight = 1,
            stroke = TRUE,
            radius = selected_countries$rescaled_value, 
            popup = ~label,
            layerId = ~id) %>%
        
        addLegend(pal = color_pal, 
            position="bottomright", 
            values = value, 
            title = legend.title)
    
    # dataset returned by the function --------------------------------------------------------------
    
    return_data <- selected_countries
    
    ###############
    # II. emu case ----------------------------------------------------------------------------------
    ###############
    
  } else if (map=="emu"){
    
    # join with spatial dataframe ------------------------------------------------------------------
    
    selected_emus<-as.data.frame(emu_c[emu_c$emu_namesh%in%cc$eel_emu_nameshort,])
    selected_emus <- rename(selected_emus,"eel_emu_nameshort"="emu_namesh")
    selected_emus$eel_emu_nameshort <- as.character(selected_emus$eel_emu_nameshort) 
    selected_emus <- dplyr::inner_join(selected_emus,cc,by="eel_emu_nameshort")
    value <- selected_emus$eel_value
    # create an id as eg : GR_2016 ------------------------------------------------------------------
    
    selected_emus <- tidyr::unite(selected_emus,id,eel_emu_nameshort, eel_year)
    
    # Get popup ------------------------------------------------------------------------------------
    
    selected_emus$label<-sprintf("%s %s %i=%1.0f",dataset,selected_emus$eel_emu_nameshort,years[2],
        selected_emus$eel_value)
    
    # get scales (scales set on full dataset (from) a circle marker in pixel  --------------------
    
    selected_emus$rescaled_value <-  scales::rescale(selected_emus$eel_value,to=c(0,10),from=range(ccall$eel_value)) 
    
    # get palette and title-----------------------------------------------------------------------
    
    color_pal <- colorBin("viridis", ccall$eel_value, 100, pretty = TRUE) # reverse=TRUE
    
    legend.title <- paste(dataset, unit)
    
    # leaflet -------------------------------------------------------------------------------------
    
    m <- leaflet(data=selected_emus) %>%
        
        addProviderTiles(providers$Esri.OceanBasemap) %>% 
        
		addPolygons(data = country_p, weight = 2, opacity=0.3, fillOpacity =0.1) %>% 
        
		fitBounds(-10, 34, 26, 65) %>%
        
		addCircleMarkers(
            lng=~coords.x1,
            lat=~coords.x2,
			color = ~color_pal(value),
            fillColor = ~color_pal(value),
            fillOpacity = 0.5,
            opacity = 0.9,     
            weight = 5,
            radius = selected_emus$rescaled_value, 
            popup = ~label,
            layerId = ~id) %>%
        
        addLegend(pal = color_pal, 
            position="bottomright",
            values = value, 
            title = legend.title)
    
    # dataset returned by the function --------------------------------------------------------------
    
    return_data <- selected_emus
    
  } else {
    stop("map argument should be one of 'country' or 'emu'")
  }
  
  return(list("m"=m,"data"=return_data))
}

# recruitment_map ----------------------------------------------------------------------------------- 

validateCoords(mrd$ser_x,mrd$ser_y)

recruitment_map <- function(R_stations, statseries, wger){
  
  # when has this series last been edited (this does not mean that last data is the year it was edited)
  
  last_update <- wger%>%group_by(site)%>%
      summarize(last=as.numeric(
              format(
                  max(das_last_update,na.rm=TRUE),"%Y")
          ))
  last_update$last[is.na(last_update$last)]  <-2000    
  R_stations$ser_lfs_code <- as.factor(R_stations$ser_lfs_code)
  
  mrd <- merge(statseries, R_stations, by.x="site", by.y="ser_nameshort")
  # mrd = (m)ap (r)ecruitment (d)ata
  
  mrd <- inner_join(mrd, last_update, by ="site")
  
  color_pal <- colorFactor("Dark2", mrd$ser_lfs_code) 
  
  # Get popup ------------------------------------------------------------------------------------
  
  mrd$label<-sprintf('<strong>%s %s</strong> </br>
           years : <font color="blue">%i-%i</font> </br>
           name : %s </br>
           duration (missing): %i (%i) </br>
           sampling type: %s </br>
           used: %s </br>',
      mrd$site,
      mrd$lfs_code,
      mrd$min, mrd$max,
      mrd$namelong,
      mrd$duration, mrd$missing,
      mrd$sampling_type,
      ifelse(mrd$series_kept,
          '<font color="green">Yes</font>',
          '<font color="red";">No</font>'))
  
  
  m <- leaflet(data=mrd) %>%
      
      addProviderTiles(providers$Esri.OceanBasemap) %>% 
      
      # Add a black circle arround series with lines updated this year ------------------------------
      addCircleMarkers(
          lng=~ser_x ,
          lat=~ser_y ,
		  color = "black",
          fillOpacity = 0,
          opacity = 0.9,     
          weight = 2,
          radius = 12,
          data = mrd[mrd$last==2018,]          
      ) %>%
	  addCircleMarkers(
          lng=~ser_x ,
          lat=~ser_y ,
		  color = ~ color_pal(ser_lfs_code),
          fillColor = ~ color_pal(ser_lfs_code),
          fillOpacity = 0.5,
          opacity = 0.9,     
          weight = 1,
          radius = 10, 
          popup = ~label,
          layerId = ~ser_id) %>%     
      addLegend(pal = color_pal, 
          position="bottomright",
          values = mrd$ser_lfs_code, 
          title = "Type of series </br> black circle = updated")
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