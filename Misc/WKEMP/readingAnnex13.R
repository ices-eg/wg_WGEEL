
##Annex 13 data sheets

#

#Aim: to pull out relevent data from Overview EMU sheet into a row/column of data per EMU

#ignore sheets 'readme' metadata [we can come back and get this info if needed]
#'tr_emu_em'.
#sheet given is 'Overview_EMUX1' if only one emu this will be filled out, if more emus this could be blank with multiple sheets available


#questions/headers are mostly in column A and respective row number

#1. EMU Identification
library(XLConnect)
library(stringr)
library(dplyr)

readWorksheetWithNull=function(wb, s, startRow, startCol, endRow, endCol,header=FALSE){
	val=XLConnect::readWorksheet(wb, s, startRow=startRow, startCol=startCol,
			endRow=endRow, endCol=endCol,header=FALSE)[1,1]
	
	ifelse(is.null(val), NA, val)
}

#datawd <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2021\\WKEPEMP\\data_call\\Annex13\\"
#if(Sys.info()["user"] =="hilaire.drouineau") datawd = "~/Bureau/data_call/Annex13/"

# Select if you want to load raw data or use the data as already previously compiled.
# If you want to load the data yourself from the Excel annexes, then you need to input your own data directory where they are located

read.data = FALSE # Set this to false as a standard, so that it can be sourced by other R files and load the already-compiled data
datawd <- "C:/Users/rbva0001/Dropbox//Rob/SLU/ICES/Workshops/WKEMP4/data/annex13/"
datawd <- "W:/annex13-EMP"
if(read.data == TRUE){



#filepath <- filepath[1]
read_annex13 <- function(filepath){
	wb = loadWorkbook(filepath)
	sheet=getSheets(wb)
	sheet = sheet[-c(grep("metadata",sheet),grep("tr_emu",sheet),grep("readme", sheet))]
	do.call(rbind.data.frame,lapply(sheet,function(s){
						cou_code <- readWorksheetWithNull(wb, s, startRow=5, startCol=2, endRow=5, endCol=2,header=FALSE)
						emu_nameshort <- readWorksheetWithNull(wb, s, startRow=6, startCol=2, endRow=6, endCol=2,header=FALSE)
						transboundary <- readWorksheetWithNull(wb, s, startRow=7, startCol=2, endRow=7, endCol=2,header=FALSE)
						connected <- readWorksheetWithNull(wb, s, startRow=8, startCol=2, endRow=8, endCol=2,header=FALSE)
						comment_emu <- readWorksheetWithNull(wb, s, startRow=8, startCol=3, endRow=8, endCol=3,header=FALSE)
						agreement <- readWorksheetWithNull(wb, s, startRow=9, startCol=3, endRow=9, endCol=3,header=FALSE)
						date <- readWorksheetWithNull(wb, s, startRow=10, startCol=2, endRow=10, endCol=2,header=FALSE)
						b0_change <- readWorksheetWithNull(wb, s, startRow=14, startCol=2, endRow=14, endCol=2,header=FALSE)
						b0_explanation <- readWorksheetWithNull(wb, s, startRow=14, startCol=3, endRow=14, endCol=3,header=FALSE)
						bbest_change <- readWorksheetWithNull(wb, s, startRow=15, startCol=2, endRow=15, endCol=2,header=FALSE)
						bbest_explanation <- readWorksheetWithNull(wb, s, startRow=15, startCol=3, endRow=15, endCol=3,header=FALSE)
						bcurrent_change <- readWorksheetWithNull(wb, s, startRow=16, startCol=2, endRow=16, endCol=2,header=FALSE)
						bcurrent_explanation <- readWorksheetWithNull(wb, s, startRow=16, startCol=3, endRow=16, endCol=3,header=FALSE)
						
						habitat_considered_change <- readWorksheetWithNull(wb, s, startRow=19, startCol=2, endRow=19, endCol=2,header=FALSE)
						habitat_considered_explanation <- readWorksheetWithNull(wb, s, startRow=19, startCol=3, endRow=19, endCol=3,header=FALSE)
						data_source_change <- readWorksheetWithNull(wb, s, startRow=20, startCol=2, endRow=20, endCol=2,header=FALSE)
						data_source_explanation <- readWorksheetWithNull(wb, s, startRow=20, startCol=3, endRow=20, endCol=3,header=FALSE)
						method_assessment_change <- readWorksheetWithNull(wb, s, startRow=21, startCol=2, endRow=21, endCol=2,header=FALSE)
						method_assessment_explanation <- readWorksheetWithNull(wb, s, startRow=21, startCol=3, endRow=21, endCol=3,header=FALSE)
						
						restocking_b0 <- readWorksheetWithNull(wb, s, startRow=29, startCol=2, endRow=29, endCol=2,header=FALSE)
						restocking_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=29, startCol=3, endRow=29, endCol=3,header=FALSE)
						restocking_sumf <- readWorksheetWithNull(wb, s, startRow=29, startCol=4, endRow=29, endCol=4,header=FALSE)
						restocking_sumh <- readWorksheetWithNull(wb, s, startRow=29, startCol=5, endRow=29, endCol=5,header=FALSE)
						restocking_explanation <- readWorksheetWithNull(wb, s, startRow=46, startCol=2, endRow=46, endCol=2,header=FALSE)
						
						abs_recruitment_b0 <- readWorksheetWithNull(wb, s, startRow=27, startCol=2, endRow=27, endCol=2,header=FALSE)
						abs_recruitment_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=27, startCol=3, endRow=27, endCol=3,header=FALSE)
						abs_recruitment_sumf <- readWorksheetWithNull(wb, s, startRow=27, startCol=4, endRow=27, endCol=4,header=FALSE)
						abs_recruitment_sumh <- readWorksheetWithNull(wb, s, startRow=27, startCol=5, endRow=27, endCol=5,header=FALSE)
						
						rel_recruitment_b0 <- readWorksheetWithNull(wb, s, startRow=28, startCol=2, endRow=28, endCol=2,header=FALSE)
						rel_recruitment_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=28, startCol=3, endRow=28, endCol=3,header=FALSE)
						rel_recruitment_sumf <- readWorksheetWithNull(wb, s, startRow=28, startCol=4, endRow=28, endCol=4,header=FALSE)
						rel_recruitment_sumh <- readWorksheetWithNull(wb, s, startRow=28, startCol=5, endRow=28, endCol=5,header=FALSE)
						
						landings_b0 <- readWorksheetWithNull(wb, s, startRow=31, startCol=2, endRow=31, endCol=2,header=FALSE)
						landings_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=31, startCol=3, endRow=31, endCol=3,header=FALSE)
						landings_sumf <- readWorksheetWithNull(wb, s, startRow=31, startCol=4, endRow=31, endCol=4,header=FALSE)
						landings_sumh <- readWorksheetWithNull(wb, s, startRow=31, startCol=5, endRow=31, endCol=5,header=FALSE)
						
						effort_b0 <- readWorksheetWithNull(wb, s, startRow=32, startCol=2, endRow=32, endCol=2,header=FALSE)
						effort_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=32, startCol=3, endRow=32, endCol=3,header=FALSE)
						effort_sumf <- readWorksheetWithNull(wb, s, startRow=32, startCol=4, endRow=32, endCol=4,header=FALSE)
						effort_sumh <- readWorksheetWithNull(wb, s, startRow=32, startCol=5, endRow=32, endCol=5,header=FALSE)
						
						biological_data_b0 <- readWorksheetWithNull(wb, s, startRow=33, startCol=2, endRow=33, endCol=2,header=FALSE)
						biological_data_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=33, startCol=3, endRow=33, endCol=3,header=FALSE)
						biological_data_sumf <- readWorksheetWithNull(wb, s, startRow=33, startCol=4, endRow=33, endCol=4,header=FALSE)
						biological_data_sumh <- readWorksheetWithNull(wb, s, startRow=33, startCol=5, endRow=33, endCol=5,header=FALSE)
						
						yellow_eel_stock_abundance_b0 <- readWorksheetWithNull(wb, s, startRow=35, startCol=2, endRow=35, endCol=2,header=FALSE)
						yellow_eel_stock_abundance_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=35, startCol=3, endRow=35, endCol=3,header=FALSE)
						yellow_eel_stock_abundance_sumf <- readWorksheetWithNull(wb, s, startRow=35, startCol=4, endRow=35, endCol=4,header=FALSE)
						yellow_eel_stock_abundance_sumh <- readWorksheetWithNull(wb, s, startRow=35, startCol=5, endRow=35, endCol=5,header=FALSE)
						
						silver_eel_stock_abundance_b0 <- readWorksheetWithNull(wb, s, startRow=36, startCol=2, endRow=36, endCol=2,header=FALSE)
						silver_eel_stock_abundance_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=36, startCol=3, endRow=36, endCol=3,header=FALSE)
						silver_eel_stock_abundance_sumf <- readWorksheetWithNull(wb, s, startRow=36, startCol=4, endRow=36, endCol=4,header=FALSE)
						silver_eel_stock_abundance_sumh <- readWorksheetWithNull(wb, s, startRow=36, startCol=5, endRow=36, endCol=5,header=FALSE)
						
						glass_eel_stock_abundance_b0 <- readWorksheetWithNull(wb, s, startRow=37, startCol=2, endRow=37, endCol=2,header=FALSE)
						glass_eel_stock_abundance_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=37, startCol=3, endRow=37, endCol=3,header=FALSE)
						glass_eel_stock_abundance_sumf <- readWorksheetWithNull(wb, s, startRow=37, startCol=4, endRow=37, endCol=4,header=FALSE)
						glass_eel_stock_abundance_sumh <- readWorksheetWithNull(wb, s, startRow=37, startCol=5, endRow=37, endCol=5,header=FALSE)
						
						habitat_quantity_b0 <- readWorksheetWithNull(wb, s, startRow=40, startCol=2, endRow=40, endCol=2,header=FALSE)
						habitat_quantity_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=40, startCol=3, endRow=40, endCol=3,header=FALSE)
						habitat_quantity_sumf <- readWorksheetWithNull(wb, s, startRow=40, startCol=4, endRow=40, endCol=4,header=FALSE)
						habitat_quantity_sumh <- readWorksheetWithNull(wb, s, startRow=40, startCol=5, endRow=40, endCol=5,header=FALSE)
						
						habitat_quality_b0 <- readWorksheetWithNull(wb, s, startRow=41, startCol=2, endRow=41, endCol=2,header=FALSE)
						habitat_quality_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=41, startCol=3, endRow=41, endCol=3,header=FALSE)
						habitat_quality_sumf <- readWorksheetWithNull(wb, s, startRow=41, startCol=4, endRow=41, endCol=4,header=FALSE)
						habitat_quality_sumh <- readWorksheetWithNull(wb, s, startRow=41, startCol=5, endRow=41, endCol=5,header=FALSE)
						
						hydro_b0 <- readWorksheetWithNull(wb, s, startRow=43, startCol=2, endRow=43, endCol=2,header=FALSE)
						hydro_bbest_bcurrent <- readWorksheetWithNull(wb, s, startRow=43, startCol=3, endRow=41, endCol=3,header=FALSE)
						hydro_sumf <- readWorksheetWithNull(wb, s, startRow=43, startCol=4, endRow=43, endCol=4,header=FALSE)
						hydro_sumh <- readWorksheetWithNull(wb, s, startRow=43, startCol=5, endRow=43, endCol=5,header=FALSE)
						
						b0_mk <- readWorksheetWithNull(wb, s, startRow=50, startCol=2, endRow=50, endCol=2,header=FALSE)
						bbest_bcurrent_mk <- readWorksheetWithNull(wb, s, startRow=50, startCol=3, endRow=50, endCol=3,header=FALSE)
						b0_counter <- readWorksheetWithNull(wb, s, startRow=51, startCol=2, endRow=51, endCol=2,header=FALSE)
						bbest_bcurrent_counter <- readWorksheetWithNull(wb, s, startRow=51, startCol=3, endRow=51, endCol=3,header=FALSE)
						b0_trap <- readWorksheetWithNull(wb, s, startRow=52, startCol=2, endRow=52, endCol=2,header=FALSE)
						bbest_bcurrent_trap <- readWorksheetWithNull(wb, s, startRow=52, startCol=3, endRow=52, endCol=3,header=FALSE)  
						b0_other <- readWorksheetWithNull(wb, s, startRow=53, startCol=2, endRow=53, endCol=2,header=FALSE)
						bbest_bcurrent_other <- readWorksheetWithNull(wb, s, startRow=53, startCol=3, endRow=53, endCol=3,header=FALSE) 
						assessment_explanation <- readWorksheetWithNull(wb, s, startRow=53, startCol=4, endRow=53, endCol=4,header=FALSE) 
						assessment_method <- readWorksheetWithNull(wb, s, startRow=57, startCol=1, endRow=57, endCol=1,header=FALSE) 
						mortality_wise <- readWorksheetWithNull(wb, s, startRow=58, startCol=2, endRow=58, endCol=2,header=FALSE) 
						
						# method mortality
						impact_fishery <- readWorksheetWithNull(wb, s, startRow=63, startCol=2, endRow=63, endCol=2, header=FALSE)
						impact_fishery_description <- readWorksheetWithNull(wb, s, startRow=63, startCol=3, endRow=63, endCol=3, header=FALSE)
						impact_hp <- readWorksheetWithNull(wb, s, startRow=64, startCol=2, endRow=64, endCol=2, header=FALSE)
						impact_hp_description <- readWorksheetWithNull(wb, s, startRow=64, startCol=3, endRow=64, endCol=3, header=FALSE)
						impact_habitat <- readWorksheetWithNull(wb, s, startRow=65, startCol=2, endRow=65, endCol=2, header=FALSE)
						impact_habitat_description <- readWorksheetWithNull(wb, s, startRow=65, startCol=3, endRow=65, endCol=3, header=FALSE)
						impact_restocking <- readWorksheetWithNull(wb, s, startRow=66, startCol=2, endRow=66, endCol=2, header=FALSE)
						impact_restocking_description <- readWorksheetWithNull(wb, s, startRow=66, startCol=3, endRow=66, endCol=3, header=FALSE)
						impact_other <- readWorksheetWithNull(wb, s, startRow=67, startCol=2, endRow=67, endCol=2, header=FALSE)
						impact_other_description <- readWorksheetWithNull(wb, s, startRow=67, startCol=3, endRow=67, endCol=3, header=FALSE)
						biomass_method_ref <- readWorksheetWithNull(wb, s, startRow=70, startCol=2, endRow=70, endCol=2, header=FALSE)
						mortality_method_ref <- readWorksheetWithNull(wb, s, startRow=71, startCol=2, endRow=71, endCol=2, header=FALSE)
						biomass_method_ground_truth <- readWorksheetWithNull(wb, s, startRow=73, startCol=2, endRow=73, endCol=2, header=FALSE)
						mortality_ground_truth <- readWorksheetWithNull(wb, s, startRow=74, startCol=2, endRow=74, endCol=2, header=FALSE)
						
						# traceability
						traceability_scheme_EMU <- readWorksheetWithNull(wb, s, startRow=77, startCol=2, endRow=77, endCol=2, header=FALSE)
						traceability_scheme_EMU_description <- readWorksheetWithNull(wb, s, startRow=77, startCol=3, endRow=77, endCol=3, header=FALSE)
						traceability_scheme_country <- readWorksheetWithNull(wb, s, startRow=78, startCol=2, endRow=78, endCol=2, header=FALSE)
						traceability_scheme_country_description <- readWorksheetWithNull(wb, s, startRow=78, startCol=3, endRow=78, endCol=3, header=FALSE)
						traceability_changed <- readWorksheetWithNull(wb, s, startRow=80, startCol=2, endRow=80, endCol=2, header=FALSE)
						traceability_difficulties <- readWorksheetWithNull(wb, s, startRow=81, startCol=2, endRow=81, endCol=2, header=FALSE)
						
						# reserving60%
						
						reserving_60_monitoring  <- readWorksheetWithNull(wb, s, startRow=84, startCol=2, endRow=84, endCol=2, header=FALSE) 
						reserving_60_changed <- readWorksheetWithNull(wb, s, startRow=85, startCol=2, endRow=85, endCol=2, header=FALSE) 
						reserving_60_changed_description <- readWorksheetWithNull(wb, s, startRow=85, startCol=3, endRow=85, endCol=3, header=FALSE)
						reserving_60_difficulties_description <- readWorksheetWithNull(wb, s, startRow=86, startCol=2, endRow=86, endCol=2, header=FALSE)
						
						# control
						catch_monitoring_exists_control <- readWorksheetWithNull(wb, s, startRow=89, startCol=2, endRow=89, endCol=2, header=FALSE) 
						catch_monitoring_adapted_inland <- readWorksheetWithNull(wb, s, startRow=90, startCol=2, endRow=90, endCol=2, header=FALSE) 
						catch_monitoring_changed <- readWorksheetWithNull(wb, s, startRow=91, startCol=2, endRow=91, endCol=2, header=FALSE) 
						catch_monitoring_changed_description <- readWorksheetWithNull(wb, s, startRow=91, startCol=3, endRow=91, endCol=3, header=FALSE) 
						
						
						# Difficulties
						
						difficulties_1 <- readWorksheetWithNull(wb, s, startRow=95, startCol=2, endRow=95, endCol=2, header=FALSE) 
						difficulties_2 <- readWorksheetWithNull(wb, s, startRow=96, startCol=2, endRow=96, endCol=2, header=FALSE) 
						difficulties_3 <- readWorksheetWithNull(wb, s, startRow=97, startCol=2, endRow=97, endCol=2, header=FALSE) 
						difficulties_4 <- readWorksheetWithNull(wb, s, startRow=98, startCol=2, endRow=98, endCol=2, header=FALSE) 
						difficulties_5 <- readWorksheetWithNull(wb, s, startRow=99, startCol=2, endRow=99, endCol=2, header=FALSE) 

						# Good practises
						
						good_practises_1 <- readWorksheetWithNull(wb, s, startRow=103, startCol=2, endRow=103, endCol=2, header=FALSE) 
						good_practises_2 <- readWorksheetWithNull(wb, s, startRow=104, startCol=2, endRow=104, endCol=2, header=FALSE) 
						good_practises_3 <- readWorksheetWithNull(wb, s, startRow=105, startCol=2, endRow=105, endCol=2, header=FALSE) 
						good_practises_4 <- readWorksheetWithNull(wb, s, startRow=106, startCol=2, endRow=106, endCol=2, header=FALSE) 
						good_practises_5 <- readWorksheetWithNull(wb, s, startRow=107, startCol=2, endRow=107, endCol=2, header=FALSE) 

						data.frame(cou_code=cou_code,
								emu_nameshort=emu_nameshort,
								transboundary=transboundary,
								connected=connected,
								comment_emu=comment_emu,
								agreement=agreement,
								date=date,
								b0_change=b0_change,
								b0_explanation=b0_explanation,
								bbest_change=bbest_change,
								bbest_explanation=bbest_explanation,
								bcurrent_change=bcurrent_change,
								bcurrent_explanation=bcurrent_explanation,
								
								habitat_considered_change=habitat_considered_change,
								habitat_considered_explanation=habitat_considered_explanation,
								data_source_change=data_source_change,
								data_source_explanation=data_source_explanation,
								method_assessment_change=method_assessment_change,
								method_assessment_explanation=method_assessment_explanation,
								
								restocking_b0=restocking_b0,
								restocking_bbest_bcurrent=restocking_bbest_bcurrent,
								restocking_sumf=restocking_sumf,
								restocking_sumh=restocking_sumh,
								restocking_explanation=restocking_explanation,	
								
								abs_recruitment_b0=abs_recruitment_b0,
								abs_recruitment_bbest_bcurrent=abs_recruitment_bbest_bcurrent,
								abs_recruitment_sumf=abs_recruitment_sumf,
								abs_recruitment_sumh=abs_recruitment_sumh,
								
								rel_recruitment_b0=rel_recruitment_b0,
								rel_recruitment_bbest_bcurrent=rel_recruitment_bbest_bcurrent,
								rel_recruitment_sumf=rel_recruitment_sumf,
								rel_recruitment_sumh=rel_recruitment_sumh,
								
								landings_b0=landings_b0,
								landings_bbest_bcurrent=landings_bbest_bcurrent,
								landings_sumf=landings_sumf,
								landings_sumh=landings_sumh,
								
								effort_b0=effort_b0,
								effort_bbest_bcurrent=effort_bbest_bcurrent,
								effort_sumf=effort_sumf,
								effort_sumh=effort_sumh,
								
								biological_data_b0=biological_data_b0,
								biological_data_bbest_bcurrent=biological_data_bbest_bcurrent,
								biological_data_sumf=biological_data_sumf,
								biological_data_sumh=biological_data_sumh,
								
								yellow_eel_stock_abundance_b0=yellow_eel_stock_abundance_b0,
								yellow_eel_stock_abundance_bbest_bcurrent=yellow_eel_stock_abundance_bbest_bcurrent,
								yellow_eel_stock_abundance_sumf=yellow_eel_stock_abundance_sumf,
								yellow_eel_stock_abundance_sumh=yellow_eel_stock_abundance_sumh,
								
								silver_eel_stock_abundance_b0=silver_eel_stock_abundance_b0,
								silver_eel_stock_abundance_bbest_bcurrent=silver_eel_stock_abundance_bbest_bcurrent,
								silver_eel_stock_abundance_sumf=silver_eel_stock_abundance_sumf,
								silver_eel_stock_abundance_sumh=silver_eel_stock_abundance_sumh,
								
								glass_eel_stock_abundance_b0=glass_eel_stock_abundance_b0,
								glass_eel_stock_abundance_bbest_bcurrent=glass_eel_stock_abundance_bbest_bcurrent,
								glass_eel_stock_abundance_sumf=glass_eel_stock_abundance_sumf,
								glass_eel_stock_abundance_sumh=glass_eel_stock_abundance_sumh,
								
								habitat_quantity_b0=habitat_quantity_b0,
								habitat_quantity_bbest_bcurrent=habitat_quantity_bbest_bcurrent,
								habitat_quantity_sumf=habitat_quantity_sumf,
								habitat_quantity_sumh=habitat_quantity_sumh,
								habitat_quality_b0=habitat_quality_b0,
								habitat_quality_bbest_bcurrent=habitat_quality_bbest_bcurrent,
								habitat_quality_sumf=habitat_quality_sumf,
								habitat_quality_sumh=habitat_quality_sumh,
								
								hydro_b0=hydro_b0,
								hydro_bbest_bcurrent=hydro_bbest_bcurrent,
								hydro_sumf=hydro_sumf,
								hydro_sumh=hydro_sumh,
								
								b0_mk=b0_mk,
								bbest_bcurrent_mk=bbest_bcurrent_mk,
								b0_counter=b0_counter,
								bbest_bcurrent_counter=bbest_bcurrent_counter,
								b0_trap=b0_trap,
								bbest_bcurrent_trap=bbest_bcurrent_trap,
								b0_other=b0_other,
								bbest_bcurrent_other=bbest_bcurrent_other,
								
								assessment_explanation=assessment_explanation,
								assessment_method=assessment_method,
								mortality_wise=mortality_wise,
								
								impact_fishery=impact_fishery,
								impact_fishery_description=impact_fishery_description,
								impact_hp= impact_hp,
								impact_hp_description =impact_hp_description,
								impact_habitat = impact_habitat,
								impact_habitat_description = impact_habitat_description,
								impact_restocking =impact_restocking,
								impact_restocking_description=impact_restocking_description,
								impact_other = impact_other,
								impact_other_description =impact_other_description,
								
								biomass_method_ref =biomass_method_ref,
								mortality_method_ref =mortality_method_ref,
								biomass_method_ground_truth =biomass_method_ground_truth,
								mortality_ground_truth=mortality_ground_truth,
								
								traceability_scheme_EMU =traceability_scheme_EMU,
								traceability_scheme_EMU_description =traceability_scheme_EMU_description,
								traceability_scheme_country =traceability_scheme_country,
								traceability_scheme_country_description =traceability_scheme_country_description,
								traceability_changed =traceability_changed,
								traceability_difficulties =traceability_difficulties,	
								
								reserving_60_monitoring  =reserving_60_monitoring,
								reserving_60_changed =reserving_60_changed,
								reserving_60_changed_description =reserving_60_changed_description,
								reserving_60_difficulties_description =reserving_60_difficulties_description,
								
								catch_monitoring_exists_control = catch_monitoring_exists_control,
								catch_monitoring_adapted_inland =catch_monitoring_adapted_inland,
								catch_monitoring_changed =catch_monitoring_changed,
								catch_monitoring_changed_description =catch_monitoring_changed_description,
								
								difficulties_1 =difficulties_1,
								difficulties_2 =difficulties_2,
								difficulties_3 =difficulties_3,
								difficulties_4 =difficulties_4,
								difficulties_5 =difficulties_5,
								
								good_practises_1 = good_practises_1,
								good_practises_2 = good_practises_2,
								good_practises_3 = good_practises_3,
								good_practises_4 = good_practises_4,
								good_practises_5 = good_practises_5
						
						)
					}))
	
}



#####to build the table: put all the filenames below and then run the line starting with annexes13_table
#setwd("/tmp/Annex13/")
filenames=list.files(str_c(datawd))
filenames <- filenames[grep("xlsx", filenames)] # only extract xlsx
filenames <- filenames[!grepl("~", filenames)] 
filenames <- filenames[!grepl("compiled", filenames)] 
filenames <- file.path(datawd,filenames)
annexes13_table_raw = do.call(rbind.data.frame,lapply(filenames, function(f) read_annex13(f)))

annexes13_table = annexes13_table_raw %>%
  mutate(date2 = case_when(
    !is.na(date) & substr(date, 1, 2) == "17" ~ as.POSIXct(as.numeric(date), origin = "1970-01-01", tz = "UTC"),
    grepl("^\\d{1,2}/\\d{1,2}/\\d{4}$", date) ~ as.POSIXct(date, format = "%d/%m/%Y", tz = "UTC"),
    grepl("^\\d{2}\\.\\d{2}\\.\\d{4}$", date) ~ as.POSIXct(date, format = "%d.%m.%Y", tz = "UTC"),
    is.na(date) ~ NA
  ),
  date = date2,
  comment_emu = ifelse(comment_emu == "Which", NA, comment_emu),
  bbest_explanation = ifelse(bbest_explanation == "Why", NA, bbest_explanation),
  bcurrent_explanation = ifelse(bcurrent_explanation == "Why", NA, bcurrent_explanation),
  b0_explanation = ifelse(b0_explanation == "Why", NA, b0_explanation),
  habitat_considered_explanation = ifelse(habitat_considered_explanation == "Why", NA, habitat_considered_explanation),
  data_source_explanation = ifelse(data_source_explanation == "Why", NA, data_source_explanation),
  method_assessment_explanation = ifelse(method_assessment_explanation == "Why", NA, method_assessment_explanation),
  assessment_explanation = ifelse(assessment_explanation == "Explain", NA, assessment_explanation)
  ) %>%
  select(-date2)

annexes13_method <- annexes13_table[,1:93]
annexes13_traceability <- annexes13_table[,c(1,2,94:103)]
annexes13_management <- annexes13_table[,c(1,2,104:117)]

save(annexes13_method,annexes13_traceability,annexes13_management, file=("data_dependencies/annex13.Rdata"))

} else {
  load("data_dependencies/annex13.Rdata")
}


wb = loadWorkbook("data_dependencies/annex13_compiled.xlsx",create=TRUE)
createSheet(wb,"annexes13_method")
writeWorksheet(wb, annexes13_method, sheet = "annexes13_method")
createSheet(wb,"annexes13_traceability")
writeWorksheet(wb, annexes13_traceability, sheet = "annexes13_traceability")
createSheet(wb,"annexes13_management")
writeWorksheet(wb, annexes13_management, sheet = "annexes13_management")
saveWorkbook(wb)
