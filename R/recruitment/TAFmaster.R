
#############################################################################################
#                                                                                           #
#   Master script: Creates libraries (metadata), subscripts are created and all scripts     #
#   used in the process are sourced (data, utilities, model, output, report).               #
#                                                                                           #
#   RUN THIS SCRIPT FOR THE COMPLETE PROCESS FROM RAW DATA TO FINAL OUTPUT/REPORT  
#   TO DO THIS YOU WILL NEED AN ACCESS TO THE DATABASE
#   RUN POINT 5 ONLY IF YOU DO NOT WANT TO REIMPORT DATA AND RUN UTILITIES (time intensive) #      
#                                                                                           #
#############################################################################################




#####------------------------------------ 1. PREPARATION TO RUN SCRIPT ------------------------------------#####  

# define libraries needed
libs <- c("icesTAF") 

#define libraries already installed
installed_libs <- libs %in% rownames(installed.packages())

# install libraries that are not installed already
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

# load libraries needed
invisible(lapply(libs, library, character.only = T))


# set working directory and run taf.skeleton to create folder structure
taf.skeleton()

# change this to adapt this script the next year

CY <- 2023


#####------------------------------------ 2. CREATE METADATA (.bib file) ------------------------------------#####

#create metadata for script
draft.data(
    originator = "wgeel",
    year = CY,
    title = "Recruitment stations data",
    period = str_c("1900-",CY),
    access = "Public",
    source = "script",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "R_stations.Rdata",  
    append = FALSE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Statistics for series used in the recruitment index",
    period = str_c("1900-",CY),
    access = "Public",
    source = "script",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "statseries.Rdata",  
    append = FALSE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Statistics for series used in the recruitment index",
    period = str_c("1900-",CY),
    access = "Public",
    source = "script",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "t_series_ser.Rdata",  
    append = FALSE
)

draft.data(
    originator = "wgeel",
    year = CY,
    title = "Statistics for series used in the recruitment index",
    period = str_c("1900-",CY),
    access = "Public",
    source = "script",
    file = TRUE, # shorthand for "boot/DATA.bib".
    data.files = "wger_init.Rdata",  
    append = FALSE
)


#####------------------------------------ 3. IMPORT DATA FROM ABOVE TO BOOTSTRAP/DATA FOLDER  ------------------------------------#####

# bring all in DATA.bib to the bootstrap/data folder (from "initial/data"). Existing data will not be overwritten(? it re-downloads... Also, files not in DATA.bib that are already in data folder will be deleted!)! Delete those where an update is required!
taf.boot(software = FALSE,quiet=FALSE) 




#####------------------------------------ 4. CREATE UTILITIES  ------------------------------------#####

#source("utilities/utilities.R")




#--------------------------------------------------------------------------------#
#####----- RUN SCRIPT FROM HERE IF YOU DO NOT WANT TO IMPORT DATA AGAIN -----#####
#--------------------------------------------------------------------------------#


################## 5. source scripts for data formatting, moldel/analyses, generationg output and report ################## 

# remove all folders (including what's in them, that were created by the scripts below)
clean()

# delete everything from the R environment
rm(list = ls())

# run the scripts
source("data.R")
source("model.R")
source("output.R")
source("report.R")
