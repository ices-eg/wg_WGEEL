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
#' combined_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
#' }
#' @rdname combined_graph
#' @export 


combined_graph<-function (dataset, title=NULL , col , country_ref)
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


