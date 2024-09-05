#' Step 2 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importstep2UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
      tags$hr(),
      h2("step 2.1 Integrate/ proceed duplicates rows"),
      dataWriterModuleUI(ns("integrateduplicates"), "xls duplicates"),
      h2("step 2.2 Integrate new rows"),
      dataWriterModuleUI(ns("integratenew"), "xls new"),
      h2("step 2.3 Updated values"),
      dataWriterModuleUI(ns("integrateupdated"), "xls updated"),
      h2("step 2.4 Delete values"),
      dataWriterModuleUI(ns("integratedeleted"), "xls deleted")
  )
}




#' Step 2 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data data from step 0
#' 
#' @return nothing


importstep2Server <- function(id,globaldata, loaded_data){
  moduleServer(id,
      function(input, output, session) {
        ##########################
        # STEP 2.1
        # When database_duplicates_button is clicked
        # this will trigger the data integration
        #############################         
        # this step only starts if step1 has been launched    
        
        data <- reactiveValues()
        dataWriterModuleServer("integrateduplicates", loaded_data, globaldata,  write_duplicates,"write duplicates", qualify_code = qualify_code)

        ##########################
        # STEP 2.2
        # When database_new_button is clicked
        # this will trigger the data integration
        #############################   
        dataWriterModuleServer("integratenew", loaded_data, globaldata,  write_new,"new data integration")
        

        
        ##########################
        # STEP 2.3
        # Integration of updated_values when proceed is clicked
        # 
        #############################
        
        dataWriterModuleServer("integrateupdated", loaded_data, globaldata,  write_updated_values, "updated values data integration", qualify_code = qualify_code)
        

        ##########################
        # STEP 2.4
        # Integration of deleted_values when proceed is clicked
        # 
        #############################
        dataWriterModuleServer("integratedeleted", loaded_data, globaldata,  write_deleted_values, "deleted values data integration", delete = TRUE, qualify_code = qualify_code)
        
      })
}



