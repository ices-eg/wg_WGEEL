#' @title Trend prediction
#' @description Predict the trends from a MARSS model
#' @param model the MARSS model
#' @param type_prediction type of prediction. See predict.marssMLE
#' @param years a vector giving the years analysed
#' @return a data.frame
predict_MARSS <- function(
    model,
    type_prediction = "xtT",
    years = Years
) {
    Xt <- predict(
        model,
        type = type_prediction,
        interval = "confidence"
    )
    Xt <- Xt$pred
    Xt$t <- years # add data on years
    Xt <- Xt %>%
        dplyr::rename(
            Year = t,
            categorie = .rownames,
            trend = estimate
        )

    return(Xt)
}

#' @title Trend plot
#' @description Plot the trends from a MARSS model
#' @param prediction the prediction from a MARSS model (see predict_MARSS)
#' @param color_variable the variable to be used for color
#' @param nb_col number of column in the facet
#' @return a ggplot
plot_MARSS <- function(
    prediction,
    color_variable,
    nb_col = NULL
) {
    if (is.null(nb_col)) {
        nb_facet <- length(unique(Xt$categorie))
        nb_col <- ifelse(nb_facet > 3, nb_facet / 2, nb_facet)
    }

    g <- ggplot2::ggplot(
    prediction,
    ggplot2::aes(
        y = trend,
        x = Year,
        color = !!as.symbol(color_variable)
    )
) +
    ggplot2::geom_line() +
    ggplot2::geom_line(
        aes(y = `Lo 95`),
        linetype = "dashed"
    ) +
    ggplot2::geom_line(
        ggplot2::aes(y = `Hi 95`),
        linetype = "dashed"
    ) +
    ggplot2::facet_wrap(
        ggplot2::vars(categorie),
        ncol = nb_col
    ) +
    ggplot2::theme_bw()

    return(g)
}
