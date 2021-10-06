#' add new participants
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 
newparticipantsUI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          h2("Enter the name of a new participant"),
          fluidRow(
            column(width=10,textInput(ns("new_participants_id"), "Enter the name of the new participant (FirstName LastName)",
                                      value=""
            )),
            column(width=2,  actionButton(inputId=ns("new_participants_ok"), label="Validate"))
          ),
          
          fluidRow(
            column(width=10,
                   htmlOutput(ns("new_participants_txt"))
            ))
  )}




#' add new participants, server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#'
#' @return a list of participants


newparticipantsServer <- function(id,globaldata){
  moduleServer(id,
               function(input, output, session) {
                 res <- reactiveValues(participants = NULL)
                 observeEvent(input$new_participants_ok,{
                   tryCatch({
                     validate(need(globaldata$connectOK,"No connection"))
                     validate(need(nchar(input$new_participants_id)>0,"need a participant name"))
                     message <- write_new_participants(input$new_participants_id)
                     output$new_participants_txt <- renderText({message}) 
                     # updatePickerInput(session=session,"main_assessor",choices=participants)
                     # updatePickerInput(session=session,"secondary_assessor",choices=participants)
                     res$participants <- participants
                   },error = function(e) {
                     showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                   })})
                 
                 return(res)
                 
               }
  )
}