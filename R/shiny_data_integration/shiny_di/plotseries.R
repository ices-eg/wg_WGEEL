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
											selected = "FR",
											multiple = FALSE, 
											options = list(
													style = "btn-primary", size = 5))),
							column(width=4, 
									pickerInput(inputId = ns("typ_id"), 
											label = "Select an annex :", 
											choices = typ_id,
											selected= 1,
											multiple = FALSE,
											options = list(
													style = "btn-primary", size = 5))),
					),
					column(width=4, 
							pickerInput(inputId = ns("level"), 
									label = "Select an annex :", 
									choices = c("dataseries","group metrics","individual metrics",
											selected= 1,
											multiple = FALSE,
											options = list(
													style = "btn-primary", size = 5)))
					)			 
			
			),               
			
			fluidRow(
					column(width=6,
							plotOutput(ns("series_ggplot"),
									click = clickOpts(id = ns("series_ggplot_click"))
							)),
					column(width=6,
							plotlyOutput(ns("plotly_selected_year")))
			)                                       
	)}




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
							if (is.null(year_column)) year_column <- "das_year"
				
							# glue_sql to protect against injection, used with a vector with *
							query <- 
									switch(level,
											"dataseries"=
													glue_sql("SELECT * FROM datawg.t_series_ser JOIN datawg.t_dataseries_das ON das_ser_id=ser_id WHERE ser_cou_code in ({cou*}) and ser_typ_id in ({types*})", cou = cou, types = types, 
															.con = globaldata$pool),
											"group metrics" =
													glue_sql("SELECT * FROM SELECT * FROM datawg.t_series_ser JOIN 
													datawg.t_groupseries_grser ON grser_ser_id=ser_id WHERE WHERE ser_cou_code in ({cou*}) and ser_typ_id in ({types*})", vals = vals, types = types, 
															.con = globaldata$pool),
											"individual metrics" = 
													glue_sql("SELECT * FROM SELECT * FROM datawg.t_series_ser JOIN 
													datawg.t_fishseries_fiser ON fiser_ser_id=ser_id WHERE WHERE ser_cou_code in ({cou*}) and ser_typ_id in ({types*})", vals = vals, types = types, 
															.con = globaldata$pool))
							out_data <- dbGetQuery(globaldata$pool, query)
							return(out_data)
							
						})
				
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
							# duplicated_values_graph performs a group by, see graph.R inside the shiny data integration
							# tab
							series_graph(rvs$datagr, level= input$level, year_column=year_column) 
						}
				)
				
				# the observeEvent will not execute untill the user clicks, here it runs
				# both the plotly and datatable component -----------------------------------------------------
				
				observeEvent(input$series_ggplot_click,  tryCatch({
									# the nearpoint function does not work straight with bar plots
									# we have to retreive the x data and check the year it corresponds to ... 
									year_selected = round(input$series_ggplot_click$x)  
									datagr <- rvs$datagr
									
									datagr <- datagr%>% filter(!!sym(year_column)==year_selected) 
									
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
									showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
								}), ignoreNULL = TRUE) # additional arguments to observe ...
			}
	)
}