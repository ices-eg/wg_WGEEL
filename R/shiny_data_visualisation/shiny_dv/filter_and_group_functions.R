# Name : filter_and_group_functions.R
# Date : Date
# Author: cedric.briand
###############################################################################


#########################
# functions -----------------------------------------------------------------------------------------
########################

# filter_data ---------------------------------------------------------------------------------------

#' @title Filtering function
#' @description This will filter according to user choice
#' @param dataset A character value, one of 'landings', 'aquaculture', 'stocking', 'precodata' pre 
#' loaded in the app
#' @param typ The type of data, 4 or 6, shiny returns a character.
#' @param life_stage The life stage, Default: NULL
#' @param country The country, Default: NULL
#' @param habitat The habitat, one of c("MO", "C", "T", "F", "AL", "NA"), Default: NULL
#' @param year_range A vector of years, Default: 1900:2100
#' @return filtered dataset
#' @details In a previous version the selection was done using a generated expression contraining all
#' elements of the argument (for instance if country=NULL then country=country_ref$cou_code), to generate
#' all possible levels. In the new, more complicated version when NULL is passed then the argument is ignored
#' if not null then we pass a list of quosures which is spliced using !!!
#' @examples 
#' \dontrun{
#' filter_data(dataset='landings',life_stage = NULL, country = NULL, habitat=NULL, year_range=2010:2018)
#' filter_data(dataset='landings',typ= 4 ,life_stage = NULL, country = "AL", habitat=NULL, 
#' year_range=2010:2021)
#' filter_data(dataset = "precodata",life_stage = NULL, country = levels(country_ref$cou_code),
#' year_range=2000:2018) 
#' }
#' @seealso 
#'  \code{\link[dplyr]{filter}}
#' @rdname filter_data
#' @importFrom dplyr filter
filter_data = function(dataset, typ=NULL, life_stage = NULL, country = NULL, habitat=NULL, 
    year_range = 1900:2100)
{
  mydata <- get(dataset)
  mydata <- filter(mydata, eel_typ_id != 33) #we remove other_landings_n
  
  # this is the list of quosures
  expr <- list()
  # year is always passed
  expr[[1]] <- rlang::quo(eel_year %in% year_range)
  # country is passed if not null, if NULL then the dataset will not be filtered
  i=2
  if (!is.null(typ)& dataset != "precodata") {
	  expr[[i]]=rlang::quo(eel_typ_id%in% typ) 
	  i=i+1
  }  
  if (!is.null(country)) {
    expr[[i]]=rlang::quo(eel_cou_code %in% country) 
    i=i+1
  }  
  if (!is.null(life_stage)) {
    expr[[i]]=rlang::quo(eel_lfs_code%in%life_stage) 
    i=i+1
  }   
  if (!is.null(habitat) & dataset != "precodata") {
    # NA will be displayed as a data type, they are included in the shiny list of possible choices
    mydata$eel_hty_code[is.na(mydata$eel_hty_code)]<-"NA"
    expr[[i]]=rlang::quo(eel_hty_code %in% habitat) 
    i=i+1
  } 
 
  
  # !!! takes a list of elements and splices them into to the current call
  filtered_data = mydata%>%dplyr::filter(!!!expr)
  # this will retain all levels for graph
  # filtered_data$eel_hty_code = factor(filtered_data$eel_hty_code, 
  # levels = rev(c("MO", "C", "T", "F", "AL", "NA")))
  
  return(filtered_data)
}
#filter_precodata filtre pour créer les jeux de données pour la table et le graphe de preco

filter_precodata = function(dataset, country=NULL, habitat=NULL,lfs=NULL, year_range = 1900:2100){
  mydata <- get(dataset)
  
  if(!is.null(lfs)){
    
    if (!is.null(country) & !is.null(habitat)){
      filtered_data<-subset(mydata, eel_cou_code %in% country & eel_lfs_code %in% lfs & eel_year %in% year_range & eel_hty_code %in% habitat)
      
    }
    
    if (!is.null(country) & is.null(habitat)){ 
      filtered_data<-subset(mydata, eel_cou_code %in% country & eel_lfs_code %in% lfs & eel_year %in% year_range)
      
    }
    
    if (!is.null(habitat) & is.null(country)){
      filtered_data<-subset(mydata, eel_year %in% year_range & eel_lfs_code %in% lfs & eel_hty_code %in% habitat)
      #filtered_data <-aggregate(selection, by=list(selection$eel_year, selection$eel_cou_code),
      #  FUN=mean, na.rm=TRUE)
    }
    if (is.null(country) & is.null(habitat)){
      
      filtered_data<-subset(mydata, eel_year %in% year_range & eel_lfs_code %in% lfs)
      
    }
  }else{
    if (!is.null(country) & !is.null(habitat)){
      filtered_data<-subset(mydata, eel_cou_code %in% country & eel_year %in% year_range & eel_hty_code %in% habitat)
      
    }
    
    if (!is.null(country) & is.null(habitat)){ 
      filtered_data<-subset(mydata, eel_cou_code %in% country & eel_year %in% year_range)
      
    }
    
    if (!is.null(habitat) & is.null(country)){
      filtered_data<-subset(mydata, eel_year %in% year_range & eel_hty_code %in% habitat)
      
    }
    if (is.null(country) & is.null(habitat)){
      
      filtered_data<-subset(mydata, eel_year %in% year_range)
      
    }    
    
  }
  
  return(filtered_data)  
}

### an aggregate function for the precodata

agg_precodata<-function(dataset,geo="country",country=NULL,habitat=NULL, year_range = 1900:2100){
   
  dataset2<-data.frame(dataset,sumht=dataset$sumh*dataset$bbest,sumat=dataset$suma*dataset$bbest,sumft=dataset$sumf*dataset$bbest)
  
  if(!is.null(habitat)){
	if (geo=="country"){
	  agg_data<-dataset2 %>% 
		  group_by(eel_cou_code,eel_year) %>% 
		  summarise(bcurrent = sum(bcurrent), bbest = sum(bbest), b0 = sum(b0) , 
			  sumA = sum(sumat)/sum(bbest, na.rm=T),sumF = sum(sumft)/sum(bbest, na.rm=T), 
			  sumH=sum(sumht)/sum(bbest, na.rm=T))
	} else {
	  agg_data<-dataset2 %>% 
		  group_by(eel_emu_nameshort,eel_year) %>% 
		  summarise(bcurrent = sum(bcurrent), bbest = sum(bbest), b0 = sum(b0), 
			  sumA = sum(sumat)/sum(bbest, na.rm=T),sumF = sum(sumft)/sum(bbest, na.rm=T), 
			  sumH=sum(sumht)/sum(bbest, na.rm=T))
	}
  } else {
	if (geo=="country"){
	  agg_data<-dataset2 %>% 
		  group_by(eel_cou_code,eel_year,eel_hty_code) %>% 
		  summarise(bcurrent = sum(bcurrent), bbest = sum(bbest), b0 = sum(b0) , 
			  sumA = sum(sumat)/sum(bbest, na.rm=T),sumF = sum(sumft)/sum(bbest, na.rm=T), 
			  sumH=sum(sumht)/sum(bbest, na.rm=T))
	} else {
	  agg_data<-dataset2 %>% 
		  group_by(eel_emu_nameshort,eel_year,eel_hty_code) %>% 
		  summarise(bcurrent = sum(bcurrent), bbest = sum(bbest), b0 = sum(b0) , 
			  sumA = sum(sumat)/sum(bbest, na.rm=T),sumF = sum(sumft)/sum(bbest, na.rm=T), 
			  sumH=sum(sumht)/sum(bbest, na.rm=T))
	}   
  } 
  
  
  return(agg_data)
}
##

# group_data ----------------------------------------------------------------------------------------

#' @title function to group data
#' @description Data are grouped in the simplest way (year, country) or also by habitat or life stage, 
#' the grouping can be by emu or country
#' @param dataset the data
#' @param geo One of 'country' or 'emu', Default: 'country'
#' @param habitat Do you want result split per habitat, Default: FALSE
#' @param lfs Do you want results split by life stage, Default: FALSE
#' @param na.rm What to do when sum
#' @return A grouped dataset
#' @details ...
#' @examples 
#' \dontrun{  
#'  filtered_data <- filter_data(dataset='landings',life_stage = NULL, country = NULL, habitat=NULL, year_range=1960:2011)
#'  grouped_data <- group_data(filtered_data, geo="country", habitat=FALSE, lfs=FALSE)
#' }
#' @seealso 
#'  \code{\link[dplyr]{group_by}}
#' @rdname group_data
#' @importFrom dplyr group_by
group_data <- function(dataset, geo="country", habitat=FALSE, lfs=FALSE, na.rm = TRUE){
  if (!geo %in% c("country","emu")) stop ("geo should be country or emu")
  if (habitat & lfs){
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_nameshort,eel_year,eel_hty_code,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
      
    }
    
  } else if (habitat){ 
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_nameshort,eel_year,eel_hty_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    }
    
  } else if (lfs) {
    # filtered by habitat and lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_nameshort,eel_year,eel_lfs_code) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    }    
    
  } else {
    # not filtered by habitat nor lfs
    if (geo=="country") {
      # by country
      dataset <- dataset %>%
          dplyr::group_by(eel_cou_code,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
    } else {
      # by emu
      dataset <- dataset %>%
          dplyr::group_by(eel_emu_nameshort,eel_year) %>%
	      summarize(eel_value=sum(eel_value,na.rm=na.rm))
      
    }
  }
  return(dataset)
}  
