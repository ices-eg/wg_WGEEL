#' Elements necessary for the edition table
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements

tableEditUI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          h2("Data correction table"),
          br(),        
          h3("Filter"),
          fluidRow(
            column(width=4,
                   pickerInput(inputId = ns("edit_datatype"), 
                               label = "Select table to edit :", 
                               choices = sort(c("NULL","t_series_ser",
                                                "t_eelstock_eel",
                                                "t_eelstock_eel_perc",
                                                "t_biometry_series_bis",
                                                "t_dataseries_das")),
                               selected="NULL",
                               multiple = FALSE,  
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=4, 
                   pickerInput(inputId = ns("editpicker1"), 
                               label = "", 
                               choices = "",
                               multiple = TRUE, 
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=4, 
                   pickerInput(inputId = ns("editpicker2"), 
                               label = "", 
                               choices = "",
                               multiple = TRUE, 
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=4,
                   sliderTextInput(inputId =ns("yearAll"), 
                                   label = "Choose a year range:",
                                   choices=seq(the_years$min_year, as.integer(format(Sys.time(),"%Y"))),
                                   selected = c(the_years$min_year,as.integer(format(Sys.time(),"%Y")))
                   ))),                                                         
          helpText("This table is used to edit data in the database
														After you double click on a cell and edit the value, 
														the Save and Cancel buttons will show up. Click on Save if
														you want to save the updated values to database; click on
														Cancel to reset."),
          br(), 
          fluidRow(                                       
            column(width=6,verbatimTextOutput(ns("database_errorsAll"))),
            column(width=2,hidden(actionButton(ns("addRowTable_corAll"), "Add Row"))),
            column(width=2,actionButton(ns("clear_tableAll"), "clear")),
            column(width=2,uiOutput(ns("buttons_data_correctionAll")))
          ),                
          br(),
          fluidRow(
            column(width=2,actionBttn(inputId = ns("saveAllmod"), label = "Save",
                                      style = "material-flat", color = "danger")),
            column(width=2,actionButton(inputId = ns("cancelAllmod"),
                                      label = "Cancel"))
          ),
          br(),
          DT::dataTableOutput(ns("table_corAll")),
          fluidRow(column(width=10),
                   leafletOutput(ns("maps_editedtimeseries"),height=600))
  )
}

#' Table Edition server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param data a reactive value with global variable
#'
#' @return nothing


tableEditServer <- function(id,globaldata){
  moduleServer(id,
               function(input, output, session) {
                 rvsAll <- reactiveValues(
                   data = NA, 
                   dbdata = NA,
                   dataSame = TRUE,
                   editedInfo = NA
                   
                 )
                 
                 #-----------------------------------------  
                 # Generate source via reactive expression
                 
                 mysourceAll <- reactive({
                   req(globaldata$connectOK)
                   req(input$edit_datatype!="NULL")
                   validate(need(globaldata$connectOK,"No connection"))
                   pick1 = input$editpicker1
                   pick2= input$editpicker2
                   if (is.null(pick1)) {
                     pick1=switch(input$edit_datatype,
                                  "t_eelstock_eel"=c("FR"),
                                  "t_eelstock_eel_perc"=c("FR"),
                                  c("G")
                     )}
                   if (is.null(pick2)) {
                     pick2=switch(input$edit_datatype,
                                  "t_eelstock_eel"=c(4, 5, 6, 7),
                                  "t_eelstock_eel_perc"=c(13:15,17:19),
                                  globaldata$ser_list)
                   }
                   the_years <- input$yearAll
                   if (is.null(input$yearAll)) {
                     the_years <- c(the_years$min_year, the_years$max_year)
                   }
                   query = switch (input$edit_datatype,
                                   "t_dataseries_das" = glue_sql(str_c("SELECT das.*,ser_nameshort as ser_nameshort_ref,ser_emu_nameshort as ser_emu_nameshort_ref,ser_lfs_code as ser_lfs_code_ref from datawg.t_dataseries_das das join datawg.t_series_ser on das_ser_id=ser_id where ser_nameshort in ({pick2*}) and ser_lfs_code in ({pick1*}) and das_year>={minyear} and das_year<={maxyear}"), 
                                                                  minyear = the_years[1], maxyear = the_years[2], 
                                                                 .con = globaldata$pool),
                                   "t_eelstock_eel" =  query <- glue_sql("SELECT *,typ_name as typ_name_ref from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id where eel_cou_code in ({pick1*}) and eel_typ_id in ({pick2*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                                                                         minyear = the_years[1], maxyear = the_years[2], 
                                                                         .con = globaldata$pool),
                                   "t_eelstock_eel_perc" =  query <- glue_sql("SELECT percent_id,eel_year eel_year_ref,eel_emu_nameshort as eel_emu_nameshort_ref,eel_cou_code as eel_cou_code_ref,typ_name as typ_name_ref, perc_f, perc_t, perc_c,perc_mo from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id left join datawg.t_eelstock_eel_percent on percent_id=eel_id where eel_cou_code in ({pick1*}) and eel_typ_id in ({pick2*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                                                                              minyear = the_years[1], maxyear = the_years[2], 
                                                                              .con = globaldata$pool),
                                   "t_series_ser" =  glue_sql("SELECT *, ser_ccm_wso_id[1]::integer AS wso_id1, ser_ccm_wso_id[2]::integer AS wso_id2, ser_ccm_wso_id[3]::integer AS wso_id3 from datawg.t_series_ser where ser_nameshort in ({pick2*}) and ser_lfs_code in ({pick1*})", # ser_ccm_wso_id is an array to deal with series being part of serval basins ; here we deal until 3 basins
                                                              minyear = the_years[1], maxyear = the_years[2], 
                                                              .con = globaldata$pool),
                                   "t_biometry_series_bis" = glue_sql(str_c("SELECT bio.*,ser_nameshort as ser_nameshort_ref,ser_emu_nameshort as ser_emu_nameshort_ref,ser_lfs_code as ser_lfs_code_ref from datawg.t_biometry_series_bis bio join datawg.t_series_ser on bis_ser_id=ser_id where ser_nameshort in ({pick2*}) and bio_lfs_code in ({pick1*}) and bio_year>={minyear} and bio_year<={maxyear}"), 
                                                                      series = series, lfs = lfs, minyear = the_years[1], maxyear = the_years[2], 
                                                                      .con = globaldata$pool)
                   )
                   # glue_sql to protect against injection, used with a vector with *
                   query <- 
                     # https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
                     # it seems that dbgetquery doesn't raise an error
                     out_data <- dbGetQuery(globaldata$pool, query)
                   return(out_data)
                   
                 })
                 
                 # Observe the source, update reactive values accordingly
                 
                 observeEvent(mysourceAll(), tryCatch({
                   data <- switch(input$edit_datatype,
                                  "t_dataseries_das" = mysourceAll() %>%
                                    arrange(ser_nameshort_ref,das_year), 
                                  "t_eelstock_eel" =  mysourceAll() %>%
                                    arrange(eel_emu_nameshort,eel_year),
                                  "t_eelstock_eel_perc" =  mysourceAll() %>%
                                    arrange(eel_emu_nameshort_ref,eel_year_ref),
                                  "t_series_ser" =  mysourceAll() %>% 
                                    arrange(ser_nameshort,ser_cou_code),
                                  "t_biometry_series_bis" = mysourceAll() %>%
                                    arrange(ser_nameshort_ref,bio_year)
                   )
                   rvsAll$data <- data
                   rvsAll$dbdata <- data
                   rvsAll$editedInfo = NA
                   disable("clear_tableAll")                
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 #-----------------------------------------
                 # Render DT table 
                 # 
                 # selection better be none
                 # editable must be TRUE
                 #
                 output$table_corAll <- DT::renderDataTable({
                   validate(need(globaldata$connectOK,"No connection"))
                   req(input$edit_datatype!="NULL")
                   noteditable=c(1,grep("_ref",names(rvsAll$dbdata)))-1
                   
                   DT::datatable(
                     rvsAll$dbdata, 
                     filter="top",
                     rownames = FALSE,
                     extensions = "Buttons",
                     editable = list(target = 'cell',
                                     disable = list(columns = noteditable)), 
                     selection = 'none',
                     options=list(
                       order=list(3,"asc"),              
                       searching = TRUE,
                       rownames = FALSE,
                       scroller = TRUE,
                       scrollX = TRUE,
                       scrollY = "500px",
                       lengthMenu=list(c(-1,5,20,50,100),c("All","5","20","50","100")),
                       dom= "Blfrtip", #button fr search, t table, i information (showing..), p pagination
                       buttons=list(
                         list(extend="excel",
                              filename = paste0("data_",Sys.Date())))
                     ))})
                 
                 
                 output$maps_editedtimeseries <-renderLeaflet({
                   validate(need(globaldata$connectOK,"No connection"))
                   req(input$edit_datatype=="t_series_ser")
                   colors=rep("blue",nrow(rvsAll$data))
                   if (!all(is.na(rvsAll$editedInfo))){
                     colx=which(names(rvsAll$data)=="ser_x")
                     coly=which(names(rvsAll$data)=="ser_y")
                     colors[rvsAll$editedInfo$row[rvsAll$editedInfo$col %in% c(colx,coly)]]="red"
                   }
                   pal <- 
                     colorFactor(palette = c("blue", "red"), 
                                 levels = c("blue", "red"))
                   leaflet(rvsAll$data) %>%
                     addTiles(group="OSM") %>%
                     addProviderTiles(providers$Esri.WorldImagery, group="satellite")  %>%
                     addPolygons(data=globaldata$ccm_light %>% inner_join(union(union(rvsAll$data %>% select(wso_id1) %>% distinct() %>% transmute(wso_id = wso_id1), rvsAll$data %>% select(wso_id2) %>% distinct() %>% transmute(wso_id = wso_id2)), rvsAll$data %>% select(wso_id3) %>% distinct() %>% transmute(wso_id = wso_id3))), 
                                 popup=~as.character(wso_id),
                                 fill=TRUE, 
                                 highlight = highlightOptions(color='white',
                                                              weight=1,
                                                              bringToFront = TRUE,
                                                              fillColor="red",opacity=.2,
                                                              fill=TRUE))%>%
                     addCircleMarkers(layerId=~ser_nameshort,
                                      color=~pal(colors),
                                      lat=~ser_y,
                                      lng=~ser_x,
                                      label=~ser_nameshort,
                                      group="stations") %>%
                     addDrawToolbar(targetGroup="stations",
                                    editOptions = editToolbarOptions(edit=TRUE,
                                                                     remove=FALSE),
                                    rectangleOptions=FALSE,
                                    circleOptions=FALSE,
                                    polygonOptions=FALSE,
                                    polylineOptions=FALSE,
                                    markerOptions=FALSE,
                                    circleMarkerOptions=FALSE) %>%
                     addLayersControl(baseGroups=c("OSM","satellite"))
                 })
                 
                 observeEvent(eventExpr = input$addRowTable_corAll, tryCatch({
                   emptyRow <- rvsAll$dbdata[1,,drop=FALSE]
                   emptyRow[1,] <- NA
                   rvsAll$data <- bind_rows(rvsAll$data,emptyRow)
                   replaceData(proxy_table_corAll,rvsAll$data , resetPaging = FALSE, rownames = FALSE)
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 
                 observeEvent(input$maps_editedtimeseries_draw_edited_features, tryCatch({
                   edited <- input$maps_editedtimeseries_draw_edited_features
                   nedited <- length(edited$features)
                   ids <- edited$features[[nedited]]$properties$`layerId`
                   i <- which(rvsAll$dbdata$ser_nameshort==ids)
                   newx <- edited$features[[nedited]]$geometry$coordinates[[1]]
                   newy <- edited$features[[nedited]]$geometry$coordinates[[2]]
                   cx <- which(names(rvsAll$dbdata)=="ser_x")
                   cy <- which(names(rvsAll$dbdata)=="ser_y")
                   info <- data.frame(row=rep(i,2),
                                      col=c(cx,
                                            cy),
                                      value=as.character(c(newx,newy)))
                   rvsAll$data[i, cx] <<- DT::coerceValue(newx, rvsAll$data[i, cx])
                   rvsAll$data[i, cy] <<- DT::coerceValue(newy, rvsAll$data[i, cy])
                   replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames=FALSE)
                   # datasame is set to TRUE when save or update buttons are clicked
                   # here if it is different it might be set to FALSE
                   rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
                   # this will collate all editions (coming from datatable observer in a data.frame
                   # and store it in the reactive dataset rvs$editedInfo
                   if (all(is.na(rvsAll$editedInfo))) {
                     
                     rvsAll$editedInfo <- info
                   } else {
                     rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, info)
                   }
                   
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 #-----------------------------------------
                 # Create a DT proxy to manipulate data
                 # 
                 #
                 proxy_table_corAll = dataTableProxy('table_corAll')
                 #--------------------------------------
                 # Edit table data
                 # Examples at
                 # https://yihui.shinyapps.io/DT-edit/
                 observeEvent(input$table_corAll_cell_edit, tryCatch({
                   info <- input$table_corAll_cell_edit
                   
                   i <- info$row
                   j <- info$col <- info$col + 1  # column index offset by 1
                   v <- info$value
                   
                   rvsAll$data[i, j] <<- DT::coerceValue(v, rvsAll$data[i, j])
                   replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames = FALSE)
                   # datasame is set to TRUE when save or update buttons are clicked
                   # here if it is different it might be set to FALSE
                   rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
                   # this will collate all editions (coming from datatable observer in a data.frame
                   # and store it in the reactive dataset rvs$editedInfo
                   if (all(is.na(rvsAll$editedInfo))) {
                     
                     rvsAll$editedInfo <- data.frame(info)
                   } else {
                     rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, data.frame(info))
                   }
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 
                 #depending on the data type we want to edit, the picker change
                 observeEvent(input$edit_datatype, {req(globaldata$connectOK)
                   tryCatch({
                   
                   if (input$edit_datatype == "t_eelstock_eel"){
                     updatePickerInput(session=session,
                                       inputId="editpicker2",
                                       choices=globaldata$typ_id,
                                       label="Select a type :",
                                       selected=NULL)
                     updatePickerInput(session=session,
                                       inputId="editpicker1",
                                       label = "Select a country :", 
                                       choices = globaldata$list_country,
                                       selected=NULL)
                     shinyjs::show("addRowTable_corAll")
                   } else if (input$edit_datatype == "t_eelstock_eel_perc"){
                     updatePickerInput(session=session,
                                       inputId="editpicker2",
                                       choices=globaldata$typ_id[globaldata$typ_id %in% c(13:15,17:19)],
                                       label="Select a type :",
                                       selected=NULL)
                     updatePickerInput(session=session,
                                       inputId="editpicker1",
                                       label = "Select a country :", 
                                       choices = globaldata$list_country,
                                       selected=NULL)
                     shinyjs::hide("addRowTable_corAll")
                     
                     
                   }else {
                     updatePickerInput(session=session,
                                       inputId="editpicker2",
                                       label = "Select series :", 
                                       choices = globaldata$ser_list,
                                       selected=NULL)
                     updatePickerInput(session=session,
                                       inputId="editpicker1",
                                       label="Select a stage :",
                                       choices=c("G","GY","Y","S"),
                                       selected=NULL)
                     shinyjs::show("addRowTable_corAll")
                     
                     if (input$edit_datatype=="t_series_ser")  disable("yearAll")
                     
                     rvsAll$dataSame <- TRUE
                     rvsAll$editedInfo <- NA
                     data <- switch(input$edit_datatype,
                                    "t_dataseries_das" = mysourceAll() %>%
                                      arrange(ser_nameshort_ref,das_year), 
                                    "t_eelstock_eel" =  mysourceAll() %>%
                                      arrange(eel_emu_nameshort,eel_year),
                                    "t_series_ser" =  mysourceAll() %>% 
                                      arrange(ser_nameshort,ser_cou_code),
                                    "t_biometry_series_bis" = mysourceAll() %>%
                                      arrange(ser_nameshort_ref,bio_year)
                     )
                     rvsAll$data <- data
                     rvsAll$dbdata <- data
                   }},error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 #when we want to edit time series related data, if a life stage is selected,
                 #we can restrict available time series choices
                 observeEvent(input$editpicker1,tryCatch({
                   if (!startsWith(input$edit_datatype, "t_eelstock_eel")){
                     stageser=ifelse(endsWith(globaldata$ser_list,"GY"),
                                     "GY",
                                     str_sub(globaldata$ser_list,-1,-1))
                     selected=input$editpicker2
                     updatePickerInput(session=session,
                                       inputId="editpicker2",
                                       choices = globaldata$ser_list[stageser %in% input$editpicker1],
                                       selected=selected)
                   }
                   
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 observeEvent(input$editpicker2,tryCatch({
                   if ((!startsWith(input$edit_datatype,"t_eelstock_eel")) & is.null(input$editpicker1)){
                     stageser=ifelse(endsWith(input$editpicker2,"GY"),
                                     "GY",
                                     str_sub(input$editpicker2,-1,-1))
                     updatePickerInput(session=session,
                                       inputId="editpicker1",
                                       selected = stageser)
                   }
                   
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 # Update edited values in db once save is clicked---------------------------------------------
                 
                 observeEvent(input$saveAllmod, tryCatch({
                   errors <- update_data_generic(editedValue = rvsAll$editedInfo,
                                                 pool = globaldata$pool, data=rvsAll$data,
                                                 edit_datatype=input$edit_datatype)
                   if (length(errors$error)>0) {
                     output$database_errorsAll<-renderText({iconv(unlist(errors$errors,"UTF8"))})
                     enable("clear_tableAll")
                   } else {
                     output$database_errorsAll<-renderText({errors$message})
                   }
                   rvsAll$dbdata <- rvsAll$data
                   rvsAll$dataSame <- TRUE
                   rvsAll$editedInfo = NA
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 # Observe clear_table button -> revert to database table---------------------------------------
                 
                 observeEvent(input$clear_tableAll,
                              tryCatch({
                                data <- switch(input$edit_datatype,
                                               "t_dataseries_das" = mysourceAll() %>%
                                                 arrange(ser_nameshort_ref,das_year), 
                                               .con = pool,
                                               "t_eelstock_eel" =  mysourceAll() %>%
                                                 arrange(eel_emu_nameshort,eel_year),
                                               "t_series_ser" =  mysourceAll() %>% 
                                                 arrange(ser_nameshort,ser_cou_code),
                                               "t_biometry_series_bis" = mysourceAll() %>%
                                                 arrange(ser_nameshort_ref,bio_year)
                                )
                                rvsAll$data <- data
                                rvsAll$dbdata <- data
                                rvsAll$editedInfo = NA
                                disable("clear_tableAll")
                                output$database_errorsAll<-renderText({""})
                                rvsAll$editedInfo = NA
                              },error = function(e) {
                                showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                              }), ignoreInit = TRUE)
                 
                 # Oberve cancel -> revert to last saved version -----------------------------------------------
                 
                 observeEvent(input$cancelAllmod, tryCatch({
                   rvsAll$data <- rvsAll$dbdata
                   rvsAll$dbdata <- NA
                   rvsAll$dbdata <- rvsAll$data #this is to ensure that the table display is updated (reactive value)
                   rvsAll$dataSame <- TRUE
                   rvsAll$editedInfo = NA
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 # UI buttons ----------------------------------------------------------------------------------
                 # Appear only when data changed
                 
                 observe({
                     if (! rvsAll$dataSame) {
                       shinyjs::show("cancelAllmod")
                       shinyjs::show("saveAllmod")

                     } else {
                       shinyjs::hide("saveAllmod")
                       shinyjs::hide("cancelAllmod")
                     }
                 })
                 
                 
                 
               }
               )
}