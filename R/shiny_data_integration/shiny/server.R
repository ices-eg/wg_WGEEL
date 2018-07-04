shinyServer(function(input, output, session){ 
      # this will print the error messages to the console
      output$integrate<-renderPrint({            
            inFile <- input$xlfile      
            if (is.null(inFile)){        return(NULL)
            } else {
              switch (input$file_type, "catch_landings"={
                    return(capture.output(load_catch_landings(inFile$datapath)))},
                  "stock"={
                    return("not developped yet")},
                  "aquaculture"={
                    return("not developped yet")},
                  "stocking"={
                    return("not developped yet")},
              )
            }            
          })
      observeEvent(input$check_duplicate, {
                session$sendCustomMessage(type = 'testmessage',
                      message = 'Checking for duplicates')
            })
    })