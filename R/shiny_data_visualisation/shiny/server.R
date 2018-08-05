# server paramater for shiny
# 
# Author: lbeaulaton
###############################################################################

# create server configuration
server = function(input, output) {
  
  data<-reactiveValues()
  
  
  data_to_display <- reactive( 
        {
              if(input$dataset == "precodata"){
	      to_display = filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$year[1]:input$year[2])
	      to_display = to_display[order(to_display$cou_order, to_display$eel_year), ]
              } else {	
          filtered_data <- filter_data(input$dataset, 
              life_stage = input$lfs, 
              country = input$country, 
              year_range = input$year[1]:input$year[2])
          if (input$lfs=="Ignored") choose_habitat=FALSE        
          grouped_data <- group_data(filtered_data,geo=input$geo, habitat=choose_habitat)
	      data$filtered_data<-filtered_data
          data$grouped_data <-grouped_data
              }    
        })
  
  # table
  output$table = DT::renderDataTable({
        table = dcast(data$grouped_data, eel_year~eel_cou_code, value.var = "eel_value")  	
        #ordering the column accordign to country order
        country_to_order = names(table)[-1]
        n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
        table = table[, c(1, n_order+1)]
        DT::datatable(table, rownames = FALSE, options = list(dom = 'lftp', pageLength = 10))}
  )
  
  output$downloadData <- downloadHandler(
	  filename = function() { paste(input$dataset,'_', input$year[1], '-', input$year[2], '.csv', sep='') },
	  content = function(file) {
#				if(input$dataset == "precodata"){
#					write.csv(filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$yearmin:input$yearmax), file, row.names = FALSE)
#				} else {
#					write.csv(dcast(filter_data(input$dataset, life_stage = input$lfs, country = input$country, year_range = input$yearmin:input$yearmax),eel_year~eel_cou_code), file, row.names = FALSE)
#				}
		write.csv(data_to_display(input), file, row.names = FALSE)
	  }
  )
  
  ######################################"
  # GRAPH
  ######################################
  observeEvent(input$dataset, {
        
        switch(input$dataset,
            "aquaculture"={
              
            },
            "landings"={
              # download the data + transform into tonnes + create new names for the habitat  
              
              landings_complete$eel_value<-as.numeric(landings_complete$eel_value) / 1000
              landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))
              landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code,eel_lfs_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
              colnames(landings)<-c("year","country","lfs","landings")
              landings$country = as.factor(landings$country)
              landings$lfs = as.factor(landings$lfs)
              
              landings$year = as.numeric(as.character(landings$year))
              
              output<-renderUI(
                  div( span(
                          radioButtons(inputId="landings_graph_type", label="Graph type:",
                                                         choices=c(
                                                                 "Raw and reconstructed combined"="combined",
                                                                 "Available Data"="available",
                                                                 "Raw landings per habitat average"="average_habitat",
                                                                 "Raw landings per habitat sum"="sum_habitat",)   
                          )
                      
                                        )
                                
                                )
                        )
              
            }, 
            "stocking"={
              
            },  
            "precodata"={              
              precodata_sel<-filter_data(
                  dataset = "precodata", 
                  life_stage = NULL, 
                  country = input$country, 
                  year_range = input$year[1]:input$year[2])
              output$graph = renderPlot(
                  trace_precodiag(precodata_sel))
              
            }
        )# end switch
      })
  
  output$downloadGraph <- downloadHandler(filename = function() {
        paste("precodiag_", input$year[1], "-", input$year[2], ".png", sep = "")
      }, content = function(file) {
        ggsave(file, trace_precodiag(filter_data("precodata", life_stage = NULL, country = input$country, 
                    year_range = input$year[1]:input$year[2])), device = "png", width = 28, height = 23, 
            units = "cm")
      })
  ######################################
  # MAP
  ######################################
  output$map = renderLeaflet( {
		draw_leaflet(dataset = input$dataset,
			year = input$year,
			lfs_code= input$lfs,
			coeff = input$coef,
			map = input$geo)} )
}
