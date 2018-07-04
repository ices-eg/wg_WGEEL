shinyServer(function(input, output, session){ 
      output$integrate<-renderPrint({
      inFile <- input$xlfile
      
      if (is.null(inFile)){        return(NULL)
        } else {
          return(capture.output(load_catch_landings(inFile$datapath)))
        }

    })
})