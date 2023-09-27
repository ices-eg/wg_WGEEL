#setwd
setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")

#load TAF library
library(icesTAF)

#Create TAF skeleton
taf_directory <- taf.skeleton(paste0("./TAF/",CY))                              

#copy utilities.R to TAF folder
file.copy("./utilities.R", taf_directory)

#export wger_init to data.R


#build model.R
fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                 open = "a+b")
writeLines("source(utilities.R)", fileConn)
close(fileConn)

source("TAFgeneration/export_function.R")
export_model_to_taf("model_ge_area", taf_directory, append = TRUE)
export_predict_model_to_taf("model_ge_area", 
                            taf_directory,
                            reference="1960:1979")
export_model_to_taf("model_older", taf_directory, append = TRUE)
export_predict_model_to_taf("model_older", 
                            taf_directory,
                            reference="1960:1979")