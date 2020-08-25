# Name : load_data_from_database.R
# Date : 21/03/2019
# Author: cedric.briand
###############################################################################

#setwd("C:\\workspace\\gitwgeel\\R\\shiny_data_visualisation\\shiny_dv")
source("../../utilities/load_library.R")
load_package("RPostgreSQL")
load_package("sqldf")
load_package("glue")
if(is.null(options()$sqldf.RPostgreSQL.user)) {
  # extraction functions
source("database_connection.R")
}
source("database_reference.R")
source("database_data.R")
source("database_precodata.R")


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
# ONLY FOR AQUACULTURE WE HAVE A DATA PROTECTION LAW RESTRICTING THE ACCESS
aquaculture = extract_data("Aquaculture",quality=c(1,2,4),quality_check=TRUE)
release = extract_data("Release",quality=c(1,2,4),quality_check=TRUE)

precodata = extract_precodata() # for tables
# below by default in the view the quality 1,2,and 4 are used
precodata_all = extract_data("precodata_all",quality_check=FALSE) # for precodiagram
precodata_emu = extract_data("precodata_emu",quality_check=FALSE) 
precodata_country = extract_data("precodata_country",quality_check=FALSE) 

# yellow and silver eel series
ys_stations = sqldf('
				SELECT 
				ser_id,  ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code,
				ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription,
				ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y,             
				ser_sam_id, ser_qal_id, ser_qal_comment,     
				"tblCodeID", "Station_Code", "Country", "Organisation", "Station_Name",       
				cou_code, cou_country, cou_order, cou_iso3code,
				lfs_code, lfs_name, lfs_definition,              
				ocean,  subocean, f_area, f_subarea,  f_division
				FROM datawg.t_series_ser 
				left join ref.tr_station on ser_tblcodeid=tr_station."tblCodeID"
				left join ref.tr_country_cou on cou_code=ser_cou_code 
				left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
				left join ref.tr_faoareas on ser_area_division=f_division
				WHERE ser_typ_id IN (2,3)
				')
wger_ys = sqldf('
SELECT 
	das_id,
	das_value,       
	das_year,
	das_comment,
	/* 
			-- below those are data on effort, not used yet
	
	das_effort, 
	ser_effort_uni_code,       
	das_last_update,
	*/
			/* 
			-- this is the id on quality, not used yet but plans to use later
	-- to remove the data with problems on quality from the series
	-- see WKEELDATA (2017)
	das_qal_id,
	*/ 
	ser_id,            
	ser_nameshort,
	ser_area_division,
	f_subarea,
	lfs_code,          
	lfs_name
FROM datawg.t_dataseries_das 
	join datawg.t_series_ser on das_ser_id=ser_id
	left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
	left join ref.tr_faoareas on ser_area_division=f_division
WHERE ser_typ_id IN (2,3)
')

wger_init_ys = sqldf('
SELECT 
	das_id AS id,
	das_value AS value,       
	das_year AS year,
	das_comment,
	/* 
			-- below those are data on effort, not used yet
	
	das_effort, 
	ser_effort_uni_code,       
	das_last_update,
	*/
			/* 
			-- this is the id on quality, used from 2018
	-- to remove the data with problems on quality from the series
	-- see WKEEKDATA (2018)
	das_qal_id,
	*/ 
			ser_id,            
	ser_nameshort AS site,
	ser_area_division AS area_division,
	ser_qal_id,
	/* 
			-- this is the id on quality at the level of individual lines of data
	-- checks are done later to ensure provide a summary of the number of 0 (missing data),
	-- 3 data discarded, 4 used but with doubts....
	*/ 
			das_qal_id,
	das_last_update,
	f_subarea,
	lfs_code,          
	lfs_name AS lifestage
FROM datawg.t_dataseries_das 
	join datawg.t_series_ser on das_ser_id=ser_id
	left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
	left join ref.tr_faoareas on ser_area_division=f_division
WHERE ser_typ_id IN (2,3)
')

statseries_ys<-sqldf("select * from datawg.series_summary where life_stage IN ('Y', 'S')")
# load(file="data/ref_and_eel_data.Rdata")
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
	ys_stations, wger_ys, wger_init_ys, statseries_ys,
    file="data/ref_and_eel_data.Rdata", version=2)