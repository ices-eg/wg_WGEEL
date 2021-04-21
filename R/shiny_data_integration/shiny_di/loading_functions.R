# Name : loading_functions.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################



############# CATCH AND LANDINGS #############################################
# path <- "\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\03 Data Submission 2019\\EST\\Corrected_Eel_Data_Call_Annex4_LandingsEST.xlsx"
# path<-file.choose()
# datasource<-the_eel_datasource
load_catch_landings<-function(path,datasource){
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4)
# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
# end loop for directories
	
#---------------------- catch_landings sheet ---------------------------------------------
	
# read the catch_landings sheet
	cat("catch and landings \n")
# here we have already seached for catch and landings above.
	
	##Since dc2020, we have both new and updated_data to deal with
	output <- lapply(c("new_data","updated_data"),function(sheet){
				data_xls<-read_excel(
						path=path,
						sheet=sheet,
						skip=0, guess_max=10000)
				data_error <- data.frame(nline = NULL, error_message = NULL)
				country=as.character(data_xls[1,6])
#    data_xls <- correct_me(data_xls)
				# check for the file integrity
				
				if (ncol(data_xls)!=11 & sheet=="new_data") cat(str_c("newdata : number column wrong, should have been 11 in file from ",country,"\n"))
				if (ncol(data_xls)!=11 & sheet=="updated_data") cat(str_c("udated_data : number column wrong, should have been 11 in file from ",country,"\n"))
				
				# check column names
				
				###TEMPORARY FIX 2020 due to incorrect typ_name
				data_xls$eel_typ_name[data_xls$eel_typ_name %in% c("rec_landings","com_landings")] <- paste(data_xls$eel_typ_name[data_xls$eel_typ_name %in% c("rec_landings","com_landings")],"_kg",sep="")
				if (!all(colnames(data_xls)%in%
								c(ifelse(sheet=="updated_data","eel_id","eel_typ_name"),"eel_typ_name","eel_year","eel_value","eel_missvaluequal",
										"eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
										"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
					cat(str_c("problem in column names",            
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															c(ifelse(sheet=="updated_data","eel_id",""),
																	"eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
																	"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
																	"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= "&"),
									"file =",
									file,"\n")) 
				
				if (nrow(data_xls)>0) {
					data_xls$eel_datasource <- datasource
					
					
					######eel_id for updated_data
					if (sheet=="updated_data"){
						data_error= rbind(data_error, check_missing(dataset=data_xls,
										namedataset= sheet, 
										column="eel_id",
										country=country))
						
						#should be a integer
						data_error= rbind(data_error, check_type(dataset=data_xls,
										namedataset= sheet, 
										column="eel_id",
										country=country,
										type="integer"))
					}
					
					###### eel_typ_name ##############
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls,							
									namedataset= sheet, 
									column="eel_typ_name",
									country=country))
					
					#  eel_typ_id should be one of 4 comm.land 5 comm.catch 6 recr. land. 7 recr. catch.
					data_error= rbind(data_error, check_values(dataset=data_xls,
									namedataset= sheet, 
									column="eel_typ_name",
									country=country,
									values=c("com_landings_kg", "rec_landings_kg","other_landings_kg", "other_landings_n")))
					
					###### eel_year ##############
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls,
									namedataset= sheet, 
									column="eel_year",
									country=country))
					# should be a numeric
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_year",
									country=country,
									type="numeric"))
					
					###### eel_value ##############
					
					# can have missing values if eel_missingvaluequa is filled (check later)
					
					# should be numeric
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_value",
									country=country,
									type="numeric"))
					
					###### eel_missvaluequa ##############
					
					#check that there are data in missvaluequa only when there are missing value (NA) is eel_value
					# and also that no missing values are provided without a comment is eel_missvaluequa
					data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
									namedataset= sheet, 
									country=country))
					
					
					###### eel_emu_name ##############
					
					data_error= rbind(data_error, check_missing(dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country))
					
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country,
									type="character"))
					
					data_error= rbind(data_error, check_values(dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country,
									values=emus$emu_nameshort))
					
					###### eel_cou_code ##############
					
					# must be a character
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country,
									type="character"))
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country))
					
					# must only have one value
					data_error= rbind(data_error, check_unique(dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country))
					
					###### eel_lfs_code ##############
					
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country,
									type="character"))
					
					data_error = rbind(data_error,check_values(dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country,
									values = c("AL","G","S", "Y", "YS")))
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country))
					
					
					###### eel_hty_code ##############
					
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country,
									type="character"))
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country))
					
					# should only correspond to the following list
					data_error= rbind(data_error, check_values(dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country,
									values=c("F","T","C","MO","AL")))
					
					###### eel_area_div ##############
					
					data_error= rbind(data_error, check_type(dataset=data_xls,
									namedataset= sheet, 
									column="eel_area_division",
									country=country,
									type="character"))
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(dataset=data_xls[data_xls$eel_hty_code!='F',],
									namedataset= sheet, 
									column="eel_area_division",
									country=country))
					
					# the dataset ices_division should have been loaded there
					data_error= rbind(data_error, check_values(dataset=data_xls,
									namedataset= sheet, 
									column="eel_area_division",
									country=country,
									values=ices_division))
					
					
					###### eel_qal_id ############## 
					#####removed in dc2020
					#
					#        data_error= rbind(data_error, check_missing(dataset=data_xls,
					#              column="eel_qal_id",
					#            country=country))
					#    
					#    data_error= rbind(data_error, check_values(dataset=data_xls,
					#            column="eel_qal_id",
					#            country=country,
					#            values=c(0,1,2,3)))
					
					###### eel_datasource ############## 
					#####removed in dc2020
					
					# data_error= rbind(data_error, check_missing(dataset=data_xls,
					#         column="eel_datasource",
					#         country=country))
					# 
					# data_error= rbind(data_error, check_values(dataset=data_xls,
					#         column="eel_datasource",
					#         country=country,
					#         values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
					
					###### freshwater shouldn't have area ########################
					
					data_error= rbind(data_error, check_freshwater_without_area(
									dataset=data_xls,
									namedataset= sheet, 
									country=country) 
					)
					
					if (nrow(data_error)>0) {
						data_error$sheet <- sheet
					} else {
						data_error <- data.frame(nline = NULL, error_message = NULL,sheet=NULL)
					}
					
				}
				return(list(data=data_xls,error=data_error))
			})
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,error=data_error,the_metadata=the_metadata))) 
}


############# RELEASES #############################################

# path<-file.choose()
load_release<-function(path,datasource){
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	#---------------------- METADATA sheet ---------------------------------------------
	## It is no necessary for database
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4)
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- release sheet ---------------------------------------------
	
	cat("release \n")
	# here we have already seached for catch and landings above.
	
	##Since dc2020, we have both new and updated_data to deal with
	output <- lapply(c("new_data","updated_data"),function(sheet){
				data_error <- data.frame(nline = NULL, error_message = NULL)
				release_tot <- data_xls<-read_excel(
						path=path,
						sheet =sheet,
						skip=0)
				country=as.character(data_xls[1,7])
#    data_xls <- correct_me(data_xls)
				# check for the file integrity
				if (ncol(data_xls)!=ifelse(sheet=="new_data",10,11)) cat(str_c("number of column wrong should have been ",ifelse(sheet=="new_data",10,11)," in the file for ",country,"\n"))
				
# not necessary, values are added latter in check_values    
#    data_xls$eel_qal_id <- NA
#    data_xls$eel_qal_comment <- NA
				
				# check column names
				if (!all(colnames(data_xls)%in%
								c(ifelse(sheet=="updated_data","eel_id","eel_typ_name"),"eel_typ_name","eel_year",
										ifelse(sheet=="updated_data","eel_value","eel_value_number"), ifelse(sheet=="updated_data","eel_value","eel_value_kg"),
										"eel_missvaluequal","eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
										"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
					cat(str_c("problem in column names :",            
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															c(ifelse(sheet=="updated_data","eel_id",""),"eel_typ_name", "eel_year",
																	ifelse(sheet=="updated_data","eel_value","eel_value_number"), ifelse(sheet=="updated_data","","eel_value_kg"),
																	"eel_missvaluequal","eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
																	"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
									" file =",
									file,"\n")) 
				
				if (nrow(data_xls)>0) {
					
					data_xls$eel_datasource <- datasource
					######eel_id for updated_data
					if (sheet=="updated_data"){
						data_error= rbind(data_error, check_missing(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_id",
										country=country))
						
						#should be a integer
						data_error= rbind(data_error, check_type(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_id",
										country=country,
										type="integer"))
					}
					
					
					###### eel_typ_name ##############
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_typ_name",
									country=country))
					
					#  eel_typ_id should be one of q_data__n, gee_n
					if (sheet=="new_data"){
						data_error= rbind(data_error, check_values(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_typ_name",
										country=country,
										values=c("release_n", "gee_n")))
					} else {
						data_error= rbind(data_error, check_values(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_typ_name",
										country=country,
										values=c("q_release_n", "gee_n","q_release_kg")))
					}
					
					###### eel_year ##############
					
					# should not have any missing value
					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_year",
									country=country))
					
					# should be a numeric
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_year",
									country=country,
									type="numeric"))
					
					if (sheet=="new_data"){
						###### eel_value_number ##############
						
						# can have missing values if eel_missingvaluequal is filled (check later)
						
						# should be numeric
						data_error= rbind(data_error, check_type(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_value_number",
										country=country,
										type="numeric"))
						
						###### eel_value_kg ##############
						
						# can have missing values if eel_missingvaluequa is filled (check later)
						
						# should be numeric
						data_error= rbind(data_error, check_type(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_value_kg",
										country=country,
										type="numeric"))
					} else{
						###### eel_value ##############
						
						# can have missing values if eel_missingvaluequal is filled (check later)
						
						# should be numeric
						data_error= rbind(data_error, check_type(
										dataset=data_xls,
										namedataset= sheet, 
										column="eel_value",
										country=country,
										type="numeric"))
						
					}
					###### eel_missvaluequa ##############
					
					# check if there is data in eel_value_number and eel_value_kg
					# if there is data in eel_value_number or eel_value_kg, give warring to the user to fill the missing value 
					# if there is data in neither eel_value_number and eel_value_kg, check if there are data in missvaluequa 
					
					data_error= rbind(data_error, check_missvalue_release(
									dataset=data_xls,
									namedataset= sheet, 
									country=country,
									updated= (sheet!="new_data")))
					
					###### eel_emu_name ##############
					
					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country))
					
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country,
									type="character"))
					
					###### eel_cou_code ##############
					
					# must be a character
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country,
									type="character"))
					# should not have any missing value
					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country))
					# must only have one value
					data_error= rbind(data_error, check_unique(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country))
					
					###### eel_lfs_code ##############
					
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country,
									type="character"))
					# should not have any missing value

					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country))
					# should only correspond to the following list

					data_error= rbind(data_error, check_values(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_lfs_code",
									country=country,
									values=c("G","GY","Y","QG","OG","YS","S","AL")))
					
					###### eel_hty_code ##############
					
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country,
									type="character"))
					
					# should not have any missing value

					data_error= rbind(data_error, check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country))
					
					# should only correspond to the following list

					data_error= rbind(data_error, check_values(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_hty_code",
									country=country,
									values=c("F","T","C","MO","AL")))
					
					###### eel_area_div ##############
					
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_area_division",
									country=country,
									type="character"))
					
					# should not have any missing value

					data_error= rbind(data_error, check_missing(
									dataset=data_xls[data_xls$eel_hty_code!='F',],
									namedataset= sheet, 
									column="eel_area_division",
									country=country))
					
					# the dataset ices_division should have been loaded there

					data_error= rbind(data_error, check_values(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_area_division",
									country=country,
									values=ices_division))
					
					###### eel_datasource ############## 
					#####removed in dc2020
					#     
					# data_error= rbind(data_error, check_missing(dataset=data_xls,
					# 				column="eel_datasource",
					# 				country=country))
					# 
					# data_error= rbind(data_error, check_values(dataset=data_xls,
					# 				column="eel_datasource",
					# 				country=country,
					# 				values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
					# 
					if (sheet=="new_data"){
						###  deal with eel_value_number and eel_value_kg to import to database
						
						#tibbles are weird, change to dataframe and clear NA in the first column
						data_xls <- as.data.frame(data_xls[!is.na(data_xls[,"eel_typ_name"]),])
						
						#separate data between number and kg 
						#create data for number and add eel_typ_id 9 
						release_N <- data_xls[,-4] 
						
						#release_N$eel_typ_id <- NA
						# deal with release_n or gee_n to assign the correct type id 
						for (i in 1:nrow(release_N)) { 
							if (release_N[i,1]=="release_n") { 
								#release_N[i,"eel_typ_id"] <- 9
								release_N[i,1] <- "q_release_n"
							} else { # gee
								#release_N[i,"eel_typ_id"]  <- 10
							}
						} 
						colnames(release_N)[colnames(release_N)=="eel_value_number"] <- "eel_value" 
						
						#create release for kg and add eel_typ_id 8 
						release_kg <- data_xls[data_xls$eel_typ_name!="gee_n",-3] 
						#release_kg$eel_typ_id <- rep(8, nrow(data_xls)) 
						release_kg$eel_typ_name <- "q_release_kg"
						colnames(release_kg)[colnames(release_kg)=="eel_value_kg"] <- "eel_value" 
						
						#Rbind data_xls in the same data frame to import in database 
						release_tot <- rbind(release_N, release_kg) 
						release_tot<-release_tot[,c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
										"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
										"eel_comment","eel_datasource")
						] 
					} else {
						release_tot=data_xls[,c("eel_id","eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
										"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
										"eel_comment","eel_datasource")
						] 
					}
					#    #Add "ND" in eel_missvaluequal if one value is still missing 
					#    for (i in 1:nrow(release_tot)) { 
					#      if (is.na(release_tot[i,"eel_value"])) { 
					#        release_tot[i,"eel_missvaluequal"] <- "ND" 
					#      } 
					#    } 
					###### freshwater shouldn't have area ########################
					
					data_error= rbind(data_error, check_freshwater_without_area(
									dataset=data_xls,
									country=country) 
					)
					
				}
				return(list(data=release_tot,error=data_error))
			})
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,error=data_error,the_metadata=the_metadata))) 
}


############# AQUACULTURE PRODUCTION #############################################

# path <- file.choose()
load_aquaculture<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
#---------------------- METADATA sheet ---------------------------------------------
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4) 
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	# if there is no value in the cells then the tibble will only have one column
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- aquaculture sheet ---------------------------------------------
	
	# read the aquaculture sheet
	cat("aquaculture \n")
	
	data_xls<-read_excel(
			path=path,
			sheet="new_data",
			skip=0)
	data_xls <- correct_me(data_xls)
	country =as.character(data_xls[1,6])
	# check for the file integrity
	if (ncol(data_xls)!=10) cat(str_c("number column wrong ",file,"\n"))
	data_xls$eel_qal_id <- NA
	data_xls$eel_qal_comment <- NA
	data_xls$eel_datasource <- datasource
	# check column names
	if (!all(colnames(data_xls)%in%
					c(		"eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
							"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
							"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
		cat(str_c("problem in column names :",            
						paste(colnames(data_xls)[!colnames(data_xls)%in%
												c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
														"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
														"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
						" file =",
						file,"\n"))   
	if (nrow(data_xls)>0){
		
		###### eel_typ_name ##############
		
		# should not have any missing value
		data_error = rbind(data_error,  check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country))
		
		#  eel_typ_id should be q_aqua_kg
		data_error = rbind(data_error,  check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country,
						values=c("q_aqua_kg")))
		
		###### eel_year ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country))
		
		# should be a numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country,
						type="numeric"))
		
		###### eel_value ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country,
						type="numeric"))
		
		###### eel_missvaluequa ##############
		
		#check that there are data in missvaluequa only when there are missing value (NA) is eel_value
		# and also that no missing values are provided without a comment is eel_missvaluequa
		data_error= rbind(data_error, check_missvaluequal(
						dataset=data_xls,
						namedataset= "new_data", 
						country=country))
		
		
		
		###### eel_emu_name ##############
		data_error = rbind(data_error,   check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error = rbind(data_error,   check_emu_country(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error= rbind(data_error,  check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country,
						type="character"))
		
		###### eel_cou_code ##############
		
		# must be a character
		data_error= rbind(data_error,  check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error,  check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		# must only have one value
		data_error= rbind(data_error, check_unique(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		###### eel_lfs_code ##############
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country))
		
		# should only correspond to the following list
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country,
						values=c("G","GY","Y","YS","S","OG","QG","AL")))
		
		###### eel_datasource ############## 
		##### removed in dc 2020
# data_error= rbind(data_error, check_missing(dataset=data_xls,
# 				column="eel_datasource",
# 				country=country))
# 
# data_error= rbind(data_error, check_values(dataset=data_xls,
# 				column="eel_datasource",
# 				country=country,
# 				values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
		
		
		###### freshwater shouldn't have area ########################
		
		data_error= rbind(data_error, check_freshwater_without_area(
						dataset=data_xls,
						country=country) 
		) 
	}
	return(invisible(list(data=data_xls,error=data_error)))
}


############# BIOMASS INDICATORS #############################################
#path <- file.choose()
load_biomass<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
#---------------------- METADATA sheet ---------------------------------------------
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4) 
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	# if there is no value in the cells then the tibble will only have one column
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- biomass_indicators sheet ---------------------------------------------
	
	# read the biomass_indicators sheet
	cat("biomass_indicators \n")
	
	data_xls<-read_excel(
			path=path,
			sheet="new_data",
			skip=0)
	# correcting an error with typ_name
	data_xls <- correct_me(data_xls)  
	country =as.character(data_xls[1,6]) #country code is in the 6th column
	
	# check for the file integrity, only 12 column in this file
	if (ncol(data_xls)!=12) cat(str_c("number column wrong should have been 12 in template for country",country,"\n"))
	data_xls$eel_qal_id <- NA
	data_xls$eel_qal_comment <- NA
	data_xls$eel_datasource <- datasource
	# check column names
#FIXME there is a problem with name in data_xls, here we have to use typ_name
	if (!all(colnames(data_xls)%in%
					c("eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort", 
							"eel_cou_code", "biom_perc_F", "biom_perc_T", "biom_perc_C", "biom_perc_MO", 
							"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource"))) 
		cat(str_c("problem in column names :",
						paste(colnames(data_xls)[!colnames(data_xls)%in%
												c("eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort", 
														"eel_cou_code", "biom_perc_F", "biom_perc_T", "biom_perc_C", "biom_perc_MO", 
														"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource")],collapse= " & "),
						" file = ",file,"\n")) 
	
	if (nrow(data_xls)>0){

		###### check_duplicate_rates #############
		data_error=rbind(data_error, check_duplicate_rates(
						dataset=data_xls,
						namedataset="new_data"))
				
		###### eel_typ_name #############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country))
		
		#  eel_typ_id should be one of 13 B0_kg  14 Bbest_kg  15 Bcurrent_kg
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country,
						values=c("bcurrent_kg","bbest_kg","b0_kg")))
		
		###### eel_year ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country))
		
		# should be a numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country,
						type="numeric"))
		
		###### eel_value ##############
		
		# can have missing values if eel_missingvaluequal is filled (check later)
		
		# should be numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country,
						type="numeric"))
		
		###### eel_missvaluequal ##############
		
		#check that there are data in missvaluequal only when there are missing value (NA) is eel_value
		# and also that no missing values are provided without a comment is eel_missvaluequa
		data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
						country=country))
		
		###### eel_emu_name ##############
		
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country,
						type="character"))
		
		###### eel_cou_code ##############
		
		# must be a character
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		# must only have one value
		data_error= rbind(data_error, check_unique(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		###### biom_perc_F ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_F",
						country=country))
		
		#  biom_perc_F should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_F",
						country=country)) 

		###### biom_perc_T ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_T",
						country=country))
		
		#  biom_perc_T should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_T",
						country=country)) 
		
		###### biom_perc_C ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_C",
						country=country))
		
		#  biom_perc_C should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_C",
						country=country)) 
		
		###### biom_perc_MO ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_MO",
						country=country))
		
		#  biom_perc_MO should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="biom_perc_MO",
						country=country))

		
		}
		return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
		}
		
		
############# MORTALITY RATES #############################################

# path <- file.choose()
load_mortality_rates<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	#---------------------- METADATA sheet ---------------------------------------------
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4) 
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	# if there is no value in the cells then the tibble will only have one column
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- mortality_rates_Sigma sheet ---------------------------------------------
	
	# read the mortality_rates sheet
	cat("mortality_rates \n")
	
	data_xls<-read_excel(
			path=path,
			sheet="new_data",
			skip=0)
	data_xls <- correct_me(data_xls)
	country =as.character(data_xls[1,6]) #country code is in the 6th column
	# check for the file integrity, only 12 column in this file
	if (ncol(data_xls)!=12) cat(str_c("number column wrong, should have been 12 in template, country ",country,"\n"))
	# check column names
	data_xls$eel_qal_id <- NA
	data_xls$eel_qal_comment <- NA
	data_xls$eel_datasource <- datasource
	if (!all(colnames(data_xls)%in%
					c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
							"eel_cou_code", "mort_perc_F", "mort_perc_T","mort_perc_C", "mort_perc_MO",
							"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
		cat(str_c("problem in column names :",            
						paste(colnames(data_xls)[!colnames(data_xls)%in%
												c("eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort",
														"eel_cou_code", "mort_perc_F", "mort_perc_T","mort_perc_C", "mort_perc_MO",
														"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
						" file =",
						file,"\n"))     
	
	
	if (nrow(data_xls)>0){

		###### check_duplicate_rates #############
		data_error=rbind(data_error, check_duplicate_rates(
						dataset=data_xls,
						namedataset="new_data"))
		
		###### eel_typ_name ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country))
		
		#  eel_typ_id should be 17 to 25
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country,
						values=c("suma","sumf","sumh", "sumf_com", "sumf_rec", "sumh_hydro", "sumh_habitat", "sumh_stocking", "sumh_other", "sumh_release"))) 
		
		###### eel_year ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country))
		
		# should be a numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country,
						type="numeric"))
		
		###### eel_value ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country,
						type="numeric"))
		
		data_error= rbind(data_error, check_positive(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country))
		
		###### eel_missvaluequal ##############
		
		#check that there are data in missvaluequal only when there are missing value (NA) is eel_value
		# and also that no missing values are provided without a comment is eel_missvaluequa
		data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
						country=country))
		
		###### eel_emu_name ##############
		
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country,
						type="character"))
		
		###### eel_cou_code ##############
		
		# must be a character
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		# must only have one value
		data_error= rbind(data_error, check_unique(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))

		###### mort_perc_F ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_F",
						country=country))
		
		#  mort_perc_F should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_F",
						country=country)) 
		
		###### mort_perc_T ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_T",
						country=country))
		
		#  mort_perc_T should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_T",
						country=country)) 
		
		###### mort_perc_C ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_C",
						country=country))
		
		#  mort_perc_C should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_C",
						country=country)) 
		
		###### mort_perc_MO ##############
		# should not have any missing value
		data_error = rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_MO",
						country=country))
		
		#  mort_perc_MO should be 1 to 100 or NP
		data_error= rbind(data_error, check_rates_num(
						dataset=data_xls,
						namedataset= "new_data", 
						column="mort_perc_MO",
						country=country))
		
	}
	return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
}


############# MORTALITY SILVER EQUIVALENT BIOMASS #############################################

# path <- file.choose()
load_mortality_silver<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	#---------------------- METADATA sheet ---------------------------------------------
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4) 
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	# if there is no value in the cells then the tibble will only have one column
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- mortality_silver sheet ---------------------------------------------
	
	# read the mortality_silver sheet
	cat("mortality_silver \n")
	
	data_xls<-read_excel(
			path=path,
			sheet=3,
			skip=0)
	country =as.character(data_xls[1,6]) #country code is in the 6th column
	data_xls <- correct_me(data_xls)
	# check for the file integrity, only 10 column in this file
	if (ncol(data_xls)!=10) cat(str_c("number column wrong, should have been 10 in file for country ",country,"\n"))
	# check column names
	data_xls$eel_qal_id <- NA
	data_xls$eel_qal_comment <- NA
	data_xls$eel_datasource <- datasource
	if (!all(colnames(data_xls)%in%
					c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
							"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
							"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
		cat(str_c("problem in column names :",            
						paste(colnames(data_xls)[!colnames(data_xls)%in%
												c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
														"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
														"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
						" file =",
						file,"\n"))     
	if (nrow(data_xls)>0){
		
		###### eel_typ_name ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country))
		
		#  eel_typ_id should be 17 to 25
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country,
						values=c("see_com", "see_rec", "see_hydro", "see_habitat", "see_stocking", "see_other"))) 
		
		###### eel_year ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country))
		
		# should be a numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country,
						type="numeric"))
		
		###### eel_value ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country,
						type="numeric"))
		
		data_error =rbind(data_error, check_positive(
						dataset = data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country))
		
		
		###### eel_missvaluequal ##############
		
		#check that there are data in missvaluequal only when there are missing value (NA) is eel_value
		# and also that no missing values are provided without a comment is eel_missvaluequa
		data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
						country=country))
		
		###### eel_emu_name ##############
		
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country,
						type="character"))
		
		###### eel_cou_code ##############
		
		# must be a character
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		# must only have one value
		data_error= rbind(data_error, check_unique(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		###### eel_lfs_code ##############
		
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country))
		
		# should only correspond to the following list
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_lfs_code",
						country=country,
						values=c("G","Y","YS","S","AL")))
		
		###### eel_hty_code ##############
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error,check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country))
		
		# should only correspond to the following list
		data_error= rbind(data_error,check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country,
						values=c("F","T","C","MO", "AL")))
		
		###### eel_area_div ##############
		
		data_error= rbind(data_error,check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_area_division",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error,check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_area_division",
						country=country))
		
		# the dataset ices_division should have been loaded there
		data_error= rbind(data_error,check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_area_division",
						country=country,
						values=ices_division))
		
		###### freshwater shouldn't have area ########################
		
		data_error= rbind(data_error, check_freshwater_without_area(
						dataset=data_xls,
						country=country) 
		)
		
	}
	return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
}


load_potential_available_habitat<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	#---------------------- METADATA sheet ---------------------------------------------
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4) 
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	# if there is no value in the cells then the tibble will only have one column
	# store the content of metadata in a list
	if (ncol(metadata)>1){   
		the_metadata[["contact"]] <- as.character(metadata[1,2])
		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
		the_metadata[["method"]] <- as.character(metadata[3,2])
	} else {
		the_metadata[["contact"]] <- NA
		the_metadata[["contactemail"]] <- NA
		the_metadata[["method"]] <- NA
	}
	# end loop for directories
	
	#---------------------- hab_wet_Area sheet ---------------------------------------------
	
	# read the mortality_silver sheet
	cat("Potential available habitat \n")
	
	data_xls<-read_excel(
			path=path,
			sheet=3,
			skip=0)
	country =as.character(data_xls[1,6]) #country code is in the 6th column
	data_xls <- correct_me(data_xls)
	# check for the file integrity, only 10 column in this file
	if (ncol(data_xls)!=10) cat(str_c("number column wrong ",file,"\n"))
	# check column names
	data_xls$eel_qal_id <- NA
	data_xls$eel_qal_comment <- NA
	data_xls$eel_datasource <- datasource
	
	if (!all(colnames(data_xls)%in%
					c("eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
							"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
							"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
		cat(str_c("problem in column names :",            
						paste(colnames(data_xls)[!colnames(data_xls)%in%
												c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
														"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
														"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
						" file =",
						file,"\n")) 
	
	if (nrow(data_xls)>0){
		
		###### eel_typ_name ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country))
		
		#  eel_typ_id should be 16
		data_error= rbind(data_error, check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_typ_name",
						country=country,
						values=c("potential_availabe_habitat_production_ha"))) 
		
		###### eel_year ##############
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country))
		
		# should be a numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_year",
						country=country,
						type="numeric"))
		
		###### eel_value ##############
		
		# can have missing values if eel_missingvaluequa is filled (check later)
		
		# should be numeric
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country,
						type="numeric"))
		
		data_error =rbind(data_error, check_positive(
						dataset = data_xls,
						namedataset= "new_data", 
						column="eel_value",
						country=country))
		
		
		###### eel_missvaluequal ##############
		
		#check that there are data in missvaluequal only when there are missing value (NA) is eel_value
		# and also that no missing values are provided without a comment is eel_missvaluequa
		data_error= rbind(data_error, check_missvaluequal(
						dataset=data_xls,
						namedataset= "new_data", 
						country=country))
		
		###### eel_emu_name ##############
		
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country))
		
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_emu_nameshort",
						country=country,
						type="character"))
		
		###### eel_cou_code ##############
		
		# must be a character
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		# must only have one value
		data_error= rbind(data_error, check_unique(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_cou_code",
						country=country))
		
		###### eel_lfs_code ##############
		
		
		
		###### eel_hty_code ##############
		data_error= rbind(data_error, check_type(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error,check_missing(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country))
		
		# should only correspond to the following list
		data_error= rbind(data_error,check_values(
						dataset=data_xls,
						namedataset= "new_data", 
						column="eel_hty_code",
						country=country,
						values=c("F","T","C","MO", "AL")))
		
		
		
		###### freshwater shouldn't have area ########################
		
		data_error= rbind(data_error, check_freshwater_without_area(
						dataset=data_xls,
						namedataset= "new_data", 
						country=country) 
		)
		
	}
	return(invisible(list(data=data_xls,error=data_error,the_metadata=the_metadata)))
}

############# time series #############################################
# path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wgeel\\datacall\\FR\\Eel_Data_Call_2020_Annex1_time_series_FR_Recruitment.xlsx"
# path<-file.choose()
# datasource<-the_eel_datasource
# load_series(path,datasource,"glass_eel")
load_series<-function(path,datasource,stage="glass_eel"){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata <- list()
	dir <- dirname(path)
	file <- basename(path)
	mylocalfilename <- gsub(".xlsx","",file)
	ser_typ_id <- switch(stage,
			"glass_eel"=1,
			"yellow_eel"=2,
			"silver_eel"=3,
			stop("stage used in function load_series should be glass_eel, yellow_eel, or silver_eel")
	)
	# these are used in the function but not loaded as arguments so I check it there
	stopifnot(exists("tr_units_uni"))
	stopifnot(exists("tr_typeseries_typt"))
	stopifnot(exists("list_country"))
	stopifnot(exists("ices_division"))
	suppressWarnings(t_series_ser <- extract_data("t_series_ser",quality_check=FALSE))
	
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=1)
# check if no rows have been added
	if (names(metadata)[1]!="") cat(str_c("The structure of metadata has been changed ",datacallfiles[1]," in ",country,"\n"))
	
#---------------------- series info ---------------------------------------------
	
	cat("loading series \n")
# here we have already searched for catch and landings above.
	series <- read_excel(
			path=path,
			sheet ="series_info",
			skip=0)
	
	
# check for the file integrity
	if (ncol(series)!=16) cat(str_c("number column wrong for t_series_ser, should have been 16 in file from ",country,"\n"))
	
# check column names
	if (!all(colnames(series)%in%
					c(c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_effort_uni_code", "ser_comment", 
									"ser_uni_code", "ser_lfs_code", "ser_hty_code", "ser_locationdescription", 
									"ser_emu_nameshort", "ser_cou_code", "ser_area_division", "ser_tblcodeid", 
									"ser_x", "ser_y", "ser_sam_id", "ser_dts_datasource" )
					))) 
		cat(str_c("problem in column names",            
						paste(colnames(series)[!colnames(series)%in%
												c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_effort_uni_code", "ser_comment", 
														"ser_uni_code", "ser_lfs_code", "ser_hty_code", "ser_locationdescription", 
														"ser_emu_nameshort", "ser_cou_code", "ser_area_division", "ser_tblcodeid", 
														"ser_x", "ser_y", "ser_sam_id", "ser_dts_datasource" )],collapse= "&"),
						"file =",
						file,"\n")) 
	country <- "unknown"
	if (nrow(series)>0) {
		country=as.character(series[1,"ser_cou_code"])
		series$ser_dts_datasource <- datasource
		###### ser_nameshort ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info", 
						column="ser_nameshort",
						country=country))
		
# 
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_nameshort",
						country=country,
						values=t_series_ser$ser_nameshort))
		
		###### ser_namelong ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_namelong",
						country=country))
		
		###### ser_typ_id ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_typ_id",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_typ_id",
						country=country,
						type="numeric"))
# should be 1, 2, 3 use ser_typ_id created at the head of the function
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_typ_id",
						country=country,
						values=ser_typ_id))
		
		###### ser_effort_uni_code ##############
		
# there can be missing values
		
# should be a character
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_effort_uni_code",
						country=country,
						type="character"))
		
# should be a code in the list
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_effort_uni_code",
						country=country,
						values=tr_units_uni$uni_code))		
		
		###### ser_comment ##############
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_comment",
						country=country))
		
		
		###### ser_uni_code ##############
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_uni_code",
						country=country))
		
# should be a character
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_uni_code",
						country=country,
						type="character"))
		
# should be a code in the list
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_uni_code",
						country=country,
						values=tr_units_uni$uni_code))	
		
		###### ser_lfs_code ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_lfs_code",
						country=country))
		
# should be a character
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_lfs_code",
						country=country,
						type="character"))
		
# should be a code in the list G GY Y S no other stage allowed
# note this is more restrictive than the database
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_lfs_code",
						country=country,
						values=c('G','Y','S','GY')))	
		
		
		###### ser_hty_code ##############
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_hty_code",
						country=country,
						type="character"))
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_hty_code",
						country=country))
		
# should only correspond to the following list
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_hty_code",
						country=country,
						values=c("F","T","C","MO","AL")))
		
		###### ser_locationdescription ##############
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_locationdescription",
						country=country))
		
		
		###### ser_emu_nameshort ##############
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,
						namedataset= "series_info",
						column="ser_emu_nameshort",
						country=country))
		
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_emu_nameshort",
						country=country,
						type="character"))
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_emu_nameshort",
						country=country,
						values=emus$emu_nameshort))
		
		###### ser_cou_code ##############
		
# must be a character
		data_error <- rbind(data_error, check_type(
						dataset=series,
						namedataset= "series_info",
						column="ser_cou_code",
						country=country,
						type="character"))
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_cou_code",
						country=country))
		
# must only have one value
		data_error <- rbind(data_error, check_unique(
						dataset=series,						
						namedataset= "series_info",
						column="ser_cou_code",
						country=country))
# check country code
		
		ser_cou_code <- rbind(data_error, check_values(
						dataset=series,						
						namedataset= "series_info",
						column="ser_cou_code",
						country=country,
						values=list_country))	
		
		
		
		
		
		
		###### ser_area_div ##############
		
		data_error <- rbind(data_error, check_type(
						dataset=series,						
						namedataset= "series_info",
						column="ser_area_division",
						country=country,
						type="character"))
		
		
# the dataset ices_division should have been loaded there
		data_error <- rbind(data_error, check_values(
						dataset=series,						
						namedataset= "series_info",
						column="ser_area_division",
						country=country,
						values=ices_division))
		
		
		###### ser_x ############## should be between -29 (Atlantique) and 40 (Turkey) WGS84
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_x",
						country=country))
		
		data_error <- rbind(data_error, check_between(
						dataset=series,						
						namedataset= "series_info",						
						column="ser_x",
						country=country,
						minvalue = -29,
						maxvalue = 40
				))
		
		###### ser_y ############## should be between 27 (Sahara) and 65 (Islande) WGS84
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_y",
						country=country))
		
		data_error <- rbind(data_error, check_between(
						dataset=series,						
						namedataset= "series_info",
						column="ser_y",
						country=country,
						minvalue = 27,
						maxvalue = 65
				))
		
		
		###### ser_dts_datasource ############## 
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_dts_datasource",
						country=country))
		
		data_error <- rbind(data_error, check_values(
						dataset=series,						
						namedataset= "series_info",
						column="ser_dts_datasource",
						country=country,
						values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
		
	} 
#---------------------- station ---------------------------------------------	
# read the catch_landings sheet
	cat("loading station \n")
# here we have already seached for catch and landings above.
	station <- read_excel(
			path=path,
			sheet ="station",
			skip=0)
	
# check for the file integrity
	if (ncol(station)!=2) cat(str_c("number column wrong for station, should have been 2 in file from ",country,"\n"))
	
# check column names
	if (!all(colnames(station)%in%c("ser_nameshort", "Organisation"))) 
		cat(str_c("problem in column names",            
						paste(colnames(station)[!colnames(station)%in%
												c("ser_nameshort", "Organisation")],collapse= "&"),
						"file =",
						file,"\n")) 
#---------------------- new data ---------------------------------------------
	
	cat("loading newdata \n")
# here we have already searched for catch and landings above.
	new_data <- read_excel(
			path=path,
			sheet ="new_data",
			skip=0)

	if (ncol(new_data)!=5) cat(str_c("number column wrong for newdata, should have been 5 in file from ",country,"\n"))
	#validate(need(class(new_data$das_value)=="numeric",message="You don't have numeric values in new_data check your file, maybe convert pasted value to numeric in excel, or maybe you don't have any data."))
	
	
# check for NULL ser_id in newdata, and try to replace them with series added in the previous step
	
# check column names
	if (!all(colnames(new_data)%in%
					c(c(c("ser_nameshort", "das_year", "das_value", "das_comment", "das_effort", "das_dts_datasource" )
							)
					))) 
		cat(str_c("problem in column names",            
						paste(colnames(new_data)[!colnames(new_data)%in%
												c(c("ser_nameshort", "das_year", "das_value", "das_comment", "das_effort", "das_dts_datasource"))],collapse= "&"),
						"file =",
						file,"\n")) 
	
	if (nrow(new_data)>0) {
		new_data$das_dts_datasource <- datasource
		###### ser_nameshort ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=new_data,						
						namedataset= "new_data",						
						column="ser_nameshort",
						country=country))
		
# check if exists
		data_error <- rbind(data_error, check_values(
						dataset=new_data,
						namedataset= "new_data",		
						column="ser_nameshort",
						country=country,
						values=t_series_ser$ser_nameshort))
		
		
		###### das_year ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=new_data,
						namedataset= "new_data",		
						column="das_year",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=new_data,					
						namedataset= "new_data",		
						column="das_year",
						country=country,
						type="numeric"))
		
		
		###### das_value ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=new_data,					
						namedataset= "new_data",
						column="das_value",
						country=country)) 
		
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=new_data,					
						namedataset= "new_data",
						column="das_value",
						country=country,
						type="numeric"))
		
		
		
		###### das_dts_datasource ############## 
		
		data_error <- rbind(data_error, check_missing(
						dataset=new_data,					
						namedataset= "new_data",
						column="das_dts_datasource",
						country=country))
		
		data_error <- rbind(data_error, check_values(
						dataset=new_data,					
						namedataset= "new_data",
						column="das_dts_datasource",
						country=country,
						values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
		
	} 
#---------------------- updated data ---------------------------------------------
	cat("loading updated_data \n")
	updated_data <- read_excel(
			path=path,
			sheet ="updated_data",
			skip=0)
	if (ncol(updated_data)!=8) cat(str_c("number column wrong for updated_data, should have been 8 in file from ",country,"\n"))
	
	
	if (nrow(updated_data)>0) {
		
		updated_data$das_dts_datasource <- datasource	
		
		###### ser_nameshort ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="ser_nameshort",
						country=country))
		
# check if exists
		data_error <- rbind(data_error, check_values(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="ser_nameshort",
						country=country,
						values=t_series_ser$ser_nameshort))
		
		###### das_id ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_id",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_id",
						country=country,
						type="numeric"))	
		
		###### das_ser_id ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_ser_id",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_ser_id",
						country=country,
						type="numeric"))	
		
		###### das_year ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_year",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_year",
						country=country,
						type="numeric"))
		
		
		###### das_value ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_value",
						country=country)) 
		
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_value",
						country=country,
						type="numeric"))
		
		
		
		###### das_dts_datasource ############## 
		
		data_error <- rbind(data_error, check_missing(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_dts_datasource",
						country=country))
		
		data_error <- rbind(data_error, check_values(
						dataset=updated_data,					
						namedataset= "updated_data",
						column="das_dts_datasource",
						country=country,
						values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
		
	} 
#---------------------- new biometry ---------------------------------------------
	cat("loading new_biometry \n")
	new_biometry <- read_excel(
			path=path,
			sheet ="new_biometry",
			skip=0)
	if (ncol(new_biometry)!=17) cat(str_c("number column wrong for new_biometry, should have been 17 in file from ",country,"\n"))
	
	if (nrow(new_biometry)>0) {
		
		new_biometry$bio_dts_datasource <- datasource
		
		###### ser_nameshort ##############
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=new_biometry,					
						namedataset= "new_biometry",
						column="ser_nameshort",
						country=country))
		
# check if exists
		data_error <- rbind(data_error, check_values(
						dataset=new_biometry,					
						namedataset= "new_biometry",
						column="ser_nameshort",
						country=country,
						values=t_series_ser$ser_nameshort))
		
		
		###### bio_year ##############
		
# should not have any missing value
		
		data_error <- rbind(data_error, check_missing(
						dataset=new_biometry,				
						namedataset= "new_biometry",
						column="bio_year",
						country=country))
# should be a numeric
		
		data_error <- rbind(data_error, check_type(
						dataset=new_biometry,				
						namedataset= "new_biometry",
						column="bio_year",
						country=country,
						type="numeric"))
		
		
		###### bio_dts_datasource ############## 
		
		data_error <- rbind(data_error, check_missing(
						dataset=new_biometry,				
						namedataset= "new_biometry",
						column="bio_dts_datasource",
						country=country))
		
		data_error <- rbind(data_error, check_values(
						dataset=new_biometry,				
						namedataset= "new_biometry",
						column="bio_dts_datasource",
						country=country,
						values=c("dc_2017","wgeel_2016","wgeel_2017","dc_2018","dc_2019","dc_2020","dc_2020_missing")))
		
	} 
	
#---------------------- updated biometry ---------------------------------------------
# NOTE 2020 this should be for 2021 datacall, in 2020 no updated_biometry sheet
	
	if ("updated_biometry" %in% excel_sheets(path)) {
		
		cat("loading updated_biometry \n")
		updated_biometry <- read_excel(
				path = path,
				sheet = "updated_biometry",
				skip = 0)
	} else updated_biometry <- NULL
#TODO develop checks for updated biometry
	
	
	return(invisible(list(
							series=series,
							station = station,
							new_data=new_data,
							updated_data=updated_data,
							new_biometry=new_biometry,
							updated_biometry=updated_biometry,
							t_series_ser=t_series_ser,
							error=data_error,
							the_metadata=the_metadata))) 
}


# -------------------------------------------------------------				
# see  #130			https://github.com/ices-eg/wg_WGEEL/issues/130			
#	load_biometry<-function(path,datasource,stage="glass_eel"){
#		...
#	}
#	
#---------------------------------------------------------------	



############################
# function called to correct data call errors 2018
###########################
correct_me <- function(data){
	if ("eel_value_number"%in%colnames(data)){
		# release file, different structure, do nothing
	} else {
		colnames(data)[3] <-"eel_value"
		colnames(data)[4] <-"eel_missvaluequal"
		# correcting an error with typ_name
	}
	if ("typ_name"%in% colnames(data))
		data<-data%>%rename(eel_typ_name=typ_name)
	data <- as.data.frame(data)
	data[,1]<-tolower(data[,1]) #excel is stupid: he is not able to distinguish lower and upper case
	return(data)
}