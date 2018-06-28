# Function to load data that can be requested by the user interface 
# 
# Author: lbeaulaton
###############################################################################

#' @title load maps
#' @description load needed maps for shiny App (EMU, country)
#' @param full_load should the maps be loaded from source file? if not from Rdata file
#' @param to_save should maps be save into a Rdata file to ease the loading next time
load_maps = function(full_load = FALSE, to_save = FALSE)
{
	if(!require(stringr)) install.packages("stringr") ; require(stringr)
	if(!require(sp)) install.packages("sp") ; require(sp)
	if(full_load)
	{
		if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
		if(!require(stacomirtools)) install.packages("stacomirtools") ; require(stacomirtools)
		#path to shapes on the sharepoint
		shpwd = tk_choose.dir(caption = "Shapefile directory", default = data_directory)
		emu_c <<- rgdal::readOGR(str_c(shpwd,"/","emu_centre_4326.shp")) # a spatial object of class spatialpointsdataframe
		emu_c@data <<- stacomirtools::chnames(emu_c@data,"emu_namesh","emu_nameshort") # names have been trucated
				# this corresponds to the center of each emu.
		country_p <<- rmapshaper::ms_simplify(rgdal::readOGR(str_c(shpwd,"/","country_polygons_4326.shp")), keep = 0.01)# a spatial object of class sp, symplified to be displayed easily
				# this is the map of coutry centers, to overlay points for each country
				# beware this takes ages ...
		emu_p <<- rmapshaper::ms_simplify(rgdal::readOGR(str_c(shpwd,"/","emu_polygons_4326.shp")), keep = 0.7) # a spatial object of class sp, symplified to be displayed easily
				# this is the map of the emu.
		country_c <<- rgdal::readOGR(str_c(shpwd,"/","country_centre_4326.shp"))
				# transform spatial point dataframe to 
		if(to_save) save(emu_c,country_p,emu_p,country_c,file=str_c(data_directory,"/maps_for_shiny.Rdata"))
	} else 
	{
		if(!exists("data_directory")) 
			data_directory <- tk_choose.dir(caption = "Data directory", default = mylocalfolder)
		load(file=str_c(data_directory,"/maps_for_shiny.Rdata"), envir = .GlobalEnv)
	}
}

#' load landings data
#' 
#' load landings data either from the database or from a csv file
#' @param from_database should the data be loaded from the database? if not from a csv file
load_landings = function(from_database = FALSE)
{
	if(from_database)
	{
		#TODO: extract data from the database
	} else {
		 if(!exists(data_directory)) 
			 #TODO: ask data_directory
			cat("to be implemented")
		landings <- read.table(file=str_c(data_directory,"/landings.csv"),sep=";")
	}
	return(landings)
}

#' load aquaculture data
#' 
#' load aquaculture data either from the database or from a csv file
#' @param from_database should the data be loaded from the database? if not from a csv file
load_aquaculture = function(from_database = FALSE)
{
	if(from_database)
	{
		#TODO: extract data from the database
	} else {
		if(!exists(data_directory)) 
			#TODO: ask data_directory
			cat("to be implemented")
			aquaculture <- read.table(file=str_c(data_directory,"/aquaculture.csv"),sep=";")
	}
	return(aquaculture)
}

#' load stocking data
#' 
#' load stocking data either from the database or from a csv file and do conversion from kg into number
#' @param from_database should the data be loaded from the database? if not from a csv file
load_stocking = function(from_database = FALSE)
{
	if(from_database)
	{
		#TODO: extract data from the database
	} else {
		if(!exists(data_directory)) 
			#TODO: ask data_directory
			cat("to be implemented")
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