
##Annex 15 management measures

#

#Aim: to pull out relevant data from Overview EMU sheet into a row/column of data per EMU

#ignore sheets 'readme' metadata [we can come back and get this info if needed]
#'tr_emu_em'.
#sheet given is 'Overview_EMUX1' if only one emu this will be filled out, if more emus this could be blank with multiple sheets available


#questions/headers are mostly in column A and respective row number


library(XLConnect)
library(stringr)
datawd <- "C:\\Users\\cedric.briand\\OneDrive - EPTB Vilaine\\Projets\\GRISAM\\2021\\WKEPEMP\\data_call\\Annex15\\"
datawd1 <- "C:\\workspace\\wg_WGEEL\\data\\"
load(str_c(datawd1,"ref_and_eel_data.Rdata"))

#filename <- filenames[1]
read_annex15 <- function(filenames){
	wb = loadWorkbook(str_c(datawd,filenames[1]))
	cat(str_c(substring(filenames[1],nchar(filenames[1])-6,nchar(filenames[1])-5),"\n"))
	sheet <- getSheets(wb)
	sheet0 <- sheet[grep("INPUT_measures",sheet)]
	dat <- readWorksheet(wb, sheet0,header=TRUE)
	countries <- readWorksheet(wb, "tr_emu_country", header=TRUE)
	fulldat <- dat
	for (i in 2: length(filenames)){
		filename= filenames[i]
		cat(str_c(substring(filename,nchar(filename)-6,nchar(filename)-5),"\n"))
		wb  <- loadWorkbook(str_c(datawd,filename))
		sheet <- getSheets(wb)
		sheet <- sheet[grep("INPUT_measures",sheet)]
		dat <- readWorksheet(wb, sheet,header=TRUE)
		fulldat <- rbind(fulldat,dat)
	}
	return(fulldat)	
}

res <- read_annex15(filenames)

#####to build the table: put all the filenames below and then run the line starting with annexes13_table

filenames <- list.files(datawd)
filenames <- filenames[grep("xlsx", filenames)] # only extract xlsx

