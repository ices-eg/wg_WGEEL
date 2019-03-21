# Name : load_data_from_database.R
# Date : 21/03/2019
# Author: cedric.briand
###############################################################################

#setwd("C:\\Users\\cedric.briand\\Documents\\GitHub\\WGEEL\\R\\shiny_data_visualisation\\shiny")
source("../../utilities/load_library.R")
load_package("RPostgreSQL")
load_package("sqldf")
load_package("glue")
if(is.null(options()$sqldf.RPostgreSQL.user)) {
  # extraction functions
source("../../database_interaction/database_connection.R")


}
source("../../database_interaction/database_reference.R")
source("../../database_interaction/database_data.R")
source("../../database_interaction/database_precodata.R")


habitat_ref <- extract_ref("Habitat type")
lfs_code_base <- extract_ref("Life stage")
#lfs_code_base <- lfs_code_base[!lfs_code_base$lfs_code %in% c("OG","QG"),]
country_ref <- extract_ref("Country")
country_ref <- country_ref[order(country_ref$cou_order), ]
country_ref$cou_code <- factor(country_ref$cou_code, levels = country_ref$cou_code[order(country_ref$cou_order)], ordered = TRUE)

##have an order for the emu
emu_ref <- extract_ref("EMU")
summary(emu_ref)
emu_cou<-merge(emu_ref,country_ref,by.x="emu_cou_code",by.y="cou_code")
emu_cou<-emu_cou[order(emu_cou$cou_order,emu_cou$emu_nameshort),]
emu_cou<-data.frame(emu_cou,emu_order=1:nrow(emu_cou))
# Extract data from the database -------------------------------------------------------------------

landings = extract_data("Landings",quality=c(1,2,4),quality_check=TRUE)
aquaculture = extract_data("Aquaculture",quality=c(1,2,4),quality_check=TRUE)
release = extract_data("Release",quality=c(1,2,4),quality_check=TRUE)

precodata = extract_precodata() # for tables
# below by default in the view the quality 1,2,and 4 are used
precodata_all = extract_data("PrecoData All",quality_check=FALSE) # for precodiagram
precodata_emu = extract_data("PrecoData EMU",quality_check=FALSE) 
precodata_country = extract_data("PrecoData Country",quality_check=FALSE) 


save( precodata_all, 
    precodata,    
    precodata_emu, 
    precodata_country,
    emu_cou,
    emu_ref,
    country_ref,
    lfs_code_base,
    habitat_ref,
    release, 
    aquaculture, 
    landings,
    file="../../../data/ref_and_eel_data.Rdata")