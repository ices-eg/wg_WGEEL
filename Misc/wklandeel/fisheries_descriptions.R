
#########################################################
### script to rbind all fisheries description answers ###
#########################################################





#-----------------------------------------------------------------------------------#

#### 1. load libraries & path definitions ####

##### 1.1 load libraries #####

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

#-------------------------#



#### 1.2 define paths ####

### path definitions
italy <- "C:/Users/pohlmann/Desktop/WKLANDEEL/data_call/fisheries description - IT_may_13.xlsx"
dc_folder <- "C:/Users/pohlmann/Desktop/WKLANDEEL/data_call"

#-----------------------------------------------------------------------------------#





#### 2. Read files ####

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
save(fisheries_descriptions, file = "./Misc/wklandeel/fisheries_descriptions.RData")

#-----------------------------------------------------------------------------------#





#### 3. Create a summary of fisheries descriptions ####

# Convert data fra,me to long data
fd_long <- gather(fisheries_descriptions, year, value, 7:ncol(fisheries_descriptions)) %>% 
  mutate(year = as.integer(year))

# create summary
fd_summary <- fd_long %>% 
  filter(value != "NA") %>% 
  group_by(emu, com_rec) %>% 
  summarize(min_year=min(year),
            max_year=max(year))

# save summary to RData
save(fd_summary, file = "./Misc/wklandeel/fd_summary.RData")
