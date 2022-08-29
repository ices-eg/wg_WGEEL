mkdir("report")

(load("model/fit.RData"))

years <- unique(fit$data$aux[, "year"])

## catage
catage <- read.taf("data/catage.csv")
#row.names(catage) <- years[1:nrow(catage)]

catage <- cbind(catage, total = rowSums(catage))
catage <- rbind(catage, mean = colMeans(catage))

write.taf(catage, "report/catage.csv")

## surveys
# survey <- read.ices("data/survey.dat")
# write.taf(survey, "report/survey.csv")

## wstock
# wstock <- read.ices("data/sw.dat")
# write.taf(wstock, "report/wstock.csv")

## maturity
# maturity <- read.ices("data/mo.dat")
# maturity < maturity[, as.character(3:10)]
# write.taf(maturity, "report/maturity.csv")

## parameter table, summary, Ns and Fs
# write.taf(ptab, "report/partab.csv")
# write.taf(tab.summary, "report/summary.csv")
# write.taf(ntab, "report/natage.csv")
# write.taf(ftab, "report/fatage.csv")