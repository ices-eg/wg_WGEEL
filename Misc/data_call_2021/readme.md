# AL
Annex 4 (by GFCM) catch_landings	‘ 32 new values inserted in the database’

 

Annex 7 (by GFCM) - silver eel releases... T&T? Captured in catches? Someting else? There is no n_release, so it doesn't work. Error: object 'release_tot' not found

Annex 12 (by GFCM)

# BE


# DE
## annex 1
13 modified series
35 new dataseries
5 modified dataseries

## Annex 3 
New data is not new (rather an update?)


## Annex 4 
Why is Schl updated, it did not change, did it?

NOTE CEDRIC REMOVED LINES WITH eel_qal_id=0 as they are duplicates
|eel_typ_id|eel_qal_id|eel_year|eel_emu_nameshort|eel_lfs_code|eel_hty_code|eel_area_division|eel_value     |eel_missvaluequal|eel_datasource|eel_datelastupdate|n  |
|----------|----------|--------|-----------------|------------|------------|-----------------|--------------|-----------------|--------------|------------------|---|
|4         |0         |2019    |DE_Warn          |S           |F           |                 |              |NC               |dc_2020       |2020-09-01        |2  |
|4         |1         |2019    |DE_Warn          |S           |F           |                 |5461          |                 |dc_2021       |2021-09-08        |2  |
|4         |0         |2019    |DE_Warn          |Y           |F           |                 |              |NC               |dc_2020       |2020-09-01        |2  |
|4         |1         |2019    |DE_Warn          |Y           |F           |                 |6252          |                 |dc_2021       |2021-09-08        |2  |
|4         |0         |2019    |DE_Warn          |YS          |F           |                 |              |NC               |dc_2020       |2020-09-01        |2  |
|4         |1         |2019    |DE_Warn          |YS          |F           |                 |206           |                 |dc_2021       |2021-09-08        |2  |

## Annex 5 
e.g. 425800 updated but only quality changes... This is not for the provider to change, is it?

## Annex 7
No new values could be added yet, as weight data was missing. This still needs to be added in the original data, and then the new release data can be integrated

We updated 1241 values. The updates that were marked with DELETE in the comment column need to be undone. They were deleted because Germany does not use weight data, but WGEEL needs the weight data, so these data should not be deleted. It needs to be seen if it is possible to remove these DELETE comments in the database, to preserve these data.

## Annex 8:
Still needs to be integrated, there was a bug where updated values did not appear in the Shiny application. We wait until this bug is fixed.

## Annex 2 
the Annex 2 was modified to delete empty lines and change was made for id_typ_serie. The new file is in the sharepoint

new series = 0  
modified series = 1  
new dataseries = 1  
modified dataseries = 0  
new biometry =0  
modified biometry = 0  

## Annex 3
the Annex 3 was modified to delete empty lines and add some informations on area division. The new file is in the sharepoint

new series = 0  
modified series = 1  
new dataseries = 1  
modified dataseries = 0  
new biometry = 2  
modified biometry = 1   

## Annex 4 
the Annex 4 was modified to add some informations on area division. The new file is in the sharepoint

duplicate = 0  
new = 150  
updated = 497 

## Annex 5 
the Annex 5 was modified rec_catch_kg have been deleted

duplicate = 0  
new = 158 [lines with NP for rec_catch_kg have been deleted]  
updated = 490
## Annex 9 
new=378
## Annex 10
new=261

# CZ

Is there any report from accession ?

## Annex 4 
Why is Schl updated, it did not change, did it?

## Annex 5 
e.g. 425800 updated but only quality changes... This is not for the provider to change, is it?

## Annex 7
No new values could be added yet, as weight data was missing. This still needs to be added in the original data, and then the new release data can be integrated

We updated 1241 values. The updates that were marked with DELETE in the comment column need to be undone. They were deleted because Germany does not use weight data, but WGEEL needs the weight data, so these data should not be deleted. It needs to be seen if it is possible to remove these DELETE comments in the database, to preserve these data.

## Annex 8:
Still needs to be integrated, there was a bug where updated values did not appear in the Shiny application. We wait until this bug is fixed.

## Annex 2 
the Annex 2 was modified to delete empty lines and change was made for id_typ_serie. The new file is in the sharepoint

new series = 0  
modified series = 1  
new dataseries = 1  
modified dataseries = 0  
new biometry =0  
modified biometry = 0  

## Annex 3
the Annex 3 was modified to delete empty lines and add some informations on area division. The new file is in the sharepoint

new series = 0  
modified series = 1  
new dataseries = 1  
modified dataseries = 0  
new biometry = 2  
modified biometry = 1   

## Annex 4 
the Annex 4 was modified to add some informations on area division. The new file is in the sharepoint

duplicate = 0  
new = 150  
updated = 497 

## Annex 5 
the Annex 5 was modified rec_catch_kg have been deleted

duplicate = 0  
new = 158 [lines with NP for rec_catch_kg have been deleted]  
updated = 490
## Annex 9 
new=378
## Annex 10
new=261
# DK
Question about DK_total

Concerning the annex 15 of the data call. 
In general DK has one EMU which is DK_Inla additional there is an obtion  DK_total (that is used by me as a management unit covering all marine areas). But in annex 15 there is no DK_total option

There is isn't it ?

![image](https://user-images.githubusercontent.com/26055877/122236707-069d9c80-cebf-11eb-9b01-e331138c70e3.png)

You can use it. This is for the management units
## Annex 1

the Annex 1 was modified to delete empty lines. The new file is in the sharepoint
new series = 0  
modified series = 2  
new dataseries = 3  
modified dataseries = 0  
new biometry = 70  
modified biometry = 0  

## Annex 2 
the Annex 2 was modified to delete empty lines. The new file is in the sharepoint

new series = 0  
modified series = 0 
new dataseries = 1  
modified dataseries = 1  
new biometry =10  
modified biometry = 0  

## Annex 3
the Annex 3 was modified to delete empty lines and also problem of misundersting between das_effort and das_value. The new file is in the sharepoint

new series = 0  
modified series = 1  
new dataseries = 2  
modified dataseries = 3  
new biometry = 0  
modified biometry = 0


## Annex 4: 
4 new values added.
## Annex 5:
5 new values added and 1 value is corrected
## Annex 6
No data

## Annex 8

2 new values

33 updated values

corrections : missing type so addes q_aqua_kg and should DK uppercase

## Annex 9

 removed lines with nothing in 2007 2008


# DZ
Annex 4 (by GFCM)
42 new inserted values

# EE

|log_cou_code|log_data       |log_message                             |
|------------|---------------|----------------------------------------|
|EE          |biomass        |‘ 6 new values inserted in the database’|
|EE          |mortality_rates|‘ 6 new values inserted in the database’|
|EE          |catch_landings |‘ 4 new values inserted in the database’|


# EG

Annex 4 (by GFCM) 
|log_cou_code|log_data      |log_message                              |
|------------|--------------|-----------------------------------------|
|EG          |catch_landings|‘ 42 new values inserted in the database’|

# ES

## Annex 1
the Annex 1 was modified as corrupted data was found and empty lines were deleted in new_data. The new file is in the sharepoint

new series = 0  
modified series = 8  
new dataseries = 6  
modified dataseries = 17 
new biometry = 7  
modified biometry = 0  

## Annex 2 
the Annex 2 was modified as some effort were changed to correspond to the reference table. The new file is in the sharepoint

new series = 3  
modified series = 3  
new dataseries = 88  
modified dataseries = 0  
new biometry =23  
modified biometry = 0  

## Annex 3
the Annex 3 was modified as some character in numeric cells has been found. The new file is in the sharepoint

new series = 3  
modified series = 3  
new dataseries = 36  
modified dataseries = 0  
new biometry = 23  
modified biometry = 0   

## Annex 4 
83 updated values
262 new values (values for ES_Murc were both in new data and updated data)
at some points, there was a mess so we needed using this query
```sql
delete from datawg.t_eelstock_eel where eel_typ_id = 4 and eel_datasource ='dc_2021' and eel_qal_id =1 and eel_cou_code ='ES';
update datawg.t_eelstock_eel set eel_qal_id=1 where eel_typ_id =4 and eel_qal_id=21 and eel_cou_code='ES';
```

PLEASE CHECK DUPLICATES
|eel_typ_id|eel_qal_id|eel_year|eel_emu_nameshort|eel_lfs_code|eel_hty_code|eel_area_division|eel_value     |eel_missvaluequal|eel_datasource|eel_datelastupdate|n  |
|----------|----------|--------|-----------------|------------|------------|-----------------|--------------|-----------------|--------------|------------------|---|
|4         |0         |2014    |ES_Murc          |S           |C           |37.1.1           |              |NC               |dc_2021       |2021-09-08        |2  |
|4         |1         |2014    |ES_Murc          |S           |C           |37.1.1           |20028         |                 |dc_2021       |2021-09-09        |2  |
|4         |0         |2015    |ES_Murc          |S           |C           |37.1.1           |              |NC               |dc_2021       |2021-09-08        |2  |
|4         |1         |2015    |ES_Murc          |S           |C           |37.1.1           |13580         |                 |dc_2021       |2021-09-09        |2  |
|4         |0         |2016    |ES_Murc          |S           |C           |37.1.1           |              |NC               |dc_2021       |2021-09-08        |2  |
|4         |1         |2016    |ES_Murc          |S           |C           |37.1.1           |24244         |                 |dc_2021       |2021-09-09        |2  |



## Annex 5 

duplicate = 0  
new = 1578 [lines with NP for rec_catch_kg should have been deleted]  
updated = 0 

## Annex 6 

NO DATA

## Annex 7 

duplicate = 0  
new = 15  
updated = 3  

## Annex 8 

duplicate = 0  
new = 5  
updated = 0 

# FI


## Annex 8 

During the datacall, clarisse identified duplicates in issue #194.
Pressing a bit further there was indeed a duplicate for FINLAND aquaculture in
2014 and 2015. Two exact duplicates lines (500 t) has been removed.

## Annex 1
NO DATA
## Annex 2 
the Annex 2 was modified as in the new_biometry sheet columns were missing and effort has changed. The new file is in the sharepoint

new series = 2  
modified series = 0  
new dataseries = 7  
modified dataseries = 0  
new biometry =7  
modified biometry = 0  

## Annex 3
the Annex 3 was modified as in the new_biometry sheet columns were missing. The new file is in the sharepoint

new series = 2  
modified series = 0  
new dataseries = 11 
modified dataseries = 0  
new biometry = 11  
modified biometry = 0   
## Annex 4 
13 New values added, 1 value updated

## Annex 5
6 new values added

## Annex 6
1 new value added.

## Annex 8 

During the datacall, clarisse identified duplicates in issue #194.
Pressing a bit further there was indeed a duplicate for FINLAND aquaculture in
2014 and 2015. Two exact duplicates lines (500 t) has been removed.

## Annex 9 

No data.

## Annex 10   

No data.


# FR
-----------------------------------------------------------

## Annex 1

new series = 0  
modified series = 12  
new dataseries = 6  
modified dataseries = 28  
new biometry = 22  
modified biometry = 24  

## Annex 2 

new series = 6  
modified series = 13  
new dataseries = 62  
modified dataseries = 100  
new biometry =60  
modified biometry = 99  

## Annex 3

new series = 0  
modified series = 6  
new dataseries = 6  
modified dataseries = 2  
new biometry = 5  
modified biometry = 3   

## Annex 4 

duplicate = 0  
new = 157  
updated = 24  

## Annex 5 

duplicate = 0  
new = 125 [2765 lines with NP for rec_catch_kg should have been deleted]  
updated = 3 

## Annex 6 

NO DATA

## Annex 7 

duplicate = 0  
new = 22  
updated = 4  

## Annex 8 

NO DATA

## Annex 9 

NO DATA

## Annex 10 

NO DATA

# GR
-----------------------------------------------------------

## Annex 5
1033 new values
1 value updated

## Annex 6. Error: object 'release_tot' not found"
## Annex 8.

remove data per habitat for aquaculture (in existing kept there are values for Freshwater, this is wrong.) These values are duplicated with values entered for 2017 without the Freshwater tag. Suggestion = remove all data for aquaculture and Freshwater and update the rest if wrong

# HR
-----------------------------------------------------------

Croatia do we have anything ? 

# GB
-----------------------------------------------------------

## Annex 1

Changed name of the series from OatY to OatGY.  
1 new series was entered.  
22 series were modified.  
59 new data series were added (20 of those had no data values entered as were classified as NR, NC or NP).  
39 data series were modified.  
102 new biometry entries, mainly blank entries as data were not collected. Only 4 series had biometry data.   
No biometry data were modified.  

## Annex 2 

No new series.  
49 series were modified.  
107 new data series were added (96 of those had no data values entered as were classified as NR or NC).   
13 data series were modified.  
122 new biometry entries, mainly blank entries as data were not collected. Only 4 series had biometry data.   
No biometry data were modified.  

## Annex 3 

No new series.  
6 series were modified.  
15 new data series were added (11 of those had no data values entered as were classified as NR, NC or NP).   
No data series were modified.  
24 new biometry entries, mainly blank entries as data were not collected. Only 3 series had biometry data.   
No biometry data were modified.  

## Annex 4 

No duplicates.  
168 new values were added (145 of those had no data values entered as were classified as NP).  
79 values were updated.  

CEDRIC  :
> Note I have removed 55 duplicates with same values, one line with eel_qal_id 0 and one line with eel_qal_id 1, both NC
> I removed the zero values from the database
> I still have those to deal with, do I remove all zeros ?

|eel_id|eel_typ_id|eel_qal_id|eel_year|eel_emu_nameshort|eel_lfs_code|eel_hty_code|eel_value|eel_missvaluequal|eel_datasource|eel_datelastupdate|eel_cou_code|n  |
|------|----------|----------|--------|-----------------|------------|------------|---------|-----------------|--------------|------------------|------------|---|
|382126|4         |0         |2017    |GB_Angl          |S           |F           |         |ND               |dc_2017       |2019-08-29        |GB          |2  |
|381982|4         |0         |2017    |GB_Angl          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382203|4         |0         |2017    |GB_Dee           |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382061|4         |0         |2017    |GB_Dee           |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382113|4         |0         |2017    |GB_Humb          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|381969|4         |0         |2017    |GB_Humb          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382074|4         |0         |2017    |GB_NorW          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382100|4         |0         |2017    |GB_Nort          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|381956|4         |0         |2017    |GB_Nort          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382177|4         |0         |2017    |GB_Seve          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382034|4         |0         |2017    |GB_Seve          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382228|4         |0         |2017    |GB_Solw          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382087|4         |0         |2017    |GB_Solw          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382294|4         |0         |2005    |GB_SouE          |G           |T           |         |NP               |dc_2017       |2019-08-29        |GB          |2  |
|382296|4         |0         |2007    |GB_SouE          |G           |T           |         |NP               |dc_2017       |2019-08-29        |GB          |2  |
|382297|4         |0         |2008    |GB_SouE          |G           |T           |         |NP               |dc_2017       |2019-08-29        |GB          |2  |
|382151|4         |0         |2017    |GB_SouE          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382008|4         |0         |2017    |GB_SouE          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382164|4         |0         |2017    |GB_SouW          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382021|4         |0         |2017    |GB_SouW          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382136|4         |0         |2015    |GB_Tham          |S           |F           |         |NP               |dc_2017       |2019-03-22        |GB          |2  |
|382138|4         |0         |2017    |GB_Tham          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|381995|4         |0         |2017    |GB_Tham          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382187|4         |0         |2014    |GB_Wale          |S           |F           |         |NP               |dc_2017       |2019-03-22        |GB          |2  |
|382044|4         |0         |2014    |GB_Wale          |Y           |F           |         |NP               |dc_2017       |2019-03-22        |GB          |2  |
|382265|4         |0         |2015    |GB_Wale          |G           |T           |         |NP               |dc_2017       |2019-08-29        |GB          |2  |
|382190|4         |0         |2017    |GB_Wale          |S           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |
|382048|4         |0         |2017    |GB_Wale          |Y           |F           |         |ND               |dc_2017       |2019-03-22        |GB          |2  |


## Annex 5 

No recreational landings in the UK (180 new values inserted in the database for 2021 and some for 2020, all NP).

## Annex 6 


No duplicates.

1 new value was added.

No values were updated.


## Annex 7 

No duplicates.  
18 new values were added (12 of those had no data values entered as were classified as NP).  
14 values were updated.  

## Annex 8 

No aquaculture.

## Annex 9 

588 new values were added (90 of those had no data values entered as were classified as NC or NR).

## Annex 10 

406 new values were added (173 of those had no data values entered as were classified as NP, NC or NR).


# IE
-----------------------------------------------------------


|log_cou_code|log_data      |log_message                              |
|------------|--------------|-----------------------------------------|
|IE          |catch_landings|‘ 72 new values inserted in the database’|
|IE          |catch_landings|‘6 values updated in the db’             |
|IE          |catch_landings|‘54 values updated in the db’            |
|IE          |catch_landings|‘ 6 new values inserted in the database’ |
|IE          |aquaculture   |‘ 13 new values inserted in the database’|
|IE          |catch_landings|‘ 72 new values inserted in the database’|


## Annex 1
update series 8 values; new data series 15 new values; modified dataseries 5 values; new biometry 3 new values; update biometry 7 new values

## Annex 2 

## Annex 3  
update series 2 new values; new dataseries 2 new values, new biometry 2 new values; update biometry 43 new values
There is an empty first line on updated biometry

## Annex 4 

commercial
72 new values
54 updated

## Annex 5 

rec landings

new values 72

deleted rec_catch as value was np and throwing up errors

## Annex 6 

landings other; 6 new values; 6 updated values

## Annex 7 release

Cédric : You cannot report other_landings there, it's fine if you put two lines in other landings instead, one for numbers and one for kilograms.
32	other_landings_kg	This is neither recreational fishery, nor commercial fishery, for example catching a quantity of eel at a trapping ladder below a dam can be qualitied as other_landings, the exact purpose should be provided in the corresponding comment
33	other_landings_n	This is neither recreational fishery, nor commercial fishery, for example catching a number of eel at a trapping ladder below a dam can be qualitied as other_landings, the exact purpose should be provided  in the corresponding comment
![image](https://user-images.githubusercontent.com/26055877/131523004-b86ae0e4-9012-47ea-99b0-f6e5f7843354.png)

6 new values and 6 updated values
## Annex 8 
aquaculture
13 new values
## Annex 9 
252 new values
## Annex 10 
biomass
new values 174

# IT



## Annex 4


|log_cou_code|log_data      |log_message                               |
|------------|--------------|------------------------------------------|
|IT          |catch_landings|‘ 270 new values inserted in the database’|


## Annex 5
Error in Step 2.1 Integrate /proceed duplicates rows: Failed to prepare query: ERROR:  column "eel_value" does not exist
LINE 17:       eel_value,
HINT:  There is a column named "eel_value" in table "t_eelstock_eel", but it cannot be referenced from this part of the query.


# LT

# LV
=======


# LT (Lithuania)
## Annex 4 
28 new values added.
## Annex 5
1 new value added.
## Annex 6
NO DATA
## Annex 9 
58 new values were added.
## Annex 10  
84 new values were added.

# LV (Latvia)
## Annex 2
2 series were modified.   
2 new data series were added.  
2 new biometry data were added.   
## Annex 3
2 series were modified.   
2 new data series were added.   
2 new biometry data were added.   
## Annex 4
12 New values added
## Annex 5
2 New values added
## Annex 6
NO DATA
## Annex 9 
29 new values were added.
## Annex 10   
42 new values were added.
>>>>>>> branch 'master' of https://github.com/ices-eg/wg_WGEEL.git

# MA

# NL 

## Annex 1

|log_cou_code|log_data |log_message                              |
|------------|---------|-----------------------------------------|
|NL          |glass_eel|‘5 values updated in the db’             |
|NL          |glass_eel|‘ 5 new values inserted in the database’ |
|NL          |glass_eel|‘2 values updated in the db’             |
|NL          |glass_eel|‘ 55 new values inserted in the database’|


## Annex 2 

## Annex 3: in dataset new_biometry ser_nameshort>, value <DOIJS> is wrong, possibly not entered yet
  
## Annex 4 

## Annex 5 

## Annex 6 

## Annex 7 

## Annex 8 

## Annex 9 

## Annex 10   


# NO (Norway) 
 
## Annex 1
 
New dataseries=1

Modified biometry=1

New biometry=0
 
## Annex 2
 
No data 
 
## Annex 3
 
New dataseries=1

New biometry=1
 
## Annex 4
 
New dataseries=12 (only 1 line of values, 11 lines of "NP")

## Annex 5 
 
No data
 
## Annex 6
 
No data
 
## Annex 7
 
No data
 
## Annex 8 
 No data
 
## Annex 9 

 New dataseries= 42 (15 lines with values and 27 lines "NC")

## Annex 10
 
New dataseries=29 (10 lines with values and 19 lines with "NC") 

# PL 
 

## Annex 1

NO DATA

## Annex 2 

new series = 0
modified series = 1 
new dataseries = 1  
modified dataseries = 0  
new biometry =0 
modified biometry = 0  

## Annex 3

NO DATA

## Annex 4 

duplicate = 0  
new = 52  
updated = 0  

## Annex 5 

duplicate = 0  
new = 26 [lines with NP for rec_catch_kg should have been deleted]  
updated = 0 

## Annex 6 

NO DATA

## Annex 7 

duplicate = 0  
new = 4  
updated = 0  

## Annex 8 

NO DATA

## Annex 9 

new data: 84

## Annex 10 

new data: 58 

# PT
## Annex 1
 3 modified series info
 3 new dataseries values
 4 new biometry inserted
 
 ## Annex 2
 2 series info updated
2 new data series insered
2 new biometry 
 
 ## Annex 3
 2 series info modified
 2 new password
 2 new biometry inserted
 
 ## Annex 4
 2 new values (2020)
 
 ## Annex 5
 24 inserted (NP past data)
 
 ## Annex 6
 empty
 
 ## Annex 7
 
  ## Annex 8
 
 removed 4 lines with delete in aquaculture
 
 # SE

## Annex 1
  
  11 modified series
  
  7 new data series
  
  275 new biometry
  
  

## Annex 2 
  
|log_cou_code|log_data  |log_message                             |
|------------|----------|----------------------------------------|
|SE          |yellow_eel|‘11 values updated in the db’           |
|SE          |yellow_eel|‘6 values updated in the db’            |
|SE          |yellow_eel|‘ 4 new values inserted in the database’|


## Annex 3 
  
|log_cou_code|log_data  |log_message                             |
|------------|----------|----------------------------------------|
|SE          |silver_eel|‘ 1 new values inserted in the database’|
|SE          |silver_eel|‘6 values updated in the db’            |
|SE          |silver_eel|‘ 2 new values inserted in the database’|
|SE          |silver_eel|‘1 values updated in the db’            |
|SE          |silver_eel|‘ 3 new values inserted in the database’|
|SE          |silver_eel|‘2 values updated in the db’            |
  

## Annex 4 
  
|log_cou_code|log_data      |log_message                              |
|------------|--------------|-----------------------------------------|
|SE          |catch_landings|‘19 values updated in the db’            |
|SE          |catch_landings|‘ 36 new values inserted in the database’|
|SE          |catch_landings|‘ 38 new values inserted in the database’|


## Annex 5 

## Annex 6 
add eel_comment = assisted migration for all existing_kept data (directly with an sql query)
  
## Annex 7 
  remove all preexisting data (put eel_qal_id = 21 and eel_qal_comment="all data were updated...") with an sql query

## Annex 8 

## Annex 9 

## Annex 10 

# Sl
 
 I there any data for Solvenia ?
 
# TN
Annex 4 (by GFCM) 6 new values are added.

# TR

Annex 4  (by GFCM): data inserted
  

Annex 5  (by GFCM): data integrated.

Annex 12 (by GFCM)
 
 

 
