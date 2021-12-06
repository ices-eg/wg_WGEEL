
mor_wise = annexes13_method %>% select(emu_nameshort,mortality_wise)
mor_wise = merge(emu_sea %>% st_drop_geometry(),mor_wise)
mor_wise <- mor_wise %>% mutate(cohort_wise=grepl("ohort",mortality_wise))
load("../../R/shiny_data_visualisation/shiny_dv/data/recruitment/dat_ge.Rdata")
load("../../R/shiny_data_visualisation/shiny_dv/data/recruitment/dat_ye.Rdata")



estimate_b0 = function(emu, year, mor_wise,precodata){
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
    Rcurrent <- switch(mor_wise$rec_zone[mor_wise$emu_nameshort == emu],,
                       "EE" = mean(mod$p_std_1960_1979[mod$year %in% ((year-12):(year-7))]),
                       "NS" = mean(mod$p_std_1960_1979[mod$year %in% ((year-17):(year-12))]),
                       "BA" = mean(mod$value_std_1960_1979[mod$year %in% ((year-22):(year-17))]))
  precodata$bbest[precodata$eel_emu_nameshort==emu & precodata$eel_year==year] / Rcurrent
}

indicator_sub <- indicator %>%
  filter(eel_emu_nameshort %in% unique(mor_wise$emu_nameshort))
indicator_sub$b0_estimated = mapply(estimate_b0,indicator_sub$eel_emu_nameshort, indicator_sub$eel_year,
                                MoreArgs=list(mor_wise=mor_wise,precodata=indicator_sub))
