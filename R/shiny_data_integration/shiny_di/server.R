##############################################
# Server file for shiny data integration tool
##############################################

shinyServer(function(input, output, session){
			# this stops the app when the browsser stops
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
						textoutput <- tryCatch({
									load_database()
									var_database()
									textoutput <- "Connected" 
					},error = function(e) {
						textoutput <- paste("password:",input$password,"wrong")
					})				
						return(textoutput)
						
					})
			
			data<-reactiveValues(pool=NULL,connectOK=FALSE,
			                     ser_list = NULL,
			                     ccm_light = ccm_light,
			                     typ_id = typ_id,
			                     list_country = NULL)
			
			observeEvent(input$xlfile,tryCatch({
						if (input$xlfile!="") {
							output$integrate<-renderText({input$xlfile$datapath})
						} else {
							output$integrate<-renderText({"no dataset seleted"})
						}
						output$dt_integrate<-renderDataTable(data.frame())
						output$dt_duplicates<-renderDataTable(data.frame())
						output$dt_check_duplicates<-renderDataTable(data.frame())
						output$dt_new<-renderDataTable(data.frame())
						output$dt_missing<-renderDataTable(data.frame())
						output$dt_updated_values <- renderDataTable(data.frame())
						output$textoutput_step2.1 <- renderText("")				
						output$textoutput_step2.2 <- renderText("")
						output$textoutput_step2.3 <- renderText("")
						output$integrate <- renderText("")
						if ("updated_values_table" %in% names(data)) {
							data$updated_values_table<-data.frame()
						}
						reset("xl_new_file")
						reset("xl_duplicates_file")
					
						
						output$"textoutput_step2.1" <- renderText("")
						output$"textoutput_step2.2" <- renderText("")
						output$"textoutput_step2.3" <- renderText("")

						
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			load_database <- reactive(shinyCatch({
						# take a dependency on passwordbutton
						req(input$passwordbutton)						
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
						pool <<- pool::dbPool(drv = RPostgres::Postgres(),
								dbname="wgeel",
								host=host,
								port=port,
								user= userwgeel,
								password= passwordwgeel,
								bigint="integer")
						data$pool <-pool
						data$connectOK <-dbGetInfo(data$pool)$valid
						
					}, blocking_level="error"))
			
			var_database <- reactive(shinyCatch({
						req(input$passwordbutton)
						# untill the password has been entered don't do anything
						validate(need(data$connectOK,"No connection"))
						query <- "SELECT column_name
								FROM   information_schema.columns
								WHERE  table_name = 't_eelstock_eel'
								ORDER  BY ordinal_position"
						t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
						t_eelstock_eel_fields <<- t_eelstock_eel_fields$column_name
						
						query <- "SELECT column_name
								FROM   information_schema.columns
								WHERE  table_name = 't_dataseries_das'
								ORDER  BY ordinal_position"
						t_dataseries_das_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
						t_dataseries_das_fields <<- t_dataseries_das_fields$column_name
						
						query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
						list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						list_country <- list_countryt$cou_code
						names(list_country) <- list_countryt$cou_country
						data$list_country<- list_country
						list_country<<-list_country
						
						query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
						tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						typ_id <- tr_typeseries_typt$typ_id
						query <- "SELECT distinct ser_nameshort from datawg.t_series_ser"
						tr_series_list <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						isolate({data$ser_list <- tr_series_list$ser_nameshort})
						tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
						names(typ_id) <- tr_typeseries_typt$typ_name
						data$typ_id <- typ_id
						# tr_type_typ<-extract_ref('Type of series') this works also !
						tr_typeseries_typt<<-tr_typeseries_typt
						
						query <- "SELECT * from ref.tr_units_uni"
						tr_units_uni <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						
						
						query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel"
						the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						updateSliderTextInput(session,"yearAll",
						                      choices=seq(the_years$min_year, the_years$max_year),
						                      selected = c(the_years$min_year,the_years$max_year))
						
						query <- "SELECT name from datawg.participants order by name asc"
						participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
						
						ices_division <<- suppressWarnings(extract_ref("FAO area")$f_code)
# TODO CEDRIC 2021 remove geom from extract_ref function so as not to get a warning						
						emus <<- suppressWarnings(extract_ref("EMU"))
# TODO CEDRIC 2021 remove geom from extract_ref function so as not to get a warning						
						
						updatePickerInput(
								session = session, inputId = "main_assessor",
								choices = participants,
								selected =NULL
						)
						
						updatePickerInput(
								session = session, inputId = "secondary_assessor",
								choices = participants,
								selected = "Cedric Briand"
						)
						
					}, blocking_level="error"))
			###########################
			# step0_filepath
			# this will add a path value to reactive data in step0
			###########################
			step0_filepath <- reactive(shinyCatch({
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
					}, blocking_level="error")) 
			
			
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
			
			observeEvent(input$check_file_button, tryCatch({
						
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
										#validate(need(length(unique(rls$res$data$eel_cou_code))==1,paste("There are more than one country",paste(unique(rls$res$data$eel_cou_code),collapse=";"))))
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
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			
			##################################################
			# Events triggerred by step1_button
			###################################################      
			##########################
			# When check_duplicate_button is clicked
			# this will render a datatable containing rows
			# with duplicates values
			#############################
			observeEvent(input$check_duplicate_button, tryCatch({ 

						# see step0load_data returns a list with res and messages
						# and within res data and a dataframe of errors
						validate(
								need(input$xlfile != "", "Please select a data set")
						) 
						data_from_excel<- step0load_data()$res$data
						switch (input$file_type, "catch_landings"={                                     
									data_from_base<-extract_data("landings", quality=c(0,1,2,3,4), quality_check=TRUE)
									updated_from_excel<- step0load_data()$res$updated_data
								},
								"release"={
									data_from_base<-extract_data("release", quality=c(0,1,2,3,4), quality_check=TRUE)
									updated_from_excel<- step0load_data()$res$updated_data
								},
								"aquaculture"={             
									data_from_base<-extract_data("aquaculture", quality=c(0,1,2,3,4), quality_check=TRUE)},
								"biomass"={
									# bug in excel file - fixed in the template
									#colnames(data_from_excel)[colnames(data_from_excel)=="typ_name"]<-"eel_typ_name"
									data_from_excel$eel_lfs_code <- 'S' #always S
									data_from_excel$eel_hty_code <- 'AL' #always AL
									data_from_excel <- data_from_excel %>% 
									  rename_with(function(x) tolower(gsub("biom_", "", x)),
									              starts_with("biom_")) %>%
									  mutate_at(vars(starts_with("perc_")), function(x) as.numeric(ifelse(x=='NP','-1',x)))
									data_from_excel$eel_area_division <- as.vector(rep(NA,nrow(data_from_excel)),"character")
									data_from_base<-rbind(
											extract_data("b0", quality=c(0,1,2,3,4), quality_check=TRUE),
											extract_data("bbest", quality=c(0,1,2,3,4), quality_check=TRUE),
											extract_data("bcurrent", quality=c(0,1,2,3,4), quality_check=TRUE)) 
									data_from_base <- data_from_base %>% 
									  rename_with(function(x) tolower(gsub("biom_", "", x)),
									              starts_with("biom_"))
								},
								"potential_available_habitat"={
									data_from_base<-extract_data("potential_available_habitat", quality=c(0,1,2,3,4), quality_check=TRUE)                  
								},
								# mortality in silver eel equivalent
								"silver_eel_equivalents"={
									data_from_base<-extract_data("silver_eel_equivalents", quality=c(0,1,2,3,4), quality_check=TRUE)      
									
								},
								"mortality_rates"={
								  data_from_excel$eel_lfs_code <- 'S' #always S
								  data_from_excel$eel_hty_code <- 'AL' #always AL
								  data_from_excel <- data_from_excel %>% 
								    rename_with(function(x) tolower(gsub("mort_", "", x)),
								                starts_with("mort_")) %>%
								    mutate_at(vars(starts_with("perc_")), function(x) as.numeric(ifelse(x=='NP','-1',x)))
								  data_from_excel$eel_area_division <- as.vector(rep(NA,nrow(data_from_excel)),"character")
								  data_from_base<-rbind(
											extract_data("sigmaa", quality=c(0,1,2,3,4), quality_check=TRUE),
											extract_data("sigmaf", quality=c(0,1,2,3,4), quality_check=TRUE),
											extract_data("sigmah", quality=c(0,1,2,3,4), quality_check=TRUE))
								  data_from_base <- data_from_base %>% 
								    rename_with(function(x) tolower(gsub("mort_", "", x)),
								                starts_with("biom_"))
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
							
							eel_typ_valid <- switch(input$file_type,
							                        "biomass"=13:15,
							                        "mortality_rates"=17:25)
							list_comp<-compare_with_database(data_from_excel,data_from_base,eel_typ_valid)
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
							  output$"step1_message_updated"<-renderUI(
							    HTML(
							      paste(
							        h4("Table of updated values (xls)"),
							        "<p align='left'>Please click on excel",
							        "to download this file. <p>"                         
							      ))) 
								data$updated_values_table <- compare_with_database_updated_values(updated_from_excel,data_from_base) 
								output$dt_updated_values <- DT::renderDataTable(
											data$updated_values_table,
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
										         filename = paste0("updated_",input$file_type,"_",Sys.Date(),current_cou_code))) 
										))
							}else{
							  output$"step1_message_updated"<-renderUI("")
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
											options=list(dom="t",
													rownames = FALSE,
													scroller = TRUE,
													scrollX = TRUE,
													scrollY = "500px"
											))
								})
						#data$new <- new # new is stored in the reactive dataset to be inserted later.      
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			
			##########################
			# STEP 2.1
			# When database_duplicates_button is clicked
			# this will trigger the data integration
			#############################         
			# this step only starts if step1 has been launched    
			observeEvent(input$database_duplicates_button, tryCatch({ 
						
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
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					})) 
			##########################
			# STEP 2.2
			# When database_new_button is clicked
			# this will trigger the data integration
			#############################      
			observeEvent(input$database_new_button, tryCatch({
						
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
							path <- isolate(step22_filepath())
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
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			##########################
			# STEP 2.3
			# Integration of updated_values when proceed is clicked
			# 
			#############################
			observeEvent(input$database_updated_value_button, tryCatch({
			  ###########################
			  # step2_filepath
			  # reactive function, when clicked return value in reactive data 
			  ###########################
			  step23_filepath <- reactive({
			    inFile <- isolate(input$xl_updated_file)     
			    if (is.null(inFile)){        return(NULL)
			    } else {
			      data$path_step23<-inFile$datapath #path to a temp file             
			    }
			  })
					
						###########################
						# step23load_updated_value_data
						#  function, returns a message
						#  indicating that data integration was a succes
						#  or an error message
						###########################
						step23load_updated_value_data <- function() {
						  path <- isolate(step23_filepath())
						  if (is.null(data$path_step23)) 
						    return(NULL)
							rls <- write_updated_values(path,qualify_code=qualify_code)
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
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
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
						
						output$textoutput_step2.1_ts <- renderText("")
						output$dt_integrate_ts <- renderDataTable(data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						output$dt_duplicates_ts <- renderDataTable(data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						
						
						output$step1_message_new_series <- renderText("")
						output$dt_new_series <- renderDataTable(data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						
						output$step1_message_new_dataseries <- renderText("")
						output$dt_new_dataseries <- renderDataTable(data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						
						output$step1_message_new_biometry <- renderText("")
						output$dt_new_biometry <- renderDataTable(data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						
						output$step1_message_modified_series  <- renderText("")
						output$dt_modified_series <- renderDataTable(
								data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))  
						output$dt_highlight_change_series <- renderDataTable(
								data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))   
						
						
						output$step1_message_modified_dataseries <- renderText("")
						output$dt_modified_dataseries <- renderDataTable(
								data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))    
						output$dt_highlight_change_dataseries <- renderDataTable(
								data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))   

						
						output$step1_message_modified_biometry  <- renderText("") 
						output$dt_modified_biometry <- renderDataTable(
								data.frame(),
								options = list(searching = FALSE,paging = FALSE,
										language = list(zeroRecords = "Not run yet")))   
						
						reset("xl_modified_biometry")
						reset("xl_new_biometry")
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
										if(!length(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]))==1) stop(paste("More than one country there :",
													paste(unique(rls$res$series$ser_cou_code[!is.na(rls$res$series$ser_cou_code)]),collapse=";"), ": while there should be only one country code"))
										cou_code <- rls$res$series$ser_cou_code[1]
										if (nrow(rls$res$series)>0) plotseries(rls$res$series)
										# the following three lines might look silly but passing input$something to the log_datacall function results
										# in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
										main_assessor <- input$main_assessor
										secondary_assessor <- input$secondary_assessor
										file_type <- input$file_type_ts
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
									if(!length(unique(ls$res$series$ser_cou_code[!is.na(ls$res$series$ser_cou_code)]))==1) stop(paste("More than one country there :",
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
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			##################################################
			# Events triggered by step1_button TIME SERIES
			###################################################      
			##########################
			# When check_duplicate_button is clicked
			# this will render a datatable containing rows
			# with duplicates values
			#############################
			observeEvent(input$check_duplicate_button_ts, tryCatch({ 
						
						
						# see step0load_data returns a list with res and messages
						# and within res data and a dataframe of errors
						
						validate(
								need(input$xlfile_ts != "", "Please select a data set")
						)
						validate(need(data$connectOK,"No connection"))
						res <- isolate(step0load_data_ts()$res)
						series <- res$series
						station	<- res$station
						new_data	<- res$new_data
						updated_data	<- res$updated_data
						new_biometry <- res$new_biometry
						updated_biometry <- res$updated_biometry
						t_series_ser <- res$t_series_ser
						#suppressWarnings(t_series_ser <- extract_data("t_series_ser",  quality_check=FALSE)) 
						
						new_data <- left_join(new_data, t_series_ser[,c("ser_id","ser_nameshort")], by="ser_nameshort")
						new_data <- rename(new_data,"das_ser_id"="ser_id")
						
						# bis_ser_id is missing from excel so I'm reloading it
						if (nrow(new_biometry)>0){
							new_biometry <- select(new_biometry,-"bis_ser_id")
							new_biometry <-  left_join(new_biometry, t_series_ser[,c("ser_id","ser_nameshort")], by="ser_nameshort")
							new_biometry <- rename(new_biometry,"bis_ser_id"="ser_id")
						}
						
						
						
						t_dataseries_das <- extract_data("t_dataseries_das", quality_check=FALSE)  
						t_biometry_series_bis <- extract_data("t_biometry_series_bis", quality_check=FALSE)
						
						switch (input$file_type_ts, 
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
						if (nrow(series)>0){						
							list_comp_series <- compare_with_database_series(data_from_excel=series, data_from_base=t_series_ser)
						}
						if (nrow(new_data)>0){
							list_comp_dataseries <- compare_with_database_dataseries(data_from_excel=new_data, data_from_base=t_dataseries_das, sheetorigin="new_data")
						}

						if (nrow(updated_data)>0){
							list_comp_updateddataseries <- compare_with_database_dataseries(data_from_excel=updated_data, data_from_base=t_dataseries_das, sheetorigin="updated_data")
							
							if (nrow(new_data)>0){
								list_comp_dataseries$new <- rbind(list_comp_dataseries$new,list_comp_updateddataseries$new)
								list_comp_dataseries$modified <- rbind(list_comp_dataseries$modified,list_comp_updateddataseries$modified)
							  if (nrow(list_comp_dataseries$highlight_change)>0){
								  list_comp_dataseries$highlight_change <- bind_rows(list_comp_dataseries$highlight_change,
								                                                     list_comp_updateddataseries$highlight_change)
								} else{
								  list_comp_dataseries$highlight_change <- list_comp_updateddataseries$highlight_change
								}
								# note highlight change is not passed from one list to the other, both will be shown
							} else {
							  list_comp_dataseries$new <- list_comp_updateddataseries$new
							  list_comp_dataseries$modified <- list_comp_updateddataseries$modified
							  list_comp_dataseries$highlight_change <- list_comp_updateddataseries$highlight_change
							}
						}	else {
							list_comp_updateddataseries <- list()
							list_comp_updateddataseries$error_id_message <- "" # this message would have been displayed if pb of id
						}			
						if (nrow(new_biometry)>0){
							list_comp_biometry <- compare_with_database_biometry(data_from_excel=new_biometry, data_from_base=t_biometry_series_bis, sheetorigin="new_data")
						}
						
						if (nrow(updated_biometry)>0){
						  list_comp_updated_biometry <- compare_with_database_biometry(data_from_excel=updated_biometry, data_from_base=t_biometry_series_bis, sheetorigin="updated_biometry")
						  if (nrow(new_biometry)>0){
						    list_comp_biometry$new <- rbind(list_comp_biometry$new,list_comp_updated_biometry$new)
						    list_comp_biometry$modified <- rbind(list_comp_biometry$modified,list_comp_updated_biometry$modified)
						    if (nrow(list_comp_biometry$highlight_change)>0){
						      list_comp_biometry$highlight_change <- bind_rows(list_comp_biometry$highlight_change,
						                                                        list_comp_updated_biometry$highlight_change)
						    } else {
						      list_comp_biometry$highlight_change <- list_comp_updated_biometry$highlight_change
						    }
						    # note highlight change is not passed from one list to the other, both will be shown
						  } else {
						    list_comp_biometry$new <- list_comp_updated_biometry$new
						    list_comp_biometry$modified <- list_comp_updated_biometry$modified
						    list_comp_biometry$highlight_change <- list_comp_updated_biometry$highlight_change
						  }
						}
						current_cou_code <- list_comp_series$current_cou_code
						
						#cat("step1")					
						# step1 new series -------------------------------------------------------------
						
						if (nrow(list_comp_series$new)==0) {
							output$step1_message_new_series <- renderUI(
									HTML(
											paste(
													h4("No new series")                             
											))) 
							
							output$dt_new_series <- renderDataTable(data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No data")))  
							
							
						} else {      
							output$"step1_message_new_series"<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of new values (series) (xls)"),
															"<p align='left'>Please click on excel ",
															"to download this file and eventually qualify your data with columns <strong>qal_id, qal_comment</strong> ",
															"once this is done download the file with button <strong>download new</strong> and proceed to next step.",
															"<strong>Do this before integrating dataseries.</strong><p>"
													)))
							)
							output$dt_new_series <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_series$new,
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
														autoWidth = TRUE,
														columnDefs = list(list(width = '200px', targets = c(4, 8))),
														buttons=list(
																list(extend="excel",
																		filename = paste0("new_series_",input$file_type_ts, "_",Sys.Date(),"_",current_cou_code))) 
												))
									})
						} 					
						# step1 new dataseries -------------------------------------------------------------						
						if (nrow(list_comp_dataseries$new)==0) {
							output$"step1_message_new_dataseries"<-renderUI(
									HTML(
											paste(
													h4("No new data")                             
											)))      
							
							output$dt_new_dataseries <-  renderDataTable(data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No data")))  
							
						} else {
							output$"step1_message_new_dataseries"<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of new values (data) (xls)"),
															list_comp_updateddataseries$error_id_message,
															"<p align='left'>Please click on excel ",
															"Data may come from new_data or updated_data (error)",
															" Series should have been <strong>updated</strong> before getting data <p>"
													)))
							)
							output$dt_new_dataseries <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_dataseries$new,
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
														autoWidth = TRUE,
														columnDefs = list(list(width = '200px', targets = c(4, 8))),
														buttons=list(
																list(extend="excel",
																		filename = paste0("new_dataseries_",input$file_type_ts,"_",Sys.Date(),"_",current_cou_code))) 
												))
									})
						} 			
						# step1 new biometry -------------------------------------------------------------						
						
						if (!exists("list_comp_biometry") || nrow(list_comp_biometry$new)==0) {
							output$step1_message_new_biometry <- renderUI(
									HTML(
											paste(
													h4("No new biometry")                             
											)))  
							output$dt_new_biometry <-  renderDataTable(data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No biometry")))  
							
							
						} else {      
							output$"step1_message_new_biometry"<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of new values (data) (xls)"),
															"<p align='left'>Please click on excel <p>"
													)))
							)
							output$dt_new_biometry <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_biometry$new,
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
																		filename = paste0("new_biometry_",input$file_type_ts,"_",Sys.Date(),"_",current_cou_code))) 
												))
									})
						} 
						# step1 modified series -------------------------------------------------------------						
						
						if (nrow(list_comp_series$modified)==0) {
							output$step1_message_modified_series<-renderUI(
									HTML(
											paste(
													h4("No modified series")                             
											)))
							
							output$dt_modified_series <- renderDataTable(
									data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No data")))  
							output$dt_highlight_change_series <- renderDataTable(
									data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No change")))  
							
							
						} else {      
							output$step1_message_modified_series<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of modified series (data) (xls)"),
															"<p align='left'>Please click on excel <p>"
													)))
							)
							output$dt_modified_series <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_series$modified,
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
																		filename = paste0("modified_series_",input$file_type_ts,"_",Sys.Date(),"_",current_cou_code))) 
												))
									})
							output$dt_highlight_change_series <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_series$highlight_change,
												rownames=FALSE,          
												option=list(
														scroller = TRUE,
														scrollX = TRUE,
														scrollY = "500px",
														lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
														"pagelength"=-1,
														scrollX = T 
												))
									})
						} 				
						
						# step1 modified dataseries -------------------------------------------------------------						
						
						if (nrow(list_comp_dataseries$modified)==0) {
							output$"step1_message_modified_dataseries"<-renderUI(
									HTML(
											paste(
													h4("No modified dataseries")                             
											)))
							
							output$dt_modified_dataseries <- renderDataTable(
									data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No data")))    
							output$dt_highlight_change_dataseries <- renderDataTable(
									data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No change from newdata")))   

							
						} else {
							output$"step1_message_modified_dataseries"<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of modified dataseries (data) (xls)"),
															"<p align='left'> This is the file to import ",
															"Data may come from new_data (error) or updated_data",
															"Please click on excel<p>"
													)))
							)
							output$dt_modified_dataseries <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_updateddataseries$modified,
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
																		filename = paste0("modified_dataseries_",input$file_type_ts,"_",Sys.Date(),"_",current_cou_code))) 
												))
									})
							
							# Data are coming for either updated or new series, they are checked and
							# data from updated and new have been collated
							# but for highlight for change they are kept in each source list to be shown below
							
							output$dt_highlight_change_dataseries <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_dataseries$highlight_change,
												rownames=FALSE,          
												option=list(
														scroller = TRUE,
														scrollX = TRUE,
														scrollY = "500px",
														lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
														"pagelength"=-1,
														scrollX = T
												))
									})
							
							
						} 	
						
						# step1 modified biometry -------------------------------------------------------------						
						
						if ((!exists("list_comp_biometry")) || nrow(list_comp_biometry$modified)==0) {
							
							output$"step1_message_modified_biometry"<-renderUI(
									HTML(
											paste(
													h4("No modified biometry")                             
											)))
							
							output$dt_modified_biometry <- renderDataTable(
									data.frame(),
									options = list(searching = FALSE,paging = FALSE,
											language = list(zeroRecords = "No modified biometry"))) 	
							
						} else {      
							output$"step1_message_modified_biometry"<-renderUI(
									HTML(
											paste(
													paste(
															h4("Table of modified biometry (data) (xls)"),
															"<p align='left'> This is the file to import ",															
															"Please click on excel<p>"
													)))
							)
							
							
							
							# NO renderUI
							
							output$dt_modified_biometry <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_biometry$modified,
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
																		filename = paste0("modified_biometry_",input$file_type_ts,"_",Sys.Date(),"_",current_cou_code))) 
												))
									})
							
							
							output$dt_highlight_change_biometry <-DT::renderDataTable({ 
										validate(need(data$connectOK,"No connection"))
										datatable(list_comp_biometry$highlight_change,
												rownames=FALSE,          
												option=list(
														scroller = TRUE,
														scrollX = TRUE,
														scrollY = "500px",
														lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
														"pagelength"=-1
										))
									})						
						}
						
						
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					})) # end observe event
			
			##########################
			# STEP 2 TIME SERIES INTEGRATION
			# When database_new_button is clicked
			# this will trigger the data integration
			#############################      
			
			# 2.1 new series --------------------------------------------------------
			
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
							file_type <- input$file_type_ts
							log_datacall("new series integration", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.1_ts<-renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step21load_data()
									if (is.null(data$path_step21_new_series)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
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
							file_type <- input$file_type_ts
							log_datacall("update series", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.2_ts<-renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step22load_data()
									if (is.null(data$path_step22_modified_series)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
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
							file_type <- input$file_type_ts
							log_datacall("new dataseries integration", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.3_ts <- renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step23load_data()
									if (is.null(data$path_step_23_new_dataseries)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
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
							file_type <- input$file_type_ts
							log_datacall("update dataseries", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.4_ts <- renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step24load_data()
									if (is.null(data$path_step_24_modified_dataseries)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))	
			
			# 2.5 Integrate new biometry  --------------------------------------------------------							
			
			observeEvent(input$integrate_new_biometry_button, tryCatch({
						
						step25_filepath_new_biometry <- reactive({
									inFile <- isolate(input$xl_new_biometry)     
									if (is.null(inFile)){        return(NULL)
									} else {
										data$path_step_25_new_biometry <- inFile$datapath #path to a temp file             
									}
								})
						
						step25load_data <- function() {
							path <- isolate(step25_filepath_new_biometry())
							if (is.null(data$path_step_25_new_biometry)) 
								return(NULL)
							rls <- write_new_biometry(path)
							message <- rls$message
							cou_code <- rls$cou_code
							main_assessor <- input$main_assessor
							secondary_assessor <- input$secondary_assessor
							file_type <- input$file_type_ts
							log_datacall("write new biometry", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.5_ts <- renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step25load_data()
									if (is.null(data$path_step_25_new_biometry)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			# 2.6 update modified biometries  --------------------------------------------------------							
			
			observeEvent(input$update_biometry_button, tryCatch({
						
						step26_filepath_update_biometry <- reactive({
									inFile <- isolate(input$xl_modified_biometry)     
									if (is.null(inFile)){        return(NULL)
									} else {
										data$path_step_26_update_biometry <- inFile$datapath #path to a temp file             
									}
								})
						
						step26load_data <- function() {
							path <- isolate(step26_filepath_update_biometry())
							if (is.null(data$path_step_26_update_biometry)) 
								return(NULL)
							rls <- update_biometry(path)
							message <- rls$message
							cou_code <- rls$cou_code
							main_assessor <- input$main_assessor
							secondary_assessor <- input$secondary_assessor
							file_type <- input$file_type_ts
							log_datacall("update biometry", cou_code = cou_code, message = sQuote(message), 
									the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
									secondary_assessor = secondary_assessor)
							return(message)
						}
						
						output$textoutput_step2.6_ts <- renderText({
									validate(need(data$connectOK,"No connection"))
									# call to  function that loads data
									# this function does not need to be reactive
									message <- step26load_data()
									if (is.null(data$path_step_26_update_biometry)) "please select a dataset" else {                                      
										paste(message,collapse="\n")
									}                  
								})  
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))								
			
#			#######################################
## III. Data correction table  
## This section provides a direct interaction with the database
## Currently only developped for modifying data.
## Deletion must be done by changing data code or asking Database handler
#			#######################################
#			rvs <- reactiveValues(
#					data = NA, 
#					dbdata = NA,
#					dataSame = TRUE,
#					editedInfo = NA
#			
#			)
#			
##-----------------------------------------  
## Generate source via reactive expression
#			
#			mysource <- reactive({
#						req(input$passwordbutton)
#						validate(need(data$connectOK,"No connection"))
#						vals = input$country
#						if (is.null(vals)) 
#							vals <- c("FR")
#						types = input$typ
#						if (is.null(types)) 
#							types <- c(4, 5, 6, 7)
#						the_years <- input$year
#						if (is.null(input$year)) {
#							the_years <- c(the_years$min_year, the_years$max_year)
#						}
#						# glue_sql to protect against injection, used with a vector with *
#						query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
#								vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
#								.con = pool)
#						# https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
#						# it seems that dbgetquery doesn't raise an error
#						out_data <- dbGetQuery(pool, query)
#						return(out_data)
#						
#					})
#			
## Observe the source, update reactive values accordingly
#			
#			observeEvent(mysource(), {               
#						data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
#						rvs$data <- data
#						rvs$dbdata <- data
#						disable("clear_table")                
#					})
#			
##-----------------------------------------
## Render DT table 
## 
## selection better be none
## editable must be TRUE
##
#			output$table_cor <- DT::renderDataTable({
#						validate(need(data$connectOK,"No connection"))
#						DT::datatable(
#								rvs$dbdata, 
#								rownames = FALSE,
#								extensions = "Buttons",
#								editable = TRUE, 
#								selection = 'none',
#								options=list(
#										order=list(3,"asc"),              
#										searching = TRUE,
#										rownames = FALSE,
#										scroller = TRUE,
#										scrollX = TRUE,
#										scrollY = "500px",
#										lengthMenu=list(c(-1,5,20,50,100),c("All","5","20","50","100")),
#										dom= "Blfrtip", #button fr search, t table, i information (showing..), p pagination
#										buttons=list(
#												list(extend="excel",
#														filename = paste0("data_",Sys.Date())))
#								))})
##-----------------------------------------
## Create a DT proxy to manipulate data
## 
##
#			proxy_table_cor = dataTableProxy('table_cor')
##--------------------------------------
## Edit table data
## Expamples at
## https://yihui.shinyapps.io/DT-edit/
#			observeEvent(input$table_cor_cell_edit, {
#						
#						info = input$table_cor_cell_edit
#						
#						i = info$row
#						j = info$col = info$col + 1  # column index offset by 1
#						v = info$value
#						
#						rvs$data[i, j] <<- DT::coerceValue(v, rvs$data[i, j])
#						replaceData(proxy_table_cor, rvs$data, resetPaging = FALSE, rownames = FALSE)
#						# datasame is set to TRUE when save or update buttons are clicked
#						# here if it is different it might be set to FALSE
#						rvs$dataSame <- identical(rvs$data, rvs$dbdata)
#						# this will collate all editions (coming from datatable observer in a data.frame
#						# and store it in the reactive dataset rvs$editedInfo
#						if (all(is.na(rvs$editedInfo))) {
#							
#							rvs$editedInfo <- data.frame(info)
#						} else {
#							rvs$editedInfo <- dplyr::bind_rows(rvs$editedInfo, data.frame(info))
#						}
#						
#					})
#			
## Update edited values in db once save is clicked---------------------------------------------
#			
#			observeEvent(input$save, {
#						errors<-update_t_eelstock_eel(editedValue = rvs$editedInfo, pool = pool, data=rvs$data)
#						if (length(errors)>0) {
#							output$database_errors<-renderText({iconv(unlist(errors,"UTF8"))})
#							enable("clear_table")
#						} else {
#							output$database_errors<-renderText({"Database updated"})
#						}
#						rvs$dbdata <- rvs$data
#						rvs$dataSame <- TRUE
#					})
#			
## Observe clear_table button -> revert to database table---------------------------------------
#			
#			observeEvent(input$clear_table,
#					{
#						data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
#						rvs$data <- data
#						rvs$dbdata <- data
#						disable("clear_table")
#						output$database_errors<-renderText({""})
#					})
#			
## Oberve cancel -> revert to last saved version -----------------------------------------------
#			
#			observeEvent(input$cancel, {
#						rvs$data <- rvs$dbdata
#						rvs$dbdata <- NA
#						rvs$dbdata <- rvs$data #this is to ensure that the table display is updated (reactive value)
#						rvs$dataSame <- TRUE
#					})
#			
## UI buttons ----------------------------------------------------------------------------------
## Appear only when data changed
#			
#			output$buttons_data_correction <- renderUI({
#						div(
#								if (! rvs$dataSame) {
#											span(
#													actionBttn(inputId = "save", label = "Save",
#															style = "material-flat", color = "danger"),
#													actionButton(inputId = "cancel", label = "Cancel")
#											)
#										} else {
#											span()
#										}
#						)
#					})
#			
#			
#			
			

			#######################################
			# IV. Data correction table All  
			# This section provides a direct interaction with the database
			# Currently only developped for modifying data.
			# Deletion must be done by changing data code or asking Database handler
			#######################################
			rvsAll <- reactiveValues(
			  data = NA, 
			  dbdata = NA,
			  dataSame = TRUE,
			  editedInfo = NA
			  
			)
			
			#-----------------------------------------  
			# Generate source via reactive expression
			
			mysourceAll <- reactive({
			  req(input$passwordbutton)
			  req(input$edit_datatype!="NULL")
			  validate(need(data$connectOK,"No connection"))
			  pick1 = input$editpicker1
			  pick2= input$editpicker2
			  if (is.null(pick1)) 
			   pick1=switch(input$edit_datatype,
			              "t_eelstock_eel"=c("FR"),
			              "t_eelstock_eel_perc"=c("FR"),
			              c("G")
			             )
			  if (is.null(pick2)) 
			    pick2=switch(input$edit_datatype,
			                 "t_eelstock_eel"=c(4, 5, 6, 7),
			                 "t_eelstock_eel_perc"=c(13:15,17:19),
			                 data$ser_list)
			  the_years <- input$yearAll
			  if (is.null(input$yearAll)) {
			    the_years <- c(the_years$min_year, the_years$max_year)
			  }
			  query = switch (input$edit_datatype,
			                  "t_dataseries_das" = glue_sql(str_c("SELECT das.*,ser_nameshort as ser_nameshort_ref,ser_emu_nameshort as ser_emu_nameshort_ref,ser_lfs_code as ser_lfs_code_ref from datawg.t_dataseries_das das join datawg.t_series_ser on das_ser_id=ser_id where ser_nameshort in ({pick2*}) and ser_lfs_code in ({pick1*}) and das_year>={minyear} and das_year<={maxyear}"), 
			                                                series = series, lfs = lfs, minyear = the_years[1], maxyear = the_years[2], 
			                                                .con = pool),
			                  "t_eelstock_eel" =  query <- glue_sql("SELECT *,typ_name as typ_name_ref from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id where eel_cou_code in ({pick1*}) and eel_typ_id in ({pick2*}) and eel_year>={minyear} and eel_year<={maxyear}", 
			                                                        vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
			                                                        .con = pool),
			                  "t_eelstock_eel_perc" =  query <- glue_sql("SELECT percent_id,eel_year eel_year_ref,eel_emu_nameshort as eel_emu_nameshort_ref,eel_cou_code as eel_cou_code_ref,typ_name as typ_name_ref, perc_f, perc_t, perc_c,perc_mo from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id left join datawg.t_eelstock_eel_percent on percent_id=eel_id where eel_cou_code in ({pick1*}) and eel_typ_id in ({pick2*}) and eel_year>={minyear} and eel_year<={maxyear}", 
			                                                        vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
			                                                        .con = pool),
			                  "t_series_ser" =  glue_sql("SELECT *, ser_ccm_wso_id[1]::integer AS wso_id1, ser_ccm_wso_id[2]::integer AS wso_id2, ser_ccm_wso_id[3]::integer AS wso_id3 from datawg.t_series_ser where ser_nameshort in ({pick2*}) and ser_lfs_code in ({pick1*})", # ser_ccm_wso_id is an array to deal with series being part of serval basins ; here we deal until 3 basins
			                                             vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
			                                             .con = pool),
			                  "t_biometry_series_bis" = glue_sql(str_c("SELECT bio.*,ser_nameshort as ser_nameshort_ref,ser_emu_nameshort as ser_emu_nameshort_ref,ser_lfs_code as ser_lfs_code_ref from datawg.t_biometry_series_bis bio join datawg.t_series_ser on bis_ser_id=ser_id where ser_nameshort in ({pick2*}) and bio_lfs_code in ({pick1*}) and bio_year>={minyear} and bio_year<={maxyear}"), 
			                                                  series = series, lfs = lfs, minyear = the_years[1], maxyear = the_years[2], 
			                                                  .con = pool)
			  )
			  # glue_sql to protect against injection, used with a vector with *
			  query <- 
			    # https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
			    # it seems that dbgetquery doesn't raise an error
			    out_data <- dbGetQuery(pool, query)
			  return(out_data)
			  
			})
			
			# Observe the source, update reactive values accordingly
			
			observeEvent(mysourceAll(), tryCatch({
			  data <- switch(input$edit_datatype,
			                 "t_dataseries_das" = mysourceAll() %>%
			                   arrange(ser_nameshort_ref,das_year), 
			                 "t_eelstock_eel" =  mysourceAll() %>%
			                   arrange(eel_emu_nameshort,eel_year),
			                 "t_eelstock_eel_perc" =  mysourceAll() %>%
			                   arrange(eel_emu_nameshort_ref,eel_year_ref),
			                 "t_series_ser" =  mysourceAll() %>% 
			                   arrange(ser_nameshort,ser_cou_code),
			                 "t_biometry_series_bis" = mysourceAll() %>%
			                   arrange(ser_nameshort_ref,bio_year)
			  )
			  rvsAll$data <- data
			  rvsAll$dbdata <- data
			  rvsAll$editedInfo = NA
			  disable("clear_tableAll")                
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			#-----------------------------------------
			# Render DT table 
			# 
			# selection better be none
			# editable must be TRUE
			#
			output$table_corAll <- DT::renderDataTable({
			  validate(need(data$connectOK,"No connection"))
			  req(input$edit_datatype!="NULL")
			  noteditable=c(1,grep("_ref",names(rvsAll$dbdata)))-1

			  DT::datatable(
			    rvsAll$dbdata, 
			    filter="top",
			    rownames = FALSE,
			    extensions = "Buttons",
			    editable = list(target = 'cell',
			                    disable = list(columns = noteditable)), 
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
			
			
			output$maps_editedtimeseries <-renderLeaflet({
			  validate(need(data$connectOK,"No connection"))
			  req(input$edit_datatype=="t_series_ser")
			  colors=rep("blue",nrow(rvsAll$data))
			  if (!all(is.na(rvsAll$editedInfo))){
			    colx=which(names(rvsAll$data)=="ser_x")
			    coly=which(names(rvsAll$data)=="ser_y")
			    colors[rvsAll$editedInfo$row[rvsAll$editedInfo$col %in% c(colx,coly)]]="red"
			  }
			  pal <- 
			    colorFactor(palette = c("blue", "red"), 
			                levels = c("blue", "red"))
			  leaflet(rvsAll$data) %>%
			    addTiles(group="OSM") %>%
			    addProviderTiles(providers$Esri.WorldImagery, group="satellite")  %>%
				addPolygons(data=data$ccm_light %>% inner_join(union(union(rvsAll$data %>% select(wso_id1) %>% distinct() %>% transmute(wso_id = wso_id1), rvsAll$data %>% select(wso_id2) %>% distinct() %>% transmute(wso_id = wso_id2)), rvsAll$data %>% select(wso_id3) %>% distinct() %>% transmute(wso_id = wso_id3))), 
					popup=~as.character(wso_id),
					fill=TRUE, 
					highlight = highlightOptions(color='white',
						weight=1,
						bringToFront = TRUE,
						fillColor="red",opacity=.2,
						fill=TRUE))%>%
			    addCircleMarkers(layerId=~ser_nameshort,
			               color=~pal(colors),
			               lat=~ser_y,
			               lng=~ser_x,
			               label=~ser_nameshort,
			               group="stations") %>%
			    addDrawToolbar(targetGroup="stations",
			                   editOptions = editToolbarOptions(edit=TRUE,
			                                                    remove=FALSE),
			                   rectangleOptions=FALSE,
			                   circleOptions=FALSE,
			                   polygonOptions=FALSE,
			                   polylineOptions=FALSE,
			                   markerOptions=FALSE,
			                   circleMarkerOptions=FALSE) %>%
			    addLayersControl(baseGroups=c("OSM","satellite"))
			})
			
			observeEvent(eventExpr = input$addRowTable_corAll, tryCatch({
			  emptyRow <- rvsAll$dbdata[1,,drop=FALSE]
			  emptyRow[1,] <- NA
			  rvsAll$data <- bind_rows(rvsAll$data,emptyRow)
			  replaceData(proxy_table_corAll,rvsAll$data , resetPaging = FALSE, rownames = FALSE)
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			
			observeEvent(input$maps_editedtimeseries_draw_edited_features, tryCatch({
			  edited <- input$maps_editedtimeseries_draw_edited_features
			  nedited <- length(edited$features)
			  ids <- edited$features[[nedited]]$properties$`layerId`
			  i <- which(rvsAll$dbdata$ser_nameshort==ids)
			  newx <- edited$features[[nedited]]$geometry$coordinates[[1]]
			  newy <- edited$features[[nedited]]$geometry$coordinates[[2]]
			  cx <- which(names(rvsAll$dbdata)=="ser_x")
			  cy <- which(names(rvsAll$dbdata)=="ser_y")
			  info <- data.frame(row=rep(i,2),
			                  col=c(cx,
			                        cy),
			                        value=as.character(c(newx,newy)))
			  rvsAll$data[i, cx] <<- DT::coerceValue(newx, rvsAll$data[i, cx])
			  rvsAll$data[i, cy] <<- DT::coerceValue(newy, rvsAll$data[i, cy])
			  replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames=FALSE)
			  # datasame is set to TRUE when save or update buttons are clicked
			  # here if it is different it might be set to FALSE
			  rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
			  # this will collate all editions (coming from datatable observer in a data.frame
			  # and store it in the reactive dataset rvs$editedInfo
			  if (all(is.na(rvsAll$editedInfo))) {
			    
			    rvsAll$editedInfo <- info
				} else {
			    rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, info)
			  }

			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			#-----------------------------------------
			# Create a DT proxy to manipulate data
			# 
			#
			proxy_table_corAll = dataTableProxy('table_corAll')
			#--------------------------------------
			# Edit table data
			# Expamples at
			# https://yihui.shinyapps.io/DT-edit/
			observeEvent(input$table_corAll_cell_edit, tryCatch({
			  info <- input$table_corAll_cell_edit
			  
			  i <- info$row
			  j <- info$col <- info$col + 1  # column index offset by 1
			  v <- info$value
			  
			  rvsAll$data[i, j] <<- DT::coerceValue(v, rvsAll$data[i, j])
			  replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames = FALSE)
			  # datasame is set to TRUE when save or update buttons are clicked
			  # here if it is different it might be set to FALSE
			  rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
			  # this will collate all editions (coming from datatable observer in a data.frame
			  # and store it in the reactive dataset rvs$editedInfo
			  if (all(is.na(rvsAll$editedInfo))) {
			    
			    rvsAll$editedInfo <- data.frame(info)
			  } else {
			    rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, data.frame(info))
			  }
			  
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			
			#depending on the data type we want to edit, the picker change
			observeEvent(input$edit_datatype,tryCatch({
			  if (input$edit_datatype == "t_eelstock_eel"){
			    updatePickerInput(session=session,
			                      inputId="editpicker2",
			                      choices=data$typ_id,
			                      label="Select a type :",
			                      selected=NULL)
			    updatePickerInput(session=session,
			                      inputId="editpicker1",
			                      label = "Select a country :", 
			                      choices = data$list_country,
			                      selected=NULL)
			    shinyjs::show("addRowTable_corAll")
			  } else if (input$edit_datatype == "t_eelstock_eel_perc"){
			    updatePickerInput(session=session,
			                      inputId="editpicker2",
			                      choices=data$typ_id[data$typ_id %in% c(13:15,17:19)],
			                      label="Select a type :",
			                      selected=NULL)
			    updatePickerInput(session=session,
			                      inputId="editpicker1",
			                      label = "Select a country :", 
			                      choices = data$list_country,
			                      selected=NULL)
			    shinyjs::hide("addRowTable_corAll")
			    
			    
			  }else {
			    updatePickerInput(session=session,
			                      inputId="editpicker2",
			                      label = "Select series :", 
			                      choices = data$ser_list,
			                      selected=NULL)
			    updatePickerInput(session=session,
			                      inputId="editpicker1",
			                      label="Select a stage :",
			                      choices=c("G","GY","Y","S"),
			                      selected=NULL)
			    shinyjs::show("addRowTable_corAll")
			    
			    if (input$edit_datatype=="t_series_ser")  disable("yearAll")
					
			    rvsAll$dataSame <- TRUE
			    rvsAll$editedInfo <- NA
			    data <- switch(input$edit_datatype,
			                   "t_dataseries_das" = mysourceAll() %>%
			                     arrange(ser_nameshort_ref,das_year), 
			                   .con = pool,
			                   "t_eelstock_eel" =  mysourceAll() %>%
			                     arrange(eel_emu_nameshort,eel_year),
			                   "t_series_ser" =  mysourceAll() %>% 
			                     arrange(ser_nameshort,ser_cou_code),
			                   "t_biometry_series_bis" = mysourceAll() %>%
			                     arrange(ser_nameshort_ref,bio_year)
			    )
			    rvsAll$data <- data
			    rvsAll$dbdata <- data
			  }},error = function(e) {
			    showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			  }))
			
			#when we want to edit time series related data, if a life stage is selected,
			#we can restrict available time series choices
			observeEvent(input$editpicker1,tryCatch({
			  if (!startsWith(input$edit_datatype, "t_eelstock_eel")){
			    stageser=ifelse(endsWith(data$ser_list,"GY"),
			                    "GY",
			                    str_sub(data$ser_list,-1,-1))
			    selected=input$editpicker2
			    updatePickerInput(session=session,
			                      inputId="editpicker2",
			                      choices = data$ser_list[stageser %in% input$editpicker1],
			                      selected=selected)
			  }
			  
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			observeEvent(input$editpicker2,tryCatch({
			  if ((!startsWith(input$edit_datatype,"t_eelstock_eel")) & is.null(input$editpicker1)){
			    stageser=ifelse(endsWith(input$editpicker2,"GY"),
			                    "GY",
			                    str_sub(input$editpicker2,-1,-1))
			    updatePickerInput(session=session,
			                      inputId="editpicker1",
			                      selected = stageser)
			  }
			  
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			# Update edited values in db once save is clicked---------------------------------------------
			
			observeEvent(input$saveAll, tryCatch({
			  errors <- update_data_generic(editedValue = rvsAll$editedInfo,
			                              pool = pool, data=rvsAll$data,
			                              edit_datatype=input$edit_datatype)
			  if (length(errors$error)>0) {
			    output$database_errorsAll<-renderText({iconv(unlist(errors$errors,"UTF8"))})
			    enable("clear_tableAll")
			  } else {
			    output$database_errorsAll<-renderText({errors$message})
			  }
			  rvsAll$dbdata <- rvsAll$data
			  rvsAll$dataSame <- TRUE
			  rvsAll$editedInfo = NA
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			# Observe clear_table button -> revert to database table---------------------------------------
			
			observeEvent(input$clear_tableAll,
			             tryCatch({
			               data <- switch(input$edit_datatype,
			                              "t_dataseries_das" = mysourceAll() %>%
			                                arrange(ser_nameshort_ref,das_year), 
			                              .con = pool,
			                              "t_eelstock_eel" =  mysourceAll() %>%
			                                arrange(eel_emu_nameshort,eel_year),
			                              "t_series_ser" =  mysourceAll() %>% 
			                                arrange(ser_nameshort,ser_cou_code),
			                              "t_biometry_series_bis" = mysourceAll() %>%
			                                arrange(ser_nameshort_ref,bio_year)
			               )
			               rvsAll$data <- data
			               rvsAll$dbdata <- data
										 rvsAll$editedInfo = NA
			               disable("clear_tableAll")
			               output$database_errorsAll<-renderText({""})
			               rvsAll$editedInfo = NA
			             },error = function(e) {
			               showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			             }))
			
			# Oberve cancel -> revert to last saved version -----------------------------------------------
			
			observeEvent(input$cancelAll, tryCatch({
			  rvsAll$data <- rvsAll$dbdata
			  rvsAll$dbdata <- NA
			  rvsAll$dbdata <- rvsAll$data #this is to ensure that the table display is updated (reactive value)
			  rvsAll$dataSame <- TRUE
			  rvsAll$editedInfo = NA
			},error = function(e) {
			  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
			}))
			
			# UI buttons ----------------------------------------------------------------------------------
			# Appear only when data changed
			
			output$buttons_data_correctionAll <- renderUI({
			  div(
			    if (! rvsAll$dataSame) {
			      span(
			        actionBttn(inputId = "saveAll", label = "Save",
			                   style = "material-flat", color = "danger"),
			        actionButton(inputId = "cancelAll", label = "Cancel")
			      )
			    } else {
			      span()
			    }
			  )
			})
#################################################
# GRAPHS ----------------------------------------
#################################################
		rvs <- reactiveValues(
					datagr = NA			
			)
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
						if (is.null(input$year_g)) {
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
			
			observeEvent(mysource_graph(), tryCatch({               
						data <- mysource_graph() %>% arrange(eel_emu_nameshort,eel_year)
						rvs$datagr <- data                           
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
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
			
			observeEvent(input$duplicated_ggplot_click,  tryCatch({
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
						
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}), ignoreNULL = TRUE) # additional arguments to observe ...
			
			
			# Insert new participants
			observeEvent(input$new_participants_ok,tryCatch({
						validate(need(data$connectOK,"No connection"))
						validate(need(nchar(input$new_participants_id)>0,"need a participant name"))
						message <- write_new_participants(input$new_participants_id)
						output$new_participants_txt <- renderText({message}) 
						updatePickerInput(session=session,"main_assessor",choices=participants)
						updatePickerInput(session=session,"secondary_assessor",choices=participants)
					},error = function(e) {
					  showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
					}))
			
			
			
			#module tableEdit
			tableEditServer("tableEditmodule", data) # globaldata <- data in the module
			loaded_data <- importstep0Server("importstep0module", data) # globaldata <- data in the module 
			importstep1Server("importstep1module", data, loaded_data) # globaldata <- data in the module
			importstep2Server("importstep2module", data, loaded_data)

			loaded_data_ts <- importtsstep0Server("importtsstep0module", data) # globaldata <- data in the module 
			importtsstep1Server("importtsstep1module", data, loaded_data_ts) # globaldata <- data in the module 
			importtsstep2Server("importtsstep2module", data, loaded_data_ts) # globaldata <- data in the module 
			
			newparticipants <- newparticipantsServer("newparticipantsmodule",data)
			plotduplicatesServer("plotduplicatesmodule",data)
			observe({
			  if (!is.null(newparticipants$participants)){
			    updatePickerInput(session=session,"main_assessor",choices=newparticipants$participants)
			    updatePickerInput(session=session,"secondary_assessor",choices=newparticipants$participants)

			  }
			})
			
			
		})
