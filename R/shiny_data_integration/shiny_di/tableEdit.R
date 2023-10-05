#' Elements necessary for the edition table
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements

tableEditUI <- function(id){
  ns <- NS(id)
  tagList(useShinyjs(),
          h2("Data correction table"),
          fluidRow(
            column(width=3,
                   pickerInput(inputId = ns("edit_datatype"), 
                               label = "Select table to edit :", 
                               choices = sort(c("NULL","t_series_ser",
                                                "t_samplinginfo_sai",
                                                "t_eelstock_eel",
                                                "t_eelstock_eel_perc",                                                
                                                "t_dataseries_das",                                                
                                                "t_metricgroupsamp_megsa",
                                                "t_metricgroupseries_megser",
                                                "t_metricindsamp_meisa",
                                                "t_metricindseries_meiser")),
                               selected="NULL",
                               multiple = FALSE,  
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=2, 
                   pickerInput(inputId = ns("editpicker_cou"), 
                               label = "", 
                               choices = "",
                               multiple = TRUE, 
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=2, 
                   pickerInput(inputId = ns("editpicker_typ_series"), 
                               label = "", 
                               choices = "",
                               multiple = TRUE, 
                               options = list(
                                 style = "btn-primary", size = 5))),
            column(width=2, 
                   pickerInput(inputId = ns("editpicker_stage"), 
                               label = "", 
                               choices = "",
                               multiple = TRUE, 
                               options = list(
                                 style = "btn-primary", size = 5))),          
            column(width=3,
                   sliderTextInput(inputId =ns("yearAll"), 
                                   label = "Choose a year range:",
                                   choices=seq(the_years$min_year, as.integer(format(Sys.time(),"%Y"))),
                                   selected = c(the_years$min_year,as.integer(format(Sys.time(),"%Y")))
                   ))),
          fluidRow(
            column(
              width=12,
              actionBttn(inputId = ns("button_show_table"), label = "OK",
                         style = "material-flat", color = "primary"),
              align="center"),
          ),                                                         
          br(), 
          uiOutput(ns("table_output"))
  )
}

#' Table Edition server side
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#' @param globaldata a reactive value with global variable
#' @note currently no edition of group or fish tables only the metrics
#' @return nothing


tableEditServer <- function(id,globaldata){
  moduleServer(id,
               function(input, output, session) {
                 rvsAll <- reactiveValues(
                   data = data.frame(), 
                   dbdata = data.frame(),
                   dataSame = TRUE,
                   editedInfo = NA
                   
                 )
                 
                 selectedvalues <- reactiveValues(editpicker_cou = NULL,
                                                  editpicker_stage = NULL,
                                                  editpicker_typ_series = NULL,
                                                  yearAll = c(1800, current_year))
                 dictionnary <- reactiveValues(dictionnary = NULL)
                 # ----- renderUI
                 output$table_output <- renderUI({
                   req(input$button_show_table)
                   ns <- NS(id)
                   tagList(
                     tabsetPanel(id= ns("edit_tabsetpanel"),
                                 tabPanel("Table",
                                          fluidRow(                                       
                                            column(width=6, verbatimTextOutput(ns("database_errorsAll"))),
                                            column(width=2, hidden(actionButton(ns("addRowTable_corAll"), "Add Row"))),
                                            column(width=2, actionButton(ns("clear_tableAll"), "clear")),
                                            column(width=2, uiOutput(ns("buttons_data_correctionAll")))
                                          ),                
                                          br(),
                                          fluidRow(
                                            column(width=2, 
                                                   actionBttn(inputId = 
                                                                ns("saveAllmod"), 
                                                              label = "Save",
                                                              style = "material-flat",
                                                              color = "danger")),
                                            column(width=2, actionButton(
                                              inputId = ns("cancelAllmod"),
                                              label = "Cancel"))
                                          ),
                                          DT::dataTableOutput(ns("table_corAll"))),
                                 tabPanel("Maps", 
                                          fluidRow(column(width=10),
                                                   leafletOutput(ns("maps_editedtimeseries"),height=600))
                                          
                                 )))
                 })
                 
                 
                 # Main function to load data according to the values in pickerinput
                 createDictionnary <- function(){
                   req(globaldata$connectOK)
                   req(input$edit_datatype!="NULL")
                   validate(need(globaldata$connectOK,"No connection"))
                   
                   query = switch (input$edit_datatype,
                                   "t_dataseries_das" = glue_sql(str_c("SELECT ser_cou_code,ser_nameshort,ser_lfs_code,min(das_year) minyear, max(das_year) maxyear  from datawg.t_dataseries_das das join datawg.t_series_ser on das_ser_id=ser_id 
                                                              group by ser_cou_code,ser_nameshort,ser_lfs_code"), 
                                                                 .con = globaldata$pool),
                                   "t_eelstock_eel" =  query <- glue_sql("SELECT eel_cou_code,typ_name as typ_name_ref, eel_lfs_code,min(eel_year) minyear, max(eel_year) maxyear from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id 
                                                                group by eel_cou_code,typ_name,eel_lfs_code", 
                                                                         .con = globaldata$pool),
                                   "t_eelstock_eel_perc" =  query <- glue_sql("SELECT eel_cou_code, typ_name as typ_name_ref, eel_lfs_code, min( eel_year) minyear,max(eel_year)  max_year from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id left join datawg.t_eelstock_eel_percent on percent_id=eel_id
                                                                     group by eel_cou_code,typ_name,eel_lfs_code", 
                                                                              .con = globaldata$pool),
                                   "t_series_ser" =  glue_sql("SELECT ser_cou_code,ser_nameshort, ser_lfs_code, 1800,{current_year} from datawg.t_series_ser 
                                                     group by ser_cou_code,ser_nameshort,ser_lfs_code", # ser_ccm_wso_id is an array to deal with series being part of serval basins ; here we deal until 3 basins
                                                              .con = globaldata$pool),
                                   # new series 2023
                                   "t_samplinginfo_sai" =  glue_sql("SELECT sai_cou_code,sai_name,'G' sai_lfs_code, 1800,{current_year} from datawg.t_samplinginfo_sai 
                                                           group by sai_cou_code, sai_name,sai_lfs_code", 
                                                                    .con = globaldata$pool),
                                   "t_metricgroupsamp_megsa" =  glue_sql("SELECT sai_cou_code, sai_name ,grsa_lfs_code,  min(gr_year) minyear, max(gr_year) maxyear  FROM datawg.t_samplinginfo_sai JOIN datawg.t_groupsamp_grsa on grsa_sai_id= sai_id JOIN datawg.t_metricgroupsamp_megsa on meg_gr_id= gr_id JOIN ref.tr_metrictype_mty ON mty_id = meg_mty_id 
                                                                group by sai_cou_code,sai_name,grsa_lfs_code",
                                                                         .con = globaldata$pool),
                                   "t_metricgroupseries_megser" =  glue_sql("SELECT  ser_cou_code, ser_nameshort, ser_lfs_code, min(gr_year) minyear, max(gr_year) gr_year FROM datawg.t_series_ser JOIN datawg.t_groupseries_grser on grser_ser_id= ser_id JOIN datawg.t_metricgroupseries_megser on meg_gr_id = gr_id 
                                                                   group by ser_cou_code, ser_nameshort, ser_lfs_code",
                                                                            .con = globaldata$pool),
                                   "t_metricindsamp_meisa" =  glue_sql("SELECT sai_cou_code, sai_name ,fi_lfs_code,  min(fi_year) minyear, max(fi_year) maxyear FROM  datawg.t_samplinginfo_sai JOIN datawg.t_fishsamp_fisa ON fisa_sai_id =sai_id JOIN datawg.t_metricindsamp_meisa ON mei_fi_id =fi_id JOIN ref.tr_metrictype_mty ON  mei_mty_id=mty_id  
                                                                group by sai_cou_code,sai_name,fi_lfs_code",
                                                                       .con = globaldata$pool),
                                   "t_metricindseries_meiser" =  glue_sql("SELECT ser_cou_code, ser_nameshort, fi_lfs_code, min(fi_year) minyear, max(fi_year) FROM datawg.t_series_ser  JOIN datawg.t_fishseries_fiser ON fiser_ser_id =ser_id JOIN datawg.t_metricindseries_meiser ON mei_fi_id =fi_id JOIN ref.tr_metrictype_mty ON mty_id = mei_mty_id
                                                                   group by ser_cou_code, ser_nameshort, fi_lfs_code",
                                                                          .con = globaldata$pool)
                   )
                   
                   query <- 
                     out_data <- dbGetQuery(globaldata$pool, query)
                   names(out_data) <- c("editpicker_cou",
                                        "editpicker_typ_series",
                                        "editpicker_stage",
                                        "minyearall",
                                        "maxyearall")
                   
                   return(out_data %>%
                            arrange(editpicker_cou,editpicker_typ_series,editpicker_stage))
                   
                 }
                 
                 ####this update the pickers
                 updatepickers <- function(){
                   req(isolate(dictionnary$dictionnary))
                   dico <- isolate(dictionnary$dictionnary)
                   selected_cou <- isolate(selectedvalues$editpicker_cou)
                   selected_lfs <- isolate(selectedvalues$editpicker_stage)
                   selected_typ_series <- isolate(selectedvalues$editpicker_typ_series)
                   the_years <- isolate(selectedvalues$yearAll)
                   if (is.null(the_years)) {
                     minyear <- min(dico$minyear)
                     maxyear <- max(dico$maxyear)
                   } else{
                     minyear <- the_years[1]
                     maxyear <- the_years[2]
                   }
                   possible_cou <- sort(setdiff(unique(
                     dico$editpicker_cou[(dico$editpicker_stage %in% selected_lfs | is.null(selected_lfs)) &
                                           (dico$editpicker_typ_series %in% selected_typ_series | is.null(selected_typ_series))]
                     ),coalesce(selected_cou,"")))
                   other_cou <- sort(setdiff(unique(dico$editpicker_cou),
                                             c(coalesce(selected_cou,""),possible_cou)))
                   
                   possible_stage<- sort(setdiff(unique(
                     dico$editpicker_stage[(dico$editpicker_cou %in% selected_cou | is.null(selected_cou)) &
                                           (dico$editpicker_typ_series %in% selected_typ_series | is.null(selected_typ_series))]
                   ),coalesce(selected_lfs,"")))
                   other_stage <- sort(setdiff(unique(dico$editpicker_stage),
                                               c(coalesce(selected_lfs,""),possible_stage)))
                   
                   possible_series<- sort(setdiff(unique(
                     dico$editpicker_typ_series[(dico$editpicker_cou %in% selected_cou | is.null(selected_cou)) &
                                             (dico$editpicker_stage %in% selected_lfs | is.null(selected_lfs))]
                   ),coalesce(selected_typ_series,"")))
                   other_series <- sort(setdiff(unique(dico$editpicker_typ_series),
                                                c(coalesce(selected_typ_series,""),possible_series)))
                   
                   
                   updatePickerInput(session=session,
                                     inputId="editpicker_typ_series",
                                     choices=c(selected_typ_series,
                                               possible_series,
                                               other_series),
                                     selected=selected_typ_series,
                                     choicesOpt=list(disabled=c(rep(FALSE,length(c(selected_typ_series,possible_series))),
                                                               rep(TRUE, length(other_series)))))
                   updatePickerInput(session=session,
                                     inputId="editpicker_stage",
                                     choices=c(selected_lfs,
                                               possible_stage,
                                               other_stage),
                                     selected=selected_lfs,
                                     choicesOpt=list(disabled=c(rep(FALSE, length(c(selected_lfs, possible_stage))),
                                                             rep(TRUE, length(other_stage)))))
                   updatePickerInput(session=session,
                                     inputId="editpicker_cou",
                                     choices=c(selected_cou,
                                               possible_cou,
                                               other_cou),
                                     selected=selected_cou,
                                     choicesOpt=list(disabled=c(rep(FALSE,length(c(selected_cou,possible_cou))),
                                                               rep(TRUE,length(other_cou)))))
                   
                 }
                 
                 observeEvent(input$editpicker_stage,{
                   if (!identical(isolate(selectedvalues$editpicker_stage), input$editpicker_stage)){
                     selectedvalues$editpicker_stage <- input$editpicker_stage
                     updatepickers()
                   }}, ignoreNULL = FALSE)
                 
                 observeEvent(input$editpicker_cou,{
                   if (!identical(isolate(selectedvalues$editpicker_cou),input$editpicker_cou)){
                     selectedvalues$editpicker_cou <- input$editpicker_cou
                     updatepickers()
                     }}, ignoreNULL = FALSE)
                 observeEvent(input$editpicker_typ_series,{
                   if (!identical(isolate(selectedvalues$editpicker_typ_series), input$editpicker_typ_series)){
                     selectedvalues$editpicker_typ_series <- input$editpicker_typ_series
                     updatepickers()
                   }}, ignoreNULL = FALSE)
                 observeEvent(input$yearAll,{
                   if (!identical(isolate(selectedvalues$yearAll),input$yearAll)){
                     selectedvalues$yearAll <- input$yearAll
                     updatepickers()
                     }})
                 
                 mysourceAll <- function(){
                   req(globaldata$connectOK)
                   req(input$edit_datatype!="NULL")
                   validate(need(globaldata$connectOK,"No connection"))
                   pick_country <- input$editpicker_cou
                   pick_typ_series <- input$editpicker_typ_series
                   pick_stage <- input$editpicker_stage
                   if (is.null(pick_country)) {
                     pick_country <- "FR"}
                   if (is.null(pick_typ_series)) {
                     pick_typ_series=switch(input$edit_datatype,
                                            "t_eelstock_eel"=c(4, 5, 6, 7),
                                            "t_eelstock_eel_perc"=c(13:15,17:19),
                                            "t_samplinginfo_sai"=sort(globaldata$sai_list),
                                            "t_series_ser"=sort(globaldata$ser_list),                                                         
                                            "t_dataseries_das"=sort(globaldata$ser_list),                                                   
                                            "t_metricgroupsamp_megsa"=globaldata$sai_list,
                                            "t_metricgroupseries_megser"=sort(globaldata$ser_list),
                                            "t_metricindsamp_meisa"=sort(globaldata$sai_list),
                                            "t_metricindseries_meiser"=sort(globaldata$ser_list))
                   }
                   if (is.null(pick_stage)) {
                     pick_stage=switch(input$edit_datatype,
                                       "t_eelstock_eel"=c("G","Y","YS","S","AL","OG","QG"),               ,
                                       "t_eelstock_eel_perc"=c("G","Y","YS","S","AL","OG","QG"),
                                       "t_samplinginfo_sai"=NULL, # no stages for samplinginfo
                                       "t_series_ser"=c("G","GY","Y","S"),                                                         
                                       "t_dataseries_das"=c("G","GY","Y","S"),                                                  
                                       "t_metricgroupsamp_megsa"=c("G","GY","Y","YS","S"),
                                       "t_metricgroupseries_megser"=c("G","GY","Y","S"),
                                       "t_metricindsamp_meisa"=c("G","GY","Y","YS","S"),
                                       "t_metricindseries_meiser"=c("G","GY","Y","S"))
                   }
                   the_years <- input$yearAll
                   if (is.null(input$yearAll)) {
                     the_years <- c(the_years$min_year, the_years$max_year)
                   }
                   query = switch (input$edit_datatype,
                                   "t_dataseries_das" = glue_sql(str_c("SELECT das.*,ser_nameshort as ser_nameshort_ref,ser_emu_nameshort as ser_emu_nameshort_ref,ser_lfs_code as ser_lfs_code_ref from datawg.t_dataseries_das das join datawg.t_series_ser on das_ser_id=ser_id where ser_nameshort in ({pick_typ_series*}) and ser_cou_code in ({pick_country*}) and ser_lfs_code in ({pick_stage*}) and das_year>={minyear} and das_year<={maxyear}"), 
                                                                 minyear = the_years[1], maxyear = the_years[2], 
                                                                 .con = globaldata$pool),
                                   "t_eelstock_eel" =  query <- glue_sql("SELECT *,typ_name as typ_name_ref from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id where eel_cou_code in ({pick_country*}) and eel_typ_id in ({pick_typ_series*}) and eel_lfs_code in ({pick_stage*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                                                                         minyear = the_years[1], maxyear = the_years[2], 
                                                                         .con = globaldata$pool),
                                   "t_eelstock_eel_perc" =  query <- glue_sql("SELECT percent_id,eel_year eel_year_ref,eel_emu_nameshort as eel_emu_nameshort_ref,eel_cou_code as eel_cou_code_ref,typ_name as typ_name_ref, perc_f, perc_t, perc_c,perc_mo from datawg.t_eelstock_eel join ref.tr_typeseries_typ on typ_id=eel_typ_id left join datawg.t_eelstock_eel_percent on percent_id=eel_id where eel_cou_code in ({pick_country*}) and eel_typ_id in ({pick_typ_series*}) and eel_year>={minyear} and eel_year<={maxyear}", 
                                                                              minyear = the_years[1], maxyear = the_years[2], 
                                                                              .con = globaldata$pool),
                                   "t_series_ser" =  glue_sql("SELECT * from datawg.t_series_ser where ser_nameshort in ({pick_typ_series*}) and ser_lfs_code in ({pick_stage*}) and ser_cou_code in ({pick_country*})", # ser_ccm_wso_id is an array to deal with series being part of serval basins ; here we deal until 3 basins
                                                              .con = globaldata$pool),
                                   # new series 2023
                                   "t_samplinginfo_sai" =  glue_sql("SELECT * from datawg.t_samplinginfo_sai where sai_name in ({pick_typ_series*}) AND sai_cou_code in ({pick_country*})", 
                                                                    .con = globaldata$pool),
                                   "t_metricgroupsamp_megsa" =  glue_sql("SELECT mty_name,meg_mty_id, meg_id,meg_gr_id,meg_mty_id, meg_value, meg_last_update, meg_qal_id, meg_dts_datasource, gr_year, grsa_lfs_code, sai_name, sai_cou_code, sai_id, gr_id  FROM datawg.t_samplinginfo_sai JOIN datawg.t_groupsamp_grsa on grsa_sai_id= sai_id JOIN datawg.t_metricgroupsamp_megsa on meg_gr_id= gr_id JOIN ref.tr_metrictype_mty ON mty_id = meg_mty_id WHERE sai_name in ({pick_typ_series*}) and sai_cou_code in ({pick_country*}) and grsa_lfs_code in ({pick_stage*}) and gr_year>={minyear} and gr_year<={maxyear}",
                                                                         minyear = the_years[1], maxyear = the_years[2], 
                                                                         .con = globaldata$pool),
                                   "t_metricgroupseries_megser" =  glue_sql("SELECT  ser_nameshort, meg_mty_id, meg_id,meg_gr_id,meg_mty_id, meg_value, meg_last_update, meg_qal_id, meg_dts_datasource, gr_year,  ser_id, ser_cou_code, gr_id FROM datawg.t_series_ser JOIN datawg.t_groupseries_grser on grser_ser_id= ser_id JOIN datawg.t_metricgroupseries_megser on meg_gr_id = gr_id WHERE ser_nameshort in ({pick_typ_series*}) and ser_cou_code in ({pick_country*}) and ser_lfs_code in ({pick_stage*}) and gr_year>={minyear} and gr_year<={maxyear}",
                                                                            minyear = the_years[1], maxyear = the_years[2], 
                                                                            .con = globaldata$pool),
                                   "t_metricindsamp_meisa" =  glue_sql("SELECT mty_name, mei_id,mei_fi_id,mei_mty_id,mei_value,mei_last_update,mei_qal_id,mei_dts_datasource, sai_name, sai_cou_code, sai_id, fi_id, fi_id_cou FROM  datawg.t_samplinginfo_sai JOIN datawg.t_fishsamp_fisa ON fisa_sai_id =sai_id JOIN datawg.t_metricindsamp_meisa ON mei_fi_id =fi_id JOIN ref.tr_metrictype_mty ON  mei_mty_id=mty_id  WHERE sai_name in ({pick_typ_series*}) and sai_cou_code in ({pick_country*}) and  fi_lfs_code in ({pick_stage*}) and (fi_year>={minyear} OR extract(year from fi_date)>={minyear}) and (fi_year<={maxyear} OR extract(year from fi_date)<={maxyear})",
                                                                       minyear = the_years[1], maxyear = the_years[2],
                                                                       .con = globaldata$pool),
                                   "t_metricindseries_meiser" =  glue_sql("SELECT mty_name, mei_id,mei_fi_id,mei_mty_id,mei_value,mei_last_update,mei_qal_id,mei_dts_datasource, ser_nameshort, ser_id, fi_id, fi_id_cou, ser_cou_code FROM datawg.t_series_ser  JOIN datawg.t_fishseries_fiser ON fiser_ser_id =ser_id JOIN datawg.t_metricindseries_meiser ON mei_fi_id =fi_id JOIN ref.tr_metrictype_mty ON mty_id = mei_mty_id WHERE ser_nameshort in ({pick_typ_series*}) and ser_cou_code in ({pick_country*})  and ser_lfs_code in ({pick_stage*}) and (fi_year>={minyear} OR extract(year from fi_date)>={minyear}) and (fi_year<={maxyear} OR extract(year from fi_date)<={maxyear})",
                                                                          minyear = the_years[1], maxyear = the_years[2], 
                                                                          .con = globaldata$pool)
                   )
                   
                   query <- 
                     out_data <- dbGetQuery(globaldata$pool, query)
                   return(out_data)
                   
                 }
                 
                 
                 observeEvent(eventExpr = input$addRowTable_corAll, tryCatch({
                   emptyRow <- rvsAll$dbdata[1,,drop=FALSE]
                   emptyRow[1,] <- NA
                   rvsAll$data <- bind_rows(rvsAll$data,emptyRow)
                   replaceData(proxy_table_corAll,rvsAll$data , resetPaging = FALSE, rownames = FALSE)
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 
                 observeEvent(input$maps_editedtimeseries_draw_edited_features, tryCatch({
                   edited <- input$maps_editedtimeseries_draw_edited_features
                   nedited <- length(edited$features)
                   ids <- edited$features[[nedited]]$properties$`layerId`
                   i <- which(rvsAll$dbdata$ser_nameshort==ids)
                   newx <- edited$features[[nedited]]$geometry$coordinates[[1]]
                   newy <- edited$features[[nedited]]$geometry$coordinates[[2]]
                   cx <- which(names(rvsAll$dbdata)=="ser_x")
                   cy <- which(names(rvsAll$dbdata)=="ser_y")
                   info <- data.frame(row=rep(i,2),
                                      col=c(cx,
                                            cy),
                                      value=as.character(c(newx,newy)))
                   rvsAll$data[i, cx] <<- DT::coerceValue(newx, rvsAll$data[i, cx])
                   rvsAll$data[i, cy] <<- DT::coerceValue(newy, rvsAll$data[i, cy])
                   replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames=FALSE)
                   # datasame is set to TRUE when save or update buttons are clicked
                   # here if it is different it might be set to FALSE
                   rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
                   # this will collate all editions (coming from datatable observer in a data.frame
                   # and store it in the reactive dataset rvs$editedInfo
                   if (all(is.na(rvsAll$editedInfo))) {
                     
                     rvsAll$editedInfo <- info
                   } else {
                     rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, info)
                   }
                   
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 
                 # Create a DT proxy to manipulate data--------------------------
                 
                 proxy_table_corAll = dataTableProxy('table_corAll')
                 
                 # Edit table data -----------------------------------------
                 # Examples at
                 # https://yihui.shinyapps.io/DT-edit/
                 observeEvent(input$table_corAll_cell_edit, tryCatch({
                   info <- input$table_corAll_cell_edit
                   
                   i <- info$row
                   j <- info$col <- info$col + 1  # column index offset by 1
                   v <- info$value
                   
                   rvsAll$data[i, j] <<- DT::coerceValue(v, rvsAll$data[i, j])
                   replaceData(proxy_table_corAll, rvsAll$data, resetPaging = FALSE, rownames = FALSE)
                   # datasame is set to TRUE when save or update buttons are clicked
                   # here if it is different it might be set to FALSE
                   rvsAll$dataSame <- identical(rvsAll$data, rvsAll$dbdata)
                   # this will collate all editions (coming from datatable observer in a data.frame
                   # and store it in the reactive dataset rvs$editedInfo
                   if (all(is.na(rvsAll$editedInfo))) {
                     
                     rvsAll$editedInfo <- data.frame(info)
                   } else {
                     rvsAll$editedInfo <- dplyr::bind_rows(rvsAll$editedInfo, data.frame(info))
                   }
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 
                 # Observer the table edit_datatype picker input, and update the values in the 3 other pickerInput
                 # hide some of the pickeinput accordingly
                 
                 observeEvent(input$edit_datatype, {
                   req(globaldata$connectOK)
                   shinyCatch({ 
                     dictionnary$dictionnary <- createDictionnary()
                     dico <- dictionnary$dictionnary
                     irow = min(which(dico$editpicker_cou=="FR"))
                     selected_cou <- dico$editpicker_cou[irow] #we start we a French line
                     other_cou = sort(setdiff(unique(dico$editpicker_cou), selected_cou))
                     selected_typ_series <- dico$editpicker_typ_series[irow]
                     other_series <- sort(setdiff(unique(dico$editpicker_typ_series), selected_typ_series))
                     selected_lfs <- dico$editpicker_stage[irow]
                     other_lfs <- sort(setdiff(unique(dico$editpicker_stage), selected_lfs))
                     label <- ifelse(input$edit_datatype %in% c("t_series_ser","t_samplinginfo_sai"),
                                     "Select series :",
                                     "Select type :")
                     updatePickerInput(session=session,
                                       inputId="editpicker_typ_series",
                                       choices=c(selected_typ_series, other_series),
                                       label=label,
                                       selected=selected_typ_series,
                                       choicesOpt=list(disabled=c(FALSE,rep(TRUE, length(other_series)))))
                     selectedvalues$editpicker_typ_series <- selected_typ_series
                     updatePickerInput(session=session,
                                       inputId="editpicker_stage",
                                       choices=c(selected_lfs,other_lfs),
                                       label="Select stages :",
                                       selected=selected_lfs,
                                       choicesOpt = list(disabled = c(FALSE,
                                                                     rep(TRUE, length(other_lfs)))))
                     selectedvalues$editpicker_stage <- selected_lfs
                     updatePickerInput(session=session,
                                       inputId="editpicker_cou",
                                       selected=selected_cou,
                                       label="Select countries :",
                                       choices=c(selected_cou, other_cou),
                                       choicesOpt=list(disabled=c(FALSE,
                                                                 rep(TRUE,length(other_cou)))))
                     selectedvalues$editpicker_cou <- selected_cou
                     if (input$edit_datatype == "t_eelstock_eel_perc"){
                       shinyjs::hide("addRowTable_corAll")               
                     } else { # all other are sampling
                       shinyjs::show("addRowTable_corAll")
                     }  
                     if (input$edit_datatype %in% c("t_series_ser","t_samplinginfo_sai")) {
                       disable("yearAll")
                     } else {
                       enable("yearAll")
                     }
                     if (input$edit_datatype %in% c("t_eelstock_eel_perc","t_samplinginfo_sai")) {                      
                       disable("editpicker_stage")
                     } else {
                       enable("editpicker_stage")
                     } 
                     if (input$edit_datatype %in% c("t_series_ser")) {                      
                       shinyjs::enable(selector = '.navbar-nav a[data-value="Maps"')
                     } else {
                       shinyjs::disable(selector = '.navbar-nav a[data-value="Maps"')
                     } 

                     
                   })
                 })
                 
                 # Observer on button_show 
                 
                 observeEvent(input$button_show_table, {
                   req(globaldata$connectOK)
                   shinyCatch({                       
                     rvsAll$dataSame <- TRUE
                     rvsAll$editedInfo <- NA
                     data <- switch(input$edit_datatype,                       
                                    "t_dataseries_das" = mysourceAll() %>%
                                      arrange(ser_nameshort_ref,das_year), 
                                    "t_eelstock_eel" =  mysourceAll() %>%
                                      arrange(eel_emu_nameshort,eel_year),
                                    "t_eelstock_eel_perc" =  mysourceAll() %>%
                                      arrange(eel_emu_nameshort_ref,eel_year_ref),
                                    "t_series_ser" =  mysourceAll() %>% 
                                      arrange(ser_nameshort,ser_cou_code),
                                    "t_samplinginfo_sai" =  mysourceAll() %>% 
                                      arrange(sai_name,sai_cou_code),
                                    "t_metricgroupsamp_megsa" =  mysourceAll() %>% 
                                      arrange(sai_name,sai_cou_code),
                                    "t_metricindsamp_meisa"  =  mysourceAll() %>% 
                                      arrange(sai_name,sai_cou_code),
                                    "t_metricgroupseries_megser" = mysourceAll() %>% 
                                      arrange(ser_nameshort,ser_cou_code),
                                    "t_metricindseries_meiser" = mysourceAll() %>% 
                                      arrange(ser_nameshort,ser_cou_code)
                     )
                     rvsAll$data <- data
                     rvsAll$dbdata <- data
                   })
                   
                   # Render DT table -----------------------------------------
                   
                   output$table_corAll <- DT::renderDataTable({              
                     validate(need(globaldata$connectOK,"No connection"))
                     req(input$edit_datatype!="NULL")                    
                     noteditable=c(1,grep("_ref",names(rvsAll$dbdata)))-1
                     DT::datatable(
                       rvsAll$dbdata, 
                       filter="top",
                       rownames = FALSE,
                       extensions = "Buttons",
                       editable = list(target = 'cell',
                                       disable = list(columns = noteditable)), 
                       selection = 'none',
                       options=list(
                         order=list(3,"asc"),              
                         searching = TRUE,
                         rownames = FALSE,
                         scroller = TRUE,
                         scrollX = TRUE,
                         scrollY = "500px",
                         lengthMenu=list(c(50,-1),c("50","All")),
                         dom= "Blfrtip", #button fr search, t table, i information (showing..), p pagination
                         buttons=list(
                           list(extend="excel",
                                filename = paste0("data_",Sys.Date())))
                       ))              
                   })
                   
                   # Render Leaflet -------------------------------------------------              
                   output$maps_editedtimeseries <-renderLeaflet({                    
                     validate(need(globaldata$connectOK,""))
                     req(input$edit_datatype=="t_series_ser")
                     colors=rep("blue",nrow(rvsAll$data))
                     if (!all(is.na(rvsAll$editedInfo))){
                       colx=which(names(rvsAll$data)=="ser_x")
                       coly=which(names(rvsAll$data)=="ser_y")
                       colors[rvsAll$editedInfo$row[rvsAll$editedInfo$col %in% c(colx,coly)]]="red"
                     }
                     pal <- 
                       colorFactor(palette = c("blue", "red"), 
                                   levels = c("blue", "red"))
                     leaflet(rvsAll$data) %>%
                       addTiles(group="OSM") %>%
                       addProviderTiles(providers$Esri.WorldImagery, group="satellite")  %>%
                       addPolygons(data=globaldata$ccm_light %>% dplyr::filter(wso_id %in% as.integer(strsplit(gsub("(^\\{|\\}$)","",as.vector(rvsAll$data$ser_ccm_wso_id))
                                                                                                               ,',')[[1]])), 
                                   #popup=~as.character(wso_id),
                                   fill=TRUE, 
                                   highlight = highlightOptions(color='white',
                                                                weight=1,
                                                                bringToFront = TRUE,
                                                                fillColor="red",opacity=.2,
                                                                fill=TRUE))%>%
                       addPolygons(data=globaldata$ccm_light %>% 
                                     filter(st_is_within_distance(.,st_point(c(rvsAll$data$ser_x,
                                                                               rvsAll$data$ser_y)),50000, sparse=FALSE)[,1]),                                   popup=~as.character(wso_id),
                                   color="green",
                                   fill=TRUE, opacity=.8, 
                                   fillColor="grey", weight=2) %>%
                       addCircleMarkers(layerId=~ser_nameshort,
                                        color=~pal(colors),
                                        lat=~ser_y,
                                        lng=~ser_x,
                                        label=~ser_nameshort,
                                        group="stations") %>%
                       addDrawToolbar(targetGroup="stations",
                                      editOptions = editToolbarOptions(edit=TRUE,
                                                                       remove=FALSE),
                                      rectangleOptions=FALSE,
                                      circleOptions=FALSE,
                                      polygonOptions=FALSE,
                                      polylineOptions=FALSE,
                                      markerOptions=FALSE,
                                      circleMarkerOptions=FALSE) %>%
                       addLayersControl(baseGroups=c("OSM","satellite"))
                   })
                   
                 })
                 
                 
                 # Update edited values in db once save is clicked---------------------------------------------
                 
                 observeEvent(input$saveAllmod, tryCatch({
                   errors <- update_data_generic(editedValue = rvsAll$editedInfo,
                                                 pool = globaldata$pool, data=rvsAll$data,
                                                 edit_datatype=input$edit_datatype)
                   if (length(errors$error)>0) {
                     output$database_errorsAll<-renderText({iconv(unlist(errors$errors,"UTF8"))})
                     enable("clear_tableAll")
                   } else {
                     output$database_errorsAll<-renderText({errors$message})
                   }
                   rvsAll$dbdata <- rvsAll$data
                   rvsAll$dataSame <- TRUE
                   rvsAll$editedInfo = NA
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }))
                 
                 # Observe clear_table button -> revert to database table---------------------------------------
                 
                 observeEvent(input$clear_tableAll,
                              tryCatch({
                                data <- switch(input$edit_datatype,
                                               "t_dataseries_das" = mysourceAll() %>%
                                                 arrange(ser_nameshort_ref,das_year), 
                                               "t_eelstock_eel" =  mysourceAll() %>%
                                                 arrange(eel_emu_nameshort,eel_year),
                                               "t_eelstock_eel_perc" =  mysourceAll() %>%
                                                 arrange(eel_emu_nameshort_ref,eel_year_ref),
                                               "t_series_ser" =  mysourceAll() %>% 
                                                 arrange(ser_nameshort,ser_cou_code),
                                               "t_samplinginfo_sai" =  mysourceAll() %>% 
                                                 arrange(sai_name,sai_cou_code),
                                               "t_metricgroupsamp_megsa" =  mysourceAll() %>% 
                                                 arrange(sai_name,sai_cou_code),
                                               "t_metricindsamp_meisa"  =  mysourceAll() %>% 
                                                 arrange(sai_name,sai_cou_code),
                                               "t_metricgroupseries_megser" = mysourceAll() %>% 
                                                 arrange(ser_nameshort,ser_cou_code),
                                               "t_metricindseries_meiser" = mysourceAll() %>% 
                                                 arrange(ser_nameshort,ser_cou_code))
                                rvsAll$data <- data
                                rvsAll$dbdata <- data
                                rvsAll$editedInfo = NA
                                disable("clear_tableAll")
                                output$database_errorsAll<-renderText({""})
                                rvsAll$editedInfo = NA
                              },error = function(e) {
                                showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                              }), ignoreInit = TRUE)
                 
                 # Oberve cancel -> revert to last saved version -----------------------------------------------
                 
                 observeEvent(input$cancelAllmod, tryCatch({
                   rvsAll$data <- rvsAll$dbdata
                   rvsAll$dbdata <- NA
                   rvsAll$dbdata <- rvsAll$data #this is to ensure that the table display is updated (reactive value)
                   rvsAll$dataSame <- TRUE
                   rvsAll$editedInfo = NA
                 },error = function(e) {
                   showNotification(paste("Error: ", toString(print(e))), type = "error",duration=NULL)
                 }), ignoreInit = TRUE)
                 
                 # UI buttons ----------------------------------------------------------------------------------
                 # Appear only when data changed
                 
                 observe({
                   if (! rvsAll$dataSame) {
                     shinyjs::show("cancelAllmod")
                     shinyjs::show("saveAllmod")
                     
                   } else {
                     shinyjs::hide("saveAllmod")
                     shinyjs::hide("cancelAllmod")
                   }
                 })
                 
                 
                 
               }
  )
}