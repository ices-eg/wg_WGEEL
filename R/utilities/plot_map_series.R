# functions to plot map series
###############################################################################

# TODO: packages needed not reference here. There is a risk of error if not already loaded. Should be added if we want to package this 
source("../utilities/get_background_map.R")

#' @title plot the series name in a map according to their 'updated' status
#' @param series_data sf. With 'ser_nameshort' for the name of the series and 'Updated' a logical
#' @return a ggplot
map_series = function(series_data)
{
	sf::sf_use_s2(FALSE)
	worldmap <- ne_countries(scale = 'medium', type = 'map_units',
		returnclass = 'sf')
	europe_cropped <- st_crop(worldmap, xmin = -13, xmax = 27,
		ymin = 35, ymax = 65)
	my_map = get_background_map(transparent = FALSE, mapType = c("terrain-background"), mapbox = c(left = -13, bottom = 35, right = 27, top = 65))
	
	series_map = ggmap(my_map) + 
		geom_point(data = series_data, aes(x = ser_x, y = ser_y, col  = Updated), cex = 2, pch = 20) +
		geom_label_repel(data = series_data,
			aes(x = ser_x, y = ser_y, label = ser_nameshort, col = Updated), 
			cex = 1.5, key_glyph = draw_key_text, max.overlaps = Inf, label.padding = 0.1, show.legend = FALSE) +
		scale_color_manual("",values=c("TRUE"="black","FALSE"="red"),breaks=c(TRUE,FALSE), labels=c("Updated","Not updated")) +
#		scale_color_manual(name = "Updated?", values = c("red", "green"), guide = "none")+
		guides(color = guide_legend(override.aes = list(size = 5) ) ) +
		ylab("") + xlab("") + theme(legend.key = element_rect(fill = "white"))

	return(series_map)
}
