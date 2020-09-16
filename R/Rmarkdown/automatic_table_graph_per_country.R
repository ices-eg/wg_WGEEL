# 
# Produces the report using params specific to each country
# Author: cedricbriandgithub
###############################################################################


getUsername <- function(){
	name <- Sys.info()[["user"]]
	return(name)
}
if (getUsername() == "cedric.briand") setwd("C:/workspace/gitwgeel/R/Rmarkdown")


rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	params = 
				list("country"='FR',
						G=TRUE,Y=TRUE,YS=TRUE,S=TRUE,
						Gr=TRUE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
						releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=TRUE,releaseS=TRUE,
						year=1960, # minimum year for eelstock values
						area="Elsewhere Europe"))

rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	params = 
				list("country"='FR',
						G=TRUE,Y=TRUE,YS=TRUE,S=TRUE,
						Gr=TRUE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
						releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=TRUE,releaseS=TRUE,
						year=1960, # minimum year for eelstock values
						area="Elsewhere Europe"))
pandoc("automatic_tables_graphs_per_country.md",".doc")