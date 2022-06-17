
library(stockassessment)

# download model from stockassessment.org
fit <- fitfromweb("WBCod_2021_cand01")

# save to model folder
save(fit, file = "fit.rData")
