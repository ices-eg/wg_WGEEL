#' Step 2 of annex 9 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importdcfstep2UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          tags$hr(),
          tabsetPanel(id= ns("dcfstep2panel"), selected="SAMPLINGS",
                      tabPanel("SAMPLINGS",value="SAMPLINGS",
                               h2("step 2.1.1 Integrate new sampling"),
                               dataWriterModuleUI(ns("integratenewsampling"), "xls new sampling, do this first and re-run compare"),
                               
                               h2("step 2.1.2 Update sampling"),
                               dataWriterModuleUI(ns("integrateupdatesampling"), "xls update sampling, do this first and re-run compare")
                               ),
                      tabPanel("GROUP METRICS",value="GROUP METRICS",
                               h2("step 2.2.1 Delete from group metrics"),
                               dataWriterModuleUI(ns("deletedgroupmetricdcf"), "Delete using deleted group metrics file"),
                               h2("step 2.2.2 Integrate new group metrics"),
                               dataWriterModuleUI(ns("newgroupmetricdcf"), "Write new group metrics file"),
                               h2("step 2.2.3 Update group metrics"),
                               dataWriterModuleUI(ns("updatedgroupmetricdcf"), "Update the modified group metrics")
                               ),
                      tabPanel("INDIVIDUAL METRICS",value="INDIVIDUAL METRICS",
                               
                               
                               writedeletedindmetricUI(ns("deletedindmetricdcf"), "step 2.3.1 Delete from individual metrics"),
                               writenewindmetricUI(ns("newindmetricdcf"), "step 2.3.2 Integrate new individual metrics"),
                               writeupdatedindmetricUI(ns("updatedindmetricdcf"), "step 2.3.3 Update individual metrics"))),
          
          
  )
}




#' Step 2 of annex 9 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_dcf data from step0
#'
#' @return loaded data and file type


importdcfstep2Server <- function(id,globaldata,loaded_data_dcf, globaldcfpanel){
  moduleServer(id,
               function(input, output, session) {
                 data <- reactiveValues()
                 mydcfpanel <- reactiveValues(dcfpanel="SERIES")
                 observe({mydcfpanel <- reactiveValues(dcfpanel=globaldcfpanel$dcfpanel)
                 updateTabsetPanel(session, "dcfstep2panel",
                                   selected = globaldcfpanel$dcfpanel)
                 })
                 observeEvent(input$dcfstep2panel,{
                   if (isolate(input$dcfstep2panel) != isolate(mydcfpanel$dcfpanel))
                     mydcfpanel$dcfpanel <- input$dcfstep2panel
                 })
                 observe({
                   
                   ##################################################
                   # clean up
                   #################################################
                   loaded_data_dcf$res
                   tryCatch({
                     output$textoutput_step2.1_dcf <- renderText("")
                     
                     reset("xl_new_sampling")
                     reset("xl_updated_sampling")
                     output$"textoutput_step2.1.1_dcf" <- renderText("")
                     output$"textoutput_step2.1.2_dcf" <- renderText("")
                   },
                   error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 
                   # 2.1.1 new sampling  --------------------------------------------------------
                 dataWriterModuleServer("integratenewsampling", loaded_data_dcf,globaldata,  write_new_sampling, "new sampling integration")
                 

                 # 2.1.2 modified sampling  --------------------------------------------------------
                 dataWriterModuleServer("integrateupdatesampling", loaded_data_dcf,globaldata,  update_sampling, "update sampling")

                 # 2.2.1 deleted group metrics sampling  --------------------------------------------------------							
                 dataWriterModuleServer("deletedgroupmetricdcf", loaded_data_dcf,globaldata,  delete_group_metrics, "deleted group_metrics",delete=TRUE,type="other")

                 
                 # 2.2.2 Integrate new group metrics sampling  --------------------------------------------------------							
                 dataWriterModuleServer("newgroupmetricdcf", loaded_data_dcf,globaldata,  write_new_group_metrics, "write new group_metrics",type="other")

                 
                 # 2.2.3 update modified group metrics  --------------------------------------------------------							
                 dataWriterModuleServer("updatedgroupmetricdcf", loaded_data_dcf,globaldata,  write_updated_group_metrics, "update group_metrics",type="other")

                 # 2.3.1 Deleted individual metrics --------------------------------------------------------							
                 writedeletedindmetricServer("deletedindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
                 
                 # 2.3.2 Integrate new individual metrics --------------------------------------------------------							
                 writenewindmetricServer("newindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
                 
                 # 2.3.3 updated individual metrics  --------------------------------------------------------							
                 writeupdatedindmetricServer("updatedindmetricdcf", globaldata=globaldata,loaded_data=loaded_data_dcf,type="other")
                 
                 return(mydcfpanel)
               }
               
  )
}