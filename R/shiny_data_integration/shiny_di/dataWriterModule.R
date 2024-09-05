dataWriterModuleUI <- function(id, filemessage){
  ns <- NS(id)
  tagList(useShinyjs(),
          fluidRow(
            column(
              width=4,
              fileInput(ns("file"), filemessage,
                        multiple=FALSE,
                        accept = c(".xls",".xlsx"))
            ),
            column(
              width=2,
              actionButton(ns("proceed"), "Proceed")
            ),
            column(
              width=6,
              fluidRow(hidden(actionButton(ns("ok"),"validate?")),
                       hidden(actionButton(ns("cancel"),"cancel"))),
              verbatimTextOutput(ns("message")),
              hidden(dataTableOutput(ns("newind")))
            )
          ))
  
}




#' Step 2 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}



dataWriterModuleServer <- function(id, loaded_data_ts,globaldata, proceedfunction,log_message, delete=FALSE,...){
  moduleServer(id,
               function(input, output, session) {
                 proceedmessage <- ""
                 conn <<- NULL
                 datadb <- data.frame()
                 cou_code <- ""
                 eel_typ_id <- ""
                 
                 data <- reactiveValues()
                 
                 
                 observeEvent(input$ok,{
                   output$newind <- renderDT(data.frame())
                   shinyjs::hide("ok")
                   shinyjs::hide("cancel")
                   shinyjs::hide("newind")
                   tryCatch({
                     dbCommit(conn)
                   }, error = function(e) {
                     proceedmessage <<- e
                     dbRollback(conn)
                     shinybusy::remove_modal_spinner()
                   }, finally = {
                     dbExecute(conn,"drop table if exists new_dataseries_temp ")
                     poolReturn(conn)
                     output$message <- renderText({
                       validate(need(globaldata$connectOK,"No connection"))
                       # call to  function that loads data
                       # this function does not need to be reactive
                       if (is.null(data$path)) "please select a dataset" else {
                         paste(proceedmessage,collapse="\n")
                       }
                     })
                   }
                   )
                   if ("eel_typ_id" %in% names(datadb)) {
                     file_type <- paste("integration eel_typ_id:",
                                        paste(unique(datadb$eel_typ_id),
                                              collapse=","))
                   } else {
                     file_type <- isolate(loaded_data_ts$file_type)
                   }
                   
                   log_datacall(log_message, cou_code = cou_code, message = sQuote(proceedmessage),
                                file_type = file_type, main_assessor = globaldata$main_assessor,
                                secondary_assessor = globaldata$secondary_assessor)

                 })
                 
                 
                 
                 observeEvent(input$cancel,{
                   output$newind <- renderDT(data.frame())
                   shinyjs::hide("ok")
                   shinyjs::hide("cancel")
                   shinyjs::hide("newind")
                   proceedmessage <<- "cancelled by user"
                   dbRollback(conn)
                   dbExecute(conn,"drop table if exists new_dataseries_temp ")
                   poolReturn(conn)
                   output$message <- renderText({
                     validate(need(globaldata$connectOK,"No connection"))
                     # call to  function that loads data
                     # this function does not need to be reactive
                     if (is.null(data$path)) "please select a dataset" else {
                       paste(proceedmessage,collapse="\n")
                     }
                   })
                 })
                 
                 
                 observeEvent(input$proceed,{ 
                   validate(need(!is.null(isolate(input$file)),"needs a file"))
                   shinyjs::show("ok")
                   shinyjs::show("cancel")
                   shinyjs::show("newind")
                   getFilePath <- reactive({
                     inFile <- isolate(input$file)
                     if (is.null(inFile)){        return(NULL)
                     } else {
                       data$path <- inFile$datapath #path to a temp file
                     }
                   })
                   
                   
                   path <- isolate(getFilePath())
                   if (is.null(data$path))
                     return(NULL)
                   conn <<- poolCheckout(pool)
                   dbBegin(conn)
                   proceedmessage <<- ""
                   tryCatch({
                     rls <- proceedfunction(path, conn, ...)
                     datadb <<- rls$datadb
                     cou_code <<- rls$cou_code
                     proceedmessage <<- rls$message
                     output$newind <- renderDT(datadb,
                                               rownames=FALSE,
                                               option=list(
                                                 scroller = TRUE,
                                                 scrollX = TRUE))
                     if (! delete){
                      output$message <- renderPrint({
                        print("this is what will be in the db")
                        print(skim(datadb))
                      })
                     } else {
                       output$message <- renderText("those are the lines that will be deleted")
                     }
                     
                     # showModal(modalDialog(
                     #   dataTableOutput(ns("datadb")),
                     #   footer = tagList(
                     #     actionButton(ns("cancel"),"cancel?"),
                     #     actionButton(ns("ok"),"sure?")
                     #   )
                     # ))
                   }, error = function(e) {
                     shinybusy::remove_modal_spinner()
                     proceedmessage <<- e
                     shinyjs::hide("ok")
                     shinyjs::hide("cancel")
                     shinyjs::hide("newind")
                     dbRollback(conn)
                     poolReturn(conn)
                     output$message <- renderText({
                       validate(need(globaldata$connectOK,"No connection"))
                       # call to  function that loads data
                       # this function does not need to be reactive
                       if (is.null(data$path)) "please select a dataset" else {
                         paste(proceedmessage,collapse="\n")
                       }
                     })
                   })
                   
                   
                 }, ignoreInit = TRUE)	
               }
  )
}

