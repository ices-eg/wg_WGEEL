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
  
 
  ###################
  # fill in all countries
  ###################
  observe({
            if(input$selectall == 0) return(NULL) 
            else updateCheckboxGroupInput(session,"country","All:",
                  choices=country_ref$cou_code,selected=country_ref$cou_code, inline = TRUE)
        })
  
  
  ##############
  # table
  #############
  output$table = DT::renderDataTable({
        filtered_data <- filter_data(input$dataset, 
            life_stage = input$lfs, 
            country = input$country, 
            habitat = input$habitat,
            year_range = input$year[1]:input$year[2])
        # do not group by habitat or lfs
        grouped_data <-group_data(filtered_data,geo=input$geo,habitat=FALSE,lfs=FALSE)        
        table = dcast(grouped_data, eel_year~eel_cou_code, value.var = "eel_value")  	
        #ordering the column accordign to country order
        country_to_order = names(table)[-1]
        n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
        table = table[, c(1, n_order+1)]
        DT::datatable(table, 
            rownames = FALSE,
            extensions = "Buttons",
            option=list(
                columnDefs = list(list(className = 'dt-center', targets = 1:(n_order+1))),
                searching = FALSE, # no filtering options
                lengthMenu=list(c(5,20,50,-1),c("5","20","50","All")),
                order=list(1,"asc"),
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
        filtered_data<-data$filtered_data
        grouped_data<-data$grouped_data
        switch(input$dataset,
            "aquaculture"={
              
            },
            "landings"={

              # download the data + transform into tonnes + create new names for the habitat  
              
#              landings_complete$eel_value<-as.numeric(grouped_data$eel_value) / 1000
#              landings_complete$eel_hty_code = factor(landings_complete$eel_hty_code, levels = rev(c("MO", "C", "T", "F", "AL")))
#              landings = as.data.frame(com_landings %>% group_by(eel_year, eel_cou_code,eel_lfs_code) %>% dplyr::summarize(eel_value=sum(eel_value,na.rm=TRUE)))
#              colnames(landings)<-c("year","country","lfs","landings")
#              landings$country = as.factor(landings$country)
#              landings$lfs = as.factor(landings$lfs)
#              
#              landings$year = as.numeric(as.character(landings$year))
#              
              output<-renderUI(
                  div( span(
                          radioButtons(inputId="landings_graph_type", label="Graph type:",
                              choices=c(
                                  "Raw and reconstructed combined"="combined",
                                  "Available Data"="available",
                                  "Raw landings per habitat average"="average_habitat",
                                  "Raw landings per habitat sum"="sum_habitat",)   
                          ),
                          materialSwitch(
                                 inputId = "habitat",
                                 label = "By habitat", 
                                  value = FALSE,
                                 status = "primary"
                          ),
                          materialSwitch(
                              inputId = "lifestage",
                              label = "By lifestage", 
                              value = FALSE,
                              status = "primary"
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
