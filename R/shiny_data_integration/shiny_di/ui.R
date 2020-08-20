###############################################
# Ui file for ICES data integration tools
###############################################

ui <- dashboardPage(title="ICES Data Integration",
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
						menuItem("Import",tabName= "import", icon= icon("align-left")),
						menuItem("Import timeseries",tabName= "import_ts", icon= icon("align-left")),					
						menuItem("Edit", tabName="edit", icon=icon("table")),
						menuItem("Plot duplicates", tabName='plot_duplicates',icon= icon("area-chart")#,
						#menuSubItem("Plot duplicates",  tabName="plot_duplicates"),
						#menuSubItem("plot2", tabName="plot2")
						),
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
						selected="Jan-Dag Pohlmann"
				
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
						
						
						tabItem(tabName="import",
								h2("Datacall Integration and checks"),
								h2("step 0 : Data check"),
								fluidRow(
										column(width=4,fileInput("xlfile", "Choose xls File",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),
										column(width=4,  radioButtons(inputId="file_type", label="File type:",
														c(" Catch and Landings" = "catch_landings",
																"Release" = "release",
																"Aquaculture" = "aquaculture",                                
																"Biomass indicators" = "biomass",
																"Habitat - wetted area"= "potential_available_habitat",
																"Mortality silver equiv. Biom."="mortality_silver_equiv",
																"Mortality_rates"="mortality_rates"					
														))),
										column(width=4, actionButton("check_file_button", "Check file") )                     
								),
								
								fluidRow(
										column(width=6,
												htmlOutput("step0_message_txt"),
												verbatimTextOutput("integrate"),placeholder=TRUE),
										column(width=6,
												htmlOutput("step0_message_xls"),
												DT::dataTableOutput("dt_integrate"))
								),              
								tags$hr(),
								h2("step 1 : Compare with database"),
								fluidRow(                                       
										column(width=2,                        
												actionButton("check_duplicate_button", "Check duplicate")), 
										column(width=5,
												htmlOutput("step1_message_duplicates"),
												DT::dataTableOutput("dt_duplicates"),
												DT::dataTableOutput("dt_check_duplicates")),
										column(width=5,
												htmlOutput("step1_message_new"),
												DT::dataTableOutput("dt_new"),
												DT::dataTableOutput("dt_missing"))
								),
								tags$hr(),
								h2("step 2.1 Integrate/ proceed duplicates rows"),
								fluidRow(
										column(width=4,fileInput("xl_duplicates_file", "xls duplicates",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),                   
										column(width=2,
												actionButton("database_duplicates_button", "Proceed")),
										column(width=6,verbatimTextOutput("textoutput_step2.1"))
								),
								h2("step 2.2 Integrate new rows"),
								fluidRow(
										column(width=4,fileInput("xl_new_file", "xls new",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),                   
										column(width=2,
												actionButton("database_new_button", "Proceed")),
										column(width=6,verbatimTextOutput("textoutput_step2.2"))
								)
						),
						
						# time series integration table ---------------------------------------------------------
						
						tabItem(tabName="import_ts",
								h2("Datacall time series (glass / yellow / silver) integration"),								
								h2("step 0 : Data check"),
								fluidRow(
										column(width=4,fileInput("xlfile_ts", "Choose xls File",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),
										column(width=4,  radioButtons(inputId="file_type_ts", label="File type:",
														c(	"Glass eel"="glass_eel",
																"Yellow eel"="yellow_eel",
																"Silver eel"="silver_eel"
														))),
										column(width=4, actionButton("check_file_button_ts", "Check file") )                     
								),
								
								fluidRow(
										column(width=6,
												htmlOutput("step0_message_txt_ts"),
												verbatimTextOutput("integrate_ts"),placeholder=TRUE),
										column(width=6,
												htmlOutput("step0_message_xls_ts"),
												DT::dataTableOutput("dt_integrate_ts"))
								),              
								tags$hr(),
								h2("step 1 : Compare with database"),
								fluidRow(                                       
										column(width=2,                        
												actionButton("check_duplicate_button_ts", "Check duplicate")), 
										column(width=5,
												htmlOutput("step1_message_duplicates_ts"),
												DT::dataTableOutput("dt_duplicates_ts"),
												DT::dataTableOutput("dt_check_duplicates_ts")),
										column(width=5,
												htmlOutput("step1_message_new_ts"),
												DT::dataTableOutput("dt_new_ts"),
												DT::dataTableOutput("dt_missing_ts"))
								),
								tags$hr(),
								h2("step 2.1 Integrate/ proceed duplicates rows"),
								fluidRow(
										column(width=4,fileInput("xl_duplicates_file_ts", "xls duplicates",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),                   
										column(width=2,
												actionButton("database_duplicates_button_ts", "Proceed")),
										column(width=6,verbatimTextOutput("textoutput_step2.1_ts"))
								),
								h2("step 2.2 Integrate new rows"),
								fluidRow(
										column(width=4,fileInput("xl_new_file", "xls new",
														multiple=FALSE,
														accept = c(".xls",".xlsx")
												)),                   
										column(width=2,
												actionButton("database_new_button_ts", "Proceed")),
										column(width=6,verbatimTextOutput("textoutput_step2.2_ts"))
								)
						),
						
						# Data correction table  ----------------------------------------------------------------
						
						tabItem("edit",
								h2("Data correction table"),
								br(),        
								h3("Filter"),
								fluidRow(
										column(width=4,
												pickerInput(inputId = "country", 
														label = "Select a country :", 
														choices = list_country,
														multiple = TRUE,  
														options = list(
																style = "btn-primary", size = 5))),
										column(width=4, 
												pickerInput(inputId = "typ", 
														label = "Select a type :", 
														choices = typ_id,
														multiple = TRUE, 
														options = list(
																style = "btn-primary", size = 5))),
										column(width=4,
												sliderTextInput(inputId ="year", 
														label = "Choose a year range:",
														choices=seq(the_years$min_year, the_years$max_year),
														selected = c(the_years$min_year,the_years$max_year)
												))),                                                         
								helpText("This table is used to edit data in the database
												After you double click on a cell and edit the value, 
												the Save and Cancel buttons will show up. Click on Save if
												you want to save the updated values to database; click on
												Cancel to reset."),
								br(), 
								fluidRow(                                       
										column(width=8,verbatimTextOutput("database_errors")),
										column(width=2,actionButton("clear_table", "clear")),
										column(width=2,uiOutput("buttons_data_correction"))
								),                
								br(),
								DT::dataTableOutput("table_cor")),
						
						# plot for duplicates  ------------------------------------------------------------------
						
						tabItem("plot_duplicates", 
								box(width=NULL, title= "Data exploration tab",
										fluidRow(
												column(width=4,
														pickerInput(inputId = "country_g", 
																label = "Select a country :", 
																choices = list_country,
																selected = "FR",
																multiple = FALSE, 
																options = list(
																		style = "btn-primary", size = 5))),
												column(width=4, 
														pickerInput(inputId = "typ_g", 
																label = "Select a type :", 
																choices = typ_id,
																selected= 4,
																multiple = FALSE,
																options = list(
																		style = "btn-primary", size = 5))),
												column(width=4,
														sliderTextInput(inputId ="year_g", 
																label = "Choose a year range:",
																choices=seq(the_years$min_year, the_years$max_year),
																selected = c(the_years$min_year,the_years$max_year)
														)))),               
								
								fluidRow(
										column(width=6,
												plotOutput("duplicated_ggplot",
														click = clickOpts(id = "duplicated_ggplot_click")
												)),
										column(width=6,
												plotlyOutput("plotly_selected_year"))
								),     
								dataTableOutput("datatablenearpoints",width='100%')                                        
						)#,
				
				# second plot (not dev yet) -------------------------------------------------------------
				
#            tabItem("plot2", fluidRow(
#                    column(width=6,plotOutput("mon_graph2")),
#                    column(width=6,plotOutput("mon_ggplot2"))
#                ))
				)
		)
)


