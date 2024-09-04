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
      fluidRow(
          column(width=4,fileInput(ns("xl_duplicates_file"), "xls duplicates",
                  multiple=FALSE,
                  accept = c(".xls",".xlsx")
              )),                   
          column(width=2,
              actionButton(ns("database_duplicates_button"), "Proceed")),
          column(width=6,verbatimTextOutput(ns("textoutput_step2.1")))
      ),
      h2("step 2.2 Integrate new rows"),
      fluidRow(
          column(width=4,fileInput(ns("xl_new_file"), "xls new",
                  multiple=FALSE,
                  accept = c(".xls",".xlsx")
              )),                   
          column(width=2,
              actionButton(ns("database_new_button"), "Proceed")),
          column(width=6,verbatimTextOutput(ns("textoutput_step2.2")))
      ),
      h2("step 2.3 Updated values"),
      fluidRow(
          column(width=4,fileInput(ns("xl_updated_file"), "xls updated",
                  multiple=FALSE,
                  accept = c(".xls",".xlsx")
              )),
          column(width=6,
              actionButton(ns("database_updated_value_button"), "Proceed"),
              verbatimTextOutput(ns("textoutput_step2.3"))
          )										
      ),
      h2("step 2.4 Delete values"),
      fluidRow(
          column(width=4,fileInput(ns("xl_deleted_file"), "xls deleted",
                  multiple=FALSE,
                  accept = c(".xls",".xlsx")
              )),
          column(width=6,
              actionButton(ns("database_deleted_value_button"), "Proceed"),
              verbatimTextOutput(ns("textoutput_step2.4"))
          )										
      )
  
  
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
        
        observe({loaded_data$res
              tryCatch({
                    output$textoutput_step2.1 <- renderText("")				
                    output$textoutput_step2.2 <- renderText("")
                    output$textoutput_step2.3 <- renderText("")
                    output$integrate <- renderText("")
                    reset("xl_new_file")
                    reset("xl_duplicates_file")
                    output$"textoutput_step2.1" <- renderText("")
                    output$"textoutput_step2.2" <- renderText("")
                    output$"textoutput_step2.3" <- renderText("")
                    
                    
                  },error = function(e) {
                    showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                  })})
        
        
        observeEvent(input$database_duplicates_button, 
            
            tryCatch({ 
                  
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
                    eel_typ_id <- rls$eel_typ_id    
                    message <- rls$message
                    cou_code <- rls$cou_code
                    main_assessor <- input$main_assessor
                    secondary_assessor <- input$secondary_assessor
                    file_type <- input$file_type
                    log_datacall("write duplicates", 
                        cou_code = cou_code, 
                        message = sQuote(message), 
                        file_type = eel_typ_id,  
                        main_assessor = globaldata$main_assessor, 
                        secondary_assessor = globaldata$secondary_assessor)         
                   return(message)
                  }
                  ###########################
                  # errors_duplicates_integration
                  # this will add a path value to reactive data in step0
                  ###########################            
                  output$textoutput_step2.1<-renderText({
                        validate(need(globaldata$connectOK,"No connection"))
                        # call to  function that loads data
                        # this function does not need to be reactive                  
                        message<-step21load_data()                     
                        if (is.null(data$path_step21)) "please select a dataset" else {                                      
                          paste(message,collapse="\n")
                        }                  
                      })              
                },error = function(e) {
                  showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                }), ignoreInit = TRUE) 
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
                eel_typ_id <- rls$eel_typ_id    
                log_datacall(step="new data integration", 
                    cou_code = cou_code, 
                    message = sQuote(message), 
                    file_type = eel_typ_id, 
                    main_assessor = globaldata$main_assessor, 
                    secondary_assessor = globaldata$secondary_assessor)
                return(message)
              }
              ###########################
              # new_data_integration
              # this will add a path value to reactive data in step0
              ###########################            
              output$textoutput_step2.2<-renderText({
                    validate(need(globaldata$connectOK,"No connection"))
                    # call to  function that loads data
                    # this function does not need to be reactive              
                    message<-step22load_data()                
                    if (is.null(data$path_step22)) "please select a dataset" else {                                      
                      paste(message,collapse="\n")
                    }                  
                  })             
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
        
        
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
                        file_type = file_type, main_assessor = globaldata$main_assessor, 
                        secondary_assessor = globaldata$secondary_assessor)
                    return(message)
                  }
                  ###########################
                  # updated_values_integration
                  # this will add a path value to reactive data in step0
                  ###########################            
                  output$textoutput_step2.3<-renderText({
                        validate(need(globaldata$connectOK,"No connection"))
                        # call to  function that loads data
                        # this function does not need to be reactive
                        message<-step23load_updated_value_data()
                        paste(message,collapse="\n")
                      })  
                },error = function(e) {
                  showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                }), ignoreInit = TRUE)
        
        
        
        ##########################
        # STEP 2.4
        # Integration of deleted_values when proceed is clicked
        # 
        #############################
        observeEvent(input$database_deleted_value_button, tryCatch({
                  ###########################
                  # step2_filepath
                  # reactive function, when clicked return value in reactive data 
                  ###########################
                  step24_filepath <- reactive({
                        inFile <- isolate(input$xl_deleted_file)     
                        if (is.null(inFile)){        return(NULL)
                        } else {
                          data$path_step24<-inFile$datapath #path to a temp file             
                        }
                      })
                  
                  ###########################
                  # step24load_deleted_value_data
                  #  function, returns a message
                  #  indicating that data integration was a success
                  #  or an error message
                  ###########################
                  step24load_deleted_value_data <- function() {
                    path <- isolate(step24_filepath())
                    if (is.null(data$path_step24)) 
                      return(NULL)
                    rls <- write_deleted_values(path,qualify_code=qualify_code)
                    message <- rls$message
                    cou_code <- rls$cou_code
                    main_assessor <- input$main_assessor
                    secondary_assessor <- input$secondary_assessor
                    file_type <- input$file_type
                    log_datacall("deleted values data integration", cou_code = cou_code, message = sQuote(message), 
                        file_type = file_type, main_assessor = globaldata$main_assessor, 
                        secondary_assessor = globaldata$secondary_assessor)
                    return(message)
                  }
                  ###########################
                  # deleted_values_integration
                  # this will add a path value to reactive data in step0
                  ###########################            
                  output$textoutput_step2.4<-renderText({
                        validate(need(globaldata$connectOK,"No connection"))
                        # call to  function that loads data
                        # this function does not need to be reactive
                        message<-step24load_deleted_value_data()
                        paste(message,collapse="\n")
                      })  
                },error = function(e) {
                  showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                }), ignoreInit = TRUE)
      })
}



