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

[code](https://github.com/ices-eg/wg_WGEEL/commit/d1e4f55f7a09742077efeaed43b7b9cceeeda021)

Detail of years and number observation per series

|ser\_nameshort |ser\_lfs\_code |ser\_cou\_code | first.year| last.year| nb_year|   N|
|:-------------|:------------|:------------|----------:|---------:|-------:|---:|
|ALA           |YS           |LT           |       2019|      2019|       1|   1|
|AllE          |Y            |GB           |       2012|      2019|       8|  49|
|AshE          |Y            |GB           |       2014|      2016|       3|  16|
|BadB          |S            |GB           |       2003|      2019|      17| 203|
|Bann          |GY           |GB           |       1933|      2019|      87|  87|
|BeeG          |G            |GB           |       2006|      2019|      14|  56|
|BowE          |Y            |GB           |       2012|      2016|       5|  30|
|Bro           |GY           |GB           |       2008|      2010|       3|  24|
|BroE          |GY           |GB           |       2011|      2019|       9|  72|
|BroG          |GY           |GB           |       2011|      2019|       9|  72|
|BroS          |Y            |GB           |       2011|      2019|       9|  72|
|BurFe         |Y            |IE           |       1987|      1988|       2|  10|
|BurFu         |Y            |IE           |       1987|      1988|       2|  16|
|Burr          |G            |IE           |       2014|      2019|       6|  34|
|BurS          |S            |IE           |       1970|      2019|      50| 592|
|CraE          |Y            |GB           |       2015|      2018|       4|  24|
|DaugS         |S            |LV           |       2017|      2019|       3|  24|
|DaugY         |Y            |LV           |       2017|      2019|       3|  24|
|EmbE          |Y            |GB           |       2017|      2017|       1|   6|
|EmsB          |GY           |DE           |       2013|      2017|       5|  30|
|EmsH          |G            |DE           |       2014|      2018|       5|  25|
|Erne          |GY           |IE           |       2009|      2019|      11|  58|
|ErneS         |S            |IE           |       2009|      2019|      11|  55|
|Fla           |GY           |GB           |       2012|      2019|       8|  35|
|FlaE          |GY           |GB           |       2007|      2019|      13|  55|
|FlaG          |G            |GB           |       2007|      2019|      13|  55|
|GarG          |G            |FR           |       2015|      2019|       5|  37|
|GarY          |Y            |FR           |       2002|      2019|      18| 212|
|GirB          |S            |GB           |       2003|      2019|      17| 203|
|Girn          |Y            |GB           |       2008|      2019|      12| 143|
|GiSc          |G            |FR           |       1991|      2019|      29| 340|
|Grey          |GY           |GB           |       2009|      2017|       9| 108|
|Gud           |Y            |DK           |       2002|      2005|       4|  28|
|GVT           |YS           |LT           |       2018|      2018|       1|  12|
|HallE         |Y            |GB           |       2012|      2019|       8|  17|
|HauT          |S            |FI           |       1993|      2018|      26|  38|
|Isle_G        |G            |FR           |       2005|      2007|       3|  11|
|KauT          |S            |FI           |       1981|      1994|      14|  40|
|KER           |YS           |LT           |       2019|      2019|       1|   1|
|LakT          |YS           |LT           |       2017|      2019|       3|  36|
|LeaE          |Y            |GB           |       2016|      2019|       4|  19|
|LevS          |S            |GB           |       2000|      2019|      20| 103|
|Liff          |GY           |IE           |       2014|      2019|       6|  29|
|LilS          |S            |LV           |       2017|      2019|       3|  21|
|LilY          |Y            |LV           |       2017|      2019|       3|  21|
|LonE          |Y            |GB           |       2013|      2017|       5|  19|
|MajT          |S            |FI           |       1974|      2018|      45| 123|
|MarB_Y        |Y            |FR           |       1998|      1999|       2|  18|
|MerE          |Y            |GB           |       2012|      2019|       8|  40|
|MillE         |Y            |GB           |       2013|      2019|       7|  42|
|MolE          |Y            |GB           |       2012|      2019|       8|  46|
|MorE          |Y            |GB           |       2018|      2019|       2|  16|
|NeaS          |S            |GB           |       1907|      2019|     113| 113|
|NMilE         |Y            |GB           |       2009|      2019|      11|  66|
|OatY          |Y            |GB           |       2013|      2015|       3|  27|
|OirS          |S            |FR           |       2000|      2019|      20| 236|
|OnkT          |S            |FI           |       1983|      2012|      30|  36|
|Oria          |G            |ES           |       2005|      2018|      14|  40|
|RhinY         |Y            |FR           |       2006|      2019|      14| 165|
|RodE          |Y            |GB           |       2017|      2019|       3|  18|
|RuuT          |S            |FI           |       1982|      2016|      35|  35|
|akT          |YS           |LT           |       2017|      2017|       1|  12
|ScorS         |S            |FR           |       2000|      2019|      20| 236|
|SevNS         |S            |FR           |       2013|      2018|       6|  23|
|ShaE          |GY           |IE           |       2010|      2019|      10|  44|
|ShaKilS       |S            |IE           |       2009|      2019|      11|  40|
|ShaP          |Y            |IE           |       2010|      2019|      10|  48|
|Shie          |S            |GB           |       2002|      2019|      18| 215|
|ShiF          |G            |GB           |       2017|      2019|       3|  35|
|ShiM          |G            |GB           |       2014|      2019|       6|  71|
|SomS          |S            |FR           |       2013|      2019|       7|  43|
|SouS          |S            |FR           |       2011|      2019|       9|  48|
|StGeE         |GY           |GB           |       2014|      2014|       1|   8|
|StGeG         |G            |GB           |       2014|      2014|       1|   8|
|StGeY         |Y            |GB           |       2014|      2014|       1|   8|
|StoE          |Y            |GB           |       2013|      2018|       6|  33|
|Stra          |GY           |GB           |       2012|      2019|       8|   8|
|TedE          |Y            |GB           |       2014|      2019|       6|  31|
|UShaS         |S            |IE           |       2009|      2019|      11|  51|
|VaaT          |S            |FI           |       2014|      2019|       6|  48|
|VaccY         |Y            |FR           |       2000|      2018|      19| 111|
|VilS          |S            |FR           |       2012|      2018|       7|  43|
|VilY2         |Y            |FR           |       1996|      2019|      24| 278|
|ZeiT          |YS           |LT           |       2017|      2018|       2|  24|

Number of line per lifestage.

|lfs.code |    N| Nseries|
|:------------|----:|-------:|
|G            |  712|      11|
|GY           |  630|      13|
|S            | 2569|      23|
|Y            | 1653|      31|
|YS           |   86|       6|

Number of line per month per lifestage.

|ser\_lfs\_code |   1|   2|   3|   4|   5|   6|   7|   8|   9|  10|  11|  12|
|:------------|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|G            |  50|  52|  51|  71|  78|  75|  75|  57|  55|  50|  50|  48|
|GY           |   9|  17| 125|  46|  77|  79|  79|  78|  62|  36|  12|  10|
|S            | 187| 182| 169| 176| 242| 210| 161| 324| 230| 244| 232| 212|
|Y            |  64|  66|  86| 183| 199| 205| 189| 185| 199| 111|  99|  67|
|YS           |   7|   7|   7|   7|   7|   7|   7|   7|   7|   9|   7|   7|