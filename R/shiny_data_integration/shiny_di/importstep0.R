#' Step 0 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importstep0UI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			h2("Datacall Annex 4 to 8 integration and checks"),
			h2("step 0 : Data check"),
			fluidRow(
					column(width=4,fileInput(ns("xlfile"), "Choose xls File",
									multiple=FALSE,
									accept = c(".xls",".xlsx")
							)),
					column(width=4,  radioButtons(inputId=ns("file_type"), label="File type:",
									c(" Catch and Landings (Annex 4, 5 or 6)" = "catch_landings",
											"Release (Annex 7)" = "release" ,
											"Aquaculture  (Annex 8)" = "aquaculture",                                
											"Biomass indicators (Annex 10)" = "biomass",
											#"Habitat - wetted area"= "potential_available_habitat",
											#"Mortality silver equiv. Biom."="mortality_silver_equiv",
											"Mortality indicators (Annex 11)"="mortality_rates"					
									))),
					column(width=4, actionButton(ns("check_file_button"), "Check file") )                     
			),
			
			fluidRow(
					column(width=6,
							htmlOutput(ns("step0_message_txt")),
							verbatimTextOutput(ns("integrate")),placeholder=TRUE),
					column(width=6,
							htmlOutput(ns("step0_message_xls")),
							DT::dataTableOutput(ns("dt_integrate")))
			)             
	)
}




#' Step 0 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#'
#' @return loaded data and file type


importstep0Server <- function(id,globaldata){
	moduleServer(id,
			function(input, output, session) {
				
				
				
				
				
				rls <- reactiveValues(res = list(),
						message = "",
						file_type = "")
				data <- reactiveValues(path_step0 = NULL) 
				
				
				observeEvent(input$xlfile, shinyCatch({
									rls$file_type=""
									rls$message = ""
									rls$res=list()
									if (input$xlfile$name!="") {
										output$integrate<-renderText({input$xlfile$datapath})
									} else {
										output$integrate<-renderText({"no dataset seleted"})
									}
									output$dt_integrate<-renderDataTable(data.frame())
									output$"step0_message_xls"<-renderText("")
								}), ignoreInit = TRUE)
				
				
				
				step0_filepath <- reactive(shinyCatch({
									cat("debug message : step0_filepath")
									inFile <- input$xlfile      
									if (is.null(inFile)){        return(NULL)
									} else {
										data$path_step0<-inFile$datapath #path to a temp file
										if (grepl(c("catch"),tolower(inFile$name))) 
											updateRadioButtons(session, "file_type", selected = "catch_landings")
										if (grepl(c("release"),tolower(inFile$name)))
											updateRadioButtons(session, "file_type", selected = "release")
										if (grepl(c("aquaculture"),tolower(inFile$name)))
											updateRadioButtons(session, "file_type", selected = "aquaculture")
										if (grepl(c("biomass"),tolower(inFile$name))) 
											updateRadioButtons(session, "file_type", selected = "biomass")             
#										if (grepl(c("habitat"),tolower(inFile$name)))
#											updateRadioButtons(session, "file_type", selected = "potential_available_habitat")
#										if (grepl(c("silver"),tolower(inFile$name))) 
#											updateRadioButtons(session, "file_type", selected = "mortality_silver_equiv")      
										if (grepl(c("mortality"),tolower(inFile$name)))
											updateRadioButtons(session, "file_type", selected = "mortality_rates")
									}
								}, blocking_level="error")) 
				
				
				###########################
				# step0load_data reactive function 
				# This will run as a reactive function only if triggered by 
				# a button click (check) and will return res, a list with
				# both data and errors
				###########################
				step0load_data <- function(){          
					validate(need(globaldata$connectOK,"No connection"))
					path<- step0_filepath()   
					if (is.null(data$path_step0)) return(NULL)
					switch (input$file_type, "catch_landings"={                  
								message<-capture.output(res<-load_catch_landings(data$path_step0, 
												datasource = the_eel_datasource
										))},
							"release"={
								message<-capture.output(res<-load_release(data$path_step0, 
												datasource = the_eel_datasource ))},
							"aquaculture"={
								message<-capture.output(res<-load_aquaculture(data$path_step0, 
												datasource = the_eel_datasource ))},
							"biomass"={
								message<-capture.output(res<-load_biomass(data$path_step0, 
												datasource = the_eel_datasource ))},
#							"potential_available_habitat"={
#								message<-capture.output(res<-load_potential_available_habitat(data$path_step0, 
#												datasource = the_eel_datasource ))},
#							"mortality_silver_equiv"={
#								message<-capture.output(res<-load_mortality_silver(data$path_step0, 
#												datasource = the_eel_datasource ))},
							"mortality_rates"={
								message<-capture.output(res<-load_mortality_rates(data$path_step0, 
												datasource = the_eel_datasource ))}
					)
					#we forced the conversion into numeric to avoid problem with boolean column
					#if an error is thrown, it has been caught in the capture.output function
					res$data$eel_value=as.numeric(res$data$eel_value)
					return(list(res=res,message=message))
				}
				
				
				
				
				##################################################
				# Events triggerred by step0_button
				###################################################
				
				observeEvent(input$check_file_button, {
						#browser()
						shinyCatch({	
									
									
									##################################################
									# integrate verbatimtextoutput
									# this will print the error messages to the console
									#################################################
									validate(need(globaldata$connectOK,"No connection"))								
									ls <- step0load_data() # result list
									#preserve the reactiveness of rls
									rls$res <- ls$res
									rls$message <- ls$message
									validate(need(!is.null(data$path_step0), "Please select a data set"))
									cou_code <- rls$res$data$eel_cou_code[1]
									
									
									output$integrate<-renderText({
												#cat(data$path_step0)
												# call to  function that loads data
												# this function does not need to be reactive								
												main_assessor <- input$main_assessor
												secondary_assessor <- input$secondary_assessor
												file_type <- input$file_type
												rls$file_type <- file_type
												# this will fill the log_datacall file (database_tools.R)
												log_datacall( "check data",cou_code = cou_code, message = paste(rls$message,collapse="\n"),
												              file_type = file_type, main_assessor = globaldata$main_assessor, secondary_assessor = globaldata$secondary_assessor )
												paste(rls$message,collapse="\n")		
												
											}) 			
									
									##################################
									# Actively generates UI component on the ui side 
									# which displays text for xls download
									##################################
									
									output$"step0_message_xls"<-renderUI(
											HTML(
													paste(
															h4("File checking messages (xls)"),
															"<p align='left'>Please click on excel",'<br/>',
															"to download this file and correct the errors",'<br/>',
															"and submit again in <strong>step0</strong> the file once it's corrected<p>"
													)))  
									
									##################################
									# Actively generates UI component on the ui side
									# which generates text for txt
									##################################      
									
									output$"step0_message_txt"<-renderUI(
											HTML(
													paste(
															h4("File checking messages (txt)"),
															"<p align='left'>Please read carefully and ensure that you have",
															"checked all possible errors. This output is the same as the table",
															" output<p>"
													)))
									
									#####################
									# DataTable integration error
									########################
									
									output$dt_integrate<-DT::renderDataTable({                 
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
																lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																order=list(1,"asc"),
																dom= "Blfrtip", 
																buttons=list(
																		list(extend="excel",
																				filename = paste0("data_",Sys.Date()))) 
														)            
												)
											})									
								}						
						)
						remove_modal_spinner()	
						}
						, ignoreInit = TRUE) # end observeEvent
				
				return(rls)
				
			})}
