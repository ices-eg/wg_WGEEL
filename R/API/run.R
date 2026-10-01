
library(httr2)
library(plumber)
library(sodium)
library(RPostgres)
library(jose)
library(callr)

# Here we assume you are running this from "wgeel/R/API"
# setwd to current file location

# this will regenerate the file if changed on github


# this will regenerate the file if changed on github
url <- "https://raw.githubusercontent.com/ices-eg/wg_WGEEL/master/R/recruitment/utilities.R"
download.file(url, destfile = "utilities.R")

source("utilities.R", local = TRUE) # loads the load_database function 


 

# run front end ------------------------------------------
# if you do it open an R session in terminal to debug it
pr("plumber.R") |> pr_run(port = 8082)

# run background session (on the server) -------------------------------

# running in the background you cannot debug
# bg <- callr::r_bg(function() {
#   plumber::pr("plumber.R") |>
#   plumber::pr_run(host = "127.0.0.1", port = 8082)
# }
# 
# # PROCESS 'Rterm', running, pid 32396. in powershell kill 32396 to stop it
# 
# 
# bg$is_alive() 