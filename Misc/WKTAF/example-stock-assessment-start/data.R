## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)
library(stockassessment)

mkdir("data")

## 1 Read underlying data from bootstrap/data

catage <- read.ices(taf.data.path("sam_data/cn.dat"))

#  ## Catch-weight-at-age ##
wcatch <- read.ices(taf.data.path("sam_data/cw.dat"))
wdiscards <- read.ices(taf.data.path("sam_data/cn.dat"))
wlandings <- read.ices(taf.data.path("sam_data/lw.dat"))

#  ## Natural-mortality ##
natmort <- read.ices(taf.data.path("sam_data/nm.dat"))

#  ## Proportion of F before spawning ##
propf <- read.ices(taf.data.path("sam_data/pf.dat"))

#  ## Proportion of M before spawning ##
propm <- read.ices(taf.data.path("sam_data/pm.dat"))

#  ## Stock-weight-at-age ##
wstock <- read.ices(taf.data.path("sam_data/sw.dat"))

# Landing fraction in catch at age
landfrac <- read.ices(taf.data.path("sam_data/lf.dat"))


## 2 Preprocess data
latage <- catage * landfrac[, -1]
datage <- catage * (1 - landfrac[, -1])

## 3 Write TAF tables to data directory
write.taf(c("catage", "latage", "datage", "wstock", "wcatch", "wdiscards", "wlandings", "natmort", "propf", "propm", "landfrac"), 
          dir= "data")
