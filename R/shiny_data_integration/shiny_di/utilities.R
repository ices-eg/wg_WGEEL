#' @title converts to boolean
#' @description this function converts any kind of boolean from a spreadsheet
#' such as 0, true or FALSE to real #' boolean
#' @param myvec the vector
#' @param name a name to detect potential errors
#' @return a vector of boolean
#
#port <- 5432
#host <- "localhost"#"192.168.0.100"
#userwgeel <-"wgeel"
#pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="wgeel",
#		host=host,
#		port=port,
#		user= userwgeel,
#		password= passwordwgeel) 
#path<-"C:\\Users\\cedric.briand\\Downloads\\modified_series_2020-08-23_FR.xlsx"


convert2boolean <- function(myvec, name){
  myvec <- as.character(myvec)
  if (!all(myvec %in% c(NA,"0","1","true","false","TRUE","FALSE")))
    stop(paste("unrecognised boolean in",name, myvec[!myvec %in% c(NA,"0","1","true","false","TRUE","FALSE")])," is not a boolean, use TRUE or FALSE or 0 or 1")
  myvec[!is.na(myvec)] <- ifelse(myvec[!is.na(myvec)] %in% c("0","false","FALSE"),
                  FALSE,
                  TRUE)
  as.logical(myvec)
}


#' @title readxlTemplate
#' @description this function reads an excel template and uses a dictionary
#' to use the appropriate coltype
#' @param path the path to the data file
#' @param sheet the sheet to be read
#' @param dict dictionary defined in global.R
#' @return a well formatted tibble
#' @importFrom readxl read_excel
#


readxlTemplate <- function(path, sheet, dict=dictionary){
  headers <- suppressWarnings(read_excel(
    path=path,
    sheet=sheet,
    skip=0, 
    n_max=0))
  readed_coltypes = dict[names(headers)]
  
  data_xls <- suppressWarnings(read_excel(
    path=path,
    sheet=sheet,
    skip=0, 
    col_types=readed_coltypes))
  data_xls
}


