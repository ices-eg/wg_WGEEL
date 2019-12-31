# WKEELMIGRATION NOTES


renamed all files to lowercase, and only three extensions like :
`GB_fishery_closure.xlsx`
# DATABASE
Updated all names for GY and G recruitment series [code](https://github.com/ices-eg/wg_WGEEL/commit/3fc2e32debc9ceefa524ad47836b1b5ab7e2107a)

Removed duplicate for skagerrak norway series 


# CLOSURES


# LANDINGS 


# SEASONALITY

script is [here](https://github.com/ices-eg/wg_WGEEL/blob/master/Misc/wkeelmigration/database_integration.R)

* BE Annual data reported => ignore, remove file
* Corrected Vilaine file misplaced column (hey this is me ;-))
* Loaded all files

 value data
---------------
* Corrected all month
* Replaced missing nameshort identifiers in France (using the name of the file)
* Removed one line from the database (duplicate ORIA) 
* corrected `FR_Rhin_Y` `FR_Sous_S` `FR_Scorff_S` `FR_GAR_G` to standardize names
* corrected GirG to Gisc
* fixed names in DE
* changed names in Irish series to match with database (Burr, Erne, Liff, Burr) 
 series info
---------------
* LTU file : Mismatch between ZEIT in the series and Zeit in data, renamed to Zeit

