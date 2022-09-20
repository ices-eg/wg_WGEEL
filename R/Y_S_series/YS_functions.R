# function specific to dfa.RMD other than DFA
###############################################################################

#' @title plot the number of observation by year
#' @param mydata dataframe. With a 'year' column and a 'n' column giving the nb of observation
#' @return a ggplot
plot_nb_observation = function(mydata)
{
	point_per_year<- mydata %>%
		group_by(year) %>%
		summarize(n=n_distinct(id)) %>%
		select(year, n)
	
	myplot = ggplot(point_per_year, aes(x = year, y = n))+
		geom_line() + geom_point() +
		xlab("") + ylab("Number of available data") +
		scale_y_continuous(expand = c(0, 0), limits = c(0, NA))  + 
		theme_classic()
	
	return(myplot)
}

#' @title select the appropriate data for a GAM
#' @param mydata dataframe/tibble to be analysed. should have a 'id' and a 'year' column and a column 'value' if freq_maxi0 < 1
#' @param yearBegin, yearEnd integer. the minimum and maximum year (included) for selecting the data
#' @param nbYearMin integer. Minimum number of years to be incuded
#' @param freq_maxi0 numeric between 0 and 1. Series with frequency of 0 above are removed. If 1, no selection
#' @return a ggplot
select_data = function(mydata, yearBegin = 0, yearEnd = 5000, nbYearMin = 10, freq_maxi0 = 1)
{
	
	mydata = mydata %>%
		filter(year >= yearBegin, year <= yearEnd)
	
	nbpointsgam = mydata %>%
		group_by(id) %>%
		summarise(nbyear = n_distinct(year))%>%
		filter(nbyear >= 10)
	
	data_gam <- mydata %>%
		filter(id %in% nbpointsgam$id)
	
	#we also removed ser_id for which 0 represents more than 10% of data
	if(freq_maxi0<1)
	{
		data_gam <- data_gam %>%
			group_by(id) %>%
			mutate(nb_values = n(), nb_zeros = sum(value==0)) %>%
			mutate(freq_zero = nb_zeros/nb_values)%>%
			filter(freq_zero < freq_maxi0)
	}
	
	return(data_gam)
}

#'@title plot standardized index and a gam soother
#' @param mydata dataframe/tibble to be plotted. should have a 'id', a 'year' and a 'value' column
#' @return a ggplot
plot_smooth_gam = function(mydata)
{
	data_std = mydata%>%
		group_by(id)%>%
		mutate(value = (value - mean(value, na.rm =TRUE)) / sd(value, na.rm = TRUE))
	
	myplot = ggplot(data_std) +
		aes(x = year, y = value) +
		geom_line(aes(col=as.factor(ser_nameshort))) +
		geom_smooth(method="gam") +
		xlab("Year") +  ylab("Standardised abundance index") +
		guides(col="none") + 
		theme_classic()
	
	return(myplot)
}

#'@title compute simple GAM per country
#' @param  mydata dataframe. dataframe/tibble to be analysed. should have a 'id', a 'year', a 'value' and a 'country' column
#' @return a GAM model
GAM_series = function(mydata)
{
	model = gam(value ~ s(year, by=country), data = mydata, family = gaussian())
	
	return(model)
}

#'@title plot the result of  simple GAM per country
#' @param  mymodel GAM model as a result of 'GAM_series' function
#' @return a ggplot
plot_GAM_series = function(mymodel)
{
	modelised_data = mymodel$model
	
	# compute mean of the standardized values to be included in figure
	data_std_mean <- modelised_data %>% 
		group_by(country, year) %>% 
		summarize(mean_value = mean(value), N = n()) %>% 
		ungroup() 
	
	cols <- color_countries[as.character(unique(data_std_mean$country))]
	
	gam_plot_data = generate_dataset_plot_gam(g1)
	
	gam_plot_data = gam_plot_data %>% 
		mutate(country = factor(country, levels = country_ref$cou_code, ordered=TRUE))
	
	myplot = ggplot(gam_plot_data) +
		aes(x = year, y = pred) +
		geom_line() +
		geom_ribbon(aes(ymin=lower, ymax=upper,  fill = country), alpha=.8) +
		geom_point(aes(x = year, y= mean_value), data = data_std_mean) +
		facet_wrap(vars(country)) +
		scale_fill_manual(values=cols, guide = "none") +
		theme_classic() + ylab("Relative abundance") + xlab("Year")
	
	return(myplot)
}

#'@title generate a dataset from a GAM model for plotting
#' @param  mymodel GAM model as a result of 'GAM_series' function
#' @return a dataframe
generate_dataset_plot_gam = function(mymodel){
	model_data = mymodel$model
	
	country = levels(droplevels(model_data$country))
	
	mydataset = do.call('rbind.data.frame', lapply(country, 
			function(cou){
				year_range = model_data %>% 
					filter(country == cou) %>% 
					select(year) %>% pull() %>% 
					range(na.rm = TRUE)
				years = year_range[1]:year_range[2]
				pred=predict(mymodel, data.frame(year = years, country = cou), type = "response",
					se.fit=TRUE)
				data.frame(year=years,
					country=cou,
					pred=pred$fit,
					lower=pred$fit-1.96*pred$se.fit,
					upper=pred$fit+1.96*pred$se.fit)
				
			}))
	
	return(mydataset)
}
