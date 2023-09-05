#' Integration of individual metric (annex 1-3 and 10)
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param title header of the section
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


writenewindmetricUI <- function(id, title){
  ns <- NS(id)
  tagList(useShinyjs(),
          h2(title),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_new_individual_metrics"), "Write new individual metrics file",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("integrate_new_individual_metrics_button"), "Proceed")
              
            )
            
          ),
          fluidRow(hidden(actionButton(ns("validate_integrate_new_individual_metrics_button"), "Sure?")),
                   hidden(actionButton(ns("cancel_integrate_new_individual_metrics_button"), "Cancel"))),
          fluidRow(column(width=12,
                          verbatimTextOutput(ns("textoutput_step"))
          ))
          
          
  )
}




#' Integration of individual metric (annex 1-3 and 10)
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data
#' @param type series or others
#'
#' @return loaded data and file type


writenewindmetricServer <- function(id,globaldata,loaded_data, type="series"){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data$res
                   tryCatch({
                     reset("xl_new_individual_metrics")
                     
                     output$"textoutput_step" <- renderText("")
                     hide("validate_integrate_new_individual_metrics_button")
                     hide("cancel_integrate_new_individual_metrics_button")
                     
                     
                     
                   },
                   error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 
                 # Integrate new individual metrics --------------------------------------------------------							
                 
                 observeEvent(input$integrate_new_individual_metrics_button, tryCatch({
                   step_filepath_new_individual_metrics <- reactive({
                     inFile <- isolate(input$xl_new_individual_metrics)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_new_individual_metrics <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step_load_data <- function() {
                     path <- isolate(step_filepath_new_individual_metrics())
                     if (is.null(data$path_step_new_individual_metrics)) 
                       return(NULL)
                     read <- write_new_individual_metrics_show(path, type=type)
                     shinyjs::show("validate_integrate_new_individual_metrics_button")
                     shinyjs::show("cancel_integrate_new_individual_metrics_button")
                     data$data_to_be_integrated <- read$data_read
                     return(read$summary)
                   }
                   
                   output$textoutput_step <- renderPrint({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step_load_data()
                     if (is.null(data$path_step_new_individual_metrics)) "please select a dataset" else {                                      
                       message
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 observeEvent(input$cancel_integrate_new_individual_metrics_button, {
                   data$data_to_be_integrated <- NULL
                   output$textoutput_step <- renderText("cancelled")  
                   hide("cancel_integrate_new_individual_metrics_button")
                   hide("validate_integrate_new_individual_metrics_button")
                 })
                 observeEvent(input$validate_integrate_new_individual_metrics_button, tryCatch({
                   validate(need(!is.null(isolate(data$data_to_be_integrated)), "nothing to integrate"))
                   validate(need(globaldata$connectOK,"No connection"))
                   
                   rls <- write_new_individual_metrics_proceed(isolate(data$data_to_be_integrated), type=type)
                   message <- rls$message
                   cou_code <- rls$cou_code
                   main_assessor <- input$main_assessor
                   secondary_assessor <- input$secondary_assessor
                   file_type <- loaded_data$file_type
                   if (rls$cou_code != ""){ #otherwise, nothing integrated
                     log_datacall("write new individual_metrics", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = globaldata$main_assessor, 
                                  secondary_assessor = globaldata$secondary_assessor)
                   }
                   
                   output$textoutput_step<- renderText({
                     paste(message,collapse="\n")
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 },finally={
                   hide("cancel_integrate_new_individual_metrics_button")
                   hide("validate_integrate_new_individual_metrics_button")
                   data$data_to_be_integrated <- NULL
                 }), ignoreInit=TRUE)
               }
               
  )
}