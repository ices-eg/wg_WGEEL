
library(icesTAF)
library(stockassessment)

mkdir("report")

load("model/fit.rData")
load("model/retro_fit.rData")

## input data plots

## ....

## model output plots ##
taf.png("summary", width = 1600, height = 2000)
plot(fit)
dev.off()

taf.png("SSB")
ssbplot(fit, addCI = TRUE)
dev.off()

taf.png("Fbar")
fbarplot(fit, xlab = "", partial = FALSE)
dev.off()

taf.png("Rec")
recplot(fit, xlab = "")
dev.off()

taf.png("Landings")
catchplot(fit, xlab = "")
dev.off()

taf.png("retrospective", width = 1600, height = 2000)
plot(retro_fit)
dev.off()