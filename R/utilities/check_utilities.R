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

check_values <- function(dataset,column,country,values){
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  # remove NA from data
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  if (nrow(ddataset)>0){ 
    #line<-(1:nrow(dataset))[is.na(dataset[,column])]# there might be NA, this will have been tested elsewhere
    if (! all(ddataset[,column]%in%values)) { # are all values matching ?
          value<- str_c(unique(ddataset[,column][!ddataset[,column]%in%values]),collapse=";")
          line <- ddataset$nline[!ddataset[,column]%in%values]
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s>, value <%s> is wrong \n",
              country,
              deparse(substitute(dataset)),
              column,
              line,
              value))
      
      answer  = data.frame(nline = line , error_message = paste("value in column: ", column, " is wrong", sep = ""))
    }
  }
  return(answer)
}

#column="eel_year"

#' check_type
#' 
#' check for a specific type, e.g. numeric or character
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"

check_type <- function(dataset,column,country,values,type){
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  #remove NA from data
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  if (nrow(ddataset)>0){ 
    
    if (type=="numeric") { # cant check for a numeric into a character
      options("warn"=1)
      ddataset[,column]<-as.numeric(ddataset[,column]) # creates a warning message because of NAs introduced by coercion
      options("warn"=0)
      line <- ddataset$nline[is.na(ddataset[,column])]
      if (length(line)>0){
        cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s>,  should be of type %s \n",
                    country,
                    deparse(substitute(dataset)),
                    column,
                    line,
                    type))
        
        answer  = data.frame(nline = line, error_message = paste("error type in: ", column, sep = ""))
      }
    }
  }
  return(answer)  
}




#' check_unique
#' 
#' check that there is only one value in the column
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_unique <- function(dataset,column,country){
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  # remove the NA
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  
  if (length(unique(ddataset[,column])) != 1) {   
    line <- ddataset$nline[which(ddataset[,column] != country)]
  }
    cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s> , should only have one value \n",
            country,
            deparse(substitute(dataset)),
            column,
            line))
    
    answer  = data.frame(nline = line, error_message = paste("different country name in: ", column, sep = ""))
  return(answer)  
}



#dataset=aquaculture
#country=country


#' check_missvaluequa
#' 
#' check that there are data in missvaluequa only when there are missing value (NA) is eel_value
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_missvaluequa <- function(dataset,country){
  answer1 = NULL
  answer2 = NULL
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
              lines[!is.na(eel_values_for_missing)]))
      line1 <- lines[!is.na(eel_values_for_missing)]
      answer1  = data.frame(nline = line1, error_message = paste("there is a code in:", column, ", but the eel_value field should be empty", sep = ""))
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
      line2 <- lines[is.na(eel_missingforvalues)]
      answer2  = data.frame(nline = line2, error_message = paste("there should be a code in:",column, ", as the eel_value field is missing", sep = ""))
    }
  }
  return(rbind(answer1, answer2))  
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
