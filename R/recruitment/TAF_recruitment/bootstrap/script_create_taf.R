# Author: cedricbriandgithub
###############################################################################
# Create bootstrap folder
#library("stockassessment")
library("icesTAF")
taf.skeleton.sa.org(path = ".", "eel", force = FALSE)

mkdir("bootstrap")
load(file=str_c(datawd,"wger_init.Rdata"))
load(file=str_c(datawd,"statseries.Rdata"))
load(file=str_c(datawd,"R_stations.Rdata"))
load(file=str_c(datawd,"last_years_with_problem.Rdata"))
# Create bootstrap script, bootstrap/mydata.R
load(file=str_c(datawd,"wger_init.Rdata"))
draft.data.script(name="wger_init", title="Annual recruitment", description="Table of raw values of annual recruitment series",
		format="Rdata", originator="wgeel", year="2022",
		period=c( min(wger_init$year), max(wger_init$year)), access="Public",
		content='save(wger_init, file="wger_init.Rdata")')
draft.data(data.scripts = "wger_init", # this needs to be in the bootstrap folder
		data.files = NULL,
		originator = "ICES wgeel",
		period=str_c( min(wger_init$year),"-", max(wger_init$year)),
		title = "Annual recruitment",
		file = TRUE,
		append = FALSE
)
draft.data(data.scripts = "wger_init", # this needs to be in the bootstrap folder
		data.files = NULL,
		originator = "ICES wgeel",
		period=str_c( min(wger_init$year),"-", max(wger_init$year)),
		title = "Annual recruitment",
		file = TRUE,
		append = FALSE
)
# Process metadata files ‘SOFTWARE.bib’ and ‘DATA.bib’ to set up software and data files required for the analysis. 
taf.bootstrap()
# Create metadata, bootstrap/DATA.bib
taf.roxygenise(files="mydata.R")

# Run bootstrap script, creating bootstrap/data/mydata/pi.txt
taf.bootstrap()


