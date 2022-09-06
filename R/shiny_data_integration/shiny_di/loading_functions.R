# Name : loading_functions.R
# Date : 03/07/2018
# Author: cedric.briand
###############################################################################


############# CATCH AND LANDINGS #############################################
# path<-file.choose()
# datasource<-the_eel_datasource


load_catch_landings<-function(path,datasource){
	shinybusy::show_modal_spinner(text = "load catch and landings")
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
	
#---------------------- METADATA sheet ---------------------------------------------


	
# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4)
# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed  \n"))
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
	
	##fix bug 2022
	if ("deleted_data " %in% sheets) deleted <- "deleted_data " else deleted <- "deleted_data"
	# restore this in 2023 by replacing deleted with "deleted_data"
	output <- lapply(c("new_data","updated_data",deleted),function(sheet){
				data_xls<-read_excel(
						path=path,
						sheet=sheet,
						skip=0, guess_max=10000)
				data_error <- data.frame(nline = NULL, error_message = NULL)
				country = as.character(data_xls[1,6])
				if (is.na(country)) country <- "your country"
#    data_xls <- correct_me(data_xls)
				# check for the file integrity
				
				if (ncol(data_xls)!=13 & sheet=="new_data") cat(str_c("newdata : number column wrong, should have been 13 in file from ",country,"\n"))
				if (ncol(data_xls)!=13 & sheet=="updated_data") cat(str_c("updated_data : number column wrong, should have been 13 in file from ",country,"\n"))
				if (ncol(data_xls)!=13 & sheet==deleted) cat(str_c("deleted_data : number column wrong, should have been 13 in file from ",country,"\n"))
				
				# check column names
				
				###TEMPORARY FIX 2020 due to incorrect typ_name
				data_xls$eel_typ_name[data_xls$eel_typ_name %in% c("rec_landings","com_landings")] <- paste(data_xls$eel_typ_name[data_xls$eel_typ_name %in% c("rec_landings","com_landings")],"_kg",sep="")
				if (!all(colnames(data_xls)%in%
								c(ifelse(sheet %in% c("updated_data",deleted),"eel_id","eel_typ_name"),"eel_typ_name","eel_year","eel_value","eel_missvaluequal",
										"eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
										"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) 
					cat(str_c("problem in column names :",            
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															c(ifelse(sheet %in% c("updated_data", deleted),"eel_id",""),
																	"eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
																	"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
																	"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= "&"),
									"file =",
									file,"\n")) 
				
				if (nrow(data_xls)>0) {
					data_xls$eel_datasource <- datasource
					
					
					######eel_id for updated_data or deleted_data
					if (sheet %in% c("updated_data",deleted)){
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
									values=c("com_landings_kg", "rec_landings_kg","other_landings_kg", "other_landings_n", "rec_discard_kg")))
					
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
			shinybusy::remove_modal_spinner()
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error,output[[3]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,deleted_data=output[[3]]$data,
							error=data_error,the_metadata=the_metadata))) 
}


############# RELEASES #############################################

# path<-file.choose()
load_release<-function(path,datasource){
	shinybusy::show_modal_spinner(text = "load release")
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
	#---------------------- METADATA sheet ---------------------------------------------
	## It is no necessary for database
	# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , skip=4)
	# check if no rows have been added
	if (names(metadata)[1]!="For each data series") cat(str_c("The structure of metadata has been changed in \n"))
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
	output <- lapply(c("new_data","updated_data", "deleted_data"),function(sheet){
				data_error <- data.frame(nline = NULL, error_message = NULL)
				cat(sheet,"\n")
				data_xls <- read_excel(
						path=path,
						sheet =sheet,
						skip=0)
				if (any(grepl("\\.\\.\\.", colnames(data_xls)))) cat(str_c(sheet," you have empty columns at the end of the file please drop them\n"))
				data_xls<- data_xls[,!grepl("\\.\\.\\.", colnames(data_xls))]
				country=as.character(data_xls[1,7])
#    data_xls <- correct_me(data_xls)
				# check for the file integrity
				if (ncol(data_xls)!=ifelse(sheet =="new_data",11,11)) {
					cat(str_c("number of column wrong should have been ",ifelse(sheet=="new_data",10,11)," in the file for ",country,"\n"))
					data_error <- rbind(data_error, data.frame("nline"=0,"error_message"=str_c("number of column wrong should have been ",
											ifelse(sheet=="new_data",13,11)," in the file for ",country,"\n")))
					stop(str_c("number of column wrong should have been ",
									ifelse(sheet=="new_data",13,11)," in the file for ",country, " ", sheet,"\n"))
					
				} else {
					
# not necessary, values are added latter in check_values    
#    data_xls$eel_qal_id <- NA
#    data_xls$eel_qal_comment <- NA
					
					# check column names
					if (!all(colnames(data_xls)%in%
									c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id","eel_typ_name"),"eel_typ_name","eel_year",
											ifelse(sheet %in% c("updated_data","deleted_data"),"eel_value","eel_value_number"), ifelse(sheet %in% c("updated_data","deleted_data"),"eel_value","eel_value_kg"),
											"eel_missvaluequal","eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
											"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource"))) {
						
						cat(str_c("problem in column names :",            
										paste(colnames(data_xls)[!colnames(data_xls)%in%
																c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),"eel_typ_name", "eel_year",
																		ifelse(sheet %in% c("updated_data","deleted_data"),"eel_value","eel_value_number"), ifelse(sheet %in% c("updated_data","deleted_data"),"","eel_value_kg"),
																		"eel_missvaluequal","eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
																		"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
										" file =",
										file,"\n")) 
						
						data_error <- rbind(data_error, data.frame("nline"=0,"error_message"=str_c("problem in column names :",            
												paste(colnames(data_xls)[!colnames(data_xls)%in%
																		c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),"eel_typ_name", "eel_year",
																				ifelse(sheet %in% c("updated_data","deleted_data"),"eel_value","eel_value_number"), ifelse(sheet %in% c("updated_data","deleted_data"),"","eel_value_kg"),
																				"eel_missvaluequal","eel_emu_nameshort","eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
																				"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")],collapse= " & "),
												" file =",
												file,"\n")))
						
						
						
					} else {
						
						if (nrow(data_xls)>0) {
							
							data_xls$eel_datasource <- datasource
							######eel_id for updated_data or deleted_data
							if (sheet %in% c("updated_data","deleted_data")){
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
								
								
								
								# should be numeric
								data_error= rbind(data_error, check_type(
												dataset=data_xls,
												namedataset= sheet, 
												column="eel_value_kg",
												country=country,
												type="numeric"))
							} else{
								###### eel_value ##############
								
								
								
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
							# 2021 => it makes no sense to have checks for a column that is masked
							
#						data_error= rbind(data_error, check_type(
#										dataset=data_xls,
#										namedataset= sheet, 
#										column="eel_area_division",
#										country=country,
#										type="character"))
							
							data_error= rbind(data_error, check_na(
											dataset=data_xls,
											namedataset= sheet, 
											column="eel_area_division",
											country=country))
							
							# should not have any missing value
							
#						data_error= rbind(data_error, check_missing(
#										dataset=data_xls[data_xls$eel_hty_code!='F',],
#										namedataset= sheet, 
#										column="eel_area_division",
#										country=country))
							
							# the dataset ices_division should have been loaded there
							
#						data_error= rbind(data_error, check_values(
#										dataset=data_xls,
#										namedataset= sheet, 
#										column="eel_area_division",
#										country=country,
#										values=ices_division))
							
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
								
								
								release_tot <- release_tot[,c("eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
												"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
												"eel_comment","eel_datasource")
								] 
							} else {
								release_tot <- 
										
										data_xls[,c("eel_id","eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
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
							
						} else { #  if nrow 
							data_xls$eel_datasource <- datasource
							release_tot <- data_xls[,c("eel_id","eel_typ_name", "eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
											"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
											"eel_comment","eel_datasource")
							]
						}
					} # end else
				}# end else
				return(list(data=release_tot,error=data_error))
			})
			shinybusy::remove_modal_spinner()
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error,output[[3]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,
							deleted_data=output[[3]]$data,
							error=data_error,the_metadata=the_metadata))) 
}


############# AQUACULTURE PRODUCTION #############################################

# path <- file.choose()
load_aquaculture<-function(path,datasource){
	shinybusy::show_modal_spinner(text = "load biomass")
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
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
	output <- lapply(c("new_data","updated_data",'deleted_data'),function(sheet){
				# read the aquaculture sheet
				cat("aquaculture", sheet, "\n")
				
				data_xls<-read_excel(
						path=path,
						sheet=sheet,
						skip=0)
				#data_xls <- correct_me(data_xls)
				country =as.character(data_xls[1,6])
				# check for the file integrity
				if (ncol(data_xls)!=switch(sheet, 
						"new_data" = 12,
						"updated_data"= 13,
						"deleted_data"= 13
						)) cat(str_c("number column wrong ",file,"\n"))
				data_xls$eel_qal_id <- NA
				data_xls$eel_qal_comment <- NA
				data_xls$eel_datasource <- datasource
				# check column names
				correct_names <- c(		"eel_typ_name","eel_year","eel_value","eel_missvaluequal","eel_emu_nameshort",
						"eel_cou_code", "eel_lfs_code", "eel_hty_code","eel_area_division",
						"eel_qal_id", "eel_qal_comment","eel_comment","eel_datasource")
				
				if (sheet %in% c("updated_data","deleted_data")) correct_names <- c(correct_names, "eel_id")
				if (!all(colnames(data_xls)%in%
								correct_names)) 
					cat(str_c("problem in column names :",            
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															correct_names],collapse= " & "),
									" file =",
									file,"\n"))   
				if (nrow(data_xls)>0){
					
					######eel_id for updated_data or deleted_data
					if (sheet %in% c("updated_data","deleted_data")){
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
					data_error = rbind(data_error,  check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_typ_name",
									country=country))
					
					#  eel_typ_id should be q_aqua_kg
					data_error = rbind(data_error,  check_values(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_typ_name",
									country=country,
									values=c("q_aqua_kg")))
					
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
					
					###### eel_value ##############
					
					# can have missing values if eel_missingvaluequa is filled (check later)
					
					# should be numeric
					data_error= rbind(data_error, check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_value",
									country=country,
									type="numeric"))
					
					###### eel_missvaluequa ##############
					
					#check that there are data in missvaluequa only when there are missing value (NA) is eel_value
					# and also that no missing values are provided without a comment is eel_missvaluequa
					data_error= rbind(data_error, check_missvaluequal(
									dataset=data_xls,
									namedataset= sheet, 
									country=country))
					
					
					###### eel_emu_name ##############
					data_error = rbind(data_error,   check_missing(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country))
					
					data_error = rbind(data_error,   check_emu_country(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country))
					
					data_error= rbind(data_error,  check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_emu_nameshort",
									country=country,
									type="character"))
					
					###### eel_cou_code ##############
					
					# must be a character
					data_error= rbind(data_error,  check_type(
									dataset=data_xls,
									namedataset= sheet, 
									column="eel_cou_code",
									country=country,
									type="character"))
					
					# should not have any missing value
					data_error= rbind(data_error,  check_missing(
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
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error,output[[3]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,
							deleted_data=output[[3]]$data,
							error=data_error,the_metadata=the_metadata))) 
}


############# BIOMASS INDICATORS #############################################
#path <- file.choose()
load_biomass<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
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
	
	# loop for new, update and delete
	output <- lapply(c("new_data","updated_data","deleted_data"),function(sheet){
				data_xls<-read_excel(
						path=path,
						sheet=sheet,
						skip=0)
				# correcting an error with typ_name
				#data_xls <- correct_me(data_xls)  
				country =as.character(data_xls[1,6]) #country code is in the 6th column
				
				# check for the file integrity, only 12 column in this file
				if (ncol(data_xls)!=11 & sheet=="new data") cat(str_c("new_data: number column wrong should have been 11 in template for country",country,"\n"))
				if (ncol(data_xls)!=12 & sheet %in% c("deleted_data","updated_data")) cat(str_c("updated or deleted_data: number column wrong should have been 12 in template for country",country,"\n"))
				data_xls$eel_qal_id <- NA
				data_xls$eel_qal_comment <- NA
				data_xls$eel_datasource <- datasource
				# check column names
				#FIXME there is a problem with name in data_xls, here we have to use typ_name
				if ("typ_name" %in% names(data_xls)){
					data_xls <- data_xls %>%
							rename(eel_typ_name = typ_name)
				}
				if (!all(colnames(data_xls)%in%
								c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),
										"eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort", 
										"eel_cou_code", "biom_perc_F", "biom_perc_T", "biom_perc_C", "biom_perc_MO", 
										"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource"))) 
					cat(str_c("problem in column names :",
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),
																	"eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort", 
																	"eel_cou_code", "biom_perc_F", "biom_perc_T", "biom_perc_C", "biom_perc_MO", 
																	"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource")],collapse= " & "),
									" file = ",file,"\n")) 
				
				if (nrow(data_xls)>0){
					
					###### check_duplicate_rates #############
					data_error=rbind(data_error, check_duplicate_rates(
									dataset=data_xls,
									namedataset="new_data"))
					
					
					######eel_id for updated_data or deleted_data
					if (sheet %in% c("updated_data","deleted_data")){
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
					
					###### check consistency missvalue biomass rate ##############
					# if eel_value is empty, only 0 or NP is possible in percentages columns
					data_error= rbind(data_error, check_consistency_missvalue_rates(
									dataset=data_xls,
									namedataset= "new_data", 
									rates="biom"))
					if (nrow(data_error)>0) {
						data_error$sheet <- sheet
					} else {
						data_error <- data.frame(nline = NULL, error_message = NULL,sheet=NULL)
					}
					
				}
				return(list(data=data_xls,error=data_error))
			})
			shinybusy::remove_modal_spinner()
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error,output[[3]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,deleted_data=output[[3]]$data,
							error=data_error,the_metadata=the_metadata)))
}


############# MORTALITY RATES #############################################

# path <- file.choose()
load_mortality_rates<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
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
	
	# loop for new, update and delete
	output <- lapply(c("new_data","updated_data","deleted_data"),function(sheet){
				data_xls<-read_excel(
						path=path,
						sheet=sheet,
						skip=0)
				#data_xls <- correct_me(data_xls)
				country =as.character(data_xls[1,6]) #country code is in the 6th column
				# check for the file integrity, only 12 column in this file
				if (ncol(data_xls)!=11 & sheet=="new data") cat(str_c("new_data: number column wrong should have been 11 in template for country",country,"\n"))
				if (ncol(data_xls)!=12 & sheet %in% c("deleted_data","updated_data")) cat(str_c("updated or deleted_data: number column wrong should have been 12 in template for country",country,"\n"))
				data_xls$eel_qal_id <- NA
				data_xls$eel_qal_comment <- NA
				data_xls$eel_datasource <- datasource
				if ("typ_name" %in% names(data_xls)){
					data_xls <- data_xls %>%
							rename(eel_typ_name = typ_name)
				}
				if (!all(colnames(data_xls)%in%
								c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),"eel_typ_name", "eel_year","eel_value", "eel_missvaluequal","eel_emu_nameshort",
										"eel_cou_code", "mort_perc_F", "mort_perc_T","mort_perc_C", "mort_perc_MO",
										"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource"))) 
					cat(str_c("problem in column names :",            
									paste(colnames(data_xls)[!colnames(data_xls)%in%
															c(ifelse(sheet %in% c("updated_data","deleted_data"),"eel_id",""),"eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort",
																	"eel_cou_code", "mort_perc_F", "mort_perc_T","mort_perc_C", "mort_perc_MO",
																	"eel_qal_id", "eel_qal_comment","eel_comment", "eel_datasource")],collapse= " & "),
									" file =",
									file,"\n"))     
				
				
				if (nrow(data_xls)>0){
					
					###### check_duplicate_rates #############
					data_error=rbind(data_error, check_duplicate_rates(
									dataset=data_xls,
									namedataset="new_data"))
					
					
					######eel_id for updated_data or deleted_data
					if (sheet %in% c("updated_data","deleted_data")){
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
					###### eel_typ_name #############
					
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
					# and also that no missing values are provided without a comment is eel_missvaluequal
					data_error= rbind(data_error, check_missvaluequal(dataset=data_xls,
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
					
					###### check consistency missvalue mortality rate ##############
					# if eel_value is empty, only 0 or NP is possible in percentages columns
					data_error= rbind(data_error, check_consistency_missvalue_rates(
									dataset=data_xls,
									namedataset= "new_data", 
									rates="mort"))
					if (nrow(data_error)>0) {
						data_error$sheet <- sheet
					} else {
						data_error <- data.frame(nline = NULL, error_message = NULL,sheet=NULL)
					}
					
				}
				return(list(data=data_xls,error=data_error))
			})
	data_error=rbind.data.frame(output[[1]]$error,output[[2]]$error,output[[3]]$error)
	return(invisible(list(data=output[[1]]$data,updated_data=output[[2]]$data,deleted_data=output[[3]]$data,
							error=data_error,the_metadata=the_metadata)))
}



############# MORTALITY SILVER EQUIVALENT BIOMASS #############################################

# path <- file.choose()
load_mortality_silver<-function(path,datasource){
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata<-list()
	dir<-dirname(path)
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
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
	#data_xls <- correct_me(data_xls)
	# check for the file integrity, only 10 column in this file
	if (ncol(data_xls)!=10) cat(str_c("number column wrong, should have been 10 in file for country ",country,"\n"))
	# check column names
	# data_xls$eel_qal_id <- NA
	# data_xls$eel_qal_comment <- NA
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
	
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
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
	#data_xls <- correct_me(data_xls)
	# check for the file integrity, only 10 column in this file
	if (ncol(data_xls)!=10) cat(str_c("number column wrong ",file,"\n"))
	# check column names
	# data_xls$eel_qal_id <- NA
	# data_xls$eel_qal_comment <- NA
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
#  path<-file.choose()
# datasource <- the_eel_datasource; stage="glass_eel"
# 
# load_series(path,datasource="toto","glass_eel")
load_series<-function(path,datasource, stage="glass_eel"){
	shinybusy::show_modal_spinner(text = "load series", color="darkgreen")
	sheets <- excel_sheets(path=path)
	if ("sampling_info" %in% sheets) stop("There is a sampling_info tab in your data, you want to use import time series tab")
	
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
	metadata <- read_excel(path=path,"metadata" , skip=1)
# check if no rows have been added
	if (names(metadata)[1]!="ser_nameshort") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	
#---------------------- series info ---------------------------------------------
	
	cat("loading series \n")
# here we have already searched for catch and landings above.
	series <- read_excel(
			path=path,
			sheet ="series_info",
			skip=0)
	
	
# check for the file integrity
	if (ncol(series)!=20) cat(str_c("number column wrong for t_series_ser, should have been 20 in file \n"))
	
# check column names
	if (!all(colnames(series)%in%
					c(c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_effort_uni_code", "ser_comment", 
									"ser_uni_code", "ser_lfs_code", "ser_hty_code", "ser_locationdescription", 
									"ser_emu_nameshort", "ser_cou_code", "ser_area_division", "ser_tblcodeid", 
									"ser_x", "ser_y", "ser_sam_id", "ser_dts_datasource","ser_sam_gear", "ser_distanceseakm", "ser_method", "ser_restocking")
					))) 
		cat(str_c("problem in column names :",            
						paste(colnames(series)[!colnames(series)%in%
												c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_effort_uni_code", "ser_comment", 
														"ser_uni_code", "ser_lfs_code", "ser_hty_code", "ser_locationdescription", 
														"ser_emu_nameshort", "ser_cou_code", "ser_area_division", "ser_tblcodeid", 
														"ser_x", "ser_y", "ser_sam_id", "ser_dts_datasource","ser_sam_gear", "ser_distanceseakm", 	"ser_method", "ser_restocking" )],collapse= "&"),
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
		
		data_error_series  <- 	check_values(
				dataset=series,
				namedataset= "series_info",
				column="ser_nameshort",
				country=country,
				values=t_series_ser$ser_nameshort)
		
		if (! is.null(data_error_series)) {
			data_error_series$error_message <-paste(data_error_series$error_message, 
					"This probably means that you have not entered the series yet, please proceed for series integration, insert new series and proceed to step 0 again.")
			data_error <- rbind(data_error, 
					data_error_series)
		}			
		
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
		
		data_error <- rbind(data_error, check_values(
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
		
		
		data_error <-		rbind(data_error, check_values(
						dataset=series,						
						namedataset= "series_info",
						column="ser_sam_id",
						country=country,
						values=1:5))
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_dts_datasource",
						country=country))
		
		
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_sam_id",
						country=country))
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_distanceseakm",
						country=country))
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_method",
						country=country))
		
		data_error <- rbind(data_error, check_missing(
						dataset=series,						
						namedataset= "series_info",
						column="ser_restocking",
						country=country))
		
		data_error <- rbind(data_error, check_values(
						dataset=series,
						namedataset= "series_info",
						column="ser_restocking",
						country=country,
						values=c(1,0,"true","false",'TRUE','FALSE')))
		
	} # end if
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
		cat(str_c("problem in column names :",            
						paste(colnames(station)[!colnames(station)%in%
												c("ser_nameshort", "Organisation")],collapse= "&"),
						"file =",
						file,"\n")) 
	
	#---------------------- all_other_sheets ---------------------------------------------
	fn_check_series <- function(sheet, columns, nbcol){
		data_xls <- read_excel(
				path=path,
				sheet=sheet,
				skip=0, guess_max=10000)
		cat(sheet,"\n")
		
		data_error <- data.frame(nline = NULL, error_message = NULL)
		# country is extracted 
#    data_xls <- correct_me(data_xls)
	
	# 2022 08 we have added fi_lsf_code, it is not yet in the sheets so we add an empty if not there
	if ("fi_lfs_code" %in% columns & (!"fi_lfs_code" %in% names(data_xls)))
		data_xls$fi_lfs_code <- as.character(NA)  

		
		# check for the file integrity		
		# check column names for each sheet
	  

	
	
	
		fn_check_columns(data=data_xls, columns=columns,	file = file, sheet=sheet, nbcol=nbcol)
		
		# check datasource according to sheet name, for individual and group data two columns are already filled in
		# for updated data and deleted data 
		if (grepl("data", sheet) & grepl("new", sheet)) {
			data_xls$das_dts_datasource <- datasource
		}		
		if (grepl("group", sheet)  & (grepl("new", sheet) | grepl("updated", sheet))) {
			data_xls$gr_dts_datasource <- datasource
			data_xls$meg_dts_datasource <- datasource
		}
		
		if (grepl("individual", sheet)  & (grepl("new", sheet)| grepl("updated", sheet))) {
			data_xls$gr_dts_datasource <- datasource
			data_xls$mei_dts_datasource <- datasource
		}
		
		# ser_nameshort should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset = data_xls,						
						namedataset = sheet,						
						column="ser_nameshort",
						country=country))
		
		# ser_nameshort should exists
		data_error <- rbind(data_error, check_values(
						dataset = data_xls,
						namedataset = sheet,	
						column = "ser_nameshort",
						country = country,
						values = t_series_ser$ser_nameshort))
		
		#ser_id should not have any missing values for updated data and deleted data
		# flatten used to reduce list with NULL elements
		data_error <- rbind(data_error, 
				purrr::flatten(lapply(
								c("das_ser_id",
										"fiser_ser_id",
										"grser_ser_id"),			
								function(name_column){
									if (name_column %in% colnames(data_xls) & (grepl("deleted", sheet) | grepl("updated", sheet))){	
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										
										return(data_error)}
								})))
		
		# id columns in updated and deleted data should be present
		# the deletion is done at the group level or fish level, for update we will check for changes in the table
		
		data_error <- rbind(data_error, 
				purrr::flatten(lapply(c("das_id",
										"fi_id",
										"gr_id"
								),			
								function(name_column){
									if  (name_column %in% colnames(data_xls) & (grepl("deleted", sheet) | grepl("updated", sheet))){	
										data_error <- rbind(data_error, check_unique(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										data_error <- rbind(data_error, check_type(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country,
														type="numeric"))
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										return(data_error)}
								})))
		
		
# should not have any missing value for year and be numeric
		
		
		column_year <- switch(sheet,
				"new_data"="das_year",
				"updated_data"="das_year",
				"deleted_data"="das_year",
				"new_group_metrics"="gr_year",
				"updated_group_metrics"="gr_year",
				"deleted_group_metrics"="gr_year",
				"new_individual_metrics"=NULL,
				"updated_individual_metrics"=NULL,
				"deleted_individual_metrics"=NULL
		)
		if (!is.null(column_year)){
			data_error <- rbind(data_error, check_missing(
							dataset = data_xls,
							namedataset = sheet,		
							column = column_year,
							country = country))
			
			data_error <- rbind(data_error, check_type(
							dataset = data_xls,					
							namedataset= sheet,		
							column=column_year,
							country=country,
							type="numeric"))
		}
		
		
		column_date <- switch(sheet,
				"new_data"=NULL,
				"updated_data"=NULL,
				"deleted_data"=NULL,
				"new_group_metrics"=NULL,
				"updated_group_metrics"=NULL,
				"deleted_group_metrics"=NULL,
				"new_individual_metrics"="fi_date",
				"updated_individual_metrics"="fi_date",
				"deleted_individual_metrics"="fi_date"
		)
		if (!is.null(column_date)){
			data_error <- rbind(data_error, check_missing(
							dataset = data_xls,
							namedataset = sheet,		
							column = column_date,
							country = country))
			
			data_error <- rbind(data_error, check_type(
							dataset = data_xls,					
							namedataset= sheet,		
							column=column_date,
							country=country,
							type="numeric"))
		}
		
# this is only for data
		
		if (grepl("data", sheet)) {
			
# das_value should not have any missing value
			data_xls$das_qal_comment <- as.character(data_xls$das_qal_comment)
			data_error <- rbind(data_error, check_missing(
							dataset = data_xls,					
							namedataset = sheet,
							column="das_value",
							country=country)) 
			
# das_value should be a numeric
			
			data_error <- rbind(data_error, check_type(
							dataset = data_xls,					
							namedataset = sheet,
							column="das_value",
							country=country,
							type="numeric"))			
			
		}	
		
		
		if (grepl("metrics", sheet)) {
			
# all mty related columns should be numeric
			
			
			resmetrics <-		purrr::flatten(lapply(c("lengthmm",
									"weightg",
									"ageyear",
									"eye_diam_mean_mm",
									"pectoral_lengthmm",
									"female_proportion",
									'is_female_(1=female,0=male)',
									"is_differentiated_(1=differentiated,0_undifferentiated)",	
									"differentiated_proportion",
									"anguillicola_proportion",
									"anguillicola_presence(1=present,0=absent)",			
									"anguillicola_intensity",
									"muscle_lipid_fatmeter_perc",
									"muscle_lipid_gravimeter_perc",
									"sum_6_pcb",
									"teq",
									"evex_proportion",
									"evex_presence_(1=present,0=absent)",			
									"hva_proportion",
									"hva_presence_(1=present,0=absent)",			
									"pb",
									"hg",
									"cd",
									"m_mean_lengthmm",
									"m_mean_weightg",
									"m_mean_ageyear",
									"f_mean_lengthmm",
									"f_mean_weightg",
									"f_mean_age",
									"g_in_gy_proportion",
									"s_in_ys_proportion"),			
							function(name_column){
								if (name_column %in% colnames(data_xls)){	
									data_error <- check_type(
											dataset = data_xls,					
											namedataset = sheet,
											column=name_column,
											country=country,
											type="numeric")
									return(data_error)}
								
							}))
			data_error <- bind_rows(data_error,	purrr::flatten(resmetrics)	)
		} # end if grepl
		return(list(data=data_xls,error=data_error))
	}			
#	new_data <- fn_check_series("new_data", 
#			columns=c("ser_nameshort", "das_year", "das_value", "das_comment", "das_effort"), 
#			nbcol=5)	
#	
#	updated_data <- fn_check_series("updated_data", 
#			columns=c("ser_nameshort",	"das_id",	"das_ser_id",	"das_value",	"das_year",	"das_comment",	"das_effort",	"das_qal_id"), 
#			nbcol=8)	
#	
#	new_group_metrics <- fn_check_series("new_group_metrics", 
#			columns=c("ser_nameshort",	"gr_year",	"gr_number", "gr_comment","lengthmm",	"weightg",	"ageyear",	"female_proportion", "differentiated_proportion",
#					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age","g_in_gy_proportion",	"s_in_ys_proportion",	
#					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",	"evex_proportion",	
#					"hva_proportion",	"pb",	"hg",	"cd"), 
#			nbcol=26)	
	
	sheet <- list(
			"new_data",
			"updated_data",
			"deleted_data",
			"new_group_metrics",
			"updated_group_metrics",
			"deleted_group_metrics",
			"new_individual_metrics",
			"updated_individual_metrics",
			"deleted_individual_metrics")
	columns <- list(
			c("ser_nameshort", "das_year", "das_value", "das_comment", "das_effort","das_qal_id", "das_qal_comment"),
			#TODO check that das_lastupdate and das_dts_datasource 
			c("ser_nameshort",	"das_id",	"das_ser_id",	"das_value",	"das_year",	"das_comment",	"das_effort",	"das_qal_id", "das_qal_comment", "das_dts_datasource"),
			c("ser_nameshort",	"das_id",	"das_ser_id",	"das_value",	"das_year",	"das_comment",	"das_effort",	"das_qal_id", "das_qal_comment", "das_dts_datasource"),
			c("gr_id","ser_nameshort",	"grser_ser_id", "gr_year",	"gr_number", "gr_comment", "gr_last_update", "gr_dts_datasource", "lengthmm",	"weightg",	"ageyear",	"female_proportion","differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age",
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_proportion","hva_proportion",	"pb",	"hg",	"cd","g_in_gy_proportion","s_in_ys_proportion"),		
			c("gr_id","ser_nameshort",	"grser_ser_id", "gr_year",	"gr_number", "gr_comment", "gr_last_update", "gr_dts_datasource", "lengthmm",	"weightg",	"ageyear",	"female_proportion","differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age",
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_proportion","hva_proportion",	"pb",	"hg",	"cd","g_in_gy_proportion","s_in_ys_proportion"),	
			c("gr_id","ser_nameshort",	"grser_ser_id", "gr_year",	"gr_number", "gr_comment", "gr_last_update", "gr_dts_datasource", "lengthmm",	"weightg",	"ageyear",	"female_proportion","differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age",
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_proportion","hva_proportion",	"pb",	"hg",	"cd","g_in_gy_proportion","s_in_ys_proportion"),
			c("ser_nameshort",	"fi_date", "fi_year", "fi_lfs_code","fi_comment",  "lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"),
			c("fi_id","ser_nameshort","fiser_ser_id",	"fi_date", "fi_year","fi_lfs_code", "fi_comment", "fi_last_update",	"fi_dts_datasource",
					"lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"),
			# TODO 2023 change name fiser_year to fi_year the template has been updated
			c("fi_id","ser_nameshort",	"fiser_ser_id", "fi_date",	"fiser_year", "fi_lfs_code", "fi_comment",  "fi_last_update",	"fi_dts_datasource", 
					"lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"))
	nbcol <- list(7,10,10,28,31,31,23,26,26)
	
	
	res <- purrr::pmap(list(sheet,columns,nbcol), fn_check_series)
	data_error <- 	lapply(res,function(X)X$error) %>% bind_rows()
	shinybusy::remove_modal_spinner()
	
	return(invisible(list(
							series=series,
							station = station,
							new_data = res[[1]]$data,
							updated_data = res[[2]]$data,
							deleted_data = res[[3]]$data, 
							new_group_metrics =  res[[4]]$data, 
							updated_group_metrics = res[[5]]$data, 
							deleted_group_metrics = res[[6]]$data, 
							new_individual_metrics = res[[7]]$data, 
							updated_individual_metrics = res[[8]]$data, 
							deleted_individual_metrics = res[[9]]$data, 
							t_series_ser = t_series_ser, 
							error =data_error,
							the_metadata =the_metadata))) 
}


# -------------------------------------------------------------				
# see  #130			https://github.com/ices-eg/wg_WGEEL/issues/130			
#	load_biometry<-function(path,datasource,stage="glass_eel"){
#		...
#	}
#	
#---------------------------------------------------------------	

############# other sampling #############################################
# launch helper_dev_connect
#  path<-file.choose()
# datasource <- the_eel_datasource
# load_dcf(path,datasource="toto")
load_dcf<-function(path,datasource){
	shinybusy::show_modal_spinner(text = "load dcf")
	sheets <- excel_sheets(path=path)
	if ("series_info" %in% sheets) stop("There is a series_info tab in your data, you want to use import time series tab")
	
	data_error <- data.frame(nline = NULL, error_message = NULL)
	the_metadata <- list()
	dir <- dirname(path)
	file <- basename(path)
	mylocalfilename <- gsub(".xlsx","",file)
	# these are used in the function but not loaded as arguments so I check it there
	stopifnot(exists("tr_units_uni"))
	stopifnot(exists("tr_typeseries_typt"))
	stopifnot(exists("list_country"))
	stopifnot(exists("ices_division"))	
	
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
	metadata <- read_excel(path=path,"metadata" , skip=1)
# check if no rows have been added
	if (names(metadata)[1]!="name") cat(str_c("The structure of metadata has been changed ",file,"\n"))
	
#---------------------- series info ---------------------------------------------
	
	cat("loading sampling info \n")
# here we have already searched for catch and landings above.
	
	sampling_info <- read_excel(
			path=path,
			sheet ="sampling_info",
			skip=0)
	
	#WGEEL 2022 we made a mistake adding a sai_year in the db that should not exist
	#those lines address the issue
	if ("sai_year" %in% names(sampling_info)){
	  sampling_info <- sampling_info %>%
	    select(-sai_year) %>%
	    unique()
	}
	
	
	
	fn_check_columns(sampling_info, 
			columns=c("sai_name","sai_emu_nameshort","sai_locationdescription","sai_area_division"	,
					"sai_hty_code",	"sai_samplingobjective","sai_samplingstrategy","sai_protocol","sai_qal_id","sai_comment",
					"sai_lastupdate","sai_dts_datasource"),
			file= file,
			sheet="sampling_info",
			nbcol=12)
	
	country <- "unknown"
	if (nrow(sampling_info)>0) {
	  sampling_info$sai_cou_code <- substr(sampling_info$sai_emu_nameshort,
	                                       1,
	                                       2)
		country <- as.character(sampling_info[1,"sai_cou_code"])
		sampling_info$sai_dts_datasource <- datasource
		###### ser_nameshort ##############
		
# should not have any missing value
# PROBABLY CHANGE 2023 WHEN WE ADD name
#		data_error <- rbind(data_error, check_missing(
#						dataset=sampling_info,
#						namedataset= "sampling_info", 
#						column="ser_nameshort",
#						country=country))
#		
#		data_error_sampling_info  <- 	check_values(
#				dataset=sampling_info,
#				namedataset= "sampling_info",
#				column="ser_nameshort",
#				country=country,
#				values=t_sampling_info_ser$ser_nameshort)
		
#		if (! is.null(data_error_sampling_info)) {
#			data_error_sampling_info$error_message <-paste(data_error_sampling_info$error_message, 
#					"This probably means that you have not entered the sampling_info yet, please proceed for sampling_info integration, insert new sampling_info and proceed to step 0 again.")
#			data_error <- rbind(data_error, 
#					data_error_sampling_info)
#		}			
		
		####### sai_name #######################################
		
		data_error <- rbind(data_error, check_missing(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_name",
						country=country))
		
		data_error <- rbind(data_error, check_type(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_name",
						country=country,
						type="character"))
		
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_name",
						country=country,
						values=emus$emu_nameshort))
		
		
		
		###### sai_emu_nameshort ##############
		
		data_error <- rbind(data_error, check_missing(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_emu_nameshort",
						country=country))
		
		data_error <- rbind(data_error, check_type(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_emu_nameshort",
						country=country,
						type="character"))
		
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_emu_nameshort",
						country=country,
						values=emus$emu_nameshort))
		
		###### sai_cou_code ##############
		
# must be a character
		data_error <- rbind(data_error, check_type(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_cou_code",
						country=country,
						type="character"))
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_cou_code",
						country=country))
		
# must only have one value
		data_error <- rbind(data_error, check_unique(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_cou_code",
						country=country))
		
# check values list
		
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_cou_code",
						country=country,
						values=list_country))	
		
		## sai_area_division
		
# check country code
		
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_cou_code",
						country=country,
						values=list_country))			
		
		
		
		###### sai_hty_code ##############
		
		data_error <- rbind(data_error, check_type(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_hty_code",
						country=country,
						type="character"))
		
# should not have any missing value
		data_error <- rbind(data_error, check_missing(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_hty_code",
						country=country))
		
# should only correspond to the following list
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,
						namedataset= "sampling_info",
						column="sai_hty_code",
						country=country,
						values=c("F","T","C","MO","AL")))
		
		
		
		###### sai_area_div ##############
		
		data_error <- rbind(data_error, check_type(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_area_division",
						country=country,
						type="character"))
		
		# the dataset ices_division should have been loaded there
		data_error <- rbind(data_error, check_values(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_area_division",
						country=country,
						values=ices_division))
		
		###### sai_hty_code ##############
		
		data_error= rbind(data_error, check_type(
						dataset=sampling_info,
						namedataset= "sampling_info", 
						column="sai_hty_code",
						country=country,
						type="character"))
		
		# should not have any missing value
		data_error= rbind(data_error, check_missing(
						dataset = sampling_info,
						namedataset = "sampling_info", 
						column = "sai_hty_code",
						country = country))
		
		# should only correspond to the following list
		data_error= rbind(data_error, check_values(
						dataset=sampling_info,
						namedataset = "sampling_info", 
						column = "sai_hty_code",
						country = country,
						values = c("F","T","C","MO","AL")))	
		
		# sai_samplingobjective	
		
		
		data_error <- rbind(data_error, check_missing(
						dataset = sampling_info,						
						namedataset = "sampling_info",
						column = "sai_samplingobjective",
						country = country))
		
		# sai_samplingstrategy
		
		data_error <- rbind(data_error, check_missing(
						dataset = sampling_info,						
						namedataset = "sampling_info",
						column = "sai_samplingstrategy",
						country = country))
		
		# 	sai_protocol	
		
		data_error <- rbind(data_error, check_missing(
						dataset=sampling_info,						
						namedataset= "sampling_info",
						column="sai_protocol",
						country=country))
		
		# sai_qal_id	sai_comment	sai_lastupdate	sai_dts_datasource
		
		
	} # end if nrow
	
	#---------------------- all_other_sheets ---------------------------------------------
	fn_check_gr_ind <- function(sheet, columns, nbcol){
		data_xls <- read_excel(
				path=path,
				sheet=sheet,
				skip=0, guess_max=10000)
		cat(sheet,"\n")
		
		
		#some countries have added a fi_year column so we deal with it
		if ("fi_year" %in% columns & (!"fi_year" %in% names(data_xls)))
		  data_xls$fi_year <- NA  
		if ("fi_year" %in% columns){
		  data_xls <- data_xls %>%
		    mutate(fi_year=as.integer(fi_year))
		}

		data_error <- data.frame(nline = NULL, error_message = NULL)
		# country is extracted 
#    data_xls <- correct_me(data_xls)
		
		# check for the file integrity		
		
		# check column names for each sheet
		
		fn_check_columns(data=data_xls, columns=columns,	file = file, sheet=sheet, nbcol=nbcol)
		
		
		if (grepl("group", sheet)) {
			data_xls$gr_dts_datasource <- datasource
			data_xls$meg_dts_datasource <- datasource
		}
		if (grepl("individual", sheet)) {
			data_xls$gr_dts_datasource <- datasource
			data_xls$mei_dts_datasource <- datasource
		}
		
		# ser_nameshort should not have any missing value
		data_error <- bind_rows(data_error, check_missing(
						dataset = data_xls,						
						namedataset = sheet,						
						column="sai_name",
						country=country))
		
		# ser_nameshort should exists
		data_error <- bind_rows(data_error, check_values(
						dataset = data_xls,
						namedataset = sheet,	
						column = "sai_name",
						country = country,
						values = tr_sai_list))
		
		#sai_id should not have any missing values for updated data and deleted data
		# flatten used to reduce list with NULL elements
		data_error <- bind_rows(data_error, 
				purrr::flatten(lapply(
								c("fisa_sai_id",
										"grsa_sai_id"),			
								function(name_column){
									if (name_column %in% colnames(data_xls) & (grepl("deleted", sheet) | grepl("updated", sheet))){	
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										
										return(data_error)}
								})))
		
		# id columns in updated and deleted data should be present
		
		# the deletion is done at the group level or fish level, for update we will check for changes in the table
		
		
		data_error <- bind_rows(data_error, 
				
				purrr::flatten(lapply(c(
										"fi_id",
										"gr_id"
								),			
								function(name_column){
									if  (name_column %in% colnames(data_xls) & (grepl("deleted", sheet) | grepl("updated", sheet))){	
										data_error <- rbind(data_error, check_unique(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										data_error <- rbind(data_error, check_type(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country,
														type="numeric"))
										data_error <- rbind(data_error, check_missing(
														dataset = data_xls,					
														namedataset = sheet,
														column=name_column,
														country=country))
										return(data_error)}
								})))
		

		column_year <- switch(sheet,
				"new_group_metrics"="gr_year",
				"updated_group_metrics"="gr_year",
				"deleted_group_metrics"="gr_year",
				"new_individual_metrics"="fi_year",
				"updated_individual_metrics"="fi_year",
				"deleted_individual_metrics"="fi_year"
		
		)
		if (!is.null(column_year)){
			data_error <- bind_rows(data_error, check_missing(
							dataset = data_xls,
							namedataset = sheet,		
							column = column_year,
							country = country))
			
			data_error <- bind_rows(data_error, check_type(
							dataset = data_xls,					
							namedataset= sheet,		
							column=column_year,
							country=country,
							type="numeric"))
		}
		
		
		column_date <- switch(sheet,
				"new_group_metrics"=NULL,
				"updated_group_metrics"=NULL,
				"deleted_group_metrics"=NULL,
				"new_individual_metrics"="fi_date",
				"updated_individual_metrics"="fi_date",
				"deleted_individual_metrics"="fi_date"
		)
		if (!is.null(column_date)){
			data_error <- bind_rows(data_error, check_missing(
							dataset = data_xls,
							namedataset = sheet,		
							column = column_date,
							country = country))
			
			data_error <- bind_rows(data_error, check_type(
							dataset = data_xls,					
							namedataset= sheet,		
							column=column_date,
							country=country,
							type="numeric"))
		}
		
		
		if (grepl("metrics", sheet)) {
# all mty related columns should be numeric
			resmetrics <- 
					do.call(bind_rows,lapply(c("lengthmm",
											"weightg",
											"ageyear",
											"eye_diam_mean_mm",
											"pectoral_lengthmm",
											"female_proportion",
											'is_female_(1=female,0=male)',
											"is_differentiated_(1=differentiated,0_undifferentiated)",	
											"differentiated_proportion",
											"anguillicola_proportion",
											"anguillicola_presence(1=present,0=absent)",			
											"anguillicola_intensity",
											"muscle_lipid_fatmeter_perc",
											"muscle_lipid_gravimeter_perc",
											"sum_6_pcb",
											"teq",
											"evex_proportion",
											"evex_presence_(1=present,0=absent)",			
											"hva_proportion",
											"hva_presence_(1=present,0=absent)",			
											"pb",
											"hg",
											"cd",
											"m_mean_lengthmm",
											"m_mean_weightg",
											"m_mean_ageyear",
											"f_mean_lengthmm",
											"f_mean_weightg",
											"f_mean_age",
											"g_in_gy_proportion",
											"s_in_ys_proportion"),			
									function(name_column){
										if (name_column %in% colnames(data_xls)){	
											data_error <- check_type(
													dataset = data_xls,					
													namedataset = sheet,
													column=name_column,
													country=country,
													type="numeric")
											return(as.data.frame(data_error))}
										
									}))
			data_error <- bind_rows(data_error,	resmetrics)
			
			
			#check that proportions are indeed between 0 and 1
			resmetrics <- 
			  do.call(bind_rows,
			                         lapply(c("female_proportion",
			                          'is_female_(1=female,0=male)',
			                          "is_differentiated_(1=differentiated,0_undifferentiated)",	
			                          "differentiated_proportion",
			                          "anguillicola_proportion",
			                          "anguillicola_presence(1=present,0=absent)",			
			                          "evex_proportion",
			                          "evex_presence_(1=present,0=absent)",			
			                          "hva_proportion",
			                          "hva_presence_(1=present,0=absent)",			
			                          "g_in_gy_proportion",
			                          "s_in_ys_proportion"),			
			                        function(name_column){
			                          if (name_column %in% colnames(data_xls)){	
			                            data_error <- check_between(
			                              dataset = data_xls,					
			                              namedataset = sheet,
			                              column=name_column,
			                              country=country,
			                              minvalue=0,
			                              maxvalue=1)
			                            return(as.data.frame(data_error))}
			                          
			                        }))
			data_error <- bind_rows(data_error,	resmetrics	)
			
			
			#check that percentages are indeed between 0 and 100
			resmetrics <- 
			  do.call(bind_rows,
			                         lapply(c("muscle_lipid_fatmeter_perc",
			                          "muscle_lipid_gravimeter_perc"),			
			                        function(name_column){
			                          if (name_column %in% colnames(data_xls)){	
			                            data_error <- check_between(
			                              dataset = data_xls,					
			                              namedataset = sheet,
			                              column=name_column,
			                              country=country,
			                              minvalue=0,
			                              maxvalue=100)
			                            return(as.data.frame(data_error))}
			                          
			                        }))
			data_error <- bind_rows(data_error,	resmetrics	)
			
			
		} # end if metrics

		return(list(data=data_xls,error=data_error))
	}	# 	fn_check_gr_ind		
	
	
	
	
#	new_group_metrics <- fn_check_series("new_group_metrics", 
#			columns=c("sai_name", "sai_emu_nameshort",	"gr_year",	"grsa_lfs_code", "gr_number", "gr_comment","lengthmm",	"weightg",	"ageyear",	"female_proportion", "differentiated_proportion",
#					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age","g_in_gy_proportion",	"s_in_ys_proportion",	
#					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",	"evex_proportion",	
#					"hva_proportion",	"pb",	"hg",	"cd"), 
#			nbcol=30)	
#	
	sheet <- list(
			"new_group_metrics",
			"updated_group_metrics",
			"deleted_group_metrics",
			"new_individual_metrics",
			"updated_individual_metrics",
			"deleted_individual_metrics")
	columns <- list(
			c("sai_name", "sai_emu_nameshort",	"gr_year",	"grsa_lfs_code", "gr_number", "gr_comment","lengthmm",	"weightg",	"ageyear",	"female_proportion", "differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age","g_in_gy_proportion",	"s_in_ys_proportion",	
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",	"evex_proportion",	
					"hva_proportion",	"pb",	"hg",	"cd"),
			c("gr_id", "sai_name", "sai_emu_nameshort",	"gr_year",	"grsa_lfs_code", "gr_number", "gr_comment",  "gr_last_update", "gr_dts_datasource", "lengthmm",	"weightg",	"ageyear",	"female_proportion", "differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age","g_in_gy_proportion",	"s_in_ys_proportion",	
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",	"evex_proportion",	
					"hva_proportion",	"pb",	"hg",	"cd"),
			c("gr_id", "sai_name", "sai_emu_nameshort",	"gr_year",	"grsa_lfs_code", "gr_number", "gr_comment", "gr_last_update", "gr_dts_datasource","lengthmm",	"weightg",	"ageyear",	"female_proportion", "differentiated_proportion",
					"m_mean_lengthmm","m_mean_weightg","m_mean_ageyear","f_mean_lengthmm","f_mean_weightg","f_mean_age","g_in_gy_proportion",	"s_in_ys_proportion",	
					"anguillicola_proportion",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",	"evex_proportion",	
					"hva_proportion",	"pb",	"hg",	"cd"),
			c("sai_name",	"sai_emu_nameshort",	"fi_date",	"fi_year", "fi_lfs_code",	"fisa_x_4326",	"fisa_y_4326",
					"fi_comment",  "lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"),
			c("fi_id","sai_name",	"sai_emu_nameshort", "fi_date",	"fi_year",	 "fi_lfs_code", "fisa_x_4326",	"fisa_y_4326", "fi_comment",  "fi_last_update",	"fi_dts_datasource", 
					"lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"),
			c("fi_id","sai_name",	"sai_emu_nameshort", "fi_date",	"fi_year", "fi_lfs_code",	"fisa_x_4326",	"fisa_y_4326", "fi_comment",  "fi_last_update",	"fi_dts_datasource", 
					"lengthmm",	"weightg",	"ageyear",	"eye_diam_meanmm", "pectoral_lengthmm",
					"is_female_(1=female,0=male)","is_differentiated_(1=differentiated,0_undifferentiated)",
					"anguillicola_presence_(1=present,0=absent)",	"anguillicola_intensity",	"muscle_lipid_fatmeter_perc", "muscle_lipid_gravimeter_perc",	"sum_6_pcb", "teq",
					"evex_presence_(1=present,0=absent)","hva_presence_(1=present,0=absent)",	"pb",	"hg",	"cd"))
	nbcol <- sapply(columns,length)
	res <- purrr::pmap(list(sheet,columns,nbcol), fn_check_gr_ind)
	data_error <- 	lapply(res,function(X)X$error) %>% bind_rows()
	
	shinybusy::remove_modal_spinner()
	return(invisible(list(
							sampling_info = sampling_info,
							new_group_metrics =  res[[1]]$data, 
							updated_group_metrics = res[[2]]$data, 
							deleted_group_metrics = res[[3]]$data, 
							new_individual_metrics = res[[4]]$data, 
							updated_individual_metrics = res[[5]]$data, 
							deleted_individual_metrics = res[[6]]$data,
							error = data_error,
							the_metadata = the_metadata))) 
	
}


