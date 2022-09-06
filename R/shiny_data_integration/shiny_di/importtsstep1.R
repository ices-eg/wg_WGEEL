#' Step 1 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importtsstep1UI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			tags$hr(),
			h2("step 1 : Compare with database"),								
			fluidRow(
					fluidRow(                                       
							column(width=2,                        
									actionButton(ns("check_duplicate_button_ts"), "Check duplicate")),
							column(width=2,                        
									actionButton(ns("clean_output"), "Clean Output"))),
					fluidRow(
							column(width=6,
									h3("new series"),
									htmlOutput(ns("step1_message_new_series")),
									DT::dataTableOutput(ns("dt_new_series")),
									h3("new dataseries"),
									htmlOutput(ns("step1_message_new_dataseries")),
									DT::dataTableOutput(ns("dt_new_dataseries")),
									h3("new group metrics"),
									htmlOutput(ns("step1_message_new_group_metrics")),
									DT::dataTableOutput(ns("dt_new_group_metrics")),
									h3("new individual metrics"),
									htmlOutput(ns("step1_message_new_individual_metrics")),
									DT::dataTableOutput(ns("dt_new_individual_metrics")),
									uiOutput(ns("button_new_individual_metrics")),
									#downloadButton(ns("btn_down_indiv_metrics"), label = "Download Indiv metrics", icon = icon("table")),
									h3("deleted dataseries"),
									DT::dataTableOutput(ns("dt_deleted_dataseries")),
									h3("deleted group metrics"),
									DT::dataTableOutput(ns("dt_deleted_group_metrics")),
									h3("deleted individual metrics"),
									DT::dataTableOutput(ns("dt_deleted_individual_metrics"))
							),
							column(width=6,
									h3("modified series"),
									htmlOutput(ns("step1_message_modified_series")),
									DT::dataTableOutput(ns("dt_modified_series")),	
									h3("modified series : what changed at series level ?"),
									DT::dataTableOutput(ns("dt_highlight_change_series")),
									h3("modified dataseries"),
									htmlOutput(ns("step1_message_modified_dataseries")),
									DT::dataTableOutput(ns("dt_modified_dataseries")),
									h3("modified dataseries : what changed for new_data and updated_data ?"),	
									DT::dataTableOutput(ns("dt_highlight_change_dataseries")),
									h3("modified group metrics"),	
									DT::dataTableOutput(ns("dt_modified_group_metrics")),
									htmlOutput(ns("step1_message_modified_group_metrics")),
									h3("modified group metrics : what changed ?"),
									DT::dataTableOutput(ns("dt_highlight_change_group_metrics")),
									h3("modified individual metrics"),	
									DT::dataTableOutput(ns("dt_modified_individual_metrics")),
									htmlOutput(ns("step1_message_modified_individual_metrics")),
									h3("modified individual metrics : what changed ?"),
									DT::dataTableOutput(ns("dt_highlight_change_individual_metrics"))
							)
					)
			)
	)
}




#' Step 1 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_ts data from step0
#'
#' @return loaded data and file type


importtsstep1Server <- function(id,globaldata,loaded_data_ts){
	moduleServer(id,
			function(input, output, session) {
				
				observeEvent(input$clean_output,
							shinyCatch({
										
										##################################################
										# clean up
										#################################################						
										
										
										output$step1_message_new_series <- renderText("")
										output$dt_new_series <- renderDataTable(data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))  
										
										output$step1_message_new_dataseries <- renderText("")
										output$dt_new_dataseries <- renderDataTable(data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))  
										
										output$step1_message_new_group_metrics <- renderText("")
										output$dt_new_group_metrics <- renderDataTable(data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))  
										
										output$step1_message_new_individual_metrics <- renderText("")
										output$dt_new_individual_metrics <- renderDataTable(data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet"))) 
										
										output$step1_message_modified_series  <- renderText("")
										output$dt_modified_series <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))  
										output$dt_highlight_change_series <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))   
										
										
										output$step1_message_modified_dataseries <- renderText("")
										output$dt_modified_dataseries <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))    
										output$dt_highlight_change_dataseries <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))   
										
										
										output$step1_message_modified_group_metrics  <- renderText("") 
										
										output$dt_modified_group_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet"))) 
										
										output$dt_highlight_change_group_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))   
										
										output$step1_message_modified_individual_metrics  <- renderText("") 
										
										output$dt_modified_individual_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet"))) 
										
										output$dt_highlight_change_individual_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))   
										
										output$step1_message_deleted_dataseries <- renderText("")
										
										output$dt_deleted_dataseries <- renderDataTable(data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet"))) 
										
										output$step1_message_deleted_group_metrics  <- renderText("") 
										output$dt_deleted_group_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))   
										
										output$step1_message_deleted_individual_metrics  <- renderText("") 
										
										output$dt_deleted_individual_metrics <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet"))) 
										
									})
						)
				
				
				
				##################################################
				# Events triggered by step1_button TIME SERIES
				###################################################
				##########################
				# When check_duplicate_button is clicked
				# this will render a datatable containing rows
				# with duplicates values
				#############################
				observeEvent(input$check_duplicate_button_ts, {
							
							shinyCatch({
										shinybusy::show_modal_spinner(text = "Checking File", color="darkgreen",spin="fading-circle")
										
										# see step0load_data returns a list with res and messages
										# and within res data and a dataframe of errors
										
										validate(
												need(length(loaded_data_ts$res) > 0, "Please select a data set")
										)
										validate(need(globaldata$connectOK,"No connection"))
										res <- isolate(loaded_data_ts$res)
										series <- res$series
										station	<- res$station
										new_data	<- res$new_data
										updated_data	<- res$updated_data
										deleted_data <- res$deleted_data
										new_group_metrics <- res$new_group_metrics
										updated_group_metrics <- res$updated_group_metrics
										deleted_group_metrics <- res$deleted_group_metrics
										new_individual_metrics <- res$new_individual_metrics
										updated_individual_metrics <- res$updated_individual_metrics
										deleted_individual_metrics <- res$deleted_individual_metrics
										t_series_ser <- res$t_series_ser
										#suppressWarnings(t_series_ser <- extract_data("t_series_ser",  quality_check=FALSE))
										
										new_data <- left_join(new_data, t_series_ser[,c("ser_id","ser_nameshort")], by="ser_nameshort")
										new_data <- rename(new_data,"das_ser_id"="ser_id")
										
										if (nrow(new_group_metrics)>0){
											new_group_metrics <-  left_join(new_group_metrics, t_series_ser[,c("ser_id","ser_nameshort")], by="ser_nameshort")
											new_group_metrics <- rename(new_group_metrics,"grser_ser_id"="ser_id") # use the true name in the table
										}
										
										if (nrow(new_individual_metrics)>0){
											new_individual_metrics <- left_join(new_individual_metrics, t_series_ser[,c("ser_id","ser_nameshort")], by="ser_nameshort")
											new_individual_metrics <- rename(new_individual_metrics,"fiser_ser_id"="ser_id")
										}										
										
										
										t_dataseries_das <- extract_data("t_dataseries_das", quality_check=FALSE)
										t_groupseries_grser <- extract_data("t_groupseries_grser", quality_check=FALSE)
										t_fishseries_fiser <- extract_data("t_fishseries_fiser", quality_check=FALSE)
										t_metricgroupseries_megser <- extract_data("t_metricgroupseries_megser", quality_check=FALSE)
										t_metricindseries_meiser <- extract_data("t_metricindseries_meiser", quality_check=FALSE)
										
										switch (loaded_data_ts$file_type,
												"glass_eel"={
													t_series_ser <- t_series_ser %>%  filter(ser_typ_id==1)
													t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
													t_groupseries_grser <-  t_groupseries_grser %>% filter (grser_ser_id %in% t_series_ser$ser_id)
													t_fishseries_fiser <-  t_fishseries_fiser %>% filter (fiser_ser_id %in% t_series_ser$ser_id)
													t_metricgroupseries_megser <- t_metricgroupseries_megser%>% 
															inner_join(t_groupseries_grser, by = c("meg_gr_id" = "gr_id") ) %>%
															filter (grser_ser_id %in% t_series_ser$ser_id) %>% rename("gr_id"="meg_gr_id")	%>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("grser_ser_id"="ser_id")) 
													t_metricindseries_meiser <- t_metricindseries_meiser%>%
															inner_join(t_fishseries_fiser, by = c("mei_fi_id" = "fi_id") ) %>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("fiser_ser_id"="ser_id")) %>% 
															filter (fiser_ser_id %in% t_series_ser$ser_id) %>% 
															rename("fi_id"="mei_fi_id")		
												},
												"yellow_eel"={
													t_series_ser <- t_series_ser %>%  filter(ser_typ_id==2)
													t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
													t_groupseries_grser <-  t_groupseries_grser %>% filter (grser_ser_id %in% t_series_ser$ser_id)
													t_fishseries_fiser <-  t_fishseries_fiser %>% filter (fiser_ser_id %in% t_series_ser$ser_id)
													t_metricgroupseries_megser <- t_metricgroupseries_megser%>% 
															inner_join(t_groupseries_grser, by = c("meg_gr_id" = "gr_id") ) %>%
															filter (grser_ser_id %in% t_series_ser$ser_id) %>% rename("gr_id"="meg_gr_id") %>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("grser_ser_id"="ser_id")) 			
													t_metricindseries_meiser <- t_metricindseries_meiser%>%
															inner_join(t_fishseries_fiser, by = c("mei_fi_id" = "fi_id") ) %>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("fiser_ser_id"="ser_id")) %>% 
															filter (fiser_ser_id %in% t_series_ser$ser_id) %>% 
															rename("fi_id"="mei_fi_id")		
													
												},
												"silver_eel"={
													t_series_ser <- t_series_ser %>%  filter(ser_typ_id==3)
													t_dataseries_das <- t_dataseries_das %>% filter (das_ser_id %in% t_series_ser$ser_id)
													t_groupseries_grser <-  t_groupseries_grser %>% filter (grser_ser_id %in% t_series_ser$ser_id)
													t_fishseries_fiser <-  t_fishseries_fiser %>% filter (fiser_ser_id %in% t_series_ser$ser_id)
													t_metricgroupseries_megser <- t_metricgroupseries_megser%>% 
															inner_join(t_groupseries_grser, by = c("meg_gr_id" = "gr_id") ) %>%
															filter (grser_ser_id %in% t_series_ser$ser_id) %>% rename("gr_id"="meg_gr_id")	 %>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("grser_ser_id"="ser_id")) 		
													t_metricindseries_meiser <- t_metricindseries_meiser%>%
															inner_join(t_fishseries_fiser, by = c("mei_fi_id" = "fi_id") ) %>%
															inner_join(t_series_ser %>% select(ser_nameshort, ser_id), by=c("fiser_ser_id"="ser_id")) %>% 
															filter (fiser_ser_id %in% t_series_ser$ser_id) %>% 
															rename("fi_id"="mei_fi_id")		
													
												}
										)
										# the compare_with_database function will compare
										# what is in the database and the content of the excel file
										# previously loaded. It will return a list with two components
										# the first duplicates contains elements to be returned to the use
										# the second new contains a dataframe to be inserted straight into
										# the database
										#cat("step0")
								
										if (nrow(series)>0){
											list_comp_series <- compare_with_database_series(data_from_excel=series, data_from_base=t_series_ser)
										}
										if (nrow(new_data)>0){
											list_comp_dataseries <- compare_with_database_dataseries(data_from_excel=new_data, 
													data_from_base=t_dataseries_das, 
													sheetorigin="new_data")
										} 
										
										
										if (nrow(deleted_data)>0){
											list_comp_deleted_dataseries <- compare_with_database_dataseries(data_from_excel=deleted_data, 
													data_from_base=t_dataseries_das, 
													sheetorigin="deleted_data")
										} else {
											list_comp_deleted_dataseries <- list("deleted"= data.frame())
										}
										
										if (nrow(updated_data)>0){
											list_comp_updateddataseries <- compare_with_database_dataseries(data_from_excel=updated_data, 
													data_from_base=t_dataseries_das, 
													sheetorigin="updated_data")
											# to avoid binding column type error
											if (nrow(new_data)>0){
												if (nrow(list_comp_updateddataseries$new)>0 & nrow(list_comp_dataseries$new)>0) {
													list_comp_dataseries$new <- bind_rows(list_comp_dataseries$new,	list_comp_updateddataseries$new)
												} else  if (nrow(list_comp_dataseries$new)==0)  {
												  list_comp_dataseries$new <- list_comp_updateddataseries$new
												}
												if (nrow(list_comp_updateddataseries$modified)>0 & nrow(list_comp_dataseries$modified)>0) {
													list_comp_dataseries$modified <- bind_rows(list_comp_dataseries$modified,list_comp_updateddataseries$modified)
												}  else  if (nrow(list_comp_dataseries$modified)==0)  {
												  list_comp_dataseries$modified <- list_comp_updateddataseries$modified
												}
												if (nrow(list_comp_dataseries$highlight_change)>0 & nrow(list_comp_updateddataseries$highlight_change)>0){
													list_comp_dataseries$highlight_change <- bind_rows(list_comp_dataseries$highlight_change,
															list_comp_updateddataseries$highlight_change)
												} else if (nrow(list_comp_dataseries$highlight_change) == 0){
													  list_comp_dataseries$highlight_change <- list_comp_updateddataseries$highlight_change
												}
												# note highlight change is not passed from one list to the other, both will be shown
											} else {
												list_comp_dataseries$new <- list_comp_updateddataseries$new
												list_comp_dataseries$modified <- list_comp_updateddataseries$modified
												list_comp_dataseries$highlight_change <- list_comp_updateddataseries$highlight_change
											}
										}	else {
											list_comp_updateddataseries <- list()
											list_comp_updateddataseries$error_id_message <- "" # this message would have been displayed if pb of id
										}
										
										if (nrow(new_group_metrics)>0){
											list_comp_group_metrics <- compare_with_database_metric_group(
													data_from_excel=new_group_metrics,
													data_from_base=t_metricgroupseries_megser, 
													sheetorigin="new_group_metrics")
										}  else {
											list_comp_group_metrics <- list(new=data.frame())
										}
										#browser()
										if (nrow(updated_group_metrics)>0){
											list_comp_updated_group_metrics <- compare_with_database_metric_group(
													data_from_excel=updated_group_metrics,
													data_from_base=t_metricgroupseries_megser,
													sheetorigin="updated_group_metrics")
											if (nrow(new_group_metrics)>0){
												# when integrating the id must be different so I'm adding the max of id in news, 
												# later they will be used to differentiate groups when writing, and we don't want to mix up 
												# groups from new and from updated sheets
												mxn <- max(list_comp_group_metrics$new$id, na.rm=TRUE)
												mxm <- max(list_comp_group_metrics$modified, na.rm=TRUE)
												list_comp_updated_group_metrics$new$id <- list_comp_updated_group_metrics$new$id + mxn
												list_comp_updated_group_metrics$modified$id <- list_comp_updated_group_metrics$modified$id + mxm
												list_comp_group_metrics$new <- bind_rows(list_comp_group_metrics$new,list_comp_updated_group_metrics$new)
												list_comp_group_metrics$modified <- bind_rows(list_comp_group_metrics$modified,list_comp_updated_group_metrics$modified)
												if (nrow(list_comp_group_metrics$highlight_change)>0){
													list_comp_group_metrics$highlight_change <- bind_rows(list_comp_group_metrics$highlight_change,
															list_comp_updated_group_metrics$highlight_change)
												} else {
													list_comp_group_metrics$highlight_change <- list_comp_updated_group_metrics$highlight_change
												}
												# note highlight change is not passed from one list to the other, both will be shown
											} else {
												list_comp_group_metrics$new <- list_comp_updated_group_metrics$new
												list_comp_group_metrics$modified <- list_comp_updated_group_metrics$modified
												list_comp_group_metrics$highlight_change <- list_comp_updated_group_metrics$highlight_change
											}
										} else {
											if (!"modified" %in% names(list_comp_group_metrics)) {
												list_comp_group_metrics$modified <- data.frame()
												list_comp_group_metrics$highlight_change <- data.frame()
											}
										}
										
										if (nrow(deleted_group_metrics)>0){
											list_comp_deleted_group_metrics <- compare_with_database_metric_group(
													data_from_excel=deleted_group_metrics,
													data_from_base=t_metricgroupseries_megser,
													sheetorigin="deleted_group_metrics")
										} else {
											list_comp_deleted_group_metrics <- list("deleted"=data.frame())
										}
										
										if (nrow(new_individual_metrics)>0){
											list_comp_individual_metrics <- 
													compare_with_database_metric_ind(
															data_from_excel=new_individual_metrics, 
															data_from_base=t_metricindseries_meiser, 
															sheetorigin="new_individual_metrics")
										} 	else {
											list_comp_individual_metrics <- list("new"=data.frame())
										}	 
										
										if (nrow(updated_individual_metrics)>0){
											list_comp_updated_individual_metrics <- 
													compare_with_database_metric_ind(
															data_from_excel=updated_individual_metrics, 
															data_from_base=t_metricindseries_meiser, 
															sheetorigin="updated_individual_metrics")
											if (nrow(new_individual_metrics)>0){
												mxn <- max(list_comp_individual_metrics$new$id, na.rm=TRUE)
												mxm <- max(list_comp_individual_metrics$modified, na.rm=TRUE)
												list_comp_updated_individual_metrics$new$id <- list_comp_updated_individual_metrics$new$id + mxn
												list_comp_updated_individual_metrics$modified$id <- list_comp_updated_individual_metrics$modified$id + mxm
												list_comp_individual_metrics$new <- bind_rows(list_comp_individual_metrics$new,list_comp_updated_individual_metrics$new)
												
												list_comp_individual_metrics$new <- bind_rows(list_comp_individual_metrics$new,list_comp_updated_individual_metrics$new)
												list_comp_individual_metrics$modified <- bind_rows(list_comp_individual_metrics$modified,list_comp_updated_individual_metrics$modified)
												if (nrow(list_comp_individual_metrics$highlight_change)>0){
													list_comp_individual_metrics$highlight_change <- bind_rows(list_comp_individual_metrics$highlight_change,
															list_comp_updated_individual_metrics$highlight_change)
												} else {
													list_comp_individual_metrics$highlight_change <- list_comp_updated_individual_metrics$highlight_change
												}
												# note highlight change is not passed from one list to the other, both will be shown
											} else {
												list_comp_individual_metrics$new <- list_comp_updated_individual_metrics$new
												list_comp_individual_metrics$modified <- list_comp_updated_individual_metrics$modified
												list_comp_individual_metrics$highlight_change <- list_comp_updated_individual_metrics$highlight_change
											}
										}		 else {
											if (!"modified" %in% names(list_comp_individual_metrics)) {
												list_comp_individual_metrics$modified <- data.frame()
												list_comp_individual_metrics$highlight_change <- data.frame()
											}
										}
										
										if (nrow(deleted_individual_metrics)>0){
											list_comp_deleted_individual_metrics <- compare_with_database_metric_ind(
													data_from_excel=deleted_individual_metrics,
													data_from_base=t_metricindseries_meiser,
													sheetorigin="deleted_individual_metrics")
										} 	else {
											list_comp_deleted_individual_metrics <- list("deleted" = data.frame())
										}
										
										current_cou_code <- list_comp_series$current_cou_code
										
										#cat("step1")
										# step1 new series -------------------------------------------------------------
										
										if ( nrow(list_comp_series$new)==0) {
											output$step1_message_new_series <- renderUI(
													HTML(
															paste(
																	h4("No new series")
															)))
											
											output$dt_new_series <- renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											
											
										} else {
											output$"step1_message_new_series"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of new values (series) (xls)"),
																			"<p align='left'>Please click on excel ",
																			"to download this file and eventually qualify your data with columns <strong>qal_id, qal_comment</strong> ",
																			"once this is done download the file with button <strong>download new</strong> and proceed to next step.",
																			"<strong>Do this before integrating dataseries.</strong><p>"
																	)))
											)
											output$dt_new_series <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_series$new,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		autoWidth = TRUE,
																		columnDefs = list(list(width = '200px', targets = c(4, 8))),
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("new_series_",loaded_data_ts$file_type, "_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										# step1 new dataseries -------------------------------------------------------------
										if (nrow(list_comp_dataseries$new)==0) {
											output$"step1_message_new_dataseries"<-renderUI(
													HTML(
															paste(
																	h4("No new data")
															)))
											
											output$dt_new_dataseries <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											
										} else {
											output$"step1_message_new_dataseries"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of new values (data) (xls)"),
																			list_comp_updateddataseries$error_id_message,
																			"<p align='left'>Please click on excel ",
																			"Data may come from new_data or updated_data (error)",
																			" Series should have been <strong>updated</strong> before getting data <p>"
																	)))
											)
											output$dt_new_dataseries <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_dataseries$new,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		autoWidth = TRUE,
																		columnDefs = list(list(width = '200px', targets = c(4, 8))),
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("new_dataseries_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										# step1 new group_metrics -------------------------------------------------------------
										
										if (nrow(list_comp_group_metrics$new)==0) {
											output$step1_message_new_group_metrics <- renderUI(
													HTML(
															paste(
																	h4("No new group metrics")
															)))
											output$dt_new_group_metrics <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No group metrics")))
											
											
										} else {
											output$"step1_message_new_group_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of new values (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_new_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_group_metrics$new,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scrollX = TRUE,
																		scrollY = TRUE,
																		"pagelength"=-1,
																		dom= "Blfrtip",																		
																		buttons=list(
																				list(extend="colvis",
																						targets = 0, 
																						visible = FALSE),
																				list(extend="excel",
																						filename = paste0("new_group_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										
										# step1 new individual_metrics -------------------------------------------------------------
										
										if (nrow(list_comp_individual_metrics$new)==0) {
											output$step1_message_new_individual_metrics <- renderUI(
													HTML(
															paste(
																	h4("No new individual metrics")
															)))
											output$dt_new_individual_metrics <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No individual metrics")))
											
											
										} else {
											# In some cases there are too many rows
											# so the app crashes here I put a button generated on the server side to download data 
											# instead of using DT
											limitDT <- 1000
											if (nrow(list_comp_individual_metrics$new)<limitDT){
												
												output$"step1_message_new_individual_metrics"<-renderUI(
														HTML(
																paste(
																		paste(
																				h4("Table of new values (data) (xls)"),
																				"<p align='left'>Please click on excel button <p>"
																		)))
												)
												# here with server =FALSE (default is TRUE) data sent to the client, all can be downloaded
												# here with server =FALSE (default is TRUE) data is kept on the server side
												output$dt_new_individual_metrics <-DT::renderDataTable(server = FALSE,{
															validate(need(globaldata$connectOK,"No connection"))
															datatable(list_comp_individual_metrics$new,
																	rownames=FALSE,
																	extensions = c("Buttons", "Scroller"),																
																	option=list(
																			scrollX = TRUE,
																			scrollY = TRUE,
																			paging = TRUE, # necessary for scroller
																			deferRender = TRUE, # defer render helps with large datasets
																			dom = 'lBfrtip',
																			fixedColumns = TRUE,
																			searching= FALSE,																		
																			buttons=list(
																					# will allow column choice button
																					list(extend="colvis",
																							targets = 0, 
																							visible = FALSE),
																					list(extend="excel",
																							# modifier = list(page = "all"), I don't think that this is necessary
																							filename = paste0("new_individual_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)
																					)
																			)
																	))
														})
											} else {
												output$"step1_message_new_individual_metrics"<-renderUI(
														HTML(
																paste(
																		paste(
																				h4(" WARNING data nrow>", limitDT, "You have been busy mmmm ?"),
																				"<p align='left'>Too many lines all is kept on the server side <p>",
																				"<p align='left'>Click on the `Download Indiv metrics` button below the table <p>"
																		
																		)))
												)
												# only allow server side option and no download
												output$dt_new_individual_metrics <- DT::renderDataTable(server = TRUE,{
															validate(need(globaldata$connectOK,"No connection"))
															datatable(list_comp_individual_metrics$new,
																	rownames=FALSE,
																	extensions = c("Buttons", "Scroller"),																
																	option=list(
																			scrollX = TRUE,
																			scrollY = TRUE,
																			paging = TRUE, # necessary for scroller
																			deferRender = TRUE, # defer render helps with large datasets
																			dom = 'lBfrtip',
																			fixedColumns = TRUE,
																			searching= TRUE,																		
																			buttons=list(
																					# will allow column choice button
																					list(extend="colvis",
																							targets = 0, 
																							visible = FALSE)																		
																			)
																	))
														}) # end renderDataTable
												# generate a button dynamically on the server side
												output$"button_new_individual_metrics" <- renderUI({
															ns <- NS(id)
															downloadButton(ns("btn_down_indiv_metrics"), label = "Download Indiv metrics", icon = icon("table"))
															
														})
												
												output$btn_down_indiv_metrics <- downloadHandler(
														filename = function(){
															paste0("new_individual_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code,".xlsx")
														},											
														content = function(file) {
															write_xlsx(as.data.frame(list_comp_individual_metrics$new), file)
														}
												)
												
												
											}
										}
# step1 modified series -------------------------------------------------------------
										
										if (nrow(list_comp_series$modified)==0) {
											output$step1_message_modified_series<-renderUI(
													HTML(
															paste(
																	h4("No modified series")
															)))
											
											output$dt_modified_series <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											output$dt_highlight_change_series <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No change")))
											
											
										} else {
											output$step1_message_modified_series<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified series (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_modified_series <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_series$modified,
																rownames=FALSE,
																extensions = c("Buttons", "Scroller"),																
																option=list(
																		scrollX = TRUE,
																		scrollY = TRUE,
																		paging = TRUE, # necessary for scroller
																		deferRender = TRUE,
																		dom = 'lBfrtip',
																		fixedColumns = TRUE,
																		searching= FALSE,																		
																		buttons=list(
																				list(extend="colvis",
																						targets = 0, 
																						visible = FALSE),
																				list(extend="excel",
																						filename = paste0("modified_series_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
											output$dt_highlight_change_series <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_series$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		scrollX = T
																))
													})
										}
										
# step1 modified dataseries -------------------------------------------------------------
										
										if ( nrow(list_comp_dataseries$modified)==0) {
											output$"step1_message_modified_dataseries"<-renderUI(
													HTML(
															paste(
																	h4("No modified dataseries")
															)))
											
											output$dt_modified_dataseries <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											output$dt_highlight_change_dataseries <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No change from newdata")))
											
											
										} else {
											output$"step1_message_modified_dataseries"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified dataseries (data) (xls)"),
																			"<p align='left'> This is the file to import ",
																			"Data may come from new_data (error) or updated_data",
																			"Please click on excel<p>"
																	)))
											)
											output$dt_modified_dataseries <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_updateddataseries$modified,
														           rownames=FALSE,
														           extensions = "Buttons",
														           option=list(
														             # scroller = TRUE,
														             scrollX = TRUE,
														             scrollY = TRUE,
														            order=list(3,"asc"),
														            lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
														            "pagelength"=-1,
														            dom= "Blfrtip",
														            autoWidth = TRUE,
														            columnDefs = list(list(width = '200px', targets = c(4, 8))),
														            buttons=list(
														              list(extend="excel",
																						filename = paste0("modified_dataseries_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
														 		)
																)
													})
											
											# Data are coming for either updated or new series, they are checked and
											# data from updated and new have been collated
											# but for highlight for change they are kept in each source list to be shown below
											
											output$dt_highlight_change_dataseries <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_dataseries$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		scrollX = T
																))
													})
											
											
										}
										
# step1 modified group metrics -------------------------------------------------------------
										
										if (nrow(list_comp_group_metrics$modified)==0) {
											
											output$"step1_message_modified_group_metrics"<-renderUI(
													HTML(
															paste(
																	h4("No modified  group metrics")
															)))
											
											output$dt_modified_group_metrics <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No modified group metrics")))
											
										} else {
											output$"step1_message_modified_group_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified group metrics (data) (xls)"),
																			"<p align='left'> This is the file to import ",
																			"Please click on excel<p>"
																	)))
											)
											
											output$dt_modified_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_group_metrics$modified,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("modified_group_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
											
											
											output$dt_highlight_change_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_group_metrics$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1
																))
													})										
										}
										
										
										if (nrow(list_comp_individual_metrics$modified)==0) {
											
											output$"step1_message_modified_individual_metrics"<-renderUI(
													HTML(
															paste(
																	h4("No modified individual metrics")
															)))
											
											output$dt_modified_individual_metrics <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No modified individual metrics")))
											
										} else {
											output$"step1_message_modified_individual_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified individual metrics (data) (xls)"),
																			"<p align='left'> This is the file to import ",
																			"Please click on excel<p>"
																	)))
											)
											
											
											output$dt_modified_individual_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_individual_metrics$modified,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("modified_individual_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
											
											
											output$dt_highlight_change_individual_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_individual_metrics$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1
																))
													})
										}
# step1 deleted dataseries -------------------------------------------------------------
										if (nrow(list_comp_deleted_dataseries$deleted)==0) {
											output$"step1_message_deleted_dataseries"<-renderUI(
													HTML(
															paste(
																	h4("No deleted data")
															)))
											
											output$dt_deleted_dataseries <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											
										} else {
											output$"step1_message_deleted_dataseries"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of deleted values (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_deleted_dataseries <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_deleted_dataseries$deleted,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		autoWidth = TRUE,
																		columnDefs = list(list(width = '200px', targets = c(4, 8))),
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("deleted_dataseries_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
# step1 deleted group_metrics -------------------------------------------------------------
										
										if (nrow(list_comp_deleted_group_metrics$deleted)==0) {
											output$step1_message_deleted_group_metrics <- renderUI(
													HTML(
															paste(
																	h4("No deleted group metrics")
															)))
											output$dt_deleted_group_metrics <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No deleted group metrics")))
											
											
										} else {
											output$"step1_message_deleted_group_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of deleted values (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_deleted_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_deleted_group_metrics$deleted,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("deleted_group_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										
# step1 deleted individual_metrics -------------------------------------------------------------
										
										if (nrow(list_comp_deleted_individual_metrics$deleted)==0) {
											output$step1_message_deleted_metrics <- renderUI(
													HTML(
															paste(
																	h4("No deleted individual metrics")
															)))
											output$dt_deleted_individual_metrics <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No deleted individual metrics")))
											
											
										} else {
											output$"step1_message_deleted_individual_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of deleted values (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_deleted_individual_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_deleted_individual_metrics$deleted,
																rownames=FALSE,
																extensions = "Buttons",
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = TRUE,
																		order=list(3,"asc"),
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		dom= "Blfrtip",
																		scrollX = T,
																		buttons=list(
																				list(extend="excel",												
																						filename = paste0("deleted_individual_metrics_",loaded_data_ts$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										
										shinybusy::remove_modal_spinner()	
									}) # shinycatch
						}, ignoreInit = TRUE)
			}
	
	)
}