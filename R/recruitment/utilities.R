#' predict_model
#' makes prediction using the fitted model
#' @param mymodel the name of the object containing the model
#' @param reference reference period for standardization
#' @param vargroup grouping variable (default area), null if no gouping
#' @return a table with prediction
#' @export
#'
#' @examples
predict_model <- function(mymodel, reference = 1960:1979, vargroup = "area"){
  #we build the prediction grid
  lookup <- c(site = "as.factor(site)")
  newdata <- expand.grid(mymodel$xlevels) %>%
    rename(any_of(lookup))
  
  names(mymodel$xlevels) <- ifelse(names(mymodel$xlevels) == "as.factor(site)",
                                   "site",
                                   names(mymodel$xlevels))
  
  #we only predict for reference site
  if ("site" %in% names(newdata))
    newdata <- newdata %>%
    dplyr::filter(site==mymodel$xlevels$site[1]) %>%
    mutate(year = as.numeric(as.character(year_f)))
  
  newdata$p=predict(mymodel ,newdata = newdata)
  newdata$se=predict(mymodel, newdata = newdata, se.fit=TRUE)[["se.fit"]]
  
  #rescale by reference period
  if (is.null(vargroup)){
    newdata <- newdata %>%
    mutate(customgroup = "1")
    vargroup = "customgroup"
  }
  newdata <- newdata %>%
    group_by(!!sym(vargroup)) %>%
    mutate(mean_ref = mean(ifelse(year %in% reference, p, NA), #compute mean over the reference period
                           na.rm = TRUE)) %>%
    mutate(p_std = exp(p - mean_ref),
           p_std_min = exp(p - mean_ref - 1.96 * se),
           p_std_max = exp(p - mean_ref + 1.96 * se)) %>%
    ungroup() %>%
    dplyr::select(-any_of("customgroup"))
  newdata
  
}


#' plot_trend_model
#' makes a ggplot of time-trend of a model
#' @param predtable the table of prediction, should have a column year, a column
#' vargroup and column p_std, p_std_in and p_std_max
#' @param vargroup the variable that separate lines (default area), potentially 
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
                             vargroup = "area",
                             xlab = "", 
                             ylab = "",
                             palette = NULL,
                             logscale = FALSE,
                             ...){
  showlegend <- !is.null(vargroup) #we do not display legend if no grouping
  if (!is.null(vargroup)){
    if (length(vargroup) > 1){
      predtable$group <- interaction(predtable[vargroup],
                                     sep = ":")
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std)) 
      vargroup <- "group"
    } else {
      p <- ggplot(predtable,
                  aes(x = year,
                      y = p_std) )
    }
  } else {
    predtable$group <- "1"
    vargroup <- "group"
    p <- ggplot(predtable, aes(x = year, y = p_std))
  }
  p <- p + 
    geom_line(aes(col = !!sym(vargroup)), show.legend = showlegend) +
    geom_ribbon(aes(ymin = p_std_min,
                    ymax = p_std_max,
                    fill = !!sym(vargroup)),
                alpha = .3,
                show.legend = showlegend)
  if (logscale)
    p <- p + scale_y_log10()
  if (!is.null(palette))
    p <- p + 
    scale_fill_manual(values = palette) + 
    scale_color_manual(values = palette)
  p <- p + xlab(xlab) + ylab(ylab) +theme(...) + labs(fill = "", col = "")
  p + theme_bw() + theme(...)
}
