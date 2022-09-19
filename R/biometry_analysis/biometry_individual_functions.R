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
	  
	  map<-get_legend(p)
	  
	} else if (only_legend=="no"){
	  
	  map<- p + theme(legend.position="none")
	} else{
	  
	  map<-p
	}
	
	return(map)
}

#' @title Plot a distribution by lifestage and an other variable for a given variable
#' @param mydata individual data you want to plot
#' @param lifeStage character or vector. One of or any combinaison of 'G', 'Y', 'S'
#' @param var character. Which variable you want to map? One of 'length', 'weight', 'sexratio', 'age'
#' @param group character. which variable you want to use for the y axis ('country' or 'gear')
#' @return a map
plot_distribution = function(mydata = total_individual, lifeStage, var = "length", group = "country", scale_value = 3, bandwidth_value = 5)
{
	#TODO: add the number of samples for each line
	
	var_name=switch (var,
		"length" = "lengthmm",
		"weight" = "weightg",
		"age" = "ageyear"
	)
	
	xlabel=switch (var,
		"length" = "Length (mm)",
		"weight" = "Weight (g)",
		"age" = "Age"
	)
	
	group = switch(group,
	  "country"="country",
	  "gear"="gear"
	  )
	
	mydata_prepared <- mydata %>% filter(!is.na(!!as.symbol(var_name)), life_stage %in% lifeStage) %>%
		mutate(life_stage  = case_when(life_stage =="G" ~"Glass eel", life_stage =="Y" ~"Yellow eel", life_stage =="S" ~ "Silver eel")) %>%
		mutate(country = factor(country, levels = cou_ref$cou_code, ordered=TRUE))
	
	mydata_summarised = mydata_prepared %>% 
		group_by(life_stage, !!as.symbol(group)) %>%
		summarise(min = min(!!as.symbol(var_name)), max = max(!!as.symbol(var_name)), mean = mean(!!as.symbol(var_name)))
	
p<-	ggplot(mydata_prepared) + aes(x = !!as.symbol(var_name), y=!!as.symbol(group), fill = !!as.symbol(group), alpha=0.5)  + 
		geom_density_ridges( scale = scale_value, rel_min_height = 0.003, bandwidth = bandwidth_value) + 
		geom_point(data = mydata_summarised, aes(x = min), pch = 19, color = "red", size = 2, alpha = 1, show.legend = FALSE) +
		geom_point(data = mydata_summarised, aes(x = max), pch = 19, color = "red", size = 2, alpha = 1, show.legend = FALSE) +
		geom_segment(data = mydata_summarised, aes(x = min, xend = max, yend = !!as.symbol(group)), alpha = 1, show.legend = FALSE) +
		scale_alpha(guide="none") +
		xlab(xlabel) +
		ylab(str_to_title(group)) +
		coord_cartesian(expand = FALSE) + xlim(c(0, NA)) + 
  		theme_classic() 

if(group=="country"){
  
  graph<- p + scale_fill_manual("Country", values = color_countries[names(color_countries) %in% unique(mydata_prepared$country)], drop = TRUE, guide = "none")+
          scale_y_discrete(limits = rev) + facet_grid(vars(life_stage))  
    
}else{
  
  graph<-p+facet_grid(vars(life_stage), scales="free_x") 
}

return(graph)	
	
	
}
