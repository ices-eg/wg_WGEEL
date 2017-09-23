# Script to load shapes from sharepoint
# Author: cedric.briand
###############################################################################


require(stringr) # text handling
library(sqldf) # mimict sql queries in a data.frame
library(RPostgreSQL) # one can use RODBC, here I'm using direct connection via the sqldf package
# loading RPostgresSQL ensures that postgres is used as a default driver by sqldf
# setting options to access postgres using sqldf
library(plyr)# join fuction
library(sp)
library(maptools)
library(maps)
library(ggplot2)
library(scales)# no longer loaded automatically with ggplot2


mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"

# path to local github (or write a local copy of the files and point to them)
setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL")
# path to shapes on the sharepoint
shpwd <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/shp"
########################################
# Exporting shapefiles on the sharepoint from postgis
#######################################

# the export of shapes is done in command line
# it uses the simplifyPreservetopology argument to make map less heavy. Note that using simplify does not work with
# the function fortify from ggplot as the polygons often loose their topology.
# all the following graphs are in postgis so I'm saving them as shapefiles in command lines

# cd C:\temp\SharePoint\WGEEL - 2017 Meeting Docs\06. Data\shp
# pgsql2shp -u postgres -P postgres -k -f "emu_centre_4326" -g centre wgeel "select emu_nameshort,x,y,centre from ref.tr_emusplit_ems"
# pgsql2shp -u postgres -P postgres -k -f "t_emu_polygons_4326" -g geom2 wgeel "select *,ST_SimplifyPreserveTopology(geom,0.1) geom2 from ref.tr_emu_emu where geom is not null"
# pgsql2shp -u postgres -P postgres -k -f "t_country_coun_4326" -g geom wgeel "select * from ref.tr_country_cou"

emu_c=rgdal::readOGR(str_c(shpwd,"/","emu_centre_4326.shp")) # a spatial object of class spatialpointsdataframe
# this corresponds to the center of each emu.
country_c=rgdal::readOGR(str_c(shpwd,"/","t_country_coun_4326.shp"))# a spatial object of class sp
# this is the map of coutry centers, to overlay points for each country
emusp0=rgdal::readOGR(str_c(shpwd,"/","t_emu_polygons_4326.shp")) # a spatial object of class sp
# this is the map of the emu.

plot(emusp0)
