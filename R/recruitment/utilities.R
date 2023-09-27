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


#' plot_trend_model
#' makes a ggplot of time-trend of a model
#' @param predtable the table of prediction, should have a column year, a column
#' vargroup and column p_std, p_std_in and p_std_max
#' @param vargroup the variable that separate lines (default site), potentially 
#' a vector
#' @param xlab xaxis title
#' @param ylab yaxis title
#' @param palette the colors to be used, if NULL (default) standard ggplot
#' colors will be used
#' @param logscale should a logscale y be used for y axis(default FALSE) 
#' @param ... other option send to theme
#' @return a ggplot
#' @export
#'
#' @examples

plot_trend_model <- function(predtable, 
                             vargroup = "site",
                             xlab = "", 
                             ylab = "",
                             palette = NULL,
                             logscale = FALSE,
                             ...){
  if (!is.null(vargroup)){
    if (length(vargroup) > 1){
      predtable$group <- interaction(predtable[vargroup],
                                     sep = ":")
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std,
                      col = group,
                      fill = group)) 
    } else {
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std, 
                      col = .data[[vargroup]], 
                      fill = .data[[vargroup]])) 
    }
  } else {
    p <- ggplot(predtable, aes(x = year, y = p_std))
  }
  p <- p + 
    geom_line() +
    geom_ribbon(aes(ymin = p_std_min, ymax = p_std_max), alpha = .3)
  if (logscale)
    p <- p + scale_y_log10()
  if (!is.null(palette))
    p <- p + 
    scale_fill_manual(values = palette) + 
    scale_color_manual(values = palette)
  p <- p + xlab(xlab) + ylab(ylab) +theme(...) + labs(fill = "", col = "")
  p
}
