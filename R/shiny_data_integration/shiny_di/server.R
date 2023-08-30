##############################################
# Server file for shiny data integration tool
##############################################

shinyServer(function(input, output, session){
      # this stops the app when the browsser stops
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
      
      data<-reactiveValues(pool=NULL,
          connectOK=FALSE,
          ser_list = NULL,
          ccm_light = ccm_light,
          typ_id = typ_id,
          list_country = NULL)
      
      
      output$passwordtest <- renderText({
            req(input$passwordbutton)   
            load_database()
           
            if (data$connectOK){
              var_database()
              return("Connected") 
            } else {
              return(paste("password:",input$password,"wrong"))               
            }})


load_database <- function(){
  # we use isolate as we want no dependency on the value (only the button being clicked)
  passwordwgeel <- isolate(input$password)
  ############################################
  # FIRST STEP INITIATE THE CONNECTION WITH THE DATABASE
  ###############################################
#						options(sqldf.RPostgreSQL.user = userwgeel,  
#								sqldf.RPostgreSQL.password = passwordwgeel,
#								sqldf.RPostgreSQL.dbname = "wgeel",
#								sqldf.RPostgreSQL.host = host, #getInformation("PostgreSQL host: if local ==> localhost"), 
#								sqldf.RPostgreSQL.port = port)
  
  # Define pool handler by pool on global level
  
  pool <<- pool::dbPool(drv = RPostgres::Postgres(),
      dbname="wgeel",
      host=host,
      port=port,
      user= userwgeel,
      password= passwordwgeel,
      bigint="integer",
      minSize = 0,
      maxSize = 2)          
  t <- tryCatch({dbListTables(pool);"OK"},error=function(e)"connexion error")
  if (t=="connexion error") {
    textoutput <- paste("password:",input$password,"wrong")
    isolate(data$pool <- NULL)       
    isolate(data$connectOK <- FALSE)
  } else { 
    isolate(data$pool <- pool)
    isolate(data$connectOK <- dbGetInfo(data$pool)$valid)        
    # if the password is wrong we need to test the connection           
  }
}
  
  
  var_database <- function(){
    #print("var_database")
    # until the password has been entered don't do anything
    #validate(need(data$connectOK,"No connection"))
    query <- "SELECT column_name
        FROM   information_schema.columns
        WHERE  table_name = 't_eelstock_eel'
        ORDER  BY ordinal_position"
    t_eelstock_eel_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
    t_eelstock_eel_fields <<- t_eelstock_eel_fields$column_name
    
    query <- "SELECT column_name
        FROM   information_schema.columns
        WHERE  table_name = 't_dataseries_das'
        ORDER  BY ordinal_position"
    t_dataseries_das_fields <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))     
    t_dataseries_das_fields <<- t_dataseries_das_fields$column_name
    
    query <- "SELECT cou_code,cou_country from ref.tr_country_cou order by cou_country"
    list_countryt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
    list_country <- list_countryt$cou_code
    names(list_country) <- list_countryt$cou_country
    isolate({data$list_country<- list_country})
    list_country<<-list_country
    
    query <- "SELECT * from ref.tr_typeseries_typ order by typ_name"
    tr_typeseries_typt <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
    typ_id <- tr_typeseries_typt$typ_id
    
    query <- "SELECT distinct ser_nameshort from datawg.t_series_ser"
    tr_series_list <- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
    isolate({data$ser_list <- tr_series_list$ser_nameshort})
    tr_typeseries_typt$typ_name <- tolower(tr_typeseries_typt$typ_name)
    names(typ_id) <- tr_typeseries_typt$typ_name
    isolate({data$typ_id <- typ_id})
    # tr_type_typ<-extract_ref('Type of series') this works also !
    tr_typeseries_typt<<-tr_typeseries_typt
    
    #205-shiny-integration-for-dcf-data 
    query <- "SELECT distinct sai_name FROM datawg.t_samplinginfo_sai"
    tr_sai_list <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))$sai_name
    
    query <- "SELECT * FROM datawg.t_samplinginfo_sai"
    t_samplinginfo_sai <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))
    #isolate({data$sai_list <- tr_sai_list$ser_id})
    
    #205-shiny-integration-for-dcf-data
    query <- "SELECT * from ref.tr_metrictype_mty"
    tr_metrictype_mty <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))
    
    #205-shiny-integration-for-dcf-data
    query <- "SELECT * from ref.tr_units_uni"
    tr_units_uni <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
    
    query <- "SELECT * from ref.tr_gear_gea"
    tr_gear_gea <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  						
    
    query <- "SELECT min(eel_year) as min_year, max(eel_year) as max_year from datawg.t_eelstock_eel"
    the_years <<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))   
    updateSliderTextInput(session,"yearAll",
        choices=seq(the_years$min_year, the_years$max_year),
        selected = c(the_years$min_year,the_years$max_year))
    
    query <- "SELECT name from datawg.participants order by name asc"
    participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query))  
    
    ices_division <<- suppressWarnings(extract_ref("FAO area", pool)$f_code)
    
    emus <<- suppressWarnings(extract_ref("EMU", pool))			
    
    updatePickerInput(
        session = session, inputId = "main_assessor",
        choices = participants,
        selected =NULL
    )
    
    updatePickerInput(
        session = session, inputId = "secondary_assessor",
        choices = participants,
        selected = "Cedric Briand"
    )
    
  }# end var_database
  
  
  #module tableEdit
  tableEditServer("tableEditmodule", data) # globaldata <- data in the module
  loaded_data <- importstep0Server("importstep0module", data) # globaldata <- data in the module 
  importstep1Server("importstep1module", data, loaded_data) # globaldata <- data in the module
  importstep2Server("importstep2module", data, loaded_data)
  
  loaded_data_ts <- importtsstep0Server("importtsstep0module", globaldata=data) # globaldata <- data in the module 
  importtsstep1Server("importtsstep1module", data, loaded_data_ts) # globaldata <- data in the module 
  importtsstep2Server("importtsstep2module", data, loaded_data_ts) # globaldata <- data in the module 
  
  loaded_data_ts <- importtsstep0Server("importtsstep0module", globaldata=data) # globaldata <- data in the module 
  importtsstep1Server("importtsstep1module", data, loaded_data_ts) # globaldata <- data in the module 
  importtsstep2Server("importtsstep2module", data, loaded_data_ts) # globaldata <- data in the module 
  
  
  loaded_data_dcf <- importdcfstep0Server("importdcfstep0module", globaldata=data)
  importdcfstep1Server("importdcfstep1module", data, loaded_data_dcf) # globaldata <- data in the module 
  importdcfstep2Server("importdcfstep2module", data, loaded_data_dcf) # globaldata <- data in the module
  
  newparticipants <- newparticipantsServer("newparticipantsmodule",data)
  plotduplicatesServer("plotduplicatesmodule",data)
  plotseriesServer("plotseriesmodule",data)
  observe({
        if (!is.null(newparticipants$participants)){
          updatePickerInput(session=session,"main_assessor",choices=newparticipants$participants)
          updatePickerInput(session=session,"secondary_assessor",choices=newparticipants$participants)
          
        }
      })
  
  
})
