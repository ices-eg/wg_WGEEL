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
        path<- step0_filepath()   
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
      # Events triggerred by step0_button
      ###################################################
      observeEvent(input$check_file_button, {
            #cat(data$path_step0)
            ##################################################
            # integrate verbatimtextoutput
            # this will print the error messages to the console
            #  the load function is just used to capture
            # this component is rendered reactive by the inclusion of 
            #  a reference to inuput$check_file_button
            #################################################
            output$integrate<-renderText({
                  # call to  function that loads data
                  # this function does not need to be reactive
                  if (is.null(data$path_step0)) "please select a dataset" else {          
                    ls<-step0load_data()
                    paste(ls$message,collapse="\n")
                  }
                  
                }) 
            
            ##################################
            # Actively generates UI component on the ui side 
            # which displays text for xls download
            ##################################
            
            output$"step0_message_xls"<-renderUI(
                HTML(
                    paste(
                        h4("File checking messages (xls)"),
                        "<p align='left'>Please click on excel",'<br/>',
                        "to download this file correct your errors",'<br/>',
                        "and submit again the file once it's corrected<p>"
                    )))  
            
            ##################################
            # Actively generates UI component on the ui side
            # which generates text for txt
            ##################################      
            
            output$"step0_message_txt"<-renderUI(
                HTML(
                    paste(
                        h4("File checking messages (txt)"),
                        "<p align='left'>Please read carefully and ensure that you have",'<br/>',
                        "checked all possible errors <p>"
                    )))
            
            
            #####################
            # DataTable integration error
            ########################
            
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
      ##################################################
      # Events triggerred by step1_button
      ###################################################      
      ##########################
# When check_duplicate_button is clicked
# this will render a datatable containing rows
# with duplicates values
      #############################
      observeEvent(input$check_duplicate_button, {         
            # see step0load_data returns a list with res and messages
            # and within res data and a dataframe of errors
            validate(
                need(input$xlfile != "", "Please select a data set")
            ) 
            data_from_excel<- step0load_data()$res$data
            switch (input$file_type, "catch_landings"={                                     
                  data_from_base<-extract_data("Catches and landings")                  
                },
                "stock"={
                  # TODO: develop for stock                 
                },
                "aquaculture"={             
                  data_from_base<-extract_data("Aquaculture")},
                "stocking"={
                  # TODO:
                }
            )
            # the compare_with_database function will compare
            # what is in the database and the content of the excel file
            # previously loaded. It will return a list with two components
            # the first duplicates contains elements to be returned to the use
            # the second new contains a dataframe to be inserted straight into
            # the database
            cat("step0")
            if (nrow(data_from_excel)>0){
              list_comp<-compare_with_database(data_from_excel,data_from_base)
              duplicates <- list_comp$duplicates
              new <- list_comp$new 
              cat("step1")
              #####################      
              # Duplicates values
              #####################
              
              if (nrow(duplicates)==0) {
                  output$"step1_message_duplicates"<-renderUI(
                      HTML(
                          paste(
                              h4("No duplicates")                             
                          )))                 
                }else{      
                  output$"step1_message_duplicates"<-renderUI(
                      HTML(
                          paste(
                              h4("Table of duplicates (xls)"),
                              "<p align='left'>Please click on excel",'<br/>',
                              "to download this file and check whether to keep data",'<br/>',
                              "from the database or use the new inserted",'<br/>',
                              "don't forget to qualify your data otherwise they will be rejected",'<br/>',
                              "once this is done download the file and proceed to next step.<p>"                         
                          )))  
                }
              output$dt_duplicates <-DT::renderDataTable({                     
                    datatable(duplicates,
                        rownames=FALSE,
                        caption = htmltools::tags$caption(
                            style = 'caption-side: bottom; text-align: center;',
                            'Table 2: ', htmltools::em('Table of duplicates values, download and line by line change .')
                        ),                                             
                        extensions = "Buttons",
                        option=list("pagelength"=5,
                            lengthMenu=list(c(10,50,-1),c("10","50","All")),
                            order=list(5,"asc"),
                            dom= "Blfrtip",
                            scrollX = T, 
                            buttons=list(
                                list(extend="excel",
                                    filename = paste0("data_",Sys.Date()))) #  JSON behind the scene
                        ))
                  })
              if (nrow(new)==0) {
                  output$"step1_message_new"<-renderUI(
                      HTML(
                          paste(
                              h4("No new values")                             
                          )))                    
                } else {
                  output$"step1_message_new"<-renderUI(
                      HTML(
                          paste(
                              h4("Table of new values (xls)"),
                              "<p align='left'>Please click on excel ",
                              "to download this file and qualify your data with column qal_id, qal_comment ",
                              "once this is done download the file with button <strong>download new</strong> and proceed to next step.<p>"                         
                          )))  
                  
                }
              
              output$dt_new <-DT::renderDataTable({             
                    datatable(new,
                        rownames=FALSE,          
                        extensions = "Buttons",
                        option=list("pagelength"=5,
                            lengthMenu=list(c(10,50,-1),c("10","50","All")),
                            order=list(5,"asc"),
                            dom= "Blfrtip",
                            scrollX = T, 
                            buttons=list(
                                list(extend="excel",
                                    filename = paste0("data_",Sys.Date()))) #  JSON behind the scene
                        ))
                  })
            } # closes if nrow(...      
            data$new <- new # new is stored in the reactive dataset to be inserted later.      
          })
      
      
      ##########################
      # When database integration is clicked
      # this will trigger the data integration
      # TODO 
      #############################   
      
      ##########################
      # When database integration is clicked
      # this will trigger the data integration
      # TODO 
      #############################      
    })
