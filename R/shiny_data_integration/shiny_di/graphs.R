

#' @title Graph to check for duplicates
#' @description The function uses ggplot
#' @param dataset The landings dataset
#' @return A ggplot
#' @examples 
#' # Test with a query as in the app -------------------------------------------------------------------
#' 
#' query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) 
#' and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
#'                   vals = 'FR', types = c(4), minyear = 1980, maxyear = 2018, 
#'                   .con = pool)
#' dataset<- sqldf(query)
#' 
#' # Generate a wrong dataset for test -----------------------------------------------------------------
#' 
#' dataset1 <- dataset[1:50,] # artifically generate a dataset with duplicates
#' dataset1$eel_qal_id <- 2 # modified by wgeel
#' dataset2 <- dataset[51:100,] # artifically generate a dataset rejected by wgeel
#' dataset2$eel_value <- dataset2$eel_value/2
#' dataset2$eel_qal_id <- rep(c(3,18), nrow(dataset2)/2) 
#' dataset <- rbind(dataset, dataset1, dataset2)
#' 
#' # function ------------------------------------------------------------------------------------------
#' 
#' duplicated_values_graph(dataset)
#' grid:: grid.locator(unit="native")
#' 
#' @rdname duplicated_values_graph
duplicated_values_graph<-function (dataset)
{ 
	if (nrow(dataset)==0) return(NULL)
	dataset$kept <- "Not kept, eel_qal_id = 3 or 18...22 "
	dataset$kept[ dataset$eel_qal_id %in% c(1,2,4) ] <- "Kept, eel_qal_id = 1 (good), 2 (corrected) or 4 (dubious)"
	grouped_dataset <- dataset %>% group_by(kept, eel_year) %>% summarize(eel_value=sum(eel_value,na.rm=TRUE),nobs=n())
	g <-ggplot(grouped_dataset)+geom_col(aes(x=eel_year,y=eel_value,fill=nobs), position='stack')+
			facet_grid(kept ~ . )+
			scale_fill_viridis()+
			ggtitle("Clik a bar for details ...", subtitle='Color according to number of observations')
	theme_bw() 
	return(g)         
}


series_graph<-function (dataset,level, year_column, kept_or_datacall="kept")
{ 
	if (nrow(dataset)==0) return(NULL)
	dataset$kept <- "Not kept, eel_qal_id = 0 or 18 ... 22"
	dataset[,qal_column][is.na(dataset[,qal_column])] <-""
	dataset[dataset[,qal_column]%in% c("1","2","4"),"kept"] <- "Kept"
				
	
	#save(grouped_dataset, file="c:/temp/grouped_dataset.Rdata")

	if (kept_or_datacall=="kept"){
		dataset$das_dts_datasource[is.na(dataset$das_dts_datasource)]<- "Unknown"
		grouped_dataset <- dataset %>% 
				group_by(das_dts_datasource, !!sym(year_column), kept) %>%
				summarize(nobs=n())
		
		g <- ggplot(grouped_dataset) + 
				geom_tile(aes_string(x=year_column,y="nobs",fill="kept")) +
				scale_fill_manual("series used ?", values = c("Not kept, eel_qal_id = 0 or 18 ... 22"="red","Kept"="red" ))
				ggtitle("Clik a bar for details ...") +
				theme_bw() 
		return(g)  
	} else {
		grouped_dataset <- dataset %>% 
				group_by(das_dts_datasource, !!sym(year_column), ser_nameshort) %>%
				summarize(nobs=n())
		
		g <-ggplot(grouped_dataset)+geom_tile(aes_string(
								x=year_column,
								y="ser_nameshort",
								fill="das_dts_datasource"))+
				ggtitle("Clik a bar for details ...")+
				theme_bw() 
		return(g)
	}
}

