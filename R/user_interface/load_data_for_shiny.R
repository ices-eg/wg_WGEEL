# Function to load data that can be requested by the user interface 
# 
# Author: lbeaulaton
###############################################################################

load_maps = function(full_load = FALSE, to_save = FALSE)
{
	if(!require(stringr)) install.packages("stringr") ; require(stringr)
	if(!require(sp)) install.packages("sp") ; require(sp)
	if(full_load)
	{
		if(!require(tcltk)) install.packages("tcltk") ; require(tcltk)
		if(!require(stacomirtools)) install.packages("stacomirtools") ; require(stacomirtools)
		#path to shapes on the sharepoint
		shpwd = tk_choose.dir(caption = "Shapefile directory", default = mylocalfolder)
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
		if(to_save) save(emu_c,country_p,emu_p,country_c,file=str_c(mylocalfolder,"/maps_for_shiny.Rdata"))
	} else 
	{
		load(file=str_c(mylocalfolder,"/maps_for_shiny.Rdata"), envir = .GlobalEnv)
	}
}

