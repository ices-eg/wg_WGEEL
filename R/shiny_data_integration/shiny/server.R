shinyServer(function(input, output, session){
      # this stops the app when the browser stops
      session$onSessionEnded(stopApp)
      # A button that stops the application
      observeEvent(input$close, {
            js$closeWindow()
            stopApp()
          })
      ##########################
# I. Datacall Integration and checks
      ######################### 
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
            "release"={
              message<-capture.output(load_release(data$path_step0))},
            "aquaculture"={
              message<-capture.output(load_aquaculture(data$path_step0))},
            "biomass"={
              message<-capture.output(load_biomass(data$path_step0))},
            "potential_available_habitat"={
              message<-capture.output(load_potential_available_habitat(data$path_step0))},
            "silver_eel_equivalents"={
              message<-capture.output(load_mortality_silver(data$path_step0))},
            "mortality_rates"={
              message<-capture.output(load_mortality_rates(data$path_step0))}
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
                    # this will fill the log file (database_tools.R)
                    log("check data")
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
                        "and submit again in <strong>step0</strong> the file once it's corrected<p>"
                    )))  
            
            ##################################
            # Actively generates UI component on the ui side
            # which generates text for txt
            ##################################      
            
            output$"step0_message_txt"<-renderUI(
                HTML(
                    paste(
                        h4("File checking messages (txt)"),
                        "<p align='left'>Please read carefully and ensure that you have",
                        "checked all possible errors. This output is the same as the table",
                        " output<p>"
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
#                      !!removed caption otherwise included in the file content                      
#                      caption = htmltools::tags$caption(
#                          style = 'caption-side: bottom; text-align: center;',
#                          'Table 1: ', htmltools::em('Please check the following values, click on excel button to download.')
#                      ),
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
                  data_from_base<-extract_data("Landings")                  
                },
                "release"={
                  data_from_base<-extract_data("Release")
                },
                "aquaculture"={             
                  data_from_base<-extract_data("Aquaculture")},
                "biomass"={
                  data_from_base<-rbind(
                      extract_data("B0"),
                      extract_data("Bbest"),
                      extract_data("Bcurrent"))
                },
                "potential_available_habitat"={
                  data_from_base<-extract_data("Potential available habitat")                  
                },
                "silver_eel_equivalents"={
                  data_from_base<-extract_data("Mortality in Silver Equivalents")      
                  
                },
                "mortality_rates"={
                  data_from_base<-rbind(
                      extract_data("Sigma A"),
                      extract_data("Sigma F"),
                      extract_data("Sigma H"))
                }                
            )
            # the compare_with_database function will compare
            # what is in the database and the content of the excel file
            # previously loaded. It will return a list with two components
            # the first duplicates contains elements to be returned to the use
            # the second new contains a dataframe to be inserted straight into
            # the database
            #cat("step0")
            if (nrow(data_from_excel)>0){
              list_comp<-compare_with_database(data_from_excel,data_from_base)
              duplicates <- list_comp$duplicates
              new <- list_comp$new 
              #cat("step1")
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
                            "<p align='left'>Please click on excel",
                            "to download this file. In <strong>keep new value</strong> choose true",
                            "to replace data using the new datacall data (true)",
                            "if new is selected don't forget to qualify your data in column <strong> eel_qal_id.xls, eel_qal_comment.xls </strong>",
                            "once this is done download the file and proceed to next step.",
                            "Rows with false will be ignored and kept as such in the database",
                            "Rows with true will use the column labelled .xls for the new insertion, and flag existing values as removed ",
                            "If you see an error in old data, use panel datacorrection (on top of the application), this will allow you to make changes directly in the database <p>"                         
                        )))  
              }
              output$dt_duplicates <-DT::renderDataTable({                     
                    datatable(duplicates,
                        rownames=FALSE,                                                    
                        extensions = "Buttons",
                        option=list("pagelength"=5,
                            lengthMenu=list(c(10,50,-1),c("10","50","All")),
                            order=list(5,"asc"),
                            dom= "Blfrtip",
                            scrollX = T, 
                            buttons=list(
                                list(extend="excel",
                                    filename = paste0("duplicates_",input$file_type,"_",Sys.Date()))) #  JSON behind the scene
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
                            "to download this file and qualify your data with columns <strong>qal_id, qal_comment</strong> ",
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
                                    filename = paste0("new_",input$file_type,"_",Sys.Date()))) #  JSON behind the scene
                        ))
                  })
            } # closes if nrow(...      
            #data$new <- new # new is stored in the reactive dataset to be inserted later.      
          })
      
      
      ##########################
      # STEP 2.1
      # When database_duplicates_button is clicked
      # this will trigger the data integration
      #############################         
      # this step only starts if step1 has been launched    
      observeEvent(input$database_duplicates_button, { 
            ###########################
            # step2_filepath
            # reactive function, when clicked return value in reactive data 
            ###########################
            step21_filepath <- reactive({
                  inFile <- input$xl_duplicates_file      
                  if (is.null(inFile)){        return(NULL)
                  } else {
                    data$path_step21<-inFile$datapath #path to a temp file             
                  }
                })
            ###########################
            # step21load_data
            #  function, returns a message
            #  indicating that data integration was a succes
            #  or an error message
            ###########################
            step21load_data<-function(){
              path<- step21_filepath()   
              if (is.null(data$path_step21)) return(NULL)
              message<-write_duplicates(path,qualify_code=qualify_code)
              return(message)
            }
            ###########################
            # errors_duplicates_integration
            # this will add a path value to reactive data in step0
            ###########################            
            output$textoutput_step2.1<-renderText({
                  # call to  function that loads data
                  # this function does not need to be reactive                  
                  message<-step21load_data() 
                  # this will fill the log file (database_tools.R) 
                  log("check data")
                  if (is.null(data$path_step21)) "please select a dataset" else {                                      
                    paste(message,collapse="\n")
                  }                  
                })              
          }) 
      ##########################
      # STEP 2.2
      # When database_new_button is clicked
      # this will trigger the data integration
      #############################      
      observeEvent(input$database_new_button, {
            
            ###########################
            # step2_filepath
            # reactive function, when clicked return value in reactive data 
            ###########################
            step22_filepath <- reactive({
                  inFile <- input$xl_new_file      
                  if (is.null(inFile)){        return(NULL)
                  } else {
                    data$path_step22<-inFile$datapath #path to a temp file             
                  }
                })
            ###########################
            # step22load_data
            #  function, returns a message
            #  indicating that data integration was a succes
            #  or an error message
            ###########################
            step22load_data<-function(){
              path<- step22_filepath()   
              if (is.null(data$path_step22)) return(NULL)             
              message<-write_new(path)
              return(message)
            }
            ###########################
            # new_data_integration
            # this will add a path value to reactive data in step0
            ###########################            
            output$textoutput_step2.2<-renderText({
                  # call to  function that loads data
                  # this function does not need to be reactive
                  message<-step22load_data()
                  # this will fill the log file 
                  log("new data integration") 
                  if (is.null(data$path_step22)) "please select a dataset" else {                                      
                    paste(message,collapse="\n")
                  }                  
                })  
          })
      #######################################
      # II. Data correction table  
      #######################################
      rvs <- reactiveValues(
          data = NA, 
          dbdata = NA,
          dataSame = TRUE,
          editedInfo = NA
      
      )
      
      #-----------------------------------------  
      # Generate source via reactive expression
      mysource <- reactive({
            {
              vals=input$country
              if (is.null(vals)) vals<-c('FR')
              types=input$typ
              if (is.null(types)) types<-c(4,5,6,7)     
              the_years<-input$year
              if (is.null(input$year)){
                the_years<-c(the_years$min_year,the_years$max_year)
              }
              # glue_sql to protect against injection, used with a vector with *   
              query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}",
                  vals=vals,types=types,minyear=the_years[1],maxyear=the_years[2],.con=pool)
              # https:,/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
              # it seems that dbgetquery doesn't raise an error
              out_data <- dbGetQuery(pool, query)              
              return(out_data)
            }
          })
      
      # Observe the source, update reactive values accordingly
      
      observeEvent(mysource(), {
            
            # Lightly format data by arranging id
            # Not sure why disordered after sending UPDATE query in db    
            data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
            rvs$data <- data
            rvs$dbdata <- data
            disable("clear_table")                
          })
      
      #-----------------------------------------
      # Render DT table 
      # 
      # selection better be none
      # editable must be TRUE
      #
      output$table_cor <- DT::renderDataTable(
          rvs$data, 
          rownames = FALSE, 
          editable = TRUE, 
          selection = 'none',
          options=list(
              order=list(3,"asc"),              
              searching = FALSE,
              rownames = FALSE,
              scroller = TRUE,
              scrollX = TRUE,
              scrollY = "500px",
              dom= "Blfrtip", # de gauche à droite button fr search, t tableau, i informaiton (showing..), p pagination
              buttons=list(
                  list(extend="excel",
                      filename = paste0("data_",Sys.Date())))
          ))
      #-----------------------------------------
      # Create a DT proxy to manipulate data
      # 
      #
      proxy_table_cor = dataTableProxy('table_cor')
      #--------------------------------------
      # Edit table data
      # Expamples at
      # https://yihui.shinyapps.io/DT-edit/
      observeEvent(input$table_cor_cell_edit, {
            
            info = input$table_cor_cell_edit
            
            i = info$row
            j = info$col = info$col + 1  # column index offset by 1
            v = info$value
            
            rvs$data[i, j] <<- DT::coerceValue(v, rvs$data[i, j])
            replaceData(proxy_table_cor, rvs$data, resetPaging = FALSE, rownames = FALSE)
            # datasame is set to TRUE when save or update buttons are clicked
            # here if it is different it might be set to FALSE
            rvs$dataSame <- identical(rvs$data, rvs$dbdata)
            # this will collate all editions (coming from datatable observer in a data.frame
            # and store it in the reactive dataset rvs$editedInfo
            if (all(is.na(rvs$editedInfo))) {
              
              rvs$editedInfo <- data.frame(info)
            } else {
              rvs$editedInfo <- dplyr::bind_rows(rvs$editedInfo, data.frame(info))
            }
            
          })
      #-----------------------------------------
      # Update edited values in db once save is clicked
      observeEvent(input$save, {
            
            errors<-update_t_eelstock_eel(editedValue = rvs$editedInfo, pool = pool, data=rvs$data)
            if (length(errors)>0) {
              output$database_errors<-renderText({iconv(unlist(errors,"UTF8"))})
              enable("clear_table")
            } else {
              output$database_errors<-renderText({"Database updated"})
            }
            rvs$dbdata <- rvs$data
            rvs$dataSame <- TRUE
          })
      #-----------------------------------------
      # Oberve cleat table button -> revert to database table
      observeEvent(input$clear_table,
          {
            data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
            rvs$data <- data
            rvs$dbdata <- data
            disable("clear_table")
            output$database_errors<-renderText({""})
          })
      #-----------------------------------------
      # Oberve cancel -> revert to last saved version
      observeEvent(input$cancel, {
            rvs$data <- rvs$dbdata
            rvs$dataSame <- TRUE
          })
      
      #-----------------------------------------
      # UI buttons
      # Appear only when data changed
      output$buttons_data_correction <- renderUI({
            div(
                if (! rvs$dataSame) {
                      span(
                          actionButton(inputId = "save", label = "Save",
                              class = "btn-primary"),
                          actionButton(inputId = "cancel", label = "Cancel")
                      )
                    } else {
                      span()
                    }
            )
          })
      
    })
