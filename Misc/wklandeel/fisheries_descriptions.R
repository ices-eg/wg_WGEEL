
#########################################################
### script to rbind all fisheries description answers ###
#########################################################





#-----------------------------------------------------------------------------------#

#### 1. Preparations ####

##### 1.1 load libraries #####

### define libraries needed 
libs <- c("tidyverse", "readxl", "ggplot2", "ggforce") #RPostgres may need to be installed manually 

### define libraries already installed
installed_libs <- libs %in% rownames(installed.packages())

### install libraries that are not installed already
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

### load libraries needed
invisible(lapply(libs, library, character.only = T))

#-------------------------#



#### 1.2 define paths ####

### path definitions
italy <- "C:/Users/pohlmann/Desktop/WKLANDEEL/data_call/fisheries description - IT_may_13.xlsx"
dc_folder <- "C:/Users/pohlmann/Desktop/WKLANDEEL/data_call"
catchdata <- "C:/Users/pohlmann/Desktop/WKLANDEEL/merged_data.RData"

#-----------------------------------------------------------------------------------#





#### 2. Read data ####

#### 2.1 Create an empty global data frame to write all the input to ####

### create df with all relevant columns
fisheries_descriptions <- data.frame(country = as.character(),
                                     emu = as.character(),
                                     stage = as.character(),
                                     com_rec = as.character(),
                                     ISSCFG = as.numeric(),
                                     gear_name = as.character())

### create a dataframe with all relevant years
years <- seq(from = 1946, to = 2024)
year_columns <- as.data.frame(matrix(NA, ncol=length(years)))
year_columns <- year_columns[-c(1), ]
colnames(year_columns) <- years

### join year columns to fisheries descriptions
fisheries_descriptions <- cbind(fisheries_descriptions, year_columns)

#-------------------------#



#### 2.2 For countries that provided EMUs in differwent tabs in one file (only IT), read tabs separately and add to global df ####

### create a list of EMU tabs in italian submission
tabs <- excel_sheets(italy)
tabs <- tabs[grepl("IT", tabs)]

### read each sheet from italian call and rbind to fisheries descriptions


for (i in 1:length(tabs)){
  
temp <- read_excel(italy, sheet = tabs[i]) %>% mutate(emu = tabs[i]) %>% rename(com_rec = "com/rec", gear_name = "gear name")
fisheries_descriptions <- rbind(fisheries_descriptions, temp)  
  
print(i) 

}
  
#-------------------------#



#### 2.3 For countries that provided one file per EMU (containing a single tab with data), read files separately and add to global df ####

### create list of all relevant files
files <- list.files(dc_folder, pattern = "description", full.names = T)
files <- files[!grepl("IT", files)]

### read the respective sheet from each file and rbind to fisheries_descriptions
for (i in 1:length(files)){
  
  temp <- read_excel(files[i], sheet = "Fisheries description") %>% rename(com_rec = "com/rec", gear_name = "gear name")
  fisheries_descriptions <- rbind(fisheries_descriptions, temp)  
  
  print(i) 
  
}

### save global df to RData
save(fisheries_descriptions, file = "./Misc/wklandeel/fd_full.RData")

#-----------------------------------------------------------------------------------#





#### 3. Create summary ####

# Convert data fra,me to long data
fd_long <- gather(fisheries_descriptions, year, value, 7:ncol(fisheries_descriptions)) %>% 
  filter(gear_name != "Total") %>% 
  mutate(year = as.integer(year),
         availability = ifelse(value == "NA", "no_information",
                               ifelse(value == "Y" | value == "y", "no_quantity", "quantified"))) 

# create summary
fd_summary <- fd_long %>% 
  filter(value != "NA") %>% 
  group_by(emu, com_rec, stage) %>% 
  summarize(min_year_total=min(year),
            max_year_total=max(year))

# create a data frame ex
fd_with_value <- fd_long %>% 
  filter(value != "NA") %>%
  filter(value != "Y"& value != "y") %>%
  group_by(emu, com_rec, stage) %>% 
  summarize(min_year_value=min(year),
            max_year_vlaue=max(year))

# add columns with max/min year where a value exists to fd_summary
fd_summary <- fd_summary %>% 
  left_join(fd_with_value, by = c("emu", "com_rec", "stage"))

# save summary to RData
save(fd_summary, file = "./Misc/wklandeel/fd_summary.RData")

#-----------------------------------------------------------------------------------#





#### 4. Visualization ####

#### 4.1 visualize data availability by year ####

# create a summary of data availability by year (reported only)
fd_bar_year <- fd_long %>% 
  group_by(year, com_rec, stage) %>% 
  summarize(quantified = length(value[which(availability == "quantified")]),
            no_quantity = length(value[which(availability == "no_quantity")]),
            no_information = length(value[which(availability == "no_information")])) 
  
fd_bar_year <- gather(fd_bar_year, availability, value, 4:ncol(fd_bar_year))

# create graphs for commercial fisheries
com_by_year <- ggplot(data = fd_bar_year %>% filter(com_rec == "commercial"), aes(x=year, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("commercial by year")
com_by_year

# create graphs for recreational fisheries
rec_by_year <- ggplot(data = fd_bar_year %>% filter(com_rec == "recreational"), aes(x=year, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("recreational by year")
rec_by_year

#-------------------------#



#### 4.2 visualize data availability by EMU ####

# create a summary of data availability by emu (reported only)
fd_bar_emu <- fd_long %>% 
  group_by(emu, com_rec, stage) %>% 
  summarize(quantified = length(value[which(availability == "quantified")]),
            no_quantity = length(value[which(availability == "no_quantity")]),
            no_information = length(value[which(availability == "no_information")]))  
  
fd_bar_emu <- gather(fd_bar_emu, availability, value, 4:ncol(fd_bar_emu))

# create graphs for commercial fisheries
com_by_emu <- ggplot(data = fd_bar_emu %>% filter(com_rec == "commercial"), aes(x=emu, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("commercial_by_emu") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
com_by_emu

# create graphs for recreational fisheries
rec_by_emu <- ggplot(data = fd_bar_emu %>% filter(com_rec == "recreational"), aes(x=emu, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("recreational_by_emu") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
rec_by_emu

#-------------------------#



#### 4.3 visualize data availability by gear ####

# create a summary of data availability by emu (reported only)
fd_bar_gear <- fd_long %>% 
  group_by(gear_name, com_rec, stage) %>% 
  summarize(quantified = length(value[which(availability == "quantified")]),
            no_quantity = length(value[which(availability == "no_quantity")]),
            no_information = length(value[which(availability == "no_information")]))  

fd_bar_gear <- gather(fd_bar_gear, availability, value, 4:ncol(fd_bar_gear))

# create graphs for commercial fisheries
com_by_gear <- ggplot(data = fd_bar_gear %>% filter(com_rec == "commercial"), aes(x=gear_name, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("commercial_by_gear") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
com_by_gear

# create graphs for recreational fisheries
rec_by_gear <- ggplot(data = fd_bar_gear %>% filter(com_rec == "recreational"), aes(x=gear_name, y=value, fill = availability)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_wrap(~stage) +
  theme_bw() +
  ggtitle("recreational_by_gear") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
rec_by_gear

#-------------------------#

#### 4.4 Compare landings with reported uncertainties (as of 05-14-2024)

# load catch data
load(catchdata)

# define a function to test if string contains numbers only
numbers_only <- function(x) !grepl("\\D", x)

# list emus that reported a value for commercial and recreational
fd_com_quant <- fd_long %>% filter(availability == "quantified" & com_rec == "commercial") %>% 
  mutate(min_landings = as.numeric(ifelse(numbers_only(value), value, sub(">.*", "", value))),
         max_landings = as.numeric(ifelse(numbers_only(value), value, sub(".*>", "", value)))) %>% 
  group_by(country, emu, stage, year) %>% 
  summarize(min_landings = sum(min_landings),
            max_landings = sum(max_landings))
emus_com <- unique(fd_com_quant$emu)

fd_rec_quant <- fd_long %>% filter(availability == "quantified" & com_rec == "recreational") %>% 
  mutate(min_landings = as.numeric(ifelse(numbers_only(value), value, sub(">.*", "", value))),
         max_landings = as.numeric(ifelse(numbers_only(value), value, sub(".*>", "", value)))) %>% 
  group_by(country, emu, stage, year) %>% 
  summarize(min_landings = sum(min_landings),
            max_landings = sum(max_landings)) 
emus_rec <- unique(fd_rec_quant$emu)

# reduce landings data from db to emus that were reported with a quantity during WKLANDEEL
com_land <- commercial %>% filter(eel_emu_nameshort %in% emus_com) %>% select(eel_lfs_code, eel_year, eel_emu_nameshort, eel_value.db)
rec_land <- recreational %>% filter(eel_emu_nameshort %in% emus_com) %>% select(eel_lfs_code, eel_year, eel_emu_nameshort, eel_value.db)

# add margins to landings data
com_land <- com_land %>% 
  left_join(fd_com_quant %>% select(country, emu, year, stage, min_landings, max_landings), by = c("eel_lfs_code" = "stage", "eel_emu_nameshort" = "emu", "eel_year" = "year")) %>% 
  mutate(difference = abs(max_landings-min_landings),
         min_landings_min = eel_value.db-(difference/2),
         min_landings_max = eel_value.db+(difference/2),
         min_landings_cor = min_landings*(eel_value.db/((abs(max_landings+min_landings))/2)),
         max_landings_cor = max_landings*(eel_value.db/((abs(max_landings+min_landings))/2)),
         difference_cor = abs(max_landings_cor - min_landings_cor)) %>% 
           filter(!is.na(eel_value.db) & !is.na(min_landings) & !is.na(max_landings))

rec_land <- rec_land %>% 
  left_join(fd_rec_quant %>% select(country, emu, year, stage, min_landings, max_landings), by = c("eel_lfs_code" = "stage", "eel_emu_nameshort" = "emu", "eel_year" = "year")) %>% 
  mutate(difference = abs(max_landings-min_landings),
         min_landings_min = eel_value.db-(difference/2),
         min_landings_max = eel_value.db+(difference/2),
         min_landings_cor = min_landings*(eel_value.db/((abs(max_landings+min_landings))/2)),
         max_landings_cor = max_landings*(eel_value.db/((abs(max_landings+min_landings))/2)))

# create graphs of EMUs with uncertainties for commercial fisheries (not relevant for rec since no known uncertainties reported)
 com_land_comp <- function(x) {
  ggplot(com_land %>% filter(eel_lfs_code == x), aes(x=eel_year, y=eel_value.db)) +
  geom_line() +
  geom_line(aes(x=eel_year, y=min_landings_cor), color = "red") +
  geom_line(aes(x=eel_year, y=max_landings_cor), color = "red") +
  theme_bw() +
  facet_wrap(~eel_emu_nameshort) +
  ggtitle(x)
}

lapply(c("G", "Y", "S", "YS"), com_land_comp)

# create a summarized uncertainty over all reported EMUs per year
com_unc <- com_land %>% 
  group_by(eel_year, eel_lfs_code) %>% 
  summarize(uncertainty = sum(difference, na.rm=TRUE))
  
rec_unc <- rec_land %>% 
  group_by(eel_year, eel_lfs_code) %>% 
  summarize(uncertainty = sum(difference, na.rm=TRUE))

# create graph of uncertainty margins over time (total commercial, not relevant for rec since no known uncertainties reported)
unc_plot_com <- ggplot(com_unc %>% filter(uncertainty != 0), aes(x = eel_year, y = uncertainty)) +
  geom_line() +
  theme_bw() +
  facet_wrap(~eel_lfs_code) +
  ggtitle("Known minimum uncertainty commercial")
unc_plot_com


# Code to loop graph creation (multiple pages with 2x2 facet wrap)

# create graphs of EMUs with uncertainties for commercial fisheries (no differences in rec, so not created)
# com_land_comp <- function(x) {
#  ggplot(com_land, aes(x=eel_year, y=eel_value.db)) +
#  geom_line() +
#  geom_line(aes(x=eel_year, y=min_landings_cor), color = "red") +
#  geom_line(aes(x=eel_year, y=max_landings_cor), color = "red") +
#  theme_bw() +
#  facet_wrap_paginate(~eel_emu_nameshort, ncol = 2, nrow = 2, page = x) #from ggforce
#}
#
#lapply(1:5, com_land_comp)

