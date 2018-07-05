# user interface for shiny
# 
# Author: lbeaulaton
###############################################################################

ui = fluidPage(
		headerPanel('Test'),
		sidebarPanel(
				radioButtons("dataset", "Dataset", c("aquaculture", "landings", "stocking", "precodata"), selected = "landings", inline = TRUE),
				sliderInput("year", "Year", value = 2015, min = 1920, max = 2017, step = 1, sep = ""),
				checkboxGroupInput("lfs", "Life stage", lfs_code_base$lfs_code, selected = "G", inline = TRUE),
				radioButtons("geo", "Geographical level", c("country", "emu"), selected = "country", inline = TRUE),
				sliderInput("coef", "Size of circles", value = 5, min = 0, max = 100, step = 5, sep = ""),
				checkboxGroupInput("country", "Country (for table only)", country_ref$cou_code, inline = TRUE)
		),
		
		mainPanel(
				tabsetPanel(
#						tabPanel("Map", leafletOutput("map", height = 800)),
						tabPanel("Table", DT::dataTableOutput("table"), downloadButton('downloadData', 'Download data')),
						tabPanel("Graph", plotOutput("graph"), downloadButton('downloadGraph', 'Download graph')),
						tabPanel("Test", textOutput("test"))
				)
		)
)


