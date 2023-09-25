# functions to plot map series
###############################################################################

# TODO: packages needed not reference here. There is a risk of error if not already loaded. Should be added if we want to package this 
source("../utilities/get_background_map.R")

#' @title plot the series name in a map according to their 'updated' status
#' @param series_data sf. With 'ser_nameshort' for the name of the series and 'Updated' a logical
#' @param variable character. The name of the variable to map
#' @param palette_brewer character. The palette color to pass to scale_fill_brewer
#' @param lables logical. Should the labels be displayed
#' @param pch_cex integer. size of the point. Default = 2
#' @param ... argument for 'get_background_map' function
#' @return a ggplot
map_series = function(series_data, variable = "Updated", palette_brewer = "Set3", labels = TRUE, pch_cex = 2, ...)
{
	sf::sf_use_s2(FALSE)
	worldmap <- ne_countries(scale = 'medium', type = 'map_units',
		returnclass = 'sf')
	europe_cropped <- st_crop(worldmap, xmin = -13, xmax = 27,
		ymin = 35, ymax = 65)
	my_map = get_background_map(...)
	
	series_map = ggmap(my_map) + 
		guides(color = guide_legend(override.aes = list(size = 5) ) ) +
		ylab("") + xlab("") + theme(legend.key = element_rect(fill = "white"))
	
	if(labels)
	{
		series_map = series_map + 
			geom_label_repel(data = series_data,
			aes(x = ser_x, y = ser_y, label = ser_nameshort, col = !!as.symbol(variable)), 
			cex = 1.5, key_glyph = draw_key_text, max.overlaps = Inf, label.padding = 0.1, show.legend = FALSE)
		if(variable != "Updated")
			series_map = series_map + scale_color_brewer(type="qual", palette = palette_brewer) 
	}
	
	if(variable == "Updated")
	{
		series_map = series_map + 
			scale_fill_brewer(type="qual", palette = palette_brewer, guide = "none") + 
			geom_point(data = series_data, aes(x = ser_x, y = ser_y, col  = !!as.symbol(variable)), cex = pch_cex, pch = 20) +
			scale_color_manual("", values = c("TRUE" = "black", "FALSE" = "red"), breaks = c(TRUE, FALSE), labels = c("Updated", "Not updated")) 
	} else {
		series_map = series_map + 
			scale_fill_brewer(type="qual", palette = palette_brewer) + 
			geom_point(data = series_data, aes(x = ser_x, y = ser_y, fill  = !!as.symbol(variable)), cex = pch_cex, col = "black", pch = 21)
	}
	
	return(series_map)
}
