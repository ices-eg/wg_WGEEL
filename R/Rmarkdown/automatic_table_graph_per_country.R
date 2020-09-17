# 
# Produces the report using params specific to each country
# Author: cedricbriandgithub
###############################################################################

require(rmarkdown)
require(bookdown)
getUsername <- function(){
	name <- Sys.info()[["user"]]
	return(name)
}
if (getUsername() == "cedric.briand") setwd("C:/workspace/gitwgeel/R/Rmarkdown")
if (getUsername() == "hilaire.drouineau") setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github/wg_WGEEL/R/Rmarkdown/")
load("../shiny_data_visualisation/shiny_dv/data/ref_and_eel_data.Rdata")
cou_code <- unique(landings$eel_cou_code[!is.na(landings$eel_cou_code)])
dir.create("C:/workspace/gitwgeel/R/Rmarkdown/2020",showWarnings = FALSE)
dir.create("C:/workspace/gitwgeel/R/Rmarkdown/files",showWarnings = FALSE)


# North Sea
for (cou in c("DK","NL","DE")){
rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
		output_file = cou,
		output_dir =str_c("./",CY), 
	  output_format	=  "bookdown::word_document2", # calling doc either here or in the yaml ends up with the wrong name
		intermediates_dir ="./files",
		clean = FALSE,
		params = list("country"=cou,
						G=FALSE,Y=TRUE,YS=TRUE,S=TRUE,
						Gr=FALSE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
						releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
						year=1960, # minimum year for eelstock values
						area="North Sea",
						map=TRUE))
rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
                  output_file = cou,
                  output_dir =str_c("./",CY), 
                  output_format	=  "bookdown::html_document2", # calling doc either here or in the yaml ends up with the wrong name
                  intermediates_dir ="./files",
                  clean = FALSE,
                  params = list("country"=cou,
                                G=FALSE,Y=TRUE,YS=TRUE,S=TRUE,
                                Gr=FALSE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
                                releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
                                year=1960, # minimum year for eelstock values
                                area="North Sea",
                                map=TRUE))

}
# Baltic
for (cou in c("EE", "SE", "LT", "LV", "NO", "PL", "FI")){
  cat(cou)
	rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
			output_file = cou,
			output_dir =str_c("./",CY), 
			output_format	=  "bookdown::word_document2",
			intermediates_dir ="./files",
			clean = FALSE,
			params = list("country"=cou,
					G=FALSE,Y=TRUE,YS=TRUE,S=TRUE,
					Gr=FALSE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
					releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
					year=1960, # minimum year for eelstock values
					area="Elsewhere Europe",
					map=TRUE))

}

for (cou in c("ES","IT","FR","GB","PT")){
	
	rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
			output_file = cou,
			output_dir =str_c("./",CY), 
			output_format	=  NULL,
			intermediates_dir ="./files",
			clean = FALSE,
			params = list("country"=cou,
					G=TRUE,Y=TRUE,YS=TRUE,S=TRUE,
					Gr=TRUE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
					releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
					year=1960, # minimum year for eelstock values
					area="Elsewhere Europe",
					map=TRUE))
}

for (cou in c("IE","BE")){
	rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
			output_file = cou,
			output_dir =str_c("./",CY), 
			output_format	= NULL ,
			intermediates_dir ="./files",
			clean = FALSE, # keep md
 			params = list("country"=cou,
					G=FALSE,Y=TRUE,YS=TRUE,S=TRUE,
					Gr=FALSE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
					releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
					year=1960, # minimum year for eelstock values
					area="Elsewhere Europe",
					map=TRUE))	
}
 

 

for (cou in c("TR","HR","TN","SI","GR")){
	rmarkdown::render("automatic_tables_graphs_per_country.Rmd", 	
			output_file = cou,
			output_dir =str_c("./",CY), 
			output_format	= NULL ,
			intermediates_dir ="./files",
			clean = FALSE, # keep md
			params = list("country"=cou,
					G=FALSE,Y=TRUE,YS=TRUE,S=TRUE,
					Gr=FALSE,Yr=TRUE,YSr=TRUE,Sr=TRUE,
					releaseG=TRUE, releaseY=TRUE,releaseQG=TRUE,releaseOG=TRUE,releaseYS=FALSE,releaseS=TRUE,
					year=1960, # minimum year for eelstock values
					area="Elsewhere Europe",
					map=TRUE))	
}
