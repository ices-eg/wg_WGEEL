setwd("./example-stock-assessment-start")


#install.packages("remotes")
library(remotes)

# remotes::install_github("fishfollower/sam/stockassessment")
# remotes::install_github("fishfollower/SAM/stockassessment", INSTALL_opts=c("--no-multiarch"))

# because this is a special package we need to add it to
# the taf analysis

library(icesTAF)

# add any special packages (almost always github ones) - DATA.bib was provided for this example, otherwise it would be drafted analogue to the methods done in Example 1
draft.software("stockassessment")
draft.software("stockassessment", file = TRUE)

draft.data(data.scripts = c("sam_data.R", "sam_fit.R"),
           data.files = NULL,
           originator = "WGBFAS",
           year = 2021,
           file = TRUE
           )

taf.bootstrap(software = FALSE) #software = FALSE skips the software install (since stockassessment is already installed and large; also didn't work;)

library(stockassessment)
library(rmarkdown)

taf.bootstrap()

sourceTAF("data")
sourceTAF("model")
sourceTAF("output")
sourceTAF("report")
#sourceAll() #sources all scripts; careful if the model is complex and takes time, it'll be fitted again!
#when sourcing other scripts in e.g. report.R or output.R, their name should start with report or output to tie them to the four main scripts in the TAF (data, model, output, report)


render("report.Rmd",
  output_file = "report.html",
  encoding = "UTF-8"
)

browseURL("report.html")
