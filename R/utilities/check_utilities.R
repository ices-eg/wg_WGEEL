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
  answer = NULL
  if (any(is.na(dataset[,column]))){
    line<-(1:nrow(dataset))[is.na(dataset[,column])]
    if (length(line)>10) line <-str_c(str_c(line[1:10],collapse=";"),"...") else
      line <- str_c(line,collpase=";")
    cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, missing values line %s \n",
            country,
           deparse(substitute(dataset)),
            column,
            line))
    answer  = data.frame(nline = line, error_message = paste("missing value in column: ", column, sep = ""))
  }
  return(answer)
}

#' check_values
#' 
#' check the values in the current column against a list of values, missing values are removed
#' prior to assessment
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
dataset=aquaculture
column= "eel_typ_id"
country=country
values=c(11,13)
check_values <- function(dataset,column,country,values){
  # remove NA from data
  dataset$nline <- 1:nrow(dataset)
  ddataset <- as.data.frame(dataset[!is.na(dataset[,column]),])
  if (nrow(ddataset)>0){ 
    #line<-(1:nrow(dataset))[is.na(dataset[,column])]# there might be NA, this will have been tested elsewhere
    if (! all(ddataset[,column]%in%values)) { # are all values matching ?
          value<- str_c(unique(ddataset[,column][!ddataset[,column]%in%values]),collapse=";")
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, value <%s> is wrong \n",
              country,
              deparse(substitute(dataset)),
              column,
              value))
    }
    answer  = data.frame(nline = ddataset$nline[!ddataset[,column]%in%values], error_message = paste("value in column: ", column, " is wrong", sep = ""))
  }
  return(answer)
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
              lines[!is.na(eel_values_for_missing)]
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


#' check_missvalue_restocking
#' 
#' check if there is data in eel_value_number and eel_value_kg
#' if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
#' if there is data in neither eel_value_number and eel_value_kg, check if there are data in missvaluequa 
#' 
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
#' 
check_missvalue_restocking <- function(dataset,country){
  # tibbles are weird, change to dataframe
  ddataset<-as.data.frame(dataset)
  # first check that any value in eel_missvaluequal corresponds to a NA in eel_value_number and eel_value_kg
  # get the rows where a label has been put
  if (! all(is.na(ddataset[,"eel_missvaluequal"]))){
    # get eel_values where missing has been filled in
    lines<-which(!is.na(ddataset[,"eel_missvaluequal"]))
    eel_values_for_missing <-ddataset[lines,c("eel_value_number","eel_value_kg")]
    if (! all(is.na(eel_values_for_missing))) {
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, lines <%s>, there is a code, but the eel_value_number and eel_value_kg field should be empty \n",
                  country,
                  deparse(substitute(dataset)),
                  "eel_missvaluequal",
                  lines[!is.na(eel_values_for_missing)]
      ))
    }
  }
  # now check of missing values do all get a comment
  # if there is any missing values
  if (all(is.na(ddataset[,c("eel_value_number","eel_value_kg")]))){
    # get eel_values where missing has been filled in
    lines<-which(is.na(ddataset[,c("eel_value_number","eel_value_kg")]))
    eel_missingforvalues <-ddataset[lines,"eel_missvaluequal"]
    # if in those lines, one missing value has not been commented upon
    if (any(is.na(eel_missingforvalues))) {
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, lines <%s>, there should be a code, as the eel_value_number and eel_value_kg fields are both missing \n",
                  country,
                  deparse(substitute(dataset)),
                  "eel_missvaluequal",
                  lines[is.na(eel_missingforvalues)]))
    }
  }
  
  # now check if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
  # if there is any missing values
    if (any(is.na(ddataset[,c("eel_value_number","eel_value_kg")]))){
    # get eel_values where missing has been filled in
    lines<-which(is.na(ddataset[,c("eel_value_number","eel_value_kg")]))
    # if in those lines, one missing value has not been commented upon
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, lines <%s>, there should be a value in both column eel_value_number and eel_value_kg \n",
                  country,
                  deparse(substitute(dataset)),
                  "eel_missvaluequal"))
    }
  return(invisible(NULL))  
}
