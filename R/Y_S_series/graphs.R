# TODO: Add comment
# 
# Author: cedricbriandgithub
###############################################################################

CY<-2019 # current year ==> dont forget to update the graphics path below


#--------------------------------
# get your current name 
#--------------------------------
getUsername <- function(){
	name <- Sys.info()[["user"]]
	return(name)
}


	# I have two password in the R.site of c:/program files/R... so I don't need no prompt
	
	#baseODBC=c("wgeel","wgeel",passwordwgeel) #"w3.eptb-vilaine.fr" "localhost" "wgeel" "wgeel_distant" 
	options(sqldf.RPostgreSQL.user = "wgeel", 
			sqldf.RPostgreSQL.password = passwordwgeel,
			sqldf.RPostgreSQL.dbname = "wgeel",
			sqldf.RPostgreSQL.host = "localhost", # "localhost"
			sqldf.RPostgreSQL.port = 5435) # 5435 launch the ssh tunnel
	setwd("C:/workspace/gitwgeel/R/recruitment")
	
	wd <- getwd()
	wddata <- gsub("C:/workspace/gitwgeel/R","C:/workspace/wgeeldata",wd)
	datawd <- str_c(wddata,"/",CY,"/data/")
	imgwd <- str_c(wddata,"/",CY,"/image/")
	tabwd <- str_c(wddata,"/",CY,"/table/")
	shpwd <- str_c("C:/workspace/wgeeldata/shp/") 
	shinywd <- "C:/workspace/gitwgeel/R/shiny_data_visualisation/shiny_dv/data/recruitment/"


query='SELECT 
		das_id,
		das_value,       
		das_year,
		das_comment,
		/* 
		-- below those are data on effort, not used yet
		
		das_effort, 
		ser_effort_uni_code,       
		das_last_update,
		*/
		/* 
		-- this is the id on quality, used from 2018
		-- to remove the data with problems on quality from the series
		-- see WKEEKDATA (2018)
		das_qal_id,
		*/ 
		ser_id,            
		cou_order,
		ser_nameshort,
		ser_area_division,
		ser_qal_id,
		/* 
		-- this is the id on quality at the level of individual lines of data
		-- checks are done later to ensure provide a summary of the number of 0 (missing data),
		-- 3 data discarded, 4 used but with doubts....
		*/ 
		das_qal_id,
		das_last_update,
		f_subarea,
		lfs_code,          
		lfs_name
		from datawg.t_dataseries_das 
		join datawg.t_series_ser on das_ser_id=ser_id
		left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
		left join ref.tr_faoareas on ser_area_division=f_division
		left join ref.tr_country_cou on cou_code = ser_cou_code
		where ser_typ_id=2'

wger_init=sqldf(query) # (wge)el (r)ecruitment data
wger_init<-chnames(wger_init,
		c("das_id","das_value","das_year","ser_nameshort","ser_area_division","lfs_name"),
		c("id","value","year","site","area_division","lifestage"))
