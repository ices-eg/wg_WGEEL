###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# 
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
CY<-2021
# function to load packages if not available
load_library=function(necessary) {
	if(!all(necessary %in% installed.packages()[, 'Package']))
		install.packages(necessary[!necessary %in% installed.packages()[, 'Package']], dep = T)
	for(i in 1:length(necessary))
		library(necessary[i], character.only = TRUE)
}
###########################
# Loading necessary packages
############################
load_library("sqldf")
load_library("RPostgreSQL")
load_library("stacomirtools")
load_library("stringr")
# Issue still open https://github.com/awalker89/openxlsx/issues/348
#load_library("openxlsx")
load_library("XLConnect")
load_library("sf")
load_library("ggmap")

#############################
# here is where the script is working change it accordingly
##################################
wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata = paste0(getwd(), "/data/datacall_template/")
load(str_c(getwd(),"/data/ccm_seaoutlets.rdata")) #polygons off ccm seaoutlets WGS84


###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
options(sqldf.RPostgreSQL.user = userwgeel, 
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5435)



#' function to create the series excel tables for data call
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country code, for instance "SW"
#' @param name, the name of the file (without .xlsx) used as template and in the destination folders
#' country='IE'; name="Eel_Data_Call_2021_Annex_time_series"; ser_typ_id=1
create_datacall_file_series <- function(country, name, ser_typ_id){
	if (!is.numeric(ser_typ_id)) stop("ser_typ_id must be numeric")
	
	
	# load file -------------------------------------------------------------
	
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	
	key <- c("1" = "Recruitment","2" = "Yellow_standing_stock","3" = "Silver")
	suffix <- key[ser_typ_id]
	namedestinationfile <- str_c(name,"_",country, "_",suffix, ".xlsx")	
	if (ser_typ_id==1) namedestinationfile <-gsub("Annex","Annex1", namedestinationfile)
	if (ser_typ_id==2) namedestinationfile <-gsub("Annex","Annex2", namedestinationfile)
	if (ser_typ_id==3) namedestinationfile <-gsub("Annex","Annex3", namedestinationfile)
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	#wb = openxlsx::loadWorkbook(templatefile)
	wb = loadWorkbook(templatefile)
	
	# series description -------------------------------------------------------
	
	t_series_ser<-sqldf(str_c("SELECT  
							t_series_ser.ser_id, 
							t_series_ser.ser_nameshort, 
							t_series_ser.ser_namelong, 
							t_series_ser.ser_typ_id, 
							t_series_ser.ser_effort_uni_code, 
							t_series_ser.ser_comment, 
							t_series_ser.ser_uni_code, 
							t_series_ser.ser_lfs_code, 
							t_series_ser.ser_hty_code, 
							t_series_ser.ser_locationdescription, 
							t_series_ser.ser_emu_nameshort, 
							t_series_ser.ser_cou_code, 
							t_series_ser.ser_area_division, 
							t_series_ser.ser_tblcodeid, 
							t_series_ser.ser_x, 
							t_series_ser.ser_y, 
							t_series_ser.ser_sam_id,
							t_series_ser.ser_qal_id,
							t_series_ser.ser_qal_comment,
							t_series_ser.ser_ccm_wso_id,
							t_series_ser.ser_sam_gear,
							t_series_ser.ser_distanceseakm,
							t_series_ser.ser_method							
							FROM 
							datawg.t_series_ser
							WHERE ser_cou_code='",country,"' ",
					"AND ser_typ_id ='", ser_typ_id, "';"))
# converting some information to latin1, necessary for latin1 final user
	
	
	if (nrow(t_series_ser)>0){
		
		t_series_ser[,4]<-iconv(t_series_ser[,4],from="UTF8",to="latin1")
		t_series_ser[,11]<-iconv(t_series_ser[,11],from="UTF8",to="latin1")
		t_series_ser[,7]<-iconv(t_series_ser[,7],from="UTF8",to="latin1")
#		openxlsx::writeData(wb, sheet = "series_info", x=t_series_ser[,
#						c("ser_nameshort",
#								"ser_namelong",
#								"ser_typ_id",
#								"ser_effort_uni_code",
#								"ser_comment",
#								"ser_uni_code",
#								"ser_lfs_code",
#								"ser_hty_code",
#								"ser_locationdescription",
#								"ser_emu_nameshort",
#								"ser_cou_code",
#								"ser_area_division",
#								"ser_tblcodeid",
#								"ser_x",
#								"ser_y",
#								"ser_sam_id",
#								"ser_sam_gear",
#								"ser_distanceseakm",
#								"ser_method")		
#				] )
	writeWorksheet(wb, sheet = "series_info", data=t_series_ser[,
						c("ser_nameshort",
								"ser_namelong",
								"ser_typ_id",
								"ser_effort_uni_code",
								"ser_comment",
								"ser_uni_code",
								"ser_lfs_code",
								"ser_hty_code",
								"ser_locationdescription",
								"ser_emu_nameshort",
								"ser_cou_code",
								"ser_area_division",
								"ser_tblcodeid",
								"ser_x",
								"ser_y",
								"ser_sam_id",
								"ser_sam_gear",
								"ser_distanceseakm",
								"ser_method"	
								)		
				] )
	}
	
	
# station data ----------------------------------------------
	
	station <- sqldf("select * from ref.tr_station")
	station$Organisation <-iconv(station$Organisation,from="UTF8",to="latin1")
	# drop  tblCodeID Station_Code
	
	if (nrow(t_series_ser)>0){
		station <- dplyr::left_join(t_series_ser[,c("ser_nameshort"),drop=F], station, by=c("ser_nameshort"="Station_Name"))
		station <- station[,c("ser_nameshort",  "Organisation")]
		
		if (nrow(station)>0){
			
			#openxlsx::writeData(wb, sheet = "station", station, startRow = 1)
		   writeWorksheet(wb, sheet = "station", data=station, startRow = 1)
		}
	}
	
# existing series data ----------------------------------------	
	
	dat <- sqldf(str_c("select 
							ser_nameshort, 
							das_id,
							das_ser_id,
							das_value,
							das_year,
							das_comment,
							das_effort,
							das_qal_id
							from datawg.t_dataseries_das",
					" JOIN datawg.t_series_ser ON ser_id = das_ser_id",
					" WHERE ser_typ_id=",ser_typ_id,
					" AND ser_cou_code='",country,"' ",
					" ORDER BY das_ser_id, das_year ASC"))
	
	if (nrow(dat)> 0){
		#openxlsx::writeData(wb, sheet = "existing_data", dat, startRow = 1)
		writeWorksheet(wb, dat,  sheet = "existing_data")
	}
	
# new data ----------------------------------------------------
# extract missing data from CY-10
	if (nrow(dat)> 0){
		new_data <- dat %>% dplyr::filter(das_year>=(CY-10)) %>%
				dplyr::select(ser_nameshort,das_year,das_value, das_comment, das_effort) %>%
				tidyr::complete(ser_nameshort,das_year=(CY-10):CY) %>%
				dplyr::filter(is.na(das_value) & is.na(das_comment)) %>%
				dplyr::arrange(ser_nameshort, das_year)
		
		if (nrow(new_data)> 0){
			#openxlsx::writeData(wb, sheet = "new_data", new_data, startRow = 1)
			writeWorksheet(wb, new_data,  sheet = "new_data")
		}
	}
# biometry data existing ------------------------------------------
	
	
	biom0 <- sqldf(str_c("select ser_nameshort, 
							bio_year,
							bio_length,
							bio_weight,
							bio_age,
							bio_perc_female,
							bio_length_f,
							bio_weight_f,
							bio_age_f,
							bio_length_m,
							bio_weight_m,
							bio_age_m,
							bio_comment,
							bio_last_update,
							bio_qal_id,
							bio_number,
							bis_g_in_gy,
							bis_ser_id
							FROM datawg.t_series_ser  
							LEFT JOIN datawg.t_biometry_series_bis ON ser_id = bis_ser_id",					
					" WHERE ser_typ_id=",ser_typ_id,
					" AND ser_cou_code='",country,"'",
					" ORDER BY bis_ser_id, bio_year  ASC"))
	
	biom <- biom0[!is.na(biom0$bio_year),]
	if (nrow(biom)> 0){	
		#openxlsx::writeData(wb, sheet = "existing_biometry", biom, startRow = 1)
		writeWorksheet(wb, biom,  sheet = "existing_biometry")
	} 
	
	
# biometry data new data ------------------------------------------
	
	
	if (nrow(biom0) >0 ){
		newbiom <- biom0 %>% 
				dplyr::mutate_at(.vars="bio_year",tidyr::replace_na,replace=CY-1) %>%
				dplyr::filter(bio_year>=(CY-10)) %>%
				tidyr::complete(ser_nameshort,bio_year=(CY-10):CY) %>%
				dplyr::filter(is.na(bio_length) & is.na(bio_weight) & is.na(bio_age) & is.na(bis_g_in_gy)) %>%
				dplyr::arrange(ser_nameshort, bio_year)
		
		if (nrow(newbiom)>0) {
			#openxlsx::writeData(wb, sheet = "new_biometry", newbiom, startRow = 1)
			writeWorksheet(wb, newbiom,  sheet = "new_biometry")	
		}
	}
	
# maps ---------------------------------------------------------------
#st_crs(ccm) 
	if (nrow(t_series_ser)>0){
		for (i in 1:nrow(t_series_ser)){
			#turn a pgsql array into an R vector for ccm_wso_id
			pols_id=eval(parse(text=paste("c(",gsub(pattern="\\{|\\}",replacement='',t_series_ser$ser_ccm_wso_id[i]),")")))
			# NOT USED IN openxlsx
			#createNamedRegion(wb, sheet= "station_map", name = paste("station_map_",i,sep=""), cols=2,rows=(i-1)*40+2)
			createName(wb, name = paste("station_map_",i,sep=""), formula = paste("station_map!$B$",(i-1)*40+2,sep=""))
			pol=subset(ccm,ccm$wso_id %in% pols_id)
			st_crs(pol) <- 4326 
			if (nrow(pol)>0){
				bounds <- matrix(st_bbox(pol),2,2)
				bounds[,1]=pmin(bounds[,1],c(t_series_ser$ser_x[i],t_series_ser$ser_y[i]))-0.5
				bounds[,2]=pmax(bounds[,2],c(t_series_ser$ser_x[i],t_series_ser$ser_y[i]))+0.5
				my_map=get_map(bounds, maptype = "terrain", source="stamen",zoom=7) 
				g <- ggmap(my_map,maprange = TRUE, extent = "normal") + 
						geom_sf(data=pol, inherit.aes = FALSE,fill=NA,color="red")+
						geom_point(data=t_series_ser[i,],aes(x=ser_x,y=ser_y),col="red")+
						ggtitle(t_series_ser$ser_nameshort[i])+
						xlab("")+ylab("")
			} else if (!any(is.na(c(t_series_ser$ser_x[i],t_series_ser$ser_y[i])))){
				bounds <- rbind(rep(t_series_ser$ser_x[i],2), rep(t_series_ser$ser_y[i],2))
				bounds[,1]=bounds[,1]-1
				bounds[,2]=bounds[,2]+1
				my_map <- get_stamenmap(bounds, maptype = "terrain", source="stamen",zoom=7)
				pol=st_crop(ccm,xmin=bounds[1,1],ymin=bounds[2,1],xmax=bounds[1,2],ymax=bounds[2,2])
				st_crs(pol) <- 4326 
				g <- ggmap(my_map) + 
						geom_point(data=t_series_ser[i,],aes(x=ser_x,y=ser_y),col="red")+
						ggtitle(t_series_ser$ser_nameshort[i])+
						xlab("")+
						ylab("")+
						geom_sf(data=pol, inherit.aes = FALSE,fill=NA,color="black")
			} else {
				g=ggplot()+ggtitle(t_series_ser$ser_nameshort[i])
			}
			ggsave(paste(tempdir(),"/",t_series_ser$ser_nameshort[i],".png",sep=""),g,width=20/2.54,height=16/2.54,units="in",dpi=150)
# OPENXLSX
#			insertImage(wb, 
#					sheet= "station_map", 
#					startRow=(i-1)*40+2,
#					file=paste(tempdir(),"/",t_series_ser$ser_nameshort[i],".png",sep="")
#					)
			
			addImage(wb,paste(tempdir(),"/",t_series_ser$ser_nameshort[i],".png",sep=""),name=paste("station_map_",i,sep=""),originalSize=TRUE)
		}
	}

	#saveWorkbook(wb, file = destinationfile, overwrite = TRUE)
	saveWorkbook(wb, file = destinationfile)
	cat("work finished\n")
}


# recruitment ---------------------------------------------------

country_code <- c("DK","ES","EE","IE","SE","GB","FI","IT","GR","DE","LV","FR","NL","LT","PT",
		"NO","PL","SI","TN","TR","BE")

for (country in country_code){
	cat("country: ",country,"\n")
	create_datacall_file_series(country, 
			name="Eel_Data_Call_2021_Annex_time_series", 
			ser_typ_id=1)
}



# Yellow ---------------------------------------------------


for (country in country_code ){
	cat("country: ",country,"\n")
	create_datacall_file_series(country, 
			name="Eel_Data_Call_2021_Annex_time_series", 
			ser_typ_id=2)
}


# Silver ---------------------------------------------------


for (country in country_code ){
	cat("country: ",country,"\n")
	create_datacall_file_series(country, 
			name="Eel_Data_Call_2021_Annex_time_series", 
			ser_typ_id=3)
}
