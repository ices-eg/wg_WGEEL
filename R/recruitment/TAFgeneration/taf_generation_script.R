# set current year
CY <- 2023

#setwd
if (getUsername() == "cedric.briand") wddata <- setwd("C:/workspace/wg_WGEEL/R/recruitment") 
if (getUsername() == "hilaire.drouineau") wddata <-setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/recruitment/")

#load TAF library
library(icesTAF)

#Create TAF skeleton
taf_directory <- taf.skeleton(paste0("./TAF/",CY))                              

#copy utilities.R to TAF folder
file.copy("./utilities.R", taf_directory)
source("TAFgeneration/export_function.R")

#Load database ----------------------------------


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
# build data.R



#build model.R
fileConn <- file(paste(taf_directory, "model.R", sep = "/"), 
                 open = "a+b")
writeLines("source(utilities.R)", fileConn)
close(fileConn)


export_model_to_taf("model_ge_area", taf_directory, append = TRUE)
export_predict_model_to_taf("model_ge_area", 
                            taf_directory,
                            reference="1960:1979")
export_model_to_taf("model_older", taf_directory, append = TRUE)
export_predict_model_to_taf("model_older", 
                            taf_directory,
                            reference="1960:1979")

####build output.R
