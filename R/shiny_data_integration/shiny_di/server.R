##############################################
# Server file for shiny data integration tool
##############################################

shinyServer(function(input, output, session){
			# this stops the app when the browser stops
			#session$onSessionEnded(stopApp)
			# A button that stops the application
#      observeEvent(input$close, {
#            js$closeWindow()
#            stopApp()
#          })
			##########################
# I. Datacall Integration and checks
			######################### 
			##########################
			# reactive values in data
			##########################
			
			output$passwordtest <- renderText({
						req(input$passwordbutton)
						load_database()
						var_database()
						if (data$connectOK) textoutput <- "Connected" 
						else textoutput <- paste0("password: ",isolate(input$password)," wrong")
						return(textoutput)
						
					})
			
			data<-reactiveValues(pool=NULL,connectOK=FALSE)
			
			load_database <- reactive({
						# take a dependency on passwordbutton
						req(input$passwordbutton)						
						port <- 5432
						host <- "localhost"#"192.168.0.100"
						userwgeel <-"wgeel"
						# we use isolate as we want no dependency on the value (only the button being clicked)
						passwordwgeel<-isolate(input$password)
						############################################
						# FIRST STEP INITIATE THE CONNECTION WITH THE DATABASE
						###############################################
						options(sqldf.RPostgreSQL.user = userwgeel,  
								sqldf.RPostgreSQL.password = passwordwgeel,
								sqldf.RPostgreSQL.dbname = "wgeel",
								sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
								sqldf.RPostgreSQL.port = port)
						
						# Define pool handler by pool on global level
						pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
								dbname="wgeel",
								host=host,
								port=port,
								user= userwgeel,
								password= passwordwgeel)
						data$pool <-pool
						data$connectOK <-dbGetInfo(data$pool)$valid
						
					})
			
			var_database <- reactive({
						req(input$passwordbutton)
						# untill the password has been entered don't do anything
						validate(need(data$connectOK,"No connection"))
						query <- "SELECT column_name
								FROM   information_schema.columns
								WHERE  table_name = 't_eelstock_eel'
								ORDER  BY ordinal_position"
						t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
						t_eelstock_eel_fields <<- t_eelstock_eel_fields$column_name
						
						query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
						list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						list_country <- list_countryt$cou_code
						names(list_country) <- list_countryt$cou_country
						list_country<<-list_country
						
						query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
						tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						typ_id <- tr_typeseries_typt$typ_id
						tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
						names(typ_id) <- tr_typeseries_typt$typ_name
						# tr_type_typ<-extract_ref('Type of series') this works also !
						tr_typeseries_typt<<-tr_typeseries_typt
						
						query <- "SELECT * from ref.tr_units_uni"
						tr_units_uni <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						
						
						query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel eel_cou "
						the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						
						query <- "SELECT name from datawg.participants"
						participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
						# save(participants,list_country,typ_id,the_years,t_eelstock_eel_fields, file=str_c(getwd(),"/common/data/init_data.Rdata"))
						
						ices_division <<- extract_ref("FAO area")$f_code
						
						emus <<- extract_ref("EMU")
						
						
					})
			###########################
			# step0_filepath
			# this will add a path value to reactive data in step0
			###########################
			step0_filepath <- reactive({
						cat("debug message : stetp0_filepath")
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
							if (grepl(c("biomass_indicator"),tolower(inFile$name))) 
								updateRadioButtons(session, "file_type", selected = "biomass")             
							if (grepl(c("habitat"),tolower(inFile$name)))
								updateRadioButtons(session, "file_type", selected = "potential_available_habitat")
							if (grepl(c("silver"),tolower(inFile$name))) 
								updateRadioButtons(session, "file_type", selected = "mortality_silver_equiv")      
							if (grepl(c("rate"),tolower(inFile$name)))
								updateRadioButtons(session, "file_type", selected = "mortality_rates")
						}
					}) 

			
			###########################
			# step0load_data reactive function 
			# This will run as a reactive function only if triggered by 
			# a button click (check) and will return res, a list with
			# both data and errors
			###########################
			step0load_data <- function(){
				validate(need(data$connectOK,"No connection"))
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
						"potential_available_habitat"={
							message<-capture.output(res<-load_potential_available_habitat(data$path_step0, 
											datasource = the_eel_datasource ))},
						"mortality_silver_equiv"={
							message<-capture.output(res<-load_mortality_silver(data$path_step0, 
											datasource = the_eel_datasource ))},
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
						
						cat(data$path_step0)
						##################################################
						# integrate verbatimtextoutput
						# this will print the error messages to the console
						#################################################
						output$integrate<-renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									if (is.null(data$path_step0)) "please select a dataset" else {          
										rls <- step0load_data() # result list
										stopifnot(length(unique(rls$res$data$eel_cou_code))==1)
										cou_code <- rls$res$data$eel_cou_code[1]
										# the following three lines might look silly but passing input$something to the log_datacall function results
										# in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- input$file_type
										# this will fill the log_datacall file (database_tools.R)
										log_datacall( "check data",cou_code = cou_code, message = paste(rls$message,collapse="\n"), the_metadata = rls$res$the_metadata, file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor )
										paste(rls$message,collapse="\n")
										
									}
									
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
												validate(need(input$xlfile != "", "Please select a data set"))           
												ls <- step0load_data()   
												country <- ls$res$series
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
																lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																order=list(1,"asc"),
																dom= "Blfrtip", 
																buttons=list(
																		list(extend="excel",
																				filename = paste0("data_",Sys.Date()))) 
														)            
												)
											})
								})
								
								
						##################################################
						# Events triggerred by step1_button
						###################################################      
						##########################
						# When check_duplicate_button is clicked
						# this will render a datatable containing rows
						# with duplicates values
						#############################
						observeEvent(input$check_duplicate_button, { 
									
									
									# see step0load_data returns a list with res and messages
									# and within res data and a dataframe of errors
									validate(
											need(input$xlfile != "", "Please select a data set")
									) 
									data_from_excel<- step0load_data()$res$data
									switch (input$file_type, "catch_landings"={                                     
												data_from_base<-extract_data("landings", quality=c(1,2,3,4), quality_check=TRUE)
												updated_from_excel<- step0load_data()$res$updated_data
											},
											"release"={
												data_from_base<-extract_data("release", quality=c(1,2,3,4), quality_check=TRUE)
												updated_from_excel<- step0load_data()$res$updated_data
											},
											"aquaculture"={             
												data_from_base<-extract_data("aquaculture", quality=c(1,2,3,4), quality_check=TRUE)},
											"biomass"={
												# bug in excel file
												colnames(data_from_excel)[colnames(data_from_excel)=="typ_name"]<-"eel_typ_name"
												data_from_base<-rbind(
														extract_data("b0", quality=c(1,2,3,4), quality_check=TRUE),
														extract_data("bbest", quality=c(1,2,3,4), quality_check=TRUE),
														extract_data("bcurrent", quality=c(1,2,3,4), quality_check=TRUE))
											},
											"potential_available_habitat"={
												data_from_base<-extract_data("potential_available_habitat", quality=c(1,2,3,4), quality_check=TRUE)                  
											},
											# mortality in silver eel equivalent
											"silver_eel_equivalents"={
												data_from_base<-extract_data("silver_eel_equivalents", quality=c(1,2,3,4), quality_check=TRUE)      
												
											},
											"mortality_rates"={
												data_from_base<-rbind(
														extract_data("sigmaa", quality=c(1,2,3,4), quality_check=TRUE),
														extract_data("sigmafallcat", quality=c(1,2,3,4), quality_check=TRUE),
														extract_data("sigmahallcat", quality=c(1,2,3,4), quality_check=TRUE))
											}                
									)
									# the compare_with_database function will compare
									# what is in the database and the content of the excel file
									# previously loaded. It will return a list with two components
									# the first duplicates contains elements to be returned to the use
									# the second new contains a dataframe to be inserted straight into
									# the database
									#cat("step0")
									if (nrow(data_from_excel)>0){
									  ###TEMPORARY FIX 2020 due to incorrect typ_name
									  data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")] <- paste(data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")],"_kg",sep="")
									      
										list_comp<-compare_with_database(data_from_excel,data_from_base)
										duplicates <- list_comp$duplicates
										new <- list_comp$new 
										current_cou_code <- list_comp$current_cou_code
										#cat("step1")
										#####################      
										# Duplicates values
										#####################
										
										if (nrow(duplicates)==0) {
											output$"step1_message_duplicates"<-renderUI(
													HTML(
															paste(
																	h4("No duplicates")                             
															)))                 
										}else{      
											output$"step1_message_duplicates"<-renderUI(
													HTML(
															paste(
																	h4("Table of duplicates (xls)"),
																	"<p align='left'>Please click on excel",
																	"to download this file. In <strong>keep new value</strong> choose true",
																	"to replace data using the new datacall data (true)",
																	"if new is selected don't forget to qualify your data in column <strong> eel_qal_id.xls, eel_qal_comment.xls </strong>",
																	"once this is done download the file and proceed to next step.",
																	"Rows with false will be ignored and kept as such in the database",
																	"Rows with true will use the column labelled .xls for the new insertion, and flag existing values as removed ",
																	"If you see an error in old data, use panel datacorrection (on top of the application), this will allow you to make changes directly in the database <p>"                         
															)))  
										}
										
										# table of number of duplicates values per year (hilaire)
										
										years=sort(unique(c(duplicates$eel_year,new$eel_year)))
										
										output$dt_duplicates <-DT::renderDataTable({
													validate(need(data$connectOK,"No connection"))
													datatable(duplicates,
															rownames=FALSE,                                                    
															extensions = "Buttons",
															option=list(
																	rownames = FALSE,
																	scroller = TRUE,
																	scrollX = TRUE,
																	scrollY = "500px",
																	order=list(3,"asc"),
																	lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																	"pagelength"=-1,
																	dom= "Blfrtip",
																	buttons=list(
																			list(extend="excel",
																					filename = paste0("duplicates_",input$file_type,"_",Sys.Date(),current_cou_code))) 
															))
													
												})
										
										if (nrow(new)==0) {
											output$"step1_message_new"<-renderUI(
													HTML(
															paste(
																	h4("No new values")                             
															)))                    
										} else {
											output$"step1_message_new"<-renderUI(
													HTML(
															paste(
																	h4("Table of new values (xls)"),
																	"<p align='left'>Please click on excel ",
																	"to download this file and qualify your data with columns <strong>qal_id, qal_comment</strong> ",
																	"once this is done download the file with button <strong>download new</strong> and proceed to next step.<p>"                         
															)))  
											
										}
										
										output$dt_new <-DT::renderDataTable({ 
													validate(need(data$connectOK,"No connection"))
													datatable(new,
															rownames=FALSE,          
															extensions = "Buttons",
															option=list(
																	scroller = TRUE,
																	scrollX = TRUE,
																	scrollY = "500px",
																	order=list(3,"asc"),
																	lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																	"pagelength"=-1,
																	dom= "Blfrtip",
																	scrollX = T, 
																	buttons=list(
																			list(extend="excel",
																					filename = paste0("new_",input$file_type,"_",Sys.Date(),current_cou_code))) 
															))
												})
										######
										#Missing data
										######
										if (input$file_type == "catch_landings" & nrow(list_comp$complete)>0) {
											output$dt_missing <- DT::renderDataTable({
														validate(need(data$connectOK,"No connection"))
														check_missing_data(list_comp$complete, new)
													})
										}
										
										
									} # closes if nrow(...  
									if (input$file_type %in% c("catch_landings","release")){
									  if (nrow(updated_from_excel)>0){
									    data$updated_values_table <- compare_with_database_updated_values(updated_from_excel,data_from_base) 
									    output$dt_updated_values <- DT::renderDataTable({
									      data$updated_values_table
									    },option=list(
									      rownames = FALSE,
									      scroller = TRUE,
									      scrollX = TRUE,
									      scrollY = TRUE))
									  }
									}
								  if (input$file_type %in% c("catch_landings","release")){
									  summary_check_duplicates=data.frame(years=years,
									    nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
									    nb_duplicates_updated=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
									    nb_duplicates_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))),
                      nb_updated_values=sapply(years, function(y) length(which(updated_from_excel$eel_year==y))))
								  } else {
								    summary_check_duplicates=data.frame(years=years,
                        nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
                        nb_duplicates_updated=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
                        nb_duplicates_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))))
								  }
									
									output$dt_check_duplicates <-DT::renderDataTable({ 
									  validate(need(data$connectOK,"No connection"))
									  datatable(summary_check_duplicates,
									            rownames=FALSE,                                                    
									            options=list(dom="t"
									            ))
									})
									#data$new <- new # new is stored in the reactive dataset to be inserted later.      
								})
						
						
						##########################
						# STEP 2.1
						# When database_duplicates_button is clicked
						# this will trigger the data integration
						#############################         
						# this step only starts if step1 has been launched    
						observeEvent(input$database_duplicates_button, { 
									
									###########################
									# step2_filepath
									# reactive function, when clicked return value in reactive data 
									###########################
									step21_filepath <- reactive({
												inFile <- isolate(input$xl_duplicates_file)      
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step21<-inFile$datapath #path to a temp file             
												}
											})
									###########################
									# step21load_data
									#  function, returns a message
									#  indicating that data integration was a succes
									#  or an error message
									###########################
									step21load_data <- function() {
										path <- step21_filepath()
										if (is.null(data$path_step21)) 
											return(NULL)
										# this will alter changed values (change qal_id code) and insert new rows
										rls <- write_duplicates(path, qualify_code = qualify_code)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- input$file_type
										log_datacall("check duplicates", cou_code = cou_code, message = sQuote(message), the_metadata = NULL, 
												file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor)
										
										return(message)
									}
									###########################
									# errors_duplicates_integration
									# this will add a path value to reactive data in step0
									###########################            
									output$textoutput_step2.1<-renderText({
												validate(need(data$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive                  
												message<-step21load_data()                     
												if (is.null(data$path_step21)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})              
								}) 
						##########################
						# STEP 2.2
						# When database_new_button is clicked
						# this will trigger the data integration
						#############################      
						observeEvent(input$database_new_button, {
									
									###########################
									# step2_filepath
									# reactive function, when clicked return value in reactive data 
									###########################
									step22_filepath <- reactive({
												inFile <- isolate(input$xl_new_file)     
												if (is.null(inFile)){        return(NULL)
												} else {
													data$path_step22<-inFile$datapath #path to a temp file             
												}
											})
									###########################
									# step22load_data
									#  function, returns a message
									#  indicating that data integration was a succes
									#  or an error message
									###########################
									step22load_data <- function() {
										path <- step22_filepath()
										if (is.null(data$path_step22)) 
											return(NULL)
										rls <- write_new(path)
										message <- rls$message
										cou_code <- rls$cou_code
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- input$file_type
										log_datacall("new data integration", cou_code = cou_code, message = sQuote(message), 
												the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
												secondary_assessor = secondary_assessor)
										return(message)
									}
									###########################
									# new_data_integration
									# this will add a path value to reactive data in step0
									###########################            
									output$textoutput_step2.2<-renderText({
												validate(need(data$connectOK,"No connection"))
												# call to  function that loads data
												# this function does not need to be reactive
												message<-step22load_data()
												if (is.null(data$path_step22)) "please select a dataset" else {                                      
													paste(message,collapse="\n")
												}                  
											})  
								})
			
            		##########################
            		# STEP 2.3
            		# Integration of updated_values when proceed is clicked
            		# 
            		#############################
          			observeEvent(input$database_updated_value_button, {
          			  validate(need(data$updated_values_table,"need data to be updated"))
          			  
          			  ###########################
          			  # step23load_updated_value_data
          			  #  function, returns a message
          			  #  indicating that data integration was a succes
          			  #  or an error message
          			  ###########################
          			  step23load_updated_value_data <- function() {
          			    rls <- write_updated_values(data$updated_values_table,qualify_code=qualify_code)
          			    message <- rls$message
          			    cou_code <- rls$cou_code
          			    main_assessor <- input$main_assessor
          			    secondary_assessor <- input$secondary_assessor
          			    file_type <- input$file_type
          			    log_datacall("updated values data integration", cou_code = cou_code, message = sQuote(message), 
          			                 the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
          			                 secondary_assessor = secondary_assessor)
          			    return(message)
          			  }
          			  ###########################
          			  # updated_values_integration
          			  # this will add a path value to reactive data in step0
          			  ###########################            
          			  output$textoutput_step2.3<-renderText({
          			    validate(need(data$connectOK,"No connection"))
          			    # call to  function that loads data
          			    # this function does not need to be reactive
          			    message<-step23load_updated_value_data()
          			    paste(message,collapse="\n")
          			  })  
          			})
			#######################################
			# II. Time series data
			#######################################		
			
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
			  validate(need(data$connectOK,"No connection"))
			  path<- step0_filepath_ts()   
			  if (is.null(data$path_step0_ts)) return(NULL)
			  
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
			
			##################################################
			# Events triggerred by step0_button (time series page)
			###################################################
			observeEvent(input$ts_check_file_button, {
			  
			  ##################################################
			  # integrate verbatimtextoutput
			  # this will print the error messages to the console
			  #################################################
			  output$integrate_ts<-renderText({
			    validate(need(data$connectOK,"No connection"))
			    # call to  function that loads data
			    # this function does not need to be reactive
			    if (is.null(data$path_step0_ts)) "please select a dataset" else {          
			      rls <- step0load_data_ts() # result list
			      # this will fill the log_datacall file (database_tools.R)
			      stopifnot(length(unique(rls$res$series$ser_cou_code))==1)
			      cou_code <- rls$res$series$ser_cou_code[1]
			      # the following three lines might look silly but passing input$something to the log_datacall function results
			      # in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
			      main_assessor <- input$main_assessor
			      secondary_assessor <- input$secondary_assessor
			      file_type <- input$file_type
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
			    validate(need(input$xlfile_ts != "", "Please select a data set"))
			    ls <- step0load_data_ts()
			    stopifnot(length(unique(ls$res$series$ser_cou_code))==1)
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
			                lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
			                order=list(1,"asc"),
			                dom= "Blfrtip",
			                buttons=list(
			                  list(extend="excel",
			                       filename = paste0("datats_",cou_code, Sys.Date())))
			              )
			    )
			  })
		})
			
		##################################################
		# Events triggered by step1_button TIME SERIES
		###################################################      
		##########################
		# When check_duplicate_button is clicked
		# this will render a datatable containing rows
		# with duplicates values
		#############################
		observeEvent(input$check_duplicate_button_ts, { 
					
					
					# see step0load_data returns a list with res and messages
					# and within res data and a dataframe of errors
					validate(
							need(input$xlfile_ts != "", "Please select a data set")
					)
					res <- step0load_data_ts()$res
					series <- res$series
					station	<- res$station
					new_data	<- res$new_data
					updated_data	<- res$updated_data
					new_biometry <- res$new_biometry
					updated_biometry <- res$updated_biometry

					suppressWarnings(t_series_ser <- extract_data("t_series_ser",  quality_check=FALSE)) 
					t_dataseries_das <- extract_data("t_dataseries_das", quality_check=FALSE)  
					t_biometry_series_bis <- extract_data("t_biometry_series_bis", quality_check=FALSE)
					
					switch (input$file_type, 
							"glass_eel"={                                     
								t_series_ser <- t_series_ser %>%  filter(ser_typ_id==1)    
								t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
							},
							"yellow_eel"={
								t_series_ser <- t_series_ser %>%  filter(ser_typ_id==2)    
								t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
							},
							"silver_eel"={             
								t_series_ser <- t_series_ser %>%  filter(ser_typ_id==3)    
								t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
							}                
					)
					# the compare_with_database function will compare
					# what is in the database and the content of the excel file
					# previously loaded. It will return a list with two components
					# the first duplicates contains elements to be returned to the use
					# the second new contains a dataframe to be inserted straight into
					# the database
					#cat("step0")
					if (nrow(data_from_excel)>0){
						list_comp<-compare_with_database(data_from_excel,data_from_base)
						duplicates <- list_comp$duplicates
						new <- list_comp$new 
						current_cou_code <- list_comp$current_cou_code
						#cat("step1")
						#####################      
						# Duplicates values
						#####################
						
						if (nrow(duplicates)==0) {
							output$"step1_message_duplicates"<-renderUI(
									HTML(
											paste(
													h4("No duplicates")                             
											)))                 
						}else{      
							output$"step1_message_duplicates"<-renderUI(
									HTML(
											paste(
													h4("Table of duplicates (xls)"),
													"<p align='left'>Please click on excel",
													"to download this file. In <strong>keep new value</strong> choose true",
													"to replace data using the new datacall data (true)",
													"if new is selected don't forget to qualify your data in column <strong> eel_qal_id.xls, eel_qal_comment.xls </strong>",
													"once this is done download the file and proceed to next step.",
													"Rows with false will be ignored and kept as such in the database",
													"Rows with true will use the column labelled .xls for the new insertion, and flag existing values as removed ",
													"If you see an error in old data, use panel datacorrection (on top of the application), this will allow you to make changes directly in the database <p>"                         
											)))  
						}
						
						# table of number of duplicates values per year (hilaire)
						
						years=sort(unique(c(duplicates$eel_year,new$eel_year)))
						
						summary_check_duplicates=data.frame(years=years,
								nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
								nb_updated_duplicates=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
								nb_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))))
						
						output$dt_check_duplicates <-DT::renderDataTable({ 
									validate(need(data$connectOK,"No connection"))
									datatable(summary_check_duplicates,
											rownames=FALSE,                                                    
											options=list(dom="t"
											),
											scroller = TRUE,
											scrollX = TRUE,
											scrollY = TRUE)
								})
						output$dt_duplicates <-DT::renderDataTable({
									validate(need(data$connectOK,"No connection"))
									datatable(duplicates,
											rownames=FALSE,                                                    
											extensions = "Buttons",
											option=list(
													rownames = FALSE,
													scroller = TRUE,
													scrollX = TRUE,
													scrollY = "500px",
													order=list(3,"asc"),
													lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
													"pagelength"=-1,
													dom= "Blfrtip",
													buttons=list(
															list(extend="excel",
																	filename = paste0("duplicates_",input$file_type,"_",Sys.Date(),current_cou_code))) 
											))
									
								})
						
						if (nrow(new)==0) {
							output$"step1_message_new"<-renderUI(
									HTML(
											paste(
													h4("No new values")                             
											)))                    
						} else {
							output$"step1_message_new"<-renderUI(
									HTML(
											paste(
													h4("Table of new values (xls)"),
													"<p align='left'>Please click on excel ",
													"to download this file and qualify your data with columns <strong>qal_id, qal_comment</strong> ",
													"once this is done download the file with button <strong>download new</strong> and proceed to next step.<p>"                         
											)))  
							
						}
						
						output$dt_new <-DT::renderDataTable({ 
									validate(need(data$connectOK,"No connection"))
									datatable(new,
											rownames=FALSE,          
											extensions = "Buttons",
											option=list(
													scroller = TRUE,
													scrollX = TRUE,
													scrollY = "500px",
													order=list(3,"asc"),
													lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
													"pagelength"=-1,
													dom= "Blfrtip",
													scrollX = T, 
													buttons=list(
															list(extend="excel",
																	filename = paste0("new_",input$file_type,"_",Sys.Date(),current_cou_code))) 
											))
								})
						######
						#Missing data
						######
						if (input$file_type == "catch_landings" & nrow(list_comp$complete)>0) {
							output$dt_missing <- DT::renderDataTable({
										validate(need(data$connectOK,"No connection"))
										check_missing_data(list_comp$complete, new)
									})
						}
						
						
					} # closes if nrow(...      
					#data$new <- new # new is stored in the reactive dataset to be inserted later.      
				})
		
			
						#######################################
						# III. Data correction table  
						# This section provides a direct interaction with the database
						# Currently only developped for modifying data.
						# Deletion must be done by changing data code or asking Database handler
						#######################################
						rvs <- reactiveValues(
								data = NA, 
								dbdata = NA,
								dataSame = TRUE,
								editedInfo = NA
						
						)
						
						#-----------------------------------------  
						# Generate source via reactive expression
						
						mysource <- reactive({
									req(input$passwordbutton)
									validate(need(data$connectOK,"No connection"))
									vals = input$country
									if (is.null(vals)) 
										vals <- c("FR")
									types = input$typ
									if (is.null(types)) 
										types <- c(4, 5, 6, 7)
									the_years <- input$year
									if (is.null(input$year)) {
										the_years <- c(the_years$min_year, the_years$max_year)
									}
									# glue_sql to protect against injection, used with a vector with *
									query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
											vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
											.con = pool)
									# https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
									# it seems that dbgetquery doesn't raise an error
									out_data <- dbGetQuery(pool, query)
									return(out_data)
									
								})
						
						# Observe the source, update reactive values accordingly
						
						observeEvent(mysource(), {               
									data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
									rvs$data <- data
									rvs$dbdata <- data
									disable("clear_table")                
								})
						
						#-----------------------------------------
						# Render DT table 
						# 
						# selection better be none
						# editable must be TRUE
						#
						output$table_cor <- DT::renderDataTable({
									validate(need(data$connectOK,"No connection"))
									DT::datatable(
											rvs$dbdata, 
											rownames = FALSE,
											extensions = "Buttons",
											editable = TRUE, 
											selection = 'none',
											options=list(
													order=list(3,"asc"),              
													searching = TRUE,
													rownames = FALSE,
													scroller = TRUE,
													scrollX = TRUE,
													scrollY = "500px",
													lengthMenu=list(c(-1,5,20,50,100),c("All","5","20","50","100")),
													dom= "Blfrtip", #button fr search, t table, i information (showing..), p pagination
													buttons=list(
															list(extend="excel",
																	filename = paste0("data_",Sys.Date())))
											))})
						#-----------------------------------------
						# Create a DT proxy to manipulate data
						# 
						#
						proxy_table_cor = dataTableProxy('table_cor')
						#--------------------------------------
						# Edit table data
						# Expamples at
						# https://yihui.shinyapps.io/DT-edit/
						observeEvent(input$table_cor_cell_edit, {
									
									info = input$table_cor_cell_edit
									
									i = info$row
									j = info$col = info$col + 1  # column index offset by 1
									v = info$value
									
									rvs$data[i, j] <<- DT::coerceValue(v, rvs$data[i, j])
									replaceData(proxy_table_cor, rvs$data, resetPaging = FALSE, rownames = FALSE)
									# datasame is set to TRUE when save or update buttons are clicked
									# here if it is different it might be set to FALSE
									rvs$dataSame <- identical(rvs$data, rvs$dbdata)
									# this will collate all editions (coming from datatable observer in a data.frame
									# and store it in the reactive dataset rvs$editedInfo
									if (all(is.na(rvs$editedInfo))) {
										
										rvs$editedInfo <- data.frame(info)
									} else {
										rvs$editedInfo <- dplyr::bind_rows(rvs$editedInfo, data.frame(info))
									}
									
								})
						
						# Update edited values in db once save is clicked---------------------------------------------
						
						observeEvent(input$save, {
									errors<-update_t_eelstock_eel(editedValue = rvs$editedInfo, pool = pool, data=rvs$data)
									if (length(errors)>0) {
										output$database_errors<-renderText({iconv(unlist(errors,"UTF8"))})
										enable("clear_table")
									} else {
										output$database_errors<-renderText({"Database updated"})
									}
									rvs$dbdata <- rvs$data
									rvs$dataSame <- TRUE
								})
						
						# Observe clear_table button -> revert to database table---------------------------------------
						
						observeEvent(input$clear_table,
								{
									data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
									rvs$data <- data
									rvs$dbdata <- data
									disable("clear_table")
									output$database_errors<-renderText({""})
								})
						
						# Oberve cancel -> revert to last saved version -----------------------------------------------
						
						observeEvent(input$cancel, {
									rvs$data <- rvs$dbdata
									rvs$dataSame <- TRUE
								})
						
						# UI buttons ----------------------------------------------------------------------------------
						# Appear only when data changed
						
						output$buttons_data_correction <- renderUI({
									div(
											if (! rvs$dataSame) {
														span(
																actionBttn(inputId = "save", label = "Save",
																		style = "material-flat", color = "danger"),
																actionButton(inputId = "cancel", label = "Cancel")
														)
													} else {
														span()
													}
									)
								})
						#################################################
						# GRAPHS ----------------------------------------
						#################################################
						
						# Same as mysource but for graphs, different page, so different buttons
						# there must be a way by reorganizing the buttons to do a better job
						# but buttons don't apply to the data integration sheet and here we don't
						# want multiple choices (to check for duplicates we need to narrow down the search) ....
						
						mysource_graph <- reactive(					
								{
									req(input$passwordbutton)
									validate(need(data$connectOK,"No connection"))
									validate(need(!is.null(pool), "Waiting for database connection"))
									vals = input$country_g
									if (is.null(vals)) 
										vals <- c("FR")
									types = input$typ_g
									if (is.null(types)) 
										types <- c(4, 5, 6, 7)
									the_years <- input$year_g
									if (is.null(input$year)) {
										the_years <- c(the_years$min_year, the_years$max_year)
									}
									# glue_sql to protect against injection, used with a vector with *
									query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
											vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
											.con = pool)
									# https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
									# it seems that dbgetquery doesn't raise an error
									out_data <- dbGetQuery(pool, query)
									return(out_data)
									
								})
						
						# store data in reactive values ---------------------------------------------------------------
						
						observeEvent(mysource_graph(), {               
									data <- mysource_graph() %>% arrange(eel_emu_nameshort,eel_year)
									rvs$datagr <- data                           
								})
						
						# plot -------------------------------------------------------------------------------------------
						# the plots groups by kept (typ id = 1,2,4) or not (other typ_id) and year 
						# and calculate thenumber of values 
						
						output$duplicated_ggplot <- renderPlot({
									validate(need(data$connectOK,"No connection"))
									if (is.null(rvs$datagr)) return(NULL)
									# duplicated_values_graph performs a group by, see graph.R inside the shiny data integration
									# tab
									duplicated_values_graph(rvs$datagr)
								}
						)
						
						# the observeEvent will not execute untill the user clicks, here it runs
						# both the plotly and datatable component -----------------------------------------------------
						
						observeEvent(input$duplicated_ggplot_click,  {
									# the nearpoint function does not work straight with bar plots
									# we have to retreive the x data and check the year it corresponds to ... 
									year_selected = round(input$duplicated_ggplot_click$x)  
									datagr <- rvs$datagr
									datagr <- datagr[datagr$eel_year==year_selected, ] 
									
									# Data table for individual data corresponding to the year bar on the graph -------------
									
									output$datatablenearpoints <- DT::renderDataTable({            
												datatable(datagr,
														rownames = FALSE,
														extensions = 'Buttons',
														options=list(
																order=list(3,"asc"),    
																lengthMenu=list(c(-1,5,10,30),c("All","5","10","30")),                           
																searching = FALSE,                          
																scroller = TRUE,
																scrollX = TRUE,                         
																dom= "Blfrtip", # l length changing,  
																buttons=list('copy',I('colvis')) 
														)
												)
											})        
									
									# Plotly output allowing to brush out individual values per EMU
									x <- sample(c(1:5, NA, NA, NA))
									coalesce(x, 0L)
									output$plotly_selected_year <-renderPlotly({  
												coalesce 
												datagr$hl <- as.factor(str_c(datagr$eel_lfs_code, coalesce(datagr$eel_hty_code,"no"),collapse= "&"))   
												p <-plot_ly(datagr, x = ~eel_emu_nameshort, y = ~eel_value,
														# Hover text:
														text = ~paste("Lifestage: ", eel_lfs_code, 
																'$<br> Hty_code:', eel_hty_code,
																'$<br> Area_division:', eel_area_division,
																'$<br> Source:', eel_datasource,
																'$<br> Value:', eel_value),
														color = ~ eel_lfs_code,
														split = ~eel_hty_code)  
												p$elementId <- NULL # a hack to remove warning : ignoring explicitly provided widget
												p           
											}) 
									
								}, ignoreNULL = TRUE) # additional arguments to observe ...
						
						
						
						
						
					})
