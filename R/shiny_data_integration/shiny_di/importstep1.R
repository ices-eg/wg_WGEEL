#' Step 1 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importstep1UI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          tags$hr(),
          h2("step 1 : Compare with database"),
          fluidRow(
            fluidRow(column(width=2,                        
                            actionButton(ns("check_duplicate_button"), "Check duplicate")) ),
            fluidRow(
              column(width=5,
                     h3("Duplicated data"),
                     htmlOutput(ns("step1_message_duplicates")),
                     DT::dataTableOutput(ns("dt_duplicates")),
                     h3("Updated data"),
                     htmlOutput(ns("step1_message_updated")),
                     DT::dataTableOutput(ns("dt_updated_values"))),
              column(width=5,
                     h3("New values"),
                     htmlOutput(ns("step1_message_new")),
                     DT::dataTableOutput(ns("dt_new")))),
            fluidRow(
              column(width=5,
                     h3("Summary modifications"),
                     DT::dataTableOutput(ns("dt_check_duplicates"))),
              column(width=5,
                     h3("summary still missing"),
                     DT::dataTableOutput(ns("dt_missing"))))
            
          ))
}



#' Step 1 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param data a reactive value with global variable
#' @param loaded_data data from step 0
#'
#' @return nothing


importstep1Server <- function(id,globaldata, loaded_data){
  moduleServer(id,
               function(input, output, session) {
                 
                 observe({
                   loaded_data
                   tryCatch({
                   output$dt_duplicates<-renderDataTable(data.frame())
                   output$dt_check_duplicates<-renderDataTable(data.frame())
                   output$dt_new<-renderDataTable(data.frame())
                   output$dt_missing<-renderDataTable(data.frame())
                   output$dt_updated_values <- renderDataTable(data.frame())
                   if ("updated_values_table" %in% names(globaldata)) {
                     globaldata$updated_values_table<-data.frame()
                   }
                 },error = function(e) {
                   showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
                 })})
                 ##################################################
                 # Events triggerred by step1_button
                 ###################################################      
                 ##########################
                 # When check_duplicate_button is clicked
                 # this will render a datatable containing rows
                 # with duplicates values
                 #############################
                 observeEvent(input$check_duplicate_button, tryCatch({ 

                   # see step0load_data returns a list with res and messages
                   # and within res data and a dataframe of errors
                   validate(
                     need(!is.null(loaded_data$res), "Please select a data set")
                   ) 
                   data_from_excel<- loaded_data$res$data
                   switch (loaded_data$file_type, "catch_landings"={                                     
                     data_from_base<-extract_data("landings", quality=c(0,1,2,3,4), quality_check=TRUE)
                     updated_from_excel<- loaded_data$res$updated_data
                   },
                   "release"={
                     data_from_base<-extract_data("release", quality=c(0,1,2,3,4), quality_check=TRUE)
                     updated_from_excel<- step0load_data()$res$updated_data
                   },
                   "aquaculture"={             
                     data_from_base<-extract_data("aquaculture", quality=c(0,1,2,3,4), quality_check=TRUE)},
                   "biomass"={
                     # bug in excel file - fixed in the template
                     #colnames(data_from_excel)[colnames(data_from_excel)=="typ_name"]<-"eel_typ_name"
                     data_from_excel$eel_lfs_code <- 'S' #always S
                     data_from_excel$eel_hty_code <- 'AL' #always AL
                     data_from_excel <- data_from_excel %>% 
                       rename_with(function(x) tolower(gsub("biom_", "", x)),
                                   starts_with("biom_")) %>%
                       mutate_at(vars(starts_with("perc_")), function(x) as.numeric(ifelse(x=='NP','-1',x)))
                     data_from_excel$eel_area_division <- as.vector(rep(NA,nrow(data_from_excel)),"character")
                     data_from_base<-rbind(
                       extract_data("b0", quality=c(0,1,2,3,4), quality_check=TRUE),
                       extract_data("bbest", quality=c(0,1,2,3,4), quality_check=TRUE),
                       extract_data("bcurrent", quality=c(0,1,2,3,4), quality_check=TRUE)) 
                     data_from_base <- data_from_base %>% 
                       rename_with(function(x) tolower(gsub("biom_", "", x)),
                                   starts_with("biom_"))
                   },
                   "potential_available_habitat"={
                     data_from_base<-extract_data("potential_available_habitat", quality=c(0,1,2,3,4), quality_check=TRUE)                  
                   },
                   # mortality in silver eel equivalent
                   "silver_eel_equivalents"={
                     data_from_base<-extract_data("silver_eel_equivalents", quality=c(0,1,2,3,4), quality_check=TRUE)      
                     
                   },
                   "mortality_rates"={
                     data_from_excel$eel_lfs_code <- 'S' #always S
                     data_from_excel$eel_hty_code <- 'AL' #always AL
                     data_from_excel <- data_from_excel %>% 
                       rename_with(function(x) tolower(gsub("mort_", "", x)),
                                   starts_with("mort_")) %>%
                       mutate_at(vars(starts_with("perc_")), function(x) as.numeric(ifelse(x=='NP','-1',x)))
                     data_from_excel$eel_area_division <- as.vector(rep(NA,nrow(data_from_excel)),"character")
                     data_from_base<-rbind(
                       extract_data("sigmaa", quality=c(0,1,2,3,4), quality_check=TRUE),
                       extract_data("sigmaf", quality=c(0,1,2,3,4), quality_check=TRUE),
                       extract_data("sigmah", quality=c(0,1,2,3,4), quality_check=TRUE))
                     data_from_base <- data_from_base %>% 
                       rename_with(function(x) tolower(gsub("mort_", "", x)),
                                   starts_with("biom_"))
                   }                
                   )
                   # the compare_with_database function will compare
                   # what is in the database and the content of the excel file
                   # previously loaded. It will return a list with two components
                   # the first duplicates contains elements to be returned to the use
                   # the second new contains a dataframe to be inserted straight into
                   # the database
                   #cat("step0")
                   if (nrow(data_from_excel)>0){
                     ###TEMPORARY FIX 2020 due to incorrect typ_name
                     data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")] <- paste(data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")],"_kg",sep="")
                     
                     eel_typ_valid <- switch(loaded_data$file_type,
                                             "biomass"=13:15,
                                             "mortality_rates"=17:25)
                     list_comp<-compare_with_database(data_from_excel,data_from_base,eel_typ_valid)
                     duplicates <- list_comp$duplicates
                     new <- list_comp$new 
                     current_cou_code <- list_comp$current_cou_code
                     #cat("step1")
                     #####################      
                     # Duplicates values
                     #####################
                     
                     if (nrow(duplicates)==0) {
                       output$"step1_message_duplicates"<-renderUI(
                         HTML(
                           paste(
                             h4("No duplicates")                             
                           )))                 
                     }else{      
                       output$"step1_message_duplicates"<-renderUI(
                         HTML(
                           paste(
                             h4("Table of duplicates (xls)"),
                             "<p align='left'>Please click on excel",
                             "to download this file. In <strong>keep new value</strong> choose true",
                             "to replace data using the new datacall data (true)",
                             "if new is selected don't forget to qualify your data in column <strong> eel_qal_id.xls, eel_qal_comment.xls </strong>",
                             "once this is done download the file and proceed to next step.",
                             "Rows with false will be ignored and kept as such in the database",
                             "Rows with true will use the column labelled .xls for the new insertion, and flag existing values as removed ",
                             "If you see an error in old data, use panel datacorrection (on top of the application), this will allow you to make changes directly in the database <p>"                         
                           )))  
                     }
                     
                     # table of number of duplicates values per year (hilaire)
                     
                     years=sort(unique(c(duplicates$eel_year,new$eel_year)))
                     
                     output$dt_duplicates <-DT::renderDataTable({
                       validate(need(globaldata$connectOK,"No connection"))
                       datatable(duplicates,
                                 rownames=FALSE,                                                    
                                 extensions = "Buttons",
                                 option=list(
                                   rownames = FALSE,
                                   scroller = TRUE,
                                   scrollX = TRUE,
                                   scrollY = "500px",
                                   order=list(3,"asc"),
                                   lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                                   "pagelength"=-1,
                                   dom= "Blfrtip",
                                   buttons=list(
                                     list(extend="excel",
                                          filename = paste0("duplicates_",loaded_data$file_type,"_",Sys.Date(),current_cou_code))) 
                                 ))
                       
                     })
                     
                     if (nrow(new)==0) {
                       output$"step1_message_new"<-renderUI(
                         HTML(
                           paste(
                             h4("No new values")                             
                           )))                    
                     } else {
                       output$"step1_message_new"<-renderUI(
                         HTML(
                           paste(
                             h4("Table of new values (xls)"),
                             "<p align='left'>Please click on excel ",
                             "to download this file and qualify your data with columns <strong>qal_id, qal_comment</strong> ",
                             "once this is done download the file with button <strong>download new</strong> and proceed to next step.<p>"                         
                           )))  
                       
                     }
                     
                     output$dt_new <-DT::renderDataTable({ 
                       validate(need(globaldata$connectOK,"No connection"))
                       datatable(new,
                                 rownames=FALSE,          
                                 extensions = "Buttons",
                                 option=list(
                                   scroller = TRUE,
                                   scrollX = TRUE,
                                   scrollY = "500px",
                                   order=list(3,"asc"),
                                   lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                                   "pagelength"=-1,
                                   dom= "Blfrtip",
                                   scrollX = T, 
                                   buttons=list(
                                     list(extend="excel",
                                          filename = paste0("new_",loaded_data$file_type,"_",Sys.Date(),current_cou_code))) 
                                 ))
                     })
                     ######
                     #Missing data
                     ######
                     if (loaded_data$file_type == "catch_landings" & nrow(list_comp$complete)>0) {
                       output$dt_missing <- DT::renderDataTable({
                         validate(need(globaldata$connectOK,"No connection"))
                         check_missing_data(list_comp$complete, new)
                       })
                     }
                     
                     
                   } # closes if nrow(...  
                   if (loaded_data$file_type %in% c("catch_landings","release")){
                     if (nrow(updated_from_excel)>0){
                       output$"step1_message_updated"<-renderUI(
                         HTML(
                           paste(
                             h4("Table of updated values (xls)"),
                             "<p align='left'>Please click on excel",
                             "to download this file. <p>"                         
                           ))) 
                       globaldata$updated_values_table <- compare_with_database_updated_values(updated_from_excel,data_from_base) 
                       output$dt_updated_values <- DT::renderDataTable(
                         globaldata$updated_values_table,
                         rownames=FALSE,
                         extensions = "Buttons",
                         option=list(
                           scroller = TRUE,
                           scrollX = TRUE,
                           scrollY = "500px",
                           order=list(3,"asc"),
                           lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                           "pagelength"=-1,
                           dom= "Blfrtip",
                           scrollX = T, 
                           buttons=list(
                             list(extend="excel",
                                  filename = paste0("updated_",loaded_data$file_type,"_",Sys.Date(),current_cou_code))) 
                         ))
                     }else{
                       output$"step1_message_updated"<-renderUI("")
                     } 
                   }
                   if (loaded_data$file_type %in% c("catch_landings","release")){
                     summary_check_duplicates=data.frame(years=years,
                                                         nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
                                                         nb_duplicates_updated=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
                                                         nb_duplicates_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))),
                                                         nb_updated_values=sapply(years, function(y) length(which(updated_from_excel$eel_year==y))))
                   } else {
                     summary_check_duplicates=data.frame(years=years,
                                                         nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
                                                         nb_duplicates_updated=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
                                                         nb_duplicates_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))))
                   }
                   
                   output$dt_check_duplicates <-DT::renderDataTable({ 
                     validate(need(globaldata$connectOK,"No connection"))
                     datatable(summary_check_duplicates,
                               rownames=FALSE,                                                    
                               options=list(dom="t",
                                            rownames = FALSE,
                                            scroller = TRUE,
                                            scrollX = TRUE,
                                            scrollY = "500px"
                               ))
                   })
                   #data$new <- new # new is stored in the reactive dataset to be inserted later.      
                 },error = function(e) {
                   showNotification(paste("Error: ", e$message), type = "error",duration=NULL)
                 }))
           
               })
}
          