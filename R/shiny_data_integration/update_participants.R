# TODO: Add comment
# 
# Author: cedricbriandgithub
###############################################################################


pool <- pool::dbPool(drv = dbDriver("PostgreSQL"),
		dbname="wgeel",
		host=host,
		port=port,
		user= userwgeel,
		password= passwordwgeel)
#dbExecute(pool,"INSERT INTO datawg.participants SELECT 'Clarisse Boulenger'")
#dbExecute(pool,"INSERT INTO datawg.participants SELECT 'Tessa Vanderhammen'")
dbExecute(pool,"INSERT INTO datawg.participants SELECT 'Kristof Vlietinck'")
query <- "SELECT name from datawg.participants order by name asc"
participants<<- dbGetQuery(pool, sqlInterpolate(ANSI(), query)) 
save(participants, file=str_c(getwd(),"/common/data/participants.Rdata"), version=2)
