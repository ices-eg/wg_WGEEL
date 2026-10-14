
library(httr2)
library(plumber)
library(sodium)
library(RPostgres)
library(jose)
library(callr)


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