#' Step 2 of annex 9 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importdcfstep2UI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			tags$hr(),
			h2("step 2.1.1 Integrate new sampling"),
			fluidRow(
					column(
							width=4,
							fileInput(ns("xl_new_sampling"), "xls new sampling, do this first and re-run compare",
									multiple=FALSE,
									accept = c(".xls",".xlsx")
							)
					),
					column(
							width=2,
							actionButton(ns("integrate_new_sampling_button"), "Proceed")
					),
					column(
							width=6,
							verbatimTextOutput(ns("textoutput_step2.1.1_dcf"))
					)
			),
			
			h2("step 2.2.1 Delete from group metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.2.1_dcf"))
					)
			),
			h2("step 2.2.2 Integrate new group metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.2.2_dcf"))
					)
			),
			h2("step 2.2.3 Update group metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.2.3_dcf"))
					)
			),
			h2("step 2.3.1 Delete from individual metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.3.1_dcf"))
					)
			),
			h2("step 2.3.2 Integrate new individual metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.3.2_dcf"))
					)
			),
			h2("step 2.3.3 Update individual metrics"),
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
							verbatimTextOutput(ns("textoutput_step2.3.3_dcf"))
					)
			)
	
	
	)
}




#' Step 2 of annex 9 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_dcf data from step0
#'
#' @return loaded data and file type


importdcfstep2Server <- function(id,globaldata,loaded_data_dcf){
	moduleServer(id,
			function(input, output, session) {
				data <- reactiveValues()
				observe({
							
							##################################################
							# clean up
							#################################################
							loaded_data_dcf$res
							tryCatch({
										output$textoutput_step2.1_dcf <- renderText("")
										
										reset("xl_new_sampling")
										reset("xl_updated_sampling")
										reset("xl_deleted_group_metrics")
										reset("xl_new_group_metrics")
										reset("xl_update_group_metrics")
										reset("xl_deleted_individual_metrics")
										reset("xl_new_individual_metrics")
										reset("xl_update_individual_metrics")
										
										output$"textoutput_step2.1.1_dcf" <- renderText("")
										output$"textoutput_step2.1.2_dcf" <- renderText("")
										output$"textoutput_step2.2.1_dcf" <- renderText("")
										output$"textoutput_step2.2.2_dcf" <- renderText("")
										output$"textoutput_step2.2.3_dcf" <- renderText("")
										output$"textoutput_step2.3.1_dcf" <- renderText("")
										output$"textoutput_step2.3.2_dcf" <- renderText("")
										output$"textoutput_step2.3.3_dcf" <- renderText("")
										
										
										
									},
									error = function(e) {
										showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
									})})
				
				observeEvent(input$integrate_new_sampling_button, tryCatch({
									
									# 2.1.1 new sampling  --------------------------------------------------------
									
									step2.1.1_filepath_new_sampling <- reactive({
												inFile <- isolate(input$xl_new_sampling)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step2.1.1_new_sampling <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.1.1_load_data <- function() {
										path <- isolate(step2.1.1_filepath_new_sampling())
										if (is.null(data$path_step2.1.1_new_sampling)) 
											return(NULL)
										rls <- write_new_sampling(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("new sampling integration", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.1.1_dcf<-renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.1.1_load_data()
												if (is.null(data$path_step2.1.1_new_sampling)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)			
				
				# 2.1.2 modified sampling  --------------------------------------------------------
				
				
				observeEvent(input$update_sampling_button, tryCatch({
									
									step2.1.2_filepath_modified_sampling <- reactive({
												inFile <- isolate(input$xl_updated_sampling)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step2.1.2_modified_sampling <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.1.2_load_data <- function() {
										path <- isolate(step2.1.2_filepath_modified_sampling())
										if (is.null(data$path_step2.1.2_modified_sampling)) 
											return(NULL)
										rls <- update_sampling(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("update sampling", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.1.2_dcf<-renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.1.2_load_data()
												if (is.null(data$path_step2.1.2_modified_sampling)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)	
				
				
				# 2.2.1 deleted group metrics sampling  --------------------------------------------------------							
				
				observeEvent(input$delete_group_metrics_button, tryCatch({
									
									step2.2.1_filepath_deleted_group_metrics <- reactive({
												inFile <- isolate(input$xl_deleted_group_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.2.1_deleted_group_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.2.1_load_data <- function() {
										path <- isolate(step2.2.1_filepath_deleted_group_metrics())
										if (is.null(data$path_step_2.2.1_deleted_group_metrics)) 
											return(NULL)
										rls <- delete_group_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("deleted group_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.2.1_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.2.1_load_data()
												if (is.null(data$path_step_2.2.1_deleted_group_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)
				
				# 2.2.2 Integrate new group metrics sampling  --------------------------------------------------------							
				
				observeEvent(input$integrate_new_group_metrics_button, tryCatch({
									
									step2.2.2_filepath_new_group_metrics <- reactive({
												inFile <- isolate(input$xl_new_group_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.2.2_new_group_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.2.2_load_data <- function() {
										path <- isolate(step2.2.2_filepath_new_group_metrics())
										if (is.null(data$path_step_2.2.2_new_group_metrics)) 
											return(NULL)
										rls <- write_new_group_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("write new group_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.2.2_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.2.2_load_data()
												if (is.null(data$path_step_2.2.2_new_group_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)
				
				# 2.2.3 update modified group metrics  --------------------------------------------------------							
				
				observeEvent(input$update_group_metrics_button, tryCatch({
									
									step2.2.3_filepath_update_group_metrics <- reactive({
												inFile <- isolate(input$xl_update_group_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.2.3_update_group_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.2.3_load_data <- function() {
										path <- isolate(step2.2.3_filepath_update_group_metrics())
										if (is.null(data$path_step_2.2.3_update_group_metrics)) 
											return(NULL)
										rls <- update_group_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("update group_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.2.3_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.2.3_load_data()
												if (is.null(data$path_step_26_update_group_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)	
				
				# 2.3.1 Deleted individual metrics --------------------------------------------------------							
				
				observeEvent(input$delete_individual_metrics_button, tryCatch({
									
									step2.3.1_filepath_deleted_individual_metrics <- reactive({
												inFile <- isolate(input$xl_deleted_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.3.1_deleted_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.3.1_load_data <- function() {
										path <- isolate(step2.3.1_filepath_deleted_individual_metrics())
										if (is.null(data$path_step_2.3.1_deleted_individual_metrics)) 
											return(NULL)
										rls <- delete_individual_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("deleted individual_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.3.1_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.3.1_load_data()
												if (is.null(data$path_step_2.3.1_deleted_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)
				
				# 2.3.2 Integrate new individual metrics --------------------------------------------------------							
				
				observeEvent(input$integrate_new_individual_metrics_button, tryCatch({
									
									step2.3.2_filepath_new_individual_metrics <- reactive({
												inFile <- isolate(input$xl_new_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.3.2_new_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.3.2_load_data <- function() {
										path <- isolate(step2.3.2_filepath_new_individual_metrics())
										if (is.null(data$path_step_2.3.2_new_individual_metrics)) 
											return(NULL)
										rls <- write_new_individual_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("write new individual_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.3.2_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.3.2_load_data()
												if (is.null(data$path_step_2.3.2_new_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)
				
				# 2.3.3 updated individual metrics  --------------------------------------------------------							
				
				observeEvent(input$update_individual_metrics_button, tryCatch({
									
									step2.3.3_filepath_update_individual_metrics <- reactive({
												inFile <- isolate(input$xl_update_individual_metrics)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step_2.3.3_update_individual_metrics <- inFile$datapath #path to a temp file             
												}
											})
									
									step2.3.3_load_data <- function() {
										path <- isolate(step2.3.3_filepath_update_individual_metrics())
										if (is.null(data$path_step_2.3.3_update_individual_metrics)) 
											return(NULL)
										rls <- update_individual_metrics(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- loaded_data_dcf$file_type
										log_datacall("update individual_metrics", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									
									output$textoutput_step2.3.3_dcf <- renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message <- step2.3.3_load_data()
												if (is.null(data$path_step_2.3.3_update_individual_metrics)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreInit = TRUE)		
				
				
			}
	
	)
}