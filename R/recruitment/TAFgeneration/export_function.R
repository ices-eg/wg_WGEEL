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
  close(fileConn)
}


