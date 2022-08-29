setwd("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example")

#install.packages("icesTAF")

library(icesTAF)

#creates folder structure
taf.skeleton()

##################----------------1. bring in initial data/scripts----------------#########################

#bring in a local file from elsewhere (to initial/data)
cp("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/sample_files/trees.csv", "bootstrap/initial/data/")

#download data
download("https://www.metoffice.gov.uk/hadobs/hadsst4/data/netcdf/HadSST.4.0.1.0_median.nc", dir = "C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example/bootstrap/initial/data")

#create a folder with two dummy datasets (empty xlsx files)
dir.create("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example/bootstrap/initial/data/collection/")
invisible(file.create("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example/bootstrap/initial/data/collection/1.csv"))
invisible(file.create("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example/bootstrap/initial/data/collection/2.csv"))

#copy script to bootstrap
invisible(file.copy("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/sample_files/ices-areas.R", "C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF/Example/bootstrap/ices-areas.R"))


###############-----------2. create metadata----------################### (.bib file)

# create metadata for file
draft.data(
  data.files = "trees.csv",
  data.scripts = NULL, #set this to NULL or it will also look for all the scripts, it's not perfect yet;)
  originator = "Ryan, T. A., Joiner, B. L. and Ryan, B. F. (1976) The Minitab Student Handbook. Duxbury Press.",
  title = "Diameter, Height and Volume for Black Cherry Trees",
  file = TRUE,
  append = FALSE # create a new DATA.bib
)

# create metadata for a download
draft.data(
  data.files = "HadSST.4.0.1.0_median.nc", 
  originator = "UK MET office",
  data.scripts = NULL,
  title = "Met office observations data set",
  source = "https://www.metoffice.gov.uk/hadobs/hadsst4/data/netcdf/HadSST.4.0.1.0_median.nc",
  year = 2022,
  file = TRUE,
  append = TRUE # append to existing DATA.bib
)

#create metadata for folder
draft.data(
  data.files = "collection", #give name of a folder
  originator = "myself",
  data.scripts = NULL,
  title = "empty sheets",
  source = "folder", #write folder if it is a folder
  year = 2022,
  file = TRUE,
  append = TRUE # append to existing DATA.bib
)

#create metadata for script
draft.data(data.scripts = "ices-areas.R", # this needs to be in the bootstrap folder
  data.files = NULL,
  originator = "ICES",
  title = "ICES areas",
  file = TRUE,
  append = TRUE
)


##################----------------3. copy initial data to actual data folder (basically a copy to work with)----------------#########################

taf.bootstrap(software = FALSE) #brings all data that is in DATA.bib to the data folder (from "initial/data") - so basically can be run once in the end, depends. Existing data will not be overwritten but skipped - so if you need to update the data, remove the files from the data folder first!

