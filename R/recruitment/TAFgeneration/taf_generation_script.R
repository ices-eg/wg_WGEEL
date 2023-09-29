library(stringr)

# set current year
CY <- 2023

####setwd
if (Sys.info()["user"] == "cedric.briand") wddata <- setwd("C:/workspace/wg_WGEEL/R/recruitment") 
if (Sys.info()["user"] == "hdrouineau") wddata <-setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")
source("utilities.R")
wddata <- getwd()
#wddata <- gsub("C:/workspace/gitwgeel/R","C:/workspace/wgeeldata",wd)

datawd <- str_c(wddata,"/",CY,"/data/")
shinywd <-  str_c(wddata,"/../shiny_data_visualisation/shiny_dv/data/recruitment/")
load(paste0(shinywd,"recruitment_models.Rdata"))


source("TAFgeneration/export_function.R")

####load TAF library
library(icesTAF)

####Create TAF skeleton
taf_directory <- taf.skeleton(paste0("./TAF/",CY), force = TRUE)                              

####copy utilities.R to TAF folder
file.copy("./utilities.R", taf_directory, overwrite = TRUE)
source("TAFgeneration/export_function.R")

####Load database ----------------------------------
export_data_to_taf(source_directory=datawd, 
                   taf_directory=taf_directory, 
                   files= c("wger_init.Rdata", 
                            "statseries.Rdata",
                            "R_stations.Rdata",
                            "last_years_with_problem.Rdata",
                            "t_series_ser.Rdata"))


######## Initialisation of files
#### data.R
write_to_taf("## 1 loading", "data.R",taf_directory, TRUE)
write_to_taf("for (f in list.files('boot/',pattern='Rdata$', full.names=TRUE)) load(f)", "data.R",taf_directory, TRUE)
write_to_taf("source('utilities.R')", "data.R", taf_directory, FALSE)


#### model.R
write_to_taf("load('data/datamodel.Rdata')", "model.R",taf_directory, TRUE)
write_to_taf("source('utilities.R')", "model.R", taf_directory, FALSE)
write_to_taf("modelResults <- character(0)", "model.R", taf_directory, FALSE)



#### report.R
write_to_taf("source('utilities.R')", "report.R", taf_directory, FALSE)
write_to_taf("library(dplyr)", "report.R", taf_directory, TRUE)
write_to_taf("library(ggplot2)", "report.R", taf_directory, FALSE)
write_to_taf(paste0("load('model/model.rdata')"),
             "report.R",
             taf_directory, FALSE)
write_to_taf("outputResults <- character(0)", "report.R", taf_directory, FALSE)


######## Making data selection
export_selection_to_taf(taf_directory = taf_directory)

######## Exporting models
ylab = expression(frac(p,bar(p)[1960-1979]))
export_all_modelprocess_to_taf("model_ge_area",
                               taf_directory,
                               "1960:1979",
                               list(list(logscale = TRUE, ylab = ylab),    #a graph with logscale
                                    list(logscale = FALSE, ylab = ylab))  #a graph in natural scale
                              )

export_all_modelprocess_to_taf("model_older",
                               taf_directory,
                               "1960:1979",
                               list(list(logscale = TRUE, ylab = ylab, palette="darkolivegreen"),    #a graph with logscale
                                    list(logscale = FALSE, ylab = ylab, palette="darkolivegreen"))  #a graph in natural scale
)
######## Finalisation of files
#### model.R
write_to_taf(paste0("save(list = modelResults, file = 'model/model.rdata')"),
             "model.R",
             taf_directory, TRUE)
#### report.R
export_diagram_series_to_taf(taf_directory = taf_directory)
write_to_taf("write.taf(outputResults, dir = 'output')",
             "report.R",
             taf_directory, TRUE)

write_to_taf("for (f in list.files('./','REPORT', full.names=TRUE, recursive=TRUE)) file.copy(f, 'report/')",
             "report.R",
             taf_directory, TRUE)

         
         
##### Write master.R directly in taf

write_file_to_taf(source_file= "TAFmaster.R", destination_file= "master.R", taf_directory= taf_directory)

