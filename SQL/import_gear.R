# SCRIPT TO IMPORT GEAR
# Author: cedricbriandgithub
###############################################################################


#gear <- read_excel("C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2021/WKEELDATA/CL_FI_GEAR_GROUPS.xlsx",sheet="import")

gear <- structure(list(gea_id = c(111, 112, 201, 202, 203, 204, 206, 
						208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 
						221, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 
						235, 236, 237, 238, 239, 240, 242, 245, 246, 247, 248, 249, 252, 
						253, 254, 255, 305, 306, 307, 309, 310, 313, 315, 325, 326, 400, 
						440), gea_isscfg_code = c(1.9, 10.9, 1.2, 2.1, 2.2, 2.9, 3.19, 
						3.13, 3.14, 3.3, 3.9, 4.1, 4.2, 5.1, 5.2, 5.9, 6.1, 6.2, 7.1, 
						7.2, 7.3, 7.5, 7.9, 8.2, 8.3, 8.4, 8.5, 8.6, 8.9, 9.4, 9.31, 
						9.32, 9.39, 9.5, 9.9, 10.1, 10.3, 4.3, 4.9, 10.4, 99.9, 8.1, 
						7.4, 9.1, 1.1, 7.6, 10.5, 10.6, 5.3, 3.11, 3.12, 3.15, 3.21, 
						3.22, 9.2, 10.2, 10.7, 10.8, 3.29, 6.9), gea_nameen = c("Surrounding nets (nei)", 
						"Gear nei", "Surrounding nets without purse lines", "Beach seines", 
						"Boat seines", "Seine nets (nei)", "Bottom trawls (nei)", "Twin bottom otter trawls", 
						"Multiple bottom otter trawls", "Semipelagic trawls", "Trawls (nei)", 
						"Towed dredges", "Hand dredges", "Portable lift nets", "Boat-operated lift nets", 
						"Lift nets (nei)", "Cast nets", "Cover pots/Lantern nets", "Set gillnets (anchored)", 
						"Drift gillnets", "Encircling gillnets", "Trammel nets", "Gillnets and entangling nets (nei)", 
						"Pots", "Fyke nets", "Stow nets", "Barriers, fences, weirs, etc.", 
						"Aerial traps", "Traps (nei)", "Vertical lines", "Set longlines", 
						"Drifting longlines", "Longlines (nei)", "Trolling lines", "Hooks and lines (nei)", 
						"Harpoons", "Pumps", "Mechanized dredges", "Dredges (nei)", "Electric fishing", 
						"Gear not known", "Stationary uncovered pound nets", "Fixed gillnets (on stakes)", 
						"Handlines and hand-operated pole-and-lines", "Purse seines", 
						"Combined gillnets-trammel nets", "Pushnets", "Scoopnets", "Shore-operated stationary lift nets", 
						"Beam trawls", "Single boat bottom otter trawls", "Bottom pair trawls", 
						"Single boat midwater otter trawls", "Midwater pair trawls", 
						"Mechanized lines and pole-and-lines", "Hand Implements (Wrenching gear, Clamps, Tongs, Rakes, Spears)", 
						"Drive-in nets", "Diving", "Midwater trawls (nei)", "Falling gear (nei)"
				)), row.names = c(NA, -60L), class = c("tbl_df", "tbl", "data.frame"
		))



library("RPostgreSQL")
library("DBI")
#con=dbConnect(PostgreSQL(), 		
#		dbname="wgeel", 		
#		host="localhost",
#		port=5435, 		
#		user= userlocal, 		
#		password= passwordlocal)
con=dbConnect(PostgreSQL(), 		
		dbname="wgeel", 		
		host="localhost",
		port=5435, 		
		user= userwgeel, 		
		password= passwordwgeel)
DBI::dbExecute(con, "DROP TABLE IF EXISTS gear")
DBI::dbWriteTable(con, "gear",gear,row.names =FALSE)

dbGetQuery(con,"SELECT * FROM   gear")