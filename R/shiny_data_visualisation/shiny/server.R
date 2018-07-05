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
	output$table = DT::renderDataTable({if(input$dataset == "precodata"){
					DT::datatable(filter_data("precodata", life_stage = NULL, country = input$country))
				} else {
					dcast(filter_data(input$dataset, life_stage = input$lfs, country = input$country), eel_year~eel_cou_code, options = list(dom = 'lftp', pageLength = 10))
				}})
	
	output$downloadData <- downloadHandler(
			filename = function() { paste('test_', input$year, '.csv', sep='') },
			content = function(file) {
				if(input$dataset == "precodata"){
					write.csv(filter_data("precodata", life_stage = NULL, country = input$country), file, row.names = FALSE)
				} else {
					write.csv(dcast(filter_data(input$dataset, life_stage = input$lfs, country = input$country),eel_year~eel_cou_code), file, row.names = FALSE)
				}
			}
	)
	
	# graph
	output$graph = renderPlot(trace_precodiag(precodata))
	
	output$downloadGraph <- downloadHandler(
			filename = function() { paste('precodiag_', input$year, '.png', sep='') },
			content = function(file) {
				ggsave(file, trace_precodiag(precodata), device = "png")
			}
	)
}

