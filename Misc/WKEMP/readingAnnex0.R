library(readxl)
library(dplyr)
library(tidyr)
library(tidyverse)
library(sf)

# ##################################################################
# # if new annex 0 is provided
# # at first, set you working directory to a folder containing all the annexes 0
# provided <- read_xlsx("2024_Eel_Data_Call_Annex_0_Summary_AL.xlsx",2)
# provided$date_of_submission <- as.logical(provided$date_of_submission)  # to avoid issue on column G date is not always reported as a standard date format
#
# files=list.files(".")
#
# for(i in 2 : length(files)){
#   provided <- rbind(provided, read_xlsx(path = paste0("C:/Users/guandre/Documents/WGEEL/Annexes_0/",files[i]),2)) # correct with the link to the folder where all annexes 0 are stored
#   provided
# }
#
# save(provided, file = "readingAnnex0.RData")
# #########################################################################

load("data_dependencies/readingAnnex0.RData")
load("../../R/shiny_data_visualisation/shiny_dv/data/maps_for_shiny.Rdata")


annex0provided <- function(status, annex) {
  if (status %in% c("Yes", "No")) {
    result <- provided |>
      select(annex, country_code, annex_provided, why_not_provided, comment) |>
      filter(annex_provided == status )
  }
  if (status == "NA") {
    result <- provided |>
      select(annex, country_code, annex_provided, why_not_provided, comment) |>
      filter(is.na(annex_provided) )
  }
  result
}

annex0provided("Yes")
annex0provided("No")
annex0provided("NA")


 provided_sel <- provided
 write.csv2(provided_sel, file=file.path(params$data_path, "annex0_answers.csv"))
  provided_sel <- merge(country_p, provided_sel, by.x = "cou_code", by.y = "country_code", all.x = T) |>
    mutate(annex_provided = case_when(
      is.na(annex)
      ~ "No_annex_0",
      TRUE ~ annex_provided
    ))


###########################
# show answering on a map
annex_availability <- function(annex_name) {
  provided_sel <- filter(provided, annex == annex_name)
  provided_sel <- merge(country_p, provided_sel, by.x = "cou_code", by.y = "country_code", all.x = T) |>
    mutate(annex_provided = case_when(
      is.na(annex)
      ~ "No_annex_0",
      TRUE ~ annex_provided
    ))
  provided_sel <- st_transform(provided_sel, crs = 3035)
  provided_sel <- provided_sel |>
    mutate(
      x = map_dbl(geom, ~ st_point_on_surface(.x)[[1]]),
      y = map_dbl(geom, ~ st_point_on_surface(.x)[[2]])
    )

  plot <- ggplot() +
    theme_bw() +
    geom_sf(data = provided_sel, aes(fill = as.factor(annex_provided))) +
    scale_fill_viridis_d(annex_name, labels = c("No", "No_annex_0", "Yes", "NA"))
  plot
}

annex_availability("Annex 10")
annex_availability("Annex 11")

# ### Annex 10
# provided_10 <- filter(provided, annex=="Annex 10")
# write.csv2(provided_10,"C:/Users/guandre/Documents/WGEEL/provided_10.csv")
#
# ### Annex 11
# provided_11 <- filter(provided, annex=="Annex 11")
# write.csv2(provided_11,"C:/Users/guandre/Documents/WGEEL/provided_11.csv")


#####
# show all on one figure

provided_all <- merge(country_p, provided, by.x = "cou_code", by.y = "country_code", all.x = T) |>
  mutate(
    annex_provided = case_when(
      is.na(annex)
      ~ "No_annex_0",
      TRUE ~ annex_provided
    ),
    annex = case_when(
      is.na(annex)
      ~ "No_annex_0",
      TRUE ~ annex
    )
  )
provided_all <- st_transform(provided_all, crs = 3035)
provided_all <- provided_all |>
  mutate(
    x = map_dbl(geom, ~ st_point_on_surface(.x)[[1]]),
    y = map_dbl(geom, ~ st_point_on_surface(.x)[[2]])
  )

ggplot(st_transform(country_p, crs = 3035)) +
  geom_sf(fill = NA) +
  theme_bw() +
  geom_sf(data = provided_all, aes(fill = as.factor(annex_provided))) +
  scale_fill_viridis_d("annex_provided", labels = c("No", "No_annex_0", "Yes", "NA")) +
  facet_wrap(~annex)


# # restriction to the CIEM annexes
# provided_all_ciem <- filter(provided_all, annex %in% c("Annex 1","Annex 2","Annex 3","Annex 4","Annex 5",
#                                                        "Annex 6","Annex 7","Annex 8","Annex 9", "No_annex_0"))
#
# ggplot(st_transform(country_p,crs=3035)) + geom_sf(fill=NA)+theme_bw()+
#   geom_sf(data=provided_all_ciem,aes(fill=as.factor(annex_provided)))+
#   scale_fill_viridis_d("annex_provided",labels=c("No","No_annex_0","Yes","NA"))+
#   facet_wrap(~annex)


# map of no annex 0 provided
ggplot(st_transform(country_p, crs = 3035)) +
  geom_sf(fill = NA) +
  theme_bw() +
  geom_sf(data = filter(provided_all, annex_provided == "No_annex_0"), aes(fill = as.factor(annex_provided))) +
  scale_fill_viridis_d("annex_0_provided", labels = c("No", "No_annex_0", "Yes", "NA")) +
  facet_wrap(~annex)

list_annex0_missing <- filter(provided_all, annex_provided == "No_annex_0")
