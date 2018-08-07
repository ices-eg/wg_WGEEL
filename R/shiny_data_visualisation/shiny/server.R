# server paramater for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################

# create server configuration
server = function(input, output, session) {
  # this stops the app when the browser stops
  session$onSessionEnded(stopApp)
  # A button that stops the application
  observeEvent(input$close, {
        js$closeWindow()
        stopApp()
      })
  # A reactive dataset
  data<-reactiveValues()
  
  
  
  #####################
  # table text input
  #####################
  output$"table_description"<-renderUI({
        if (input$dataset %in% c("aquaculture","landings")) {
          text <-  paste("<p align='left'>Value in ton",'<br/>',
              "to download this, use the excel button <p>'")
        } else text =""
        HTML(
            paste(
                h4(paste0("Table for :", input$dataset)),
                text
            )) 
      }) 
  #####################
# table 
  #####################
  output$table = DT::renderDataTable({
        filtered_data <- filter_data(input$dataset, 
            life_stage = input$lfs, 
            country = input$country, 
            habitat = input$habitat,
            year_range = input$year[1]:input$year[2])
        # do not group by habitat or lfs
        grouped_data <-group_data(filtered_data,geo=input$geo,habitat=FALSE,lfs=FALSE)
        if (input$dataset %in% c("aquaculture","landings")) {
          fun.agg<-function(X){round(sum(X)/1000)}
        } else fun.agg <- sum
        table = dcast(grouped_data, eel_year~eel_cou_code, value.var = "eel_value",fun.aggregate = fun.agg)  	
        #ordering the column accordign to country order
        country_to_order = names(table)[-1]
        n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
        table = table[, c(1, n_order+1)]
        DT::datatable(table, 
            rownames = FALSE,
            extensions = "Buttons",            
            option=list(
                order=list(0,"asc"),
                pageLength = 10,
                columnDefs = list(list(className = 'dt-center', targets = 1:(n_order+1))),
                searching = FALSE, # no filtering options
                lengthMenu=list(c(5,10,30,-1),c("5","10","30","All")),                
                dom= "Bltip", # de gauche a droite button left f, t tableau, i informaiton (showing..), p pagination
                buttons=list(
                    list(extend="excel",
                        filename = paste0("data_",Sys.Date()))) # JSON behind the scene
            )) 
      })      
  
  
  
  
  ######################################"
  # GRAPH
  ######################################
  observeEvent(input$dataset, {
        switch(input$dataset,
            "aquaculture"={
              
            },
            "landings"={
              filtered_data <- filter_data(input$dataset, 
                  life_stage = input$lfs, 
                  country = input$country, 
                  habitat = input$habitat,
                  year_range = input$year[1]:input$year[2])
              
                  
              if (is.null(input$landings_graph_type)) return(NULL)
              switch(input$landings_graph_type,"combined"={
                    output$"graph_description"<-renderUI({
                          text0 <- "Predictions on log transformed values by glm. '<br/>'"
                          if (input$geo== "emu") {
                            text1 <- "Emu not supported for this graph, switching to country. '<br/>'"
                          } else {
                            text1 <-""
                          }
                          if (length(input$lfs)>1) {
                            text2 <- "Attention you are using a prediction model on values grouped on several stages."
                          } else {
                            text2 <-""
                          }
                          text <-  paste("<p align='left'>", text0, text1, text2, "<p>'")
                          HTML(
                              paste(
                                  h4(paste0("Combined Landings Graph for :", input$dataset)),
                                  text
                              )) 
                        }) 
                    
                    # do not group by habitat or lfs, there might be several lfs selected but all will be grouped
                    landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
                    landings$eel_value <- as.numeric(landings$eel_value) / 1000
                    landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
                    pred_landings <- predict_missing_values(landings, verbose=TRUE) 
                    title <- paste("Landings for : ", paste(input$lfs,collapse="+"))
                    output$graph <-  renderPlot({
                          combined_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
                        })
                    output$downloadGraph <- downloadHandler(filename = function() {
                                  paste("precodiag_", input$year[1], "-", input$year[2], ".png", sep = "")
                              }, content = function(file) {
                                  ggsave(file, combined_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref),
                                       device = "png", width = 28, height = 23, 
                                          units = "cm")
                              })
                  }, "available"= {
                    
                  }, "average_habitat"={
                    
                  }, "sum_habitat" = {
                    
                  })
              
              
            }, 
            "release"={
              
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
