# WKEELMIGRATION NOTES


renamed all files to lowercase, and only three extensions like :
`GB_fishery_closure.xlsx`
# DATABASE

* Updated all names for GY and G recruitment series [code](https://github.com/ices-eg/wg_WGEEL/commit/3fc2e32debc9ceefa524ad47836b1b5ab7e2107a)

* Removed duplicate for skagerrak norway series [code](https://github.com/ices-eg/wg_WGEEL/commit/4ec6c47a12d3f6680b58f6e52fc299527c86a252)

* Updated names for NO Imsa  [code](https://github.com/ices-eg/wg_WGEEL/commit/2ae4fda65af81d206f8b3daab25807394e79174c)

# CLOSURES


# LANDINGS
### BE

* No monthly data => remove the file

### DE
* Data for DE_Elbe is pretty much incomplete since only one state reported monthly catches. Thus, they are good for relative changes but we have to keep track that the absolute numbers are wrong for the EMU - Delete or use?
* Many rows reported as ND,NR,NM etc., with "WHOLE YEAR". -> We will not use those anyway, so I deleted them. However, as discussed so many times, this information is useful in the sense of knowing that it is not 0-catch, but e.g. no monthly data available. (Anyway, we have the original file stored if we want to use these information...) 

### ES
* ES_Anda was missing, I have add it. (No data before 2009 and forbidden later). In ES_Murc there is monthly data from 2002 on. For 2000 and 2001 data for the whole year has been provided. I have leaveD it.


### FI
* Total Landings for the whole country (EMU).  NO edits for the rest, it can be used


### FR
FR_Meus, FR_Rhin missing. I guess this is because they are international bassins withoufh fishery. NO edits for the rest, it can be used

### GB
* data for lough neagh not reported monthly -> Derek will provide monthly data for Y after Jan 20th, thus for now, the Neagh entries were deleted and a seperate file will be provided once available.
* data on Y&S is reported for GB_Total from 2011-2013 -> Assume there is no EMU data thus summed for all but GB_Scot & GB_neag, but sent an email to clarify. How to treat these? -> confirmed, left it in the sheet as GB_total  
* habitat is defined as NR for a lot of the data, if its unknown what are we going to do? -> Check with Cedric if we use those data (Cédric => I would say very probably not, if it's there we have it and can compare later on with what we have in the database for landings through shiny app, if not then it's probably not very important). I have sent an email to Ryan ". I guess that the problem is that you do not know where the catches happened exactly; if this is  the case I´d suggest to writte “FTC” since it includes all the possible habitats" and he has agreed 

Jan-Dag: After habitat was recorded, GB_Dee is the only EMU with T, thus I'd suggest using FC for the other EMUs before 2011. Also, after habitat was recorded, all glass eel fisheries have habitat "F", so I'd suggest using only F for glass eel fisheries before 2011. All others FC. -> Awaiting confirmation from Ryan.
 
* glass eel catch data is reported for whole year (season Feb to May) in GB since 2014 for several EMUs -> deleted entries, except if it was 0, then converted to respective month according to comment
* GB_NorW was missing in the EMU list and was added to this sheet -> Cedric, does the EMU exist in the database? => Yes
* WAITING FOR AN ANSWER -> Jan-Dag: I have the file prepared and will upload it once clarified

### HR
* data for 2018 is preliminary, which I think we don't want. -> delete these rows? (wasn't done by me)
* otherwise no edits needed 

### IE
* no edits needed. Esti: I  have deleted some extra "0"s in the rows below and changed some months with lower case to upper case

### DK

* data for 2019 is preliminary, which I think we don't want. -> delete these rows? (wasn't done by me)
* otherwise no edits needed 

### LTU
* I have sent this mail to Arvydas: in some "eel_value" rows there was a "0" in places where "eel_missvaluequal" was NC or NR. I have deleted those "0"s, since this would mean 0 catches, not no data. I have found that in the T - Curonian Lagoon for some months (Jan, Feb, March, Nov and DEC) you have included 0 catches. I have checked the closure document, and I have seen that the fishery is closed during this months. Therefore, I think that it would be more correct not to include this months, (o catches means you have gone fishing and your catches have been 0. Please let me know if I´m correct.  Arvydas´s answer: The main fishing gear for eel in the Curonian Lagoon is eel Fyke nets, fishing period are from April to October. The catch of eel depends on natural conditions. The water temperature is very low between November and March in Curonian Lagoon, which makes the eels passive and its does not migrate. But at the this  time (autumn, winter) in Curonian Lagoon fishermen used small mesh size traps for fishing for lamprey and smelt, and eels are sometimes caught like bycatch.  Eels are recorded by fishermen, so they appear in the statistics  (a few kilograms). But I agree that it would be more correct not to include this months. On the other hand, the increase  eel catches in November reflects climate change.SO i´LL DELETE Jan, Feb, March, Nov and DEC) 
* In some cases they have included data by month and also a total by year adding up all those months. I deleted the total because it duplicated the information.  
* In some cases, they don't have data by month and put "NC" or "ND" and then for the same year they do include whole year data. I deleted the NC and ND for months and left the annual data. 

### LV
* I have sent this mail to Janis. In the case of Latvia there was not a contact person to check the data, so I though you might be related to that.  In this way, I wanted to check with you that “0” catches is correct. You have included 0 catches during oct, nov, dec, jan, feb, marc, apr. 0 catches mean that fisher have gone fishing and their catches have been 0. Is that the case? If the fishery was closed during these months you should write NP (no pertinent ). I have checked the closures files and they only describe closures during 2018 and 2019 and they only mention closures during nov, dic, jan. Could you clarify please if the 0 s correspond to 0 catches or to a fishery closure? ANSWER: Yes, that is correct - 0 catches mean that fisher have gone fishing and their catches have been 0. There is no eel speciffic fisheries in coastal waters  - eel is a bycatch. In fresh waters also many fishermen use fyke nets and focus on multiple species, only some use eel specific gear. SO NO CHANGES NEEDED
* LV_Latv changed to LV_tota

### NL
* There are 0s in the catches, but they vary from year to year, so I understand that they do not correspond to closures in the fishery.
* I have changed  from NL_Neth  to NL_total
* ICes area was not included and I have included it

### NO
* I have found that eel_lfs_code is missing in some rows (see attached). Caroline has asked me to include YS in those cases
* I have sent a mail to Caroline to confirm that "0"s correspond to real 0 catches. ANSWER FROM CAROLINE: "The fishery closed starting in from 2011. It opened partially in 2016 (and it is still the same today): to only a few fishers which could fish from July to October." and me answer "SO I understand that for the 2011-2015 period I should change the “0” catches to NP( this means that fishery was closed) and the rest of the 0s really mean 0 cacthes (there was a a fishery activity but catches were 0). Right?" ANSWER: right

### PL
* Data for the 2000-2003 is tagged as low quality. Should we use it?

### SE
* Message for Josephine , I have found that eel_lfs_code is missing in some rows (see attached). What should I include?. Answer from Josephine: "Also, if lifestage is also missing in certain places, that too would be because it’s missing in the original file, i.e. in the data we get from Swam. This is not an easy fix problem but Swam are at least aware that their data is far from perfect and they are working on improving their database, but that does not help us now. I’m sorry I don’t have a better answer to this…". So I have deleted the rows that do not contain life stage

# SEASONALITY

## Data integration

script is [here](https://github.com/ices-eg/wg_WGEEL/blob/master/Misc/wkeelmigration/database_integration.R)

* BE Annual data reported => ignore, remove file
* Corrected Vilaine file misplaced column
* Loaded all files

 value data
---------------

* Corrected all month
* Replaced missing nameshort identifiers in France (using the name of the file)
* corrected `FR_Rhin_Y` `FR_Sous_S` `FR_Scorff_S` `FR_GAR_G` to standardize names
* corrected GirG to Gisc
* fixed names in DE
* changed names in Irish series to match with database (Burr, Erne, Liff, Burr) 
* removed special coding characters from codnames
* coordinates x and y are switched in Netherlands

 series info
---------------


* LTU file : Mismatch between ZEIT in the series and Zeit in data, renamed to Zeit
* replaced all existing series with data from database
* Sent mail to Justas ask for coordinates in Lithuania => TODO integrate updated data
* Corrected wrong format for coordinates in Finland
* Sent mail to Josefin (SE) to ask for coordinates in decimal degrees => TODO integrate updated data



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

Number of observation : 7764

Number of series : 151


Detail of years and number observation per series

|ser_nameshort |ser_lfs_code |ser_cou_code | first.year| last.year| nb_year|   N|
|:-------------|:------------|:------------|----------:|---------:|-------:|---:|
|ALA           |YS           |LT           |       2019|      2019|       1|   1|
|AllE          |Y            |GB           |       2012|      2019|       8|  49|
|AlsT          |S            |SE           |       2010|      2012|       3|  14|
|AshE          |Y            |GB           |       2014|      2016|       3|  16|
|AtrT          |S            |SE           |       2010|      2011|       2|   8|
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
|ForT          |S            |SE           |       2010|      2011|       2|   8|
|GarG          |G            |FR           |       2015|      2019|       5|  37|
|GarY          |Y            |FR           |       2002|      2019|      18| 212|
|GirB          |S            |GB           |       2003|      2019|      17| 203|
|Girn          |Y            |GB           |       2008|      2019|      12| 143|
|GiSc          |G            |FR           |       1991|      2019|      29| 340|
|GraT          |S            |SE           |       2018|      2018|       1|   4|
|Grey          |GY           |GB           |       2009|      2017|       9| 108|
|Gud           |Y            |DK           |       2002|      2005|       4|  28|
|GVT           |YS           |LT           |       2018|      2018|       1|  12|
|HallE         |Y            |GB           |       2012|      2019|       8|  17|
|HauT          |S            |FI           |       1993|      2018|      26|  38|
|hv1T          |S            |NL           |       2012|      2019|       8|  39|
|hv2T          |S            |NL           |       2012|      2019|       8|  39|
|hv3T          |S            |NL           |       2012|      2019|       8|  39|
|hv4T          |S            |NL           |       2012|      2019|       8|  39|
|hv5T          |S            |NL           |       2012|      2019|       8|  39|
|hv6T          |S            |NL           |       2012|      2019|       8|  39|
|hv7T          |S            |NL           |       2012|      2019|       8|  39|
|ij10T         |S            |NL           |       2012|      2013|       2|   6|
|ij11T         |S            |NL           |       2012|      2013|       2|   6|
|ij12T         |S            |NL           |       2012|      2013|       2|   6|
|ij1T          |S            |NL           |       2012|      2013|       2|   6|
|ij2T          |S            |NL           |       2012|      2013|       2|   6|
|ij3T          |S            |NL           |       2012|      2013|       2|   6|
|ij4T          |S            |NL           |       2012|      2013|       2|   6|
|ij5T          |S            |NL           |       2012|      2013|       2|   6|
|ij6T          |S            |NL           |       2012|      2013|       2|   6|
|ij7T          |S            |NL           |       2012|      2013|       2|   6|
|ij8T          |S            |NL           |       2012|      2013|       2|   6|
|ij9T          |S            |NL           |       2012|      2013|       2|   6|
|ImsaGY        |GY           |NO           |       2000|      2019|      20| 240|
|ImsaS         |S            |NO           |       2000|      2019|      20| 240|
|Isle_G        |G            |FR           |       2005|      2007|       3|  11|
|KauT          |S            |FI           |       1981|      1994|      14|  40|
|KavT          |S            |SE           |       2019|      2019|       1|  10|
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
|nw10T         |S            |NL           |       2012|      2019|       8|  40|
|nw1T          |S            |NL           |       2012|      2019|       8|  42|
|nw2T          |S            |NL           |       2012|      2019|       8|  40|
|nw3T          |S            |NL           |       2012|      2019|       8|  40|
|nw4T          |S            |NL           |       2012|      2019|       8|  40|
|nw5T          |S            |NL           |       2012|      2019|       8|  39|
|nw6T          |S            |NL           |       2012|      2019|       8|  39|
|nw7T          |S            |NL           |       2012|      2019|       8|  39|
|nw8T          |S            |NL           |       2012|      2019|       8|  40|
|nw9T          |S            |NL           |       2012|      2019|       8|  40|
|NydT          |S            |SE           |       2010|      2011|       2|   5|
|nz1T          |S            |NL           |       2012|      2019|       8|  32|
|nz2T          |S            |NL           |       2012|      2019|       8|  32|
|nz3T          |S            |NL           |       2012|      2019|       8|  33|
|nz4Y          |S            |NL           |       2012|      2019|       8|  32|
|nz5T          |S            |NL           |       2012|      2019|       8|  31|
|OatY          |Y            |GB           |       2013|      2015|       3|  27|
|OirS          |S            |FR           |       2000|      2019|      20| 236|
|OnkT          |S            |FI           |       1983|      2012|      30|  36|
|Oria          |G            |ES           |       2005|      2018|      14|  40|
|OstT          |S            |SE           |       2010|      2011|       2|   8|
|RhDOG         |G            |NL           |       2000|      2019|      20|  60|
|RhinY         |Y            |FR           |       2006|      2019|      14| 165|
|rij10T        |S            |NL           |       2013|      2019|       7|  30|
|rij1T         |S            |NL           |       2013|      2019|       7|  30|
|rij2T         |S            |NL           |       2013|      2019|       7|  30|
|rij3T         |S            |NL           |       2013|      2019|       7|  30|
|rij4T         |S            |NL           |       2013|      2019|       7|  30|
|rij5T         |S            |NL           |       2013|      2019|       7|  30|
|rij6T         |S            |NL           |       2013|      2019|       7|  30|
|rij7T         |S            |NL           |       2013|      2019|       7|  30|
|rij8T         |S            |NL           |       2013|      2019|       7|  30|
|rij9T         |S            |NL           |       2013|      2019|       7|  30|
|RodE          |Y            |GB           |       2017|      2019|       3|  18|
|RuuT          |S            |FI           |       1982|      2016|      35|  35|
|Sakt          |YS           |LT           |       2017|      2017|       1|  12|
|ScorS         |S            |FR           |       2000|      2019|      20| 236|
|SevNS         |S            |FR           |       2013|      2018|       6|  23|
|ShaE          |GY           |IE           |       2010|      2019|      10|  44|
|ShaKilS       |S            |IE           |       2009|      2019|      11|  40|
|ShaP          |Y            |IE           |       2010|      2019|      10|  48|
|Shie          |S            |GB           |       2002|      2019|      18| 215|
|ShiF          |G            |GB           |       2017|      2019|       3|  35|
|ShiM          |G            |GB           |       2014|      2019|       6|  71|
|SkaT          |S            |SE           |       2010|      2011|       2|  11|
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
|VesT          |S            |SE           |       2010|      2011|       2|  10|
|VilS          |S            |FR           |       2012|      2018|       7|  43|
|VilY2         |Y            |FR           |       1996|      2019|      24| 278|
|Vist          |Y            |PL           |       2017|      2019|       3|  19|
|ZeiT          |YS           |LT           |       2017|      2018|       2|  24|
|zm            |S            |NL           |       2012|      2017|       6|  28|
|zm10T         |S            |NL           |       2012|      2017|       6|  27|
|zm1T          |S            |NL           |       2012|      2017|       6|  28|
|zm2T          |S            |NL           |       2012|      2017|       6|  27|
|zm3T          |S            |NL           |       2012|      2017|       6|  27|
|zm5T          |S            |NL           |       2012|      2017|       6|  27|
|zm6T          |S            |NL           |       2012|      2017|       6|  28|
|zm7T          |S            |NL           |       2012|      2017|       6|  27|
|zm8T          |S            |NL           |       2012|      2017|       6|  27|
|zm9T          |S            |NL           |       2012|      2017|       6|  27|


Number of line per lifestage.

|lfs.code |    N| Nseries|
|:------------|----:|-------:|
|G            |  712|      11|
|GY           |  630|      13|
|S            | 2569|      23|
|Y            | 1653|      31|
|YS           |   86|       6|

Number of line per month per lifestage.


|ser\_lfs__code |   1|   2|   3|   4|   5|   6|   7|   8|   9|  10|  11|  12|
|:------------|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|G            |  50|  52|  71|  92|  97|  75|  75|  57|  55|  50|  50|  48|
|GY           |  29|  37| 145|  66|  97|  99|  99|  98|  82|  56|  32|  30|
|S            | 207| 202| 397| 416| 485| 274| 192| 358| 501| 521| 501| 310|
|Y            |  64|  66|  86| 184| 202| 208| 192| 188| 202| 114|  99|  67|
|YS           |   7|   7|   7|   7|   7|   7|   7|   7|   7|   9|   7|   7|
