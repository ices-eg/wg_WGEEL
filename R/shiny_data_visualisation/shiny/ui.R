# user interface for shiny
# 
# Author: lbeaulaton
###############################################################################

ui = fluidPage(
		headerPanel('WGEEL data visualition tool'),
		sidebarPanel(
				radioButtons("dataset", "Dataset", c("aquaculture", "landings", "stocking", "precodata"), selected = "landings", inline = TRUE),
				sliderTextInput("year", "Year", 
                    choices=seq(from=min(landings$eel_year),to= as.numeric(format(Sys.time(), "%Y")),by=1),
                     selected=c(1980,as.numeric(format(Sys.time(), "%Y")))),
				checkboxGroupInput("lfs", "Life stage", lfs_code_base$lfs_code, selected = "G", inline = TRUE),
				radioButtons("geo", "Geographical level", c("country", "emu"), selected = "country", inline = TRUE),
#				sliderInput("coef", "Size of circles", value = 5, min = 0, max = 100, step = 5, sep = ""),
				checkboxGroupInput("country", "Country", country_ref$cou_code, inline = TRUE)
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


