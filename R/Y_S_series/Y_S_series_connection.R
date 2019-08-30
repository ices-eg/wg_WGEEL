# connection to database for convenience
# TODO: switch to normal connection procedure
###############################################################################

load_library("pool")
load_library("DBI")
load_library("RPostgreSQL")

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
	
#	#configuration of database connection
#	options(sqldf.RPostgreSQL.user = "lolo", 
#		sqldf.RPostgreSQL.password = passwordwgeel,
#		sqldf.RPostgreSQL.dbname = "wgeel_ices",
#		sqldf.RPostgreSQL.host = "localhost",
#		sqldf.RPostgreSQL.port = 5432)
	
#	dbpool = pool::dbPool(drv = dbDriver("PostgreSQL"),
#		dbname="wgeel_ices",
#		host="localhost",
#		port=5432,
#		user= "lolo",
#		password= passwordwgeel)
	
}

## configuration for connection to WGEEL database
userwgeel = getpassword()
dbpool <<- pool::dbPool(drv = dbDriver("PostgreSQL"),
	dbname="wgeel",
	host="localhost",
	port=5435,
	user= userwgeel,
	password= passwordwgeel)

message = NULL

wgeel_query = function(query0, ...)
{
	conn <- poolCheckout(dbpool)
	nr0 <- tryCatch({     
			result = dbGetQuery(conn, query0)
		}, error = function(e) {
			message <<- e  
			cat("step1 message :")
			print(message)   
		}, finally = {
			poolReturn(conn)
		})
	return(result)
}

wgeel_execute = function(query0, extra_data = NULL, country = country, environment)
{
	conn <- poolCheckout(dbpool)
	
	nr0 <- tryCatch({
			if(!is.null(extra_data))
				for(i in 1:length(extra_data))
				{
					if(dbExistsTable(conn, str_c('temp_', country, '_', extra_data[i])))
						dbRemoveTable(conn, str_c('temp_', country, '_', extra_data[i]))
					dbWriteTable(conn, str_c('temp_', country, '_', extra_data[i]), get(extra_data[i], envir = environment), temporary = TRUE, row.names = FALSE)
				}
			dbExecute(conn, query0)
		}, error = function(e) {
			message <<- e  
			cat("step1 message :")
			print(message)   
		}, finally = {
			poolReturn(conn)
		})
}
