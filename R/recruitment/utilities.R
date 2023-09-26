#' predict_model
#' makes prediction using the fitted model
#' @param modelname the name of the object containing the model
#' @param reference reference period for standardization
#' @return a table with prediction
#' @export
#'
#' @examples
predict_model <- function(modelname, reference = 1960:1979){
  mymodel <- get(modelname)
  
  #we build the prediction grid
  newdata <- expand.grid(mymodel$xlevels)
  
  #we only predict for reference site
  if ("site" %in% names(newdata))
    newdata <- newdata %>%
    dplyr::filter(site==mymodel$xlevels$site[1]) %>%
    mutate(year = as.numeric(as.character(year_f)))
  
  newdata$p=predict(mymodel ,newdata = newdata)
  newdata$se=predict(mymodel, newdata = newdata, se.fit=TRUE)[["se.fit"]]
  
  #rescale by reference period
  newdata <- newdata %>%
    group_by(area) %>%
    mutate(mean_ref = mean(ifelse(year %in% reference, p, NA), #compute mean over the reference period
                           na.rm = TRUE)) %>%
    mutate(p_std = exp(p - mean_ref),
           p_std_min = exp(p - mean_ref - 1.96 * se),
           p_std_max = exp(p - mean_ref + 1.96 * se))
  newdata
  
}
