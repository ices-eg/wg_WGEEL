#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importtsstep2UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          tags$hr(),
          tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: red;  color:black}
    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}
  ")),
          tabsetPanel(id= ns("tsstep2panel"), selected="SERIES",
                      tabPanel("SERIES",value="SERIES",
                               h2("step 2.1.1 Integrate new series"),
                               dataWriterModuleUI(ns("integratenewseries"), "xls new series, do this first and re-run compare"),
                               h2("step 2.1.2 Update modified series"),
                               dataWriterModuleUI(ns("integrateupdatedseries"), "xls updated series, do this first and re-run compare")),
                      tabPanel("DATASERIES", value="DATASERIES",
                               h2("step 2.2.1 Delete from data"),
                               dataWriterModuleUI(ns("deletedataseries"), "Once the series are deleted please re-run the integration"),
                               h2("step 2.2.2 Integrate new data"),
                               dataWriterModuleUI(ns("integratenewdas"), "Once the series are updated, integrate new dataseries"),
                               h2("step 2.2.3 Update modified data"),
                               dataWriterModuleUI(ns("integrateupdatedas"), "Update the modified dataseries")),
                      tabPanel("GROUP METRICS", value="GROUP METRICS",
                               h2("step 2.3.1 Delete from group metrics"),
                               dataWriterModuleUI(ns("deletegroupmetrics"), "Delete using deleted group metrics file"),
                               h2("step 2.3.2 Integrate new group metrics"),
                               dataWriterModuleUI(ns("integratenewgroupmetrics"), "Write new group metrics file"),
                               h2("step 2.3.3 Update group metrics"),
                               dataWriterModuleUI(ns("updatedgroupmetricseries"), "Update the modified group metrics")),
                      tabPanel("INDIVIDUAL METRICS", value="INDIVIDUAL METRICS",
                               h2("step 2.4.1 Delete from individual metrics"),
                               dataWriterModuleUI(ns("deletedindmetricseries"), "Delete using deleted individual metrics file"),
                               h2("step 2.4.2 Integrate new individual metrics"),
                               dataWriterModuleUI(ns("newindmetricseries"), "Write new individual metrics file"),
                               h2("step 2.4.3 Update individual metrics"),
                               dataWriterModuleUI(ns("updatedindmetricseries"), "Update the modified individual metrics file")))
          
  )
}




#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_ts data from step0
#'
#' @return loaded data and file type


importtsstep2Server <- function(id,globaldata,loaded_data_ts,globaltspanel){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 mytspanel <- reactiveValues(tspanel="SERIES")
                 observe({mytspanel <- reactiveValues(tspanel=globaltspanel$tspanel)
                 updateTabsetPanel(session, "tsstep2panel",
                                   selected = globaltspanel$tspanel)
                 })
                 observeEvent(input$tsstep2panel,{
                   if (isolate(input$tsstep2panel) != isolate(mytspanel$tspanel))
                     mytspanel$tspanel <- input$tsstep2panel
                 })               
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data_ts$res
                   shinyCatch({
                     output$textoutput_step2.1_ts <- renderText("")
                     
                     reset("xl_new_series")
                     reset("xl_updated_series")
                     reset("xl_new_dataseries")
                     reset("xl_updated_dataseries")
                     reset("xl_deleted_dataseries")
                     
                     output$"textoutput_step2.1.1_ts" <- renderText("")
                     output$"textoutput_step2.1.2_ts" <- renderText("")
                     output$"textoutput_step2.2.1_ts" <- renderText("")
                     output$"textoutput_step2.2.2_ts" <- renderText("")
                     output$"textoutput_step2.2.3_ts" <- renderText("")
                     
                     
                     
                     
                   })
                 })
                 
                 
                 
                 
                 # 2.1.1 new series  --------------------------------------------------------
                 
                 dataWriterModuleServer("integratenewseries", loaded_data_ts,globaldata,  write_new_series,"new series integration")
                 	
                 
                 # 2.1.2 updated series  --------------------------------------------------------
                 dataWriterModuleServer("integrateupdatedseries", loaded_data_ts,globaldata,  update_series, "update series")

                 # 2.2.1 deleted dataseries  --------------------------------------------------------							
                 dataWriterModuleServer("deletedataseries", loaded_data_ts,globaldata,  delete_dataseries, "deleted dataseries", delete=TRUE)
                 

                 # 2.2.2 new dataseries  --------------------------------------------------------							
                 
                 dataWriterModuleServer("integratenewdas", loaded_data_ts,globaldata,  write_new_dataseries,"new dataseries integration")

                 # 2.2.3 update modified dataseries  --------------------------------------------------------							
                 
                 dataWriterModuleServer("integrateupdatedas", loaded_data_ts,globaldata,  update_dataseries,"update dataseries")
                 
                 
                 # 2.3.1 deleted group metrics series  --------------------------------------------------------							
                 dataWriterModuleServer("deletegroupmetrics", loaded_data_ts,globaldata,  delete_group_metrics,"write new group_metrics",delete=TRUE,type="series")
                 
                 # 2.3.2 Integrate new group metrics series  --------------------------------------------------------							
                 dataWriterModuleServer("integratenewgroupmetrics", loaded_data_ts,globaldata,  write_new_group_metrics,"write new group_metrics",type="series")

                 # 2.3.3 update modified group metrics  --------------------------------------------------------							
                 dataWriterModuleServer("updatedgroupmetricseries", loaded_data_ts,globaldata,  write_updated_group_metrics,"update group_metrics",type="series")

                 # 2.4.1 Deleted individual metrics --------------------------------------------------------							
                 dataWriterModuleServer("deletedindmetricseries", loaded_data_ts,globaldata,  delete_individual_metrics,"deleted individual_metrics", delete=TRUE, type="series")

                 # 2.4.2 Integrate new individual metrics --------------------------------------------------------							
                 dataWriterModuleServer("newindmetricseries", loaded_data_ts,globaldata,  write_new_individual_metrics_proceed,"write new individual_metrics",type="series")

                 
                 # 2.4.3 updated individual metrics  --------------------------------------------------------							
                 dataWriterModuleServer("updatedindmetricseries", loaded_data_ts,globaldata,  write_updated_individual_metrics,"update individual_metrics",type="series")
                 
                 return(mytspanel)
                 
               }
               
  )
}