# test shiny interface for maps.R
# 
# Author: lbeaulaton
###############################################################################

# execute maps.R until c1 is created

if(!require(shiny)) install.packages("shiny") ; require(shiny)
if(!require(DT)) install.packages("DT") ; require(DT)

# create a user interface
ui = fluidPage(
		headerPanel('Test'),
		sidebarPanel(
				radioButtons("dataset", "Dataset", c("aquaculture", "landings", "catch_landings", "catch", "stocking"), selected = "catch_landings", inline = TRUE),
				sliderInput("year", "Year", value = 2015, min = 2007, max = 2017, step = 1, sep = ""),
				radioButtons("lfs", "Life stage", lfs_code_base, selected = "G", inline = TRUE),
				radioButtons("geo", "Geographical level", c("country", "emu"), selected = "country", inline = TRUE),
				sliderInput("coef", "Size of circles", value = 5, min = 0, max = 100, step = 5, sep = "")
		),

		mainPanel(
				tabsetPanel(
						tabPanel("Map", leafletOutput("map", height = 800)),
						tabPanel("Table", DT::dataTableOutput("table"), downloadButton('downloadData', 'Download data'))
				)
		)
)

# create server configuration
server = function(input, output) {
	output$map = renderLeaflet( {
				draw_leaflet(dataset = input$dataset,
						year = input$year,
						lfs_code= input$lfs,
						coeff = input$coef,
						map = input$geo)} )
	
	output$table = DT::renderDataTable(dcast(c1,eel_year~eel_cou_code), options = list(dom = 'lftp', pageLength = 10))
	
	output$downloadData <- downloadHandler(
			filename = function() { paste('test_', input$year, '.csv', sep='') },
			content = function(file) {
				write.csv(dcast(c1,eel_year~eel_cou_code), file, row.names = FALSE)
			}
	)
}

# Launch shiny and open your browser
shinyApp(ui, server, option =  list(port = 1234, host = "0.0.0.0", launch.browser = T))