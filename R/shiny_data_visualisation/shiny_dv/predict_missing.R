# Name : predict_missing.R
# Date : Date
# Author: cedric.briand
###############################################################################


# predict_missing_values ----------------------------------------------------------------------------

#TODO swith to gam for years.... issue #40
#' @title Predict missing values for landings
#' @description Use simple glm with factors year and countries to make predictions
#' @param landings The dataset of landings
#' @return Landings with missing values filled with predictions
#' @details Use a loop not very efficient
#' @examples 
#' \dontrun{
#' landings <-group_data(filtered_data,geo="country",habitat=FALSE,lfs=FALSE)
#' landings$eel_value <- as.numeric(landings$eel_value) / 1000
#' landings$eel_cou_code = as.factor(landings$eel_cou_code)                       
#' pred_landings <- predict_missing_values(landings, verbose=TRUE) 
#' }
#' @rdname predict_missing_values
#' @export 
predict_missing_values <- function(landings, verbose=FALSE, na.rm=FALSE){
  landings <-as.data.frame(landings)
  landings <- na.omit(landings)
  landings$lvalue<-log(landings$eel_value+0.001) #introduce +0.001 to use 0 data
  landings$eel_year<-as.factor(landings$eel_year)
  landings$eel_cou_code <- as.factor(as.character(landings$eel_cou_code))
  glm_la<-glm(lvalue~ eel_year + eel_cou_code, data=landings )
  if (verbose)  print(summary(glm_la)) # check fit
  landings2<-expand.grid("eel_year"=glm_la$xlevels$eel_year,"eel_cou_code"=glm_la$xlevels$eel_cou_code)
  landings2$pred=predict(glm_la,newdat=landings2,type="response")
  # BELOW WE REPLACE MISSING VALUES BY THE PREDICTED MODELLED
  value_to_test = numeric(0)
  
  for (y in unique(landings$eel_year)){
    for (c in levels(landings$eel_cou_code)){
      if (identical(landings[landings$eel_year==y&landings$eel_cou_code==c,"eel_value"],value_to_test)){ 
        # no data ==> replace by predicted
        landings2[landings2$eel_year == y & landings2$eel_cou_code == c,"eel_value"]<-round(exp(landings2[landings2$eel_year==y&landings2$eel_cou_code==c,"pred"]))
        landings2[landings2$eel_year == y & landings2$eel_cou_code == c,"predicted"]<-TRUE
      } else {
        # use actual value
        
        landings2[landings2$eel_year == y & landings2$eel_cou_code == c,"eel_value"]<-round(landings[landings$eel_year==y&landings$eel_cou_code==c,"eel_value"])
        landings2[landings2$eel_year == y & landings2$eel_cou_code == c,"predicted"]<-FALSE
      }
    }
  }
  landings2$eel_year<-as.numeric(as.character(landings2$eel_year))  
  return(landings2)  
}

