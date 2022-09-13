#' plot duplicates ui
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


plotduplicatesUI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          box(width=NULL, title= "Data exploration tab",
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
                       pickerInput(inputId = ns("typ_g"), 
                                   label = "Select a type :", 
                                   choices = typ_id[!typ_id%in%c(1,2,3)],
                                   selected= 4,
                                   multiple = FALSE,
                                   options = list(
                                     style = "btn-primary", size = 5))),
                column(width=4,
                       sliderTextInput(inputId =ns("year_g"), 
                                       label = "Choose a year range:",
                                       choices=seq(the_years$min_year, current_year),
                                       selected = c(the_years$min_year,the_years$max_year)
                       )))),               
          
          fluidRow(
            column(width=6,
                   plotOutput(ns("duplicated_ggplot"),
                              click = clickOpts(id = ns("duplicated_ggplot_click"))
                   )),
            column(width=6,
                   plotlyOutput(ns("plotly_selected_year")))
          ),     
          DT::dataTableOutput(ns("datatablenearpoints"),width='100%')                                        
  )}




#' plot duplicates server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' 
#' @return nothing


plotduplicatesServer <- function(id,globaldata){
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
                                       .con = globaldata$pool)
                     # https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
                     # it seems that dbgetquery doesn't raise an error
                     out_data <- dbGetQuery(globaldata$pool, query)
                     return(out_data)
                     
                   })
                 
                 # store data in reactive values ---------------------------------------------------------------
                 
                 observeEvent(mysource_graph(), tryCatch({               
                   data <- mysource_graph() %>% arrange(eel_emu_nameshort,eel_year)
                   rvs$datagr <- data                           
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 # plot -------------------------------------------------------------------------------------------
                 # the plots groups by kept (typ id = 1,2,4) or not (other typ_id) and year 
                 # and calculate thenumber of values 
                 
                 output$duplicated_ggplot <- renderPlot({
                   validate(need(globaldata$connectOK,"No connection"))
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
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreNULL = TRUE) # additional arguments to observe ...
               }
               )
}