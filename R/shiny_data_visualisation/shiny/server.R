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
        n_order <- n_order+1
        n_order <- c(1,n_order)
        table = table[, n_order]
        DT::datatable(table, 
            rownames = FALSE,
            extensions = "Buttons",            
            option=list(
                order=list(0,"asc"),
                pageLength = 10,
                columnDefs = list(list(className = 'dt-center')),
                searching = FALSE, # no filtering options
                lengthMenu=list(c(5,10,30,-1),c("5","10","30","All")),                
                dom= "Bltip", # de gauche a droite button left f, t tableau, i informaiton (showing..), p pagination
                buttons=list(
                    list(extend="excel",
                        filename = paste0("data_",Sys.Date()))) # JSON behind the scene
            )) 
      })      
  
  
  
  
  ######################################"
  # combined landings
  ######################################
  get_combined_landings <- eventReactive(input$combined_button,{
        filtered_data <- filter_data(input$dataset, 
            life_stage = input$lfs, 
            country = input$country, 
            habitat = input$habitat,
            year_range = input$year[1]:input$year[2])        
        # do not group by habitat or lfs, there might be several lfs selected but all will be grouped
        landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
        landings$eel_value <- as.numeric(landings$eel_value) / 1000
        landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
        pred_landings <- predict_missing_values(landings, verbose=FALSE) 
        return(pred_landings)
      })
  
  
  output$graph_combined <-  renderPlot({
        title <- paste("Landings for : ", paste(input$lfs,collapse="+"))
        pred_landings <- get_combined_landings()
        combined_landings_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
      })
  
  output$downloadcombined <- downloadHandler(filename = function() {
        paste("combined_landings", input$year[1], "-", input$year[2], ".png", sep = "")
      }, content = function(file) {                        
        ggsave(file, combined_landings_graph(dataset=get_combined_landings(),
                title=paste("Landings for : ", paste(input$lfs,collapse="+")),
                col=color_countries, 
                country_ref=country_ref),
            device = "png", width = 20, height = 14, 
            units = "cm")
      })
  
  output$graph_combined_description<-renderUI({
        text0 <- "Predictions on log transformed values by glm. <br/>"
        if (input$geo== "emu") {
          text1 <- "Emu not supported for this graph, switching to country. <br/>"
        } else {
          text1 <-""
        }
        if (length(input$lfs)>1) {
          text2 <- "Attention you are using a prediction model on values grouped on several stages."
        } else {
          text2 <-""
        }
        text <-  paste("<p align='left'>", text0, text1, text2, "<p>")
        HTML(
            paste(
                h4(paste0("Combined Landings Graph for Landings")),
                text
            )) 
      }) 
  ######################################"
  # raw landings
  ######################################
  get_raw_landings <- eventReactive(input$raw_landings_button,{
        filtered_data <- filter_data(input$dataset, 
            life_stage = input$lfs, 
            country = input$country, 
            habitat = input$habitat,
            typ=as.numeric(input$raw_landings_eel_typ_id),
            year_range = input$year[1]:input$year[2])        
        # eventually grouped by habitat type and lfs, if both rec and com are selected, they are summed
        landings <-group_data(filtered_data,geo="country",
            habitat=input$raw_landings_habitat_switch,
            lfs=input$raw_landings_lifestage_switch)
        landings$eel_value <- as.numeric(landings$eel_value) / 1000
        landings$eel_cou_code = as.factor(landings$eel_cou_code)        
        return(landings)
      })
  output$graph_raw_landings <-  renderPlot({
        if (4 %in% (input$raw_landings_eel_typ_id) & 6%in%(input$raw_landings_eel_typ_id)) title2<-"Commercial and recreational landings for " else 
        if (4 %in% input$raw_landings_eel_typ_id) title2 <- "Commercial landings for " else
        if (6 %in% input$raw_landings_eel_typ_id) title2 <- "Recreational landings for " else
          stop ("Internal error, unexpected landings eel_typ_id, should be 4 or 6")
        title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"), " and habitat =", paste(input$habitat,collapse="+"))
        landings <- get_raw_landings()
        raw_landings_graph(dataset=landings,title=title,
            col=color_countries, 
            country_ref=country_ref,
            habitat=input$raw_landings_habitat_switch,
            lfs=input$raw_landings_lifestage_switch)
      })
  
  output$download_graph_raw_landings <- downloadHandler(filename = function() {
        paste("raw_landings", input$year[1], "-", input$year[2], ".png", sep = "")
      }, content = function(file) {
        title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"), " and habitat =", paste(input$habitat,collapse="+"))
        landings <- get_raw_landings()
        ggsave(file, raw_landings_graph(dataset=landings,title=title,col=color_countries, country_ref=country_ref),
            device = "png", width = 20, height = 14, 
            units = "cm")
      })
  
  
  ################################
# Precautionary diagram
  #################################
# Take a reactive dependency on input$precodata_button, but
# not on any of the stuff inside the function
  filter_data_reactive <- eventReactive(input$precodata_button,{
        return(filter_data(
                dataset = "precodata", 
                life_stage = NULL, 
                country = input$country, 
                year_range = input$year[1]:input$year[2]))    
      })
  
  output$precodata_graph<- renderPlot({
        precodata_sel<-filter_data_reactive()        
        trace_precodiag(precodata_sel)
      })
  ######################################
# MAP
  ######################################
  # dynamically generate the button to choose between Commercial and recreational landings
  # if "landings" is selected as a dataset
  output$leaflet_typ_button <- renderUI({
        if (is.null(input$leaflet_dataset))
          return()
        
        # we check the value of leaflet dataset
        # if landings then the ui will generate leaflet_eel_typ_id button
        switch(input$leaflet_dataset,
            "landings"= 
                awesomeCheckboxGroup(
                    inputId = "leaflet_eel_typ_id",
                    label = "Dataset",
                    choices = c("com"=4,"rec"=6),
                    selected=c("com"=4,"rec"=6),
                    status = "primary",
                    inline=TRUE                                
                ),   
            "aquaculture"= 
                radioGroupButtons(
                    inputId = "leaflet_eel_typ_id",
                    label = "Dataset",
                    choices = c("q_aqua_kg"=11,"q_aqua_n"=12),
                    selected=c("q_aqua_kg"=11),
                    direction = "horizontal"                               
                ),
            "release"= 
                radioGroupButtons(
                    inputId = "leaflet_eel_typ_id",
                    label = "Dataset",
                    choices = c("q_release_kg"=8,"q_release_n"=9,"gee_n"=10),
                    selected=c("q_release_kg"=8),
                    direction = "horizontal"                                
                )
        # TODO develop this, we need a view for biomass+ sigmaA different from precodata (which has one column per type)
        # ideally one view for SEE, one view for SumH by type
        #,
#            "precodata"=
#                radioGroupButtons(
#                    inputId = "leaflet_eel_typ_id",
#                    label = "Dataset",
#                    choices = c(
#                        "B0_kg"=13,
#                        "Bbest_kg" = 14,
#                        "Bcurrent_kg" = 15,        
#                        "SumA" = 17,
#                        "SumF" = 18,
#                        "SumH" = 19,
#                        "sumF_com" = 20,
#                        "SumF_rec" = 21,
#                        "SumH_hydro" = 22,
#                        "SumH_habitat" = 23,
#                        "SumH_release" = 24,
#                        "SumH_other" = 25,
#                        "SEE_com" = 26,
#                        "SEE rec" = 27,
#                        "SEE_hydro" = 28,
#                        "SEE_habitat" = 29,
#                        "SEE_stocking" = 30,
#                        "SEE_other" = 31),       
#                    selected=c("sumA"=17),                    
#                    inline=FALSE 
#                )
        )})     
  
#  Leaflet map, this uses the draw_leaflet function -------------------------------------------------  
  observe({
        select_a_point <- function(map, x, y)   addPulseMarkers(data = fireball_last,
              icon = makePulseIcon(color = ~fireball_pal(log(`Impact Energy (kt)`)),
                  iconSize = ~sqrt(`Impact Energy (kt)`) + 14, 
                  animate = TRUE, heartbeat = 0.5),
              layerId = ~id)
        
        addCircleMarkers(map, x, y, radius = 15,
            fill = FALSE, color = "yellow", 
            opacity = 0.5, weight = 2, 
            stroke = TRUE, layerId = "selected")
        output$map = renderLeaflet({
              # draw leaflet depends on input$leaflet_eel_typ_id which is generated anyways
              # it returns a list with a dataset and a leaflet map (m)
	          ls<-draw_leaflet(dataset = input$leaflet_dataset,
		          years = input$year,
                  typ=input$leaflet_eel_typ_id,
		          lfs_code= input$lfs,		    
		          map = input$geo)
              
              # store data into the reactive values
              
              data$leaflet_dataset <- ls$data
              
              # print the map   
                          
              ls$m
            })
        
# observer click event ------------------------------------------------------------------------------- 
        
        observeEvent(input$Map_circle_click, {
              p <- input$Map_circle_click
              lat <- p$lat
              lng <- p$lng
              id <- p$id
              
              proxy <- leafletProxy("Map")
              if(p$id == "selected") {
                proxy %>% removeMarker(layerId = "selected")
              } else {
                # Create selected marker -------------------------------------------------------------
                proxy %>% setView(lng = lng, lat = lat, input$Map_zoom) %>% select_a_point(lng, lat)
                
                # Create selected marker table and put in in reactive values--------------------------
                           
                data$leaflet_dataset_selected <- data$leaflet_dataset[data$leaflet_dataset$id == id, ]
                
                # Create a plotly graph
                        
                output$plotly_graph <- "XXXXXXX TODO XXXXXXXXXXXX"
              }
            })
        
      }
