###############################################
# Server file for shiny data integration tool
##############################################

shinyServer(function(input, output, session){
      # this stops the app when the browser stops
      #session$onSessionEnded(stopApp)
      # A button that stops the application
#      observeEvent(input$close, {
#            js$closeWindow()
#            stopApp()
#          })
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
              if (grepl(c("catch"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "catch_landings")
              if (grepl(c("release"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "release")
              if (grepl(c("aquaculture"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "aquaculture")
              if (grepl(c("biomass_indicator"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "biomass")             
              if (grepl(c("habitat"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "potential_available_habitat")
              if (grepl(c("silver"),tolower(inFile$name))) 
                updateRadioButtons(session, "file_type", selected = "mortality_silver_equiv")      
              if (grepl(c("rate"),tolower(inFile$name)))
                updateRadioButtons(session, "file_type", selected = "mortality_rates")
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
              message<-capture.output(res<-load_catch_landings(data$path_step0, datasource = the_eel_datasource ))},
            "release"={
              message<-capture.output(res<-load_release(data$path_step0, datasource = the_eel_datasource ))},
            "aquaculture"={
              message<-capture.output(res<-load_aquaculture(data$path_step0, datasource = the_eel_datasource ))},
            "biomass"={
              message<-capture.output(res<-load_biomass(data$path_step0, datasource = the_eel_datasource ))},
            "potential_available_habitat"={
              message<-capture.output(res<-load_potential_available_habitat(data$path_step0, datasource = the_eel_datasource ))},
            "mortality_silver_equiv"={
              message<-capture.output(res<-load_mortality_silver(data$path_step0, datasource = the_eel_datasource ))},
            "mortality_rates"={
              message<-capture.output(res<-load_mortality_rates(data$path_step0, datasource = the_eel_datasource ))}
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
            #################################################
            output$integrate<-renderText({
                  # call to  function that loads data
                  # this function does not need to be reactive
                  if (is.null(data$path_step0)) "please select a dataset" else {          
                    rls<-step0load_data() # result list
                    # this will fill the log_datacall file (database_tools.R)
                    stopifnot(length(unique(rls$res$data$eel_cou_code))==1)
                    cou_code <- rls$res$data$eel_cou_code[1]
                    # the following three lines might look silly but passing input$something to the log_datacall function results
                    # in an error (input not found), I guess input$something has to be evaluated within the frame of the shiny app
                    main_assessor <- input$main_assessor
                    secondary_assessor <- input$secondary_assessor
                    file_type <- input$file_type
                    log_datacall( "check data",cou_code = cou_code, message = paste(rls$message,collapse="\n"), the_metadata = rls$res$the_metadata, file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor )
                    paste(rls$message,collapse="\n")
                    
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
                          lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                          order=list(1,"asc"),
                          dom= "Blfrtip", 
                          buttons=list(
                              list(extend="excel",
                                  filename = paste0("data_",Sys.Date()))) 
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
                  # bug in excel file
                  colnames(data_from_excel)[colnames(data_from_excel)=="typ_name"]<-"eel_typ_name"
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
                      extract_data("Sigma F all"),
                      extract_data("Sigma H all"))
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
              current_cou_code <- list_comp$current_cou_code
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
              
              # table of number of duplicates values per year (hilaire)
  
              years=sort(unique(c(duplicates$eel_year,new$eel_year)))
              
              summary_check_duplicates=data.frame(years=years,
                                                  nb_new=sapply(years, function(y) length(which(new$eel_year==y))),
                                                  nb_updated_duplicates=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base!=duplicates$eel_value.xls)))),
                                                  nb_no_changes=sapply(years,function(y) length(which(duplicates$eel_year==y & (duplicates$eel_value.base==duplicates$eel_value.xls)))))
              
              output$dt_check_duplicates <-DT::renderDataTable({                     
                datatable(summary_check_duplicates,
                          rownames=FALSE,                                                    
                          options=list(dom="t"
                          ))
              })
              output$dt_duplicates <-DT::renderDataTable({                     
                    datatable(duplicates,
                        rownames=FALSE,                                                    
                        extensions = "Buttons",
                        option=list(
                            rownames = FALSE,
                            scroller = TRUE,
                            scrollX = TRUE,
                            scrollY = "500px",
                            order=list(3,"asc"),
                            lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                            "pagelength"=-1,
                            dom= "Blfrtip",
                            buttons=list(
                                list(extend="excel",
                                    filename = paste0("duplicates_",input$file_type,"_",Sys.Date(),current_cou_code))) 
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
                        option=list(
                            scroller = TRUE,
                            scrollX = TRUE,
                            scrollY = "500px",
                            order=list(3,"asc"),
                            lengthMenu=list(c(-1,5,20,50),c("All","5","20","50")),
                            "pagelength"=-1,
                            dom= "Blfrtip",
                            scrollX = T, 
                            buttons=list(
                                list(extend="excel",
                                    filename = paste0("new_",input$file_type,"_",Sys.Date(),current_cou_code))) 
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
            step21load_data <- function() {
              path <- step21_filepath()
              if (is.null(data$path_step21)) 
                return(NULL)
              # this will alter changed values (change qal_id code) and insert new rows
              rls <- write_duplicates(path, qualify_code = qualify_code)
              message <- rls$message
              cou_code <- rls$cou_code
              main_assessor <- input$main_assessor
              secondary_assessor <- input$secondary_assessor
              file_type <- input$file_type
              log_datacall("check duplicates", cou_code = cou_code, message = sQuote(message), the_metadata = NULL, 
                  file_type = file_type, main_assessor = main_assessor, secondary_assessor = secondary_assessor)
              
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
            step22load_data <- function() {
              path <- step22_filepath()
              if (is.null(data$path_step22)) 
                return(NULL)
              rls <- write_new(path)
              message <- rls$message
              cou_code <- rls$cou_code
              main_assessor <- input$main_assessor
              secondary_assessor <- input$secondary_assessor
              file_type <- input$file_type
              log_datacall("new data integration", cou_code = cou_code, message = sQuote(message), 
                  the_metadata = NULL, file_type = file_type, main_assessor = main_assessor, 
                  secondary_assessor = secondary_assessor)
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
                  if (is.null(data$path_step22)) "please select a dataset" else {                                      
                    paste(message,collapse="\n")
                  }                  
                })  
          })
      #######################################
      # II. Data correction table  
      # This section provides a direct interaction with the database
      # Currently only developped for modifying data.
      # Deletion must be done by changing data code or asking Database handler
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
              vals = input$country
              if (is.null(vals)) 
                vals <- c("FR")
              types = input$typ
              if (is.null(types)) 
                types <- c(4, 5, 6, 7)
              the_years <- input$year
              if (is.null(input$year)) {
                the_years <- c(the_years$min_year, the_years$max_year)
              }
              # glue_sql to protect against injection, used with a vector with *
              query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                  vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
                  .con = pool)
              # https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
              # it seems that dbgetquery doesn't raise an error
              out_data <- dbGetQuery(pool, query)
              return(out_data)
            }
          })
      
      # Observe the source, update reactive values accordingly
      
      observeEvent(mysource(), {               
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
          extensions = "Buttons",
          editable = TRUE, 
          selection = 'none',
          options=list(
              order=list(3,"asc"),              
              searching = FALSE,
              rownames = FALSE,
              scroller = TRUE,
              scrollX = TRUE,
              scrollY = "500px",
              dom= "Blfrtip", #button fr search, t table, i information (showing..), p pagination
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
      
      # Update edited values in db once save is clicked---------------------------------------------
      
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
      
      # Observe clear_table button -> revert to database table---------------------------------------
      
      observeEvent(input$clear_table,
          {
            data <- mysource() %>% arrange(eel_emu_nameshort,eel_year)
            rvs$data <- data
            rvs$dbdata <- data
            disable("clear_table")
            output$database_errors<-renderText({""})
          })
      
      # Oberve cancel -> revert to last saved version -----------------------------------------------
      
      observeEvent(input$cancel, {
            rvs$data <- rvs$dbdata
            rvs$dataSame <- TRUE
          })
      
      # UI buttons ----------------------------------------------------------------------------------
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
      #################################################
      # GRAPHS ----------------------------------------
      #################################################
      
      # Same as mysource but for graphs, different page, so different buttons
      # there must be a way by reorganizing the buttons to do a better job
      # but buttons don't apply to the data integration sheet and here we don't
      # want multiple choices (to check for duplicates we need to narrow down the search) ....
      
      mysource_graph <- reactive({
            {
              vals = input$country_g
              if (is.null(vals)) 
                vals <- c("FR")
              types = input$typ_g
              if (is.null(types)) 
                types <- c(4, 5, 6, 7)
              the_years <- input$year_g
              if (is.null(input$year)) {
                the_years <- c(the_years$min_year, the_years$max_year)
              }
              # glue_sql to protect against injection, used with a vector with *
              query <- glue_sql("SELECT * from datawg.t_eelstock_eel where eel_cou_code in ({vals*}) and eel_typ_id in ({types*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                  vals = vals, types = types, minyear = the_years[1], maxyear = the_years[2], 
                  .con = pool)
              # https:/stackoverflow.com/questions/34332769/how-to-use-dbgetquery-in-trycatch-with-postgresql
              # it seems that dbgetquery doesn't raise an error
              out_data <- dbGetQuery(pool, query)
              return(out_data)
            }
          })
      
      # store data in reactive values ---------------------------------------------------------------
      
      observeEvent(mysource_graph(), {               
            data <- mysource_graph() %>% arrange(eel_emu_nameshort,eel_year)
            rvs$datagr <- data                           
          })
      
      # plot -------------------------------------------------------------------------------------------
      # the plots groups by kept (typ id = 1,2,4) or not (other typ_id) and year 
      # and calculate thenumber of values 
      
      output$duplicated_ggplot <- renderPlot({
            if (is.null(rvs$datagr)) return(NULL)
            # duplicated_values_graph performs a group by, see graph.R inside the shiny data integration
            # tab
            duplicated_values_graph(rvs$datagr)
          }
      )
      
      # the observeEvent will not execute untill the user clicks, here it runs
      # both the plotly and datatable component -----------------------------------------------------
      
      observeEvent(input$duplicated_ggplot_click,  {
            # the nearpoint function does not work straight with bar plots
            # we have to retreive the x data and check the year it corresponds to ... 
            year_selected = round(input$duplicated_ggplot_click$x)  
            datagr <- rvs$datagr
            datagr <- datagr[datagr$eel_year==year_selected, ] 
            
            # Data table for individual data corresponding to the year bar on the graph -------------
            
            output$datatablenearpoints <- DT::renderDataTable({            
                  datatable(datagr,
                      rownames = FALSE,
                      extensions = 'Buttons',
                      options=list(
                          order=list(3,"asc"),    
                          lengthMenu=list(c(-1,5,10,30),c("All","5","10","30")),                           
                          searching = FALSE,                          
                          scroller = TRUE,
                          scrollX = TRUE,                         
                          dom= "Blfrtip", # l length changing,  
                          buttons=list('copy',I('colvis')) 
                      )
                  )
                })        
            
            # Plotly output allowing to brush out individual values per EMU
            x <- sample(c(1:5, NA, NA, NA))
            coalesce(x, 0L)
            output$plotly_selected_year <-renderPlotly({  
                  coalesce 
                  datagr$hl <- as.factor(str_c(datagr$eel_lfs_code, coalesce(datagr$eel_hty_code,"no"),collapse= "&"))   
                  p <-plot_ly(datagr, x = ~eel_emu_nameshort, y = ~eel_value,
                      # Hover text:
                      text = ~paste("Lifestage: ", eel_lfs_code, 
                          '$<br> Hty_code:', eel_hty_code,
                          '$<br> Area_division:', eel_area_division,
                          '$<br> Source:', eel_datasource,
                          '$<br> Value:', eel_value),
                      color = ~ eel_lfs_code,
                      split = ~eel_hty_code)  
                  p$elementId <- NULL # a hack to remove warning : ignoring explicitly provided widget
                  p           
                }) 
            
          }, ignoreNULL = TRUE) # additional arguments to observe ...
      
      
      
      
      
    })
