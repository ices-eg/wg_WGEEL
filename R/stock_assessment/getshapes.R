# Script to load shapes to the sharepoint for later use in R scripts
# Author: cedric.briand
###############################################################################


library(stringr) # text handling
library(rgdal)
library(raster)
library(rgeos)

mylocalfolder <- "C:/temp/SharePoint/WGEEL - 2017 Meeting Docs/06. Data/datacall"

# path to local github (or write a local copy of the files and point to them)
setwd("C:/workspace/gitwgeel")
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
# pgsql2shp -u postgres -P postgres -k -f "emu_centre_4326" -g center wgeel "select emu_nameshort,st_centroid(geom) as center from ref.tr_emu_emu where geom is not null"
# pgsql2shp -u postgres -P postgres -k -f "emu_polygons_4326" -g geom2 wgeel "select *,ST_SimplifyPreserveTopology(geom,0.1) geom2 from ref.tr_emu_emu where geom is not null"
# pgsql2shp -u postgres -P postgres -k -f "country_polygons_4326" -g geom wgeel "select * from ref.tr_country_cou"
# pgsql2shp -u postgres -P postgres -k -f "country_centre_4326" -g center wgeel "select st_centroid(geom) as center,cou_code, cou_country from ref.tr_country_cou "



###############################"
# Download coastline shapefiles
#  code from colinpmillar https://github.com/ices-eg/wg_WGSFD/blob/master/spatialPolygonsProducts/db-getshapes.R
###############################

# get european coastline shapefiles
download.file("http://data.openstreetmapdata.com/land-polygons-generalized-3857.zip",
    str_c(shpwd,"/land-polygons-generalized-3857.zip"))
unlink("data/land-polygons-generalized-3857.zip") 

# read coastline shapefiles and transform to wgs84
coast <- rgdal::readOGR("data/shapefiles/land-polygons-generalized-3857", "land_polygons_z5", verbose = FALSE)
unlink("data/shapefiles/land-polygons-generalized-3857", recursive = TRUE)

coast <- rgdal::spTransform(coast, CRS("+init=epsg:4326"))

# trim coastline to extent for ploting
bbox <- as(raster::extent(emusp0), "SpatialPolygons")
raster::proj4string(bbox) <- rgdal::CRS("+init=epsg:4326")
coast <- rgeos::gIntersection(coast, bbox, byid = TRUE)
coast <- rgeos::gUnaryUnion(coast)
coast <- as(coast, "SpatialPolygonsDataFrame")
