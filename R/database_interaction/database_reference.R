# retrieve reference tables from the database
# 
# Author: lbeaulaton
###############################################################################

# give the correspondance by "human readable" name and table name in the database
list_ref_table = data.frame(table_caption =c("Country", "EMU", "FAO area", "Habitat type", "ICES ecoregion", "Life stage", "Quality", "Sampling type", "Sea", "Station", "Type of series", "Unit") , table_dbname = c("tr_country_cou", "tr_emu_emu", "tr_faoareas", "tr_habitattype_hty", "tr_ices_ecoregions", "tr_lifestage_lfs", "tr_quality_qal", "tr_samplingtype_sam", "tr_sea_sea", "tr_station", "tr_typeseries_typ", "tr_units_uni"))
list_ref_table = list_ref_table[order(list_ref_table$table_caption), ]

# function to extract one reference table
extract_ref = function(table_caption)
{
	# check that the caption is recognised
	if(sum(table_caption %in% list_ref_table$table_caption) == 0)
		stop(paste("table_caption should be one of: ", list_ref_table$table_caption))
match
}