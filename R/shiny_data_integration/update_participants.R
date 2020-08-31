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
save(participants,list_country,typ_id,the_years,t_eelstock_eel_fields, file=str_c(getwd(),"/common/data/init_data.Rdata"), version=2)
