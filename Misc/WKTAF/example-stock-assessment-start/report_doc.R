library(rmarkdown)

source("utilities.R")

mkdir("report")

# combine into a word document
render("report.Rmd",
       output_file = "report.html",
       #  output_file = "report.docx",
       encoding = "UTF-8"
)
# cp("report.docx", "report", move = TRUE)

browseURL("report.html")