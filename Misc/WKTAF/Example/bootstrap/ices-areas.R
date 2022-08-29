library(icesTAF)
library(sf)
download(
  "http://gis.ices.dk/shapefiles/ICES_areas.zip"
)

unzip("ICES_areas.zip")
unlink("ICES_areas.zip")

areas <- st_read("ICES_Areas_20160601_cut_dense_3857.shp")

# write as csv
st_write(
  areas, "ices-areas.csv",
  layer_options = "GEOMETRY=AS_WKT"
)

unlink(dir(pattern = "ICES_Areas_20160601_cut_dense_3857"))
