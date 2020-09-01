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
release only provided in kg. Asked for numbers to the data provider.

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
  * 

### annex 8

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

### annex 5

### annex 6

### annex 7

### annex 8



---------------------------

 
## EE (Estonia) 

*Files sent to ICES  in time*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8

---------------------------

 
## ES (Spain) 

*Mail from ICES not received, working on it. Recruitment file sent straight by Esti.*

### annex 1

* New series => MiSpY 1, qal_id 0

*TODO* update ccm catchment

* Updated series => 5 values updated in the db

* New dataseries => 9

* Modified dataseries => added comments, all values in Oria changed. 8 values changed

* No biometry.





### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

 
## FI (Finland) 

Files sent to ICES in time


### annex 1

### annex 2

### annex 3

### annex 4

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

*Data call sent to ICES in time.*
**TODO** Change series names and replace E (Elver) with GY or G.

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

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

 
## IE (Ireland) 

Data call sent to ICES in time, one update file sent straight to Cédric and put to the wgeel folder.

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

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

*File sent to ICES 25/08.*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

 
## LV (Latvia) 

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

### annex 5

### annex 6

### annex 7

### annex 8


## NL (Netherlands) 

*First to answer the datacall*

### annex 1

No new series 

modified series = > 5 values updated in the db

new dataseries => 5 new values

biometry => No biometry

### annex 2



### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


---------------------------

## PL (Poland) 

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

*Nothing yet, check with Sukran*

### annex 1

### annex 2

### annex 3

### annex 4

### annex 5

### annex 6

### annex 7

### annex 8


 



