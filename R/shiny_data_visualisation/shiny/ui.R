# user interface for shiny
# 
# Authors: lbeaulaton Cedric
###############################################################################

ui = fluidPage(
    useShinyjs(), # to be able to use shiny js 
	headerPanel('WGEEL data visualition tool'),
	sidebarPanel(
        # A button that stops the application
        extendShinyjs(text = jscode, functions = c("closeWindow")),
        actionButton("close", "Close window"),  
		radioButtons("dataset", "Dataset", c("aquaculture", "landings", "stocking", "precodata"), selected = "landings", inline = TRUE),
        sliderTextInput("year", "Year", 
            choices=seq(from=min(landings$eel_year),to= as.numeric(format(Sys.time(), "%Y")),by=1),
            selected=c(1980,as.numeric(format(Sys.time(), "%Y")))),
		checkboxGroupInput("lfs", "Life stage", lfs_code_base$lfs_code, selected=lfs_code_base$lfs_code, inline = TRUE),
        checkboxGroupInput("habitat", "Habitat", c(habitat_ref$hty_code,"NA"), selected = c(habitat_ref$hty_code,"NA"), inline = TRUE),				
        radioButtons("geo", "Geographical level", c("country", "emu"), selected = "country", inline = TRUE),
#				sliderInput("coef", "Size of circles", value = 5, min = 0, max = 100, step = 5, sep = ""),
		checkboxGroupInput("country", "Country", country_ref$cou_code, selected= country_ref$cou_code, inline = TRUE),
        actionLink("deselectall","Deselect All") 
	),
	
	mainPanel(                
		tabsetPanel(#						
			tabPanel("Table",
                htmlOutput("table_description"),
                DT::dataTableOutput("table")),
			tabPanel("Graph", 
                uiOutput("switch_landings_graph"),
                htmlOutput("graph_description"),
                plotOutput("graph")
            ),
			tabPanel("Map", 
			         leafletOutput("map", height = 800)
			         )
		)
	)
)


