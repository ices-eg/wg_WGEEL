## Run analysis, write model results

## Before:
## After:

library(icesTAF)

mkdir("model")

(load(taf.data.path("sam_fit", "fit.rData")))

retro_fit <- stockassessment::retro(fit, year = 2019:2021)


save(fit, file = "model/fit.RData")
save(retro_fit, file = "model/retro_fit.RData")
