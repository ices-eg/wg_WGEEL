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
									column(width=4,fileInput(ns("xlfile_ts"), "Choose xls File",
													multiple=FALSE,
													accept = c(".xls",".xlsx")
											)),
									column(width=4,  radioButtons(inputId=ns("file_type_ts"), label="File type:",
													c(	"Glass eel (recruitment)"="glass_eel",
															"Yellow eel (standing stock)"="yellow_eel ",
															"Silver eel"="silver_eel"
													))),
									column(width=4, actionButton(ns("ts_check_file_button"), "Check file") )                     
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


importtsstep0Server <- function(id,globaldata){
	moduleServer(id,
			function(input, output, session) {
				
				rls <- reactiveValues(res = list(),
						message = "",
						file_type = "")
				
				
				data <- reactiveValues(path_step0_ts = NULL) 
				
				
				
				observeEvent(input$xlfile_ts,tryCatch({
									rls$file_type=""
									rls$res = list()
									rls$message = ""
									if (input$xlfile_ts$name!="") {
										output$integrate<-renderText({input$xlfile_ts$datapath})
									} else {
										output$integrate<-renderText({"no dataset seleted"})
									}
									output$dt_integrate_ts<-renderDataTable(data.frame())
									output$"step0_message_xls_ts"<-renderText("")
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}))
				
				###########################
				# step0_filepath_ts same for time series
				# this will add a path value to reactive data in step0
				###########################			
				step0_filepath_ts <- reactive({
							inFile_ts <- input$xlfile_ts      
							if (is.null(inFile_ts)){        return(NULL)
							} else {
								data$path_step0_ts <- inFile_ts$datapath #path to a temp file
								if (grepl(c("glass"),tolower(inFile_ts$name))) 
									updateRadioButtons(session, "file_type_ts", selected = "glass_eel")
								if (grepl(c("yellow"),tolower(inFile_ts$name)))
									updateRadioButtons(session, "file_type_ts", selected = "yellow_eel")
								if (grepl(c("silver"),tolower(inFile_ts$name)))
									updateRadioButtons(session, "file_type_ts", selected = "silver_eel")						
							}
						}) 			
				
				
				
				###########################
				# step0load_data_ts (same for time series)
				###########################
				step0load_data_ts<-function(){
					validate(need(globaldata$connectOK,"No connection"))
					isolate(step0_filepath_ts())  #NOT USED
					isolate(if (is.null(data$path_step0_ts)) return(NULL))
					
					#file_type_ts is generated on the ui side
					#load series returns a list with several sheets
					#return(invisible(list(series=series,
					#						station = station,
					#						new_data=new_data,
					#						updated_data=updated_data,
					#						new_biometry=new_biometry,
					#						updated_biometry=updated_biometry,
					#						error=data_error,
					#						the_metadata=the_metadata))) 
					# it also prints error or comments captured by capture.output
					switch (input$file_type_ts, 
							"glass_eel"={                  
								message<-capture.output(res <- load_series(data$path_step0_ts, 
												datasource = the_eel_datasource,
												stage="glass_eel"
										))},
							"yellow_eel"={
								message<-capture.output(res <- load_series(data$path_step0_ts, 
												datasource = the_eel_datasource,
												stage="yellow_eel"))},
							"silver_eel"={
								message<-capture.output(res <- load_series(data$path_step0_ts, 
												datasource = the_eel_datasource,
												stage="silver_eel"))}
					# -------------------------------------------------------------				
					# see  #130			https://github.com/ices-eg/wg_WGEEL/issues/130			
					#						"biometry"={
					#							message<-capture.output(res<-load_biometry(data$path_step0, 
					#											datasource = the_eel_datasource ))},
					#						}
					#---------------------------------------------------------------	
					)
					return(list(res=res,message=message))
				}
				
				plotseries <- function(series){
					output$maps_timeseries<- renderLeaflet({
								leaflet() %>% addTiles() %>%
										addMarkers(data=series,lat=~ser_y,lng=~ser_x,label=~ser_nameshort) %>%
										addPolygons(data=data$ccm_light, 
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
				# Events triggerred by step0_button (time series page)
				###################################################
				observeEvent(input$ts_check_file_button, tryCatch({
									
									##################################################
									# clean up
									#################################################						
									
									rls$file_type <- NULL
									rls$res <- NULL
									rls$message <- NULL
									
									
									##################################################
									# integrate verbatimtextoutput
									# this will print the error messages to the console
									#################################################
									output$integrate_ts<-renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												if (is.null(data$path_step0_ts)) "please select a dataset" else { 
													tmp <- step0load_data_ts() # result list
													rls$message <- tmp$message
													rls$res <- tmp$res
													# this will fill the log_datacall file (database_tools.R)
													if(length(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]))>1) stop(paste("More than one country there",
																		paste(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]),collapse=";"), ": while there should be only one country code"))
													cou_code <- rls$res$series$ser_cou_code[1]
													if (nrow(rls$res$series)>0) plotseries(rls$res$series)
													# the following three lines might look silly but passing input$something to the log_datacall function results
													# in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
													main_assessor <- input$main_assessor
													secondary_assessor <- input$secondary_assessor
													file_type <- input$file_type_ts
													rls$file_type <- file_type
													# this will fill the log_datacall file (database_tools.R)
													log_datacall( "check data time series",cou_code = cou_code, message = paste(rls$message,collapse="\n"), the_metadata = rls$res$the_metadata, file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor )
													paste(rls$message, collapse="\n")						
												}
												
											}) 
									##################################
									# Actively generates UI component on the ui side 
									# which displays text for xls download
									##################################
									
									output$"step0_message_xls_ts"<-renderUI(
											HTML(
													paste(
															h4("Time series file checking messages (xls)"),
															"<p align='left'>Please click on excel",'<br/>',
															"to download this file and correct the errors",'<br/>',
															"and submit again in <strong>step0</strong> the file once it's corrected<p>"
													)))  
									
									##################################
									# Actively generates UI component on the ui side
									# which generates text for txt
									################################## 									
									
									output$"step0_message_txt_ts"<-renderUI(
											HTML(
													paste(
															h4("Time series file checking messages (txt)"),
															"<p align='left'>Please read carefully and ensure that you have",
															"checked all possible errors. This output is the same as the table",
															" output<p>"
													)))
									
									
									#####################
									# DataTable integration error (TIME SERIES)
									########################
									
									output$dt_integrate_ts <- DT::renderDataTable({
												validate(need(input$xlfile_ts$name != "", "Please select a data set"))
												ls <- step0load_data_ts()
												if(length(unique(ls$res$series$ser_cou_code[!is.na(ls$res$series$ser_cou_code)]))>1) stop(paste("More than one country there ",
																	paste(unique(ls$res$series$ser_cou_code[!is.na(ls$res$series$ser_cou_code)]),collapse=";"), ": while there should be only one country code"))
												cou_code <- ls$res$series$ser_cou_code[1]
												datatable(ls$res$error,
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
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}))
				
				
				
				return(rls)
			}
	
	)
}