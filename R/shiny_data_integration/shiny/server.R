shinyServer(function(input, output, session){ 
      ##########################
      # reactive values in data
      ##########################
      data<-reactiveValues()
      ###########################
      # step0_filepath
      # this will add a path value to reactive data in step0
      ###########################
      step0_filepath <- reactive({
            inFile <- input$xlfile      
            if (is.null(inFile)){        return(NULL)
            } else {
              data$path_step0<-inFile$datapath #path to a temp file             
            }
          }) 
      ###########################
      # step0load_data reactive function 
      # This will run as a reactive function only if triggered by 
      # a button click (check) and will return res, a list with
      # both data and errors
      ###########################
      step0load_data<-function(){
        if (is.null(data$path_step0)) return(NULL)
        switch (input$file_type, "catch_landings"={                  
              message<-capture.output(load_catch_landings(data$path_step0))},
            "stock"={
              message<-"not developped yet"},
            "aquaculture"={
              message<-capture.output(load_aquaculture(data$path_step0))},
            "stocking"={
              message<-"not developped yet"},
        )
        switch (input$file_type, "catch_landings"={                  
              invisible(capture.output(res<-load_catch_landings(data$path_step0)))},
            "stock"={
              res<-list(NULL)},
            "aquaculture"={
              invisible(capture.output(res<-load_aquaculture(data$path_step0)))},
            "stocking"={
              res<-list(NULL)},
        )
        return(list(res=res,message=message))
      }
      ##################################################
      # integrate verbatimtextoutput
      # this will print the error messages to the console
      #  the load function is just used to capture
      # this component is rendered reactive by the inclusion of 
      #  a reference to inuput$check_file_button
      #################################################
      observeEvent(input$check_file_button, {
            output$integrate<-renderText({
                  # call to  function that loads data
                  # this function does not need to be reactive
                  if (is.null(data$path_step0)) "please select a dataset" else {          
                    ls<-step0load_data()
                    paste(ls$message,collapse="\n")
                  }
                  
                }) 
          })    
      ##################################
      # Actively generates UI component on the ui side 
      # which displays text for xls download
      ##################################
      observeEvent(input$check_file_button, {
            output$"step0_message_xls"<-renderUI(
                HTML(
                    paste(
                        h4("File checking messages (xls)"),
                        "<p align='left'>Please click on excel",'<br/>',
                        "to download this file correct your errors",'<br/>',
                        "and submit again the file once it's corrected<p>"
                    )))  
          })
      ##################################
      # Actively generates UI component on the ui side
      # which generates text for txt
      ##################################      
      observeEvent(input$check_file_button, {
            output$"step0_message_txt"<-renderUI(
                HTML(
                    paste(
                        h4("File checking messages (txt)"),
                        "<p align='left'>Please read carefully and ensure that you have",'<br/>',
                        "checked all possible errors <p>"
                    )))
          })
      
      #####################
      # DataTable integration error
      ########################
      observeEvent(input$check_file_button, {
            output$dt_integrate<-DT::renderDataTable({                 
                  validate(need(input$xlfile != "", "Please select a data set"))           
                  ls<-step0load_data()   
                  datatable(ls$res$error,
                      rownames=FALSE,
                      filter = 'top',
                      caption = htmltools::tags$caption(
                          style = 'caption-side: bottom; text-align: center;',
                          'Table 1: ', htmltools::em('Please check the following values, click on excel button to download.')
                      ),
                      extensions = "Buttons",
                      option=list(
                          "pagelength"=5,
                          searching = FALSE, # no filtering options
                          lengthMenu=list(c(5,20,50,-1),c("5","20","50","All")),
                          order=list(1,"asc"),
                          dom= "Blfrtip", # de gauche a droite button fr search, t tableau, i informaiton (showing..), p pagination
                          buttons=list(
                              list(extend="excel",
                                  filename = paste0("data_",Sys.Date()))) # JSON behind the scene
                      )            
                  )
                })
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