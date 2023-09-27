####setwd
setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")

####load TAF library
library(icesTAF)

####Create TAF skeleton
taf_directory <- taf.skeleton(paste0("./TAF/",CY), force = TRUE)                              

####copy utilities.R to TAF folder
file.copy("./utilities.R", taf_directory)

####export wger_init to data.R


####build model.R
modelConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                 open = "a+b")
writeLines("source(utilities.R)", modelConn)
writeLines("modelResults <- list()", modelConn)
close(modelConn)

source("TAFgeneration/export_function.R")
export_model_to_taf("model_ge_area", taf_directory, append = TRUE)
export_predict_model_to_taf("model_ge_area", 
                            taf_directory,
                            reference="1960:1979")

export_model_to_taf("model_older", taf_directory, append = TRUE)
export_predict_model_to_taf("model_older", 
                            taf_directory,
                            reference="1960:1979",
                            vargroup = NULL)
modelConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                  open = "a+b")

writeLines(paste0("save(list = modelResults, file = 'model/model.rdata')"), modelConn)
close(modelConn)

####build report.R
reportConn <- file(paste(taf_directory, "report.R", sep = "/"), 
                  open = "a+b")
writeLines("library(dplyr)", reportConn)
writeLines("library(ggplot2)", reportConn)

writeLines(paste0("load('model/model.rdata')"), reportConn)

close(reportConn)


export_graph_to_TAF("model_ge_area",
                    taf_directory,
                    logscale = TRUE,
                    vargroup="area",
                    ylab=expression(frac(p,bar(p)[1960-1979])))
export_graph_to_TAF("model_ge_area",
                    taf_directory,
                    logscale = FALSE,
                    vargroup="area",
                    ylab=expression(frac(p,bar(p)[1960-1979])))


export_graph_to_TAF("model_older",
                    taf_directory,
                    logscale = TRUE,
                    vargroup=NULL,
                    palette="darkolivegreen",
                    ylab=expression(frac(p,bar(p)[1960-1979])))
export_graph_to_TAF("model_older",
                    taf_directory,
                    logscale = FALSE,
                    vargroup=NULL,
                    palette="darkolivegreen",
                    ylab=expression(frac(p,bar(p)[1960-1979])))


