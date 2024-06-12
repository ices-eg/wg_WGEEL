# draw the eel precautionary diagram
# 
# Author: cedric.briand
###############################################################################



#' @title Draw background of the precautionary diagram
background<-function(Aminimum=0,Amaximum=6.5,Bminimum=1e-2,Bmaximum=1){
  # the left of the graph is filled with polygons
  Bminimum<<-Bminimum
  Bmaximum<<-Bmaximum
  Amaximum<<-Amaximum
  Aminimum<<-Aminimum
  B<-seq(Bminimum,0.4, length.out=30)
  Alim<-0.92
  Btrigger=0.4
  SumA<-Alim*(B/Btrigger) # linear decrease in proportion to B/Btrigger
  X<-c(B,rev(B))
  Ylowersquare<-c(SumA,rep(Aminimum,length(B)))
  df<-data.frame("B"=X,"SumA"=Ylowersquare,"color"="orange")
  Yuppersquare<-c(SumA,rep(Amaximum,length(B)))
  df<-rbind(df, data.frame("B"=X,"SumA"=Yuppersquare,"color"="red"))
  df<-rbind(df,data.frame("B"=c(0.4,0.4,Bmaximum,Bmaximum),"SumA"=c(Aminimum,0.94,0.94,Aminimum),"color"="green")) # drawn clockwise from low left corner
  df<-rbind(df,data.frame("B"=c(0.4,0.4,Bmaximum,Bmaximum),"SumA"=c(0.94,Amaximum,Amaximum,0.94),"color"="orange1")) # drawn clockwise from low left corner
  return(df)
}


#' @title translate a message
#'
#' @param id the id of the message
#' @param message a tibble with id, and a column per language
#' @param language choose your translation two letters coded "en" or "fr"
#' @return the message (a string)
#' @examples
#' translate_message(id_msg = "title for country", language = "fr")
translate_message <- function(
  id_msg,
  message = message_preco_diagram,
  language = "en"
) {

  if (language %in% colnames(message)) {
    msg <- message |>
      dplyr::filter(id == id_msg) |>
      dplyr::select(all_of(language)) |>
    pull()
  } else {
    msg <- NA
  }

  if (length(msg) == 0 || is.na(msg)) {
    msg <- id_msg
  }

  return(msg)
}

# msg for internationalization
message_preco_diagram <- tibble::tibble(
  id = "title general", en = "Precautionary diagram",
  fr = "Diagramme de précaution"
) |>
  tibble::add_row(
    id = "title for emu", en = "Precautionary diagram for EMU",
    fr = "Diagramme de précaution pour les UGA"
  ) |>
  tibble::add_row(
    id = "title for country", en = "Precautionary diagram for country",
    fr = "Diagramme de précaution pour les pays"
  ) |>
  tibble::add_row(
    id = "title for all countries",
    en = "Precautionary diagram for all countries",
    fr = "Diagramme de précaution pour tous les pays"
  ) |>
  tibble::add_row(
    id = "Spawner escapement",
    en = "Spawner escapement",
    fr = "Échappement"
  ) |>
  tibble::add_row(
    id = "Lifetime mortality",
    en = "Lifetime mortality",
    fr = "Mortalité cumulée"
  ) |>
  tibble::add_row(
    id = "tons",
    en = "tons",
    fr = "tonnes"
  ) |>
  tibble::add_row(
    id = "eel_year",
    en = "Year",
    fr = "Années"
  ) |>
  tibble::add_row(
    id = "aggreg_level",
    en = "Aggregation level",
    fr = "Niveau d'aggrégation"
  ) |>
  tibble::add_row(
    id = "emu",
    en = "EMU",
    fr = "UGA"
  ) |>
  tibble::add_row(
    id = "country",
    en = "Country",
    fr = "Pays"
  )

#' @title Draw precautionary diagram itself
#' @param precodata data.frame with column being: eel_emu_nameshort	bcurrent	bbest	b0	suma, using extract_data("precodata")
#' @param adjusted_b0 should adjusted_b0 following WKEMP2021 be used?
#' @param bbest_unit the unit to be displayed in the graph.
#' @param translation the msg for translation of title, ...
#' @param language choose your translation two letters coded "en" or "fr"
#' @param additional_title any additional information you want to add
#' after to standard title (in markdown format)
#' @examples
#' x11()
#' trace_precodiag( extract_data("precodata"))
# TODO: offer the possibility to aggregate by country
trace_precodiag <- function(
  precodata,
  precodata_choice = c("emu", "country", "all"),
  last_year = TRUE,
  adjusted_b0 = FALSE,
  bbest_unit = "tons",
  translation = message_preco_diagram,
  language = "en",
  additional_title = ""
) {
  ###############################
  # Data selection
  # this in done on precodata which is filtered by the app using filter_data
  #############################
  precodata$last_year[is.na(precodata$last_year)] <- precodata$eel_year[is.na(precodata$last_year)]
  if (last_year) {
    precodata <- precodata[precodata$last_year == precodata$eel_year,]
  }

  if (length(precodata_choice) > 1) {
    title <- translate_message(id = "title general", language = language)
  } else {
    title <- dplyr::case_match(
      precodata_choice,
      "emu" ~ translate_message(
        id_msg = "title for emu",
        language = language
      ),
      "country" ~ translate_message(
        id_msg = "title for country",
        language = language
      ),
      "all" ~ translate_message(
        id_msg = "title for all countries",
        language = language
      )
    )
  }

  title <- paste(title, additional_title)

  precodata <- precodata |>
    dplyr::filter(aggreg_level %in% precodata_choice)

  ############################
  # Data for buble plot
  ############################
  mylimits <- c(0, 1000)
  precodata$pSpR <- exp(-precodata$suma)
  precodata$pbiom <- precodata$ratio_bcurrent_b0
  if (
    length(precodata_choice) == 1 &&
      adjusted_b0 &&
      precodata_choice == "emu"
  ) {
    precodata$pbiom <- precodata$bcurrent / mapply(
      estimate_adjusted_b0, precodata$eel_emu_nameshort, precodata$eel_year,
      MoreArgs = list(precodata = precodata)
    )
  }
  if (any(precodata$bcurrent > precodata$b0, na.rm = TRUE)) {
    cat("You  have Bbest larger than B0, you should check \n")
    Bmaximum <- max(precodata$pbiom, na.rm = TRUE)
  } else {
    Bmaximum <- 1
  }
  if (any(is.na(precodata$b0))) {
    cat("Be careful, at least some B0 are missing")
  }
  if (max(precodata$bbest, na.rm = TRUE) > mylimits[2]) {
    mylimits[2] <- max(precodata$bbest, na.rm = TRUE)
  }
  if (
    all(is.na(precodata$pbiom)) ||
      all(is.na(precodata$pSpR))
  ) {
    errortext <- "Missing data"
  } else {
    errortext <- ""
  }

  df <- background(
    Aminimum = 0,
    Amaximum = max(5, pretty(max(precodata$suma))[2]),
    Bminimum = min(exp(-5), pretty(min(precodata$bcurrent))[1]),
    Bmaximum = Bmaximum
  )

  ######################
  # Drawing the graphs
  ############################
  # If EMU only show labels
  choose_color <- ifelse(length(precodata_choice) == 1,
    "eel_year",
    "aggreg_level"
  )
  precodata$eel_year <- as.factor(precodata$eel_year)
  g <- ggplot(df) +
    theme_bw() +
    theme(
      legend.key = element_rect(colour = "white"),
      legend.title = ggtext::element_markdown(),
      axis.title = ggtext::element_markdown(),
      title = ggtext::element_markdown()
    ) +
    geom_polygon(
      aes(x = B, y = SumA, fill = color),
      alpha = 0.7
    ) +
    scale_fill_identity(labels = NULL) +
    scale_x_continuous(
      name = paste0(
        "**",
        translate_message(
          id_msg = "Spawner escapement",
          language = language
        ),
        "** B~current~ / B~0~"
      ),
      limits = c(Bminimum, Bmaximum),
      trans = "log10",
      breaks = c(0.005, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1),
      labels = c("", "1%", "5%", "10%", "", "", "40%", "", "", "", "", "", "100%")
    ) +
    scale_y_continuous(
      name = paste0(
        "**",
        translate_message(
          id_msg = "Lifetime mortality",
          language = language
        ),
        "** &Sigma;A"
      ),
      limits = c(Aminimum, Amaximum)
    ) +
    geom_point(
      data = precodata,
      aes(x = pbiom, y = suma, size = bbest, color = .data[[choose_color]]),
      alpha = 0.7
    ) +
    geom_text_repel(
      data = precodata,
      aes(
        x = pbiom,
        y = suma,
        label = paste(aggreg_area, substr(eel_year, 3, 4), sep = "")
      ),
      size = 3,
      min.segment.length = 0,
      seed = 52,
      max.overlaps = Inf,
      box.padding = 0.3,
      point.padding = 0.3,
      force = 30,
      arrow = arrow(length = unit(0.010, "npc")),
      nudge_x = .15,
      nudge_y = .5,
      fontface = 'bold',
      color = 'black',
      segment.colour = "#4d4d4d",
      segment.alpha = 0.6,
      segment.linetype = 1,
      show.legend = FALSE
    ) +
    scale_size(
      name = paste0(
        "B~best~(",
        translate_message(
          id_msg = bbest_unit,
          language = language
        ),
        ")"
      ),
      range = c(2, 25),
      limits = c(0, max(pretty(precodata$bbest)))
    ) +
    annotate(
      "text",
      x = 1, y = 0.92,
      label = c("0.92", "Alim"),
      parse = FALSE,
      hjust = 1, vjust = c(-1.1, 1.1),
      size = 3
    ) +
    annotate(
      "text",
      x = 0.4, y = 0,
      label = c("Blim", "Btrigger"),
      parse = FALSE,
      hjust = 0, vjust = c(-0.7, 1.1),
      size = 3,
      angle = 90
    ) +
    annotate(
      "text",
      x = Bminimum, y = c(0, 1.2, 1.6, 2.3, 2.99, 4.6),
      label = c("100% -", "30% -", "20% -", "10% -", "5% -", "1% -"),
      parse = FALSE,
      hjust = 1,
      size = 3
    ) +
    annotate(
      "text",
      x = Bminimum, y = Amaximum,
      label = "%SPR",
      parse = FALSE,
      hjust = 1, vjust = -3,
      size = 3,
      angle = 90
    ) +
    ggtitle(str_c(title))

  if (choose_color == "eel_year") {
    g <- g + viridis::scale_colour_viridis(
      name = translate_message(
        id_msg = "eel_year",
        language = language
      ),
      discrete = TRUE
    )
  } else {
    g <- g + scale_colour_brewer(
      name = translate_message(
        id_msg = "aggreg_level",
        language = language
      ),
      palette = "Set3", direction = -1,
      labels = c(
        emu = translate_message(
          id_msg = "emu",
          language = language
        ),
        country = translate_message(
          id_msg = "country",
          language = language
        )
      )
    )
  }

  return(g)
}


#' estimate_adjusted_b0
#' this function estimates adjusted b0 based on recruitment model and bbest
#' following WKEMP 2020. The function uses data stored in annex13.Rdata to
#' know whether mortality are estimated computed year wise or cohort wise
#' and therefore to know if shifting recruitment is required
#' @param emu The considered EMU
#' @param year the year of interest
#' @param precodata the precodata
#'
#' @return
#' @export
#'
#' @examples
estimate_adjusted_b0 = function(emu, year, precodata){
  mor_wise = annexes13_method %>%
    filter(!is.na(emu_nameshort)) %>%
    mutate(rec_zone = ifelse(cou_code %in% c("NL","DK","NO","BE","LU", "CZ","SK") |
                               emu_nameshort %in% c("FR_Rhin","FR_Meus","GB_Tham","GB_Angl","GB_Humb","GB_Nort","GB_Solw",
                                                    "DE_Ems","DE_Wese","DE_Elbe","DE_Rhei","DE_Eide","DE_Maas") ,
                             "NS", 
                             ifelse(cou_code %in% c("EE","FI","SE","LV","LT","AX", "PL","DE"),
                                    "BA",
                                    "EE"))) %>%
    select(emu_nameshort,mortality_wise,rec_zone) %>%
    mutate(cohort_wise=grepl("ohort",mortality_wise)) %>%
    mutate(emu_nameshort=ifelse(emu_nameshort=="NL_Neth", "NL_total",emu_nameshort))
  
  if (!emu %in% unique(mor_wise$emu_nameshort))
    return(NA)
  
  mod = switch(unique(mor_wise$rec_zone[mor_wise$emu_nameshort == emu]),
               "EE" = dat_ge %>% filter (area == "Elsewhere Europe"),
               "NS" = dat_ge %>% filter (area == "North Sea"),
               "BA" = dat_ye)
  if ("value_std_1960_1979" %in% names(mod)){
    Rcurrent <- mean(mod$value_std_1960_1979[mod$year %in% ((year-4):year)])
  } else {
    Rcurrent <- mean(mod$p_std_1960_1979[mod$year %in% ((year-4):year)])
  }
  
  
  if (unique(mor_wise$cohort_wise[mor_wise$emu_nameshort==emu]))
    Rcurrent <- switch(mor_wise$rec_zone[mor_wise$emu_nameshort == emu],
                       "EE" = mean(mod$p_std_1960_1979[mod$year %in% ((year-12):(year-7))]),
                       "NS" = mean(mod$p_std_1960_1979[mod$year %in% ((year-17):(year-12))]),
                       "BA" = mean(mod$value_std_1960_1979[mod$year %in% ((year-22):(year-17))]))
  unique(precodata$bbest[precodata$eel_emu_nameshort==emu & precodata$eel_year==year] / Rcurrent)
}
