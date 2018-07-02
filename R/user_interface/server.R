# test shiny interface for maps.R
# 
# Author: lbeaulaton
###############################################################################


#########################
# shiny sever
########################


# create a user interface
ui = fluidPage(
		headerPanel('Test'),
		sidebarPanel(
				radioButtons("dataset", "Dataset", c("aquaculture", "landings", "stocking"), selected = "landings", inline = TRUE),
				sliderInput("year", "Year", value = 2015, min = 1920, max = 2017, step = 1, sep = ""),
				checkboxGroupInput("lfs", "Life stage", lfs_code_base, selected = "G", inline = TRUE),
				radioButtons("geo", "Geographical level", c("country", "emu"), selected = "country", inline = TRUE),
				sliderInput("coef", "Size of circles", value = 5, min = 0, max = 100, step = 5, sep = ""),
				checkboxGroupInput("country", "Country (for table only)", country_ref$cou_code, inline = TRUE)
		),

		mainPanel(
				tabsetPanel(
						tabPanel("Map", leafletOutput("map", height = 800)),
						tabPanel("Table", DT::dataTableOutput("table"), downloadButton('downloadData', 'Download data')),
						tabPanel("Test", textOutput("test"))
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

	output$test = renderPrint({cat(input$lfs)})
	
	output$table = DT::renderDataTable(dcast(extract_data(input$dataset, life_stage = input$lfs, country = input$country),eel_year~eel_cou_code), options = list(dom = 'lftp', pageLength = 10))
	
	output$downloadData <- downloadHandler(
			filename = function() { paste('test_', input$year, '.csv', sep='') },
			content = function(file) {
				write.csv(dcast(extract_data(input$dataset, life_stage = input$lfs, country = input$country),eel_year~eel_cou_code), file, row.names = FALSE)
			}
	)
}
