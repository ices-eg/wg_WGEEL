# check utilities
# functions to check that the code entered in the database is correct
# Author: cedric.briand
###############################################################################




#' check for missing values
#' 
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
check_missing <- function(dataset, namedataset, column,country){
  answer = NULL
  if (any(is.na(dataset[,column]))){
    line<-(1:nrow(dataset))[is.na(dataset[,column])]
    if (length(line)>10) line <-str_c(str_c(line[1:10],collapse=";"),"...") else
      line <- str_c(line) # before it was str_c(line, collapse=";") but it was crashing when checking for duplicates
    if (length(line)>0){
      cat(sprintf("dataset <%s>, column <%s>, missing values line %s \n",
							    namedataset,
                  column,
                  line))
      answer  = data.frame(nline = line, error_message = sprintf("dataset <%s>, column <%s>, missing values line %s \n",
							namedataset,
							column,
							line))
    }
  }
  return(answer)
}

#' check_values
#' 
#' check the values in the current column against a list of values, missing values are removed
#' prior to assessment
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated

check_values <- function(dataset,namedataset, column,country,values){
  answer = NULL
	namedataset <-  deparse(substitute(dataset))
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  # remove NA from data
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  if (nrow(ddataset)>0){ 
  
		if (! all(ddataset[,column]%in%values)) { # are all values matching ?
      value <- ddataset[,column][!ddataset[,column]%in%values]
      line <- ddataset$nline[!ddataset[,column]%in%values]
      if (length(line)>0){
        cat(sprintf("dataset <%s>, column <%s>, line <%s>, value <%s> is wrong, possibly not entered yet \n", 
								    namedataset,
                    column,
										str_c(unique(line),collapse=";"),
										str_c(value,collapse=";")))
        # same but split and no end of line
        answer  = data.frame(nline = line , 
						error_message = sprintf("dataset <%s>, column <%s>, value <%s> is wrong, possibly not entered yet", 
								namedataset,
								column,
								value))
      }
    }
  }
  return(answer)
}


#' check_type
#' 
#' check for a specific type, e.g. numeric or character
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"

check_type <- function(dataset,namedataset, column,country,values,type){
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
        cat(sprintf("column <%s>, line <%s>, dataset <%s>,  should be of type %s \n",
                    column,
                    line,
										namedataset,
                    type))
        
        answer  = data.frame(nline = line, error_message = sprintf("column <%s>, should be of type %s \n",
								column,								
								type))
      }
    }
  }
  return(answer)  
}



#' check_unique
#' 
#' check that there is only one value in the column
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_unique <- function(dataset, namedataset, column,country){
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  # remove the NA
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  
  if (length(unique(ddataset[,column])) != 1) {   
    line <- ddataset$nline[which(ddataset[,column] != country)]
    if (length(line)>0){
    cat(sprintf("column <%s>, line <%s> , dataset <%s>, should only have one value \n",
            column,
            line,
						namedataset))
    
    answer  = data.frame(nline = line, error_message = paste("different names in column : ", column, sep = ""))
  return(answer)  
    }
  }
}



#' check_missvaluequal
#' 
#' check that there are data in missvaluequal only when there are missing value (NA) is eel_value
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
check_missvaluequal <- function(dataset, namedataset, country){
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
      line1 <- lines[!is.na(eel_values_for_missing)]
      if (length(line1)>0){
        cat(sprintf("column <%s>, lines <%s>, dataset <%s>, there is a code, but the eel_value field should be empty \n",
                    "eel_missvaluequal",
                    line1,
										namedataset))
        
        answer1  = data.frame(nline = line1, error_message = paste("there is a code in eel_missvaluequal, but the eel_value field should be empty", sep = ""))
      }
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
      line2 <- lines[is.na(eel_missingforvalues)]
      if (length(line2)>0){
        cat(sprintf("column <%s>, lines <%s>, there should be a code, as the eel_value field is missing \n",
                    "eel_missvaluequal",
                    line2))
        
        answer2  = data.frame(nline = line2, error_message = paste("there should be a code in eel_missvaluequal, as the eel_value field is missing", sep = ""))
      }
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
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
#' 
check_missvalue_release <- function(dataset, namedataset, country,updated=FALSE){
  answer1 = NULL
  answer2 = NULL
  answer3 = NULL
  name_value = c("eel_value_number","eel_value_kg")
  if (updated) name_value = "eel_value"
  # tibbles are weird, change to dataframe
  ddataset<-as.data.frame(dataset)
  # first check that any value in eel_missvaluequal corresponds to a NA in eel_value_number and eel_value_kg
  # get the rows where a label has been put
  if (! all(is.na(ddataset[,"eel_missvaluequal"]))){
    # get eel_values where missing has been filled in
    lines<-which(!is.na(ddataset[,"eel_missvaluequal"]))
    eel_values_for_missing <-ddataset[lines,name_value]
    if (! all(is.na(eel_values_for_missing))) {
      line1 <- lines[!is.na(eel_values_for_missing)]
      if (length(line1)>0){
      cat(sprintf("column <%s>, lines <%s>, there is a code, but the eel_value_number and eel_value_kg field should be empty \n",
                  "eel_missvaluequal",
                  line1 ))
      answer1 <- data.frame(nline = line1, error_message = paste(" there is a code in eel_missvaluequal but the eel_value_number and eel_value_kg field should be empty" ))
      }
    }
  }
  # now check of missing values do all get a comment
  # if there is any missing values
  if (all(is.na(ddataset[,name_value]))){
    # get eel_values where missing has been filled in
    lines<-which(is.na(ddataset[,name_value]))
    eel_missingforvalues <-ddataset[lines,"eel_missvaluequal"]
    # if in those lines, one missing value has not been commented upon
    if (any(is.na(eel_missingforvalues))) {
      line2 <- lines[is.na(eel_missingforvalues)]
      if (length(line2)>0){
      cat(sprintf("column <%s>, lines <%s>, there should be a code, as the eel_values are both missing \n",
                  "eel_missvaluequal",
                  line2 ))
        answer2 <- data.frame(nline = line2, error_message = paste("there should be a code in eel_missvaluequal as eel_values fields are both missing"))
      }
    }
  }
  
  # now check if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
  # if there is any missing values
    if (any(is.na(ddataset[,name_value]))){
    # get eel_values where missing has been filled in
    line3<-which(is.na(ddataset[,name_value] & ddataset$eel_typ_name!="gee_n" ))
    if (length(line3)>0){
    # if in those lines, one missing value has not been commented upon
      cat(sprintf("column <%s>, lines <%s>, there should be a value in both column eel_value_number and eel_value_kg \n",
                  "eel_missvaluequal",
                  line3))
      answer3 <- data.frame(nline = line3, error_message = paste("there should be a value in both column eel_value_number and eel_value_kg"))   
        }
    }
  return(rbind(answer1,answer2,answer3))  
}


#' check_positive
#' 
#' check that the data in ee_value is positive
#' 
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
#' 
check_positive <- function(dataset, namedataset, column,country){
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  #remove NA from data
  ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
  if (nrow(ddataset)>0){
    line<-which(ddataset[,column]<0)
    if (length(line)>0){
      cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s>,  should be a positive value \n",
                  country,
									namedataset,
                  column,
                  line))
      answer  = data.frame(nline = line, error_message = paste("negative value in: ", column, sep = ""))
    }
  }
  return(answer)  
}


#' check if there is an ICES area division for freshwater data
#' prior to assessment
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param country the current country being evaluated
check_freshwater_without_area <- function(dataset,namedataset, country){
  #browser()
  answer = NULL
  newdataset <- dataset
  newdataset$nline <- 1:nrow(newdataset)
  # remove NA from data
  ddataset <- as.data.frame(newdataset[
    !is.na(newdataset[,"eel_area_division"]) &
      newdataset[,"eel_hty_code"]=="F" &
      !is.na(newdataset[,"eel_hty_code"]),]
  )   
  if (nrow(ddataset)>0){ 
    line <- ddataset$nline
    if (length(line)>0){
      cat(sprintf("line <%s>, there should not be any area divsion in freshwater \n",                   
                  line))
      
      answer  = data.frame(nline = line , error_message = paste0("there should not be any area divsion in freshwater"))
    }
    
  }
  return(answer)
}


#' check_positive
#' 
#' check that the data in ee_value is positive
#' 
#' @param dataset the name of the dataset
#' @param column the name of the column
#' @param country the current country being evaluated
#' @param type, a class described as a character e.g. "numeric"
#' 
check_between <- function(dataset, namedataset, column, country, minvalue, maxvalue){
	answer = NULL
	newdataset <- dataset
	newdataset$nline <- 1:nrow(newdataset)
	#remove NA from data
	ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
	if (nrow(ddataset)>0){
		line<-which(ddataset[,column]<minvalue)
		if (length(line)>0){
			cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s>,  should be larger than <%s> \n",
							country,
							namedataset,
							column,
							line,
							minvalue))
		}
			line<-which(ddataset[,column]>maxvalue)
			
			if (length(line)>0){
				cat(sprintf("Country <%s>,  dataset <%s>, column <%s>, line <%s>,  should be lower than <%s> \n",
								country,
								namedataset,
								column,
								line,
								maxvalue))
			answer  = data.frame(nline = line, error_message = paste("values out of bound: ", column, sep = ""))
		}
	}
	return(answer)  
}

#' check that emu is a whole country emu
#' 
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' 
check_emu_country <- function(dataset, namedataset, column, country){
  answer=NULL
  conn <- poolCheckout(pool)
  emu_whole <- dbGetQuery(conn,paste("select emu_nameshort from ref.tr_emu_emu where emu_wholecountry=true and emu_cou_code='",country,"'",sep=""))[,1]
  poolReturn(conn)
  if (sum(!dataset[,column] %in% emu_whole)>0)
    answer=data.frame(nline = which(!dataset[,column] %in% emu_whole),
                      error_message=paste("eel_emu_nameshort should be in {",paste(emu_whole,collapse=", "),"}",sep=""))
  return(answer)
}


#' check that biomass is numeric and only NP
#' 
#' @param dataset the name of the dataset
#' @param namedataset the name of the sheet 
#' @param column the name of the column
#' @param country the current country being evaluated
#' 

check_rates_num <- function(dataset, namedataset, column, country){
	answer = NULL
	namedataset <-  deparse(substitute(dataset))
	newdataset <- dataset
	newdataset$nline <- 1:nrow(newdataset)
	# remove NA from data
	ddataset <- as.data.frame(newdataset[!is.na(newdataset[,column]),])
	
	ddataset$num <- as.numeric(ddataset[,column])

	if (nrow(ddataset)>0){ 
		
		if (any(ddataset[is.na(ddataset$num),column]!="NP")) { # are all values matching ?
			value1 <- ddataset[ddataset[,column]!="NP" & is.na(ddataset$num), column]
			line1 <- ddataset$nline[ddataset[,column]!="NP" & is.na(ddataset$num)]
		}else {	value1 <- vector() 
				line1 <- vector()
			}
		
		if (length(ddataset[!is.na(ddataset$num),column])>0) {
				value2 <- ddataset[!is.na(ddataset$num) & (ddataset$num<0
										| ddataset$num>100), "num"]
				line2 <- ddataset$nline[!is.na(ddataset$num) & (ddataset$num<0
									| ddataset$num>100)]
			}else {	value2 <- vector() 
					line2 <- vector()
				}
			
		value <- c(value1, value2)
		line <- c(line1, line2)
			
			if (length(line)>0){
				cat(sprintf("dataset <%s>, column <%s>, line <%s>, value <%s> is wrong, only numeric between 0 and 100 or NP is possible \n", 
								namedataset,
								column,
								str_c(unique(line),collapse=";"),
								str_c(value,collapse=";")))
				# same but split and no end of line
				answer  = data.frame(nline = line , 
						error_message = sprintf("dataset <%s>, column <%s>, value <%s> is wrong, only numeric between 0 and 100 or NP is possible", 
								namedataset,
								column,
								value))
			}
	}
	return(answer)
}


check_duplicate_rates <- function(dataset, namedataset){
	
	dupl <- dataset[,c("eel_typ_name", "eel_year", "eel_emu_nameshort")]
	value <- dupl[duplicated(dupl),]
	
	if(nrow(value) > 0){
		cat(sprintf("dataset <%s>, line <%s>, value <%s> is duplicated, only one value per type, year and EMU is possible \n", 
						namedataset,
						str_c(as.numeric(rownames(value)),collapse=";"),
						str_c(paste(value$eel_typ_name, value$eel_year, value$eel_emu_nameshort, sep=","),collapse="|")))
		# same but split and no end of line
		answer  = data.frame(nline = as.numeric(rownames(value)), 
				error_message = sprintf("dataset <%s>, value <%s> is duplicated, only one value per type, year and EMU is possible", 
						namedataset,
						paste(value$eel_typ_name, value$eel_year, value$eel_emu_nameshort, sep=",")))
	}
}

