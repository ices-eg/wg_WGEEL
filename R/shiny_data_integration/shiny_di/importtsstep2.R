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
			),
			h2("step 2.2.1 Delete from dataseries"),
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
			h2("step 2.2.2 Integrate new dataseries"),
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
							verbatimTextOutput(ns("textoutput_step2.2.2_ts"))
					)
			),
			h2("step 2.2.3 Update modified dataseries"),
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
							verbatimTextOutput(ns("textoutput_step2.2.3_ts"))
					)
			),
			h2("step 2.3.1 Delete from group metrics"),
			fluidRow(
					column(
							width=4,
							fileInput(ns("xl_deleted_group_metrics"), "xls update",
									multiple=FALSE,
									accept = c(".xls",".xlsx"))
					),
					column(
							width=2,
							actionButton(ns("delete_group_metrics_button"), "Proceed")
					),
					column(width=6,
							verbatimTextOutput(ns("textoutput_step2.3.1_ts"))
					)
			),
			h2("step 2.3.2 Integrate new group metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.3.2_ts"))
					)
			),
			h2("step 2.3.3 Update group metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.3.3_ts"))
					)
			),
			h2("step 2.4.1 Delete from individual metrics"),
			fluidRow(
					column(
							width=4,
							fileInput(ns("xl_deleted_individual_metrics"), "xls update",
									multiple=FALSE,
									accept = c(".xls",".xlsx"))
					),
					column(
							width=2,
							actionButton(ns("delete_individual_metrics_button"), "Proceed")
					),
					column(width=6,
							verbatimTextOutput(ns("textoutput_step2.4.1_ts"))
					)
			),
			h2("step 2.4.2 Integrate new individual metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.4.2_ts"))
					)
			),
			h2("step 2.4.3 Update individual metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.4.3_ts"))
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
							shinyCatch({
										output$textoutput_step2.1_ts <- renderText("")
										
										reset("xl_new_series")
										reset("xl_updated_series")
										reset("xl_new_dataseries")
										reset("xl_updated_dataseries")
										reset("xl_deleted_dataseries")
										reset("xl_deleted_group_metrics")
										reset("xl_new_group_metrics")
										reset("xl_update_group_metrics")
										reset("xl_deleted_individual_metrics")
										reset("xl_new_individual_metrics")
										reset("xl_update_individual_metrics")
										
										output$"textoutput_step2.1.1_ts" <- renderText("")
										output$"textoutput_step2.1.2_ts" <- renderText("")
										output$"textoutput_step2.2.1_ts" <- renderText("")
										output$"textoutput_step2.2.2_ts" <- renderText("")
										output$"textoutput_step2.2.3_ts" <- renderText("")
										output$"textoutput_step2.3.1_ts" <- renderText("")
										output$"textoutput_step2.3.2_ts" <- renderText("")
										output$"textoutput_step2.3.3_ts" <- renderText("")
										output$"textoutput_step2.4.1_ts" <- renderText("")
										output$"textoutput_step2.4.2_ts" <- renderText("")
										output$"textoutput_step2.4.3_ts" <- renderText("")
										
										
										
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
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
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
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
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
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
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
				
				observeEvent(input$integrate_new_dataseries_button, shinyCatch({
									
									step2.2.2_filepath_new_dataseries <- reactive({
												inFile <- isolate(input$xl_new_dataseries)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.2.2_new_dataseries <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.2.2_load_data <- function() {
										path <- isolate(step2.2.2_filepath_new_dataseries())
										if (is.null(data$path_step_2.2.2_new_dataseries)) 
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
									
									output$textoutput_step2.2.2_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.2.2_load_data()
												if (is.null(data$path_step_2.2.2_new_dataseries)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), ignoreInit = TRUE)	
				
				# 2.2.3 update modified dataseries  --------------------------------------------------------							
				
				observeEvent(input$update_dataseries_button, shinyCatch({
									
									step2.2.3_filepath_modified_dataseries <- reactive({
												inFile <- isolate(input$xl_updated_dataseries)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.2.3_modified_dataseries <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.2.3_load_data <- function() {
										path <- isolate(step2.2.3_filepath_modified_dataseries())
										if (is.null(data$path_step_2.2.3_modified_dataseries)) 
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
									
									output$textoutput_step2.2.3_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.2.3_load_data()
												if (is.null(data$path_step_2.2.3_modified_dataseries)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), ignoreInit = TRUE)	
				
				# 2.3.1 deleted group metrics series  --------------------------------------------------------							
				
				observeEvent(input$delete_group_metrics_button, shinyCatch({
									
									step2.3.1_filepath_deleted_group_metrics <- reactive({
												inFile <- isolate(input$xl_deleted_group_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.3.1_deleted_group_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.3.1_load_data <- function() {
										path <- isolate(step2.3.1_filepath_deleted_group_metrics())
										if (is.null(data$path_step_2.3.1_deleted_group_metrics)) 
											return(NULL)
										rls <- delete_group_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_ts$file_type
										log_datacall("deleted group_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.3.1_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.3.1_load_data()
												if (is.null(data$path_step_2.3.1_deleted_group_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), ignoreInit = TRUE)
				
				# 2.3.2 Integrate new group metrics series  --------------------------------------------------------							
				
				observeEvent(input$integrate_new_group_metrics_button, 
						shinyCatch(
						{
							
							step2.3.2_filepath_new_group_metrics <- reactive({
										inFile <- isolate(input$xl_new_group_metrics)     
										if (is.null(inFile)){        return(NULL)
										} else {
											data$path_step_2.3.2_new_group_metrics <- inFile$datapath #path to a temp file             
										}
									})
							
							step2.3.2_load_data <- function() {
								path <- isolate(step2.3.2_filepath_new_group_metrics())
								if (is.null(data$path_step_2.3.2_new_group_metrics)) 
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
							
							output$textoutput_step2.3.2_ts <- renderText({
										validate(need(globaldata$connectOK,"No connection"))
										# call to  function that loads data
										# this function does not need to be reactive
										message <- step2.3.2_load_data()
										if (is.null(data$path_step_2.3.2_new_group_metrics)) "please select a dataset" else {                                      
											paste(message,collapse="\n")
										}                  
									})  
						}
						)
						, ignoreInit = TRUE)
				
				# 2.3.3 update modified group metrics  --------------------------------------------------------							
				
				observeEvent(input$update_group_metrics_button, shinyCatch({
									
									step2.3.3_filepath_update_group_metrics <- reactive({
												inFile <- isolate(input$xl_update_group_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.3.3_update_group_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.3.3_load_data <- function() {
										path <- isolate(step2.3.3_filepath_update_group_metrics())
										if (is.null(data$path_step_2.3.3_update_group_metrics)) 
											return(NULL)
										rls <- write_updated_group_metrics(path)
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
									
									output$textoutput_step2.3.3_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.3.3_load_data()
												if (is.null(data$path_step_2.3.3_update_group_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), ignoreInit = TRUE)	
				
				# 2.4.1 Deleted individual metrics --------------------------------------------------------							
				
				observeEvent(input$delete_individual_metrics_button, shinyCatch({
									
									step2.4.1_filepath_deleted_individual_metrics <- reactive({
												inFile <- isolate(input$xl_deleted_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.4.1_deleted_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.4.1_load_data <- function() {
										path <- isolate(step2.4.1_filepath_deleted_individual_metrics())
										if (is.null(data$path_step_2.4.1_deleted_individual_metrics)) 
											return(NULL)
										rls <- delete_individual_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_ts$file_type
										log_datacall("deleted individual_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.4.1_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.4.1_load_data()
												if (is.null(data$path_step_2.4.1_deleted_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), ignoreInit = TRUE)
				
				# 2.4.2 Integrate new individual metrics --------------------------------------------------------							
				observeEvent(input$integrate_new_individual_metrics_button, 
						shinyCatch(
							{
									
									step2.4.2_filepath_new_individual_metrics <- reactive({
												inFile <- isolate(input$xl_new_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.4.2_new_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.4.2_load_data <- function() {
										path <- isolate(step2.4.2_filepath_new_individual_metrics())
										if (is.null(data$path_step_2.4.2_new_individual_metrics)) 
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
									
									output$textoutput_step2.4.2_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.4.2_load_data()
												if (is.null(data$path_step_2.4.2_new_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}
						  )# end shinyCatch
								, ignoreInit = TRUE)
				
				# 2.4.3 updated individual metrics  --------------------------------------------------------							
				
				observeEvent(input$update_individual_metrics_button, shinyCatch({
									
									step2.4.3_filepath_update_individual_metrics <- reactive({
												inFile <- isolate(input$xl_update_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.4.3_update_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.4.3_load_data <- function() {
										path <- isolate(step2.4.3_filepath_update_individual_metrics())
										if (is.null(data$path_step_2.4.3_update_individual_metrics)) 
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
									
									output$textoutput_step2.4.3_ts <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.4.3_load_data()
												if (is.null(data$path_step_2.4.3_update_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								}), 				 ignoreInit = TRUE)		
				
				
			}
	
	)
}