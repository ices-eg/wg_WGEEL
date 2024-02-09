#' Step 0 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importtsstep0UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
      h2("Datacall time series (glass / yellow / silver) integration"),								
      h2("step 0 : Data check"),
      tabsetPanel(tabPanel("MAIN",
              fluidRow(
                  column(width=8,  h3("load excel file")),
                  column(width=4,  h3("load already imported file"))
              ),
              fluidRow(                 
                  column(width=4,
                      fileInput(ns("xlfile_ts"), "Choose xls File",
                          multiple=FALSE,
                          accept = c(".xls",".xlsx")),
                      actionButton(ns("ts_check_file_button"), "Check xls file")
                  ),                  
                  column(width=4,  radioButtons(inputId=ns("file_type_ts"), label="File type:",
                          c(	"Glass eel (recruitment)"="glass_eel",
                              "Yellow eel (standing stock)"="yellow_eel",
                              "Silver eel"="silver_eel"
                          ))
                  ),
                  column(width=4,                      
                      pickerInput(inputId= ns("select_local_file_ts"),
                          label = "Or choose from already uploaded file",
                          choices = list.files(path),
                          selected =NULL,
                          multiple=FALSE),                      
                      actionButton(ns("ts_check_local_file_button"), "Check local file")
                  )                     
              ),
              
              
              fluidRow(
                  column(width=6,
                      htmlOutput(ns("step0_message_txt_ts")),
                      verbatimTextOutput(ns("integrate_ts")),placeholder=TRUE),
                  column(width=6,
                      htmlOutput(ns("step0_message_xls_ts")),
                      DT::dataTableOutput(ns("dt_integrate_ts")))
              )),
          tabPanel("MAPS",
              fluidRow(column(width=10),
                  leafletOutput(ns("maps_timeseries")))))
  )
}




#' Step 0 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#'
#' @return loaded data and file type


importtsstep0Server <- function(id, globaldata){
  moduleServer(id,
      function(input, output, session) {
        
        rls <- reactiveValues(res = list(),
            message = "",
            file_type = "")
        
        
        data <- reactiveValues(path_step0_ts = NULL) 
        
        
        
        
        
        ###########################
        # step0loadlocal_ts (load from Rdata saved previously)
        ########################### 
        
        
        step0load_local_ts<-function(){ 
          if (grepl(c("annex1"),tolower(input$select_local_file_ts))) 
            updateRadioButtons(session, "file_type_ts", selected = "glass_eel")
          if (grepl(c("annex2"),tolower(input$select_local_file_ts)))
            updateRadioButtons(session, "file_type_ts", selected = "yellow_eel")
          if (grepl(c("annex3"),tolower(input$select_local_file_ts)))
            updateRadioButtons(session, "file_type_ts", selected = "silver_eel")		
          ls <- loadData(
              file_name = input$select_local_file_ts, 
              path=path)  
          ls$message <- c(paste("file :",input$select_local_file_ts),ls$message)
          return(ls)
          
        }
        
        ###########################
        # step0load_data_ts (load from excel file)
        ########################### 
        
        step0load_data_ts<-function(){               
          if (is.null(input$xlfile_ts )){ 
              return(NULL)           
                 } else {
            if (is.null(input$xlfile_ts$datapath)) {
              return(NULL)              
            }
            data$path_step0_ts <- input$xlfile_ts$datapath #path to a temp file
            
            
            if (grepl(c("annex1"),tolower(input$xlfile_ts$name))) 
              updateRadioButtons(session, "file_type_ts", selected = "glass_eel")
            if (grepl(c("annex2"),tolower(input$xlfile_ts$name)))
              updateRadioButtons(session, "file_type_ts", selected = "yellow_eel")
            if (grepl(c("annex3"),tolower(input$xlfile_ts$name)))
              updateRadioButtons(session, "file_type_ts", selected = "silver_eel")	
          switch (input$file_type_ts,              
              "glass_eel"={                  
                message<-capture.output(res <- load_series(path = data$path_step0_ts, 
                        datasource = the_eel_datasource,
                        stage="glass_eel"
                    ))},
              "yellow_eel"={								
                message<-capture.output(res <- load_series(path = data$path_step0_ts, 
                        datasource = the_eel_datasource,
                        stage="yellow_eel"))},
              "silver_eel"={
                message<-capture.output(res <- load_series(path = data$path_step0_ts, 
                        datasource = the_eel_datasource,
                        stage="silver_eel"))})
          # add path to file to message (to see if changes when loading from load already imported file
          message <- c(paste("file :",input$xlfile_ts$name),message)
          ls <- list(res=res,message=message)
          saveData(data= ls, 
              file_name =input$xlfile_ts$name, 
              path=path)                         
          return(ls)
          }
          
        }
        
        plotseries <- function(series){
 
          output$maps_timeseries<- renderLeaflet({
                leaflet() %>% addTiles() %>%
                    addMarkers(data=series,lat=~ser_y,lng=~ser_x,label=~ser_nameshort) %>%
                    addPolygons(data=isolate(globaldata$ccm_light), 
                        popup=~as.character(wso_id),
                        fill=TRUE, 
                        highlight = highlightOptions(color='white',
                            weight=1,
                            bringToFront = TRUE,
                            fillColor="red",opacity=.2,
                            fill=TRUE))%>%
                    fitBounds(min(series$ser_x,na.rm=TRUE)-.1,
                        min(series$ser_y,na.rm=TRUE)-.1,
                        max(series$ser_x,na.rm=TRUE)+.1,
                        max(series$ser_y,na.rm=TRUE)+.1)
                
              })
        }
        
        ##################################################
        # Events triggered by step0_check_file_button (time series page)
        ###################################################
        observeEvent(
            eventExpr={input$ts_check_file_button},             
            handlerExpr= {  
              #browser()
              shinyCatch({ 
                    if (!globaldata$connectOK)
                      output$"step0_message_xls_ts"<-renderUI(
                          HTML(
                              paste(
                                  h4("No connection")
                              ))) 
                    
                    validate(need(globaldata$connectOK,message="No connection"))
                    
                    ls <- step0load_data_ts()   
                    show_data_check(ls)
                    updatePickerInput(
                        session = session, 
                        inputId = "select_local_file_ts",
                        choices = list.files(path),
                        selected =NULL
                    )     
                  })
            }, 
            label = "step0ts_check_file_button",
            ignoreInit = TRUE
        #once = TRUE
        )
        
        ##################################################
        # Events triggered by step0_ts_check_local_file_button
        ###################################################
        
        observeEvent(
            eventExpr= input$ts_check_local_file_button,
            handlerExpr= {   
              shinyCatch({ 
                    if (!globaldata$connectOK)
                      output$"step0_message_xls_ts"<-renderUI(
                          HTML(
                              paste(
                                  h4("No connection")
                              ))) 
                    validate(need(globaldata$connectOK,message="No connection"))              
                    ls <- step0load_local_ts() 
                    show_data_check(ls)
                  })
            }, 
            label = "step0ts_check_local_file_button",
            ignoreInit = TRUE
        #once = TRUE
        )
        
        #req(input$ts_check_file_button)
        show_data_check <- function(ls){
          if (is.null(ls)){
            output$"step0_message_txt_ts" <- renderText('no dataset seleted, wait for message "upload complete"')               
            output$"dt_integrate_ts" <- renderDataTable(data.frame())
            output$"step0_message_xls_ts" <- renderText("")  
          } else {                
                rls$message <- ls$message
                rls$res <- ls$res
                
                if(length(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]))>1) stop(paste("More than one country there",
                          paste(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]),collapse=";"), ": while there should be only one country code"))
                cou_code <- rls$res$series$ser_cou_code[1]
                if (nrow(rls$res$series)>0) plotseries(rls$res$series)
                
                ##################################################
                # integrate verbatimtextoutput
                # this will print the error messages to the console
                #################################################
                output$integrate_ts<-renderText({
                      # the following three lines might look silly but passing input$something to the log_datacall function results
                      # in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
                      main_assessor <- input$main_assessor
                      secondary_assessor <- input$secondary_assessor
                      file_type <- input$file_type_ts
                      rls$file_type <- file_type
                      # this will fill the log_datacall file (database_tools.R)
                      log_datacall( "check data time series",cou_code = cou_code, 
                                    message = paste(rls$message,collapse="\n"),
                                    file_type = file_type, main_assessor = globaldata$main_assessor,
                                    secondary_assessor = globaldata$secondary_assessor )
                      paste(rls$message, collapse="\n")						
                    }
                
                ) 
                ##################################
                # Actively generates UI component on the ui side 
                # which displays text for xls download
                ##################################
                
                output$"step0_message_xls_ts"<-renderUI({
                      if (nrow(rls$res$error)==0){
                        HTML(
                            paste(
                                h4("No error"),
                                "<p align='left'> You can proceed to check duplicate<p>"
                            ))
                      } else {
                        HTML(
                            paste(
                                h4("Time series file checking messages (xls)"),
                                "<p align='left'>Please click on excel",'<br/>',
                                "to download this file and correct the errors",'<br/>',
                                "and submit again in <strong>step0</strong> the file once it's corrected<p>"
                            ))
                      }
                    })  
                
                ##################################
                # Actively generates UI component on the ui side
                # which generates text for txt
                ################################## 									
                
                output$"step0_message_txt_ts" <- renderUI({  
                      HTML(
                          paste(
                              h4("Time series file checking messages (txt)"),
                              "<p align='left'>Please read carefully and ensure that you have",
                              "checked all possible errors. This output is the same as the table",
                              " output<p>"
                          ))                    
                    })
                
                
                #####################
                # DataTable integration error (TIME SERIES)
                ########################
                
                output$dt_integrate_ts <- DT::renderDataTable({                      
                      validate(need(globaldata$connectOK,message="No connection"))  
                      if(length(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]))>1) stop(paste("More than one country there ",
                                paste(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]),collapse=";"), ": while there should be only one country code"))
                      cou_code <- rls$res$series$ser_cou_code[1]             
                      datatable(rls$res$error,
                          rownames=FALSE,
                          filter = 'top',
                          #                      !!removed caption otherwise included in the file content
                          #                      caption = htmltools::tags$caption(
                          #                          style = 'caption-side: bottom; text-align: center;',
                          #                          'Table 1: ', htmltools::em('Please check the following values, click on excel button to download.')
                          #                      ),
                          extensions = "Buttons",
                          option=list(
                              "pagelength"=5,
                              searching = FALSE, # no filtering options
                              lengthMenu=list(c(5,20,50,-1),c("5","20","50","All")),
                              order=list(1,"asc"),
                              dom= "Blfrtip",
                              buttons=list(
                                  list(extend="excel",
                                      filename = paste0("datats_",cou_code, Sys.Date())))
                          )
                      )
                    })      	
              }
        }
        
        
        
        return(rls)
      }
  
  )
}