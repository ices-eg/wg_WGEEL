# WKEELMIGRATION NOTES

These notes are related to the treatment and integration of files, you can start with this file, and then for more details about data integration switch to the other markdown (.md) files in this folder.
read in this order time_series_seasonality.md and jags_modelling.md (for time series) and landings_seasonality (for landings data)

As a first step we have renamed all files to lowercase, and only three extensions like :
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
* ES_Murc duplicated values in jan, feb, marc in 2013. Message sent asking for clarification.  
* ES_Basq, Es_Cata, ES_Astu: data was pasted twice. ONe has been deleted. 

### FI
* Total Landings for the whole country (EMU).  
* Mail to Jouni: I have realized that you have two values for June and we should just have one. Could you please check that? .  ANSWER: there was a mistake, JOuni has sent a new file


### FR
FR_Meus, FR_Rhin missing. I guess this is because they are international bassins withoufh fishery (CEDRIC Confirm, there is no commercial fishery there). NO edits for the rest, it can be used

### GB
* data for lough neagh not reported monthly -> Derek will provide monthly data for Y after Jan 20th, thus for now, the Neagh entries were deleted and a seperate file will be provided once available.
* data on Y&S is reported for GB_Total from 2011-2013 -> Assume there is no EMU data thus summed for all but GB_Scot & GB_neag, but sent an email to clarify. How to treat these? -> confirmed, left it in the sheet as GB_total  
* habitat is defined as NR for a lot of the data, if its unknown what are we going to do? -> Check with Cedric if we use those data (Cédric => I would say very probably not, if it's there we have it and can compare later on with what we have in the database for landings through shiny app, if not then it's probably not very important). I have sent an email to Ryan ". I guess that the problem is that you do not know where the catches happened exactly; if this is  the case I´d suggest to writte “FTC” since it includes all the possible habitats" and he has agreed 

Jan-Dag: After habitat was recorded, GB_Dee is the only EMU with T (but it has no NR lines), thus I'd suggest using FC for the other EMUs before 2011. Also, after habitat was recorded, all glass eel fisheries have habitat "F", so I'd suggest using only F for glass eel fisheries before 2011. -> confirmed by Ryan and changes were made. File is uploaded (suffix EDITED_UPDATED)
 
* glass eel catch data is reported for whole year (season Feb to May) in GB since 2014 for several EMUs -> deleted entries, except if it was 0, then converted to respective month according to comment
* GB_NorW was missing in the EMU list and was added to this sheet -> Cedric, does the EMU exist in the database? => Yes

DONE => Just waiting for the additional data from Derek, but they'll come in a seperate file

### HR
* data for 2018 is preliminary, which I think we don't want. -> delete these rows? (wasn't done by me)
* otherwise no edits needed 

### IE
* I  have deleted some extra "0"s in the rows below and changed some months with lower case to upper case
* They were some duplicates because in the same EMU catches were coming for different RBDs, we will add those to have one value per EMU

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
* ICes area was not included and I have included it =>(Cédric unless we are dealing with coastal or marine areas corresponding to ICES division, and I don't think we will have much of those, I don't think we are gonna use the ICES area). 

### NO
* I have found that eel_lfs_code is missing in some rows (see attached). Caroline has asked me to include YS in those cases
* I have sent a mail to Caroline to confirm that "0"s correspond to real 0 catches. ANSWER FROM CAROLINE: "The fishery closed starting in from 2011. It opened partially in 2016 (and it is still the same today): to only a few fishers which could fish from July to October." and me answer "SO I understand that for the 2011-2015 period I should change the “0” catches to NP( this means that fishery was closed) and the rest of the 0s really mean 0 cacthes (there was a a fishery activity but catches were 0). Right?" ANSWER: right

### PL
* Data for the 2000-2003 is tagged as low quality. Should we use it?
* Message for Tomasz: ´ I have realized that for the same EMU, habitat and life stage and month you have different catches (see below). We just  need to have one value per year/month/emu/habitat. Could you please aggregate the data in that way? WAITING FOR THE ANSWER

### SE
* Message for Josepin , I have found that eel_lfs_code is missing in some rows (see attached). What should I include?. Answer from Josephine: "Also, if lifestage is also missing in certain places, that too would be because it’s missing in the original file, i.e. in the data we get from Swam. This is not an easy fix problem but Swam are at least aware that their data is far from perfect and they are working on improving their database, but that does not help us now. I’m sorry I don’t have a better answer to this…". So I have deleted the rows that do not contain life stage
* Message for Josepin : we are reviewing  the data sent by each country before the meeting. In this way, I have realized that you have two values for June 2018 for S and F. Can you check that please?. ANSWER, you have to add the two values for F. Done

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
* removed comments in wrong column GB and pasted them to previous comments

Hilaire corrections :

* In the Irish seasonality file line 38 (série BurS), error for year: should be 1973 instead of 1972
* In Finland, for the MajT series, 
	wondering whether lines 110 à 115 should be in 1988. In any case there are doubles,
	for lines 124 and 125, should be 1991
* In France:
	double for June on the Scorff, contacter Clarisse to ask her
	On Souston, line 40 should be 2017, not 2018



 series info
---------------


* LTU file : Mismatch between ZEIT in the series and Zeit in data, renamed to Zeit
* replaced all existing series with data from database
* Sent mail to Justas ask for coordinates in Lithuania => TODO integrate updated data
* Corrected wrong format for coordinates in Finland
* Sent mail to Josefin (SE) to ask for coordinates in decimal degrees => TODO integrate updated data
