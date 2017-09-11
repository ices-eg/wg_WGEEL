# Recruitment_analysis (how to)
The recruitment analysis *recruitment_analysis.Rnw* is a standalone sweave script
It can be run with sweave for instance in Rstudio and provides a pdf as output

The *asking_data_update.R* script is run to send the data arround to users

The *script_manual_insertion.R* script is used to load large new dataset on recruitment

----------
# Instructions

To run the recruitment script.
Use either [RStudio]{http://rstudio-pubs-static.s3.amazonaws.com/639_b3a59601ba94400aabbe29025de83c10.html} or [eclipse]{https://www.r-bloggers.com/getting-started-with-sweave-r-latex-eclipse-statet-texlipse/} to run a sweave script. 
You can run only the chunks (Parts with R code) if you just want the results and no latex report produced.

# folder structure

It is necessary to create a folder, your code is currently stored in
* FOLDER>WGEELgit>R>recruitment>recruitment_analysis.Rnw

 This will be automatically set when pulling code from git.
 
 *WGEELgit* is the local name you have chosen for the git repository,
 
 *FOLDER* is the directory where you have stored the git code
 
 So you need to create a directory to store data and figures besides this 
 directory, like this
 
 * FOLDER>datawgeel>recruitement>2017>data
 * FOLDER>datawgeel>recruitement>2017>image
 * FOLDER>datawgeel>recruitement>2017>table
 
 then adapt from line 127
 
```r
if(getUsername() == 'cedric.briand')
{
	# I have two password in the R.site of c:/program files/R... so I don't need no prompt
	password<-passworddistant
	baseODBC=c("wgeel","postgres",passwordlocal) #"w3.eptb-vilaine.fr" "localhost" "wgeel" "wgeel_distant" 
	options(sqldf.RPostgreSQL.user = "postgres", 
			sqldf.RPostgreSQL.password = passwordlocal,
			sqldf.RPostgreSQL.dbname = "wgeel",
			sqldf.RPostgreSQL.host = "localhost", # "localhost"
			sqldf.RPostgreSQL.port = 5432)
	setwd("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R/recruitment")
	
	wd<-getwd()
	wddata<-gsub("C:/Users/cedric.briand/Documents/GitHub/WGEEL/R","C:/workspace/wgeeldata",wd)
	datawd<-str_c(wddata,"/",CY,"/data")
	imgwd<-str_c(wddata,"/",CY,"/image")
	tabwd<-str_c(wddata,"/",CY,"/table")
	shpwd=str_c("C:/workspace/wgeeldata/shp") 
}
```

## with the database

The database must be running with postgres. Configure an ODBC link named wgeel. Ask Cédric for a dump of the database in its current state.


## without access to the database

Without access to the database, intermediary results produced by the *load_database* chunk are saved in 2017 *Meeting Docs/data/saved data*, load them to your data working directory. Don't evaluate the load_database chunk by putting eval=FALSE in the chunk options

```
<<load_database, echo=FALSE, fig=FALSE, eval=FALSE,results=hide>>= 
```
