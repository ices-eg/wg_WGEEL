#' export_model_to_taf
#' add lines to the TAF model.R file which corresponds to the model
#' @param modelname the name of the object containing the model
#' @param taf_directory path to the taf directory
#'
#' @return nothing
#' @export
#'
#' @examples
export_model_to_taf <- function(modelname, 
                                taf_directory){
  mymodel <- get(modelname)
  
  fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                   open = "a+b")
  writeLines("", fileConn)
  writeLines("", fileConn)
  
  writeLines(paste("#######RUN MODEL", modelname), fileConn)
  command <- mymodel$call
  writeLines(paste(modelname,"<-",
                   paste(deparse(command), collapse = "\n")),
             fileConn)
  
  writeLines(paste0("modelResults <- c(modelResults, ",
                    quote_string(modelname),
                    ")"), fileConn)
  
  close(fileConn)
}

#' export_predict_model_to_taf
#' add lines to the TAF model.R file which corresponds to the model
#' @param modelname the name of the object containing the model
#' @param taf_directory path to the taf directory
#' @param reference reference period as a string (default "1960:1979")
#'
#' @return nothing
#' @export
#'
#' @examples
export_predict_model_to_taf <- function(modelname, 
                                        taf_directory,
                                        reference = "1960:1979"){
  fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                   open = "a+b")
  writeLines("", fileConn)
  writeLines("", fileConn)
  
  name_output <- paste("pred", modelname, sep = "_")
  writeLines(paste("##PREDICTION MODEL", modelname), fileConn)
  command <- paste(name_output, 
                   "<-",
                   "predict_model(",
                   paste(modelname,
                         reference,
                         sep=", "),
                   ")"
  )
  writeLines(command,
             fileConn)
  writeLines(paste0("modelResults <- c(modelResults, ",
                    quote_string(name_output),
                    ")"), fileConn)
  
  close(fileConn)
}




#' export_graph_to_TAF
#' export graph based on model prediction to TAF
#' @param modelname the name of the object containing the model
#' @param taf_directory path to the taf directory
#' @param width default 16/2.54
#' @param height default 10/2.54
#' @param units default "in"
#' @param dpi default 150
#' @param format default png
#' @param xlab xaxis title
#' @param ylab yaxis title
#' @param palette the colors to be used, if NULL (default) standard ggplot
#' colors will be used
#' @param logscale should a logscale y be used for y axis(default FALSE) 
#' @param ... other option send to theme
#'
#' @return nothing
#' @export
#'
#' @examples
export_graph_to_TAF <- function(modelname, 
                                taf_directory,
                                width = 16/2.54,
                                height = 10/2.54,
                                units = "in",
                                dpi = 150,
                                format = "png",
                                xlab = "", 
                                ylab = "",
                                palette = NULL,
                                logscale = FALSE,
                                ...){
  #get the argument line
  current_call <- match.call()
  
  #retrieve corresponding predtable name
  predname <- paste("pred", modelname, sep = "_")
  
  #format the commandline
  list_call <- as.list(current_call)
  
  #set the name of prediction table
  list_call[names(list_call) == "modelname"] <- predname
  names(list_call)[names(list_call) == "modelname"] <- "predtable"
  
  #remove taf_directory and other units
  list_call <- list_call[-which(names(list_call) %in% c("taf_directory",
                                                        "width" ,
                                                        "height",
                                                        "units" ,
                                                        "dpi",
                                                        "format"))]
  
  command <- deparse(as.call(list_call))
  command <- gsub("export_graph_to_TAF", "plot_trend_model", command)
  command <- gsub(paste0("\"",predname,"\""),predname, command)
  
  fileConn <- file(paste(taf_directory, "report.R", sep = "/"), 
                   open = "a+b")
  writeLines("", fileConn)
  writeLines("", fileConn)
  writeLines(paste("##EXPORT TREND GRAPH MODEL", modelname), fileConn)
  writeLines(command,
             fileConn)
  filename <- paste(paste(list_call[-1], collapse = "_"), format, sep = ".") 
  writeLines(deparse(call("ggsave", 
                          filename = paste0("report/figure", filename), 
                          width=width, 
                          height = height,
                          units = units,
                          dpi = dpi)),
             fileConn)
  close(fileConn)
}


#' write_to_taf
#' write a line to taf
#' @param lines the lines to be written
#' @param file the TAF file to modify
#' @param taf_directory the taf directory
#' @param blank should an empty line be inserted first
#'
#' @return
#' @export
#'
#' @examples
write_to_taf <- function(lines, file, taf_directory, blank = TRUE){
  fileConn <- file(paste(taf_directory, file, sep = "/"), 
                   open = "a+b")
  if (blank)
    writeLines("", fileConn)
  writeLines(lines, fileConn)
  close(fileConn)
}


#' write_file_to_taf
#' writes a full file to taf
#' @param source_file the source file
#' @param destination_file the file name to copy to in taf directory
#' @param taf_directory the taf directory
#' @param overwrite = TRUE
#' @return
#' @export
#'
#' @examples
write_file_to_taf <- function(source_file, destination_file=NULL, taf_directory){
  if (is.null(destination_file)) destination_file <- source_file
  file.copy(source_file, taf_directory)
  file.rename(from= file.path(taf_directory,source_file), to=file.path(taf_directory,destination_file))
}

#' export_all_modelprocess_to_taf
#' @description export all the model filling model.R, report.R
#' @param modelname the name of the model
#' @param taf_directory path to taf_directory
#' @param reference the reference period as a string (default "1960:1979")
#' @param graphparam a list of named lists (one per graph) specifying the
#' graph to be generated
#' @details
#' basically, the function call the other export functions, it aims at 
#' simplifying the main script
#' 
#' @return nothing
#' @export 

export_all_modelprocess_to_taf <- function(modelname, 
                                           taf_directory, 
                                           reference = "1960:1979",
                                           graph_param){
  #first we export the model
  export_model_to_taf(modelname, taf_directory)
  
  #then the prediction
  export_predict_model_to_taf(modelname, taf_directory, reference)
  
  #then the graph
  if (length(graph_param) > 0){
    graphargs <- list(modelname = modelname,
                      taf_directory = taf_directory)
    lapply(graph_param, function(g){
      args <- c(graphargs, g)
      string_args <- gsub("list", "", deparse1(args))
      eval(parse(text = paste0("export_graph_to_TAF",
                               string_args)))
    })
  }
  
  #finally export the predtable
  export_predtable_to_taf(modelname, taf_directory)
}




#' export_data_to_taf
#' @description copy files to taf_directory
#' @param source_directory path to source directory
#' @param taf_directory path to taf_directory
#' @param files Vector of names of files to copy
#' @param overwrite Do you want to replace the files if already existing, Default: TRUE
#' @return nothing
#' @rdname export_data_to_taf
#' @export 
export_data_to_taf <- function(source_directory, taf_directory, files, overwrite = TRUE){
  lf <- list.files(path= source_directory)
  if (!(all(files %in% lf))) warnings(sprintf("file(s) %s not in the folder", paste(files[!files %in% lf]), collapse=","))
  mapply(function(x) file.copy(from=file.path(source_directory,x),
                               to = paste0(taf_directory, "/boot/"),
                               overwrite=overwrite),
         files)
}


#' export_predtable_to_taf
#' @description update report.R to add the creation of a prediction csv table
#' @param modelname the name of the model
#' @param taf_directory path to taf_directory
#' 
#' @return nothing
#' @export 

export_predtable_to_taf <- function(modelname, 
                                    taf_directory){
  predname <- paste("pred", modelname, sep = "_")
  fileConn <- file(paste(taf_directory, "report.R", sep = "/"), 
                   open = "a+b")
  writeLines("", fileConn)
  writeLines(paste0("### Export pred table", modelname), fileConn)
  formatted_tab <- paste("formatted",
                         predname,
                         sep = "_")
  writeLines(paste0(paste("formatted",
                   predname,
                   sep = "_"),
                   "<- createReportTableFromPred(",
                   predname,
                   ")"),
             fileConn)
  writeLines(paste0("outputResults <- c(outputResults, ",
                    quote_string(formatted_tab),
                    ")"),
             fileConn)
  close(fileConn)
  
}


export_selection_to_taf <- function(taf_directory){
  fileConn <- file(paste(taf_directory, "data.R", sep = "/"), 
                   open = "a+b")
  
  writeLines("", fileConn)
  writeLines("## 2 Preprocess data", fileConn)
  writeLines("selection <- select_series(wger_init, R_stations)
vv <- selection$vv
glass_eel_yoy <- selection$glass_eel_yoy
older <- selection$older
wger <- selection$wger
R_stations <- selection$R_stations",
             fileConn)
  writeLines("", fileConn)
  writeLines("series_tables <- make_table_series(vv, R_stations, wger)
vv <- series_tables$vv
REPORTR_stations <- series_tables$R_stations 
REPORTseries_CY <- series_tables$series_CY
REPORTseries_CYm1 <- series_tables$series_CYm1
REPORTseries_lost <- series_tables$series_lost
REPORTseries_prob <- series_tables$series_prob
REPORTprintstatseriesY <- series_tables$printstatseriesY
REPORTprintstatseriesGNS <- series_tables$printstatseriesGNS
REPORTprintstatseriesGEE <- series_tables$printstatseriesGEE
REPORTprintstatseriesGY <- series_tables$printstatseriesGY",
             fileConn)
  
  
  
  writeLines("", fileConn)
  writeLines("## 3 Write TAF tables to data directory", fileConn)
  for (tab in c('glass_eel_yoy', 'older', 'REPORTR_stations', 
                'REPORTseries_CY', 'REPORTseries_CYm1', 'REPORTseries_lost', 'REPORTseries_prob', 'REPORTprintstatseriesY',
                'REPORTprintstatseriesGNS', 'REPORTprintstatseriesGEE',  'REPORTprintstatseriesGY'))
    writeLines(paste0("write.taf(", tab, ", dir = 'data', quote = TRUE)"),
                      fileConn)
  writeLines("save(list = c('glass_eel_yoy', 'older'), file = 'data/datamodel.Rdata')",
             fileConn)
  writeLines("save(list = c('REPORTR_stations', 'vv',
  'REPORTseries_CY', 'REPORTseries_CYm1', 'REPORTseries_lost', 'REPORTseries_prob', 'REPORTprintstatseriesY',
  'REPORTprintstatseriesGNS', 'REPORTprintstatseriesGEE',  'REPORTprintstatseriesGY'), file = 'data/selectionsummary.Rdata')", fileConn)
  close(fileConn)
}


export_diagram_series_to_taf <- function(taf_directory){
  fileConn <- file(paste(taf_directory, "report.R", sep = "/"), 
      open = "a+b")
  
  writeLines("", fileConn)
  writeLines("## create diagram of series selection", fileConn)
  writeLines("load(selection_summary.Rdata)",fileConn)
  writeLines("diagram_series_used(selection_summary)", fileConn)
      close(fileConn)
}


