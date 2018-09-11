# Fetch data needed to build precautionnary diagram
# 
# Author: lbeaulaton
###############################################################################

# PostgreSQL connection (if needed)
if(!exists("extract_data")) source("R/database_interaction/database_data.R")

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details Function developped by clarisse to get all combinasons with null values
#' this is for tables
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname extract_precodata
#' @export 
#' 
extract_precodata = function(outer_join=T){
	b0 = extract_data("B0")
	bbest = extract_data("Bbest")
	bcurrent = extract_data("Bcurrent")
	sigmaa = extract_data("Sigma A")
	sigmaf= extract_data("Sigma F")
	sigmah= extract_data("Sigma H")
	
	# merge data to have one data.frame
	# TODO: handling habitat, ...
	col_to_keep = c("eel_emu_nameshort", "eel_cou_code","eel_hty_code","eel_area_division", "eel_lfs_code","eel_year", "eel_value")
	#precodata = bcurrent[,col_to_keep]
	precodata = merge(bcurrent[,col_to_keep], bbest[,col_to_keep], by = col_to_keep[-length(col_to_keep)], suffixes = c(".bcurrent", ".bbest"),all=outer_join)
	n = names(precodata)
	n[n=="eel_value.bcurrent"] = "bcurrent"
	n[n == "eel_value.bbest"] = "bbest"
	names(precodata) = n
	precodata = merge(precodata, b0[,col_to_keep], by = col_to_keep[-length(col_to_keep)],all=outer_join)
	names(precodata) = c(names(precodata)[-length(precodata)], "b0")
	precodata = merge(precodata, sigmaa[,col_to_keep], by = col_to_keep[-length(col_to_keep)],all=outer_join)
	names(precodata) = c(names(precodata)[-length(precodata)], "suma")
	precodata = merge(precodata, sigmaf[,col_to_keep], by = col_to_keep[-length(col_to_keep)],all=outer_join)
	names(precodata) = c(names(precodata)[-length(precodata)], "sumf")
	precodata = merge(precodata, sigmah[,col_to_keep], by = col_to_keep[-length(col_to_keep)],all=outer_join)
	names(precodata) = c(names(precodata)[-length(precodata)], "sumh")

  return(precodata)
}


