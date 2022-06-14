
setwd("C:/Users/pohlmann/Desktop/Home_Office/Projekte/wg_WGEEL/Misc/WKTAF")

#load library
library(icesTAF)

taf.skeleton("taf-workshop-example-1")
setwd("taf-workshop-example-1")

#write.taf
write.taf(cars, dir = taf.boot.path("initial", "data"))
write.taf(trees, dir = taf.boot.path("initial", "data"))

draft.data()

draft.data(data.files = "cars.csv")

draft.data(
  data.files = "trees.csv",#
  originator = "Ryan, T. A., Joiner, B.l.",
  title = "Diameter etc.",
  file = TRUE,
  append = FALSE
)

draft.data(
  data.files = "cars.csv",#
  originator = "Ezekiel, M.",
  title = "Speed etc.",
  year = "2002",
  file = TRUE,
  append = FALSE
)

taf.bootstrap()