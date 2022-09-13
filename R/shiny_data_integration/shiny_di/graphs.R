

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


s_graph<-function (dataset,level, year_column)
{ 
	if (nrow(dataset)==0) return(NULL)
	dataset$kept <- "Not kept, eel_qal_id = 0 or 18 ... 22 "
	qal_column <- swith(level, "dataseries"="das_qal_id",
			"group metrics"="meg_qal_id",
			"individual metrics"="fi_qal_id")
	dataset <-dataset %>% mutate(kept= 
			case_when(!!!sym(qal_column) %in% c(1,2,4)~"Kept, eel_qal_id = 1 (good), 2 (corrected) or 4 (dubious)",
					TRUE ~ "Not kept" ))
					

	grouped_dataset <- dataset %>% group_by(kept, !!sym(year_column), ser_nameshort) %>% summarize(nobs=n())
	g <-ggplot(grouped_dataset)+geom_col(aes(x=eel_year,y=nobs,fill=ser_nameshort), position='stack')+
			facet_grid(kept ~ . )+
			ggtitle("Clik a bar for details ...")
	theme_bw() 
	return(g)         
}

