#' @title Graph for combined landings (including predictions)
#' @description The function uses ggplot
#' @param dataset The landings dataset
#' @param title A title for the graph, Default: NULL
#' @return A ggplot
#' @examples 
#' \dontrun{
#' landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
#' landings$eel_value <- as.numeric(landings$eel_value) / 1000
#' colnames(landings)<-gsub("eel_","",colnames(landings))
#' landings$cou_code = as.factor(landings$cou_code)                       
#' pred_landings <- predict_missing_values(landings, verbose=TRUE) 
#' CombinedCLandingsGraph
#' }
#' @rdname CombinedCLandingsGraph
#' @export 


combined_graph<-function (dataset, title=NULL)
{ 
  complete2<-dataset

    ### To order the table by country (geographical position)
    Country<-factor(complete2$country,levels=cou_cod,ordered=T)
    Country<-droplevels(Country)
    
    landings_year<-aggregate(landings~year, complete2, sum)
    #########################
    # graph
    #########################

    # reconstructed
    g_reconstructed_landings <- ggplot(complete2) + geom_col(aes(x=year,y=landings,fill=Country),position='stack')+
      ggtitle(title)+ 
      xlab("Year") + ylab("Landings (tons)")+
      coord_cartesian(expand = FALSE, ylim = c(0, max(landings_year$landings)*1.6)) +
      scale_fill_manual(values=col)+
      theme_bw()
    
    # percentage of original data
    g_percentage_reconstructed <- ggplot(complete2)+geom_col(aes(x=year,y=landings,fill=!predicted),position='stack')+
      xlab("") + 
      ylab("")+
      scale_fill_manual(name = "Data", values=c("black","grey"),labels=c("Predicted","Raw"))+
      theme_bw()+    
      theme(legend.position="top")

    
    g3_grob <- ggplotGrob(g_percentage_reconstructed)
    g_combined_landings <- g_reconstructed_landings+annotation_custom(g3_grob, xmin=min(complete2$year), xmax=max(complete2$year), ymin=max(landings_year$landings)*1.05, ymax=max(landings_year$landings)*1.6)
    x11()

    
    print(g_combined_landings)
    

  
  return(g_combined_landings)

}
 

 