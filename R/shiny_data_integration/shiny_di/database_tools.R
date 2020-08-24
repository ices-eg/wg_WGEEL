# Name : compare_with_database.R Date : 04/07/2018 Author: cedric.briand



#' @title compare with database for t_eelstock_eel
#' @description This function loads the data from the database and compare it with data
#' loaded from excel, the 
#' @param data_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @return A list with three dataset, one is duplicate the other new, they correspond 
#' to duplicates values that have to be checked by wgeel and when a new value
#' is selected the database data has to be removed and the new lines needs to be qualified.
#' THe second dataset (new) contains new value, these also will need to be qualified by wgeel
#' the last data set is contains all records that will be in the db for the country after
#' inclusion of the new records
#' @details There are various checks to ensure there is no problem at this turn, the tr_type_typ reference dataset will be loaded if absent,
#' To extract duplicates, this function does a merge of excel and base values using inner join,
#' and adds a column keep_new_value where the user will have to select whether to replace conflicting 
#' values with the new (TRUE) or discard it and keep the old value (FALSE).
#' @examples 
#' \dontrun{
#' if(interactive()){
#' # choose a dataset such as catch_landings.xls
#' wg_file.choose<-file.choose
#' data_from_excel<-load_catch_landings(wg_file.choose(),"dc_2018")$data
#' data_from_excel<-load_release(wg_file.choose(),datasource="test")$data
#' data_from_base<-extract_data('landings')
#' data_from_base<-extract_data('b0')
#' data_from_base<-extract_data('release')
#' list_comp<-compare_with_database(data_from_excel,data_from_base)
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{filter}},\code{\link[dplyr]{select}},\code{\link[dplyr]{inner_join}},\code{\link[dplyr]{right_join}}
#' @rdname compare_with_database
#' @importFrom dplyr filter select inner_join right_join
compare_with_database <- function(data_from_excel, data_from_base) {
  # tr_type_typ should have been loaded by global.R in the program in the shiny app
  if (!exists("tr_type_typ")) {
    tr_type_typ<-extract_ref("Type of series")
  }
  # data integrity checks
  if (nrow(data_from_excel) == 0) 
    stop("There are no data coming from the excel file")
  current_cou_code <- unique(data_from_excel$eel_cou_code)
  if (length(current_cou_code) != 1) 
    stop("There is more than one country code, this is wrong")
  current_typ_name <- unique(data_from_excel$eel_typ_name)
  if (!all(current_typ_name %in% tr_type_typ$typ_name)) stop(str_c("Type ",current_typ_name[!current_typ_name %in% tr_type_typ$typ_name]," not in list of type name check excel file"))
  # all data returned by loading functions have only a name just in case to avoid doubles
  
  if (!"eel_typ_id"%in%colnames(data_from_excel)) {
    # extract subset suitable for merge
    tr_type_typ_for_merge <- tr_type_typ[, c("typ_id", "typ_name")]
    colnames(tr_type_typ_for_merge) <- c("eel_typ_id", "eel_typ_name")
    data_from_excel <- merge(data_from_excel, tr_type_typ_for_merge, by = "eel_typ_name") 
  }
  if (nrow(data_from_base) == 0) {
    # the data_from_base has 0 lines and 0 columns
    # this poses computation problems
    # I'm changing it here by loading a correct empty dataset
    load("common/data/data_from_base_0L.Rdata")
    data_from_base<-data_from_base0L
    warning("No data in the file coming from the database")
    current_typ_id<-0
  } else {   
    current_typ_id <- unique(data_from_excel$eel_typ_id)
    if (!all(current_typ_id %in% data_from_base$eel_typ_id)) 
      stop(paste("There is a mismatch between selected typ_id", paste0(current_typ_id, 
                                                                       collapse = ";"), "and the dataset loaded from base", paste0(unique(data_from_base$eel_typ_id), 
                                                                                                                                   collapse = ";"), "did you select the right File type ?"))
  }
  # Can't join on 'eel_area_division' x 'eel_area_division' because of incompatible
  # types (character / logical)
  data_from_excel$eel_area_division <- as.character(data_from_excel$eel_area_division)
  data_from_excel$eel_hty_code <- as.character(data_from_excel$eel_hty_code)
  eel_colnames <- colnames(data_from_base)[grepl("eel", colnames(data_from_base))]

  #since dc2020, qal_id are automatically created during the import
  data_from_excel$eel_qal_id <- ifelse(is.na(data_from_excel$eel_value),0,1)
  data_from_excel$eel_qal_comment <- rep(NA,nrow(data_from_excel))

  # duplicates are inner_join eel_cou_code added to the join just to avoid
  # duplication
  duplicates <- data_from_base %>% dplyr::filter(eel_typ_id %in% current_typ_id & 
                                                   eel_cou_code == current_cou_code) %>% dplyr::select(eel_colnames) %>% # dplyr::select(-eel_cou_code)%>%
    dplyr::inner_join(data_from_excel, by = c("eel_typ_id", "eel_year", "eel_lfs_code", 
                                              "eel_emu_nameshort", "eel_cou_code", "eel_hty_code", "eel_area_division"), 
                      suffix = c(".base", ".xls"))
  duplicates$keep_new_value <- vector("logical", nrow(duplicates))
  duplicates <- duplicates[, c("eel_id", "eel_typ_id", "eel_typ_name", "eel_year", 
                               "eel_value.base", "eel_value.xls", "keep_new_value", "eel_qal_id.xls", "eel_qal_comment.xls", 
                               "eel_qal_id.base", "eel_qal_comment.base", "eel_missvaluequal.base", "eel_missvaluequal.xls", 
                               "eel_emu_nameshort", "eel_cou_code", "eel_lfs_code", "eel_hty_code", "eel_area_division", 
                               "eel_comment.base", "eel_comment.xls", "eel_datasource.base", "eel_datasource.xls")]
  new <- dplyr::anti_join(data_from_excel, data_from_base, by = c("eel_typ_id", 
                                                                  "eel_year", "eel_lfs_code", "eel_emu_nameshort", "eel_hty_code", "eel_area_division", 
                                                                  "eel_cou_code"), suffix = c(".base", ".xls"))
  new <- new[, c("eel_typ_id", "eel_typ_name", "eel_year", "eel_value", "eel_missvaluequal", 
                 "eel_emu_nameshort", "eel_cou_code", "eel_lfs_code", "eel_hty_code", "eel_area_division", 
                 "eel_qal_id", "eel_qal_comment", "eel_datasource", "eel_comment")]
  complete <- rbind.data.frame(data_from_base[data_from_base$eel_cou_code %in% unique(new$eel_cou_code),
                                              c("eel_typ_id", "eel_year", "eel_lfs_code", 
                                                "eel_emu_nameshort", "eel_cou_code", "eel_hty_code")],
                               new[,c("eel_typ_id", "eel_year", "eel_lfs_code", 
                                      "eel_emu_nameshort", "eel_cou_code", "eel_hty_code")])
  return(list(duplicates = duplicates, new = new, current_cou_code= current_cou_code, complete=complete))
}
#' @title compare with database for updated values
#' @description This function retrieves older values in the database and compares it with data
#' loaded from excel, the 
#' @param updated_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @return A table that compares data in the data base and corresponding updated values
#' @importFrom dplyr filter select inner_join right_join
compare_with_database_updated_values <- function(updated_from_excel, data_from_base) {
	# tr_type_typ should have been loaded by global.R in the program in the shiny app
	if (!exists("tr_type_typ")) {
		tr_type_typ<-extract_ref("Type of series")
	}
	# data integrity checks
	if (nrow(updated_from_excel) == 0) 
		stop("There are no data coming from the excel file")
	current_cou_code <- unique(updated_from_excel$eel_cou_code)
	if (length(current_cou_code) != 1) 
		stop("There is more than one country code, this is wrong")
	current_typ_name <- unique(updated_from_excel$eel_typ_name)
	if (!all(current_typ_name %in% tr_type_typ$typ_name)) stop(str_c("Type ",current_typ_name[!current_typ_name %in% tr_type_typ$typ_name]," not in list of type name check excel file"))
	# all data returned by loading functions have only a name just in case to avoid doubles
	
	if (!"eel_typ_id"%in%colnames(updated_from_excel)) {
		# extract subset suitable for merge
		tr_type_typ_for_merge <- tr_type_typ[, c("typ_id", "typ_name")]
		colnames(tr_type_typ_for_merge) <- c("eel_typ_id", "eel_typ_name")
		updated_from_excel <- merge(updated_from_excel, tr_type_typ_for_merge, by = "eel_typ_name") 
	}
	if (nrow(data_from_base) == 0) {
		stop("No data in the db")
		current_typ_id<-0
	} else {   
		if (!all(updated_from_excel$eel_id %in% data_from_base$eel_id))
			stop(paste("eel_id",paste(updated_from_excel$eel_id[!updated_from_excel$eel_id %in% data_from_base$eel_id],collapse=","),
							"not found in db",sep=""))
		current_typ_id <- unique(updated_from_excel$eel_typ_id)
		if (!all(current_typ_id %in% data_from_base$eel_typ_id)) 
			stop(paste("There is a mismatch between selected typ_id", paste0(current_typ_id, 
									collapse = ";"), "and the dataset loaded from base", paste0(unique(data_from_base$eel_typ_id), 
									collapse = ";"), "did you select the right File type ?"))
	}
	# Can't join on 'eel_area_division' x 'eel_area_division' because of incompatible
	# types (character / logical)
	updated_from_excel$eel_area_division <- as.character(updated_from_excel$eel_area_division)
	updated_from_excel$eel_hty_code <- as.character(updated_from_excel$eel_hty_code)
	eel_colnames <- colnames(data_from_base)[grepl("eel", colnames(data_from_base))]
	
	#since dc2020, qal_id are automatically created during the import
	updated_from_excel$eel_qal_id <- 1
	updated_from_excel$eel_qal_comment <- rep(NA,nrow(updated_from_excel))
	
	# duplicates are inner_join eel_cou_code added to the join just to avoid
	# duplication
	comparison_updated <- merge(updated_from_excel,data_from_base,by=c("eel_id","eel_typ_id"),
			all.y=FALSE,all.x=TRUE,suffix = c(".xls",".base"))
	comparison_updated <- comparison_updated[, c("eel_id", "eel_typ_id", "eel_typ_name", "eel_year.base", "eel_year.xls",
					"eel_value.base", "eel_value.xls", "eel_missvaluequal.base", "eel_missvaluequal.xls", 
					"eel_emu_nameshort.base","eel_emu_nameshort.xls", "eel_cou_code.base","eel_cou_code.xls",
					"eel_lfs_code.base","eel_lfs_code.xls", "eel_hty_code.base","eel_hty_code.xls",
					"eel_area_division.base", "eel_area_division.xls","eel_comment.base", 
					"eel_comment.xls", "eel_datasource.base", "eel_datasource.xls",
					"eel_qal_id.xls", "eel_qal_comment.xls", "eel_qal_id.base", "eel_qal_comment.base")]
	
	return(comparison_updated)
}



#' @title compare with database series
#' @description This function loads the data from the database and compare it with data
#' loaded from excel
#' @param data_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @return A list with three dataset, one is duplicate the other new, 
#' in the case of series the duplicates are ignored
#' THe second dataset (new) contains new value, these also will need to be qualified by wgeel
#' the last data set contains all records that will be in the db for the country after
#' inclusion of the new records
#' @examples 
#' \dontrun{
#' if(interactive()){
#' wg_file.choose<-file.choose
#' path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wgeel\\datacall\\FR\\Eel_Data_Call_2020_Annex1_time_series_FR_Recruitment.xlsx"
#' data_from_excel <- read_excel(path=path,	sheet ="series_info",	skip=0) #'  
#' data_from_base <- extract_data('t_series_ser')
#' 
#' list_comp <- compare_with_database_series(data_from_excel,data_from_base)
#'  }
#' }
compare_with_database_series <- function(data_from_excel, data_from_base) {
	# data integrity checks
	if (nrow(data_from_excel) == 0) 
		stop("There are no data coming from the excel file")
	current_cou_code <- unique(data_from_excel$ser_cou_code)
	if (length(current_cou_code) != 1) 
		stop("There is more than one country code, this is wrong")	
	if (nrow(data_from_base) == 0) {
		# the data_from_base has 0 lines and 0 columns
		# this poses computation problems
		# I'm changing it here by loading a correct empty dataset
		#data_from_base_series <- data_from_base[FALSE,]		
		#save(data_from_base_series, file = "C:\\workspace\\gitwgeel\\R\\shiny_data_integration\\shiny_di\\common\\data\\data_from_base_series_0L.Rdata")
		load("common/data/data_from_base_series_0L.Rdata")
		data_from_base <- data_from_base_series
		warning("No data in the file coming from the database")
		current_typ_id <- 0
	} else {   
		current_typ_id <- unique(data_from_excel$ser_typ_id)
		if (!all(current_typ_id %in% data_from_base$ser_typ_id)) 
			stop(paste("There is a mismatch between selected typ_id", paste0(current_typ_id, 
									collapse = ";"), "and the dataset loaded from base", paste0(unique(data_from_base$ser_typ_id), 
									collapse = ";"), "did you select the right File type ?"))
	}
	
	ser_colnames <- colnames(data_from_base)[grepl("ser", colnames(data_from_base))]
	# avoid importing problems when line is null
	data_from_excel <- data_from_excel %>% mutate_if(is.logical,list(as.numeric)) 
	data_from_excel <- data_from_excel %>% 
			mutate_at(vars(ser_dts_datasource, ser_comment, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort,
							ser_area_division,ser_cou_code),list(as.character)) 
	duplicates <- data_from_base %>% dplyr::filter(ser_typ_id %in% current_typ_id & 
							ser_cou_code == current_cou_code) %>% dplyr::select(ser_colnames) %>% # dplyr::select(-eel_cou_code)%>%
			dplyr::inner_join(data_from_excel, by = c("ser_typ_id",  "ser_nameshort"), 
					suffix = c(".base", ".xls"))
	duplicates <- duplicates[, 
			# not in the datacall or used as pivot :
			c("ser_id", "ser_order", "ser_nameshort", "ser_typ_id", "ser_qal_id" ,"ser_qal_comment","ser_ccm_wso_id", 
					
					# other columns
					"ser_dts_datasource.base","ser_dts_datasource.xls",
					"ser_namelong.base", "ser_namelong.xls", 
					"ser_effort_uni_code.base", "ser_effort_uni_code.xls",
					"ser_comment.base", "ser_comment.xls", 
					"ser_uni_code.base", "ser_uni_code.xls", 
					"ser_lfs_code.base", "ser_lfs_code.xls",
					"ser_hty_code.base", "ser_hty_code.xls",
					"ser_locationdescription.base",  "ser_locationdescription.xls",
					"ser_emu_nameshort.base", "ser_emu_nameshort.xls",
					"ser_cou_code.base", "ser_cou_code.xls",
					"ser_area_division.base", "ser_area_division.xls",
					"ser_tblcodeid.base", "ser_tblcodeid.xls", 
					"ser_x.base","ser_x.xls",
					"ser_y.base", "ser_y.xls",
					"ser_sam_id.base",  "ser_sam_id.xls")]
	# Anti join only keeps columns from X
	new <-  dplyr::anti_join(data_from_excel, data_from_base, 
			by = c("ser_nameshort", "ser_typ_id"))
	if (nrow(new) >0 ){
		new$ser_qal_id <- NA
		new$ser_qal_comment <- NA
		new$ser_order <- NA
		new$ser_ccm_wso_id <- "{}"
		new$ser_dts_datasource <- the_eel_datasource
	}
	modified <- dplyr::anti_join(data_from_excel, data_from_base, 
			by = c("ser_nameshort", "ser_typ_id", "ser_effort_uni_code", "ser_comment", "ser_uni_code", 
					"ser_lfs_code", "ser_hty_code", "ser_locationdescription", "ser_emu_nameshort",
					"ser_cou_code", "ser_area_division", "ser_x", "ser_y", "ser_sam_id" ))
	modified <- modified[!modified$ser_nameshort %in% new$ser_nameshort,]
	# after anti join there are still values that are not really changed.
	# this is further investigated below
	highlight_change <- duplicates[duplicates$ser_nameshort %in% modified$ser_nameshort,]
	
	if (nrow(highlight_change)>0){
		num_common_col <- grep(".xls|.base",colnames(highlight_change))
		possibly_changed <- colnames(highlight_change)[num_common_col]
		
		mat <-	matrix(FALSE,nrow(highlight_change),length(num_common_col))
		for(v in 0:(length(num_common_col)/2-1))
		{
			v=v*2+1
			test <- highlight_change %>% select(num_common_col)%>%select(v,v+1) %>%
					mutate_all(as.character) %>%	mutate_all(type.convert, as.is = TRUE) %>%	
					mutate(test=identical(.[[1]], .[[2]])) %>% pull(test)
			mat[,c(v,v+1)]<-test
			
		}
		# select only rows where there are true modified 
		modified <- modified[!apply(mat,1,all),]	 
		# show only modifications to the user (any colname modified)
		
		highlight_change <- highlight_change[!apply(mat,1,all),num_common_col[!apply(mat,2,all)]]
	}
	
	return(list(new = new, modified=modified, highlight_change=highlight_change, current_cou_code= current_cou_code))
}

#' @title compare with database dataseries
#' @description This function loads the data from the database and compare it with data
#' loaded from excel
#' @param data_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @param sheetorigin = c("new","updated"), to indicate that this comes from the "new_data" or "updated_data" sheet in the datacall as these will be treated together
#' @return A list with three dataset, one is duplicate the other new, 
#' in the case of series the duplicates are ignored
#' THe second dataset (new) contains new value, these also will need to be qualified by wgeel
#' the last data set contains all records that will be in the db for the country after
#' inclusion of the new records
#' @examples 
#' \dontrun{
#' if(interactive()){
#' wg_file.choose<-file.choose
#' path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wgeel\\datacall\\FR\\Eel_Data_Call_2020_Annex1_time_series_FR_Recruitment.xlsx"
#' data_from_excel <- read_excel(path=path,	sheet ="new_data",	skip=0) 
#' data_from_base <- extract_data('t_dataseries_das',quality_check=FALSE)
#' series <- extract_data('t_series_ser',quality_check=FALSE)
#' data_from_excel <- left_join(data_from_excel, series[,c("ser_id","ser_nameshort")], by="ser_nameshort")
#' data_from_excel <- rename(data_from_excel,"das_ser_id"="ser_id")
#' list_comp <- compare_with_database_dataseries(data_from_excel,data_from_base)
#'  }
#' }
compare_with_database_dataseries <- function(data_from_excel, data_from_base, sheetorigin="new_data") {
	# data integrity checks
	error_id_message <- ""
	if (nrow(data_from_excel) == 0) 
		stop("There are no data coming from the excel file")
	if (nrow(data_from_base) == 0) {
		# the data_from_base has 0 lines and 0 columns
		# this poses computation problems
		# I'm changing it here by loading a correct empty dataset
		#data_from_base_dataseries <- data_from_base[FALSE,]		
		#save(data_from_base_dataseries, file = "C:\\workspace\\gitwgeel\\R\\shiny_data_integration\\shiny_di\\common\\data\\data_from_base_dataseries_0L.Rdata")
		load("common/data/data_from_base_dataseries_0L.Rdata")
		data_from_base <- data_from_base_dataseries
		warning("No data in the file coming from the database")
	}
	# convert columns with missing data to numeric	  
	data_from_excel <- data_from_excel %>% mutate_if(is.logical,list(as.numeric)) 
	data_from_excel <- data_from_excel %>% mutate_at(vars(das_dts_datasource,das_comment),list(as.character)) 
	#data_from_excel <- data_from_excel %>% mutate_at(vars(matches("update")),list(as.Date)) 	
	
	data_from_excel$sheetorigin <- sheetorigin
	
	
	duplicates <- data_from_base %>% 	dplyr::inner_join(data_from_excel, by = c("das_ser_id","das_year"), 
			suffix = c(".base", ".xls"))
	# If the data_from_excel corresponds to the updated_data tab, then there is a das_id
	if ("das_id" %in% colnames(data_from_excel)){
		
		duplicates <- duplicates[, 
				# not in the datacall or used as pivot :
				c("das_ser_id","das_year", "ser_nameshort", "das_last_update",
						# duplicates columns
						"das_id.base", "das_id.xls",
						"das_qal_id.base", "das_qal_id.xls",
						"das_dts_datasource.base", "das_dts_datasource.xls",
						"das_value.base", "das_value.xls",					
						"das_comment.base", "das_comment.xls",
						"das_effort.base", "das_effort.xls",
						"sheetorigin")]
		if (any(duplicates$das_id.base!=duplicates$das_id.excel)) error_id_message <- "<p style='color:red;'>There is a problem with id, 
					they have changed this indicates that year or series has changed, check carefully </p>"
		
		
	} else {
		duplicates <- duplicates[, 
				# not in the datacall or used as pivot :
				c("das_id", "das_ser_id","das_year", "ser_nameshort", "das_qal_id","das_last_update",
						# duplicates columns
						"das_dts_datasource.base", "das_dts_datasource.xls",
						"das_value.base", "das_value.xls",					
						"das_comment.base", "das_comment.xls",
						"das_effort.base", "das_effort.xls",
						"sheetorigin")]
	}
	# Anti join only keeps columns from X
	new <-  dplyr::anti_join(as.data.frame(data_from_excel), data_from_base, 
			by = c("das_ser_id","das_year"))
	if (nrow(new)>0){
		new$das_qal_id <- NA
		new$das_dts_datasource <- the_eel_datasource
		# das_id might come from updated, identified as new, then we have a pb and remove it
		if ("das_id" %in% colnames(new)) {
			new <- new %>% select(-das_id)
		}
	}
	
	# normally there should not be any modified in new but let's check
	modified <- dplyr::anti_join(data_from_excel, data_from_base, 
			by = c("das_year", "das_value", "das_comment", "das_effort", "das_ser_id")
	)
	modified <- modified[!modified$ser_nameshort %in% new$ser_nameshort,]
	highlight_change <- duplicates[duplicates$ser_nameshort %in% modified$ser_nameshort,]
	if (nrow(modified) >0 ) {
		
		
		
		num_common_col <- grep(".xls|.base",colnames(highlight_change))
		possibly_changed <- colnames(highlight_change)[num_common_col]
		
		mat <-	matrix(FALSE,nrow(highlight_change),length(num_common_col))
		for(v in 0:(length(num_common_col)/2-1))
		{
			v=v*2+1
			test <- highlight_change %>% select(num_common_col)%>%select(v,v+1) %>%
					mutate_all(as.character) %>%	mutate_all(type.convert, as.is = TRUE) %>%	
					mutate(test=identical(.[[1]], .[[2]]))%>%pull(test)
			mat[,c(v,v+1)]<-test
			
		}
		# select only rows where there are true modified 
		modified <- modified[!apply(mat,1,all),]	 
		# show only modifications to the user (any colname modified)	
		highlight_change <- highlight_change[!apply(mat,1,all),num_common_col[!apply(mat,2,all)]]
	}
	# when modified come from new data, I need the id
	if (!"das_id" %in% colnames(modified)){
			modified <- inner_join(
					data_from_base[,c("das_year","das_ser_id","das_id", "das_qal_id")], 
					modified, by= c("das_ser_id","das_year"))
		}
	
	return(list(new = new, modified=modified, highlight_change=highlight_change, error_id_message=error_id_message))
}

#' @title compare with database biometry
#' @description This function loads the data from the database and compare it with data
#' loaded from excel
#' @param data_from_excel Dataset loaded from excel
#' @param data_from_base dataset loaded from the database with previous values to be replaced
#' @return A list with three dataset, one is duplicate the other new, 
#' in the case of series the duplicates are ignored
#' THe second dataset (new) contains new value, these also will need to be qualified by wgeel
#' the last data set contains all records that will be in the db for the country after
#' inclusion of the new records
#' @examples 
#' \dontrun{
#' if(interactive()){
#' wg_file.choose<-file.choose
#' path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2020\\wgeel\\datacall_files\\FR\\Eel_Data_Call_2020_Annex1_time_series_FR_Recruitment.xlsx"
#' data_from_excel <- read_excel(path=path,	sheet ="new_biometry",	skip=0) 
#' data_from_base <- extract_data('t_biometry_series_bis',quality_check=FALSE)
#' series <- extract_data('t_series_ser',quality_check=FALSE)
#' list_comp <- compare_with_database_biometry(data_from_excel,data_from_base)
#'  }
#' }
compare_with_database_biometry <- function(data_from_excel, data_from_base, sheetorigin="new_data") {
	# data integrity checks
	
	if (nrow(data_from_excel) == 0) 
		stop("There are no data coming from the excel file")
	if (nrow(data_from_base) == 0) {
		# the data_from_base has 0 lines and 0 columns
		# this poses computation problems
		# I'm changing it here by loading a correct empty dataset
		#data_from_base_biometry0L <- data_from_base[FALSE,]		
		#save(data_from_base_biometry0L, file = "C:\\workspace\\gitwgeel\\R\\shiny_data_integration\\shiny_di\\common\\data\\data_from_base_biometry_0L.Rdata")
		load("common/data/data_from_base_biometry_0L.Rdata")
		data_from_base <- data_from_base_biometry0L
		warning("No data in the file coming from the database")
	}
	# convert columns with missing data to numeric	  
	data_from_excel <- data_from_excel %>% mutate_if(is.logical,list(as.numeric)) 
	data_from_excel <- data_from_excel %>% mutate_at(vars(matches("comment")),list(as.character)) 
	#data_from_excel <- data_from_excel %>% mutate_at(vars(matches("update")),list(as.Date)) 	
	data_from_excel <- data_from_excel %>% select(-"bio_qal_id")
	data_from_excel$sheetorigin <- sheetorigin
	
	# removed pre-filled data not modified by user.
	
	remove_all_na <- data_from_excel %>% 
			select(-bis_ser_id,-ser_nameshort,-bio_year, -sheetorigin) %>%
			filter_all(all_vars(is.na(.))) %>%
			tibble::rowid_to_column("id") %>%
			pull(id)
	if (length(remove_all_na) > 0){	data_from_excel <- data_from_excel[-remove_all_na,]}
	
	duplicates <- data_from_base %>% 	dplyr::inner_join(data_from_excel, by = c("bis_ser_id"), 
			suffix = c(".base", ".xls"))
	duplicates <- duplicates[, 
			# not in the datacall or used as pivot :
			c("bio_id", "bio_lfs_code", "bio_qal_id", "bis_ser_id", "ser_nameshort",
					"bio_dts_datasource.base", "bio_dts_datasource.xls",
					"bio_year.base","bio_year.xls",
					"bio_length.base", "bio_length.xls",
					"bio_weight.base","bio_weight.xls",
					"bio_age.base", "bio_age.xls",
					"bio_sex_ratio.base","bio_sex_ratio.xls",
					"bio_length_f.base", "bio_length_f.xls",
					"bio_weight_f.base", "bio_weight_f.xls",
					"bio_age_f.base", "bio_age_f.xls",
					"bio_length_m.base", "bio_length_m.xls",
					"bio_weight_m.base","bio_weight_m.xls",
					"bio_age_m.base", "bio_age_m.xls",
					"bio_comment.base", "bio_comment.xls",
					"bio_last_update.base", "bio_last_update.xls",
					"bis_g_in_gy.base",  "bis_g_in_gy.xls" )%in% colnames(duplicates)]
	
	# Anti join only keeps columns from X
	new <-  dplyr::anti_join(as.data.frame(data_from_excel), data_from_base, 
			by = c("bis_ser_id","bio_year"))
	
	
	
	if (nrow(new)>0)	new$bio_dts_datasource <- the_eel_datasource
	
	# normally there should not be any modified in new but let's check
	modified <- dplyr::anti_join(as.data.frame(data_from_excel), data_from_base, 
			by =c( "bio_year", "bio_length", "bio_weight", "bio_age", "bio_sex_ratio", "bio_length_f", "bio_weight_f", "bio_age_f", "bio_length_m", "bio_weight_m", "bio_age_m", "bio_comment", "bis_g_in_gy", "bis_ser_id" )
	)
	modified <- modified[!modified$ser_nameshort %in% new$ser_nameshort,]
	highlight_change <- duplicates[duplicates$ser_nameshort %in% modified$ser_nameshort,]
	
	if (nrow(modified) >0 ) {
		
		
		
		num_common_col <- grep(".xls|.base",colnames(highlight_change))
		possibly_changed <- colnames(highlight_change)[num_common_col]
		
		mat <-	matrix(FALSE,nrow(highlight_change),length(num_common_col))
		for(v in 0:(length(num_common_col)/2-1))
		{
			v=v*2+1
			test <- highlight_change %>% select(num_common_col)%>%select(v,v+1) %>%
					mutate_all(as.character) %>%	mutate_all(type.convert, as.is = TRUE) %>%	
					mutate(test=identical(.[[1]], .[[2]]))%>%pull(test)
			mat[,c(v,v+1)]<-test
			
		}
		# select only rows where there are true modified 
		modified <- modified[!apply(mat,1,all),]	 
		# show only modifications to the user (any colname modified)	
		highlight_change <- highlight_change[!apply(mat,1,all),num_common_col[!apply(mat,2,all)]]
	}
	
	return(list(new = new, modified=modified, highlight_change=highlight_change))
}


#' @title write duplicated results into the database
#' @description Values kept from the datacall will be inserted, old values from the database
#' will be qualified with a number corresponding to the wgeel datacall (e.g. eel_qal_id=5 for 2018).
#' Values not selected from the datacall will be also be inserted with eel_qal_id=qualify_code
#' @param path path to file (collected from shiny button)
#' @param qualify_code code to insert the data into the database, default 18
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not
#' @examples 
#' \dontrun{
#'  source("../../utilities/set_directory.R") 
#'  path<-wg_file.choose() 
#'  path<-"C:\\Users\\cedric.briand\\Documents\\projets\\GRISAM\\2018\\datacall\\06. Data\\Vattican\\02duplicates_catch_landings_2018-09-04VAcorrected.xlsx"
#'  # qualify_code is 18 for wgeel2018
#'  write_duplicates(path,qualify_code=18)
#' sqldf('delete from datawg.t_eelstock_eel where eel_qal_comment='dummy_for_test'')
#'  }
#' }
#' @rdname write_duplicate
write_duplicates <- function(path, qualify_code = 19) {
	
	duplicates2 <- read_excel(path = path, sheet = 1, skip = 1)
	
	# Initial checks ----------------------------------------------------------------------------------
	
	# the user might select a wrong file, or modify the file the following check
	# should ensure file integrity
	validate(need(ncol(duplicates2) == 22, "number column wrong (should be 22) \n"))
	validate(need(all(colnames(duplicates2) %in% c("eel_id", "eel_typ_id", "eel_typ_name", 
									"eel_year", "eel_value.base", "eel_value.xls", "keep_new_value", "eel_qal_id.xls", 
									"eel_qal_comment.xls", "eel_qal_id.base", "eel_qal_comment.base", "eel_missvaluequal.base", 
									"eel_missvaluequal.xls", "eel_emu_nameshort", "eel_cou_code", "eel_lfs_code", 
									"eel_hty_code", "eel_area_division", "eel_comment.base", "eel_comment.xls", 
									"eel_datasource.base", "eel_datasource.xls")), 
					"Error in replicated dataset : column name changed, have you removed the empty line on top of the dataset ?"))
	
	cou_code = unique(duplicates2$eel_cou_code)
	validate(need(length(cou_code) == 1, "There is more than one country code, please check your file"))
	
	# Checks for column keep_new_value ----------------------------------------------------------------
	
	# select values to be replaced passing through excel does not get keep_new_value
	# with logical R value here I'm testing various mispelling
	
	duplicates2$keep_new_value[duplicates2$keep_new_value == "1"] <- "true"
	duplicates2$keep_new_value[duplicates2$keep_new_value == "0"] <- "false"
	duplicates2$keep_new_value <- toupper(duplicates2$keep_new_value)
	duplicates2$keep_new_value[duplicates2$keep_new_value == "YES"] <- "true"
	duplicates2$keep_new_value[duplicates2$keep_new_value == "NO"] <- "false"
	
	validate( need(all(duplicates2$keep_new_value %in% c("TRUE", "FALSE")), 
					"value in keep_new_value should be false or true"))
	
	duplicates2$keep_new_value <- as.logical(toupper(duplicates2$keep_new_value))
	
	
	# first deprecate old values in the database ----------------------------------------------------
	
	replaced <- duplicates2[duplicates2$keep_new_value, ]
	
	# Checks for qal_id ----------------------------------------------------------------
	
	
	validate( need(all(!is.na(replaced$eel_qal_id.xls)), 
					"All values with true in keep_new_value column should have a value in eel_qal_id \n"))
	
	
	
	if (nrow(replaced) > 0 ) {
		
		replaced$eel_comment.base[is.na(replaced$eel_comment.base)] <- ""
		replaced$eel_comment.base <- paste0(replaced$eel_comment.base, " Value ", 
				replaced$eel_value.base, " replaced by value ", replaced$eel_value.xls, 
				" for datacall ", format(Sys.time(), "%Y"))
		
		
		
		query0 <- paste0("update datawg.t_eelstock_eel set (eel_qal_id,eel_comment)=(", qualify_code ,",r.eel_comment) from ", 
				"replaced_temp_", cou_code, " r where t_eelstock_eel.eel_id=r.eel_id;")
		
		# this will perform the reverse operation if error in query 1 or 2
		# sqldf will handle this one as it is a several liners
		query0_reverse <- paste0("update datawg.t_eelstock_eel set (eel_qal_id,eel_comment)=(", 
				replaced$eel_qal_id.base , ",'", replaced$eel_comment.base, "') where eel_id=", replaced$eel_id,";")
		
		# this query will be run later cause we don't want it to run if the other fail
		
		# second insert the new lines into the database -------------------------------------------------
		
		replaced <- replaced[, c("eel_id", "eel_typ_id", "eel_year", "eel_value.xls", "eel_missvaluequal.xls", 
						"eel_emu_nameshort", "eel_cou_code", "eel_lfs_code", "eel_hty_code", 
						"eel_area_division", "eel_qal_id.xls", "eel_qal_comment.xls", "eel_datasource.xls", 
						"eel_comment.xls")]
		
		replaced$eel_qal_comment.xls <- iconv(replaced$eel_qal_comment.xls,"UTF8")
		replaced$eel_comment.xls <- iconv(replaced$eel_comment.xls,"UTF8")
		
		colnames(replaced) <- gsub(".xls", "", colnames(replaced))
		
		query1 <- str_c("insert into datawg.t_eelstock_eel (         
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
						eel_datasource,
						eel_comment) 
						select eel_typ_id,       
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
						eel_datasource,
						eel_comment from replaced_temp_", cou_code ,";")
		# again this query will be run later cause we don't want it to run if the other fail
		
		# this query will be run to rollback when query2 crashes
		
		query1_reverse <- str_c("delete from datawg.t_eelstock_eel", 
				" where eel_datelastupdate = current_date",
				" and eel_cou_code='",cou_code,"'", 
				" and eel_datasource='",the_eel_datasource ,"';")
		
		
		
	} else {
		
		query0 <- ""
		query0_reverse <- ""
		query1 <- ""
		query1_reverse <- ""
		
	}
	
	# Values not chosen, but we store them in the database --------------------------------------------
	
	not_replaced <- duplicates2[!duplicates2$keep_new_value, ]
	
	if (nrow(not_replaced) > 0 ) {
		
		not_replaced$eel_comment.xls[is.na(not_replaced$eel_comment.xls)] <- ""
		not_replaced$eel_comment.xls <- paste0(not_replaced$eel_comment.xls, " Value ", 
				not_replaced$eel_value.xls, " not used, value from the database ", not_replaced$eel_value.base, 
				" kept instead for datacall ", format(Sys.time(), "%Y"))
		not_replaced$eel_qal_id <- qualify_code
		not_replaced <- not_replaced[, c("eel_typ_id", "eel_year", "eel_value.xls", 
						"eel_missvaluequal.xls", "eel_emu_nameshort", "eel_cou_code", "eel_lfs_code", 
						"eel_hty_code", "eel_area_division", "eel_qal_id", "eel_qal_comment.xls", 
						"eel_datasource.xls", "eel_comment.xls")]
		
		not_replaced$eel_qal_comment.xls <- iconv(not_replaced$eel_qal_comment.xls,"UTF8")
		not_replaced$eel_comment.xls <- iconv(not_replaced$eel_comment.xls,"UTF8")
		
		query2 <- str_c( "insert into datawg.t_eelstock_eel (         
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
						eel_datasource,
						eel_comment) 
						select * from not_replaced_temp_",cou_code,";")
		
	} else {
		
		query2 <- ""
	}
	
	
	# Inserting temporary tables
	# running this with more than one sesssion might lead to crash
	
	sqldf( str_c("drop table if exists not_replaced_temp_",cou_code) )
	sqldf( str_c("create table not_replaced_temp_", cou_code, " as select * from not_replaced") )
	sqldf( str_c("drop table if exists replaced_temp_",cou_code) )
	sqldf( str_c("create table replaced_temp_", cou_code, " as select * from replaced") )
	
	
	# Insertion of the three queries ----------------------------------------------------------------
	
	# if fails replaces the message with this trycatch !  I've tried many ways with
	# sqldf but trycatch failed to catch the error Hence the use of DBI 
	# 
	
	
	
	message <- NULL
	
	# First step, replace values in the database --------------------------------------------------
	
	#sqldf(query0)
	conn <- poolCheckout(pool)
	nr0 <- tryCatch({     
				dbExecute(conn, query0)
			}, error = function(e) {
				message <<- e  
				cat("step1 message :")
				print(message)   
			}, finally = {
				poolReturn(conn)
				
			})
	
	# Second step insert replaced ------------------------------------------------------------------
	if (is.null(message)) {
		conn <- poolCheckout(pool)
		nr1 <- tryCatch({     
					dbExecute(conn, query1)
				}, error = function(e) {
					message <<- e  
					sqldf (query0_reverse)      # perform reverse operation
					cat("step2 message :")
					print(message)
				}, finally = {
					poolReturn(conn)
					sqldf( str_c( "drop table if exists replaced_temp_", cou_code))        
				})
	}
	# Third step insert not replaced values into the database -----------------------------------------
	
	
	if (is.null(message)){ # the previous operation had no error
		conn <- poolCheckout(pool) 
		nr2 <- tryCatch({     
					dbExecute(conn, query2)
				}, error = function(e) {
					message <<- e 
					cat("step3 message :")
					print(message)
					dbExecute(conn, query1_reverse) # this is not surrounded by trycatch, pray it does not fail ....
					sqldf (query0_reverse)      # perform reverse operation    
				}, finally = {
					poolReturn(conn)
					sqldf( str_c( "drop table if exists not_replaced_temp_", cou_code))   
				})
		
	} else {
		sqldf( str_c( "drop table if exists not_replaced_temp_", cou_code))
	}
	if (is.null(message)){  
		message <- sprintf("For duplicates %s values replaced in the database (old values kept with code eel_qal_id=%s)\n,
						%s values not replaced (values from current datacall stored with code eel_qal_id %s)", 
				nr1, qualify_code, nr2, qualify_code)  
	}
	return(list(message = message, cou_code = cou_code))
}




#' @title new results into the database
#' @description New lines will be inserted in the database
#' @param path path to file (collected from shiny button)
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  path<-wg_file.choose() 
#'  #path<-'C:\\Users\\cedric.briand\\Desktop\\06. Data\\datacall(wgeel_2018)\\new_catch_landings_2018-07-23.xlsx'
#'  # path <- "https:\\community.ices.dk\\ExpertGroups\\wgeel\\2019 Meeting Documents/06. Data\\03 Data Submission 2019\\EST\\new_aquaculture_2019-08-07EE.xlsx"
#'  # path <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2019\\datacall\\sharepoint\\03-data_submission_2019\\new_aquaculture_2019-08-07EE.xlsx"
#' # qualify_code is 18 for wgeel2018
#'  write_new(path)
#' sqldf('delete from datawg.t_eelstock_eel where eel_qal_comment='dummy_for_test'')
#'  }
#' }
#' @rdname write_duplicate

write_new <- function(path) {
	
	new <- read_excel(path = path, sheet = 1, skip = 1)
	
	####when there are no data, new values have incorrect type
	new$eel_value <- as.numeric(new$eel_value)
	
	# check for new file -----------------------------------------------------------------------------
	
	validate(need(all(!is.na(new$eel_qal_id)), "There are still lines without eel_qal_id, please check your file"))
	cou_code = unique(new$eel_cou_code)  
	validate(need(length(cou_code) == 1, "There is more than one country code, please check your file"))
	
	# create dataset for insertion -------------------------------------------------------------------
	
	
	new <- new[, c("eel_typ_id", "eel_year", "eel_value", "eel_missvaluequal", "eel_emu_nameshort", 
					"eel_cou_code", "eel_lfs_code", "eel_hty_code", "eel_area_division", "eel_qal_id", 
					"eel_qal_comment", "eel_datasource", "eel_comment")]
	sqldf::sqldf("drop table if exists new_temp ")
	sqldf::sqldf("create table new_temp as select * from new")
	
	# Query uses temp table just created in the database by sqldf
	query <- "insert into datawg.t_eelstock_eel (         
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
			eel_datasource,
			eel_comment) 
			select * from new_temp"
	# if fails replaces the message with this trycatch !  I've tried many ways with
	# sqldf but trycatch failed to catch the error Hence the use of DBI
	conn <- poolCheckout(pool)
	message <- NULL
	nr <- tryCatch({
				dbExecute(conn, query)
			}, error = function(e) {
				message <<- e
			}, finally = {
				poolReturn(conn)
				sqldf::sqldf("drop table if exists new_temp ")
			})
	
	
	if (is.null(message))   
		message <- sprintf(" %s new values inserted in the database", nr)
	
	return(list(message = message, cou_code = cou_code))
}








#' @title update value into the database
#' @description New lines will be inserted in the database and older values will be put
#' to qal_id 4
#' @param path path to file (collected from shiny button)
#' @param qualify_code new qal_id 19
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not

write_updated_values <- function(updated_values_table, qualify_code) {
  cou_code = unique(updated_values_table$eel_cou_code.xls)  
  validate(need(length(cou_code) == 1, "There is more than one country code, please check your file"))

  # create dataset for insertion -------------------------------------------------------------------
  
  
  names(updated_values_table) = gsub(".","_",names(updated_values_table),fixed=TRUE)
  sqldf::sqldf("drop table if exists updated_temp ")
  sqldf::sqldf("create table updated_temp as select * from updated_values_table")
  cyear=format(Sys.Date(), "%Y")
  query=paste("
      DO $$
        DECLARE
      rec RECORD;
      oldid integer;
      newid integer;
      BEGIN
      FOR rec in SELECT * from updated_temp
        LOOP
        BEGIN
          oldid:=rec.eel_id;
          update datawg.t_eelstock_eel set eel_qal_id=",qualify_code," where eel_id=oldid;
            insert into datawg.t_eelstock_eel (eel_typ_id,eel_year,eel_value,eel_missvaluequal,eel_emu_nameshort,eel_cou_code,eel_lfs_code,eel_hty_code,eel_area_division,eel_qal_id, eel_qal_comment,eel_datasource,eel_comment)
            (select eel_typ_id,eel_year_xls,eel_value_xls,eel_missvaluequal_xls,eel_emu_nameshort_xls,eel_cou_code_xls,eel_lfs_code_xls,eel_hty_code_xls,eel_area_division_xls,eel_qal_id_xls,eel_qal_comment_xls,eel_datasource_xls,eel_comment_xls from updated_temp where eel_id=oldid ) returning eel_id into newid;
            update datawg.t_eelstock_eel set eel_qal_comment=coalesce(eel_qal_comment,'') || ' updated to eel_id ' || newid::text || ' in ",cyear,"' where eel_id=oldid;
        END;
        END LOOP;
        END;
      $$ LANGUAGE 'plpgsql';",sep="")
  conn <- poolCheckout(pool)
  message <- NULL
  nr <- tryCatch({
    dbExecute(conn, query)
  }, error = function(e) {
    message <<- e
  }, finally = {
    poolReturn(conn)
    sqldf::sqldf("drop table if exists updated_temp ")
  })
  
  
  if (is.null(message))   
    message <- paste(nrow(updated_values_table),"values updated in the db")
  
  return(list(message = message, cou_code = cou_code))
}


#' @title write new series into the database
#' @description New lines will be inserted in the database
#' @param path path to file (collected from shiny button)
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  path<-wg_file.choose()
#port <- 5432
#host <- "localhost"#"192.168.0.100"
#userwgeel <-"wgeel"
#pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="wgeel",
#		host=host,
#		port=port,
#		user= userwgeel,
#		password= passwordwgeel) 
#'  #path<-"C:\\Users\\cedric.briand\\Downloads\\new_series_2020-08-22_FR.xlsx"
#'  write_new(path)
#' sqldf('delete from datawg.t_eelstock_eel where eel_qal_comment='dummy_for_test'')
#'  }
#' }
#' @rdname write_new series
write_new_series <- function(path) {
	
	new <- read_excel(path = path, sheet = 1, skip = 1)
	
	####when there are no data, new values have incorrect type
	new <- new %>% mutate_if(is.logical,list(as.character)) 
	# check for new file -----------------------------------------------------------------------------
	
	validate(need(all(!is.na(new$ser_qal_id)), "There are still lines without ser_qal_id, please check your file"))
	cou_code = unique(new$ser_cou_code)  
	validate(need(length(cou_code) == 1, "There is more than one country code, please check your file"))
	
	# create dataset for insertion -------------------------------------------------------------------
	
	
	new <- new[, c("ser_nameshort", "ser_namelong", "ser_typ_id", "ser_effort_uni_code", 
					"ser_comment", "ser_uni_code", "ser_lfs_code", "ser_hty_code", "ser_locationdescription",
					"ser_emu_nameshort", "ser_cou_code", "ser_area_division", "ser_tblcodeid",
					"ser_x", "ser_y", "ser_sam_id", "ser_dts_datasource", "ser_qal_id", "ser_qal_comment",
					"ser_order", "ser_ccm_wso_id" )	]
	sqldf::sqldf("drop table if exists new_series_temp ")
	sqldf::sqldf("create table new_series_temp as select * from new")
	
	# Query uses temp table just created in the database by sqldf
	query <- "insert into datawg.t_series_ser (         
			ser_nameshort,
			ser_namelong, ser_typ_id, ser_effort_uni_code, 
			ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription,
			ser_emu_nameshort, ser_cou_code, ser_area_division, ser_tblcodeid,
			ser_x, ser_y, ser_sam_id, ser_dts_datasource, ser_qal_id, ser_qal_comment,
			ser_order, ser_ccm_wso_id ) 
			select ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, 
			ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription,
			ser_emu_nameshort, ser_cou_code, ser_area_division, ser_tblcodeid::integer,
			ser_x, ser_y, ser_sam_id, ser_dts_datasource, ser_qal_id::integer, ser_qal_comment,
			ser_order::integer, ser_ccm_wso_id::integer[] from new_series_temp"
	# if fails replaces the message with this trycatch !  I've tried many ways with
	# sqldf but trycatch failed to catch the error Hence the use of DBI
	conn <- poolCheckout(pool)
	message <- NULL
	(nr <- tryCatch({
							dbExecute(conn, query)
						}, error = function(e) {
							message <<- e
						}, finally = {
							poolReturn(conn)
							sqldf::sqldf("drop table if exists new_series_temp")
						}))
	
	
	if (is.null(message))   
		message <- sprintf(" %s new values inserted in the database", nr)
	
	return(list(message = message, cou_code = cou_code))
}


#' @title write new dataseries into the database
#' @description New lines will be inserted in the database
#' @param path path to file (collected from shiny button)
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  path<-wg_file.choose()
#port <- 5432
#host <- "localhost"#"192.168.0.100"
#userwgeel <-"wgeel"
#pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="wgeel",
#		host=host,
#		port=port,
#		user= userwgeel,
#		password= passwordwgeel) 
#'  # path<-"C:\\Users\\cedric.briand\\Downloads\\new_dataseries_2020-08-23_FR.xlsx"
#'  write_new(path)
#' 
#'  }
#' }
#' @rdname write_new dataseries
write_new_dataseries <- function(path) {
	
	new <- read_excel(path = path, sheet = 1, skip = 1)
	new$das_qal_id <- as.integer(new$das_qal_id)
	
	####when there are no data, new values have incorrect type
	new <- new %>% mutate_if(is.logical,list(as.numeric)) 
		
	# create dataset for insertion -------------------------------------------------------------------
	
	
	new <- new[, c("das_year", "das_value", "das_comment",
					"das_effort", "das_dts_datasource", "das_ser_id", "das_qal_id")	]
	sqldf::sqldf("drop table if exists new_dataseries_temp ")
	sqldf::sqldf("create table new_dataseries_temp as select * from new")
	
	# Query uses temp table just created in the database by sqldf
	query <- "insert into datawg.t_dataseries_das (das_year, das_value, das_comment,
	das_effort, das_dts_datasource, das_ser_id, das_qal_id)
			select 
			das_year, das_value, das_comment,	das_effort, das_dts_datasource, das_ser_id, das_qal_id
			from new_dataseries_temp"
	# if fails replaces the message with this trycatch !  I've tried many ways with
	# sqldf but trycatch failed to catch the error Hence the use of DBI
	conn <- poolCheckout(pool)
	message <- NULL
	(nr <- tryCatch({
							dbExecute(conn, query)
						}, error = function(e) {
							message <<- e
						}, finally = {
							poolReturn(conn)
							sqldf::sqldf("drop table if exists new_dataseries_temp")
						}))
	
	
	if (is.null(message))   
		message <- sprintf(" %s new values inserted in the database", nr)
	
	return(list(message = message, cou_code = cou_code))
}


#' @title write new biometry into the database
#' @description New lines will be inserted in the database
#' @param path path to file (collected from shiny button)
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  path<-wg_file.choose()
#'port <- 5432
#'host <- "localhost"#"192.168.0.100"
#'userwgeel <-"wgeel"
#'pool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
#'		dbname="wgeel",
#'		host=host,
#'		port=port,
#'		user= userwgeel,
#'		password= passwordwgeel) 
#'  # path<-"C:\\Users\\cedric.briand\\Downloads\\new_biometry_2020-08-24_FR.xlsx"
#'  write_new(path)
#' 
#'  }
#' }
#' @rdname write_new biometry
write_new_biometry <- function(path) {
	
	new <- read_excel(path = path, sheet = 1, skip = 1)

	
	####when there are no data, new values have incorrect type
	new <- new %>% mutate_if(is.logical,list(as.numeric)) 
	new <- new %>% mutate_at(vars(bio_last_update, bio_comment, bio_dts_datasource), list(as.character)) 
	# create dataset for insertion -------------------------------------------------------------------
	
	
	new <- new[, c(c( "bio_year", "bio_length", "bio_weight", "bio_age", 
							"bio_sex_ratio", "bio_length_f", "bio_weight_f", "bio_age_f", "bio_length_m", 
							"bio_weight_m", "bio_age_m", "bio_comment", "bio_last_update", "bis_g_in_gy", 
							"bio_dts_datasource", "bis_ser_id" )
	)	]
	sqldf::sqldf("drop table if exists new_biometry_temp ")
	sqldf::sqldf("create table new_biometry_temp as select * from new")
	
	# Query uses temp table just created in the database by sqldf
	query <- "insert into datawg.t_biometry_series_bis (
 bio_year, bio_lfs_code, bio_length, bio_weight, bio_age, bio_sex_ratio,
 bio_length_f, bio_weight_f, bio_age_f, bio_length_m, bio_weight_m, bio_age_m,
 bio_comment, bio_last_update, bis_g_in_gy, bio_dts_datasource, bis_ser_id
)
			select 
			 bio_year, ser_lfs_code as bio_lsf_code, bio_length, bio_weight, bio_age, bio_sex_ratio,
 bio_length_f, bio_weight_f, bio_age_f, bio_length_m, bio_weight_m, bio_age_m,
 bio_comment, bio_last_update::date, bis_g_in_gy, bio_dts_datasource, bis_ser_id
			from  new_biometry_temp
      JOIN datawg.t_series_ser on ser_id=bis_ser_id"
	# if fails replaces the message with this trycatch !  I've tried many ways with
	# sqldf but trycatch failed to catch the error Hence the use of DBI
	conn <- poolCheckout(pool)
	message <- NULL
	(nr <- tryCatch({
							dbExecute(conn, query)
						}, error = function(e) {
							message <<- e
						}, finally = {
							poolReturn(conn)
							sqldf::sqldf("drop table if exists new_biometry_temp")
						}))
	
	
	if (is.null(message))   
		message <- sprintf(" %s new values inserted in the database", nr)
	
	return(list(message = message, cou_code = cou_code))
}



#' @title update value into the database
#' @description Performs update queries
#' @param path path to file (collected from shiny button)
#' @return message indicating success or failure at data insertion
#' @details This function uses sqldf to create temporary table then dbExecute as
#' this version allows to catch exceptions and sqldf does not

update_series <- function(path) {
	cou_code = unique(updated_values_table$eel_cou_code.xls)  
	validate(need(length(cou_code) == 1, "There is more than one country code, please check your file"))
	
	# create dataset for insertion -------------------------------------------------------------------
	
	
	names(updated_values_table) = gsub(".","_",names(updated_values_table),fixed=TRUE)
	sqldf::sqldf("drop table if exists updated_temp ")
	sqldf::sqldf("create table updated_temp as select * from updated_values_table")
	cyear=format(Sys.Date(), "%Y")
	query=paste("
					DO $$
					DECLARE
					rec RECORD;
					oldid integer;
					newid integer;
					BEGIN
					FOR rec in SELECT * from updated_temp
					LOOP
					BEGIN
					oldid:=rec.eel_id;
					update datawg.t_eelstock_eel set eel_qal_id=",qualify_code," where eel_id=oldid;
					insert into datawg.t_eelstock_eel (eel_typ_id,eel_year,eel_value,eel_missvaluequal,eel_emu_nameshort,eel_cou_code,eel_lfs_code,eel_hty_code,eel_area_division,eel_qal_id, eel_qal_comment,eel_datasource,eel_comment)
					(select eel_typ_id,eel_year_xls,eel_value_xls,eel_missvaluequal_xls,eel_emu_nameshort_xls,eel_cou_code_xls,eel_lfs_code_xls,eel_hty_code_xls,eel_area_division_xls,eel_qal_id_xls,eel_qal_comment_xls,eel_datasource_xls,eel_comment_xls from updated_temp where eel_id=oldid ) returning eel_id into newid;
					update datawg.t_eelstock_eel set eel_qal_comment=coalesce(eel_qal_comment,'') || ' updated to eel_id ' || newid::text || ' in ",cyear,"' where eel_id=oldid;
					END;
					END LOOP;
					END;
					$$ LANGUAGE 'plpgsql';",sep="")
	conn <- poolCheckout(pool)
	message <- NULL
	nr <- tryCatch({
				dbExecute(conn, query)
			}, error = function(e) {
				message <<- e
			}, finally = {
				poolReturn(conn)
			})
	
	
	if (is.null(message))   
		message <- paste(nrow(updated_values_table),"values updated in the db")
	
	return(list(message = message, cou_code = cou_code))
}


update_dataseries <- function(path) {}


update_biometry <- function(path) {}


#' @title Update t_eelstock_eel table in the database
#' @description Function to safely modify data into the database from DT edits
#' @param editedValue A dataframe wich collates all rows changed in the datatable, using the 
#' observeEvent(input$table_cor_cell_edit, ... on the server.R side
#' @param pool A database pool
#' @return Nothing
#' @details Modified from https://github.com/MangoTheCat/dtdbshiny, when compared with this example the original dbListFields from RPostgres
#' doesn't seem to work with shema.table. So I changed the function to pass colnames once only
#' @examples 
#' editedValue <-tibble(row=1,col=4,value=456)
#' editedValue <-tibble(row=1,col=5,value='ERROR')
#' pool <- pool::dbPool(drv = dbDriver('PostgreSQL'),
#'    dbname='wgeel',
#'    host='localhost',
#'    user= userlocal,
#'    password=passwordlocal)
#' update_t_eelstock_eel(editedValue, pool)
#' data <- sqldf('SELECT * from datawg.t_eelstock_eel where eel_cou_code='VA'')
#' @seealso 
#'  \code{\link[dplyr]{last}}
#'  \code{\link[glue]{glue_sql}}
#' @rdname updateDB
#' @importFrom dplyr last
#' @importFrom glue glue_sql
update_t_eelstock_eel <- function(editedValue, pool, data) {
	# Keep only the last modification for a cell edited Value is a data frame with
	# columns row, col, value this part ensures that only the last value changed in a
	# cell is replaced.  Previous edits are ignored
	editedValue <- editedValue %>% group_by(row, col) %>% filter(value == dplyr::last(value) | 
					is.na(value)) %>% ungroup()
	# opens the connection, this must be followed by poolReturn
	conn <- poolCheckout(pool)
	# Apply to all rows of editedValue dataframe
	t_eelstock_eel_ids <- data$eel_id
	error = list()
	lapply(seq_len(nrow(editedValue)), function(i) {
				row = editedValue$row[i]
				id = t_eelstock_eel_ids[row]
				col = t_eelstock_eel_fields[editedValue$col[i]]
				value = editedValue$value[i]
				# glue sql will use arguments tbl, col, value and id
				query <- glue::glue_sql("UPDATE datawg.t_eelstock_eel SET
								{`col`} = {value}
								WHERE eel_id = {id}
								", 
						.con = conn)
				tryCatch({
							dbExecute(conn, sqlInterpolate(ANSI(), query))
						}, error = function(e) {
							error[i] <<- e
						})
			})
	poolReturn(conn)
	# print(editedValue)
	return(error)
}


#' @title Function to create log of user action during data integration
#' @description connects to the database and automatically stores the user's actions
#' @param step one of 'check data', 'check duplicates', 'new data integration'
#' @param cou_code the code of the country
#' @param message : message sent to the console
#' @param the_metadata : metadata stored in the excel file
#' @param file_type : the type of data processed in the data call
#' @param main_assessor : the main person responsible for data processing, usually national correspondent
#' @param secondary_assessor : the person who helps from the data subgroup
#' @return nothing
log_datacall <- function(step, cou_code, message, the_metadata, file_type, main_assessor, 
		secondary_assessor) {
	if (is.null(the_metadata)) {
		the_metadata[["contact"]] <- NA
		the_metadata[["method"]] <- NA
	}
	query <- glue_sql("INSERT INTO datawg.log(log_cou_code,log_data,log_evaluation_name,log_main_assessor,log_secondary_assessor,log_contact_person_name, log_method, log_message, log_date) VALUES
					({cou_code},{data},{evaluation},{main},{secondary},{log_contact_person_name},{log_method},{log_message},{date})", 
			cou_code = cou_code, 
			data = file_type, 
			evaluation = step, main = main_assessor, 
			secondary = secondary_assessor, 
			log_contact_person_name = the_metadata[["contact"]], 
			log_method = the_metadata[["method"]], 
			log_message = message,
			date = Sys.Date(), 
			.con = pool)
	
	out_data <- dbGetQuery(pool, query)
	return(out_data)
}



#' @title Function to display missing data
#' @description one new landings data are provided, check which data would be missing
#' @param complete the records of the country after including the new data
#' @param newdata the newdata
#' @param restricted if TRUE, function resticted to the period covered by the new data
#' @return a DT::datatable

check_missing_data <- function(complete, newdata, restricted=TRUE) {
	load_library("data.table")
	all_comb <- expand.grid(eel_lfs_code=c("G","Y","S"),
			eel_hty_code=c("F","T","C"),
			eel_emu_nameshort=unique(complete$eel_emu_nameshort),
			eel_cou_code=unique(complete$eel_cou_code),
			eel_year=unique(complete$eel_year),
			eel_typ_id=c(4,6))
	missing_comb <- anti_join(all_comb, complete)
	missing_comb$id <- 1:nrow(missing_comb)
	found_matches <- sqldf("select id from missing_comb m inner join complete c on c.eel_cou_code=m.eel_cou_code and
					c.eel_year=m.eel_year and
					c.eel_typ_id=m.eel_typ_id and
					c.eel_lfs_code like '%'||m.eel_lfs_code||'%'
					and c.eel_hty_code like '%'||m.eel_hty_code||'%' 
					and (c.eel_emu_nameshort=m.eel_emu_nameshort or
					c.eel_emu_nameshort=substr(m.eel_emu_nameshort,1,3)||'total')")
	#looks for missing combinations
	missing_comb <- missing_comb %>%
			filter(!missing_comb$id %in% found_matches$id)%>%
			select(-id) %>%
			arrange(eel_cou_code,eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code,eel_year)
	if (restricted){
		missing_comb <-missing_comb %>%
				filter(eel_year>=min(newdata$eel_year) & eel_year<=max(newdata$eel_year))
	}
	
	missing_comb$eel_hty_code=as.character(missing_comb$eel_hty_code)
	missing_comb$eel_lfs_code=as.character(missing_comb$eel_lfs_code)
	missing_comb$eel_emu_nameshort =as.character(missing_comb$eel_emu_nameshort)
	missing_comb$eel_cou_code =as.character(missing_comb$eel_cou_code)
	
	#creates a nested data table to facilitate display in shiny
	missing_comb_dt = data.table(missing_comb)
	setkey(missing_comb_dt, eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code)
	
	hty_dt = data.table(missing_comb %>%
					group_by(eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code) %>%
					summarise(nb=n()))
	setkey(hty_dt, eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code)
	
	lfs_dt = data.table(missing_comb %>% 
					group_by(eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code) %>%
					summarize(nb=n()))
	setkey(lfs_dt, eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code)
	
	emu_dt = data.table(missing_comb %>%
					group_by(eel_cou_code, eel_typ_id,eel_emu_nameshort) %>%
					summarize(nb=n()))
	setkey(emu_dt, eel_cou_code, eel_typ_id,eel_emu_nameshort)
	
	
	main_dt = data.table(missing_comb %>%
					group_by(eel_cou_code, eel_typ_id)%>%
					summarize(nb=n()))
	setkey(main_dt, eel_cou_code, eel_typ_id)
	
	
	#  missing_comb_dt = 
	#    missing_comb_dt[, list("_details" = list(purrr::transpose(.SD))), by = list(eel_cou_code, eel_typ_id,eel_emu_nameshort,eel_lfs_code,eel_hty_code)]
	#  missing_comb_dt[, ' ' := '&oplus;']
	
	
	
	
	
	hty_dt = merge(hty_dt, missing_comb_dt, all.x = TRUE,by=c("eel_cou_code","eel_typ_id","eel_emu_nameshort","eel_lfs_code","eel_hty_code") )
	setkey(hty_dt, eel_cou_code, eel_typ_id, eel_emu_nameshort, eel_lfs_code)
	setcolorder(hty_dt, c(length(hty_dt), c(1:(length(hty_dt) - 1))))
	
	hty_dt = hty_dt[,list("_details" = list(purrr::transpose(.SD))), by = list(eel_cou_code, eel_typ_id, eel_emu_nameshort, eel_lfs_code,eel_hty_code,nb)]
	hty_dt[, ' ' := '&oplus;']
	
	
	
	lfs_dt = merge(lfs_dt, hty_dt, all.x = TRUE,by=c("eel_cou_code","eel_typ_id","eel_emu_nameshort","eel_lfs_code"),suffixes=c(".x","") )
	setkey(lfs_dt, eel_cou_code, eel_typ_id, eel_emu_nameshort)
	setcolorder(lfs_dt, c(length(lfs_dt), c(1:(length(lfs_dt) - 1))))
	
	lfs_dt = lfs_dt[,list("_details" = list(purrr::transpose(.SD))), by = list(eel_cou_code, eel_typ_id, eel_emu_nameshort,eel_lfs_code,nb.x)]
	names(lfs_dt)[names(lfs_dt)=="nb.x"]="nb"
	lfs_dt[, ' ' := '&oplus;']
	
	
	emu_dt = merge(emu_dt, lfs_dt, all.x = TRUE,by=c("eel_cou_code","eel_typ_id","eel_emu_nameshort"),suffixes=c(".x","") )
	setkey(emu_dt, eel_cou_code, eel_typ_id)
	setcolorder(emu_dt, c(length(emu_dt), c(1:(length(emu_dt) - 1))))
	
	emu_dt = emu_dt[,list("_details" = list(purrr::transpose(.SD))), by = list(eel_cou_code, eel_typ_id,eel_emu_nameshort,nb.x)]
	names(emu_dt)[names(emu_dt)=="nb.x"]="nb"
	emu_dt[, ' ' := '&oplus;']
	
	main_dt = merge(main_dt, emu_dt, all.x = TRUE,allow.cartesian=TRUE, by=c("eel_cou_code","eel_typ_id"),suffixes=c(".x","") )
	setcolorder(main_dt, c(length(main_dt),c(1:(length(main_dt) - 1))))
	
	main_dt = main_dt[,list("_details" = list(purrr::transpose(.SD))), by = list(eel_cou_code, eel_typ_id,nb.x)]
	names(main_dt)[names(main_dt)=="nb.x"]="nb"
	main_dt=cbind(' '='&oplus;',main_dt)
	
	
	
	
	## the callback https://stackoverflow.com/questions/51425442/parent-child-rows-in-r-shiny-package
	callback = JS(
			"table.column(1).nodes().to$().css({cursor: 'pointer'});",
			"",
			"// make the table header of the nested table",
			"var format = function(d, childId){",
			"  if(d != null){",
			"    var html = ", 
			"      '<table class=\"display compact hover\" id=\"' + childId + '\"><thead><tr>';",
			"    for (var key in d[d.length-1][0]) {",
			"      html += '<th>' + key + '</th>';",
			"    }",
			"    html += '</tr></thead></table>'",
			"    return html;",
			"  } else {",
			"    return '';",
			"  }",
			"};",
			"",
			"// row callback to style the rows of the child tables",
			"var rowCallback = function(row, dat, displayNum, index){",
			"  if($(row).hasClass('odd')){",
			"    $(row).css('background-color', 'papayawhip');",
			"    $(row).hover(function(){",
			"      $(this).css('background-color', '#E6FF99');",
			"    }, function() {",
			"      $(this).css('background-color', 'papayawhip');",
			"    });",
			"  } else {",
			"    $(row).css('background-color', 'lemonchiffon');",
			"    $(row).hover(function(){",
			"      $(this).css('background-color', '#DDFF75');",
			"    }, function() {",
			"      $(this).css('background-color', 'lemonchiffon');",
			"    });",
			"  }",
			"};",
			"",
			"// header callback to style the header of the child tables",
			"var headerCallback = function(thead, data, start, end, display){",
			"  $('th', thead).css({",
			"    'border-top': '3px solid indigo',", 
			"    'color': 'indigo',",
			"    'background-color': '#fadadd'",
			"  });",
			"};",
			"",
			"// make the datatable",
			"var format_datatable = function(d, childId){",
			"  var dataset = [];",
			"  var n = d.length - 1;",
			"  for(var i = 0; i < d[n].length; i++){",
			"    var datarow = $.map(d[n][i], function (value, index) {",
			"      return [value];",
			"    });",
			"    dataset.push(datarow);",
			"  }",
			"  var id = 'table#' + childId;",
			"  if (Object.keys(d[n][0]).indexOf('_details') === -1) {",
			"    var subtable = $(id).DataTable({",
			"                 'data': dataset,",
			"                 'autoWidth': true,",
			"                 'deferRender': true,",
			"                 'info': false,",
			"                 'lengthChange': false,",
			"                 'ordering': d[n].length > 1,",
			"                 'order': [],",
			"                 'paging': false,",
			"                 'scrollX': false,",
			"                 'scrollY': false,",
			"                 'searching': false,",
			"                 'sortClasses': false,",
			"                 'rowCallback': rowCallback,",
			"                 'headerCallback': headerCallback,",
			"                 'columnDefs': [{targets: '_all', className: 'dt-center'}]",
			"               });",
			"  } else {",
			"    var subtable = $(id).DataTable({",
			"            'data': dataset,",
			"            'autoWidth': true,",
			"            'deferRender': true,",
			"            'info': false,",
			"            'lengthChange': false,",
			"            'ordering': d[n].length > 1,",
			"            'order': [],",
			"            'paging': false,",
			"            'scrollX': false,",
			"            'scrollY': false,",
			"            'searching': false,",
			"            'sortClasses': false,",
			"            'rowCallback': rowCallback,",
			"            'headerCallback': headerCallback,",
			"            'columnDefs': [", 
			"              {targets: -1, visible: false},", 
			"              {targets: 0, orderable: false, className: 'details-control'},", 
			"              {targets: '_all', className: 'dt-center'}",
			"             ]",
			"          }).column(0).nodes().to$().css({cursor: 'pointer'});",
			"  }",
			"};",
			"",
			"// display the child table on click",
			"table.on('click', 'td.details-control', function(){",
			"  var tbl = $(this).closest('table'),",
			"      tblId = tbl.attr('id'),",
			"      td = $(this),",
			"      row = $(tbl).DataTable().row(td.closest('tr')),",
			"      rowIdx = row.index();",
			"  if(row.child.isShown()){",
			"    row.child.hide();",
			"    td.html('&oplus;');",
			"  } else {",
			"    var childId = tblId + '-child-' + rowIdx;",
			"    row.child(format(row.data(), childId)).show();",
			"    td.html('&CircleMinus;');",
			"    format_datatable(row.data(), childId);",
			"  }",
			"});")
	
	datatable(main_dt, callback = callback, escape = -2,
			options = list(
					columnDefs = list(
							list(visible = FALSE, targets = ncol(main_dt)),
							list(orderable = FALSE, className = 'details-control', targets = 1),
							list(className = "dt-center", targets = "_all")
					)
			))
	
	
}
