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
			
		
			
			load_database <- reactive(shinyCatch({
						# take a dependency on passwordbutton
						req(input$passwordbutton)						
						# we use isolate as we want no dependency on the value (only the button being clicked)
						passwordwgeel<-isolate(input$password)
						############################################
						# FIRST STEP INITIATE THE CONNECTION WITH THE DATABASE
						###############################################
#						options(sqldf.RPostgreSQL.user = userwgeel,  
#								sqldf.RPostgreSQL.password = passwordwgeel,
#								sqldf.RPostgreSQL.dbname = "wgeel",
#								sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
#								sqldf.RPostgreSQL.port = port)
						
						# Define pool handler by pool on global level
						pool <<- pool::dbPool(drv = RPostgres::Postgres(),
								dbname="wgeel",
								host=host,
								port=port,
								user= userwgeel,
								password= passwordwgeel,
								bigint="integer",
								minSize = 0,
								maxSize = 2)
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
						
						#205-shiny-integration-for-dcf-data TODO CHECK IF USED
						query <- "SELECT distinct sai_id FROM datawg.t_samplinginfo_sai"
						tr_sai_list <- dbGetQuery(pool, sqlInterpolate(ANSI(), query)) 
						isolate({data$sai_list <- tr_sai_list$ser_id})
						
						#205-shiny-integration-for-dcf-data
						query <- "SELECT * from ref.tr_measuretype_mty"
						tr_measuretype_mty <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))
						
						#205-shiny-integration-for-dcf-data
						query <- "SELECT * from ref.tr_units_uni"
						tr_units_uni <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						
						
						query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel"
						the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
						updateSliderTextInput(session,"yearAll",
						                      choices=seq(the_years$min_year, the_years$max_year),
						                      selected = c(the_years$min_year,the_years$max_year))
						
						query <- "SELECT name from datawg.participants order by name asc"
						participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
						
						ices_division <<- suppressWarnings(extract_ref("FAO area", pool)$f_code)
# TODO CEDRIC 2021 remove geom from extract_ref function so as not to get a warning						
						emus <<- suppressWarnings(extract_ref("EMU", pool))
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

			
			#module tableEdit
			tableEditServer("tableEditmodule", data) # globaldata <- data in the module
			loaded_data <- importstep0Server("importstep0module", data) # globaldata <- data in the module 
			importstep1Server("importstep1module", data, loaded_data) # globaldata <- data in the module
			importstep2Server("importstep2module", data, loaded_data)

			loaded_data_ts <- importtsstep0Server("importtsstep0module", data) # globaldata <- data in the module 
			importtsstep1Server("importtsstep1module", data, loaded_data_ts) # globaldata <- data in the module 
			importtsstep2Server("importtsstep2module", data, loaded_data_ts) # globaldata <- data in the module 
			
			loaded_data_dcf <- importdcfstep0Server("importstep0dcf", globaldata=data)
			
			newparticipants <- newparticipantsServer("newparticipantsmodule",data)
			plotduplicatesServer("plotduplicatesmodule",data)
			observe({
			  if (!is.null(newparticipants$participants)){
			    updatePickerInput(session=session,"main_assessor",choices=newparticipants$participants)
			    updatePickerInput(session=session,"secondary_assessor",choices=newparticipants$participants)

			  }
			})
			
			
		})
