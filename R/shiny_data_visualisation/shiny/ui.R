# user interface for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################

ui = dashboardPage(title="ICES Data Integration",
    dashboardHeader(title=div(img(src="iceslogo.png"),"wgeel")),
    dashboardSidebar(
        # A button that stops the application
        extendShinyjs(text = jscode, functions = c("closeWindow")),
        actionButton("close", "Close window"),       
	    sidebarMenu(
            menuItem("Table",tabName= "table_tab", icon= icon("table")),
            menuItem("Graph", tabName="graph_tab", icon=icon("bar-chart-o"),
                menuSubItem("graph",  tabName="graph"),
                menuSubItem("plot2", tabName="plot2")),
            menuItem("Map", tabName='map_tab',icon= icon("globe")), 
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
            ),       
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
                choices = country_ref$cou_code, 
                selected= country_ref$cou_code, 
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE))
	    )),	
	dashboardBody(
        useShinyjs(), # to be able to use shiny js                           
		tabItems(
            tabItem(tabName="table_tab",
                htmlOutput("table_description"),
                DT::dataTableOutput("table")),
			tabItem(tabName="graph", 
                box(id="box_graph",
                    title="Landings",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(
                        column(width=4,               
                            radioButtons(inputId="landings_graph_type", label="Graph type:",
                                choices=c(
                                    "Raw and reconstructed combined"="combined",
                                    "Available Data"="available",
                                    "Raw landings per habitat average"="average_habitat",
                                    "Raw landings per habitat sum"="sum_habitat")   
                            )),
                        column(width=2, materialSwitch(
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
                    )),
                fluidRow(                    
                    column(width=8,plotOutput("graph")),
                    column(width=4,htmlOutput("graph_description"),
                        downloadBttn(
                            outputId = "downloadGraph",
                            label = "download", 
                            style = "gradient",
                            color = "primary")
                                   )
                               )
            ),
			tabItem(tabName="map_tab", 
			    leafletOutput("map", height = 800)
			)
		)
	)
)


