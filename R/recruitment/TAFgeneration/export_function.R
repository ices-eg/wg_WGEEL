#' export_model_to_taf
#' add lines to the TAF model.R file which corresponds to the model
#' @param modelname the name of the object containing the model
#' @param taf_directory path to the taf directory
#' @param append should the model be appended to model.R(default TRUE)
#'
#' @return nothing
#' @export
#'
#' @examples
export_model_to_taf <- function(modelname, 
                                taf_directory, 
                                append = TRUE){
  mymodel <- get(modelname)
  if (append){
    fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                     open = "a+b")
    writeLines("", fileConn)
    writeLines("", fileConn)
  } else {
    fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                     open = "w")
  }
  
  writeLines(paste("#######RUN MODEL", modelname), fileConn)
  command <- mymodel$call
  writeLines(paste(modelname,"<-",
                   paste(deparse(command), collapse = "\n")),
             fileConn)
  
  writeLines("modelResults <- c(modelResults, modelname)", fileConn)
  
  close(fileConn)
}

#' export_predict_model_to_taf
#' add lines to the TAF model.R file which corresponds to the model
#' @param modelname the name of the object containing the model
#' @param taf_directory path to the taf directory
#' @param reference reference period as a string (default "1960:1979")
#' @param vargroup the grouping variable (default area), NULL if no grouping
#'
#' @return nothing
#' @export
#'
#' @examples
export_predict_model_to_taf <- function(modelname, 
                                        taf_directory,
                                        reference = "1960:1979", 
                                        vargroup = "area"){
  fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                   open = "a+b")
  writeLines("", fileConn)
  writeLines("", fileConn)
  if (is.null(vargroup)) {
    vargroup <- "NULL"
  } else {
    vargroup <- paste0("'",vargroup,"'")
  }
  name_output <- paste("pred", modelname, sep = "_")
  writeLines(paste("##PREDICTION MODEL", modelname), fileConn)
  command <- paste(name_output, 
                   "<-",
                   "predict_model(",
                   paste(modelname,
                         reference,
                         vargroup,
                         sep=", "),
                   ")"
  )
  writeLines(command,
             fileConn)
  writeLines("modelResults <- c(modelResults, name_output)", fileConn)
  
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
#' @param vargroup the grouping variable (default area), NULL if no grouping
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
                                vargroup = "area",
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
mapply(function(x) file.copy(from=file.path(source_directory,x), to = taf_directory, overwrite=overwrite), files)
 }

