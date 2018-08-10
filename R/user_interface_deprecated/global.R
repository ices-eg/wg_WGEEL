# Name : global.R
# Date : 02/07/2018
# Author: cedric.briand
###############################################################################

#########################
# loads shiny packages
########################
if(!require(shiny)) install.packages("shiny") ; require(shiny)
if(!require(DT)) install.packages("DT") ; require(DT)


ref_wd <- wg_choose.dir(caption = "Reference tables directory", default = mylocalfolder)
country_ref = read.csv2(str_c(ref_wd,"/","tr_country_cou.csv"))
#emu_ref = read.csv2(str_c(ref_wd,"/","tr_country_cou.csv"))

#########################
# functions
########################
extract_data = function(dataset, life_stage, country = NULL)
{
  if(is.null(country)) country = as.character(country_ref$cou_code)
  extracted_data = filter(get(dataset),eel_lfs_code%in%life_stage, eel_cou_code%in% country)%>%dplyr::group_by(eel_cou_code,eel_year)%>%
	  summarize(eel_value=sum(eel_value,na.rm=TRUE))
  return(extracted_data)
}

#test
extract_data("landings", life_stage = "S")

