# check utilities
# functions to check that the code entered in the database is correct
# Author: cedric.briand
###############################################################################


#' check for missing values
#' 
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
check_missing <- function(dataset,column,country){
  if (any(is.na(dataset[,column]))){
    line<-(1:nrow(dataset))[is.na(dataset[,column])]
    if (length(line)>10) line <-str_c(str_c(line[1:10],collapse=";"),"...") else
      line <- str_c(line,collpase=";")
    cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, missing values line %s \n",
            country,
            deparse(substitute(dataset)),
            column,
            line))
  }
  return(invisible(NULL))
}

#' check_values
#' 
#' check the values in the current column against a list of values, missing values are removed
#' prior to assessment
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
check_values <- function(dataset,column,country,values){
  # remove NA from data
  ddataset <- as.data.frame(dataset[!is.na(dataset[,column]),])
  if (nrow(ddataset)>0){ # there might be NA, this will have been tested elsewhere
    if (! all(ddataset[,column]%in%values)) { # are all values matching ?
          values<- str_c(unique(ddataset[,column][!ddataset[,column]%in%values]),collapse=";")
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, values <%s> are wrong \n",
              country,
              deparse(substitute(dataset)),
              column,
              values))
    }
  } 
  return(invisible(NULL))
}


#' check_type
#' 
#' check for a specific type, e.g. numeric or character
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_type <- function(dataset,column,country,values,type){
  if (class(dataset[[column]])!=type) {
    cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, should be of type %s \n",
            country,
            deparse(substitute(dataset)),
            column,
            type))
  }
  return(invisible(NULL))  
}


#' check_unique
#' 
#' check that there is only one value in the column
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_unique <- function(dataset,column,country,values){
  ddataset <- as.data.frame(dataset[!is.na(dataset[,column]),])
  if (length(unique(ddataset[,column]))!=1) {
    cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, should only have one value \n",
            country,
            deparse(substitute(dataset)),
            column))
  }
  return(invisible(NULL))  
}

#' check_missvaluequa
#' 
#' check that there are data in missvaluequa only when there are missing value (NA) is eel_value
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_missvaluequa <- function(dataset,country){
  # tibbles are weird, change to dataframe
  ddataset<-as.data.frame(dataset)
  # first check that any value in eel_missvaluequal corresponds to a NA in eel_value
  # get the rows where a label has been put
  if (! all(is.na(ddataset[,"eel_missvaluequal"]))){
    # get eel_values where missing has been filled in
    lines<-which(!is.na(ddataset[,"eel_missvaluequal"]))
    eel_values_for_missing <-ddataset[lines,"eel_value"]
    if (! all(is.na(eel_values_for_missing))) {
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, lines <%s>, there is a code, but the eel_value field should be empty \n",
              country,
              deparse(substitute(dataset)),
              "eel_missvaluequal",
              lines[!is.na(is.na(eel_values_for_missing))]
          ))
    }
  }
  # now check of missing values do all get a comment
  # if there is any missing values
  if (any(is.na(ddataset[,"eel_value"]))){
    # get eel_values where missing has been filled in
    lines<-which(is.na(ddataset[,"eel_value"]))
    eel_missingforvalues <-ddataset[lines,"eel_missvaluequal"]
    # if in those lines, one missing value has not been commented upon
    if (any(is.na(eel_missingforvalues))) {
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, lines <%s>, there should be a code, as the eel_value field is missing \n",
              country,
              deparse(substitute(dataset)),
              "eel_missvaluequal",
              lines[is.na(eel_missingforvalues)]))
    }
  }
  return(invisible(NULL))  
}
