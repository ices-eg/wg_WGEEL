# Fetch data needed to build precautionnary diagram
# 
# Author: lbeaulaton
###############################################################################

# PostgreSQL connection (if needed)
if(!exists("extract_data")) source("./database_data.R")

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
	b0 = extract_data("b0",quality=c(1,2,4),quality_check=TRUE)
	bbest = extract_data("bbest",quality=c(1,2,4),quality_check=TRUE)
	bcurrent = extract_data("bcurrent",quality=c(1,2,4),quality_check=TRUE)
  bcurrent_without_stocking = extract_data("bcurrent_without_stocking",quality=c(1,2,4),quality_check=TRUE)
	sigmaa = extract_data("sigmaa",quality=c(1,2,4),quality_check=TRUE)
	sigmaf= extract_data("sigmaf",quality=c(1,2,4),quality_check=TRUE)
	sigmah= extract_data("sigmah",quality=c(1,2,4),quality_check=TRUE)
	
	# merge data to have one data.frame
	# TODO: handling habitat, ...
	col_to_keep = c("eel_emu_nameshort", "eel_cou_code","eel_hty_code","eel_area_division", "eel_lfs_code","eel_year", "eel_value")
	#precodata = bcurrent[,col_to_keep]
	precodata = merge(bcurrent[,col_to_keep], bbest[,col_to_keep], by = col_to_keep[-length(col_to_keep)], suffixes = c(".bcurrent", ".bbest"),all=outer_join)
	n = names(precodata)
	n[n=="eel_value.bcurrent"] = "bcurrent"
	n[n == "eel_value.bbest"] = "bbest"
	names(precodata) = n
  precodata = merge(precodata, bcurrent_without_stocking[,col_to_keep], by = col_to_keep[-length(col_to_keep)],all=outer_join)
  names(precodata) = c(names(precodata)[-length(precodata)], "bcurrent_without_stocking")
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



