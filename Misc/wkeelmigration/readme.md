# WKEELMIGRATION NOTES


renamed all files to lowercase, and only three extensions like :
`GB_fishery_closure.xlsx`
# DATABASE
Updated all names for GY and G recruitment series [code](https://github.com/ices-eg/wg_WGEEL/commit/3fc2e32debc9ceefa524ad47836b1b5ab7e2107a)

Removed duplicate for skagerrak norway series [code](https://github.com/ices-eg/wg_WGEEL/commit/4ec6c47a12d3f6680b58f6e52fc299527c86a252)


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
* replaced all existing series with data from database


|   |ser\_nameshort |  ser\_namelong                              |
|:--|:-------------|:-----------------------------------------|
|5  |BannGY        |Bann Coleraine trapping partial           |
|6  |BeeG          |Beeleigh_Glass_<80mm                      |
|9  |BroE          |Brownshill_Elvers_>80<120mm               |
|10 |BroG          |Brownshill_Glass_<80mm                    |
|14 |BurrG         |Burrishoole                               |
|15 |BurS          |Burrishoole                               |
|20 |EmsBGY        |Ems (Bollingerfaehr) Elver monitoring     |
|21 |EmsHG         |Ems (Herbrum) Glass eel monitoring        |
|22 |ErneGY        |Erne Ballyshannon trapping all            |
|25 |FlaE          |Flatford_Elvers_>80<120mm                 |
|26 |FlaG          |Flatford_GE_<80mm                         |
|28 |GarY          |Garonne electrofishing survey             |
|30 |GirnY         |Girnock Burn trap scientific estimate     |
|31 |GiScG         |Gironde scientific estimate               |
|32 |GreyGY        |Greylakes_Elvers (<120mm)                 |
|33 |GudeY         |Guden Å Tange trapping all               |
|43 |LiffGY        |Liffey                                    |
|58 |OriaG         |Oria scientific monitoring                |
|67 |ShaPY         |Shannon Parteen trapping partial          |
|69 |ShiFG         |Shieldaig river trap scientific estimate  |
|70 |ShiMG         |Shieldaig river mouth scientific estimate |
|72 |SouS          |Soustons downstream migration trap        |
|77 |StraGY        |Strangford                                |
|82 |VilS          |Vilaine Didson Silver eel survey          |



