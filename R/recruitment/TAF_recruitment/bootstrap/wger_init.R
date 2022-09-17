#' Annual recruitment
#'
#' Table of raw values of annual recruitment series

#'

#' @name wger_init

#' @format Rdata

#' @tafOriginator wgeel

#' @tafYear 2022

#' @tafPeriod 1900-2022

#' @tafAccess Public

#' @tafSource script



options(sqldf.RPostgreSQL.user = cred$user, 
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = cred$dbname,
		sqldf.RPostgreSQL.host = cred$host, # "localhost"
		sqldf.RPostgreSQL.port = 5432) # 5435 launch the ssh tunnel

##########################"
# Description of the series -------------------------------
##########################

query ='select 
		ser_id, ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code,
		ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription,
		ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y,             
		ser_sam_id, ser_qal_id, ser_qal_comment,     
		"tblCodeID", "Station_Code", "Country", "Organisation", "Station_Name",       
		cou_code, cou_country, cou_order, cou_iso3code,
		lfs_code, lfs_name, lfs_definition,              
		ocean,  subocean, f_area, f_subarea,  f_division
		from datawg.t_series_ser 
		left join ref.tr_station on ser_tblcodeid=tr_station."tblCodeID"
		left join ref.tr_country_cou on cou_code=ser_cou_code 
		left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
		left join ref.tr_faoareas on ser_area_division=f_division
		where ser_typ_id=1'

R_stations= sqldf(query)



##########################
# Main data from the series -------------------------------
##########################

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
		ser_y,
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
		left join ref.tr_country_cou on  cou_code=ser_cou_code
		where ser_typ_id=1'

wger_init=sqldf(query) # (wge)el (r)ecruitment data
wger_init <- chnames(wger_init,
		c("das_id","das_value","das_year","ser_nameshort","ser_area_division","lfs_name"),
		c("id","value","year","site","area_division","lifestage"))


query <- paste0("SELECT * FROM datawg.t_series_ser join  datawg.t_dataseries_das ON das_ser_id = ser_id
				WHERE das_year in(", paste(CY,CY-1,sep=",",collapse=","),") AND das_qal_id IN (0,3,4) and ser_typ_id=1;")
last_years_with_problem <- sqldf(query)

##########################
# When were the series included -------------------------------
##########################
query='SELECT * FROM datawg.t_seriesglm_sgl'
inclusion <- sqldf(query)
############################################################################
# Rebuilding areas used by wgeel (North Sea, Elswhere Europe) from area_divisions
# See Ices (2008) for the reason why we need to do that
# We cannot use just one series, as the series from the North Sea have dropped more
# rapidly than the others, and are now at a much lower level.
# Some of that drop might be explained by decreasing catch in some of the semi-commercial
# catch and trap and transport series (Ems, Vidaa) but it also concerns fully scientific
# Estimates....
###############################################################################
wger_init[,"area"] <- NA
# below these are area used in some of the scripts see wgeel 2008 and Willem's Analysis 
# but currently wgeel only uses two areas so the following script is kept for memory
# but mostly useless
wger_init$area2[wger_init$f_subarea%in%'27.4'] <- "North Sea"
wger_init$area2[wger_init$f_subarea%in%'27.3'] <- "Baltic"
wger_init$area2[wger_init$f_subarea%in%c('27.6','27.7','27.8','27.9')] <- "Atlantic"
wger_init$area2[wger_init$f_subarea%in%c('37.1','37.2','37.3')] <- "Mediterranean Sea"
wger_init[wger_init$area2%in%c("Atlantic","Mediterranean Sea"),"area"] <- "Elsewhere Europe"
# We consider that the series of glass eel recruitment in the Baltic are influenced
# similarly in the Baltic and North Sea. This has no effect on Baltic data
wger_init[wger_init$area2%in%c("Baltic","North Sea"),"area"] <- "North Sea"

#check if all series have been assign to an area
if (sum(is.na(wger_init$area))>0) {
	
	cat("sites with qal_id 1 or 4 and no ref")
	wger_init %>% dplyr::filter(is.na(area)&(ser_qal_id==1|ser_qal_id==4)) %>% dplyr::select(site) %>% distinct()
	cat("sites with qal_id 0 and no ref")
	wger_init %>% dplyr::filter(is.na(area)&ser_qal_id!=1) %>% dplyr::select(site) %>% distinct()
	stop("At least one series has not been affected to an area, stop this script NOW and check !!!")
}
wger_init$area <- as.factor(wger_init$area)
# We will also need this for summary tables per recruitment site, here we go straight to 
# the result
R_stations[,"area"] <- NA
R_stations$area[R_stations$f_subarea%in%c('27.4','27.3')] <- "North Sea"
R_stations$area[R_stations$f_subarea%in%c('27.6','27.7','27.8','27.9','37.1','37.2','37.3')] <- "Elsewhere Europe"
#REMOVE THIS !!!!!!!!!!!
#R_stations$area[is.na(R_stations$area)]<-"Elsewhere Europe"
#wger_init$area[is.na(wger_init$area)]<-"Elsewhere Europe"


stopifnot(all(!is.na(R_stations$f_subarea)))

# Check that there was no error in the query (while joining foreign table)
stopifnot(all(!duplicated(wger_init$id)))
# creates some variables
wger_init$decade=factor(trunc(wger_init$year/10)*10)
wger_init$year_f=factor(wger_init$year)
wger_init$decade=factor(wger_init$decade,level=sort(unique(as.numeric(as.character(wger_init$decade)))))
wger_init$ldata=log(wger_init$value)
wger_init$lifestage=as.factor(wger_init$lifestage)

# This is a view (like the result of a query) showing a summary of each series, including first year, last year,
# and duration
statseries <- sqldf('select site,namelong,min,max,duration,missing,life_stage,sampling_type,unit,habitat_type,"order",series_kept
				from datawg.series_summary where ser_typ_id=1')
# these data will 
save(wger_init,file=str_c(datawd,"wger_init.Rdata"))
save(statseries,file=str_c(datawd,"statseries.Rdata"))
save(R_stations,file=str_c(datawd,"R_stations.Rdata"))
save(last_years_with_problem,file=str_c(datawd,"last_years_with_problem.Rdata"))
write.table(R_stations, sep=";",file=str_c(datawd,"R_stations.csv"))


save(wger_init,file=str_c(shinywd,"wger_init.Rdata"))
save(statseries,file=str_c(shinywd,"statseries.Rdata"))
save(R_stations,file=str_c(shinywd,"R_stations.Rdata"))
save(inclusion, file=str_c(shinywd,"inclusion.Rdata"))
save(wger_init, file="wger_init.Rdata")
