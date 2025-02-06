##### data for the script is on Ices SP (working documents/SG1) using the same folder structure as specified in this script #####

library(readxl)
library(tidyverse)
library(icesTAF)



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
# Join standards 
measures_all <- measures_all %>%
  left_join(standards, by = c("measure_type" = "std_measure_type", "submeasure_type" = "std_submeasure_type"))

#create output directory
mkdir("Misc/WKEMP/WKEMP4/SG1/output/")

#save result
save(measures_all, file = "Misc/WKEMP/WKEMP4/SG1/output/measures_all.RData")
