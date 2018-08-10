# examples to be used with maps.R
# 
# Author: cedric.briand
###############################################################################

#########################
# Examples run
########################
# map of landings in 2016, all stages, per country
draw_leaflet()

# map of glass eel landings in 2016, per emu
# as yet no code to distinguish commercial and recreational
draw_leaflet(dataset="landings",
		year=2015,
		lfs_code='G',
		coeff=600,
		map="emu")
# map of glass eel catch and landings
draw_leaflet(dataset="catch_landings",
		year=2015,
		lfs_code='G',
		coeff=600,
		map="emu")
draw_leaflet(dataset="aquaculture",
		year=2014,
		lfs_code=NULL,
		coeff=600,
		map="country")
# problem of conversion from number to kg and reverse
draw_leaflet(dataset="stocking",
		year=2014,
		lfs_code='G',
		coeff=200,
		map="country")

########################################
# create summary of which data for which year
########################################
catchexists<-landings%>%
		group_by(eel_cou_code,eel_year,eel_lfs_code)%>%summarize(n=n())

ggplot(catchexists)+geom_tile(aes(x=eel_year,y=eel_cou_code,fill=n))+
		facet_wrap(~eel_lfs_code)


