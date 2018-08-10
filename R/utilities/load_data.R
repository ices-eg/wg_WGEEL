# Function to load data that can be requested by the user interface 
# 
# Author: lbeaulaton
###############################################################################



#' load landings data
#' 
#' load landings data either from the database or from a csv file
#'  DEPRECATED see database_data.R
#load_landings = function(from_database = FALSE)
#{
#	if(from_database)
#	{
#		# TODO: extract data from the database
#	} else {
#		if(!exists(data_directory)) 
#			data_directory <- tk_choose.dir(caption = "Data directory", default = mylocalfolder)
#		landings <- read.table(file=str_c(data_directory,"/landings.csv"),sep=";")
#	}
#	return(landings)
#}
#'  DEPRECATED see database_data.R
#' load aquaculture data
#' 
#' load aquaculture data either from the database or from a csv file
#' @param from_database should the data be loaded from the database? if not from a csv file
#load_aquaculture = function(from_database = FALSE)
#{
#	if(from_database)
#	{
#		# TODO: extract data from the database
#	} else {
#		if(!exists(data_directory)) 
#			data_directory <- tk_choose.dir(caption = "Data directory", default = mylocalfolder)
#		aquaculture <- read.table(file=str_c(data_directory,"/aquaculture.csv"),sep=";")
#	}
#	return(aquaculture)
#}

# TODO convert this function... create a convert to number function
# see https://github.com/ices-eg/wg_WGEEL/issues/33
#' load stocking data
#' 
#' load stocking data either from the database or from a csv file and do conversion from kg into number
#' @param from_database should the data be loaded from the database? if not from a csv file
load_stocking = function(from_database = FALSE)
{
	if(from_database)
	{
		# TODO: extract data from the database
	} else {
		if(!exists(data_directory)) 
			data_directory <- tk_choose.dir(caption = "Data directory", default = mylocalfolder)
		stocking <- read.table(file=str_c(data_directory,"/stocking.csv"),sep=";")
	#-----------------------------------------------
	# Restocking which stages typ_id=9 (nb), =8 (kg)
	#---------------------------------------------
			
			stocking_nb <-filter(stocking,eel_typ_id%in%c(9))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
					summarize(eel_value=sum(eel_value))
			stocking_kg <-filter(stocking,eel_typ_id%in%c(8))%>%dplyr::group_by(eel_cou_code,eel_year,eel_lfs_code)%>%
					summarize(eel_value=sum(eel_value))
			
	#---------------------------------------------
	# converting kg to number
	#---------------------------------------------
			
	# individual weight for one piece (kg)
			GE_w=0.3e-3 
			GY_w = 5e-3
			Y_w=50e-3
			OG_w=20e-3
			QG_w=1e-3
			S_w=150e-3
			
			stocking_nb = stocking_nb%>%mutate(type="nb")
			stocking_nb = stocking_nb%>%mutate(eel_value_nb = eel_value)
			
			stocking_kg<-stocking_kg%>%mutate(type="kg")
			stocking_kg<- bind_rows(
					filter(stocking_kg, eel_lfs_code=='G')%>%mutate(eel_value_nb=eel_value/GE_w)
					,
					filter(stocking_kg, eel_lfs_code=='GY')%>%mutate(eel_value_nb=eel_value/GY_w)
					,
					filter(stocking_kg, eel_lfs_code=='YS')%>%mutate(eel_value_nb=eel_value/Y_w)
					,
					filter(stocking_kg, eel_lfs_code=='OG')%>%mutate(eel_value_nb=eel_value/OG_w)
					,
					filter(stocking_kg, eel_lfs_code=='QG')%>%mutate(eel_value_nb=eel_value/QG_w)
					,
					filter(stocking_kg, eel_lfs_code=='S')%>%mutate(eel_value_nb=eel_value/S_w))
			
			stocking = bind_rows(stocking_kg, stocking_nb)
	}
	return(stocking)
}

