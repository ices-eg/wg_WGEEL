path <- paste0(gsub("wg_WGEEL(.+|$)","", getwd()),
               "/wg_WGEEL/R/utilities/")
api <- yaml::read_yaml(paste0(path,
                              "stadia.yml"))
ggmap::register_stadiamaps(api$api)

# TODO: Add comment
# 
# Author: BEAULATON Laurent
###############################################################################


#' @title Download a background map of Europe and North Africa
#' @param transparent logical. Do you want this background map be a bit transparent?
#' @param mapbox A vector of for decimal coordinates giving the bounding box of the map (left, bottom, right, top)
#' @param mapType character string providing map theme. see getmap from ggmap package
#' @return a map
get_background_map = function(transparent = TRUE, mapbox = c(left = -13, bottom = 25, right = 40, top = 68), mapType = c("stamen_watercolor"))
{
  mapType <- gsub("-", "_", mapType)
  if (!mapType %in% ggmap:::STADIA_VALID_MAP_TYPES){
    if (paste0("stamen_", mapType) %in% ggmap:::STADIA_VALID_MAP_TYPES)
      mapType <- paste0("stamen_", mapType)
  }
	background_map = get_stadiamap(bbox = mapbox, zoom = 4, maptype = mapType, crop = TRUE)
	if(transparent)
	{
		attr = attributes(background_map)
		background_map_transparent = matrix(adjustcolor(background_map, 
				alpha.f = 0.2), 
			nrow = nrow(background_map))
		attributes(background_map_transparent) <- attr
		background_map = background_map_transparent
	}
	
	return(background_map)
}


