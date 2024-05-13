

#########################################################
### script to rbind all fisheries description answers ###
#########################################################

#-----------------------------------------------------------------------------------#





##### 1. load libraries #####

### define libraries needed 
libs <- c("tidyverse", "readxl") 

### define libraries already installed
installed_libs <- libs %in% rownames(installed.packages())

### install libraries that are not installed already
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

### load libraries needed
invisible(lapply(libs, library, character.only = T))

#-----------------------------------------------------------------------------------#





##### 2. Read files #####



##### 2.1 Create an empty global data frame to write all the input to #####

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
tabs <- excel_sheets("C:/Users/pohlmann/Desktop/WKLANDEEL/data_call/fisheries description - IT_may_13.xlsx")
tabs <- tabs[grepl("IT", tabs)]

### read each sheet from italian call and rbind to fisheries descriptions
italy <- ("C:/Users/pohlmann/Desktop/WKLANDEEL/data_call/fisheries description - IT_may_13.xlsx")

for (i in 1:length(tabs)){
  
temp <- read_excel(italy, sheet = tabs[i]) %>% mutate(emu = tabs[i]) %>% rename(com_rec = "com/rec", gear_name = "gear name")
fisheries_descriptions <- rbind(fisheries_descriptions, temp)  
  
print(i) 

}
  
#-------------------------#



#### 2.3 For countries that provided one file per EMU (containing a single tab with data), read files separately and add to global df ####

### create list of all relevant files
files <- list.files("C:/Users/pohlmann/Desktop/WKLANDEEL/data_call", pattern = "description", full.names = T)
files <- files[!grepl("IT", files)]

### read the respective sheet from each file and rbind to fisheries_descriptions
for (i in 1:length(files)){
  
  temp <- read_excel(files[i], sheet = "Fisheries description") %>% rename(com_rec = "com/rec", gear_name = "gear name")
  fisheries_descriptions <- rbind(fisheries_descriptions, temp)  
  
  print(i) 
  
}
