# Functions for the corresponding rmd
###############################################################################

get_background_map = function()
{
	mapbox = c(left = -13, bottom = 25, right = 40, top = 68)
	background_map=get_stamenmap(bbox = mapbox, zoom = 4, maptype = c("watercolor"), crop = TRUE)
	attr = attributes(background_map)
	background_map_transparent = matrix(adjustcolor(background_map, 
			alpha.f = 0.2), 
		nrow = nrow(background_map))
	attributes(background_map_transparent) <- attr
	
	return(background_map_transparent)
}

