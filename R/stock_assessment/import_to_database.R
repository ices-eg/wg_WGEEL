# import_to_database.R
# Script to read the different files in the datacall and write the results to the database
# Status development
###############################################################################


# Look at the README file for instructions on how to use this script on your computer

# here is a list of the required packages
library("readxl") # to read xls files
library("stringr") # this contains utilities for strings
library("sqldf") 
library("RPostgreSQL") 
options(sqldf.RPostgreSQL.user = "postgres", 
	sqldf.RPostgreSQL.password = passwordlocal,
	sqldf.RPostgreSQL.dbname = "wgeel",
	sqldf.RPostgreSQL.host = "localhost", # "localhost"
	sqldf.RPostgreSQL.port = 5432)
# path to local github (or write a local copy of the files and point to them)
setwd(wg_choose.dir(caption = "GIT directory"))
source("R/utilities/set_directory.R")
source("R/utilities/check_utilities.R")
#source("R/utilities/loading_functions.R")
# this will create a data_wd value in .globalEnv (the user environment)
set_directory("data")

# list the current folders in C:/temps to run into the loop

directories<-list.dirs(path = data_wd, full.names = TRUE, recursive = FALSE)
datacallfiles<-c("Eel_Data_Call_Annex2_Catch_and_Landings.xlsx",
    "Eel_Data_Call_Annex3_Stocking.xlsx",
    "Eel_Data_Call_Annex4_Aquaculture_Production.xlsx")


# to get ices division list but just once, this is out from the loop
# the ices division are extracted from the datacall itself
# choose one file
path<-wg_file.choose()
ices_squares<-read_excel(
    path=path,"tr_faoareas",
    skip=0)
ices_division<-as.character(ices_squares$f_code)

# inits before entering the loop
metadata_list<-list() # A list to store the data from metadata
data_list<-list() # A list to store data)


#################################
# DEPRECATED CODE FOR 2017
source("R/utilities/check_directories")
# launch for all directories
data_list<-check_directories()
###################################



###################################
# NEW CODE TO TEST THE SHINY APP
####################################
# these contain the functions load_catch, load_aquaculture.... adapted to each dataset
source("R/utilities/loading_functions.R")
# these contain the check functions that allow testing inside the files, e.g. check_values, check_missing
# these functions allow a formal test of data structure before loading to the database
#  lateron the constraint in the database will ensure that data are correct, but this allows
# user to test before this last step
source("R/utilities/check_utilities")




# unfold the data from the lists
catch_landings_final<-data.frame()
for (j in 1:length(data_list))
{
  catch_landings_final<- rbind(catch_landings_final,data_list[[j]][["catch_landings"]])
}
aquaculture_final<-data.frame()
for (j in 1:length(data_list))
{
  aquaculture_final<- rbind(aquaculture_final,data_list[[j]][["aquaculture"]])
}

restocking_final<-data.frame()
for (j in 1:length(data_list))
{
  restocking_final<- rbind(restocking_final,data_list[[j]][["restocking"]])
}

show_datacall<-function(dataset,
    typ_id=NULL,  
    year=NULL,
    cou_code=NULL,
    value=NULL, # ">0
    missvaluequal=NULL,
    emu_nameshort=NULL,
    lfs_code=NULL,   
    hty_code=NULL, 
    area_division=NULL,
    qal_id=NULL,        
    datasource=NULL){
  #dataset<-as.data.frame(dataset)
  if (!is.character(typ_id) & !is.null(typ_id)) stop("typ_id should be a character")
  if (!is.numeric(year) & !is.null(year)) stop("year should be a numeric")
  if (!is.character(cou_code) & !is.null(cou_code)) stop("cou_code should be a character")
  if (!is.character(value) & !is.null(value)) stop("value should be a character string like '>1000' or '==0'")
  if (!is.character(missvaluequal) & !is.null(missvaluequal)) stop("missvaluequal should be a character")
  if (!is.character(emu_nameshort) & !is.null(emu_nameshort)) stop("emu_nameshort should be a character")
  if (!is.character(lfs_code) & !is.null(lfs_code)) stop("lfs_code should be a character")
  if (!is.character(hty_code) & !is.null(hty_code)) stop("hty_code should be a character")
  if (!is.character(area_division) & !is.null(area_division)) stop("area_division should be a character")
  if (!is.numeric(qal_id) & !is.null(qal_id)) stop("qal_id should be a numeric")
  if (!is.numeric(datasource) & !is.null(datasource)) stop("datasource should be a character")
  
  
  if (! is.null(typ_id)) condition1=str_c("dataset$eel_typ_id=='",typ_id,"'&") else condition1=""
  if (! is.null(year)) condition2=str_c("dataset$eel_year==",year,"&") else condition2=""
  if (! is.null(cou_code)) condition3=str_c("dataset$eel_cou_code=='",cou_code,"'&") else condition3=""
  if (! is.null(value)) condition4=str_c("dataset$eel_value",value,"&") else condition4=""
  if (! is.null(missvaluequal)) condition5=str_c("dataset$eel_missvaluequal=='",missvaluequal,"'&") else condition5=""
  if (! is.null(emu_nameshort)) condition6=str_c("dataset$eel_emu_nameshort=='",emu_nameshort,"'&") else condition6=""
  if (! is.null(lfs_code)) condition7=str_c("dataset$lfs_code=='",lfs_code,"'&") else condition7=""
  if (! is.null(hty_code)) condition8=str_c("dataset$hty_code=='",hty_code,"'&") else condition8=""
  if (! is.null(area_division)) condition9=str_c("dataset$eel_area_division=='",area_division,"'&") else condition9=""
  if (! is.null(qal_id)) condition10=str_c("dataset$eel_qal_id==",qal_id,"&") else condition10=""
  if (! is.null(datasource)) condition11=str_c("dataset$eel_datasource=='",datasource,"'&") else condition11=""
  
  condition=str_c(condition1,condition2,condition3,condition4,condition5,condition6,condition7,condition8,condition9,condition10,condition11)
  condition<-substring(condition,1,nchar(condition)-1)
  return(dataset[ eval(parse(text=condition)),])
}
show_datacall(dataset=catch_landings_final,cou_code="FR") 
show_datacall(dataset=catch_landings_final,cou_code="IT") 
show_datacall(dataset=catch_landings_final,value=">3000")

##############################
# Import into the database
##############################
# Only this step will ensure the integrity of the data. R script above should have resolved most problems, but
# still some were remaining.
#-----------------------------------------------------
# to delete everything prior to insertion
# don't run this unless you are reloading everything
# sqldf("delete from  datawg.t_eelstock_eel")
# delete only catches and landings from the database
# sqldf("delete from  datawg.t_eelstock_eel where eel_typ_id in (4,5,6,7)")
# check what is in the database
# sqldf("select * from datawg.t_eelstock_eel")
# problem of format of some column, qal id completely void is logical should be integer
#dplyr::glimpse(catch_landings_final)
catch_landings_final$eel_qal_id=as.integer(catch_landings_final$eel_qal_id)
# correcting problem for germany

#catch_landings_final$eel_area_division[catch_landings_final$eel_area_division=="27.3.c, d"&
#        !is.na(catch_landings_final$eel_area_division)]<-"27.3.d"
# correcting problem for Ireland
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="IE_National"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"IE_total"
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="IE_Total"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"IE_total"
options(tibble.print_max = Inf)
options(tibble.width = Inf)

# transforming catch into landings and only using landings 
catch_landings_final$eel_typ_id[catch_landings_final$eel_typ_id==5]<-4
catch_landings_final$eel_typ_id[catch_landings_final$eel_typ_id==7]<-6
catch_landings_final$eel_value<-as.numeric(catch_landings_final$eel_value)
# removing zeros from the database
#catch_landings_final<-catch_landings_final[!catch_landings_final$eel_value==0&!is.na(catch_landings_final$eel_value),]
# removing area division from freshwater sites
catch_landings_final[catch_landings_final$eel_hty_code=='F'&
        !is.na(catch_landings_final$eel_hty_code)&
        !is.na(catch_landings_final$eel_area_division),"eel_area_division"]<-NA
# Denmark and Norway are in tons
catch_landings_final[catch_landings_final$eel_cou_code %in% c("NO","DK"),"eel_value"]<-
    catch_landings_final[catch_landings_final$eel_cou_code %in% c("NO","DK"),"eel_value"]*1000
catch_landings_final$eel_emu_nameshort[catch_landings_final$eel_emu_nameshort=="SE_Sout"&
        !is.na(catch_landings_final$eel_emu_nameshort)]<-"SE_So_o"
catch_landings_final[catch_landings_final$eel_year<=1998 &
        catch_landings_final$eel_cou_code=='SE',]
catch_landings_final[catch_landings_final$eel_year<=1998 &
        catch_landings_final$eel_emu_nameshort=="SE_West","eel_emu_nameshort"]<-"SE_We_o"
catch_landings_final[catch_landings_final$eel_year<=1998 &
        catch_landings_final$eel_emu_nameshort=="SE_East","eel_emu_nameshort"]<-"SE_Ea_o"
sqldf("insert into datawg.t_eelstock_eel (
        eel_typ_id,
        eel_year ,
        eel_value  ,
        eel_missvaluequal,
        eel_emu_nameshort,
        eel_cou_code,
        eel_lfs_code,
        eel_hty_code,
        eel_area_division,
        eel_qal_id,
        eel_qal_comment,
        eel_comment,
		eel_datasource)
        select * from catch_landings_final")
################"
# aquaculture
#################

aquaculture_final$eel_qal_id=as.integer(aquaculture_final$eel_qal_id)
aquaculture_final<-aquaculture_final[!is.na(aquaculture_final$eel_year),]
# check that those lines belong to DE
aquaculture_final[is.na(aquaculture_final$eel_emu_nameshort),]
aquaculture_final$eel_emu_nameshort[is.na(aquaculture_final$eel_emu_nameshort)]<-"DE_total"
aquaculture_final$eel_value<-as.numeric(aquaculture_final$eel_value)
sqldf("insert into datawg.t_eelstock_eel (
        eel_typ_id,
        eel_year ,
        eel_value  ,
        eel_missvaluequal,
        eel_emu_nameshort,
        eel_cou_code,
        eel_lfs_code,
        eel_hty_code,
        eel_area_division,
        eel_qal_id,
        eel_qal_comment,
        eel_comment,
		eel_datasource)
        select * from aquaculture_final")

restocking_final$eel_qal_id=as.integer(restocking_final$eel_qal_id)
# some years badly formed (Italy aquaculture)
restocking_final[is.na(as.integer(restocking_final$eel_year)),]
restocking_final<-restocking_final[!is.na(as.integer(restocking_final$eel_year)),]
restocking_final$eel_value<-as.numeric(restocking_final$eel_value)
restocking_final$eel_year<-as.numeric(restocking_final$eel_year)
restocking_final[is.na(restocking_final$eel_year),]
restocking_final$eel_lfs_code[restocking_final$eel_lfs_code=="y"&!is.na(restocking_final$eel_lfs_code)]<-'Y'
restocking_final[restocking_final$eel_area_division=="273"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
restocking_final[restocking_final$eel_area_division=="271"&!is.na(restocking_final$eel_area_division),"eel_area_division"]<-"27.6.a"
# temporarily removing Spain
#restocking_final<-restocking_final[!restocking_final$eel_cou_code=="ES",]

sqldf("insert into datawg.t_eelstock_eel (
        eel_typ_id,
        eel_year,
        eel_value,
        eel_missvaluequal,
        eel_emu_nameshort,
        eel_cou_code,
        eel_lfs_code,
        eel_hty_code,
        eel_area_division,
        eel_qal_id,
        eel_qal_comment,
        eel_comment,
		eel_datasource)
        select * from restocking_final")

datacall_2017<-sqldf("select * from datawg.t_eelstock_eel")
write.table(datacall_2017,file=str_c(mylocalfolder,"/datacall_2017.csv"),sep=";")



#########################
# Load data from the database
########################

landings <- sqldf(str_c("select * from  datawg.landings"))
aquaculture <- sqldf(str_c("select * from  datawg.aquaculture"))
stocking <- sqldf(str_c("select * from  datawg.stocking"))

show_datacall(dataset=landings,cou_code="IT") 
show_datacall(dataset=aquaculture,cou_code="DK")

# save them again as csv.....
write.table(aquaculture, file=str_c(mylocalfolder,"/aquaculture.csv"),sep=";")
write.table(landings, file=str_c(mylocalfolder,"/landings.csv"),sep=";")
write.table(stocking, file=str_c(mylocalfolder,"/stocking.csv"),sep=";")

lfs_code_base <- sqldf("select lfs_code from ref.tr_lifestage_lfs")[,1]
save(lfs_code_base,file=str_c(mylocalfolder,"/lfs_code.Rdata"))
