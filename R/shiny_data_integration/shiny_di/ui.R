###############################################
# Ui file for ICES data integration tools
###############################################
spsDepend("toastr") #https://www.rdocumentation.org/packages/spsComps/versions/0.1.1/topics/spsDepend

ui <- fluidPage(spsDepend("toastr"),
		dashboardPage(title="ICES Data Integration",
				
				dashboardHeader(title=div(img(src="iceslogo.png"),"wgeel")),
				
				################################################################################################
				# SIDEBAR
				################################################################################################
				
				dashboardSidebar(
						# A button that stops the application
						extendShinyjs(text = jscode, functions = c("closeWindow")),
						actionButton("close", "Close window"),  
						h3("Data"),      
						sidebarMenu(          
								# menuItem("Import",tabName= "import", icon= icon("align-left")),
								# menuItem("Import Time Series",tabName= "import_ts", icon= icon("align-left")),					
								# menuItem("Edit Data", tabName="editAll", icon=icon("table")),
								# menuItem("Plot duplicates", tabName='plot_duplicates',icon= icon("area-chart")),
								# menuItem("New Participants", tabName='integrate_new_participants',icon= icon("user-friends")),
								menuItem("Import Data module", tabName="Importmodule", icon=icon("align-left")),
								menuItem("Import Time Series module",tabName= "Importtsmodule", icon= icon("align-left")),					
								menuItem("Edit Data module", tabName="editAllmodule", icon=icon("table")),
								menuItem("Plot duplicates module", tabName='plot_duplicates_module',icon= icon("area-chart")),
								menuItem("New Participants module", tabName="newparticipantstabmodule", icon=icon("user-friends"))
								#menuSubItem("Plot duplicates",  tabName="plot_duplicates"),
								#menuSubItem("plot2", tabName="plot2")
								,
								pickerInput(
										inputId = "main_assessor",
										label = "Main assessor (National)", 
										choices = participants,
										selected="Cedric Briand")
						
						),
						pickerInput(
								inputId = "secondary_assessor",
								label = "Secondary assessor (Data)", 
								choices = participants,
								selected="Cedric Briand"
						
						),
						passwordInput("password", "Password:"),
						actionButton("passwordbutton", "Go"),
						verbatimTextOutput("passwordtest")
				
				), 
				
				################################################################################################
				# BODY
				################################################################################################
				
				dashboardBody(
						useShinyjs(), # to be able to use shiny js           
						tabItems(
								
								# Importation tab  ----------------------------------------------------------------------
								
								
								# tabItem(tabName="import",
								# 		h2("Datacall Integration and checks"),
								# 		h2("step 0 : Data check"),
								# 		fluidRow(
								# 				column(width=4,fileInput("xlfile", "Choose xls File",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)),
								# 				column(width=4,  radioButtons(inputId="file_type", label="File type:",
								# 								c(" Catch and Landings" = "catch_landings",
								# 										"Release" = "release",
								# 										"Aquaculture" = "aquaculture",                                
								# 										"Biomass indicators" = "biomass",
								# 										"Habitat - wetted area"= "potential_available_habitat",
								# 										"Mortality silver equiv. Biom."="mortality_silver_equiv",
								# 										"Mortality_rates"="mortality_rates"					
								# 								))),
								# 				column(width=4, actionButton("check_file_button", "Check file") )                     
								# 		),
								# 		
								# 		fluidRow(
								# 				column(width=6,
								# 						htmlOutput("step0_message_txt"),
								# 						verbatimTextOutput("integrate"),placeholder=TRUE),
								# 				column(width=6,
								# 						htmlOutput("step0_message_xls"),
								# 						DT::dataTableOutput("dt_integrate"))
								# 		),              
								# 		tags$hr(),
								# 		h2("step 1 : Compare with database"),
								# 		fluidRow(
								# 				fluidRow(column(width=2,                        
								# 								actionButton("check_duplicate_button", "Check duplicate")) ),
								# 				fluidRow(
								# 						column(width=5,
								# 								h3("Duplicated data"),
								# 								htmlOutput("step1_message_duplicates"),
								# 								DT::dataTableOutput("dt_duplicates"),
								# 								h3("Updated data"),
								# 								htmlOutput("step1_message_updated"),
								# 								DT::dataTableOutput("dt_updated_values")),
								# 						column(width=5,
								# 								h3("New values"),
								# 								htmlOutput("step1_message_new"),
								# 								DT::dataTableOutput("dt_new"))),
								# 				fluidRow(
								# 						column(width=5,
								# 								h3("Summary modifications"),
								# 								DT::dataTableOutput("dt_check_duplicates")),
								# 						column(width=5,
								# 								h3("summary still missing"),
								# 								DT::dataTableOutput("dt_missing")))
								# 		
								# 		),
								# 		tags$hr(),
								# 		h2("step 2.1 Integrate/ proceed duplicates rows"),
								# 		fluidRow(
								# 				column(width=4,fileInput("xl_duplicates_file", "xls duplicates",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)),                   
								# 				column(width=2,
								# 						actionButton("database_duplicates_button", "Proceed")),
								# 				column(width=6,verbatimTextOutput("textoutput_step2.1"))
								# 		),
								# 		h2("step 2.2 Integrate new rows"),
								# 		fluidRow(
								# 				column(width=4,fileInput("xl_new_file", "xls new",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)),                   
								# 				column(width=2,
								# 						actionButton("database_new_button", "Proceed")),
								# 				column(width=6,verbatimTextOutput("textoutput_step2.2"))
								# 		),
								# 		h2("step 2.3 Updated values"),
								# 		fluidRow(
								# 				column(width=4,fileInput("xl_updated_file", "xls updated",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)),
								# 				column(width=6,
								# 						actionButton("database_updated_value_button", "Proceed"),
								# 						verbatimTextOutput("textoutput_step2.3")
								# 				)										
								# 		)
								# 
								# ),
								
								# time series integration table ---------------------------------------------------------
								
								# tabItem(tabName="import_ts",
								# 		h2("Datacall time series (glass / yellow / silver) integration"),								
								# 		h2("step 0 : Data check"),
								# 		tabsetPanel(tabPanel("MAIN",
								# 						fluidRow(
								# 								column(width=4,fileInput("xlfile_ts", "Choose xls File",
								# 												multiple=FALSE,
								# 												accept = c(".xls",".xlsx")
								# 										)),
								# 								column(width=4,  radioButtons(inputId="file_type_ts", label="File type:",
								# 												c(	"Glass eel (recruitment)"="glass_eel",
								# 														"Yellow eel (standing stock)"="yellow_eel ",
								# 														"Silver eel"="silver_eel"
								# 												))),
								# 								column(width=4, actionButton("ts_check_file_button", "Check file") )                     
								# 						),
								# 						
								# 						fluidRow(
								# 								column(width=6,
								# 										htmlOutput("step0_message_txt_ts"),
								# 										verbatimTextOutput("integrate_ts"),placeholder=TRUE),
								# 								column(width=6,
								# 										htmlOutput("step0_message_xls_ts"),
								# 										DT::dataTableOutput("dt_integrate_ts"))
								# 						)),
								# 				tabPanel("MAPS",
								# 						fluidRow(column(width=10),
								# 								leafletOutput("maps_timeseries")))),
								# 		
								# 		tags$hr(),
								# 		h2("step 1 : Compare with database"),								
								# 		fluidRow(                                       
								# 				column(width=2,                        
								# 						actionButton("check_duplicate_button_ts", "Check duplicate")), 
								# 				column(width=5,
								# 						h3("new series"),
								# 						htmlOutput("step1_message_new_series"),
								# 						DT::dataTableOutput("dt_new_series"),
								# 						h3("new dataseries"),
								# 						htmlOutput("step1_message_new_dataseries"),
								# 						DT::dataTableOutput("dt_new_dataseries"),
								# 						h3("new biometry"),
								# 						htmlOutput("step1_message_new_biometry"),
								# 						DT::dataTableOutput("dt_new_biometry")
								# 				),
								# 				column(width=5,
								# 						h3("modified series"),
								# 						htmlOutput("step1_message_modified_series"),
								# 						DT::dataTableOutput("dt_modified_series"),	
								# 						h3("modified series : what changed at series level ?"),
								# 						DT::dataTableOutput("dt_highlight_change_series"),
								# 						h3("modified dataseries"),
								# 						htmlOutput("step1_message_modified_dataseries"),
								# 						DT::dataTableOutput("dt_modified_dataseries"),
								# 						h3("modified dataseries : what changed for new_data and updated_data ?"),	
								# 						DT::dataTableOutput("dt_highlight_change_dataseries"),
								# 						h3("modified biometry"),	
								# 						DT::dataTableOutput("dt_modified_biometry"),
								# 						htmlOutput("step1_message_modified_biometry"),
								# 						h3("modified biometry : what changed ?"),
								# 						DT::dataTableOutput("dt_highlight_change_biometry")												
								# 				)
								# 		),
								# 		tags$hr(),
								# 		h2("step 2.1 Integrate new series"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_new_series", "xls new series, do this first and re-run compare",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("integrate_new_series_button", "Proceed")
								# 				),
								# 				column(
								# 						width=6,
								# 						verbatimTextOutput("textoutput_step2.1_ts")
								# 				)
								# 		),
								# 		h2("step 2.2 Update modified series"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_updated_series", "xls modified series, do this first and re-run compare",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx"))
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("update_series_button", "Proceed")
								# 				),
								# 				column(
								# 						width=6,
								# 						verbatimTextOutput("textoutput_step2.2_ts")
								# 				)
								# 		),
								# 		h2("step 2.3 Integrate new dataseries"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_new_dataseries", "Once the series are updated, integrate new dataseries",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx"))
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("integrate_new_dataseries_button", "Proceed")
								# 				),
								# 				column(
								# 						width=6,
								# 						verbatimTextOutput("textoutput_step2.3_ts")
								# 				)
								# 		),
								# 		h2("step 2.4 Update modified dataseries"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_updated_dataseries", "Update the modified dataseries",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx")
								# 						)
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("update_dataseries_button", "Proceed")
								# 				),
								# 				column(
								# 						width=6,
								# 						verbatimTextOutput("textoutput_step2.4_ts")
								# 				)
								# 		),
								# 		h2("step 2.5 Integrate new biometry"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_new_biometry", "xls update",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx"))
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("integrate_new_biometry_button", "Proceed")
								# 				),
								# 				column(width=6,
								# 						verbatimTextOutput("textoutput_step2.5_ts")
								# 				)
								# 		),
								# 		h2("step 2.6 Update modified biometry"),
								# 		fluidRow(
								# 				column(
								# 						width=4,
								# 						fileInput("xl_modified_biometry", "xls update",
								# 								multiple=FALSE,
								# 								accept = c(".xls",".xlsx"))
								# 				),                   
								# 				column(
								# 						width=2,
								# 						actionButton("update_biometry_button", "Proceed")
								# 				),
								# 				column(
								# 						width=6,
								# 						verbatimTextOutput("textoutput_step2.6_ts")
								# 				)
								# 		)
								# ),
								
	
								
								# Data correction table  ----------------------------------------------------------------
								
								# tabItem("editAll",
								# 		h2("Data correction table"),
								# 		br(),        
								# 		h3("Filter"),
								# 		fluidRow(
								# 				column(width=4,
								# 						pickerInput(inputId = "edit_datatype", 
								# 								label = "Select table to edit :", 
								# 								choices = sort(c("NULL","t_series_ser",
								# 												"t_eelstock_eel",
								# 												"t_eelstock_eel_perc",
								# 												"t_biometry_series_bis",
								# 												"t_dataseries_das")),
								# 								selected="NULL",
								# 								multiple = FALSE,  
								# 								options = list(
								# 										style = "btn-primary", size = 5))),
								# 				column(width=4, 
								# 						pickerInput(inputId = "editpicker1", 
								# 								label = "", 
								# 								choices = "",
								# 								multiple = TRUE, 
								# 								options = list(
								# 										style = "btn-primary", size = 5))),
								# 				column(width=4, 
								# 						pickerInput(inputId = "editpicker2", 
								# 								label = "", 
								# 								choices = "",
								# 								multiple = TRUE, 
								# 								options = list(
								# 										style = "btn-primary", size = 5))),
								# 				column(width=4,
								# 						sliderTextInput(inputId ="yearAll", 
								# 								label = "Choose a year range:",
								# 								choices=seq(the_years$min_year, the_years$max_year),
								# 								selected = c(the_years$min_year,the_years$max_year)
								# 						))),                                                         
								# 		helpText("This table is used to edit data in the database
								# 						After you double click on a cell and edit the value, 
								# 						the Save and Cancel buttons will show up. Click on Save if
								# 						you want to save the updated values to database; click on
								# 						Cancel to reset."),
								# 		br(), 
								# 		fluidRow(                                       
								# 				column(width=6,verbatimTextOutput("database_errorsAll")),
								# 				column(width=2,hidden(actionButton("addRowTable_corAll", "Add Row"))),
								# 				column(width=2,actionButton("clear_tableAll", "clear")),
								# 				column(width=2,uiOutput("buttons_data_correctionAll"))
								# 		),                
								# 		br(),
								# 		DT::dataTableOutput("table_corAll"),
								# 		fluidRow(column(width=10),
								# 				leafletOutput("maps_editedtimeseries",height=600))),
								
								# plot for duplicates  ------------------------------------------------------------------
								
								# tabItem("plot_duplicates", 
								# 		box(width=NULL, title= "Data exploration tab",
								# 				fluidRow(
								# 						column(width=4,
								# 								pickerInput(inputId = "country_g", 
								# 										label = "Select a country :", 
								# 										choices = list_country,
								# 										selected = "FR",
								# 										multiple = FALSE, 
								# 										options = list(
								# 												style = "btn-primary", size = 5))),
								# 						column(width=4, 
								# 								pickerInput(inputId = "typ_g", 
								# 										label = "Select a type :", 
								# 										choices = typ_id,
								# 										selected= 4,
								# 										multiple = FALSE,
								# 										options = list(
								# 												style = "btn-primary", size = 5))),
								# 						column(width=4,
								# 								sliderTextInput(inputId ="year_g", 
								# 										label = "Choose a year range:",
								# 										choices=seq(the_years$min_year, current_year),
								# 										selected = c(the_years$min_year,the_years$max_year)
								# 								)))),               
								# 		
								# 		fluidRow(
								# 				column(width=6,
								# 						plotOutput("duplicated_ggplot",
								# 								click = clickOpts(id = "duplicated_ggplot_click")
								# 						)),
								# 				column(width=6,
								# 						plotlyOutput("plotly_selected_year"))
								# 		),     
								# 		DT::dataTableOutput("datatablenearpoints",width='100%')                                        
								# ),
								# tabItem(tabName="integrate_new_participants",
								# 		h2("Enter the name of a new participant"),
								# 		fluidRow(
								# 				column(width=10,textInput("new_participants_id", "Enter the name of the new participant (FirstName LastName)",
								# 								value=""
								# 						)),
								# 				column(width=2,  actionButton(inputId="new_participants_ok", label="Validate"))
								# 		),
								# 		
								# 		fluidRow(
								# 				column(width=10,
								# 						htmlOutput("new_participants_txt")
								# 				))
								# ),
                tabItem("Importmodule",
                       importstep0UI("importstep0module"),
                       importstep1UI("importstep1module"),
                       importstep2UI("importstep2module")
                        ),
                tabItem("Importtsmodule",
                    importtsstep0UI("importtsstep0module"),
                    importtsstep1UI("importtsstep1module"),
                    importtsstep2UI("importtsstep2module")
                  ),
								tabItem("editAllmodule",
										tableEditUI("tableEditmodule")),
                tabItem("newparticipantstabmodule",
                    newparticipantsUI("newparticipantsmodule")),
                tabItem("plot_duplicates_module",
                        plotduplicatesUI("plotduplicatesmodule"))
						
						)
				)
		)
)

