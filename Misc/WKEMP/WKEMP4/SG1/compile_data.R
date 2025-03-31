##### data for the script is on Ices SP (working documents/SG1) using the same folder structure as specified in this script #####

# List all currently loaded packages, excluding the default ones
default_packages <- c("base", "stats", "graphics", "grDevices", "utils", "datasets", "methods")
loaded_libs <- setdiff(.packages(), default_packages)

# Detach each non-default package
for(lib in loaded_libs) {
  detach(paste("package:", lib, sep=""), character.only = TRUE, unload = TRUE)
}

#load libraries
library(readxl)
library(tidyverse)
library(icesTAF)

# 1. ANNEX 14 ####

# 1.1 read and bind together data call files

#create a list of excel files (separated by first and second data call response)
files_second <- list.files(path = "Misc/WKEMP/WKEMP4/SG1/for_compilation/responses", 
                    pattern = ".xlsx",
                    full.names = TRUE)

files_first <- list.files(path = "Misc/WKEMP/WKEMP4/SG1/for_compilation", 
                        pattern = ".xlsx",
                        full.names = TRUE)



#read measures_2024
measures_2024_first <- map_dfr(files_first, read_xlsx, sheet = "measures_2024") %>% mutate(status = "first_call")
measures_2024_second <- map_dfr(files_second, read_xlsx, sheet = "measures_2024") %>% mutate(status = "second_call")

#extract column names for first 28 columns from "measures_2024_first)
correct_colnames <- names(measures_2024_second)[1:28]

#read measures_2024
measures_2024_new <- map_dfr(files_second, function(file) {
  read_xlsx(file, sheet = "measures_new") %>%
    mutate(status = "second_call_new") %>%
    mutate_all(as.character)
}) 

#rename columns to match other measures tables  
colnames(measures_2024_new) <- correct_colnames 
measures_2024_new <- measures_2024_new %>% rename(status = Value_missing_in)

#combine all in one dataframe
measures_all <- bind_rows(measures_2024_first, measures_2024_second, measures_2024_new)

#read standards
standards <- read_excel("Misc/WKEMP/WKEMP4/SG1/standards.xlsx")

#Merge standards to the whole data
# Rename all columns in 'standards' by adding "std_" prefix
colnames(standards) <- paste0("std_", colnames(standards))

# Join standards to measures all, add column with new id (old one kept, just added dc2021 before) and replace character NAs with true NAs 
measures_all <- measures_all %>%
  left_join(standards, by = c("measure_type" = "std_measure_type", "submeasure_type" = "std_submeasure_type")) %>% 
  mutate(across(where(is.character), ~na_if(., "NA"))) %>%  
  mutate(temp_id = 1:n(),
         new_id = ifelse(!is.na(id), paste("dc2021", id, sep = "_"), paste("dc2024", temp_id, sep = "_"))) %>% 
  select(-id, -temp_id) %>% 
  rename(id = new_id) %>% 
  relocate(id, .before = country)

#get rows where target_value, target_value_achieved or effect_size_monitored is a number
convertible_values_tv <- measures_all$id[!is.na(suppressWarnings(as.numeric(measures_all$target_value)))]
convertible_values_tva <- measures_all$id[!is.na(suppressWarnings(as.numeric(measures_all$target_value_achieved)))]
convertible_values_em <- measures_all$id[!is.na(suppressWarnings(as.numeric(measures_all$estimated_effect_size)))]

#### ADD HERE VECTORS FOR THE THREE COLUMS WHERE THERE IS TEXT WHICH IMPLIES THERE IS A MONITORING/TARGET #####
#measures_all <- measures_all %>% 
  #relocate(target_value, .before = country) %>% 
  #relocate(target_value_achieved, .before = country) %>% 
  #relocate(estimated_effect_size, .before = country)

add_target <- c("dc2021_322", "dc2021_1486","dc2021_472", "dc2021_104")
add_target_achieved <- c("dc2021_320", "dc2021_317", "dc2021_322", "dc2021_324", "dc2021_318", "dc2021_472", "dc2024_1605")
add_effect <- c("dc2021_392", "dc2021_393", "d2021_348", "dc2021_349", "dc2021_350", "dc2021_359", "dc2021_240")



#create columns for target_value, target_value_achieved or effect_size_monitored wherer only the numerics are available
measures_all <- measures_all %>% 
  mutate(target_value_numeric = as.numeric(ifelse(id %in% convertible_values_tv, target_value, NA)),
         target_value_achieved_numeric = as.numeric(ifelse(id %in% convertible_values_tva, target_value_achieved, NA)),
         effect_size_numeric = as.numeric(ifelse(id %in% convertible_values_em, estimated_effect_size, NA)),
         achieved_per = target_value_achieved_numeric/target_value_numeric,
         effect_size_true = ifelse(effectiveness_monitored != "Not monitored" & !is.na(effectiveness_monitored) & !is.na(effect_size_numeric), effectiveness_monitored, "Not monitored"), 
         target_value_numeric = ifelse(id %in% add_target, "yes", target_value_numeric),
         target_value_achieved_numeric = ifelse(id %in% add_target_achieved, "yes", target_value_achieved_numeric),
         effect_size_numeric = ifelse(id %in% add_effect, "yes", effect_size_numeric),
         quantifiable = ifelse(std_quantifiable != "n" & !is.na(std_quantifiable), std_quantifiable,
                               ifelse(!is.na(target_value_numeric), "y", "n")))




# 1.2 do some filtering

#create table with measures to remove from to get "measures_cleaned" and remove those lines
removed_UK_delete <- measures_all %>%
  filter(country == "Great_Britain" | delete == "Yes" | delete == "delete") 

measures_all_cleaned <- anti_join(measures_all, removed_UK_delete)

#create a table with rows that are not EMP or EMP_amended to be removed
removed_non_EMP <- measures_all_cleaned %>%
  filter(!measure_planned %in% c("EMP", "EMP_amended"))

measures_all_cleaned_EMP <- anti_join(measures_all_cleaned, removed_non_EMP)



#create output directory
mkdir("Misc/WKEMP/WKEMP4/SG1/output/")

#save result
save(measures_all, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all.RData")
write.csv2(measures_all, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all.csv", row.names = FALSE)

save(measures_all_cleaned, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_cleaned.RData")
write.csv2(measures_all_cleaned, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_cleaned.csv", row.names = FALSE)

save(measures_all_cleaned_EMP, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_cleaned_EMP.RData")
write.csv2(measures_all_cleaned_EMP, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_cleaned_EMP.csv", row.names = FALSE)

save(removed_UK_delete, file = "Misc/WKEMP/WKEMP4/SG1/output/removed_UK_delete.RData")
write.csv2(removed_UK_delete, file = "Misc/WKEMP/WKEMP4/SG1/output/removed_UK_delete.csv", row.names = FALSE)

save(removed_non_EMP, file = "Misc/WKEMP/WKEMP4/SG1/output/removed_non_EMP.RData")
write.csv2(removed_non_EMP, file = "Misc/WKEMP/WKEMP4/SG1/output/removed_non_EMP.csv", row.names = FALSE)



# 2. ANNEX 17

#get list of files
files_17 <- list.files(path = "Misc/WKEMP/WKEMP4/SG1/for_compilation/annex_17", 
                           pattern = ".xlsx",
                           full.names = TRUE)

#read "measures_2024"Reference List to single dataframe
references_all <- map_dfr(files_17, function(x) {
  # Read the file
  df <- read_xlsx(x, sheet = "Reference List") %>%
    mutate_all(as.character)
  
  # Extract the last two letters before .xlsx
  filename_without_extension <- sub("\\.xlsx$", "", basename(x))  # Remove .xlsx
  last_two_letters <- substr(filename_without_extension, nchar(filename_without_extension) - 1, nchar(filename_without_extension))
  
  # Add the last two letters as a new column
  df <- df %>%
    mutate(country = last_two_letters,
           ...7 = NULL)
  
  return(df)
})

#create readable table for report Annex
removed_delete <- measures_all %>%
  filter(country == "Great_Britain") 

measures_all_short <- anti_join(measures_all, removed_delete)

measures_all_short <- measures_all_cleaned %>% 
  select(-id, -c(32:47))

#create a table only with countries who responded to one of the calls
measures_all_response <- measures_all_cleaned %>% 
  filter(country != "Croatia" & country != "Estonia" & country != "Italy" & country != "Latvia" & country != "Luxembourg" & country != "Slovenia")

length(unique(measures_all_response$emu_name_short))

#save result
save(references_all, file = "Misc/WKEMP/WKEMP4/SG1/output/references_all.RData")
write.csv2(references_all, file = "Misc/WKEMP/WKEMP4/SG1/output/references_all.csv", row.names = FALSE)

#save "nicer" table as RData and csv
save(measures_all_short, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_short.RData")
write.csv2(measures_all_short, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all_short.csv", row.names = FALSE)
