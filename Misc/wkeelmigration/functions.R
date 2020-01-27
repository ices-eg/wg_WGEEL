############# seasonality #############################################
# path <- "\\\\community.ices.dk@SSL\\DavWWWRoot\\ExpertGroups\\wgeel\\2019 Meeting Documents\\06. Data\\03 Data Submission 2019\\EST\\Corrected_Eel_Data_Call_Annex4_LandingsEST.xlsx"
# path<-file.choose()
# datasource<-the_eel_datasource
load_seasonality <- function(path,datasource){
  the_metadata<-list()
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	country <- substring(mylocalfilename,1,2)
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
  metadata<-read_excel(path=path,"metadata" , range="B7:C9")
# check if no rows have been added
  if (names(metadata)[1]!="Contact person name") cat(
				str_c("The structure of metadata has been changed ",mylocalfilename," in ",country,"\n"))
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
# --------------------- data sheet ---------------------------------------------------
data<-read_excel(
			path=path,
			range=cell_cols("A:F"),
			col_types=c("text","numeric","numeric","text","text","numeric"),
			sheet =4,
			skip=0)	
	data$source <-  mylocalfilename
	data$country <- country
	data$datasource <- datasource
#data$das_value <- as.numeric(data$das_value)
#data$das_year <- as.numeric(data$das_year)
#data$das_month <- as.character(data$das_month)
#data$das_effort <- as.numeric(data$das_effort)
#---------------------- series_info_sheet ---------------------------------------------
  
# here we have already seached for catch and landings above.
  series_info<-read_excel(
      path=path,
			range=cell_cols("A:O"),
			col_types=c(rep("text",13),"numeric","numeric"),
      sheet =3,
      skip=0)


  return(list(data=data,series_info=series_info,the_metadata=the_metadata))
}




load_landings <- function(path,datasource){
	the_metadata<-list()
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	country <- substring(mylocalfilename,1,2)
#---------------------- METADATA sheet ---------------------------------------------
# read the metadata sheet
	metadata<-read_excel(path=path,"metadata" , range="B7:C9")
# check if no rows have been added
#	if (names(metadata)[1]!="Contact person name") cat(
#				str_c("The structure of metadata has been changed ",mylocalfilename," in ",country,"\n"))
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
# --------------------- data sheet ---------------------------------------------------
	data<-read_excel(
			path=path,
			range=cell_cols("A:K"),
			col_types=c("text","numeric","text","numeric",rep("text",7)),
			sheet ="landings",
			skip=0)	
	data$source <-  mylocalfilename
	data$country <- country
	data$datasource <- datasource
#data$das_value <- as.numeric(data$das_value)
#data$das_year <- as.numeric(data$das_year)
#data$das_month <- as.character(data$das_month)
#data$das_effort <- as.numeric(data$das_effort)
#---------------------- series_info_sheet ---------------------------------------------
	
# here we have already seached for catch and landings above.
	series_info<-read_excel(
			path=path,
			range=cell_cols("A:O"),
			col_types=c(rep("text",13),"numeric","numeric"),
			sheet =3,
			skip=0)
	
	
	return(list(data=data,series_info=series_info,the_metadata=the_metadata))
}




load_closures <- function(path,datasource){
	the_metadata<-list()
	file<-basename(path)
	mylocalfilename<-gsub(".xlsx","",file)
	country <- substring(mylocalfilename,1,2)
#---------------------- METADATA sheet ---------------------------------------------
# some of the files don't have metadata so I'm not processing it now
#	metadata<-read_excel(path=path,"metadata" , range="B7:C9")
# check if no rows have been added
#	if (names(metadata)[1]!="Contact person name") cat(
#				str_c("The structure of metadata has been changed ",mylocalfilename," in ",country,"\n"))
# store the content of metadata in a list
#	if (ncol(metadata)>1){   
#		the_metadata[["contact"]] <- as.character(metadata[1,2])
#		the_metadata[["contactemail"]] <- as.character(metadata[2,2])
#		the_metadata[["method"]] <- as.character(metadata[3,2])
#	} else {
#		the_metadata[["contact"]] <- NA
#		the_metadata[["contactemail"]] <- NA
#		the_metadata[["method"]] <- NA
#	}
# end loop for directories
# --------------------- data sheet ---------------------------------------------------
	data<-read_excel(
			path=path,
			range=cell_cols("A:L"),
			col_types=c("text","numeric","text","text","numeric",rep("text",7)),
			sheet ="closures",
			skip=0)	
	# correct name for first column
	colnames(data)[1] <- "eel_typ_name"
	data$source <-  mylocalfilename
	data$country <- country
	data$datasource <- datasource
#data$das_value <- as.numeric(data$das_value)
#data$das_year <- as.numeric(data$das_year)
#data$das_month <- as.character(data$das_month)
#data$das_effort <- as.numeric(data$das_effort)
#---------------------- series_info_sheet ---------------------------------------------
	

	
	
	return(list(data=data,the_metadata=the_metadata))
}

