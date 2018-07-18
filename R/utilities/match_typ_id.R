#' add eel_typ_id column before importing to database
#' 
#' create a small function which takes for input any dataset with a typ_name 
#' and collects the tr_typeserie_typ data from the database using extract_ref, 
#' it will create the column
#' 
#' @param dataset the name of the dataset
#' 
source("R/R/database_interaction/database_reference.R")
match_typ_id <- function(dataset){
  type <- extract_ref("Type of series")
  ddataset <- as.data.frame(dataset)
  ddataset[c("eel_typ_id")] <- lapply(c("typ_id"), function(x) type[[x]][match(ddataset$eel_typ_name, type$eel_typ_name)])
  return(ddataset)
}
