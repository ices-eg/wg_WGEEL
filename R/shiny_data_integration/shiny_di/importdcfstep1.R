#' Step 1 of annex dcf integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
#' 
#' 


importdcfstep1UI <- function(id){
	ns <- NS(id)
	tagList(useShinyjs(),
			tags$hr(),
			h2("step 1 : Compare with database"),								
			fluidRow(                                       
					column(width=2,                        
							actionButton(ns("check_duplicate_button_dcf"), "Check duplicate")), 
					column(width=5,
							h3("new sampling"),
							htmlOutput(ns("step1_message_new_sampling")),
							DT::dataTableOutput(ns("dt_new_sampling")),
							h3("new grouped metrics"),
							htmlOutput(ns("step1_message_new_grouped_metrics")),
							DT::dataTableOutput(ns("dt_new_grouped_metrics")),
							h3("new individual metrics"),
							htmlOutput(ns("step1_message_new_individual_metrics")),
							DT::dataTableOutput(ns("dt_new_individual_metrics"))
					),
					column(width=5,
							h3("modified sampling"),
							htmlOutput(ns("step1_message_modified_sampling")),
							DT::dataTableOutput(ns("dt_modified_sampling")),	
							h3("modified sampling : what changed ?"),
							DT::dataTableOutput(ns("dt_highlight_change_sampling")),
							h3("modified grouped metrics"),	
							DT::dataTableOutput(ns("dt_modified_grouped_metrics")),
							htmlOutput(ns("step1_message_modified_grouped_metrics")),
							h3("modified grouped metrics : what changed ?"),
							DT::dataTableOutput(ns("dt_highlight_change_grouped_metric")),	
							h3("modified individual metrics"),	
							DT::dataTableOutput(ns("dt_modified_individual_metrics")),
							htmlOutput(ns("step1_message_modified_individual_metrics")),
							h3("modified individual metrics : what changed ?"),
							DT::dataTableOutput(ns("dt_highlight_change_individual_metric"))	
					
					)
			)
	)
}




#' Step 1 of annex 1-3 integration
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @param loaded_data_cdf data from step0
#'
#' @return loaded data and file type


importdcfstep1Server <- function(id,globaldata,loaded_data_dcf){
	moduleServer(id,
			function(input, output, session) {
				
				observe({
							loaded_data_dcf$res
							tryCatch({
										
										##################################################
										# clean up
										#################################################						
										
										
										output$step1_message_new_sampling <- renderText("")
										output$dt_new_sampling <- renderDataTable(data.frame(),
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
										
										output$step1_message_modified_sampling  <- renderText("")
										output$dt_modified_sampling <- renderDataTable(
												data.frame(),
												options = list(searching = FALSE,paging = FALSE,
														language = list(zeroRecords = "Not run yet")))  
										
										output$dt_highlight_change_sampling <- renderDataTable(
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
										
									},
									error = function(e) {
										showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
									})})
				
				
				
				##################################################
				# Events triggered by step1_button TIME sampling
				###################################################
				##########################
				# When check_duplicate_button is clicked
				# this will render a datatable containing rows
				# with duplicates values
				#############################
				observeEvent(input$check_duplicate_button_dcf, {
							tryCatch({
										
										
										# see step0load_data returns a list with res and messages
										# and within res data and a dataframe of errors
										validate(
												need(length(loaded_data_dcf$res) > 0, "Please select a data set")
										)
										validate(need(globaldata$connectOK,"No connection"))
										res <- isolate(loaded_data_dcf$res)
										sampling <- res$sampling_info
										new_group_metrics <- res$new_group_metrics
										updated_group_metrics <- res$updated_group_metrics
										deleted_group_metrics <- res$deleted_group_metrics
										new_individual_metrics <- res$new_individual_metrics
										updated_individual_metrics <- res$updated_individual_metrics
										deleted_individual_metrics <- res$deleted_individual_metrics
										
										
										# bis_sai_id is missing from excel so I'm reloading it
										if (nrow(new_group_metrics)>0){
											new_group_metrics <-  left_join(new_group_metrics, t_samplinginfo_sai[,c("sai_id","sai_name")], by="sai_name")
											new_group_metrics <- rename(new_group_metrics,"grsai_sai_id"="sai_id") # use the true name in the table
										}
										
										if (nrow(new_individual_metrics)>0){
											new_individual_metrics <- left_join(new_individual_metrics, t_samplinginfo_sai[,c("sai_id","sai_name")], by="sai_name")
											new_individual_metrics <- rename(new_individual_metrics,"fisa_sai_id"="sai_id")
										}						
										
										
										t_groupsamp_grsa <- extract_data("t_groupsamp_grsa", quality_check=FALSE)
										t_fishsamp_fisa <- extract_data("t_fishsamp_fisa", quality_check=FALSE)
										t_metricgroupsamp_megsa <- extract_data("t_metricgroupsamp_megsa", quality_check=FALSE)
										t_metricindsamp_meisa <- extract_data("t_metricindsamp_meisa", quality_check=FALSE)
										
										validate(need(nrow(sampling)>0, "No sampling info, cannot continue"))
										list_comp_sampling <- compare_with_database_sampling(data_from_excel=sampling, data_from_base=t_samplinginfo_sai)
										current_cou_code <- list_comp_sampling$current_cou_code
										
										
										
										if (nrow(new_group_metrics)>0){
											list_comp_new_group_metrics <- compare_with_database_metric_group(data_from_excel=new_group_metrics, data_from_base=t_metricgroupsamp_megsa, sheetorigin="new_group_metrics")
										}
										
										if (nrow(updated_group_metrics)>0){
											list_comp_updated_group_metrics <- compare_with_database_metric_group(
													data_from_excel=updated_group_metrics, 
													data_from_base=t_metricgroupsamp_megsa, 
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
										}
										if (nrow(deleted_group_metrics)>0){
											list_comp_deleted_group_metrics <- compare_with_database_metric_group(
													data_from_excel=deleted_group_metrics,
													data_from_base=t_metricgroupsamp_megsa,
													sheetorigin="deleted_group_metrics")
										}
										
										if (nrow(new_individual_metrics)>0){
											list_comp_individual_metrics <- 
													compare_with_database_metric_ind(
															data_from_excel=new_individual_metrics, 
															data_from_base=t_metricindsamp_meisa, 
															sheetorigin="new_individual_metrics")
										}
										
										if (nrow(updated_individual_metrics)>0){
											list_comp_updated_individual_metrics <- 
													compare_with_database_metric_ind(
															data_from_excel=updated_individual_metrics, 
															data_from_base=t_metricindsamp_meisa, 
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
										}
										if (nrow(deleted_individual_metrics)>0){
											list_comp_deleted_individual_metrics <- compare_with_database_metric_ind(
													data_from_excel=deleted_individual_metrics,
													data_from_base=t_metricindsamp_meisa,
													sheetorigin="deleted_individual_metrics")
										}
										
										
										#cat("step1")
										# step1 new sampling -------------------------------------------------------------
										
										if (nrow(list_comp_sampling$new)==0) {
											output$step1_message_new_sampling <- renderUI(
													HTML(
															paste(
																	h4("No new sampling info")
															)))
											
											output$dt_new_sampling <- renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											
											
										} else {
											output$"step1_message_new_sampling"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of new values (sampling) (xls)"),
																			"<p align='left'>Please click on excel ",
																			"to download this file and eventually qualify your data with columns <strong>qal_id, qal_comment</strong> ",
																			"once this is done download the file with button <strong>download new</strong> and proceed to next step.",
																			"<strong>Do this before integrating datasampling.</strong><p>"
																	)))
											)
											output$dt_new_sampling <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_sampling$new,
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
																		autoWidth = TRUE,
																		columnDefs = list(list(width = '200px', targets = c(4, 8))),
																		buttons=list(
																				list(extend="excel",
																						filename = paste0("new_sampling_",loaded_data_dcf$file_type, "_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										# step1 new group_metrics -------------------------------------------------------------
										
										if (!exists("list_comp_group_metrics") || nrow(list_comp_group_metrics$new)==0) {
											output$step1_message_new_group_metrics <- renderUI(
													HTML(
															paste(
																	h4("No new group_metrics")
															)))
											output$dt_new_group_metrics <-  renderDataTable(data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No group_metrics")))
											
											
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
																						filename = paste0("new_group_metrics_",loaded_data_dcf$file_type,"_",Sys.Date(),"_",current_cou_code)))
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
											output$"step1_message_new_individual_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of new values (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_new_individual_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_individual_metrics$new,
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
																						filename = paste0("new_individual_metrics_",loaded_data_dcf$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
										# step1 modified sampling -------------------------------------------------------------
										
										if (nrow(list_comp_sampling$modified)==0) {
											output$step1_message_modified_sampling<-renderUI(
													HTML(
															paste(
																	h4("No modified sampling")
															)))
											
											output$dt_modified_sampling <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No data")))
											
											output$dt_highlight_change_sampling <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No change")))											
											
										} else {
											output$step1_message_modified_sampling<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified sampling (data) (xls)"),
																			"<p align='left'>Please click on excel <p>"
																	)))
											)
											output$dt_modified_sampling <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_sampling$modified,
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
																						filename = paste0("modified_sampling_",loaded_data_dcf$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
											output$dt_highlight_change_sampling <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_sampling$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = "500px",
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1,
																		scrollX = T
																))
													})
										}
										
										
										# step1 modified group_metrics -------------------------------------------------------------
										
										if ((!exists("list_comp_group_metrics")) || nrow(list_comp_group_metrics$modified)==0) {
											
											output$"step1_message_modified_group_metrics"<-renderUI(
													HTML(
															paste(
																	h4("No modified group_metrics")
															)))
											
											output$dt_modified_group_metrics <- renderDataTable(
													data.frame(),
													options = list(searching = FALSE,paging = FALSE,
															language = list(zeroRecords = "No modified group_metrics")))
											
										} else {
											output$"step1_message_modified_group_metrics"<-renderUI(
													HTML(
															paste(
																	paste(
																			h4("Table of modified group_metrics (data) (xls)"),
																			"<p align='left'> This is the file to import ",
																			"Please click on excel<p>"
																	)))
											)
											
											
											
											# NO renderUI
											
											output$dt_modified_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_group_metrics$modified,
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
																						filename = paste0("modified_group_metrics_",loaded_data_cdf$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
											
											
											output$dt_highlight_change_group_metrics <-DT::renderDataTable({
														validate(need(globaldata$connectOK,"No connection"))
														datatable(list_comp_group_metrics$highlight_change,
																rownames=FALSE,
																option=list(
																		scroller = TRUE,
																		scrollX = TRUE,
																		scrollY = "500px",
																		lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
																		"pagelength"=-1
																))
													})
										}
										if ((!exists("list_comp_individual_metrics")) || nrow(list_comp_individual_metrics$modified)==0) {
											
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
																						filename = paste0("modified_individual_metrics_",loaded_data_cdf$file_type,"_",Sys.Date(),"_",current_cou_code)))
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
																						filename = paste0("deleted_group_metrics_",loaded_data_cdf$file_type,"_",Sys.Date(),"_",current_cou_code)))
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
																						filename = paste0("deleted_individual_metrics_",loaded_data_cdf$file_type,"_",Sys.Date(),"_",current_cou_code)))
																))
													})
										}
									},error = function(e) {
										showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
									})}, ignoreInit = TRUE)
			}
	
	)
}