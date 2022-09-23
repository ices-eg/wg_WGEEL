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
			
			h2("step 2.1.2 Update sampling"),
			fluidRow(
					column(
							width=4,
							fileInput(ns("xl_updated_sampling"), "xls update sampling, do this first and re-run compare",
									multiple=FALSE,
									accept = c(".xls",".xlsx")
							)
					),
					column(
							width=2,
							actionButton(ns("update_sampling_button"), "Proceed")
					),
					column(
							width=6,
							verbatimTextOutput(ns("textoutput_step2.1.2_dcf"))
					)
			),
			writedeletedgroupmetricUI(ns("deletedgroupmetricdcf"), "step 2.2.1 Delete from group metrics"),
			writenewgroupmetricUI(ns("newgroupmetricdcf"), "step 2.2.2 Integrate new group metrics"),
			writeupdatedgroupmetricUI(ns("updatedgroupmetricdcf"), "step 2.2.3 Update group metrics"),

			writedeletedindmetricUI(ns("deletedindmetricdcf"), "step 2.3.1 Delete from individual metrics"),
			writenewindmetricUI(ns("newindmetricdcf"), "step 2.3.2 Integrate new individual metrics"),
			writeupdatedindmetricUI(ns("updatedindmetricdcf"), "step 2.3.3 Update individual metrics"),

	
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
										output$"textoutput_step2.1.1_dcf" <- renderText("")
										output$"textoutput_step2.1.2_dcf" <- renderText("")
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
				writedeletedgroupmetricServer("deletedgroupmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
				
				# 2.2.2 Integrate new group metrics sampling  --------------------------------------------------------							
				writenewgroupmetricServer("newgroupmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
				
				
				# 2.2.3 update modified group metrics  --------------------------------------------------------							
				writeupdatedgroupmetricServer("updatedgroupmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
			
				# 2.3.1 Deleted individual metrics --------------------------------------------------------							
				writedeletedindmetricServer("deletedindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")

				# 2.3.2 Integrate new individual metrics --------------------------------------------------------							
        writenewindmetricServer("newindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
				
				# 2.3.3 updated individual metrics  --------------------------------------------------------							
				writeupdatedindmetricServer("updatedindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")

			}
	
	)
}