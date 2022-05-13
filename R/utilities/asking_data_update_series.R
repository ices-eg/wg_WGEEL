###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# 
# Author Cedric Briand
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
library(readxl)
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

load_library("RPostgres")
load_library("DBI")

library("DBI")

load_library("stacomirtools")
load_library("stringr")
# Issue still open https://github.com/awalker89/openxlsx/issues/348
#load_library("openxlsx")
load_library("XLConnect")
load_library("sf")
load_library("ggmap")
load_library("getPass")

#############################
# here is where the script is working change it accordingly
# one must be at the head of wgeel git 
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
if( !exists("pois")) pois <- getPass(msg="main password")
# host <- decrypt_string(hostdistant,pois)
host <- "localhost"
userwgeel <- decrypt_string(userdistant,pois)
passwordwgeel <- passwordlocal
con=dbConnect(RPostgres::Postgres(), 		
		dbname="wgeel", 		
		host="localhost",
		port=5432, 		
		user= userwgeel, 		
		password= passwordwgeel)



#' function to create the series excel tables for data call
#' 
#' @note this function writes the xl sheet for each country
#' it creates series metadata and series info for ICES station table
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country code, for instance "SW"
#' @param name, the name of the file (without .xlsx) used as template and in the destination folders
#' country='IE'; name="Eel_Data_Call_2021_Annex_time_series"; ser_typ_id=1
create_datacall_file_series <- function(country, name, ser_typ_id, type="series"){
	if (!is.numeric(ser_typ_id)) stop("ser_typ_id must be numeric")
	
	
	# load file -------------------------------------------------------------
	
	dir.create(str_c(wddata,country),showWarnings = FALSE) # show warning= FALSE will create if not exist	
	nametemplatefile <- str_c(name,".xlsx")
	templatefile <- file.path(wddata,"00template",nametemplatefile)
	
	key <- c("1" = "Recruitment","2" = "Yellow_standing_stock","3" = "Silver")
	suffix <- key[ser_typ_id]
	namedestinationfile <- str_c(name,"_",country, "_",suffix, ".xlsx")	
	if (ser_typ_id==1 & type=="series") namedestinationfile <-gsub("Annex","Annex1", namedestinationfile)
	if (ser_typ_id==2 & type=="series") namedestinationfile <-gsub("Annex","Annex2", namedestinationfile)
	if (ser_typ_id==3 & type=="series") namedestinationfile <-gsub("Annex","Annex3", namedestinationfile)
	destinationfile <- file.path(wddata, country, namedestinationfile)		
	
	#wb = openxlsx::loadWorkbook(templatefile)
	wb = loadWorkbook(templatefile)
	
	# series or sampling infodescription -------------------------------------------------------
	
	t_series_ser<- dbGetQuery(con, str_c("SELECT *			FROM ",
	           ifelse(type=="series",
	                  "datawg.t_series_ser ",
	                  "datawg.t_samplinginfo_sai "),
	           "WHERE ",
	           ifelse(type=="series","ser_cou_code='","sai_cou_code='"),
	           country,"' ",
	           ifelse(type=="series"," AND ser_typ_id ='", ser_typ_id, "';", ""))) %>%		# maybe this is only needed on windows 
	  select(-any_of("geom","ser_dts_datasource","sai_dts_datasource")) %>%		# maybe this is only needed on windows 
	  mutate_at(ends_with("nameshort"), ~iconv(.,from="UTF-8",to="latin1")) %>%		# maybe this is only needed on windows 
	  mutate_at(ends_with("comment"), ~iconv(.,from="UTF-8",to="latin1")) %>% 		# maybe this is only needed on windows 
	  mutate_at(ends_with("locationdescription"), ~iconv(.,from="UTF-8",to="latin1")) %>% 		# maybe this is only needed on windows 
	  mutate_at(ends_with("method"), ~iconv(.,from="UTF-8",to="latin1")) 		# maybe this is only needed on windows 

	  
	

	
	if (nrow(t_series_ser)>0){

	  formatted = readxl(templatefile, ifelse(type=="series",
	                                          "series_info",
	                                          "sampling_info"))
	  t_series_ser <- bind_rows(formatted,
	                            t_series_ser %>%
	                              select(any_of(names(formatted))))
		writeWorksheet(wb, sheet =  ifelse(type=="series",
		                                   "series_info",
		                                   "sampling_info"), 
		               t_series_ser)
	}
	
	
# station data ----------------------------------------------
	if (type == "series") {
	station <- dbGetQuery(con,"select * from ref.tr_station")
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
	}
# existing series data ----------------------------------------	
	if (type == "series"){
	dat <- dbGetQuery(con,str_c("select 
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
		dat[,"das_comment"]<-iconv(dat[,"das_comment"],from="UTF-8",to="latin1")
		#openxlsx::writeData(wb, sheet = "existing_data", dat, startRow = 1)
		writeWorksheet(wb %>% filter(!is.na(das_gal_id)), dat,  sheet = "existing_data")
	}
	
	#put data where das_qal_id is missing into updated_data
	if (nrow(dat)> 0){
	  dat[,"das_comment"]<-iconv(dat[,"das_comment"],from="UTF-8",to="latin1")
	  #openxlsx::writeData(wb, sheet = "existing_data", dat, startRow = 1)
	  writeWorksheet(wb %>% filter(!s.na(das_gal_id)), dat,  sheet = "updated_data")
	}
	
	}
# new data ----------------------------------------------------
# extract missing data from CY-10
	if (type == "series"){
	if (nrow(dat)> 0){
		new_data <- 
				dplyr::bind_rows(
						dat %>% dplyr::filter(das_year>=(CY-10))  %>%
								dplyr::select(ser_nameshort,das_year,das_value, das_comment, das_effort,das_qal_id) %>%
								tidyr::complete(ser_nameshort,das_year=(CY-10):CY) %>%
								dplyr::filter(is.na(das_value) & is.na(das_comment)), 
						dat %>% dplyr::filter(das_year>=(CY-10)& das_qal_id !=1)  %>%
								dplyr::select(ser_nameshort,das_year,das_value, das_comment, das_effort,das_qal_id) 
				)%>%
				dplyr::arrange(ser_nameshort, das_year)
		
		if (nrow(new_data)> 0){
			#openxlsx::writeData(wb, sheet = "new_data", new_data, startRow = 1)
			writeWorksheet(wb, new_data,  sheet = "new_data")
		}
	}
	
	}
# group biometry data existing  ------------------------------------------
	
	
	groups <- dbGetQuery(con,str_c(
	  "select gr.* ",
	  ifelse(type=="series",", ser_nameshort",""),
	  "from ",
	  ifelse(type=="series", "datawg.t_groupseries_grser gr ",
                          "datawg.t_groupsamp_grssa gr "),
	  "LEFT JOIN ",
	  ifelse(type=="series","datawg.t_series_ser ON ser_id = grser_ser_id ",	
         "datawg.t_samplinginfo_sa ON sai_id = grsa_sai_id "),
	  "WHERE ",
	  ifelse(type== series, str_c(" ser_typ_id=",ser_typ_id, " AND "),""),
     ifelse(type==series," ser_cou_code='", " sai_cou_code='"),
	  country,"'",
  " ORDER BY ",
  ifelse(type=="series", "ser_id","sai_id"),
  ", gr_year, gr_id  ASC"))
	
	metrics <- dbGetQuery(con, str_c(
	"select gr_id, 
  mty_name,
  meg_value
	FROM ",
	ifelse(type=="series",
	       "datawg.t_metricgroupseries_megser LEFT JOIN datawg.t_groupseries_grser on gr_id=meg_gr_id ",
	       "datawg.t_metricgroupsamp_megsai LEFT JOIN datawg.t_groupsamp_grsa on gr_id=meg_gr_id "),
	" LEFT JOIN ref.tr_metrictype_mty on mty_id=meg_mty_id ",
	ifelse(type=="series"," LEFT JOIN datawg.t_series_ser ON ser_id = grser_ser_id "," "),
	" WHERE ",
	ifelse(type=="series",str_c("ser_typ_id=",ser_typ_id),""),
  " AND ser_cou_code='",country,"'",
  " ORDER BY ",
  ifelse(type=="series","ser_id","sai_id"),
  ", gr_year, gr_id  ASC"))

	#read the existing data template to have the correct format
	formatted_table <- read_xls(templatefile,"existing_group_metrics")
	if(type=="series"){
	  if(ser_typ_id==1){
	    formatted_table$g_in_gy_proportion = numeric()

	  } else{
	    formatted_table$s_in_ys_proportion = numeric()
	    
	  }
	}
	
	existing_metric <- bind_rows(formatted_table,
	                             groups %>%
	                               left_join(metrics) %>%
	                               tidyr::pivot_wider(names_from=mty_name,
	                                                  values_from=meg_value) %>%
	                               arrange(!!sym(ifelse(type=="series","ser_nameshort","grsa_sai_id")),gr_year,gr_id) %>%
	                               select(any_of(names(formtatted_table))))
	  
	

	existing_metric <- existing_metric[!is.na(existing_metric$gr_year),]
	if (nrow(existing_metric)> 0){	
		#openxlsx::writeData(wb, sheet = "existing_biometry", biom, startRow = 1)
		writeWorksheet(wb, biom,  sheet = "existing_group_metrics")
	} 
	
	
	# group biometry data new data ------------------------------------------
	
	
	if (nrow(existing_metric) >0 ){
	  newbiom <- existing_metric %>% 
	    dplyr::mutate_at(.vars="gr_year",tidyr::replace_na,replace=CY-1) %>%
	    dplyr::filter(gr_year>=(CY-10)) %>%
	    tidyr::complete(!!sym(ifelse(type=="series","ser_nameshort","grsa_sai_id")),gr_year=(CY-10):CY) %>%
	    dplyr::filter(0==rowSums(!is.na(. %>% select(-gr_id,-!!sym(ifelse(type=="series","ser_nameshort","grsa_sai_id")),-gr_year,-gr_number,-gr_dts_datasource,-grser_ser_id)))) %>%
	    dplyr::arrange(!!sym(ifelse(type=="series","ser_nameshort","grsa_sai_id")), gr_year)
	  
	  if (nrow(newbiom)>0) {
	    #openxlsx::writeData(wb, sheet = "new_biometry", newbiom, startRow = 1)
	    writeWorksheet(wb, newbiom,  sheet = "new_group_metrics")	
	  }
	}
	
	
	# individual biometry data existing  ------------------------------------------
	
	
	fishes <- dbGetQuery(con,str_c(
	"select 
	fi.* ",
	ifelse(type=="series",", ser_nameshort",""),
	"FROM ",
	ifelse(type=="series", "datawg.t_fishseries_fiser fi ", "datawg.t_fishsamp_fisa fi "),
	ifelse(type=="series"," LEFT JOIN datawg.t_series_ser ON ser_id = fiser_ser_id ",	""),
	" WHERE ",
	ifelse(type=="series",str_c("ser_typ_id=",ser_typ_id, "AND "), ""),
	ifelse(type=="series",str_c("ser_cou_code='",country,"'"),str_c("sai_cou_code='",country,"'")),
	" ORDER BY ",
	ifelse(type=="series","ser_id", "sai_id"),
	",gr_year, gr_id  ASC"))
	
	metrics <- dbGetQuery(con, str_c(
	"select fi_id, 
  mty_name,
  mty_individual_name,
  meg_value
	FROM ",
	ifelse(type=="series",
	       "datawg t_metricindseries_meiser LEFT JOIN datawg.t_fishseries_grser on fi_id=mei_gr_id ",
	       "datawg t_metricindsamp_meisa LEFT JOIN datawg.t_fishsamp_grsa on fi_id=mei_gr_id "),
	" LEFT JOIN ref.tr_metrictype_mty on mty_id=mei_mty_id",
  ifelse (type==series," LEFT JOIN datawg.t_series_ser ON ser_id = fiser_ser_id "," "),
	" WHERE ",
	ifelse(type=="series",str_c("ser_typ_id=",ser_typ_id, "AND "), ""),
	ifelse(type=="series",str_c("ser_cou_code='",country,"'"),str_c("sai_cou_code='",country,"'")),
	" ORDER BY ",
	ifelse(type=="series","ser_id", "sai_id"),
	" fi_year, fi_id  ASC")) %>%
	  mutate(mty_name=ifelse(is.na(mty_individual_name),mty_name,mty_individual_name)) %>%
	  select(-mty_individual_name)
	
	#read the existing data template to have the correct format
	formatted_table <- read_xls(templatefile,"existing_individual_metrics")
	
	existing_metric <- bind_rows(formatted_table,
	                             fishes %>%
	                               left_join(metrics) %>%
	                               tidyr::pivot_wider(names_from=mty_name,
	                                                  values_from=mei_val) %>%
	                               arrange(!!sym(ifelse(type=="series","ser_nameshort","fisa_sai_id")),fi_year,fi_id) %>%
	                               select(any_of(names(formatted_table))))
	
	
	
	existing_metric <- existing_metric[!is.na(existing_metric$fi_year),]
	if (nrow(existing_metric)> 0){	
	  #openxlsx::writeData(wb, sheet = "existing_biometry", biom, startRow = 1)
	  writeWorksheet(wb, biom,  sheet = "existing_individual_metrics")
	} 
	
	
	# individual biometry data new data ------------------------------------------
	
	
	if (nrow(existing_metric) >0 ){
	  newbiom <- existing_metric %>% 
	    dplyr::mutate_at(.vars="fi_year",tidyr::replace_na,replace=CY-1) %>%
	    dplyr::filter(fi_year>=(CY-10)) %>%
	    tidyr::complete(!!sym(ifelse(type=="series","ser_nameshort","fisa_sai_id")),fi_year=(CY-10):CY) %>%
	    dplyr::filter(0==rowSums(!is.na(. %>% select(-fi_id,-!!sym(ifelse(type=="series","ser_nameshort","fi_sai_id")),-fi_year,-fi_dts_datasource,-!!sym(ifelse(type=="series","fiser_ser_id","fisa_sai_id")))))) %>%
	    dplyr::arrange(!!sym(ifelse(type=="series","ser_nameshort","fisa_sai_id")), fi_year)
	  
	  if (nrow(newbiom)>0) {
	    #openxlsx::writeData(wb, sheet = "new_biometry", newbiom, startRow = 1)
	    writeWorksheet(wb, newbiom,  sheet = "new_individual_metrics")	
	  }
	}
	
	
# maps ---------------------------------------------------------------
#st_crs(ccm) 
	if (type=="series") {
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
