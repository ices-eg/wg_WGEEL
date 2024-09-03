#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importtsstep2UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          tags$hr(),
          tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: red;  color:black}
    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}
  ")),
          tabsetPanel(id= ns("tsstep2panel"), selected="SERIES",
                      tabPanel("SERIES",value="SERIES",
                               h2("step 2.1.1 Integrate new series"),
                               fluidRow(
                                 column(
                                   width=4,
                                   fileInput(ns("xl_new_series"), "xls new series, do this first and re-run compare",
                                             multiple=FALSE,
                                             accept = c(".xls",".xlsx")
                                   )
                                 ),
                                 column(
                                   width=2,
                                   actionButton(ns("integrate_new_series_button"), "Proceed")
                                 ),
                                 column(
                                   width=6,
                                   verbatimTextOutput(ns("textoutput_step2.1.1_ts"))
                                 )
                               ),
                               h2("step 2.1.2 Update modified series"),
                               fluidRow(
                                 column(
                                   width=4,
                                   fileInput(ns("xl_updated_series"), "xls updated series, do this first and re-run compare",
                                             multiple=FALSE,
                                             accept = c(".xls",".xlsx"))
                                 ),
                                 column(
                                   width=2,
                                   actionButton(ns("update_series_button"), "Proceed")
                                 ),
                                 column(
                                   width=6,
                                   verbatimTextOutput(ns("textoutput_step2.1.2_ts"))
                                 )
                               )),tabPanel("DATASERIES", value="DATASERIES",
                                           h2("step 2.2.1 Delete from data"),
                                           fluidRow(
                                             column(
                                               width=4,
                                               fileInput(ns("xl_deleted_dataseries"), "Once the series are deleted please re-run the integration",
                                                         multiple=FALSE,
                                                         accept = c(".xls",".xlsx"))
                                             ),
                                             column(
                                               width=2,
                                               actionButton(ns("delete_dataseries_button"), "Proceed")
                                             ),
                                             column(
                                               width=6,
                                               verbatimTextOutput(ns("textoutput_step2.2.1_ts"))
                                             )
                                           ),
                                           h2("step 2.2.2 Integrate new data"),
                                           dataWriterModuleUI(ns("integratenewdas"), "Once the series are updated, integrate new dataseries"),
                                           h2("step 2.2.3 Update modified data"),
                                           dataWriterModuleUI(ns("integrateupdatedas"), "Update the modified dataseries")),
                      tabPanel("GROUP METRICS", value="GROUP METRICS",
                                                       writedeletedgroupmetricUI(ns("deletedgroupmetricseries"), "step 2.3.1 Delete from group metrics"),
                                                       writenewgroupmetricUI(ns("newgroupmetricseries"), "step 2.3.2 Integrate new group metrics"),
                                                       writeupdatedgroupmetricUI(ns("updatedgroupmetricseries"), "step 2.3.3 Update group metrics")),
                      tabPanel("INDIVIDUAL METRICS", value="INDIVIDUAL METRICS",			writedeletedindmetricUI(ns("deletedindmetricseries"), "step 2.4.1 Delete from individual metrics"),
                               writenewindmetricUI(ns("newindmetricseries"), "step 2.4.2 Integrate new individual metrics"),
                               writeupdatedindmetricUI(ns("updatedindmetricseries"), "step 2.4.3 Update individual metrics")))
          
  )
}




#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_ts data from step0
#'
#' @return loaded data and file type


importtsstep2Server <- function(id,globaldata,loaded_data_ts,globaltspanel){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 mytspanel <- reactiveValues(tspanel="SERIES")
                 observe({mytspanel <- reactiveValues(tspanel=globaltspanel$tspanel)
                 updateTabsetPanel(session, "tsstep2panel",
                                   selected = globaltspanel$tspanel)
                 })
                 observeEvent(input$tsstep2panel,{
                   if (isolate(input$tsstep2panel) != isolate(mytspanel$tspanel))
                     mytspanel$tspanel <- input$tsstep2panel
                 })               
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data_ts$res
                   shinyCatch({
                     output$textoutput_step2.1_ts <- renderText("")
                     
                     reset("xl_new_series")
                     reset("xl_updated_series")
                     reset("xl_new_dataseries")
                     reset("xl_updated_dataseries")
                     reset("xl_deleted_dataseries")
                     
                     output$"textoutput_step2.1.1_ts" <- renderText("")
                     output$"textoutput_step2.1.2_ts" <- renderText("")
                     output$"textoutput_step2.2.1_ts" <- renderText("")
                     output$"textoutput_step2.2.2_ts" <- renderText("")
                     output$"textoutput_step2.2.3_ts" <- renderText("")
                     
                     
                     
                     
                   })
                 })
                 
                 observeEvent(input$integrate_new_series_button, 
                              shinyCatch({
                                
                                # 2.1.1 new series  --------------------------------------------------------
                                
                                step2.1.1_filepath_new_series <- reactive({
                                  inFile <- isolate(input$xl_new_series)     
                                  if (is.null(inFile)){        return(NULL)
                                  } else {
                                    data$path_step2.1.1_new_series <- inFile$datapath #path to a temp file             
                                  }
                                })
                                
                                step2.1.1_load_data <- function() {
                                  path <- isolate(step2.1.1_filepath_new_series())
                                  if (is.null(data$path_step2.1.1_new_series)) 
                                    return(NULL)
                                  rls <- write_new_series(path)
                                  message <- rls$message
                                  cou_code <- rls$cou_code
                                  main_assessor <- input$main_assessor
                                  secondary_assessor <- input$secondary_assessor
                                  file_type <- loaded_data_ts$file_type
                                  log_datacall("new series integration", cou_code = cou_code, message = sQuote(message), 
                                               file_type = file_type, main_assessor = globaldata$main_assessor, 
                                               secondary_assessor = globaldata$secondary_assessor)
                                  return(message)
                                }
                                
                                output$textoutput_step2.1.1_ts<-renderText({
                                  validate(need(globaldata$connectOK,"No connection"))
                                  # call to  function that loads data
                                  # this function does not need to be reactive
                                  message <- step2.1.1_load_data()
                                  if (is.null(data$path_step2.1.1_new_series)) "please select a dataset" else {                                      
                                    paste(message,collapse="\n")
                                  }                  
                                })  
                              }), ignoreInit = TRUE)			
                 
                 # 2.1.2 updated series  --------------------------------------------------------
                 
                 
                 observeEvent(input$update_series_button, shinyCatch({
                   
                   step2.1.2_filepath_modified_series <- reactive({
                     inFile <- isolate(input$xl_updated_series)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step2.1.2_modified_series <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step2.1.2_load_data <- function() {
                     path <- isolate(step2.1.2_filepath_modified_series())
                     if (is.null(data$path_step2.1.2_modified_series)) 
                       return(NULL)
                     rls <- update_series(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("update series", cou_code = cou_code, message = sQuote(message), 
                                  file_type = file_type, main_assessor = globaldata$main_assessor, 
                                  secondary_assessor = globaldata$secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.1.2_ts<-renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step2.1.2_load_data()
                     if (is.null(data$path_step2.1.2_modified_series)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 }), ignoreInit = TRUE)	
                 
                 # 2.2.1 deleted dataseries  --------------------------------------------------------							
                 
                 observeEvent(input$delete_dataseries_button, shinyCatch({
                   
                   step2.2.1_filepath_deleted_dataseries <- reactive({
                     inFile <- isolate(input$xl_deleted_dataseries)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_2.2.1_deleted_dataseries <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step2.2.1_load_data <- function() {
                     path <- isolate(step2.2.1_filepath_deleted_dataseries())
                     if (is.null(data$path_step_2.2.1_deleted_dataseries)) 
                       return(NULL)
                     rls <- delete_dataseries(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("deleted dataseries", cou_code = cou_code, message = sQuote(message), 
                                  file_type = file_type, main_assessor = globaldata$main_assessor, 
                                  secondary_assessor = globaldata$secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.2.1_ts <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step2.2.1_load_data()
                     if (is.null(data$path_step_2.2.1_deleted_dataseries)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 }), ignoreInit = TRUE)	
                 
                 # 2.2.2 new dataseries  --------------------------------------------------------							
                 
                 dataWriterModuleServer("integratenewdas", loaded_data_ts,globaldata,  write_new_dataseries,"new dataseries integration")

                 # 2.2.3 update modified dataseries  --------------------------------------------------------							
                 
                 dataWriterModuleServer("integrateupdatedas", loaded_data_ts,globaldata,  update_dataseries,"update dataseries")
                 
                 
                 # 2.3.1 deleted group metrics series  --------------------------------------------------------							
                 writedeletedgroupmetricServer("deletedgroupmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 # 2.3.2 Integrate new group metrics series  --------------------------------------------------------							
                 writenewgroupmetricServer("newgroupmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 # 2.3.3 update modified group metrics  --------------------------------------------------------							
                 writeupdatedgroupmetricServer("updatedgroupmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 # 2.4.1 Deleted individual metrics --------------------------------------------------------							
                 writedeletedindmetricServer("deletedindmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 # 2.4.2 Integrate new individual metrics --------------------------------------------------------							
                 writenewindmetricServer("newindmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 
                 # 2.4.3 updated individual metrics  --------------------------------------------------------							
                 writeupdatedindmetricServer("updatedindmetricseries", globaldata=globaldata,loaded_data=loaded_data_ts,type="series")
                 
                 return(mytspanel)
                 
               }
               
  )
}