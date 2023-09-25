#' plot duplicates ui
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


plotseriesUI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			box(width=NULL, title= "Time series exploration tab",
					fluidRow(
							column(width=4,
									pickerInput(inputId = ns("country_g"), 
											label = "Select a country :", 
											choices = list_country,
											selected = "GB",
											multiple = TRUE, 
											options = list(
													style = "btn-primary", size = 5))),
							column(width=4, 
									pickerInput(inputId = ns("typ_id"), 
											label = "Select an annex :", 
											choices = c(1,2,3),
											selected= c(1,2,3),
											multiple = TRUE,
											options = list(
													style = "btn-primary", size = 5))),							
							column(width=4, 
									pickerInput(inputId = ns("level"), 
											label = "Select a type :", 
											choices = c("dataseries","group metrics","individual metrics"),
											selected= 1,
											multiple = FALSE,
											options = list(
													style = "btn-primary", size = 5)))
					
					)		 
			
			),               
			box( width=12, collapsible=TRUE,
					fluidRow(
							column(width=5,
							pickerInput(inputId = ns("kept_or_datacall"), 
									label = "Choose kept or datacall :", 
									choices = c("kept","datacall"),
									selected= 1,
									multiple = FALSE,
									options = list(
											style = "btn-primary", size = 5)))),
					fluidRow(
							plotOutput(ns("series_ggplot"),
									click = clickOpts(id = ns("series_ggplot_click"))
							)
					)),	
			fluidRow(
					DT::dataTableOutput(ns("datatable_series_nearpoints"),width='100%') 
			))}




#' plot duplicates server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' 
#' @return nothing


plotseriesServer <- function(id,globaldata){
	moduleServer(id,
			function(input, output, session) {
				
				rvs <- reactiveValues(
						datagr = NA			
				)
				# Same as mysource but for graphs, different page, so different buttons
				# there must be a way by reorganizing the buttons to do a better job
				# but buttons don't apply to the data integration sheet and here we don't
				# want multiple choices (to check for duplicates we need to narrow down the search) ....
				
				mysource_graph <- reactive(					
						{
							validate(need(globaldata$connectOK,"No connection"))
							validate(need(!is.null(globaldata$pool), "Waiting for database connection"))
							cou = input$country_g
							if (is.null(cou)) 
								cou <- c("FR")
							types = input$typ_id
							if (is.null(types)) 
								types <- c(1,2,3)  
							level <- ifelse (is.null(input$level), "dataseries",  input$level)
							year_column <<- switch(input$level, "dataseries"="das_year",
									"group metrics"="gr_year",
									"individual metrics"="fi_year")
							qal_column <<- switch(level, "dataseries"="das_qal_id",
									"group metrics"="meg_qal_id",
									"individual metrics"="mei_qal_id")
							datasource_column <<- switch(level, "dataseries"="das_dts_datasource",
									"group metrics"="meg_dts_datasource",
									"individual metrics"="mei_dts_datasource")
							#if (is.null(year_column)) year_column <- "das_year"
							
							# glue_sql to protect against injection, used with a vector with *
							query <- 
									switch(level,
											"dataseries"=
													glue_sql("SELECT * FROM datawg.t_series_ser JOIN datawg.t_dataseries_das ON das_ser_id=ser_id WHERE ser_cou_code in ({cou*}) and ser_typ_id in ({types*})", cou = cou, types = types, 
															.con = globaldata$pool),
											"group metrics" =
													glue_sql("SELECT count(*) AS n, ser_id, gr_year, ser_nameshort,meg_dts_datasource, meg_qal_id   FROM datawg.t_series_ser JOIN 
																datawg.t_groupseries_grser ON grser_ser_id=ser_id 
																	JOIN datawg.t_metricgroupseries_megser on meg_gr_id=gr_id 
																	WHERE ser_cou_code in ({cou*}) and ser_typ_id in ({types*})
																	GROUP BY ser_id, gr_year, ser_nameshort,meg_dts_datasource, meg_qal_id
																	", vals = vals, types = types, 
															.con = globaldata$pool),
											"individual metrics" = 
													glue_sql("SELECT count(*) AS n, ser_id, case when fi_year is NULL then extract(year from fi_date) else fi_year end as fi_year, ser_nameshort,mei_dts_datasource, mei_qal_id   FROM datawg.t_series_ser JOIN 
																	datawg.t_fishseries_fiser ON fiser_ser_id=ser_id
																	JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
																	WHERE  ser_cou_code in ({cou*}) and ser_typ_id in ({types*})
																	GROUP BY ser_id, fi_year,fi_date, ser_nameshort,mei_dts_datasource, mei_qal_id
																	", vals = vals, types = types, 
															.con = globaldata$pool))
							out_data <- dbGetQuery(globaldata$pool, query)
							return(out_data)
							
						}, )
				
				# store data in reactive values ---------------------------------------------------------------
				
				observeEvent(mysource_graph(), shinyCatch({               
									rvs$datagr  <- mysource_graph() 
								}))
				
				# plot -------------------------------------------------------------------------------------------
				# the plots groups by kept (typ id = 1,2,4) or not (other typ_id) and year 
				# and calculate thenumber of values 
				
				output$series_ggplot <- renderPlot({
							validate(need(globaldata$connectOK,"No connection"))
							if (is.null(rvs$datagr)) return(NULL)
							validate(need(nrow(rvs$datagr)>0, "no data"))
							# duplicated_values_graph performs a group by, see graph.R inside the shiny data integration
							# tab
							series_graph(rvs$datagr, level= input$level, year_column=year_column, qal_column=qal_column, datasource_column=datasource_column,  kept_or_datacall=input$kept_or_datacall) 
						}
				)
				
				# the observeEvent will not execute untill the user clicks, here it runs
				# both the plotly and datatable component -----------------------------------------------------
				
				observeEvent(input$series_ggplot_click, 
						tryCatch({
									# the nearpoint function does not work straight with bar plots
									# we have to retreive the x data and check the year it corresponds to ...
									#browser()
									year_selected = round(input$series_ggplot_click$x) 
									nseries_selected = round(input$series_ggplot_click$y)
									
									datagr <- rvs$datagr
									ser <- unique(rvs$datagr$ser_nameshort)
									ser <- ser[(order(ser))]
									series_selected <- ser[nseries_selected]
									
									datagr <- datagr[datagr$ser_nameshort==series_selected,] 
									
									# Data table for individual data corresponding to the year bar on the graph -------------
									
									output$datatable_series_nearpoints <- DT::renderDataTable({            
												datatable(datagr,
														rownames = FALSE,
														extensions = 'Buttons',
														filter = 'top',
														options=list(    
																lengthMenu=list(c(-1,5,10,30),c("All","5","10","30")),
																"pagelength"=10,
																scroller = TRUE,
																scrollX = TRUE,
																scrollY= "200px",
																dom= "Blfrtip", # l length changing,  
																buttons=list(
																		list(extend="copy"),																	
																		# will allow column choice button
																		list(extend="colvis",
																				targets = 0, 
																				visible = FALSE),
																		list(extend="excel",
																				# modifier = list(page = "all"), I don't think that this is necessary
																				filename = paste0("plotseries_data")
																		)
																)
														) 												
												)
												
											})        
									
									
									
									
									
								},error = function(e) {
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreNULL = TRUE) # additional arguments to observe ...
			}
	)
}