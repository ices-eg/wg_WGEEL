
library(icesTAF)

sam_assessment <- "WBCod_2021_cand01"

sam_dir <-
  paste0(
    "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/",
    sam_assessment,
    "/data/"
  )

files <-
  paste0(
    c("cn", "cw", "dw", "lf", "lw", "mo", "nm", "pf", "pm", "survey", "sw"),
    ".dat"
  )

for (file in files) {
  download(paste0(sam_dir, file))
}
