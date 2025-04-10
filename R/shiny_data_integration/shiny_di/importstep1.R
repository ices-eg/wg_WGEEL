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
									actionButton(ns("check_duplicate_button"), "Check duplicate")),
							column(width=2,                        
									actionButton(ns("clean_output"), "Clean Output"))),
					box(fluidRow(
							column(width=5,
									h3("Duplicated data"),
									htmlOutput(ns("step1_message_duplicates")),
									DT::dataTableOutput(ns("dt_duplicates")),
									h3("Updated data"),
									htmlOutput(ns("step1_message_updated")),
									DT::dataTableOutput(ns("dt_updated_values")),
									h3("Deleted data"),
									htmlOutput(ns("step1_message_deleted")),
									DT::dataTableOutput(ns("dt_deleted_values"))),
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
									DT::dataTableOutput(ns("dt_missing")))), collapsible=TRUE, width=12)
			
			))
}



#' Step 1 of annex 4-10 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data data from step 0
#'
#' @return nothing


importstep1Server <- function(id,globaldata, loaded_data){
	moduleServer(id,
			function(input, output, session) {
				
				observeEvent(input$clean_output,
						{
							
							shinyCatch({ 
										output$dt_duplicates<-renderDataTable(data.frame())
										output$dt_check_duplicates<-renderDataTable(data.frame())
										output$dt_new<-renderDataTable(data.frame())
										output$dt_missing<-renderDataTable(data.frame())
										output$dt_updated_values <- renderDataTable(data.frame())
										output$dt_deleted_values <- renderDataTable(data.frame())
										if ("updated_values_table" %in% names(globaldata)) {
											globaldata$updated_values_table<-data.frame()
										}
										if ("deleted_values_table" %in% names(globaldata)) {
											globaldata$deleted_values_table<-data.frame()
										}
									}) #shinyCatch
						})
				##################################################
				# Events triggerred by step1_button
				###################################################      
				##########################
				# When check_duplicate_button is clicked
				# this will render a datatable containing rows
				# with duplicates values
				#############################
				
				observeEvent(input$check_duplicate_button,
						{ #browser() #you can put browser here
							shinyCatch({ 
										shinybusy::show_modal_spinner(text = "Checking File", color="#337ab7",spin="fading-circle")
										# see step0load_data returns a list with res and messages
										# and within res data and a dataframe of errors
										validate(
												need(length(loaded_data$res) > 0, "Please select a data set")
										) 
                    
										data_from_excel    <- loaded_data$res$data
                    updated_from_excel <- loaded_data$res$updated_data
                    deleted_from_excel <- loaded_data$res$deleted_data
                    
										switch (loaded_data$file_type, "catch_landings"={                                     
													data_from_base <- extract_data("landings", quality=c(0,1,2,3,4), quality_check=TRUE)											
												},
												"release"={
													data_from_base <-extract_data("release", quality=c(0,1,2,3,4), quality_check=TRUE)
												},
												"aquaculture"={             
													data_from_base <- extract_data("aquaculture", quality=c(0,1,2,3,4), quality_check=TRUE)
												},
												"biomass"={
                          data_from_base <- rbind(
                              extract_data("b0", quality=c(0,1,2,3,4), quality_check=TRUE),
                              extract_data("bbest", quality=c(0,1,2,3,4), quality_check=TRUE),
                              extract_data("bcurrent", quality=c(0,1,2,3,4), quality_check=TRUE),
                              extract_data("bcurrent_without_stocking", quality=c(0,1,2,3,4), quality_check=TRUE)) %>% 
                              rename_with(function(x) tolower(gsub("biom_", "", x)), starts_with("biom_"))
												},
												"mortality_rates"={						
													data_from_base<-rbind(
															extract_data("sigmaa", quality=c(0,1,2,3,4), quality_check=TRUE),
															extract_data("sigmaf", quality=c(0,1,2,3,4), quality_check=TRUE),
															extract_data("sigmah", quality=c(0,1,2,3,4), quality_check=TRUE))%>% 
															rename_with(function(x) tolower(gsub("mort_", "", x)),
																	starts_with("biom_"))
												}                
										)
										# the compare_with_database function will compare
										# what is in the database and the content of the excel file
										# previously loaded. It will return a list with two components
										# the first duplicates contains elements to be returned to the user
										# the second new contains a dataframe to be inserted straight into
										# the database
										#cat("step0")
										if (nrow(data_from_excel)>0){
											# this select eel type names 4 6 
											data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")] <- paste(data_from_excel$eel_typ_name[data_from_excel$eel_typ_name %in% c("rec_landings","com_landings")],"_kg",sep="")
											
											eel_typ_valid <- switch(loaded_data$file_type,
													"biomass"=c(13:15,34),
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
											  if (nrow(duplicates)>0){
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
																						filename = paste0("duplicates_",
																						                  ifelse(loaded_data$file_type == 'catch_landings',
																						                         unique(duplicates$eel_typ_name),
																						                         loaded_data),
																						                  "_",
																						                  Sys.Date(),
																						                  current_cou_code))) 
																))
											  } else {
											    datatable()
											  }
														
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
														if (nrow(new >0)) {
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
																						filename = paste0("new_",
																						                  ifelse(loaded_data$file_type == 'catch_landings',
																						                         unique(new$eel_typ_name),
																						                         loaded_data$file_type),
																						                  "_",
																						                  Sys.Date(),
																						                  current_cou_code))) 
																))} else{
																  datatable(data.frame())
																}
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
											
											
										} else {
											output$dt_new <- DT::renderDataTable({validate(need(FALSE,"No data"))})
											output$dt_duplicates <- DT::renderDataTable({validate(need(FALSE,"No data"))})
											current_cou_code <- ""
										}# closes if nrow(...  
										
										if (loaded_data$file_type %in% c("catch_landings","release", "aquaculture", "biomass","mortality_rates" )){
											
											if (nrow(updated_from_excel)>0){
												output$"step1_message_updated"<-renderUI(
														HTML(
																paste(
																		h4("Table of updated values (xls)"),
																		"<p align='left'>Please click on excel",
																		"to download this file. <p>"                         
																)))                 
												globaldata$updated_values_table <- compare_with_database_updated_values(updated_from_excel,data_from_base) 
												if (nrow(globaldata$updated_values_table)==0) stop("step1 compare_wih_database_updated_values did not return any values")
												  output$dt_updated_values <- DT::renderDataTable({
												    if (nrow(globaldata$updated_values_table) > 0){
												      datatable(  
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
												                 filename = paste0("updated_",
												                                   ifelse(loaded_data$file_type == 'catch_landings',
												                                          unique(globaldata$updated_values_table$eel_typ_name),
												                                          loaded_data$file_type),
												                                   "_",
												                                   Sys.Date(),
												                                   current_cou_code))) 
												        )) 
												    } else {
												      datatable(data.frame())
												    }}
												  )
												
											}else{
												output$"step1_message_updated" <- renderUI("No data")
											} 
											
											if (nrow(deleted_from_excel)>0){
												output$"step1_message_deleted"<-renderUI(
														HTML(
																paste(
																		h4("Table of deleted values (xls)"),
																		"<p align='left'>Please click on excel",
																		"to download this file. <p>"                         
																))) 
                        
												globaldata$deleted_values_table <- compare_with_database_deleted_values(deleted_from_excel,data_from_base) 
												output$dt_deleted_values <- DT::renderDataTable({
												  if (nrow(globaldata$deleted_values_table) > 0){
														datatable(globaldata$deleted_values_table,
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
																				filename = paste0("deleted_",
																				                  ifelse(loaded_data$file_type == 'catch_landings',
																				                         data_from_excel$eel_typ_name,
																				                         loaded_data$file_type),
																				                  "_",
																				                  Sys.Date(),
																				                  current_cou_code))) 
														))
												    }else {
												      datatable(data.frame())
												    }})
											}else{
												output$"step1_message_deleted"<-renderUI("No data")
											}
										}
										if (exists("years")){
											summary_check_duplicates=data.frame(years=years,
													nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
													nb_duplicates_updated=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls | duplicates$eel_missvaluequal.base != duplicates$eel_missvaluequal.xls )))),
													nb_duplicates_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls | duplicates$eel_missvaluequal.base == duplicates$eel_missvaluequal.xls)))),
													nb_updated_values=sapply(years, function(y) length(which(updated_from_excel$eel_year==y))),
													nb_deleted_values=sapply(years,function(y) length(which(deleted_from_excel$eel_year==y))))
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
										}
										#data$new <- new # new is stored in the reactive dataset to be inserted later.      
									}) # shiny catch
									shinybusy::remove_modal_spinner()
						} ,# expr for browser
						ignoreInit = TRUE)
				
			})
}
