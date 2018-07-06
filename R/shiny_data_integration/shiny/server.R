shinyServer(function(input, output, session){ 
      data<-reactiveValues()
      # this will add a path value to reactive data
      step0_filepath <- reactive({
            inFile <- input$xlfile      
            if (is.null(inFile)){        return(NULL)
            } else {
              data$path0<-inFile$datapath #path to a temp file             
            }
          })  
      # This will run as a reactive function only if triggered by 
      # a button click (check) and will return res, a list with
      # both data and errors
      step0load_data<-reactive({
            if (is.null(data$path0)) return(NULL)
            cat(data$path0)
            if (is.null(data$path0)) return(NULL)
            switch (input$file_type, "catch_landings"={                  
                  message<-capture.output(load_catch_landings(data$path0))},
                "stock"={
                  message<-"not developped yet"},
                "aquaculture"={
                  message<-capture.output(load_aquaculture(data$path0))},
                "stocking"={
                  message<-"not developped yet"},
            )
            switch (input$file_type, "catch_landings"={                  
                  invisible(capture.output(res<-load_catch_landings(data$path0)))},
                "stock"={
                  res<-list(NULL)},
                "aquaculture"={
                  invisible(capture.output(res<-load_aquaculture(data$path0)))},
                "stocking"={
                  res<-list(NULL)},
            )
            return(list(res=res,message=message))
          })
      
   
      
      
      # this will print the error messages to the console
      #  the load function is just used to capture
      # the messages in the console (the data will not be returned to capture.output
      # load function use return(invisible(data))
      output$integrate<-renderText({
            # Simply accessing input$check_file_button here makes this reactive
            # object take a dependency on it. That means when
             # input$check_file_button changes, this code will re-execute.
            input$check_file_button
            validate(
                need(input$xlfile != "", "Please select a data set")
            )
            ls<-step0load_data()
#            cat(str(ls))
#            validate(
#                need(ls$message!=NULL, "Please click on the button"))
            paste(ls$message,collapse="\n")
                     
          })         
      
      #####################
      # DataTable integration error
      ########################
      output$dt_integrate<-DT::renderDataTable({
            validate(need(input$xlfile != "", "Please select a data set"))           
            ls<-step0load_data()  
            if (nrow(ls$res$error>0)){    
            datatable(ls$res$error,
                rownames=FALSE,          
                extensions = "Buttons",
                # internationalisation enregistre le ficher de l'url
                option=list("pagelength"=5,
                    lengthMenu=list(c(10,50,-1),c("10","50","All")),
                    order=list(5,"asc"),
                    dom= "Blfrtip", # de gauche a droite button en search, t tableau, i information (showing..), p pagination
                    buttons=list(
                        list(extend="excel",
                            filename = paste0("data_",Sys.Date()))) #  JSON behind the scene
                ))
            } else {
              "no value in error table"
            }
          })
      
      observeEvent(input$check_duplicate_button, {            
            session$sendCustomMessage(type = 'testmessage',
                message = 'Checking for duplicates')
            
            switch (input$file_type, "catch_landings"={ 
                  data_from_excel<- load_catch_landings(step0_filepath)                  
                  data_from_base<-extract_data("Catches and landings")                  
                },
                "stock"={
                  # TODO: develop for stock                 
                  return("not developped yet")},
                "aquaculture"={
                  data_from_excel<- load_aquaculture(step0_filepath)                  
                  data_from_base<-extract_data("Aquaculture")},
                "stocking"={
                  # TODO:
                  return("not developped yet")}
            )
            # the compare_with_database function will compare
            # what is in the database and the content of the excel file
            # previously loaded. It will return a list with two components
            # the first duplicates contains elements to be returned to the use
            # the second new contains a dataframe to be inserted straight into
            # the database
            if (nrow(data_from_excel$data)>0){
              list_comp<-compare_with_database(data_from_excel$data,data_from_base)
              data$new<-list_comp$new
              data$duplicates<-list_comp$duplicates
              
            }
          })
      # renders a datatable with duplicates 
      output$dt_duplicates <-DT::renderDataTable({
            #TODO change this to file imported as second step
            
            validate(
                need(input$xlfile != "", "Please select a data set")
            )
            path<- step0_filepath()        
            if (is.null(path)) return("No check yet, please load the file")
            switch (input$file_type, "catch_landings"={                  
                  message<-capture.output(load_catch_landings(path))},
                "stock"={
                  message<-"not developped yet"},
                "aquaculture"={
                  message<-capture.output(load_aquaculture(path))},
                "stocking"={
                  message<-"not developped yet"},
            )
            datatable(data$duplicates,
                rownames=FALSE,          
                extensions = "Buttons",
                # internationalisation enregistre le ficher de l'url
                option=list("pagelength"=5,
                    lengthMenu=list(c(10,50,-1),c("10","50","All")),
                    order=list(5,"asc"),
                    dom= "Blfrtip", # de gauche a droite button en search, t tableau, i information (showing..), p pagination
                    buttons=list(
                        list(extend="excel",
                            filename = paste0("data_",Sys.Date()))) #  JSON behind the scene
                ))
          })
      
    })