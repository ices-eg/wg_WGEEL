###################################################################################"
# File create to build excel files sent to persons responsible for recruitment data
# Author Cedric Briand
#TODO This is following the old format, needs to be updated before the datacall
# This script will create an excel sheet per country that currently have recruitment series
#######################################################################################
# put the current year there
CY<-2016
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
load_library("XLConnect")
#############################
# here is where the script is working change it accordingly
##################################
setwd("F:/workspace/wgeel/sweave")
wd<-getwd()
#############################
# here is where you want to put the data. It is different from the code
# as we don't want to commit data to git
# read git user 
##################################
wddata<-gsub("wgeel","wgeeldata",wd)
#####################################
# Finally we store the xl data in a sub chapter
########################################
dataxl<-str_c(wddata,"/",CY,"/xl")
###################################
# this set up the connextion to the postgres database
# change parameters accordingly
###################################"
options(sqldf.RPostgreSQL.user = "postgres", 
		sqldf.RPostgreSQL.password = localpassword,
		sqldf.RPostgreSQL.dbname = "wgeel",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5432)

#############################
# Table storing information from the recruitment series
# TODO adapt this to new database format
##################################
rec_info<-sqldf("select loc_id,loc_name,loc_country,rec_river,rec_location,rec_samplingtype,rec_remark,
				rec_lfs_name,rec_nameshort,rec_namelong,max(dat_year) 
				from  ts.t_location_loc 
				join ts.t_recruitment_rec on rec_loc_id=loc_id
				join ts.t_data_dat on dat_loc_id=loc_id
				group by loc_id,loc_name,loc_country,rec_river,rec_location,rec_samplingtype,rec_remark,
				rec_lfs_name,rec_nameshort,rec_namelong,rec_order
				order by rec_order	
				")
# converting some information to latin1, necessary for latin1 final user

rec_info[,5]<-iconv(rec_info[,5],from="UTF8",to="latin1")
rec_info[,2]<-iconv(rec_info[,2],from="UTF8",to="latin1")
rec_info[,7]<-iconv(rec_info[,7],from="UTF8",to="latin1")


#' function to create the recuitment sheet 
#' 
#' @note this function writes the xl sheet for each country
#' loop on the number of series in the country to create as many sheet as necessary
#' 
#' @param country the country name, for instance "Sweden"
createxl<-function(country){
	Rcoun<-rec_info[rec_info$loc_country==country,]

	xls.file<-str_c(dataxl,"/",country,CY,".xls")
	wb = loadWorkbook(xls.file, create = TRUE)
	createSheet(wb,"rec_info")
	writeWorksheet (wb , Rcoun , sheet="rec_info" ,header = TRUE )
	saveWorkbook(wb)
	
	wb = loadWorkbook(xls.file, create = TRUE)
	for (i in 1:length(Rcoun$loc_id)){
		loc<-Rcoun$loc_id[i]
		dat<-sqldf(str_c("select dat_year as Year, 
								loc_country as Country, 
								loc_emu_name_short as EMU, 
								rec_nameshort as site, 
								case when dat_stage='glass eel' then 'G'
								when dat_stage='yellow eel' then 'Y'
								else 'M' end as Lifestage,
								rec_samplingtype as Type,
								NULL as method,
								dat_value as Value,
								rec_unit as Unit,
								dat_effort as Effort,
								eft_name as Typeeffort
								from  ts.t_location_loc 
								join ts.t_recruitment_rec on rec_loc_id=loc_id
								join ts.t_data_dat on dat_loc_id=loc_id 
								left join ts.tr_efforttype_eft on dat_eft_id=eft_id
								where dat_loc_id=",loc,"								
								order by dat_year asc"))
		createSheet(wb, name = Rcoun$rec_nameshort[i])
		writeWorksheet (wb , dat , sheet=Rcoun$rec_nameshort[i] ,header = TRUE)	
	}
	saveWorkbook(wb)
	cat("work finished\n")
}
# launch this to see how many countries you have
unique(rec_info$loc_country)
# create an excel file for each of the countries
createxl("Sweden")
createxl("France")
createxl("Spain")
createxl("Netherlands")
createxl("UK")
createxl("Denmark")
createxl("Germany")
createxl("Ireland")
createxl("Portugal")
createxl("Norway")
createxl("Italy")
createxl("Belgium")
createxl("Northern Ireland")
