#' @title Graph for combined landings (including predictions)
#' @description The function uses ggplot
#' @param dataset The landings dataset
#' @param title A title for the graph, Default: NULL
#' @return A ggplot
#' @examples 
#' \dontrun{
#' landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
#' landings$eel_value <- as.numeric(landings$eel_value) / 1000
#' landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
#' pred_landings <- predict_missing_values(landings, verbose=TRUE) 
#' title <- paste("Landings for : ", paste(c("Y","S"),collapse="+"))
#' # colors
#' country_ref = extract_ref("Country")
#' country_ref = country_ref[order(country_ref$cou_order), ]
#' country_ref$cou_code = factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)
#' 
#' values=c(RColorBrewer::brewer.pal(12,"Set3"),
#'     RColorBrewer::brewer.pal(12, "Paired"), 
#'     RColorBrewer::brewer.pal(8,"Accent"),
#'     RColorBrewer::brewer.pal(7, "Dark2"))
#' color_countries = setNames(values,cou_cod)
#' combined_landings_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
#' }
#' @rdname combined_landings_graph
#' @export 
combined_landings_graph<-function (dataset, title=NULL , col , country_ref)
{ 
  
  dataset<-rename(dataset,"Country"="eel_cou_code")  
  ### To order the table by cou_code (geographical position)
  dataset$Country<-factor(dataset$Country,levels=country_ref$cou_code,ordered=TRUE)
  
  landings_year<-aggregate(eel_value~eel_year, dataset, sum)
  #########################
  # graph
  #########################
  
  # reconstructed
  g_reconstructed_landings <- ggplot(dataset) + 
      geom_col(aes(x=eel_year,y=eel_value,fill=Country),position='stack')+
      ggtitle(title)+ 
      xlab("Year") + ylab("Landings (tons)")+
      coord_cartesian(expand = FALSE, ylim = c(0, max(landings_year$eel_value)*1.6)) +
      scale_fill_manual(values=col)+
      theme_bw()
  
  # percentage of original data
  g_percentage_reconstructed <- ggplot(dataset)+
      geom_col(aes(x=eel_year,y=eel_value,fill=!predicted),position='stack')+
      xlab("") + 
      ylab("")+
      scale_fill_manual(name = "Data", values=c("black","grey"),labels=c("Predicted","Raw"))+
      theme_bw()+    
      theme(legend.position="top")
  
  
  g3_grob <- ggplotGrob(g_percentage_reconstructed)
  g_combined_landings <- g_reconstructed_landings+
      annotation_custom(g3_grob, 
          xmin=min(dataset$eel_year), 
          xmax=max(dataset$eel_year), 
          ymin=max(landings_year$eel_value)*1.05, 
          ymax=max(landings_year$eel_value)*1.6)
  return(g_combined_landings)
  
  
}



#' @title Graph for raw landings, per 
#' @description The function uses ggplot
#' @param dataset The landings dataset
#' @param title A title for the graph, Default: NULL
#' @param col A named vector of colors, Default: color_countries
#' @param country_ref The country referential ordered from North to South, Default: country_ref
#' @param habitat=FALSE
#' @param lfs=FALSE
#' @return A ggplot
#' @examples 
#' \dontrun{
#' setwd(shiny_data_wd)
#' source(paste0(shiny_data_wd,"\\global.R"))
#' filtered_data <- filter_data("landings", 
#'    life_stage = NULL, 
#'    country = NULL, 
#'     habitat = NULL,
#'     eel_typ_id= 4,
#'     year_range = 1980:2018)        
#' # do not group by habitat or lfs, there might be several lfs selected but all will be grouped
#' landings <-group_data(filtered_data,geo="country",
#'     habitat=TRUE,
#'     lfs=TRUE)
#' landings$eel_value <- as.numeric(landings$eel_value) / 1000
#' landings$eel_cou_code = as.factor(landings$eel_cou_code)  


#' title <- paste("Landings for : ", paste(c("Y","S"),collapse="+"))
#' # colors
#' country_ref = extract_ref("Country")
#' country_ref = country_ref[order(country_ref$cou_order), ]
#' country_ref$cou_code = factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)
#' 
#' values=c(RColorBrewer::brewer.pal(12,"Set3"),
#'     RColorBrewer::brewer.pal(12, "Paired"), 
#'     RColorBrewer::brewer.pal(8,"Accent"),
#'     RColorBrewer::brewer.pal(7, "Dark2"))
#' color_countries = setNames(values,cou_cod)
#' raw_landings_graph(dataset=landings,title=title,col=color_countries, country_ref=country_ref)
#' }
#' @rdname raw_landings_graph
#' @export 
raw_landings_graph<-function (dataset, title=NULL, col=color_countries, 
    country_ref=country_ref, habitat=FALSE, lfs=FALSE)
{ 
  dataset<-rename(dataset,"Country"="eel_cou_code")
  dataset$Country<-factor(dataset$Country,levels=country_ref$cou_code,ordered=TRUE)
  
  if (!habitat & !lfs){
    g_raw_Rlandings <- ggplot(dataset) + geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab("Landings (tons)")+
        scale_fill_manual(values=col)+
        theme_bw()  
    return(g_raw_Rlandings)  
  } else if (!habitat){
    g_raw_Rlandings <- ggplot(dataset) + geom_col(aes(x=eel_year,y=eel_value,fill=Country),  position='stack')+
        ggtitle(title) + xlab("year") + ylab("Landings (tons)")+
        scale_fill_manual(values=col)+
        facet_wrap(~eel_lfs_code)+
        theme_bw()  
    return(g_raw_Rlandings)   
  } else if (!lfs){
    g_raw_Rlandings <- ggplot(dataset) + geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab("Landings (tons)")+
        scale_fill_manual(values=col)+
        facet_wrap(~eel_hty_code)+
        theme_bw()  
    return(g_raw_Rlandings)   
  } else {
    g_raw_Rlandings <- ggplot(dataset) + geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab("Landings (tons)")+
        scale_fill_manual(values=col)+
        facet_grid(eel_lfs_code~eel_hty_code)+
        theme_bw()  
    return(g_raw_Rlandings)     
  }  
}

#' @title Graph of aquaculture data
#' @description 
#' @param dataset Aquaculture data passed to the plot
#' @param title The title, generated dynamically by shiny, Default: NULL
#' @param col Colord vector of countries, Default: color_countries
#' @param country_ref The countries reference list, used for colors, Default: country_ref
#' @param lfs Is the graph split by lifestage, Default: FALSE
#' @param typ Should be one of 11 or 12, if 11 display tons in ylab legend.  Default: 11
#' @return A ggplot
#' @details 
#' @examples 
#' @rdname aquaculture_graph

aquaculture_graph<-function(dataset, title=NULL, col=color_countries, 
    country_ref=country_ref,  lfs=FALSE, typ=11)
{
  
  dataset<-rename(dataset,"Country"="eel_cou_code")
  dataset$Country<-factor(dataset$Country,levels=country_ref$cou_code,ordered=TRUE)
  if (typ == 11) the_ylab <- "Aquaculture (tons)" else the_ylab <- "Aquaculture number"
  # title already formatted is passed by the shiny and kg already converted to tons
  if (!lfs){
    g_aquaculture <-  ggplot(dataset) + 
        geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab(the_ylab)+
        scale_fill_manual(values=col)+
        theme_bw()  
  } else {
    g_aquaculture <-  ggplot(dataset) + 
        geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab(the_ylab)+
        scale_fill_manual(values=col)+
        facet_wrap(~eel_lfs_code)+
        theme_bw()  
  }
  return(g_aquaculture)
}

#' @title Graph for release
#' @description 
#' @param dataset Release data passed to the plot
#' @param title The title, generated dynamically by shiny, Default: NULL
#' @param col Colord vector of countries, Default: color_countries
#' @param country_ref The countries reference list, used for colors, Default: country_ref
#' @param lfs Is the graph split by lifestage, Default: FALSE
#' @param typ Should be one of 8 or 9, if 10 display tons in ylab legend.  Default: 10
#' @return A ggplot
#' @details 
#' @examples 
#' @rdname aquaculture_graph
release_graph <- function(dataset,
    title = NULL,
    col=color_countries, 
    country_ref=country_ref,
    lfs = FALSE,
    typ = 8){
  dataset<-rename(dataset,"Country"="eel_cou_code")
  dataset$Country<-factor(dataset$Country,levels=country_ref$cou_code,ordered=TRUE)
  the_ylab <- dplyr::case_when(typ == 8 ~  "Release (kg)",
          typ == 9 ~ "1000 * Release (n)",
          typ == 10 ~  "1000 * Glass eel equivalents(n)")
  # title already formatted is passed by the shiny and kg already converted to tons
  if (!lfs){
    g_release <-  ggplot(dataset) + 
        geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab(the_ylab)+
        scale_fill_manual(values=col)+
        theme_bw()  
  } else {
    g_release<-  ggplot(dataset) + 
        geom_col(aes(x=eel_year,y=eel_value,fill=Country), position='stack')+
        ggtitle(title) + xlab("year") + ylab(the_ylab)+
        scale_fill_manual(values=col)+
        facet_wrap(~eel_lfs_code)+
        theme_bw()  
  }
  return(g_release)
}


