# functions to plot map series
###############################################################################

# TODO: packages needed not reference here. There is a risk of error if not already loaded. Should be added if we want to package this 
source("../utilities/get_background_map.R")

#' @title plot the series name in a map according to their 'updated' status
#' @param series_data sf. With 'ser_nameshort' for the name of the series and 'Updated' a logical
#' @return a ggplot
map_series = function(series_data, variable = "Updated", labels = TRUE, ...)
{
	sf::sf_use_s2(FALSE)
	worldmap <- ne_countries(scale = 'medium', type = 'map_units',
		returnclass = 'sf')
	europe_cropped <- st_crop(worldmap, xmin = -13, xmax = 27,
		ymin = 35, ymax = 65)
	my_map = get_background_map(...)
	
	series_map = ggmap(my_map) + 
		geom_point(data = series_data, aes(x = ser_x, y = ser_y, col  = !!as.symbol(variable)), cex = 2, pch = 20) +
		scale_fill_brewer(type="qual", palette = "Set3")+
		scale_color_brewer(type="qual", palette = "Set3") + 
		guides(color = guide_legend(override.aes = list(size = 5) ) ) +
		ylab("") + xlab("") + theme(legend.key = element_rect(fill = "white"))
	
	if(variable == "Updated")
	{
		series_map = series_map + scale_color_manual("", values = c("TRUE" = "black", "FALSE" = "red"), breaks = c(TRUE, FALSE), labels = c("Updated", "Not updated")) 
	}
	
	if(labels)
	{
		series_map = series_map + geom_label_repel(data = series_data,
			aes(x = ser_x, y = ser_y, label = ser_nameshort, col = !!as.symbol(variable)), 
			cex = 1.5, key_glyph = draw_key_text, max.overlaps = Inf, label.padding = 0.1, show.legend = FALSE)
	}

	return(series_map)
}
