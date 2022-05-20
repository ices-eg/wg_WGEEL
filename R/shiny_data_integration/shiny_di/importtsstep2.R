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
          h2("step 2.1 Integrate new series"),
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
              verbatimTextOutput(ns("textoutput_step2.1_ts"))
            )
          ),
          h2("step 2.2 Update modified series"),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_updated_series"), "xls modified series, do this first and re-run compare",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("update_series_button"), "Proceed")
            ),
            column(
              width=6,
              verbatimTextOutput(ns("textoutput_step2.2_ts"))
            )
          ),
          h2("step 2.3 Integrate new dataseries"),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_new_dataseries"), "Once the series are updated, integrate new dataseries",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("integrate_new_dataseries_button"), "Proceed")
            ),
            column(
              width=6,
              verbatimTextOutput(ns("textoutput_step2.3_ts"))
            )
          ),
          h2("step 2.4 Update modified dataseries"),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_updated_dataseries"), "Update the modified dataseries",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx")
              )
            ),
            column(
              width=2,
              actionButton(ns("update_dataseries_button"), "Proceed")
            ),
            column(
              width=6,
              verbatimTextOutput(ns("textoutput_step2.4_ts"))
            )
          ),
          h2("step 2.5 Integrate new group metrics"),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_new_group_metrics"), "xls update",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("integrate_new_group_metrics_button"), "Proceed")
            ),
            column(width=6,
                   verbatimTextOutput(ns("textoutput_step2.5_ts"))
            )
          ),
          h2("step 2.6 Update group metrics"),
          fluidRow(
            column(
              width=4,
              fileInput(ns("xl_update_group_metrics"), "xls update",
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("update_group_metrics_button"), "Proceed")
            ),
            column(
              width=6,
              verbatimTextOutput(ns("textoutput_step2.6_ts"))
            )
          ),
					h2("step 2.7 Integrate new individual metrics"),
					fluidRow(
							column(
									width=4,
									fileInput(ns("xl_new_individual_metrics"), "xls update",
											multiple=FALSE,
											accept = c(".xls",".xlsx"))
							),
							column(
									width=2,
									actionButton(ns("integrate_new_individual_metrics_button"), "Proceed")
							),
							column(width=6,
									verbatimTextOutput(ns("textoutput_step2.7_ts"))
							)
					),
					h2("step 2.8 Update group metrics"),
					fluidRow(
							column(
									width=4,
									fileInput(ns("xl_update_individual_metrics"), "xls update",
											multiple=FALSE,
											accept = c(".xls",".xlsx"))
							),
							column(
									width=2,
									actionButton(ns("update_individual_metrics_button"), "Proceed")
							),
							column(
									width=6,
									verbatimTextOutput(ns("textoutput_step2.8_ts"))
							)
					)
					

  )
}




#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_ts data from step0
#'
#' @return loaded data and file type


importtsstep2Server <- function(id,globaldata,loaded_data_ts){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 observe({
                     
                     ##################################################
                     # clean up
                     #################################################
                   loaded_data_ts$res
                   tryCatch({
                     output$textoutput_step2.1_ts <- renderText("")
               
                     reset("xl_update_group_metrics")
                     reset("xl_new_group_metrics")
                     reset("xl_updated_dataseries")
                     reset("xl_new_dataseries")
                     reset("xl_updated_series")
                     reset("xl_new_series")
                     
                     
                     output$"textoutput_step2.1_ts" <- renderText("")
                     output$"textoutput_step2.2_ts" <- renderText("")
                     output$"textoutput_step2.3_ts" <- renderText("")
                     output$"textoutput_step2.4_ts" <- renderText("")
                     output$"textoutput_step2.5_ts" <- renderText("")
                     output$"textoutput_step2.6_ts" <- renderText("")
                    

                     
                   },
                   error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 observeEvent(input$integrate_new_series_button, tryCatch({
                   
                   
                   step21_filepath_new_series <- reactive({
                     inFile <- isolate(input$xl_new_series)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step21_new_series <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step21load_data <- function() {
                     path <- isolate(step21_filepath_new_series())
                     if (is.null(data$path_step21_new_series)) 
                       return(NULL)
                     rls <- write_new_series(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("new series integration", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.1_ts<-renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step21load_data()
                     if (is.null(data$path_step21_new_series)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))			
                 
                 # 2.2 update modified series  --------------------------------------------------------
                 
                 
                 observeEvent(input$update_series_button, tryCatch({
                   
                   step22_filepath_modified_series <- reactive({
                     inFile <- isolate(input$xl_updated_series)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step22_modified_series <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step22load_data <- function() {
                     path <- isolate(step22_filepath_modified_series())
                     if (is.null(data$path_step22_modified_series)) 
                       return(NULL)
                     rls <- update_series(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("update series", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.2_ts<-renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step22load_data()
                     if (is.null(data$path_step22_modified_series)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))	
                 
                 # 2.3 new dataseries  --------------------------------------------------------							
                 
                 observeEvent(input$integrate_new_dataseries_button, tryCatch({
                   
                   step23_filepath_new_dataseries <- reactive({
                     inFile <- isolate(input$xl_new_dataseries)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_23_new_dataseries <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step23load_data <- function() {
                     path <- isolate(step23_filepath_new_dataseries())
                     if (is.null(data$path_step_23_new_dataseries)) 
                       return(NULL)
                     rls <- write_new_dataseries(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("new dataseries integration", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.3_ts <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step23load_data()
                     if (is.null(data$path_step_23_new_dataseries)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))	
                 
                 # 2.4 update modified dataseries  --------------------------------------------------------							
                 
                 observeEvent(input$update_dataseries_button, tryCatch({
                   
                   step24_filepath_modified_dataseries <- reactive({
                     inFile <- isolate(input$xl_updated_dataseries)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_24_modified_dataseries <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step24load_data <- function() {
                     path <- isolate(step24_filepath_modified_dataseries())
                     if (is.null(data$path_step_24_modified_dataseries)) 
                       return(NULL)
                     rls <- update_dataseries(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("update dataseries", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.4_ts <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step24load_data()
                     if (is.null(data$path_step_24_modified_dataseries)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))	
                 
                 # 2.5 Integrate new group metrics series  --------------------------------------------------------							
                 
                 observeEvent(input$integrate_new_group_metrics_button, tryCatch({
                   
                   step25_filepath_new_group_metrics <- reactive({
                     inFile <- isolate(input$xl_new_group_metrics)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_25_new_group_metrics <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step25load_data <- function() {
                     path <- isolate(step25_filepath_new_group_metrics())
                     if (is.null(data$path_step_25_new_group_metrics)) 
                       return(NULL)
                     rls <- write_new_group_metrics(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("write new group_metrics", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.5_ts <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step25load_data()
                     if (is.null(data$path_step_25_new_group_metrics)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 # 2.6 update modified group metrics  --------------------------------------------------------							
                 
                 observeEvent(input$update_group_metrics_button, tryCatch({
                   
                   step26_filepath_update_group_metrics <- reactive({
                     inFile <- isolate(input$xl_update_group_metrics)     
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path_step_26_update_group_metrics <- inFile$datapath #path to a temp file             
                     }
                   })
                   
                   step26load_data <- function() {
                     path <- isolate(step26_filepath_update_group_metrics())
                     if (is.null(data$path_step_26_update_group_metrics)) 
                       return(NULL)
                     rls <- update_group_metrics(path)
                     message <- rls$message
                     cou_code <- rls$cou_code
                     main_assessor <- input$main_assessor
                     secondary_assessor <- input$secondary_assessor
                     file_type <- loaded_data_ts$file_type
                     log_datacall("update group_metrics", cou_code = cou_code, message = sQuote(message), 
                                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                                  secondary_assessor = secondary_assessor)
                     return(message)
                   }
                   
                   output$textoutput_step2.6_ts <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     message <- step26load_data()
                     if (is.null(data$path_step_26_update_group_metrics)) "please select a dataset" else {                                      
                       paste(message,collapse="\n")
                     }                  
                   })  
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))	
				 
				 # 2.7 Integrate new individual group metrics --------------------------------------------------------							
				 
				 observeEvent(input$integrate_new_individual_metrics_button, tryCatch({
									 
									 step25_filepath_new_individual_metrics <- reactive({
												 inFile <- isolate(input$xl_new_individual_metrics)     
												 if (is.null(inFile)){        return(NULL)
												 } else {
													 data$path_step_25_new_individual_metrics <- inFile$datapath #path to a temp file             
												 }
											 })
									 
									 step25load_data <- function() {
										 path <- isolate(step25_filepath_new_individual_metrics())
										 if (is.null(data$path_step_25_new_individual_metrics)) 
											 return(NULL)
										 rls <- write_new_individual_metrics(path)
										 message <- rls$message
										 cou_code <- rls$cou_code
										 main_assessor <- input$main_assessor
										 secondary_assessor <- input$secondary_assessor
										 file_type <- loaded_data_ts$file_type
										 log_datacall("write new individual_metrics", cou_code = cou_code, message = sQuote(message), 
												 the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												 secondary_assessor = secondary_assessor)
										 return(message)
									 }
									 
									 output$textoutput_step2.5_ts <- renderText({
												 validate(need(globaldata$connectOK,"No connection"))
												 # call to  function that loads data
												 # this function does not need to be reactive
												 message <- step25load_data()
												 if (is.null(data$path_step_25_new_individual_metrics)) "please select a dataset" else {                                      
													 paste(message,collapse="\n")
												 }                  
											 })  
								 },error = function(e) {
									 showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								 }))
				 
				 # 2.8 update modified individual metrics  --------------------------------------------------------							
				 
				 observeEvent(input$update_individual_metrics_button, tryCatch({
									 
									 step26_filepath_update_individual_metrics <- reactive({
												 inFile <- isolate(input$xl_update_individual_metrics)     
												 if (is.null(inFile)){        return(NULL)
												 } else {
													 data$path_step_26_update_individual_metrics <- inFile$datapath #path to a temp file             
												 }
											 })
									 
									 step26load_data <- function() {
										 path <- isolate(step26_filepath_update_individual_metrics())
										 if (is.null(data$path_step_26_update_individual_metrics)) 
											 return(NULL)
										 rls <- update_individual_metrics(path)
										 message <- rls$message
										 cou_code <- rls$cou_code
										 main_assessor <- input$main_assessor
										 secondary_assessor <- input$secondary_assessor
										 file_type <- loaded_data_ts$file_type
										 log_datacall("update individual_metrics", cou_code = cou_code, message = sQuote(message), 
												 the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												 secondary_assessor = secondary_assessor)
										 return(message)
									 }
									 
									 output$textoutput_step2.6_ts <- renderText({
												 validate(need(globaldata$connectOK,"No connection"))
												 # call to  function that loads data
												 # this function does not need to be reactive
												 message <- step26load_data()
												 if (is.null(data$path_step_26_update_individual_metrics)) "please select a dataset" else {                                      
													 paste(message,collapse="\n")
												 }                  
											 })  
								 },error = function(e) {
									 showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								 }))		
                 

               }
               
  )
}