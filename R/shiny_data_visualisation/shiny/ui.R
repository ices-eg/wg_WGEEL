# user interface for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################

ui = dashboardPage(title="ICES Data Visualisation",
    dashboardHeader(title=div(img(src="iceslogo.png")," wgeel")),
    dashboardSidebar(
        # A button that stops the application
        extendShinyjs(text = jscode, functions = c("closeWindow")),
        actionButton("close", "Close window"),       
	    sidebarMenu(
            menuItem("Table",tabName= "table_tab", icon= icon("table")),
            menuItem("Landings", tabName="landings_tab", icon=icon("bar-chart-o"),
                menuSubItem("Raw + cor",  tabName="combined_landings_tab"),
                menuSubItem("Raw",  tabName="raw_landings_tab"),               
                menuSubItem("Available Data",tabName="available_landings_tab"),
                menuSubItem("Habitat average",tabName="average_landings_habitat_tab"),
                menuSubItem("Habitat sum",tabName="sum_landings_habitat_tab")
            ),
            menuItem("Map", tabName='map_tab',icon= icon("globe")),  
            menuItem("Preco-diag", tabName='precodata_tab',icon= icon("dashboard",lib="glyphicon")),            
            sliderTextInput("year", "Year", 
                choices=seq(from=min(landings$eel_year),to= as.numeric(format(Sys.time(), "%Y")),by=1),
                selected=c(1980,as.numeric(format(Sys.time(), "%Y")))),
            radioGroupButtons(
                inputId = "geo",
                label = "Scale", 
                choices = c("country", "emu"), 
                selected = "country"      
            ),
            pickerInput(
                inputId = "lfs",
                label = "Life stage", 
                choices = lfs_code_base$lfs_code,
                selected=lfs_code_base$lfs_code,
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE)
            ),
            pickerInput(
                inputId = "habitat",
                label = "Habitat", 
                choices = c(habitat_ref$hty_code,"NA"),
                selected=c(habitat_ref$hty_code,"NA"),
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE)
            ),
		    pickerInput(
                inputId = "country",
                label =  "Country", 
                choices = levels(country_ref$cou_code), 
                selected= levels(country_ref$cou_code), 
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE))
	    )),	
	dashboardBody(
        useShinyjs(), # to be able to use shiny js                           
		tabItems(
            tabItem(tabName="table_tab",
                box(id="box_table",
                    title="Table per country",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(column(width=4,
                            radioGroupButtons(
                                inputId = "dataset",
                                label = "Dataset",
                                choices = c("landings","aquaculture", "release", "precodata"),
                                status = "primary",
                                checkIcon = list(
                                    yes = icon("ok", 
                                        lib = "glyphicon"),
                                    no = icon("remove",
                                        lib = "glyphicon"))
                            )), 
                        column(width=6,htmlOutput("table_description"))),
                    DT::dataTableOutput("table"))),
			tabItem(tabName="combined_landings_tab", 
                fluidRow(                    
                    column(width=10,plotOutput("graph_combined",height="800px")),
                    column(width=2,htmlOutput("graph_combined_description"),
                        actionBttn(
                               inputId = "combined_button",
                               label = NULL,
                               style = "material-circle", 
                                color = "success",
                                icon("refresh",lib="glyphicon")
                        ),                              
                        downloadBttn(
                            outputId = "download_graph_combined",
                            label = "D", 
                            style = "material-circle", ,
                            color = "danger")
                    )
                )
            ),
            tabItem(tabName="raw_landings_tab", 
                box(id="box_graph",
                    title="Landings",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(column(width=2, materialSwitch(
                                inputId = "habitat_switch",
                                label = "By habitat", 
                                value = FALSE,
                                status = "primary"
                            )),
                        column(width=2,  materialSwitch(
                                inputId = "lifestage_switch",
                                label = "By lifestage", 
                                value = FALSE,
                                status = "primary"
                            ))
                    ))),
            tabItem(tabName="available_landings_tab"),
            tabItem(tabName="average_landings_habitat_tab"),
            tabItem(tabName="sum_landings_habitat_tab"),
            tabItem(tabName="precodata_tab",
                fluidRow(                    
                    column(width=8,plotOutput("precodata_graph",height="800px")),
                    column(width=4, 
                        actionBttn(
                            inputId = "precodata_button",
                            label = NULL,
                            style = "material-circle", 
                            color = "success",
                            icon("refresh",lib="glyphicon")
                        ),        
                        downloadBttn(
                            outputId = "download_precodata_graph",
                            label = "D",
                            style = "material-circle", ,
                            color = "danger")
                    )
                )            
            ),
            
			tabItem(tabName="map_tab", 
			    leafletOutput("map", height = 800)
			)
		)
	)
)


