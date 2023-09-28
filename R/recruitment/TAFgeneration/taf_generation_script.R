# set current year
CY <- 2023

####setwd
if (getUsername() == "cedric.briand") wddata <- setwd("C:/workspace/wg_WGEEL/R/recruitment") 
if (getUsername() == "hdrouineau") wddata <-setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")

source("TAFgeneration/export_function.R")

####load TAF library
library(icesTAF)

####Create TAF skeleton
taf_directory <- taf.skeleton(paste0("./TAF/",CY), force = TRUE)                              

####copy utilities.R to TAF folder
file.copy("./utilities.R", taf_directory)
source("TAFgeneration/export_function.R")

####Load database ----------------------------------


cred=read_yaml("../../credentials.yml")
pwd = passwordwgeel = password = cred$password
con = dbConnect(RPostgres::Postgres(), 
                dbname=cred$dbname,
                host=cred$host,
                port=cred$port,
                user=cred$user, 
                password=passwordwgeel)
dir.create(str_c(wddata,"/",CY),showWarnings = FALSE)
datawd <- str_c(wddata,"/",CY,"/data/")
dir.create(datawd, showWarnings = FALSE)
load_database(con, path=datawd)
export_data_to_taf(source_directory=datawd, 
                   taf_directory=taf_directory, 
                   files= c("wger_init.Rdata", 
                            "statseries.Rdata",
                            "R_stations.Rdata",
                            "last_years_with_problem.Rdata",
                            "t_series_ser.Rdata"))


######## Initialisation of files
#### model.R
write_to_taf("source(utilities.R)", "model.R", taf_directory, FALSE)
write_to_taf("modelResults <- character(0)", "model.R", taf_directory, FALSE)


#### report.R
write_to_taf("library(dplyr)", "report.R", taf_directory, TRUE)
write_to_taf("library(gglot2)", "report.R", taf_directory, FALSE)
write_to_taf(paste0("load('model/model.rdata')"),
             "report.R",
             taf_directory, FALSE)
write_to_taf("outputResults <- character(0)", "report.R", taf_directory, FALSE)


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

write_to_taf("write.taf(outputResults, dir = 'output')",
             "report.R",
             taf_directory, TRUE)



