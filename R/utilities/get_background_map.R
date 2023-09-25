# TODO: Add comment
# 
# Author: BEAULATON Laurent
###############################################################################

#' @title Download a background map of Europe and North Africa
#' @param transparent logical. Do you want this background map be a bit transparent?
#' @param mapbox A vector of for decimal coordinates giving the bounding box of the map (left, bottom, right, top)
#' @param mapType character string providing map theme. see getmap from ggmap package
#' @return a map
get_background_map = function(transparent = TRUE, mapbox = c(left = -13, bottom = 25, right = 40, top = 68), mapType = c("watercolor"))
{
	background_map = get_stamenmap(bbox = mapbox, zoom = 4, maptype = mapType, crop = TRUE)
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


