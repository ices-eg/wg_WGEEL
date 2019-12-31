# WKEELMIGRATION NOTES


renamed all files to lowercase, and only three extensions like :
`GB_fishery_closure.xlsx`
# DATABASE
Updated all names for GY and G recruitment series [code](https://github.com/ices-eg/wg_WGEEL/commit/3fc2e32debc9ceefa524ad47836b1b5ab7e2107a)

Removed duplicate for skagerrak norway series [code](https://github.com/ices-eg/wg_WGEEL/commit/4ec6c47a12d3f6680b58f6e52fc299527c86a252)


# CLOSURES


# LANDINGS 


# SEASONALITY

## Data integration

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
* Updated names for NO Imsa  [code](https://github.com/ices-eg/wg_WGEEL/commit/2ae4fda65af81d206f8b3daab25807394e79174c)


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

## Summary of data

|nameshort |lfs.code |cou.code | first.year| last.year| nb_year|   N|
|:-------------|:------------|:------------|----------:|---------:|-------:|---:|
|ALA           |YS           |LT           |       2019|      2019|       0|   1|
|AllE          |Y            |GB           |       2012|      2019|       7|  49|
|AshE          |Y            |GB           |       2014|      2016|       2|  16|
|BadB          |S            |GB           |       2003|      2019|      16| 203|
|Bann          |GY           |GB           |       1933|      2019|      86|  87|
|BeeG          |G            |GB           |       2006|      2019|      13|  56|
|BowE          |Y            |GB           |       2012|      2016|       4|  30|
|Bro           |GY           |GB           |       2008|      2010|       2|  24|
|BroE          |GY           |GB           |       2011|      2019|       8|  72|
|BroG          |GY           |GB           |       2011|      2019|       8|  72|
|BroS          |Y            |GB           |       2011|      2019|       8|  72|
|BurFe         |Y            |IE           |       1987|      1988|       1|  10|
|BurFu         |Y            |IE           |       1987|      1988|       1|  16|
|Burr          |G            |IE           |       2014|      2019|       5|  34|
|BurS          |S            |IE           |       1970|      2019|      49| 592|
|CraE          |Y            |GB           |       2015|      2018|       3|  24|
|DaugS         |S            |LV           |       2017|      2019|       2|  24|
|DaugY         |Y            |LV           |       2017|      2019|       2|  24|
|EmbE          |Y            |GB           |       2017|      2017|       0|   6|
|EmsB          |GY           |DE           |       2013|      2017|       4|  30|
|EmsH          |G            |DE           |       2014|      2018|       4|  25|
|Erne          |GY           |IE           |       2009|      2019|      10|  58|
|ErneS         |S            |IE           |       2009|      2019|      10|  55|
|Fla           |GY           |GB           |       2012|      2019|       7|  35|
|FlaE          |GY           |GB           |       2007|      2019|      12|  55|
|FlaG          |G            |GB           |       2007|      2019|      12|  55|
|GarG          |G            |FR           |       2015|      2019|       4|  37|
|GarY          |Y            |FR           |       2002|      2019|      17| 212|
|GirB          |S            |GB           |       2003|      2019|      16| 203|
|Girn          |Y            |GB           |       2008|      2019|      11| 143|
|GiSc          |G            |FR           |       1991|      2019|      28| 340|
|Grey          |GY           |GB           |       2009|      2017|       8| 108|
|Gud           |Y            |DK           |       2002|      2005|       3|  28|
|GVT           |YS           |LT           |       2018|      2018|       0|  12|
|HallE         |Y            |GB           |       2012|      2019|       7|  17|
|HauT          |S            |FI           |       1993|      2018|      25|  38|
|Isle_G        |G            |FR           |       2005|      2007|       2|  11|
|KauT          |S            |FI           |       1981|      1994|      13|  40|
|KER           |YS           |LT           |       2019|      2019|       0|   1|
|LakT          |YS           |LT           |       2017|      2019|       2|  36|
|LeaE          |Y            |GB           |       2016|      2019|       3|  19|
|LevS          |S            |GB           |       2000|      2019|      19| 103|
|Liff          |GY           |IE           |       2014|      2019|       5|  29|
|LilS          |S            |LV           |       2017|      2019|       2|  21|
|LilY          |Y            |LV           |       2017|      2019|       2|  21|
|LonE          |Y            |GB           |       2013|      2017|       4|  19|
|MajT          |S            |FI           |       1974|      2018|      44| 123|
|MarB_Y        |Y            |FR           |       1998|      1999|       1|  18|
|MerE          |Y            |GB           |       2012|      2019|       7|  40|
|MillE         |Y            |GB           |       2013|      2019|       6|  42|
|MolE          |Y            |GB           |       2012|      2019|       7|  46|
|MorE          |Y            |GB           |       2018|      2019|       1|  16|
|NeaS          |S            |GB           |       1907|      2019|     112| 113|
|NMilE         |Y            |GB           |       2009|      2019|      10|  66|
|OatY          |Y            |GB           |       2013|      2015|       2|  27|
|OirS          |S            |FR           |       2000|      2019|      19| 236|
|OnkT          |S            |FI           |       1983|      2012|      29|  36|
|Oria          |G            |ES           |       2005|      2018|      13|  40|
|RhinY         |Y            |FR           |       2006|      2019|      13| 165|
|RodE          |Y            |GB           |       2017|      2019|       2|  18|
|RuuT          |S            |FI           |       1982|      2016|      34|  35|
|akT          |YS           |LT           |       2017|      2017|       0|  12
|ScorS         |S            |FR           |       2000|      2019|      19| 236|
|SevNS         |S            |FR           |       2013|      2018|       5|  23|
|ShaE          |GY           |IE           |       2010|      2019|       9|  44|
|ShaKilS       |S            |IE           |       2009|      2019|      10|  40|
|ShaP          |Y            |IE           |       2010|      2019|       9|  48|
|Shie          |S            |GB           |       2002|      2019|      17| 215|
|ShiF          |G            |GB           |       2017|      2019|       2|  35|
|ShiM          |G            |GB           |       2014|      2019|       5|  71|
|SomS          |S            |FR           |       2013|      2019|       6|  43|
|SouS          |S            |FR           |       2011|      2019|       8|  48|
|StGeE         |GY           |GB           |       2014|      2014|       0|   8|
|StGeG         |G            |GB           |       2014|      2014|       0|   8|
|StGeY         |Y            |GB           |       2014|      2014|       0|   8|
|StoE          |Y            |GB           |       2013|      2018|       5|  33|
|Stra          |GY           |GB           |       2012|      2019|       7|   8|
|TedE          |Y            |GB           |       2014|      2019|       5|  31|
|UShaS         |S            |IE           |       2009|      2019|      10|  51|
|VaaT          |S            |FI           |       2014|      2019|       5|  48|
|VaccY         |Y            |FR           |       2000|      2018|      18| 111|
|VilS          |S            |FR           |       2012|      2018|       6|  43|
|VilY2         |Y            |FR           |       1996|      2019|      23| 278|
|ZeiT          |YS           |LT           |       2017|      2018|       1|  24|


|lfs.code |    N| Nseries|
|:------------|----:|-------:|
|G            |  712|      11|
|GY           |  630|      13|
|S            | 2569|      23|
|Y            | 1653|      31|
|YS           |   86|       6|
