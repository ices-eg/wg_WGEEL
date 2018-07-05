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
# TODO : integrate a data from the load_functions and display in excel with download button.
      # this part is triggered when the user clicks on check_duplicate
      # A message is returned to the user
      # then the load function is really used, not just to capture
      # the messages in the console.
      observeEvent(input$check_duplicate, {
            inFile <-input$xlfile   
            if (is.null(inFile))        return(NULL)
            session$sendCustomMessage(type = 'testmessage',
                message = 'Checking for duplicates')
            switch (input$file_type, "catch_landings"={ 
                  data_from_excel<- load_catch_landings(inFile$datapath)                  
                  data_from_base<-extract_data("Catches and landings")
                },
                "stock"={
# TODO: develop for other stocking                  
                  return("not developped yet")},
                "aquaculture"={
                  return("not developped yet")},
                "stocking"={
                  return("not developped yet")},
            )
            # the compare_with_database function will compare
            # what is in the database and the content of the excel file
            # previously loaded. It will return a list with two components
            # the first duplicates contains elements to be returned to the use
            # the second new contains a dataframe to be inserted straight into
            # the database
            
            list_comp<-compare_with_database(data_from_excel,data_from_base)
            new<-list_comp$new
            duplicates<-list$duplicates
          })
    })