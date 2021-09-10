##########################################
# shiny data visualisation : server.R
# Authors: lbeaulaton Cedric
###############################################################################

# create server configuration
server = function(input, output, session) {
	# this stops the app when the browser stops
#  session$onSessionEnded(stopApp)
	# A button that stops the application
#  observeEvent(input$close, {
#        js$closeWindow()
#        stopApp()
#      })
	# A reactive dataset
	data<-reactiveValues()
	
	
	
	#####################
	# table text input
	#####################
	output$"table_description"<-renderUI({
				if (input$dataset %in% c("aquaculture","landings")) {
					text <-  paste("<p align='left'>Value in ton <br/>",
							"to download this, use the Excel button </p>")
				} else if (input$dataset == "landings_com_corrected" | input$dataset == "landings_rec_corrected") {
					text <-  paste("<p align='left'>Value in ton, Asterisk (*) represents predicted data<br/>",
							"<p align='left'> Attention, if you are using a table and displaying a group of several stages
									you are probably doing something stupid  <br/>",
							"<p align='left'>To download this, use the Excel button </p>")
				}
				else text =paste("<p align='left'>",
							"to download this, use the Excel button </p>")
				HTML(
						paste(
								h4(paste0("Table for :", input$dataset)),
								text
						)) 
			}) 
	#####################
# table 
	#####################
	
	
	output$table = DT::renderDataTable({
				if (input$dataset=="precodata"){
					filtered_data<-filter_precodata(input$dataset,
							#lfs = input$lfs, 
							country = input$country,
							#habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)
				}else if (input$dataset == "raw_landings_com" | input$dataset == "landings_com_corrected"){
					filtered_data<-filter_data("landings",
							typ = 4,
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
				}else if (input$dataset == "raw_landings_rec" | input$dataset == "landings_rec_corrected"){      
					filtered_data<-filter_data("landings",
							typ = 6,
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
				}else if (input$dataset == "aquaculture_kg"){      
					filtered_data<-filter_data("aquaculture",
							typ = 11,
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
				}  else if (input$dataset == "aquaculture_n"){      
					filtered_data<-filter_data("aquaculture",
							typ = 12,
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
					
				}   else if (input$dataset == "release_kg"){      
					filtered_data<-filter_data("release",
							typ = 8,
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
				}  else if (input$dataset == "release_n"){      
					filtered_data<-filter_data("release",
							typ = 9, 
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]                                      
					)      
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
					
				}  else if (input$dataset == "gee"){      
					filtered_data<-filter_data("release",
							typ = 10,              
							life_stage = input$lfs, 
							country = input$country,
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2]
					
					)      
					
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
					
				} else {
					
					filtered_data <- filter_data(input$dataset, 
							life_stage = input$lfs, 
							country = input$country, 
							habitat = input$habitat,
							year_range = input$year[1]:input$year[2])
					filtered_data<-subset(filtered_data,!is.na(eel_value)) 
				}
				# do not group by habitat or lfs
				if (input$dataset=="precodata"){
					table<-agg_precodata(filtered_data, geo=input$geo,country = input$country,habitat=input$habitat,year_range = input$year[1]:input$year[2])
					# table<-filtered_data
					#filtered_data
					
				} else {
					grouped_data <-group_data(filtered_data,geo=input$geo,habitat=FALSE,lfs=FALSE,na.rm=FALSE)
					
					#TODO:if na.rm=F allow to handle missing value --> create a button
					
					if (input$dataset %in% c("aquaculture_kg","landings","raw_landings_com","raw_landings_rec","landings_com_corrected" , "landings_rec_corrected")) {
						fun.agg<-function(X){if(length(X)>0){round(sum(X)/1000,ifelse(sum(X)>1000,0,3))}else{sum(c(X,NA))}}
						
					} else{
						
						if(input$dataset %in% c("release_n")){
							fun.agg<-function(X){if(length(X)>0){round(sum(X)/10^6,ifelse(sum(X)>10^6,0,3))}else{sum(c(X,NA))}}
							
							
						}else {fun.agg <- function(X){if(length(X)>0){round(sum(X),ifelse(sum(X)>1000,0,1))}else{sum(c(X,NA))}}
						}
					}
					if (input$dataset == "landings_com_corrected" | input$dataset == "landings_rec_corrected"){
						
						validate(need(input$geo=="country","Predictions only done at the country level"))
						validate(need(length(unique(grouped_data$eel_cou_code))>1, "You need at least two country to run the model for predictions"))
						grouped_data$eel_cou_code = as.factor(grouped_data$eel_cou_code)                       
						grouped_data <- predict_missing_values(grouped_data, verbose=FALSE, na.rm=FALSE) 
						
					}
					
					
					switch(input$geo,"country"={
								
								if (input$dataset == "landings_com_corrected" | input$dataset == "landings_rec_corrected"){
									
									table = dcast(grouped_data, eel_year~eel_cou_code, value.var = "eel_value",fun.aggregate = fun.agg)
									table2=dcast(grouped_data, eel_year~eel_cou_code, value.var = "predicted",fun = prod)
									
									
									#ordering the column accordign to country order
									country_to_order = names(table)[-1]
									n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
									n_order <- n_order+1
									n_order <- c(1,n_order)
									table = table[, n_order]
									table2 = table2[, n_order]
									
									#add a column with the sum of all the values and prod of predicted
									
									table<-data.frame(table,sum=rowSums(table[,-1],na.rm = TRUE))
									table2<-data.frame(table2,prod=apply(table2[,-1],1,prod,na.rm = TRUE))
									
									#add a * when the data is predicted
									
									for (col in 2:ncol(table)){
										table[,col][table2[,col]==1]<-paste0(table[,col][table2[,col]==1],"*")
									}
									
									
								}else{
									
									table = dcast(grouped_data, eel_year~eel_cou_code, value.var = "eel_value",fun.aggregate = fun.agg)
									table<-data.frame(table,sum=rowSums(table[,-1],na.rm=T))
									
									
									#ordering the column accordign to country order
									country_to_order = names(table)[-1]
									n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
									n_order <- n_order+1
									n_order <- c(1,n_order)
									table = table[, n_order]
								}
							},
							"emu"={
								table = dcast(grouped_data, eel_year~eel_emu_nameshort, value.var = "eel_value",fun.aggregate = fun.agg)  
								
								#add a column with the sum of all the values
								table<-data.frame(table,sum=rowSums(table[,-1],na.rm=T))
								
								#ordering the column accordign to country order
								country_to_order = names(table)[-1]
								n_order = order(country_ref$cou_order[match(country_to_order, country_ref$cou_code)])
								n_order <- n_order+1
								n_order <- c(1,n_order)
								table = table[, n_order]
							})
				}
	      unit <-switch(input$dataset,
	                    "landings"="ton",
	                    "raw_landings_com"="ton",
	                    "raw_landings_rec"="ton",
	                    "landings_com_corrected"="ton",
	                    "landings_rec_corrected"="ton",
	                    "aquaculture_n"="n",
	                    "aquaculture_kg"="kg",
	                    "release_kg"="kg",
	                    "release_n"="number",
	                    "gee"="glass eel equivalent",
	                    "precodata"="biomasses in tons, mortality rates for the eel lifespan")
	      caption_table <- paste(input$dataset," (",unit,")",sep="")
				DT::datatable(table, 
						rownames = FALSE,
						extensions = c("Buttons","KeyTable"),
						caption=caption_table,
						option=list(
								order=list(0,"asc"),
								scroller = TRUE,
								scrollX = TRUE,
								scrollY = "500px",
								keys = TRUE,
								pageLength = 10,
								columnDefs = list(list(className = 'dt-center')),
								searching = FALSE, # no filtering options
								lengthMenu=list(c(5,10,30,-1),c("5","10","30","All")),                
								dom= "Bltip", # from left to right button left f, t tableau, i informaiton (showing..), p pagination
								buttons=list(
										list(extend="excel",
												filename = paste0("data_",Sys.Date())))
						)) 
				
			})      
	
	
	
	
	######################################"
	# combined landings
	######################################
	get_combined_landings <- eventReactive(input$combined_button,{
				filtered_data <- filter_data("landings", 
						typ = as.numeric(input$combined_landings_eel_typ_id),
						life_stage = input$lfs, 
						country = NULL, 
						habitat = input$habitat,
						year_range = input$year[1]:input$year[2])        
				# do not group by habitat or lfs, there might be several lfs selected but all will be grouped
				landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE,na.rm=FALSE)
				landings$eel_value <- as.numeric(landings$eel_value) / 1000
				landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
				pred_landings <- predict_missing_values(landings, verbose=FALSE) 
				pred_landings <- pred_landings %>%
				  filter(pred_landings$eel_cou_code %in% input$country)
				return(pred_landings)
			})
	
	
	output$graph_combined <-  renderPlot({
				title <- paste("Landings for : ", paste(input$lfs,collapse="+"))
				pred_landings <- get_combined_landings()
				combined_landings_graph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
			})
	
	output$downloadcombined <- downloadHandler(filename = function() {
				paste("combined_landings", input$year[1], "-", input$year[2], ".",input$image_format, sep = "")
			}, content = function(file) {                        
				ggsave(file, combined_landings_graph(dataset=get_combined_landings(),
								title=paste("Landings for : ", paste(input$lfs,collapse="+")),
								col=color_countries, 
								country_ref=country_ref),
						device = input$image_format, width = 20, height = 14, 
						units = "cm")
			})
	
	output$graph_combined_description<-renderUI({
				text0 <- "Predictions on log transformed values by glm. <br/>"
				if (input$geo== "emu") {
					text1 <- "Emu not supported for this graph, switching to country. <br/>"
				} else {
					text1 <-""
				}
				if (length(input$lfs)>1) {
					text2 <- "Attention you are using a prediction model on values grouped on several stages."
				} else {
					text2 <-""
				}
				text <-  paste("<p align='left'>", text0, text1, text2, "<p>")
				HTML(
						paste(
								h4(paste0("Combined Landings Graph for Landings")),
								text
						)) 
			}) 
	
	#######################
	# Available com landings data
	########################
	
	get_available_landings <- eventReactive(input$available_landings_button,{
				filtered_data <- filter_data("landings", 
						typ = as.numeric(input$combined_landings_eel_typ_id),
						life_stage = input$lfs, 
						country = input$country, 
						habitat = input$habitat,
						year_range = input$year[1]:input$year[2])        
				# do not group by habitat or lfs, there might be several lfs selected but all will be grouped
				landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE,na.rm=FALSE)
				landings$eel_value <- as.numeric(landings$eel_value) / 1000
				landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
				pred_landings <- predict_missing_values(landings, verbose=FALSE,na.rm=FALSE) 
				return(pred_landings)
			})
	
	output$graph_available <-  renderPlot({
				title <- paste("Available commercial landings for : ", paste(input$lfs,collapse="+"))
				pred_landings <- get_available_landings()
				aalg<<-AvailableCLandingsGraph(dataset=pred_landings,title=title,col=color_countries, country_ref=country_ref)
				aalg
			})
	
	output$downloadAvailable <- downloadHandler(filename = function() {
				paste("available_landings", input$year[1], "-", input$year[2], ".",input$image_format, sep = "")
			}, content = function(file) {                        
				ggsave(file, aalg,
						device = input$image_format, width = 20, height = 14, 
						units = "cm")
			})
	######################################"
	# raw landings
	######################################
	get_raw_landings <- eventReactive(input$raw_landings_button,{
				filtered_data <- filter_data("landings", 
						life_stage = input$lfs, 
						country = input$country, 
						habitat = input$habitat,
						typ=as.numeric(input$raw_landings_eel_typ_id),
						year_range = input$year[1]:input$year[2])        
				# eventually grouped by habitat type and lfs, if both rec and com are selected, they are summed
				landings <-group_data(filtered_data,geo=input$geo,
						habitat=input$raw_landings_habitat_switch,
						lfs=input$raw_landings_lifestage_switch)
				landings$eel_value <- as.numeric(landings$eel_value) / 1000
				if (input$geo=="country"){
					landings$eel_cou_code = as.factor(landings$eel_cou_code)
				}else{
					landings$eel_emu_nameshort = as.factor(landings$eel_emu_nameshort)
					
				}
				return(landings)
			})
	
	output$graph_raw_landings <-  renderPlot({
				if (4 %in% (input$raw_landings_eel_typ_id) & 6%in%(input$raw_landings_eel_typ_id)) title2<-"Commercial and recreational landings for " else 
				if (4 %in% input$raw_landings_eel_typ_id) title2 <- "Commercial landings for " else
				if (6 %in% input$raw_landings_eel_typ_id) title2 <- "Recreational landings for " else
					stop ("Internal error, unexpected landings eel_typ_id, should be 4 or 6")
				title <- paste(title2,paste(input$geo,collapse="+")," and ", "stages = ", paste(input$lfs,collapse="+"), " and habitat =", paste(input$habitat,collapse="+"))
				landings <- get_raw_landings()
				raw_landings_graph(dataset=landings,title=title,
						col=color_countries,
						emu_col=color_emu,
						emu_ref=emu_cou,
						geo=input$geo,
						country_ref=country_ref,
						habitat=input$raw_landings_habitat_switch,
						lfs=input$raw_landings_lifestage_switch)
			})
	
	output$download_graph_raw_landings <- downloadHandler(filename = function() {
				paste("raw_landings", input$year[1], "-", input$year[2], ".",input$image_format, sep = "")
			}, content = function(file) {      
				if (4 %in% (input$raw_landings_eel_typ_id) & 6%in%(input$raw_landings_eel_typ_id)) title2<-"Commercial and recreational landings for " else 
				if (4 %in% input$raw_landings_eel_typ_id) title2 <- "Commercial landings for " else
				if (6 %in% input$raw_landings_eel_typ_id) title2 <- "Recreational landings for " else
					stop ("Internal error, unexpected landings eel_typ_id, should be 4 or 6")
				ggsave(file, raw_landings_graph(dataset= get_raw_landings(),
								title=paste(title2,paste(input$geo,collapse="+")," and ","stages = ", paste(input$lfs,collapse="+"), " and habitat =", paste(input$habitat,collapse="+")),col=color_countries, country_ref=country_ref,
								emu_col=color_emu,
								emu_ref=emu_cou,
								geo=input$geo),
						device = input$image_format, width = 20, height = 14, 
						units = "cm")
			})
	
	################################################
	# AQUACULTURE
	###################################################
	
	get_aquaculture <- eventReactive(input$aquaculture_button,{
				switch(input$aquaculture_eel_typ_id,
						"ton" = typ <- 11,
						"n"  = typ <- 12)
				filtered_data <- filter_data("aquaculture", 
						life_stage = input$lfs, 
						country = input$country, 
						habitat = input$habitat,
						typ=typ,
						year_range = input$year[1]:input$year[2])        
				aquaculture <-group_data(filtered_data,geo="country",
						habitat=FALSE,
						lfs=input$aquaculture_lifestage_switch)
				aquaculture$eel_cou_code = as.factor(aquaculture$eel_cou_code)        
				return(aquaculture)
			})
	output$graph_aquaculture <-  renderPlot({
				aquaculture <- get_aquaculture()
				if (input$aquaculture_eel_typ_id == "ton") {
					title2 <- "Aquaculture weight (tons) for " 
					aquaculture$eel_value <- as.numeric(aquaculture$eel_value) / 1000
				}
				else  if (input$aquaculture_eel_typ_id == "n") 
					title2 <- "Aquaculture number for "
				switch(input$aquaculture_eel_typ_id,
						"ton" = typ <-11,
						"n"  = typ <- 12)
				title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"))
				
				aquaculture_graph(dataset=aquaculture,
						title=title,
						col=color_countries, 
						country_ref=country_ref,
						lfs=input$aquaculture_lifestage_switch,
						typ=typ)
			})
	
	output$download_graph_aquaculture <- downloadHandler(filename = function() {
				paste("aquaculture", input$year[1], "-", input$year[2], ".", input$image_format,sep = "")
			}, content = function(file) {
				aquaculture <- get_aquaculture()
				if (input$aquaculture_eel_typ_id == "ton") {
					title2 <- "Aquaculture weight (tons) for " 
					aquaculture$eel_value <- as.numeric(aquaculture$eel_value) / 1000
				}
				else  if (input$aquaculture_eel_typ_id == "n") 
					title2 <- "Aquaculture number for "
				switch(input$aquaculture_eel_typ_id,
						"ton" = typ <-11,
						"n"  = typ <- 12)
				title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"))
				
				ggsave(file, aquaculture_graph(dataset=aquaculture,
								title=title,
								col=color_countries, 
								country_ref=country_ref,
								lfs=input$aquaculture_lifestage_switch,
								typ=typ),device = input$image_format, width = 20, height = 14, 
						units = "cm")
			})
	
	################################################
	# Release
	###################################################
	
	get_release <- eventReactive(input$release_button,{
				switch(input$release_eel_typ_id,
						"Release_kg" = typ <- 8,
						"Release_n" = typ <- 9,
						"Gee"  = typ <- 10)
				filtered_data <- filter_data("release", 
						life_stage = input$lfs, 
						country = input$country, 
						habitat = input$habitat,
						typ=typ,
						year_range = input$year[1]:input$year[2])        
				release <-group_data(filtered_data,geo="country",
						habitat=FALSE,
						lfs=input$release_lifestage_switch)
				release$eel_cou_code = as.factor(release$eel_cou_code)        
				return(release)
			})
	output$graph_release <-  renderPlot({
				release <- get_release()
				if (input$release_eel_typ_id == "Release_kg") {
					
					title2 <- "Released weight (kg) for " 
					typ <- 8
					
				}  else  if (input$release_eel_typ_id == "Release_n") {
					
					title2 <- "Released number (in thousands) for "
					typ <- 9
					release$eel_value <- as.numeric(release$eel_value) / 1000
					
				} else if (input$release_eel_typ_id == "Gee") {
					
					title2 <- "Glass eel equivalent (in thousands) for "
					typ <- 10 
					release$eel_value <- as.numeric(release$eel_value) / 1000
				}
				
				title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"))
				
				release_graph(dataset=release,
						title=title,
						col=color_countries, 
						country_ref=country_ref,
						lfs=input$release_lifestage_switch,
						typ=typ)
			})
	
	output$download_graph_release <- downloadHandler(filename = function() {
				paste("release.",input$image_format, sep = "")
			}, content = function(file) {
				release <- get_release()
				if (input$release_eel_typ_id == "Release_kg") {
					
					title2 <- "Released weight (kg) for " 
					typ <- 8
					
				}  else  if (input$release_eel_typ_id == "Release_n") {
					
					title2 <- "Released number (in thousands) for "
					typ <- 9
					release$eel_value <- as.numeric(release$eel_value) / 1000
					
				} else if (input$release_eel_typ_id == "Gee") {
					
					title2 <- "Glass eel equivalent (in thousands) for "
					typ <- 10 
					release$eel_value <- as.numeric(release$eel_value) / 1000
				}
				
				title <- paste(title2, "stages = ", paste(input$lfs,collapse="+"))
				ggsave(file, 
						release_graph(dataset=release,title=title,
								col=color_countries, 
								country_ref=country_ref,
								lfs=input$release_lifestage_switch,
								typ=typ),
						device = input$image_format, 
						width = 20, 
						height = 14, 
						units = "cm")
			})
	
	
	################################
	# Precautionary diagram
	#################################
# Take a reactive dependency on input$precodata_button, but
# not on any of the stuff inside the function
	filter_data_reactive <- reactive({
				return(
						if (!"all" %in% input$precodata_choice) {
									filter_data(
											dataset = "precodata_all", 
											life_stage = NULL, 
											country = input$country,
											year_range = input$year[1]:input$year[2]) 
								} else {
									filter_data(
											dataset = "precodata_all", 
											life_stage = NULL, 
											country = NULL,
											year_range = input$year[1]:input$year[2])
								}
				)  
			})
	
	
	output$precodata_graph<- renderPlot({
				precodata_sel<-filter_data_reactive()        
				trace_precodiag(precodata_sel,
						precodata_choice = input$precodata_choice,
						last_year = input$button_precodata_last_year)
			})
	
	output$download_precodata_graph=downloadHandler(filename = function() {
				paste("preco_diag.",input$image_format, sep = "")
			}, content = function(file) {
				ggsave(file, 
						trace_precodiag(filter_data_reactive()),
						device = input$image_format, 
						width = 20, 
						height = 14, 
						units = "cm")
			})
	
	################################
	# Rasta map
	################################
	output$rasta_map <- renderLeaflet({
				b_map(
						dataset=precodata_all,
						map = input$geo,
						use_last_year=input$rasta_map_last_year, type = input$rasta_map_type,
						the_year=input$year[2],
						maxscale_country=300, # scale in km
						maxscale_emu=50) # scale in km
				
			})
	
	
	
	
	######################################
# MAP
	######################################
	# dynamically generate the button to choose between Commercial and recreational landings
	# if "landings" is selected as a dataset
	output$leaflet_typ_button <- renderUI({
				if (is.null(input$leaflet_dataset))
					return()
				
				# we check the value of leaflet dataset
				# if landings then the ui will generate leaflet_eel_typ_id button
				switch(input$leaflet_dataset,
						"landings"= 
								awesomeCheckboxGroup(
										inputId = "leaflet_eel_typ_id",
										label = "Dataset",
										choices = c("com"=4,"rec"=6),
										selected=c("com"=4,"rec"=6),
										status = "primary",
										inline=TRUE                                
								),   
						"aquaculture"= 
								radioGroupButtons(
										inputId = "leaflet_eel_typ_id",
										label = "Dataset",
										choices = c("q_aqua_kg"=11,"q_aqua_n"=12),
										selected=c("q_aqua_kg"=11),
										direction = "horizontal"                               
								),
						"release"= 
								radioGroupButtons(
										inputId = "leaflet_eel_typ_id",
										label = "Dataset",
										choices = c("q_release_kg"=8,"q_release_n"=9,"gee_n"=10),
										selected=c("q_release_kg"=8),
										direction = "vertical"                                
								)
				# TODO develop this, we need a view for biomass+ sigmaA different from precodata (which has one column per type)
				# ideally one view for SEE, one view for SumH by type
				#,
#            "precodata"=
#                radioGroupButtons(
#                    inputId = "leaflet_eel_typ_id",
#                    label = "Dataset",
#                    choices = c(
#                        "B0_kg"=13,
#                        "Bbest_kg" = 14,
#                        "Bcurrent_kg" = 15,        
#                        "SumA" = 17,
#                        "SumF" = 18,
#                        "SumH" = 19,
#                        "sumF_com" = 20,
#                        "SumF_rec" = 21,
#                        "SumH_hydro" = 22,
#                        "SumH_habitat" = 23,
#                        "SumH_release" = 24,
#                        "SumH_other" = 25,
#                        "SEE_com" = 26,
#                        "SEE rec" = 27,
#                        "SEE_hydro" = 28,
#                        "SEE_habitat" = 29,
#                        "SEE_stocking" = 30,
#                        "SEE_other" = 31),       
#                    selected=c("sumA"=17),                    
#                    inline=FALSE 
#                )
				)})     
	
#  Leaflet map, this uses the datacall_map function -------------------------------------------------  
	observe({
				
				# adding a pulse marker when selected
				
				acm_defaults <-   function(map, x, y)   {          
					addPulseMarkers(map, x, y, 
							layerId = "selected",          
							icon = makePulseIcon(color = "yellow",
									iconSize =  10, 
									animate = TRUE, heartbeat = 1)
					)
				}        
				
				output$map = renderLeaflet({
							# draw leaflet depends on input$leaflet_eel_typ_id which is generated anyways
							# it returns a list with a dataset and a leaflet map (m)
							ls<-datacall_map(dataset = input$leaflet_dataset,
									years = input$year,
									typ=input$leaflet_eel_typ_id,
									lfs_code= input$lfs,		    
									map = input$geo)
							
							# store data into the reactive values
							
							data$leaflet_dataset <- ls$data
							
							# print the map   
							
							ls$m
						})
				
# observer click event ------------------------------------------------------------------------------- 
				
				observeEvent(input$map_marker_click, {
							p <- input$map_marker_click               
							id <- p$id
							id1 <- gsub('[0-9]*',"",id) # NO_ or NO_total_
							country_or_emu_selected <-substr(id1,1,nchar(id1)-1) # remove trailing "_"
							proxy <- leafletProxy("map")
							if(p$id == "selected") {
								proxy %>% removeMarker(layerId = "selected")
								updateSwitchInput(session, "showplotly", value = FALSE) 
							} else {
								
								# Create selected marker run acm which is for pulse --------------------------------------
								
								proxy %>%  fitBounds(-10, 34, 26, 65) %>%
										acm_defaults(p$lng, p$lat)
								
								# Create selected marker table and put in in reactive values--------------------------
								# CHECKME this is probably not necessary 
								# data$point_selected<-data$leaflet_dataset[data$leaflet_dataset$id==id,]
								
								# Extract a dataset corresponding to the year and other stuff, as in maps.R ---------- 
								
								time_series_selected <-  filter_data(input$leaflet_dataset,
										typ=input$leaflet_eel_typ_id,
										life_stage=input$lfs,         
										habitat=NULL,
										year_range=input$year[1]:input$year[2])
								
								time_series_selected <- group_data(time_series_selected,
										geo= input$geo,
										habitat=FALSE, 
										lfs=FALSE)
								
								# we cannot use filter_data with emu, so we extract last
								
								switch(input$geo, "emu"= {
											time_series_selected <- time_series_selected[time_series_selected$eel_emu_nameshort==country_or_emu_selected,]
										}, "country"= {
											time_series_selected <- time_series_selected[time_series_selected$eel_cou_code==country_or_emu_selected,]
										}) 
								
								
								# Some units converted to tons --------------------------------------------------------
								
								if (is.null(input$leaflet_eel_typ_id)) {
									time_series_selected$eel_value <- round(time_series_selected$eel_value / 1000,digits=1) 
								} else if (4 %in% input$leaflet_eel_typ_id || 6 %in% input$leaflet_eel_typ_id || 11 %in% input$leaflet_eel_typ_id ){
									time_series_selected$eel_value <- round(time_series_selected$eel_value / 1000,digits=1)
								} 
								
								# Create a plotly graph------------------------------------------------------------------
								updateSwitchInput(session, "showplotly", value = TRUE)
								output$plotly_graph <- renderPlotly({
											plot_ly(time_series_selected, x = ~eel_year, y = ~eel_value,
															# Hover text:
															text = ~paste("Year: ", eel_year, '$<br>Value:', eel_value),
															color = ~eel_value, size = ~eel_value )   %>%
													layout(plot_bgcolor='rgb(209, 218, 201)') #%>% 
											#layout(paper_bgcolor="transparent") #will also accept 'rgb(254, 247, 234)' paper_bgcolor='black'    
											
										})
								
							}
						})
			})
	observeEvent(input$showplotly, {
				# every time the button is pressed, alternate between hiding and showing the plot
				toggle("plotly_graph",TRUE, anim = TRUE, animType = "slide", condition = input$showplotly)
				
			})
	##################################
	# Recruitment map -----------------------------------------------------------------------------
	##################################
	# first let's hide the sidebar
	
	
	
	
	observe({
				output$mapstation = renderLeaflet({
							
							recruitment_map(R_stations, statseries, wger_init, CY, colors=c("#F2F3F4","#CCFF99","#FFFF00"))                               
							
						})
				
# observer click event ------------------------------------------------------------------------------- 
				# xtabs(R_stations$ser_id~R_stations$ser_nameshort)
				# debug the_id =28 (Tibe)/ the_id=17 (Vil) / the_id=12 (RhDO) / the_id=189 (Stra not selected)
				#  the_id= 30 (Dala)
				#       the_name='Tibe' / the_name='Vil'
				#       the_stage ='G'
				#       the_area='EE'
				observeEvent(input$mapstation_marker_click,  {
							shinyjs::addClass(selector = "body", class = "sidebar-collapse")       
							p <- input$mapstation_marker_click
							lat <- p$lat
							lng <- p$lng
							the_id <- p$id
							
							validate (need(!is.null(the_id), "Please click on a point")) 
							
							the_station <- R_stations %>%
									dplyr::filter(ser_id==the_id) 
							
							the_name <- the_station$ser_nameshort
							
							the_namelong <- iconv(the_station$ser_namelong,"UTF8")
							
							the_stage <- the_station$lfs_code
							
							the_area <- case_when(the_stage =="Y" ~ "Yellow",
									the_station$area=="Elsewhere Europe" ~ "Elsewhere Europe",
									the_station$area=="North Sea" ~ "North Sea")   
							
							is_selected <- the_station$ser_qal_id==1
							
							the_title= paste(the_namelong)
							
							
							
							if (the_stage=='G'| the_stage=='GY'){
								
								# These values are standardized against the predictions in 1960s-1970s
								# the predictions are the predictions of the expand.grid(year,site,area)
								
								# this is the North Sea or Elswhere Europe series
								
								the_series <-  	dat_ge[dat_ge$area==the_area,c("year",
												"p", # predictions in the log scale for EE or NS series
												"mean", # mean of predictions 1960-1979 log scale
												"p_std_1960_1979", # scaled prediction exp(p-mean)
												"p_std_1960_1979_min",     
												"p_std_1960_1979_max",
												"p_std_1960_1979_maxgraph")]
								
								
								
								if (is_selected) {
									
									# extracting residuals for second plot -------------------------------------------
									
									model_data <- model_ge_area$model 
									
									# working residuals ---------------------------------------------------------
									
									model_data$r <- resid(model_ge_area)  
									
									# extracting scaled value for the plot -------------------------------------------
		
									if (the_name=="AdCP") model_data$co <- 0 else
									model_data$co <- coefficients(model_ge_area)[str_c("site",the_name)] # coefficient for site
									model_data <- model_data %>% 
											filter(site==the_name) %>% 
											mutate(year=as.numeric(as.character(year_f))) %>% 
											right_join(                             # right join = keep all from dat_ge
													dat_ge[dat_ge$area==the_area,c("year",
																	"p", # predictions in the log scale for EE or NS series
																	"mean", # mean of predictions 1960-1979 log scale
																	"p_std_1960_1979", # scaled prediction exp(p-mean)
																	"p_std_1960_1979_min",     
																	"p_std_1960_1979_max",
																	"p_std_1960_1979_maxgraph")],
													by="year")	%>% # join by year
											right_join(wger%>%filter(site==the_name)%>%dplyr::select(year, das_qal_id),
													by="year")%>% # getting das_qal_id for the graph 
											mutate(value_std_1960_1979=exp(log(value_std)-co-mean))	%>%
											arrange(year)    
									
									# The data is not selected, no model, just raw data          
								} else {
									# we can't use modelled data, and have to rescale on the common period
									model_data <- wger_init %>% dplyr::select(value,year,site) %>%
											filter(site==the_name)%>%
											mutate(value=value/mean(value,na.rm=TRUE))%>%
											right_join(                             # right join = keep all from dat_ge
													dat_ge[dat_ge$area==the_area,c("year",
																	"p", # predictions in the log scale for EE or NS series
																	"mean", # mean of predictions 1960-1979 log scale
																	"p_std_1960_1979" # scaled prediction exp(p-mean)
															)],
													by="year")  %>%		
											arrange(year) %>%
											# calculate log average when value is not missing to rescale only on the common period
											mutate(		
													mean_pred_when_existing = mean(p[!is.na(value)]), # geometric mean log scale
													mean_pred_value_std = mean(log(value),na.rm=TRUE) # mean of log of existing observed											
											) %>%						
											# Standardize the value to existing predictions
											mutate(
													standardized_same_period= log(value)-mean_pred_value_std+mean_pred_when_existing
											)%>%		 
											# calculate the value standardized to 1960_1979, the wgeel series has also been scaled by mean 
											# which is the average 1960_1979
											mutate(
													value_std_1960_1979= exp(standardized_same_period -mean)
											)
									
								}
								
							} else {
								
								# Yellow eel case --------------------------------------------------------------
								
								#       debug : see glass eel above set id to Dala
								#browser()
								the_series <- dat_ye	%>%
										dplyr::rename(p_std_1960_1979 = value_std_1960_1979,
												p_std_1960_1979_min =yellow_eel_min,
												p_std_1960_1979_max = yellow_eel_max)
								
								if (is_selected) {
									# below we do a right join with the prediciton
									
									
									
									# extracting residuals for second plot -------------------------------------------
									
									model_data <- model_older$model 
									
									model_data$r <- resid(model_older) 
									
									if (the_name=="Dala") model_data$co <- 0 else
										model_data$co <- coefficients(model_older)[str_c("as.factor(site)",the_name)] # coefficient for site
									
									model_data <- model_data %>% 
											dplyr::rename("site" = "as.factor(site)") %>%
											mutate(year=as.numeric(as.character(year_f))) %>% 
											filter(as.factor(site) == the_name) %>%											
											right_join(           # right join = keep all from dat_ye                 
													dat_ye %>% 
															dplyr::select(year,p,value_std_1960_1979,mean_1960_1979) %>%
															dplyr::rename(p_std_1960_1979 = value_std_1960_1979,mean=mean_1960_1979),																	
													by="year")  %>%	
											mutate(value_std_1960_1979=exp(log(value_std)-co-mean))	%>%
											arrange(year)    
									
									
								} else {
									
									model_data <- wger_init %>% dplyr::select(value,year,site) %>%
											filter(site==the_name)%>%
											mutate(value=value/mean(value,na.rm=TRUE))%>%
											right_join(                             # right join = keep all from dat_ge
													dat_ye %>% 
															dplyr::select(year,p,value_std_1960_1979,mean_1960_1979) %>%
															dplyr::rename(p_std_1960_1979 = value_std_1960_1979,mean=mean_1960_1979),																	
													by="year")  %>%	
											arrange(year) %>%
											# calculate log average when value is not missing to rescale only on the common period
											mutate(		
													mean_pred_when_existing = mean(p[!is.na(value)]), # geometric mean log scale
													mean_pred_value_std = mean(log(value),na.rm=TRUE) # mean of log of existing observed											
											) %>%						
											# Standardize the value to existing predictions
											mutate(
													standardized_same_period= log(value)-mean_pred_value_std+mean_pred_when_existing
											)%>%		 
											# calculate the value standardized to 1960_1979, the wgeel series has also been scaled by mean 
											# which is the average 1960_1979
											mutate(
													value_std_1960_1979= exp(standardized_same_period -mean)
											)
									
								}
								
							}
							
# assign to parent environment
							
							the_series <<-the_series
							
							
# Create a plotly graph of trend ------------------------------------------------------------------
							
							output$plotly_recruit <- renderPlotly({
										f <- list(
												#family = "Verdana",
												size = 12,
												color = "#7f7f7f")
										x <- list(												
												title = "Year",
												titlefont = f)
										y <- list(
												title = paste("Values standardized by 1960-1979 pred for the", the_area,"serie"),
												autorange = TRUE,
												side = "left",
												titlefont = f)
# additional axis for the value itself
#										ay <- list(
#												tickfont = list(color = "blue"),
#												overlaying = "y",
#												side = "right",
#												title = paste("Values standardized by 1960-1979 pred for the", the_name,"serie"),
#												autorange = FALSE,
#												range=c(min(the_series$value_std,na.rm=TRUE)-0.5,max(the_series$value_std,na.rm=TRUE)+0.5),
#												titlefont = f)
										
										# pal ending with numbers are not recognized by plot_ly
										
										# note the source argument is used to find this
										# graph in eventdata
																				
										
										p <- plot_ly(the_series, 
														x = ~ year, 
														y = ~ p_std_1960_1979,
														name = the_area,                              
														source= "select_year",
														type="scatter",
														mode="lines+markers",
														color = switch(the_area,"Elsewhere Europe"= I("red"),
																"North Sea"= I("dodgerblue"),
																"Yellow"=I("black")),
														symbol = I('circle-open') ,
														yaxis = "y",
														marker = list(size = 9)) %>% 
												add_ribbons( 
														x = ~ year,
														ymin = ~ p_std_1960_1979_min, 
														ymax=~ p_std_1960_1979_max,
														color=switch(the_area,"Elsewhere Europe"= I("darkred"),
																"North Sea"= I("dodgerblue4"),
																"Yellow"=I("green4")),
														fill=switch(the_area,"Elsewhere Europe"= I("darkred"),
																"North Sea"= I("dodgerblue4"),
																"Yellow"=I("green4")),
														name = "CI 95%", 														
														yaxis = "y",
														type="scatter",
														mode="lines",
														inherit = FALSE # this will ignore "line+markers"
												) %>%												
												#layout(title = the_title, xaxis = x, yaxis = y, yaxis2=ay) %>%
												add_trace(
														x= ~ year,
														y = ~ value_std_1960_1979, 
														data=model_data,
														name = the_name, 
														color = switch(the_area,"Elsewhere Europe"= I("turquoise"),
																"North Sea"= I("gold"),
																"Yellow"=I("pink")),
														symbol=I('circle-dot'),
														yaxis = "y",
														marker = list(size = 10)) %>%												
												layout(title = the_title, xaxis = x, yaxis =y, legend = list(x = 1.10, y = 1)) # yaxis2= ay,
										p$elementId <- NULL # a hack to remove warning : ignoring explicitly provided widget
										p  
									})
							
							##
# Create a graph of residuals ---------------------------------------------------------   
							
							output$resid_recruitment_graph <- renderPlot({
										validate(need(is_selected, 
														paste("This series is not included in the analyis",", so no plot of residuals can be provided"))) 
										g <-ggplot(model_data)+
												geom_point(aes(x=year,y=r),shape="-",size=12,col="darkblue")+
												geom_line(aes(x=year,y=r),alpha=0.5)+
												theme_bw()+
												geom_hline(aes(yintercept=0))+
												ylab("glm residuals")
										if (input$button_smooth==TRUE) {# working residuals
											g <- g +           
													geom_smooth(aes(x=year,y=r),fill="gold3",col="gold")                   
										}
										g
									})
							
# Series text -------------------------------------------------------------------------
							
							output$recruit_site_description <- renderUI({                                
										tagList(
												h2(iconv(the_station$ser_namelong,"UTF8")),
												p(paste0("Location : ", iconv(the_station$ser_locationdescription,"UTF8"))),
												p(paste0('Comments : ', iconv(the_station$ser_comment,"UTF8"))))
									})
							
							
							
# Series image -------------------------------------------------------------------------
							
							output$recruit_site_image <- renderImage({                      
										filename <- normalizePath(file.path('./www/',paste0(the_name, '.',input$image_format)))
										list(src = filename)                    
									},
									deleteFile = FALSE
							)
							
# Comment for individual point --------------------------------------------------------
							
							output$das_comment <-renderUI({
										event.data <- event_data("plotly_click", source = "select_year")
										
										# If NULL dont do anything
										if(is.null(event.data) == T) 
										{ 
											the_comment <- "<p> click on a point </p>"
											
											# event.data returns the name of the trace and the pointNumber
										} else  if (event.data$curveNumber == 0) {
											the_comment <- ifelse (is.na(the_series$das_comment[the_series$year==event.data$x]),
													"No comment available", 
													the_series$das_comment[the_series$year==event.data$x]) 
											the_comment <- paste( "<b>",event.data$x, " : ", the_comment,"</b>")
										} else {
											the_comment<- "<p> click on the other series </p>" 
										}
										the_text <- paste("<h2>Details about the point</h2>",the_comment)
										HTML(the_text)
									}) 
						})
			})
	
	
	####recruitment indices
	output$table_recruitment<-renderDataTable({
	  names(dat_ye)[names(dat_ye)=="value_std_1960_1979"] <- "p_std_1960_1979"
				if (input$index_rec=="Elsewhere Europe"){
  					data_rec<-dat_ge[dat_ge$area=="Elsewhere Europe",]
				} else if (input$index_rec=='North Sea'){
					data_rec<-dat_ge[dat_ge$area=="North Sea",]
				}else data_rec<-dat_ye
				data_rec$decades<-(data_rec$year%/%10)*10
				data_rec$unit<-data_rec$year-data_rec$decades
				data_rec_cast<-dcast(data_rec[,c("decades","unit","p_std_1960_1979")],unit~decades,value.var="p_std_1960_1979")
				rownames(data_rec_cast)<-data_rec_cast$unit
				data_rec_cast$unit <- data_rec_cast$unit/100
				names(data_rec_cast)[1] <-"year\\decade"
				DT::datatable(round(data_rec_cast*100,digits=2), 
						rownames=FALSE,
						extensions = c("Buttons","KeyTable"),
						option=list(
								order=list(0,"asc"),
								keys = TRUE,
								pageLength = 10,
								columnDefs = list(list(className = 'dt-center')),
								searching = FALSE, # no filtering options
								dom= "Bti", # from left to right button left f, t tableau, i informaiton (showing..), p pagination
								buttons=list(
										list(extend="excel",
												filename = paste0("data_",Sys.Date())))
						)) %>% formatStyle("year\\decade",fontWeight="bold")
			})
	
	
	
	get_recruitment_graph <- reactive({
	      tmp=data.frame(year=dat_ye$year,area=rep("Y",nrow(dat_ye)),p_std_1960_1979=dat_ye$value_std_1960_1979)
				data_rec=rbind.data.frame(dat_ge[,c("year","p_std_1960_1979","area")],tmp[,c("year","p_std_1960_1979","area")]) 
				data_rec$area <- c("EE","NS","Y")[match(data_rec$area,c("Elsewhere Europe","North Sea","Y"))]
				data_rec<-data_rec[data_rec$area %in% input$indices_rec_graph,]
				are_we_jokking=input$just_a_joke
				return(data_rec)
			})
	output$graph_recruitment <-  renderPlot({
				data_rec <- get_recruitment_graph()
				data_rec<-data_rec[data_rec$area %in% input$indices_rec_graph,]
				recruitment_graph(dataset=data_rec,as.numeric(input$just_a_joke)%%2==FALSE)
			})
	
	output$download_recruitment_graph <- downloadHandler(filename = function() {
				paste("recruitment.", input$image_format,sep = "")
			}, content = function(file) {
				data_rec <- get_recruitment_graph()
				ggsave(file, recruitment_graph(dataset=data_rec,as.numeric(input$just_a_joke)%%2==FALSE))
			})
	
	##################################
# yellow & silver eel map -----------------------------------------------------------------------------
	##################################
# first let's hide the sidebar
	
	
	
	
	observe({
				output$mapstation_ys = renderLeaflet({
							
							recruitment_map(ys_stations, statseries_ys, wger_init_ys, CY, colors= c("#CACFD4","#B0E44B","#FFFF66"))                               
							
						})
				
# observer click event ------------------------------------------------------------------------------- 
				observeEvent(input$mapstation_ys_marker_click,  {
							shinyjs::addClass(selector = "body", class = "sidebar-collapse")       
							p <- input$mapstation_ys_marker_click
							lat <- p$lat
							lng <- p$lng
							the_id <- p$id
							
							validate (need(!is.null(the_id), "Please click on a point"))              
							the_station <- ys_stations %>%
									dplyr::filter(ser_id==the_id) 
							
							the_name <- the_station$ser_nameshort
							
							the_namelong <- iconv(the_station$ser_namelong,"UTF8")
							
							the_stage <- the_station$lfs_code
							
							is_selected <- the_station$ser_qal_id==1
							
							the_title <- paste(the_namelong)
							
							the_unit = the_station$ser_uni_code
							
							the_series = wger_init_ys %>%
									dplyr::filter(ser_id==the_id)  %>% dplyr::arrange(year)
							
							# Create a plotly graph of trend ------------------------------------------------------------------
							output$plotly_ys <- renderPlotly({ #plotly_ys
										f <- list(
												#family = "Verdana",
												size = 12,
												color = "#7f7f7f")
										x <- list(
												title = "Year",
												titlefont = f)
										y <- list(
												title = paste("Values (", the_unit,")"),
												autorange = T,
												side = "left",
												titlefont = f)
										
										p <- plot_ly(the_series, 
														x = ~ year, 
														y = ~ value,
														name = the_name,                              
														source= "select_year",
														type="scatter",
														mode="lines+markers",
														color = I("dodgerblue3"),
														symbol = I('circle-open'),
														marker = list(size = 12)) %>% 
												layout(title = the_title, xaxis = x, yaxis =y,legend = list(x = 1.10, y = 1))
										p$elementId <- NULL # a hack to remove warning : ignoring explicitly provided widget
										p  
									})#plotly_ys
							
							
							# Series text -------------------------------------------------------------------------
							
							output$ys_site_description <- renderUI({                                
										tagList(
												h2(iconv(the_station$ser_namelong,"UTF8")),
												p(paste0("Location : ", iconv(the_station$ser_locationdescription,"UTF8"))),
												p(paste0('Comments : ', iconv(the_station$ser_comment,"UTF8"))))
									})
							
#						# Comment for individual point --------------------------------------------------------
#						
#						output$das_comment <-renderUI({
#									event.data <- event_data("plotly_click", source = "select_year")
#									
#									# If NULL dont do anything
#									if(is.null(event.data) == T) 
#									{ 
#										the_comment <- "<p> click on a point </p>"
#										
#										# event.data returns the name of the trace and the pointNumber
#									} else  if (event.data$curveNumber == 0) {
#										the_comment <- ifelse (is.na(the_series$das_comment[the_series$year==event.data$x]),
#												"No comment available", 
#												the_series$das_comment[the_series$year==event.data$x]) 
#										the_comment <- paste( "<b>",the_comment,"</b>")
#									} else {
#										the_comment<- "<p> click on the other series </p>" 
#									}
#									the_text <- paste("<h2>Details about the point</h2>",the_comment)
#									HTML(the_text)
#								}) 
#					})
						})
			})
	
	
	
}
