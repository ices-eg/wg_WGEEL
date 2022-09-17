# Functions for the corresponding rmd
###############################################################################

source("../utilities/get_background_map.R")

#' @title Plot a map of available data
#' @param var character. Which variable you want to map? One of 'length', 'weight', 'sexratio', 'age'
#' @param stage character. For Which life stage? One of 'G', 'Y', 'S'
#' @param mydata dataframe or tibble. Summary statistics including coordinates.
#' @param transparent logical. Do you want this background map be a bit transparent?
#' @return a map
plot_map_bio_emu = function(var, stage, mydata = stats_data_coord, transparent = TRUE, only_legend){
	background_map = get_background_map(transparent)
	
	if(!only_legend %in% c("yes","no","both"))stop("You can only use yes, no or both in only_legend")
	data=mydata %>%
		filter(life_stage==stage)
	
	var_name=switch (var,
		"length" = "lengthmm",
		"weight" = "bio_weight",
		"sexratio" = "female_proportion",
		"age" = "ageyear"
	)
	
	title=switch (stage,
		"G" = "Glass eel",
		"Y" = "Yellow eel",
		"S" = "Silver eel"
	)
	
	
	data <- data %>%
		filter(!!as.symbol(paste("n_",var_name,sep=""))>=5)
	
	p<-ggmap(background_map) + 
	geom_point(data=data,
			aes(x = coord_x, y = coord_y, fill = source,   shape= habitat), size = 3, alpha = 0.6)+
		scale_shape_manual("Habitat type", breaks = c("MO", "C", "T", "F"), values = 21:24)+
		scale_fill_viridis_d("Source") + scale_color_discrete("Source")+
		guides(fill = guide_legend(override.aes = list(shape = 21) ) ) +
		theme_bw()+xlab("")+ylab("") + ggtitle(title)
	
	if (only_legend=="yes"){
	  
	  map<-get_legend2(p)
	  
	} else if (only_legend=="no"){
	  
	  map<- p + theme(legend.position="none")
	} else{
	  
	  map<-p
	}
	
	return(map)
}
