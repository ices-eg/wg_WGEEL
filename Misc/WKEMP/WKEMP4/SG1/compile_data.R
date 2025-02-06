library(readxl)
library(tidyverse)



#create a list of excel files (separated by first and second data call response)
files_second <- list.files(path = "C:/Users/pohlmann/Desktop/2024_WKEMP4/pt 2/for_compilation/responses", 
                    pattern = ".xlsx",
                    full.names = TRUE)

files_first <- list.files(path = "C:/Users/pohlmann/Desktop/2024_WKEMP4/pt 2/for_compilation", 
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

#save result
save(measures_all, file = "output/measures_all.RData")

