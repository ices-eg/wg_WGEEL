#' Integration of group metric (annex 1-3 and 10)
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param title header of the section
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


writenewgroupmetricUI <- function(id, title){
  ns <- NS(id)
  tagList(useShinyjs(),
          h2(title),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_new_group_metrics"), "Write new group metrics file",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("integrate_new_group_metrics_button"), "Proceed")
            ),
            column(width=6,
                   verbatimTextOutput(ns("textoutput_step"))
            )
          )
  )
}




#' Step 2 of annex 9 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data data from step0
#' @param type series or other
#'
#' @return loaded data and file type


writenewgroupmetricServer <- function(id,globaldata,loaded_data, type = "series"){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data$res
                   tryCatch({
                     reset("xl_new_group_metrics")
                     output$"textoutput_step" <- renderText("")
                   },
                   error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 
                 # Integrate new group metrics sampling  --------------------------------------------------------							
                 
                 observeEvent(input$integrate_new_group_metrics_button, tryCatch({
                   
                   step_filepath_new_group_metrics <- reactive({
                     inFile <- isolate(input$xl_new_group_metrics)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_new_group_metrics <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step_load_data <- function() {
                     path <- isolate(step_filepath_new_group_metrics())
                     if (is.null(data$path_step_new_group_metrics)) 
                       return(NULL)
                     rls <- write_new_group_metrics(path, type=type)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data$file_type
                     if (cou_code != ""){#otherwise something was incorrect
                       log_datacall("write new group_metrics", cou_code = cou_code, message = sQuote(message), 
                                    file_type = file_type, main_assessor = globaldata$main_assessor, 
                                    secondary_assessor = globaldata$secondary_assessor)
                     }
                     return(message)
                   }
                   
                   output$textoutput_step <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step_load_data()
                     if (is.null(data$path_step_new_group_metrics)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
               }
               
  )
}