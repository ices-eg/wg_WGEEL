#' Step 0 
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importdcfstep0UI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			h2("Datacall DCF data - quality - biometry integration"),								
			h2("step 0 : Data check"),
			tabsetPanel(tabPanel("MAIN",
							fluidRow(
									column(width=4,fileInput(ns("xlfile_dcf"), "Choose xls File",
													multiple=FALSE,
													accept = c(".xls",".xlsx")
											)),
#                                 column(width=4,  radioButtons(inputId=ns("file_type_dcf"), label="File type:",
#                                                               c(	"Glass eel (recruitment)"="glass_eel",
#                                                                  "Yellow eel (standing stock)"="yellow_eel ",
#                                                                  "Silver eel"="silver_eel"
#                                                               ))),
									column(width=4, actionButton(ns("dcf_check_file_button"), "Check file") )                     
							),
							
							fluidRow(
									column(width=6,
											htmlOutput(ns("step0_message_txt_dcf")),
											verbatimTextOutput(ns("integrate_dcf")),placeholder=TRUE),
									column(width=6,
											htmlOutput(ns("step0_message_xls_dcf")),
											DT::dataTableOutput(ns("dt_integrate_dcf")))
							)),
					tabPanel("MAPS",
							fluidRow(column(width=10),
									leafletOutput(ns("maps_dcf")))))
	)
}




#' Step 0 of annex 1-3 integration server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#'
#' @return loaded data and file type


importdcfstep0Server <- function(id,globaldata){
	moduleServer(id,
			function(input, output, session) {
				
				rls <- reactiveValues(res = list(),
						message = "",
						file_type = "")
				
				
				data <- reactiveValues(path_step0_dcf = NULL) 
				
				
				# TODO check if need to replace trycatch with smth else
				observeEvent(input$xlfile_dcf,
						shinyCatch({
									rls$file_type=""
									rls$res = list()
									rls$message = ""
									if (input$xlfile_dcf$name!="") {
										output$integrate <- renderText({input$xlfile_dcf$datapath})
									} else {
										output$integrate <- renderText({"no dataset seleted"})
									}
									output$dt_integrate_dcf <- renderDataTable(data.frame())
									output$"step0_message_xls_dcf"<-renderText("")
								}), ignoreInit = TRUE)
				
				###########################
				# step0_filepath_dcf 
				# this will add a path value to reactive data in step0
				###########################			
				step0_filepath_dcf <- reactive({
							inFile_dcf <- input$xlfile_dcf      
							if (is.null(inFile_dcf)){        return(NULL)
							} else {
								data$path_step0_dcf <- inFile_dcf$datapath #path to a temp file				
							}
						}) 			
				
				
				
				###########################
				# step0load_data_dcf (same for sampling info)
				###########################
				step0load_data_dcf<-function(){
					validate(need(globaldata$connectOK,"No connection"))
					isolate(step0_filepath_dcf())  #NOT USED
					isolate(if (is.null(data$path_step0_dcf)) return(NULL))
					

					message<-capture.output(res <- load_dcf(data$path_step0_dcf, 
									datasource = the_eel_datasource)
					
					)
					return(list(res=res,message=message))
				}
				# TODO adapt plotsampling_info to plotDCF
				plotsampling_info <- function(sampling_info){
					output$maps_dcf<- renderLeaflet({
								leaflet() %>% addTiles() %>%
										addMarkers(data=sampling_info,lat=~sai_y,lng=~sai_x,label=~sai_name) %>%
										addPolygons(data=data$ccm_light, 
												popup=~as.character(wso_id),
												fill=TRUE, 
												highlight = highlightOptions(color='white',
														weight=1,
														bringToFront = TRUE,
														fillColor="red",opacity=.2,
														fill=TRUE))%>%
										fitBounds(min(sampling_info$sai_x,na.rm=TRUE)-.1,
												min(sampling_info$sai_y,na.rm=TRUE)-.1,
												max(sampling_info$sai_x,na.rm=TRUE)+.1,
												max(sampling_info$sai_y,na.rm=TRUE)+.1)
								
							})
				}
				
				##################################################
				# Events triggerred by step0_button 
				###################################################
				observeEvent(input$dcf_check_file_button,{ 
						#browser()
						shinyCatch(
								{
									
									##################################################
									# clean up
									#################################################						
									ls <- step0load_data_dcf()
									rls$message <- ls$message
									file_type <- "DCF data"
									rls$file_type <- file_type
									rls$file_type <- NULL
									rls$res <- ls$res

									##################################################
									# integrate verbatimtextoutput
									# this will print the error messages to the console
									#################################################
									output$integrate_dcf<-renderText({
												validate(need(globaldata$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												if (is.null(data$path_step0_dcf)) "please select a dataset" else { 
													# tmp <- step0load_data_dcf() # result list
													# rls$message <- tmp$message
													# rls$res <- tmp$res
													# this will fill the log_datacall file (database_tools.R)
													if(length(unique(rls$res$sampling_info$sai_cou_code[!is.na(rls$res$sampling_info$sai_cou_code)]))>1) stop(paste("More than one country there :",
																		paste(unique(rls$res$sampling_info$sai_cou_code[!is.na(rls$res$sampling_info$sai_cou_code)]),collapse=";"), ": while there should be only one country code"))
													cou_code <- rls$res$sampling_info$sai_cou_code[1]
													if (nrow(rls$res$sampling_info)>0) plotsampling_info(rls$res$sampling_info)
													# the following three lines might look silly but passing input$something to the log_datacall function results
													# in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
													main_assessor <- input$main_assessor
													secondary_assessor <- input$secondary_assessor

													# this will fill the log_datacall file (database_tools.R)
													log_datacall( "check data sampling info",cou_code = cou_code, message = paste(rls$message,collapse="\n"), the_metadata = rls$res$the_metadata, file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor )
													paste(rls$message, collapse="\n")						
												}
												
											}) 
									##################################
									# Actively generates UI component on the ui side 
									# which displays text for xls download
									##################################
									
									output$"step0_message_xls_dcf"<-renderUI(
											HTML(
													paste(
															h4("sampling info file checking messages (xls)"),
															"<p align='left'>Please click on excel",'<br/>',
															"to download this file and correct the errors",'<br/>',
															"and submit again in <strong>step0</strong> the file once it's corrected<p>"
													)))  
									
									##################################
									# Actively generates UI component on the ui side
									# which generates text for txt
									################################## 									
									
									output$"step0_message_txt_dcf"<-renderUI(
											HTML(
													paste(
															h4("Sampling info file checking messages (txt)"),
															"<p align='left'>Please read carefully and ensure that you have",
															"checked all possible errors. This output is the same as the table",
															" output<p>"
													)))
									
									
									#####################
									# DataTable integration error (sampling info)
									########################
									
									output$dt_integrate_dcf <- DT::renderDataTable({
												validate(need(input$xlfile_dcf$name != "", "Please select a data set"))
												if(length(unique(rls$res$sampling_info$sai_cou_code[!is.na(rls$res$sampling_info$sai_cou_code)]))>1) stop(paste("More than one country there ",
																	paste(unique(rls$res$sampling_info$sai_cou_code[!is.na(rls$res$sampling_info$sai_cou_code)]),collapse=";"), ": while there should be only one country code"))
												cou_code <- rls$res$sampling_info$sai_cou_code[1]
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
																#order=list(1,"asc"),
																dom= "Blfrtip",
																buttons=list(
																		list(extend="excel",
																				filename = paste0("datadcf_",cou_code, Sys.Date())))
														)
												)
											})
								}								
								)}, ignoreInit = TRUE)
				
				
				
				return(rls)
			}
	
	)
}