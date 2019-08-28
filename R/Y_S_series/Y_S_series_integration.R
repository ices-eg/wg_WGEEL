# Y_S_series_integration.R
# provisional script to integrated 2019 data call yellow and silver eel series
# TODO: to integrate this in the shiny app
###############################################################################

source("R/utilities/load_library.R")

# here is a list of the required packages
load_library("readxl") # to read xls files
load_library("stringr") # this contains utilities for strings
load_library("sqldf") # to run queries
load_library("RPostgreSQL") # to run queries to the postgres database
load_library("dplyr") # to manipulate data

#--------------------------------
# get your current name 
#--------------------------------
getUsername <- function(){
	name <- Sys.info()[["user"]]
	return(name)
}

#--------------------------------
# personalise directories .... 
#--------------------------------

if(getUsername() == 'lbeaulaton')
{
	getpassword<-function(){  
		require(tcltk);  
		wnd<-tktoplevel();tclVar("")->passVar;  
		#Label  
		tkgrid(tklabel(wnd,text="Enter password:"));  
		#Password box  
		tkgrid(tkentry(wnd,textvariable=passVar,show="*")->passBox);  
		#Hitting return will also submit password  
		tkbind(passBox,"<Return>",function() tkdestroy(wnd));  
		#OK button  
		tkgrid(tkbutton(wnd,text="OK",command=function() tkdestroy(wnd)));  
		#Wait for user to click OK  
		tkwait.window(wnd);  
		password<-tclvalue(passVar);  
		return(password);  
	}  
	if (!exists("password"))  { 
		passwordwgeel<-getpassword()
	}
	
	userwgeel = "wgeel"
	
	# path to the folder where all files where stored
	wd_file_folder = "/home/lbeaulaton/Documents/Documents sur Donnees/ANGUILLE/ICES/WGEEL/WGEEL 2019 Bergen/data call/all_countries/03 Data Submission 2019"
	
	#configuration of database connection
	options(sqldf.RPostgreSQL.user = "lolo", 
		sqldf.RPostgreSQL.password = passwordwgeel,
		sqldf.RPostgreSQL.dbname = "wgeel_ices",
		sqldf.RPostgreSQL.host = "localhost",
		sqldf.RPostgreSQL.port = 5432)

}

## configuration for connection to WGEEL database
#options(sqldf.RPostgreSQL.user = userwgeel, 
#	sqldf.RPostgreSQL.password = passwordwgeel,
#	sqldf.RPostgreSQL.dbname = "wgeel",
#	sqldf.RPostgreSQL.host = "localhost",
#	sqldf.RPostgreSQL.port = 5435)

#--------------------------------
# function for integration
#--------------------------------
#' extract data from the excel file
#' 
#' @param country the name of the country folder
#' @param type_series name of the life stage you want to examine. Should be one of: "Yellow_Eel", "Silver_Eel"
#'
#' @return a list containing tibbles for data (meta, series_info, data and biom)
retrieve_data = function(country, type_series = "wrong")
{
	# check the type_series
	if(!(type_series %in% c("Yellow_Eel", "Silver_Eel")))
		stop("Chose right series' type")
	
	# check for existing files
	country_file = list.files(str_c(wd_file_folder, "/", country), type_series)
	if(length(country_file) == 0)
	{
		warning("No Yellow eel file")
		return(NULL)
	}
	
	country_data = list()
	# read the file
	country_data$meta = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="metadata", range = "B6:Y9") # TODO: I put a rather large range, adjust it?
	country_data$series_info = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="series_info")
	country_data$data = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="data")
	country_data$biom = read_excel(str_c(wd_file_folder, "/", country, "/", country_file), sheet="biometry")
	
	
	return(country_data)
}

#' check if the series have already been created
#' 
#' @param series_info the tibble from the excel file
#' @paral ser_db list of series in the database
#'
#' @return a list with existing series (incl. the database ser_id) and series to be created
check_series = function(series_info, ser_db)
{
	# serie type ?
	ser_typ = series_info %>% select(ser_typ_id) %>% distinct() %>% pull()
	# check for unique type
	if(length(ser_typ) > 1)
		stop("You have different type of series in your file")
	
	# add row number to series_info
	series_info = series_info %>% mutate(nrow = row_number())
	
	#chek for already existing series
	existing_series = inner_join(series_info %>% select(nrow, ser_typ_id, ser_lfs_code, ser_nameshort), ser_db %>% select(ser_id, ser_typ_id, ser_lfs_code, ser_nameshort))
	to_be_created_series = anti_join(series_info %>% select(nrow, ser_typ_id, ser_lfs_code, ser_nameshort), ser_db %>% select(ser_id, ser_typ_id, ser_lfs_code, ser_nameshort))
	
	print(str_c("existing series: ", nrow(existing_series)))
	print(str_c("series to be created: ", nrow(to_be_created_series)))
	
	return(list(existing_series = existing_series, to_be_created_series = to_be_created_series))
}

#' create new series
#' 
#' @param series_info the tibble from the excel file
#'
#' @return the ser_id of the new series
create_series = function(series_info)
{
	# insert data in the database 
	sqldf('INSERT INTO datawg.t_series_ser (ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y, ser_order) SELECT *, 999 FROM series_info;')
	
	# retrieve le ser_id for further use
	return(sqldf("SELECT ser_id FROM datawg.t_series_ser JOIN series_info USING(ser_nameshort)"))
}

#' check data series
#' 
#' @param series_info the tibble from the excel file
#'
#' @return the ser_id of the new series
check_dataseries = function(series_info)
{
	# insert data in the database 
	sqldf('INSERT INTO datawg.t_series_ser (ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_area_division, ser_x, ser_y, ser_order) SELECT *, 999 FROM series_info;')
	
	# retrieve le ser_id for further use
	return(sqldf("SELECT ser_id FROM datawg.t_series_ser JOIN series_info USING(ser_nameshort)"))
}


#--------------------------------
# Start integration
#--------------------------------
# series info in the database
ser_db <- sqldf("SELECT * FROM datawg.t_series_ser")

# read the folder to have all names
countries = list.dirs(wd_file_folder, full.names = FALSE, recursive = FALSE)

country_data = retrieve_data(country = "FRA", type_series = "Yellow_Eel")

chk_series = check_series(country_data$series_info, ser_db)

new_ser_id = create_series(country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid))
#series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% select(- ser_tblcodeid)

country_data$series_info = country_data$series_info %>% semi_join(chk_series$to_be_created_series) %>% mutate(ser_id = new_ser_id)
