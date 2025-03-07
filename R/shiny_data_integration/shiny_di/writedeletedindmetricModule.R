#' Deletion of ind metric (annex 1-3 and 10)
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param title header of the section
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


writedeletedindmetricUI <- function(id, title){
  ns <- NS(id)
  tagList(useShinyjs(),
     
          h2(title),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_deleted_individual_metrics"), "Delete using deleted individual metrics file",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("delete_individual_metrics_button"), "Proceed")
            ),
            column(width=6,
                   verbatimTextOutput(ns("textoutput_step"))
            )
          )
          
  )
}




#' Deletion of ind metric (annex 1-3 and 10)
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data data from step0
#' @param type series of other
#'
#' @return loaded data and file type


writedeletedindmetricServer <- function(id,globaldata,loaded_data, type){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data$res
                   tryCatch({
                     output$textoutput_step2.1_dcf <- renderText("")
                     reset("xl_deleted_individual_metrics")
                     output$"textoutput_step" <- renderText("")

                   },
                   error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                # Deleted individual metrics --------------------------------------------------------							
                 
                 observeEvent(input$delete_individual_metrics_button, tryCatch({

                   step_filepath_deleted_individual_metrics <- reactive({
                     inFile <- isolate(input$xl_deleted_individual_metrics)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_deleted_individual_metrics <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step_load_data <- function() {
                     path <- isolate(step_filepath_deleted_individual_metrics())
                     if (is.null(data$path_step_deleted_individual_metrics)) 
                       return(NULL)
                     rls <- delete_individual_metrics(path, type=type)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data$file_type
                     log_datacall("deleted individual_metrics", cou_code = cou_code, message = sQuote(message), 
                                  file_type = file_type, main_assessor = globaldata$main_assessor, 
                                  secondary_assessor = globaldata$secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step_load_data()
                     if (is.null(data$path_step_deleted_individual_metrics)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
               }
               
  )
}