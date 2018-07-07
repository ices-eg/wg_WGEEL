# Integrate data into the database strating from a dataframe after the duplicate
# check in the shiny application
# Author: lbeaulaton
###############################################################################

# TODO: this is just a copy of the relevant part of import_to_database (stock assessment folder)

data_integration = function(data_to_integrate)
{
# TODO: fix table deletion
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

	# retrieve eel_type_id
	extract_ref("rr")
	
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
					select eel_typ_id,
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
    					eel_datasource 
                    from catch_landings_final")
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
	
}
