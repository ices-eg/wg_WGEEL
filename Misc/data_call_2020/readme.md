# INFORMATIONS ABOUT DATA CALL INTEGRATION 2020

_GT1 subgroup_

----------------------------------


# General notes

General notes (feedback on datacall for next year are there : https://github.com/ices-eg/wg_WGEEL/issues/129

**CHECK** you need to check, **MISSING** corresponds to missing data, **IMPORTANT NOTE** is a big change we have brought to your data.
**TODO** something to be done at series level


**TODO** Stations all series ... manually


# Series integration 


---------------------------

 
## BE (Belgium)
(HILAIRE)

Files sent to ICES 26/08
Add a new participants as main assessor: Kristof Vlietinck

### annex 1
* new series: nothing
* new dataseries
  * VeAmGY data from 2010 to 2016 not taken into account (monitoring started in 2017)
  * all new dataseries qal_id set to 3 because very impacted by covid crisis
  * 3 rows integrated
* new biometry: no data
* modified series
  * updates the location of YserG which was in sea in front of Dunkerque
  * update of datasource
  * updates units and description of VeAmGY
  * 3 values updated in the db
* modified dataseries
  * updated value for MeusY (incomplete value in 2019)
  * 1 value updated


### annex 2
Empty

### annex 3
Empty

### annex 4
* new_data:
  * mostly NP for past data
  * values for YS in BE_Sche till 2005 in F. Same value for all years, not official data but rough estimate. qal_id=4
  * data provider has deleted all NP for C, T and MO habitats, but they correspond to NP: we should tell him to leave this next year
  * 231 new values inserted in the database
* updated data: none

### annex 5
* new data:
  * mostly NP for past data
  * old estimates in BE_Meus and BE_Sche for Y. removed NP in eel_missavalueequal since a value was provided. qal_id=4
  * data provider has deleted all NP for C, T and MO habitats, but they correspond to NP: we should tell him to leave this next year
  * 250 new values inserted in the database
* updated values:
  * 2 values updated in the db


### annex 6
none

### annex 7
* new data
  * release only provided in kg. Asked for numbers to the data provider. conversion 3000eels/kg according to data provider
  * 54 new values inserted in the database
* updated data: none

### annex 8
none

---------------------------


## DE (Germany) 
(HILAIRE)

*The data call files we be late by one week, mail explaining why (some landers didn't answer ... files incomplete)
Files sent 28/08 to ICES. Data on the server*

### annex 1
* new dataseries
  * WisWGY, WisWGY, WaSEY, WaSG, BrokGY, LangGY, VerlGY, WaSEY qal_id 4 given comments
  * DoElY, DoFpY, EmsBGY, EmsHG, FarpGY, WaSEY, WaSG qal_id 1
  * Not considered (series not started or ended): HHKGY after 2013, BrokGY before 2012, EmsBGY before 2013, EmsHG before 2014, LangGY before 2015, WaSEY before 2015, WaSG before 2015, HoSGY other than 2010
  * 14 new values inserted in the database
* modified series:
  * update of datasource
  * update of coordinates of EmsG which was too far in the West
* updated dataseries
  * 7 values updates corresponding to finalization of data (3 LangGY, 2 BrokGY, 1 EmsBGY, 1 VerlGY). qal_id 1
  * 7 values updated in the db
* biometry: nothing

### annex 2
none

### annex 3
* new series: none
* modified series:
  * only datasource updated (WarS)
  * 1 values updated in the db
* new dataseries
  * qal_id set to 1 given comment (WarS)
  * 1 new values inserted in the database
* modified data series
  * update of value for 2019 qal_id=1 (WarS)
  * 1 values updated in the db
* biometry: nothing


### annex 4
* new data:
  * removed some duplicates DE_Warn Y and S from 2017 to 2019 due to bug in template filling procedure (chech with Lasse Marohn)
  * 1862 new values inserted in the database
* updated data : nothing

### annex 5
* new data:
  * mostly NP or NC for old data
  * a few data for DE_Warn from 2017 to 2019, eel_qal_id=4 given comments
  * 1846 new values inserted in the database
* updated data: nothing

### annex 6
nothing 

### annex 7
* new data:
  * 56 new values inserted in the database
* updated data:
  * mostly lfs_code correction, a few values corrections and some rows deletion
  * 135 values updated in the db

### annex 8
* new_data
  * 2 values, eel_qal_id=4 (provisional data)
  * 2 new values inserted in the database
* duplicates:
  * update of some values which were in tonnes instead of kg
  * For duplicates 4 values replaced in the database (old values kept with code eel_qal_id=20) / 0 values not replaced (values from current datacall stored with code eel_qal_id 20)


---------------------------

 ## DK (Denmark) 

*Received 28/08 in ICES submission*

CEDRIC

### annex 1

* new series : no new series

* modified series : 7 values updated in the db

* new dataseries : 10

* biometry = nothing


### annex 2

### annex 3

### annex 4

(Sukran)

### annex 5

### annex 6

### annex 7

### annex 8



---------------------------

 
## EE (Estonia) 
(HILAIRE)
*Files sent to ICES  in time*

### annex 1
none 
 
### annex 2
none
 
### annex 3
none
 
### annex 4
* new_data:
  * 2 news values for 2019, NP for historical data
  * 424 new values inserted in the database
* updated values: none

### annex 5
* new_data:
 * 2 news values for 2019, NP for historical data
 * 442 new values inserted in the database
* updated values: none
 
### annex 6
none
 
### annex 7
* newdata: 4 new values inserted in the database
* updated data: 16 values updated in the db
 
### annex 8
none

---------------------------

 
## ES (Spain) 

*Mail from ICES not received, working on it. Recruitment file sent straight by Esti.*

### annex 1

* New series => MiSpY 1, qal_id 0

*TODO* update ccm catchment

* Updated series => 5 values updated in the db
* updated series (second round by Esti) 4 values updated in the db

* New dataseries => 9

* Modified dataseries => added comments, all values in Oria changed. 8 values changed

* No biometry.





### annex 2

***Esti working on the file now. Don't touch Spain***

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

 
## FI (Finland) 
(HILAIRE)
Files sent to ICES in time


### annex 1
none

### annex 2
empty file

### annex 3
empty file


### annex 4
* new data
  * I remove two lines that were provided as NC for Y and S while data were provided for NS
* updated_data:
  * 2 updated values
### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## FR (France) 

(CEDRIC)

*Data call sent in time
Updates expected for other landings (mediterranean lagoons) ... but in the end those landings were already there so there is nothing to change.*


### annex 1

* metadata : The method to estimate the index of the GiScG serie was changed this year then it's necessary to delete the 1992 and 1993 lines as the protocol was changed in 1994 and the data before this change were not used in the new method.

* One new series : sousGY 2013:2019, does not qualify for entry : too short.  1 new values inserted in the database

* series : 8 values updated in the db, Updates in GiScG series

* dataseries 13 values inserted / 28 values updated in the db / many doubtfull quality (4) not finished or partly impacted by covid

* new biometry 55 new values inserted in the database


**TODO** change ccm wso_id for Frémur, and find the one for SOUSTONS

### annex 2

* metadata: New series were added and the method used to estimate the index was changed for the series: BreY, SeiY, SeNY and SouY

* new series 6 new series integrated

OrnY	Orne electrofishing survey

SciY	Scie electrofishing survey

TouY	Touques electrofishing survey

VirY	VirY electrofishing survey

YerY	YerY electrofishing survey

AdoY	Adour elecrofishing survey

* modified series => 
5 values 

* new dataseries =>  59 new values inserted in the database

* updated dataseries => 42 values updated in the db

* new biometry =>  59 new values inserted in the database



### annex 3

metadata : 2018 Biometry data of the FreS serie have been updated and put into the new_biometry sheet; For 2019 SouS serie, estimated could not be made due to exceptional climatic conditions; Biometry data of the SeNS serie have been updated and put into the new_biometry sheet

* new series : no new series

* updated series : 1 value. Comment updated for Vilaine Silver.
 
* new data series : one missing data and all other data provisional (qal_id 4).  One data complete.

* updated data series : 6 new values integrated in the database

* modified data series : 6 provisional data set to qal_id = 4, 10 values updated in the db

* new biometry :  4 new values inserted in the database

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## GB (Great Britain) 

(CEDRIC)

*Data call sent to ICES in time.*
**DONE** Change series names and replace E (Elver) with GY or G.

### annex 1


* new series
changed series names as following, I've only kept E for two series where you already have GY and Y, these two were already in the database.
I've made a link between stage in the table and name, so RodE for yellow eel becomes RodY

  * BeeGY	Beeleigh_Elver_>80mm
  * BeeY	Beeleigh_Yellow_>120mm
  * NmiGY	New Mills Elvers/Yellow (>120mm)
  * OatY	Oath Lock Yellow (>120mm)
  * MillY	Thames - Hogsmill  Middle Mill
  * RodY	Thames - Roding
  * MolY	Thames-Molesey weir
  * MerY	Thames - Wandle - Merton Abbey Mills

Changed location to Colleraine for the Bann

Decision for inclusion new, series

| ser_qal_id 	| ser_qal_comment 	|            	|
|------------	|-----------------	|------------	|
| BeeGY      	| 0               	| < 10 years 	|
| BeeY       	| 0               	| < 10 years 	|
| NmiGY      	| 1               	| > 10 years 	|
| OatY       	| 0               	| < 10 years 	|
| MillY      	| 0               	| < 10 years 	|
| RodY       	| 1               	| > 10 years 	|
| MolY       	| 1               	| > 10 years 	|
| MerY       	| 0               	| 9 years    	|
 
 8 new values inserted in the database
 
 * modified series => 12 values updated in the db
 
 *  new dataseries => 94 new values inserted in the database, Qal_id set to 4 for series to be updated, 0 for missing data, removed lines automatically generated saying "no data".
 
 * modified dataseries => 12 values updated in the db
 
 * new biometry =>  110 new values inserted in the database
 
 
 
 --------------------------------------------------------------
 
 
### annex 2

* Updated coordinates for series KilY

```sql
BEGIN;
UPDATE datawg.t_series_ser SET geom=ST_SETSRID(ST_MakePoint(-5.6338,54.26285),4326) WHERE ser_nameshort='KilY';
UPDATE datawg.t_series_ser SET (ser_x,ser_y)=(st_x(geom),st_y(geom)) WHERE ser_nameshort = 'KilY';
COMMIT;
```
* no new series

* modified series  44 values updated in the db

* new dataseries  312 new values inserted in the database

* modified dataseries 638

*CHECK* new data series medY I have two values for 2001, none for 2000, I put 0 for 2000 (transformed 2001 in 2000) OK ?
=> ANSWER : no don't add a line for 2000 DELETE THE LINE

*CHECK* remove data with delete this line or keep value ? Answer remove

```sql
UPDATE datawg.t_dataseries_das SET (das_value,das_qal_id)=(NULL,0) WHERE das_ser_id=271 AND das_year=2008;
UPDATE datawg.t_dataseries_das set(das_value,das_effort,das_qal_id)=(NULL,NULL, 0) WHERE das_value=0 AND das_year=2000 AND das_ser_id=271;
```

*  new biometry  73 new values inserted in the database

### annex 3

* new series : FowS;LevS, added ccm basins. Set to qal_id 1 by default (no information indicating otherwise).

edition : coordinates for the strangford silver eel trap, again on the Killough river.
```sql
BEGIN;
UPDATE datawg.t_series_ser SET geom=ST_SETSRID(ST_MakePoint(-5.6338,54.26285),4326) WHERE ser_nameshort='StrS';
UPDATE datawg.t_series_ser SET (ser_x,ser_y)=(st_x(geom),st_y(geom)) WHERE ser_nameshort = 'StrS';
COMMIT;
```
Error: Failed to fetch row: ERROR:  duplicate key value violates unique constraint "unique_name_short"
DETAIL:  Key (ser_nameshort)=(FowS) already exists.



* updated series : Baddoch Burn

* new data series : das_qal_id set to 4 when incomplete year or flooding event otherwise das_qal_id=1 .  29 new values inserted in the database

* new biometry :  10 new values inserted in the database.


### annex 4

### annex 5

### annex 6

### annex 7

### annex 8



---------------------------

 
## GR (Greece) 

*Data call sent to ICES in time*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## HR (Croatia) 
(HILAIRE)
*File sent to ICES 25/08.*

### annex 1
none

### annex 2
none

### annex 3
none

### annex 4
* new data:
  * 2 news values for 2018 and 2019
  * NP and NC for historical data
  * 247 new values inserted in the database
* udpated data: none  

### annex 5
* new data:
  * only NP
  * 252 new values inserted in the database
* updated data: none

### annex 6
none

### annex 7
none

### annex 8
none



---------------------------
 
## IE (Ireland) 

Data call sent to ICES in time, one update file sent straight to Cédric and put to the wgeel folder.

### annex 1

Importing file from new version by Russell

***CHECK*** There is a difference between ccm catchment and series position for InagGY, could you check ?
OK was wrong
https://www.google.fr/maps/place/52%C2%B056'24.9%22N+9%C2%B018'04.2%22W/@52.9324866,-9.3216336,13.88z/data=!4m5!3m4!1s0x0:0x0!8m2!3d52.94025!4d-9.3011667

```sql
UPDATE datawg.t_series_ser SET geom=ST_SETSRID(ST_MakePoint(-9.301167,52.940250),4326) WHERE ser_nameshort='InagGY';
UPDATE datawg.t_series_ser SET (ser_x,ser_y)=(st_x(geom),st_y(geom)) WHERE ser_nameshort = 'InagGY';
```

Corrected now


* empty lines in new_data tab => removed

* modified series => 4 values updated in the db

* new dataseries =>  10 new values inserted in the database

* new biometries => I had to find and drop the empty lines,  12 new values inserted in the database

### annex 2

* No new series

* new dataseries  4 new values inserted in the database

* new biometries 4 new rows inserted 


### annex 3

Ciara and Russell

> Data from MI & ESB/NUIG. The Burrishoole silver sex ratio data needs to be replaced for the full time series, 1971 - 2019.  The data here is % male. I will email you the % female. Or you can subtract the % male from 100 to make % Female. 
>> DONE

```sql
UPDATE  datawg.t_biometry_series_bis SET bio_sex_ratio = 100-bio_sex_ratio WHERE bis_ser_id = 230 AND bio_sex_ratio IS NOT NULL; --36
```

|bio_year|bio_sex_ratio|
|--------|-------------|
|1971||
|1972||
|1973||
|1974||
|1975||
|1976|42.7|
|1977||
|1978||
|1979|36.5|
|1980||
|1981||
|1982||
|1983||
|1984|45|
|1985|59.3|
|1986|60.8|
|1987|64.6|
|1988|62.7|
|1989||
|1990|50|
|1991|69.3|
|1992|54.7|
|1993|83.3|
|1994|75.5|
|1995|71.4|
|1996|90.6|
|1997|75.3|
|1998|58.7|
|1999|65.4|
|2000|62.5|
|2001|73.4|
|2002|61.3|
|2003|55.2|
|2004|70.9|
|2005|71.9|
|2006|77|
|2007|60.1|
|2008|76.2|
|2009|65.1|
|2010|64.5|
|2011|59.9|
|2012|54.8|
|2013|54.3|
|2014|67.8|
|2015|55.3|
|2016|63.2|
|2017|65.3|
|2018|59.2|


> Also, delete the value for 1996 (9.4%).
>> OK done

```sql
DELETE FROM datawg.t_biometry_series_bis WHERE bio_year=1996 AND bis_ser_id = 230 --1
```

> Why no sample size in the biometry tab? 
>> CEDRIC : https://github.com/ices-eg/wg_WGEEL/issues/144
 
> There are no units in the data tabs, KilS is kg and BurS is numbers. 
>> CEDRIC : The units should be set in the series tab (you don't change units in the middle of one series. All is fine.
 
 
> For KilS biometry, there was no updated biometry tab so we created one. This means there is dupication between the Updated Sheet and the New Data sheet.
>> CEDRIC : I'll copy them back in new biometries and the shiny will handle duplicates.


* series no new seres

* updated series no update

* new dataseries : 2 values

* modified dataseries : 14 values

* new biometry : 2 values

 

### annex 4

> We have decided to delete any duplicate data, and for habitats where there was never a fishery, to insert NP. For transitional waters where there was a fishery, but the landings were reported combined with freshwater, we have inserted NP. There may be some duplication here between data in the Updated_Data tab and the New_Data tab

DELETE records for stage AL 


```sql
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment)=
('20',coalesce(eel_qal_comment,'')||'national assessor asks for deletion')  
WHERE eel_cou_code='IE' AND eel_lfs_code='AL' AND eel_typ_id=4 AND eel_qal_id IN (1,2,4);--48
```

* new data  => 756 lines

* Updated data => 648 values updated in the db



### annex 5

* 1440 new values inserted in the database
 
* 96 updated values 

### annex 6

 394 new values inserted in the database
 
 ***note stage GY accepted for assisted migration***

### annex 7

### annex 8

---------------------------

 
## IT (Italy) 

*Nothing yet*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8




 
## LV (Latvia) 

(Tessa)
*Data call sent to ICES in time*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## MA (Morocco) 

*No data, check with Fatima*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8
---------------------------

 
## NO (Norway) 

*No data yet*

### annex 1

### annex 2

### annex 3

### annex 4
*221 new values inserted in the database* proceed
### annex 5

### annex 6

### annex 7

### annex 8


## NL (Netherlands) 

*First to answer the datacall*

### annex 1

No new series 

* modified series = > 5 values updated in the db

* new dataseries => 5 new values

* biometry => No biometry

### annex 2

* new series As stated in the excel sheets, series should end with the name of the stage, I have changed accordingly.

|nameshort| namelong                  |
|-------- |---------------------------|
| DeBY   	| Den Burg fyke net survey 	|
| IjsY   	| FYMA_IJSSELMEER          	|
| MarY   	| FYMA_MARKERMEER          	|
| IJsFVY 	| FYOE-IJM-Veg             	|
| MmFVY  	| FYOE-MM-Veg              	|
| IJsFVY 	| FYOE-IJM-Rock            	|
| MmFRY  	| FYOE-MM-Rock             	|

 4 new values inserted in the database

* No updated series

* New dataseries  62 new values inserted in the database

* Modified dataseries 105 values updated in the db

* New biometries 113 values


### annex 3

### annex 4

* new data 128 new values inserted in the database

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

## No (Norway)

### annex 1

new dataseries 1

modified dataseries 1

new biometry 1

### annex 2

new dataseries 1

new biometry 1

### annex 3

### annex 4

Done by Sukran

### annex 5

### annex 6

### annex 7

### annex 8






---------------------------

## PL (Poland) 
(HILAIRE)

*Data call sent to ICES in time*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

## PT (Portugal) 

*Data call sent to ICES in time*

### annex 1

* Modified series => 1 value

* new dataseries => 5

* Modified dataseries => 4 values

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

 
## SE (Sweden) 

*Data call sent to ICES in time*
New data submitted by Josefin 31/08

We have completed those files now, please use the attached. The info below has been added to the meta data tabs.

Annex 2: No data with high enough quality in the end, so this file is essentially the same as the one submitted before.
Annex 4: Commercial landings for 2019 for inland and east.
Annex 6: Other landings kg and n for 2019.
Annex 7: restocked and assisted for 2019 (T&T not ready to report). Restocked for 2018 (was not reported last year).

### annex 1

* new series => no new series

* Modified series => 10 values updated in the db

* new dataseries => 10 new values inserted in the database

* new biometry =>  121 new values inserted in the database

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## TN (Tunisia) 

*Nothing yet*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## TR (Turkey) 

*proceed Annex 4*

### annex 1
*n
### annex 2

### annex 3

### annex 4
*proceed*

### annex 5

### annex 6

### annex 7

### annex 8


 



