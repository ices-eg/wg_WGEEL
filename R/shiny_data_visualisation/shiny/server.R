# server paramater for shiny
# 
# Author: lbeaulaton
###############################################################################

# create server configuration
server = function(input, output) {
#	output$map = renderLeaflet( {
#				draw_leaflet(dataset = input$dataset,
#						year = input$year,
#						lfs_code= input$lfs,
#						coeff = input$coef,
#						map = input$geo)} )
	
	output$test = renderPrint({cat(input$lfs)})
	
	# table
	output$table = DT::renderDataTable(DT::datatable(data_to_display(input), rownames = FALSE))
	
	output$downloadData <- downloadHandler(
			filename = function() { paste(input$dataset,'_', input$yearmin, '-', input$yearmax, '.csv', sep='') },
			content = function(file) {
#				if(input$dataset == "precodata"){
#					write.csv(filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$yearmin:input$yearmax), file, row.names = FALSE)
#				} else {
#					write.csv(dcast(filter_data(input$dataset, life_stage = input$lfs, country = input$country, year_range = input$yearmin:input$yearmax),eel_year~eel_cou_code), file, row.names = FALSE)
#				}
				write.csv(data_to_display(input), file, row.names = FALSE)
			}
	)

	# graph
	# TODO: switch graph according to dataset selected
	output$graph = renderPlot(trace_precodiag(filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$yearmin:input$yearmax)))
	
	output$downloadGraph <- downloadHandler(
			filename = function() { paste('precodiag_', input$yearmin, '-', input$yearmax, '.png', sep='') },
			content = function(file) {
				ggsave(file, trace_precodiag(filter_data("precodata", life_stage = NULL, country = input$country, year_range = input$yearmin:input$yearmax)), device = "png", width = 28, height = 23, units = "cm")
			}
	)
}
