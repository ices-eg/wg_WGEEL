# INFORMATIONS ABOUT DATA CALL INTEGRATION 2019

_Cédric Briand and Jan-Dag Pohlmann_

----------------------------------


# General notes

Some files are in WGEEL accession, the rest have been collected by Jan Dag

https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment.xlsx
=> nothing, don't know what country it is.

* *NOTE*  For recruitment check that series now > 10 years are included
* *NOTE*  There is nothing in our sheets to enter data for the station table, for next year insert a sheet with fields <br/>
			ref.tr_station( "tblCodeID",<br/>
			"Station_Code",<br/>
			"Country",--'country responsible of the data collection ?'<br/> 
			"Organisation",<br/>
			"Station_Name",<br/>
			"WLTYP",--'Water and land station types ';<br/> 
			"Lat",<br/>
			"Lon",<br/>
			"StartYear",<br/>
			"EndYear",<br/>
			"PURPM",'Purpose of monitoring http://vocab.ices.dk/?ref=1399'<br/>
			"Notes") <br/>
* *NOTE*  The reference list for emu is wrong in landings original file, it should not integrate outside emu, there is a script to generate referential tables, run it to provide the right references during wgeel
* *NOTE*  INTEGRATION PROCEDURE I've checked, if you don't intend to keep any data in duplicates excel file you don't need to put a code in `eel_qal_id` weel you can but it will be replace by `qualify_code (19)` taken from `global.R`. In fact you only need to qualify the lines that you want (`keep_new_value=TRUE`).


# Series integration 

## GREECE

Recruitment
https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment_GR.xlsx
=> No data

## LITHUANIA

Recruitment => No data 

## DENMARK

### Recruitment 

* *MISSING*  I need png 300x225px for all Danish stations to illustrate in shiny.  

 **=> new series Hellebaekken**


* *CHECK* I guess the `ser_uni_cod` is number (nr). It was left blank in the description file.
* *CHECK* My guess is that the trap is in transitional waters is it TRUE ?
* *CHECK*  The organisation doing the monitoring is DTU Aqua ? this is necessary for the station table for ICES
* *NOTE*  This series will be named hell :-) !		
* *NOTE* Cannot use the effort as it stands, it should be a numeric, with effort, so I'm putting the season monitored which never changes (total season 1 april-1 november) into the series description.
* *CHECK* Biometry 70-100 mm is a text not a numeric what should I do ?

  
  
NorsA Klet Sle


*  *CHECK* description edited : Average densities (eel/m2) of pigmented glas eel and yellow eel (elvers)  from three electro surveys from may to august . The data represent in general 3 electrofishing surveys per season. Some years only one or two  electrofishing surveys have been possible. The max density is usally found in June/July. 
*  *CHECK* locationdescription edited : Electrofishing in a small stream. 
*  *CHECK* No new data ? 


			
** Harte **
OK


### Landings

The values `DK_outside_emu` should be replace by `DK_total`, it was decided to remove all outside emu data,
corrected uppercase hty, added cou_code, removed area from freshwater, no duplicates

```
column <eel_emu_nameshort>, line <4>, value <DK_outside_emu> is wrong 
column <eel_emu_nameshort>, line <5>, value <DK_outside_emu> is wrong 
column <eel_emu_nameshort>, line <6>, value <DK_outside_emu> is wrong 
column <eel_cou_code>, missing values line 1 
 column <eel_cou_code>, missing values line 2 
 column <eel_cou_code>, missing values line 3 
 column <eel_cou_code>, missing values line 4 
 column <eel_cou_code>, missing values line 5 
 column <eel_cou_code>, missing values line 6 
column <eel_hty_code>, line <4>, value <c> is wrong 
 column <eel_hty_code>, line <5>, value <c> is wrong 
 column <eel_hty_code>, line <6>, value <c> is wrong 
 line <1>, there should not be any area divsion in freshwater 
 line <2>, there should not be any area divsion in freshwater 
 line <3>, there should not be any area divsion in freshwater
 ```
 
###  Release
 
 ```
 release 
column <eel_emu_nameshort>, missing values line 4 
 column <eel_emu_nameshort>, missing values line 5 
 column <eel_emu_nameshort>, missing values line 6 
line <1>, there should not be any area divsion in freshwater 
 line <2>, there should not be any area divsion in freshwater 
 line <3>, there should not be any area divsion in freshwater 
 ```
 
* *NOTE* There are 3 lines for Dk_Inla but only one EMU, you cannot have area division in Freshwater, 
 so I've added the 3 lines.
 
 
## SPAIN
 
### Landings

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2014 | 0 | 0 | 1  |
| 2015 | 0 | 0 | 1  |
| 2016 | 0 | 0 | 1  |
| 2017 | 0 | 1 | 1  |
| 2018 | 1 | 0 | 3  |
| 2019 | 0 | 0 | 12 |
 
* *NOTE*  MARIA or Esti praise for you for spotting the wrong `eel_area_division` the best was to remove those lines
 and re-inserting again.
 
 
```sql
  BEGIN;
DELETE FROM datawg.t_eelstock_eel  where eel_area_division in ('37.1.2','37.1.3') and eel_cou_code='ES';
COMMIT;
```
* *NOTE* Value for datacall 2019 was dc_2019 => corrected

```
13 new values inserted in the database
For duplicates 6 values replaced in the database (old values kept with code eel_qal_id=19),
            0 values not replaced (values from current datacall stored with code eel_qal_id 19)
```

### Release
 
* *NOTE* All names should be `release_n`, it's later on that the script will split up the two columns `release_n` and `release_kg`
* *CHECK* You have values for 2020 I this is obviously a mistake, I changed to 2019 correct ?
 
| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 6    | 0         | 0         |
| 2019 | 10   | 0         | 0         |

* *NOTE* The last line is a duplicate fom previous line but with values wrong (57 kg glass eel is about 17000 not 170000 + this was the 2020 line ... I'm dropping this line.  

```
 16 new values inserted in the database
 ```
 * *MISSING* You have not submitted aquaculture but you have some no ?
 
 
## ESTONIA

### Landings

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 6    | 0         | 0         |


### Releases

* *NOTE* `Removed eel_missvaluequal`

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 2    | 0         | 0         |

### Aquaculture
 
No linges


## FINLAND

### Landings

* *NOTE* Changed emu name to FI_total otherwise it's creating duplicates
* *NOTE* Removed wrong entries NC where no data, changed 2018 value in recreational landings to ND (the alternative could have been not to report any data.
* **CHECK** Changed type `com_landings` to `other_landings`in Landings in Freshwater with comment as "Trap and transport" fish from freshwater to the sea in one location, otherwise 0 kg. I've checked the value in landings in Freshwater from 2014 to 2018 corresponding to those lines. It was 0 for 2014 and then NULL and marked either as `not collected` or `not reported` or zero. So there will not be any duplicates for those data and these line will stay in the database. I think it's OK but please check.
* *NOTE*  When checking the duplicates, there is no change in the data, so I will not update the database. You didn't have to report data that were already in, next year we will again provide you the data as they are in the database, please use that to check and only ask for corrections. The table reports that there is no data in 2018 though we will integrate one line with ND.
 
 | year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2008 | 0 | 0 | 4 |
| 2009 | 0 | 0 | 1 |
| 2010 | 0 | 0 | 4 |
| 2011 | 0 | 0 | 1 |
| 2012 | 0 | 0 | 4 |
| 2013 | 0 | 0 | 1 |
| 2014 | 1 | 0 | 3 |
| 2015 | 1 | 0 | 1 |
| 2016 | 1 | 0 | 1 |
| 2017 | 1 | 0 | 1 |

```
For duplicates 0 values replaced in the database (old values kept with code eel_qal_id=19),
36 values not replaced (values from current datacall stored with code eel_qal_id 19)

For New 8 new values inserted in the database

```


### Release

TODO


### Aquaculture

TODO

### Recruitment

No recruitment

## PORTUGAL

### landings

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 1974  | 0 | 1 | 0 |
| 1975 | 0 | 1 | 0 |
| 1976 | 0 | 1 | 0 |
| 1977 | 0 | 1 | 0 |
| 1978 | 0 | 1 | 0 |
| 1979 | 0 | 1 | 0 |
| 1980 | 0 | 1 | 0 |
| 1981 | 0 | 1 | 0 |
| 1982 | 0 | 1 | 0 |
| 1983 | 0 | 1 | 0 |

### Recruitment

 * Mond 

**MISSING** Please provide the effort (in number of days samples per year); Check I put 6 in 2018 and 7 in 2019 and I had 5 in 1989.

biometry integratd thanks !

* MiPo

**MISSING** Recruitment series of total catch. I know it's the same as Portugese landings in the Minho so I've used this file, please next year could you provide both ?

*NOTE*  The value from 2017 has increased from 2094 => 2178

**CHECK** Comment is  :"Glass eel fishery (total landings) in the River Minho. There has been a diminution in effort as the fishery used to be permitted from November to April before 2006/2007. It has gradually been reduced to the 1st February." 

*Is that still true, what is the current fishing season ? => please provide the right expertise on that.*

**CHECK** Location is  : "Glass eel commercial fishery in the Minho. The Minho forms the border between Spain and Portugal. It is the only place in Portugal where a glass eel fishery is authorized. Fishing takes place in the tidal part of the estuary using Tela net which are not operative when the flow is high."


## SWEDEN

### landings

* **CHECK** No value is given for the area division, supposably since it cannot be clearly distiguished (i.e. EMUs overlap with >1 area divisions). Correct? In the old data series, area divisions are given though... 

### releases

* **CHECK** In releases, GEE are reported. For those no kg estimate should be reported. Also, one of the kg values is reported as 0, which doesn't make sense if there is a number. How does T&T apply to glass eels?   

### recruitment

**MISSING** I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email.

SERIES INFO

I have modified your comments so please check :

* Dala 

**CHECK** Comment : "Ascending yellow eels of about 40 cm caught in an eel pass placed close to a hydro power complex. This series started in 1951."  
**CHECK** Ser_location_description Hydro power station 10 km from the river mouth, this site is the farthest site into the Baltic
       
* Gota 

**CHECK** Comment: "Operated since 1900, this series is the longest available to the working group
Missing years 1995, 1998 to 2001, 2010,2011 (fish pass rebuilt in 2010 2011). The station collects ascending yellow eels of different sizes caught in an eel pass placed close to a hydro power station."  
       *NOTE* Ser_location_description updated
       
* Kavl 

 **CHECK** location : "Near the Øresund (Sound) strait, outlet of Lake Vombsjön 45 km from the sea."  
**CHECK** comment : Ascending small eels caught in an eel pass.   

* Laga  

 **CHECK** location : Swedish west coast, hydropower station ca 10 km from the sea.  
**CHECK** comment : Ascending small eels caught in an eel pass at a hydro power station. Though classified as a yellow eel series, there is always a high percentage of YOY elvers from this site.
         
* Morr  

**CHECK** location : Station located on the Mörrumån river flowing to the southern coast of Sweden, the station is quite far upstream the river.   
**CHECK** comment : Ascending yellow eels at a hydro power station. The series is complete since 1960.
          
* Mota   

 **CHECK**  location  Eel pass located at a hydro power station near the outlet of Lake Vättern, second largest lake by surface area in Sweden. This lake is flowing into the Baltic about a 100 km south from Stockholm.     
**CHECK** comment :  As this site is both far upstream and far into the Baltic, ascending yellow eels are quite large (30-40) cm. This series is one of the longest series available to wgeel, with a complete series dating back to 1942.
           
* Ronn    

There was a mistake, the trap was located in Ronne Island... In Danemark. OK this is now corrected. I guess it's the same site for both upstream and downstream migration that I've found in one of your report.   
          
**CHECK** location : Rönnemölla (55°56'40.69"N, 13°22'37.44"E) is a mill including a small hydroelectric power plant, located in Rönne å River (catchment area: 1896.6 km²), 6.5 km downstream of the outflow of lake Ringsjön.  The river flows to southern Kattegat.  
**CHECK** comment : The trap has been operated since 1946,  with 9 missing years between 1988 et 1997. It collects mostly small eels. There have been several problems with both placing and maintenance of this eel pass situated at a hydro power dam.
           
* Ring   

  **CHECK** location : "The Ringhals nuclear power plant is located on the Swedish west coast in the Kattegat. This site is located at the coast. The monitoring takes place near the intake of cooling water to the nuclear power plant.    
**CHECK** comment : 'The Ringhals series consists of transparent glass eel. The time of arrival of the glass eels to the sampling site varies between years, probably as a consequence of hydrographical conditions, but the peak in abundance normally occurred in late March to early April. Abundance has decreased by 96% if the recent years are compared to the peak in 1981-1983. From 2012 the series has been corrected and now only concerns glass eel collected during March and April (weeks 9-18).
			The sampling at Ringhals is performed twice weekly in February-April, using a modified Isaacs-Kidd Midwater trawl (IKMT). The trawl is fixed in the current of incoming cooling water, fishing passively during entire nights. Sampling is depending on the operation of the power plant and changes in the strength of the current may occur so data are corrected for variations in water flow.'

* Visk    

**CHECK** location The Viskan series is collected at 4 eel passes situated at an overflow dam that regulate river Viskan. The dam is located at the the very shoreline (250 m from the sea). In River Viskan flows to the Swedish West Coast.  
**CHECK** comment Most eels are young-of-the-year recruits, i.e. originates from glass eels arriving at the coast in the same year. The Viskan has been monitored since 1972.
   			         
* YFS2 

**CHECK** comment is  "Skagerrak-KattegatCatch of glass eels by a modified Methot–Isaacs–Kidd Midwater trawl (MIKT) in the Skagerrak-Kattegat. Data expressed as total numbers per hour of haul. No sampling in 2011 due to technical problems".  
*NOTE* Ser_location_description updated according to your data 


RECRUITMENT SERIES 

=> OK everyhting has been updated and checked twice, I had a temporary value for Gota Alv last year, can you confirm it's still 20 ? What happened this year for the pass not be opened ?

BIOMETRIC DATA

There is only one line , I guess it's not done ?

## Tunisia

### landings

* *NOTE* country code changed to TN instead of TUN


## UK

### landings

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 27 | 3 | 2 |
| 2019 | 42 | 0 | 0 |
 
* *NOTE* several duplicates were entered were the comment basically changed from "preliminary data" to "confirmed data" 
* *NOTE* In some EMUs for commercial fisheries there was a comment adressing recreational catch & release fisheries. The comment was edited slightly to avoid confusion about "commercial catch and release":)
* *NOTE* Aquaculture was not integrated since the database doesn't allow for sheets with no values at all. This should be adressed in general during WGEEL, we need to agree on a working practice concerning no data, 0 values etc.

### Recruitment

biometry tab => OK
updating the series
  * Bann updated 2018 inserted 2019 it's looow
  * SEEA updated 2018 inserted 2019
  **CHECK** I have a series in tons, I'm **ignoring** the change I see the series metadata are now in kg and that the series is reported in kg
  * Girn updated 2018 ( no data for 2019 yet
  * ShiM data as of 13 Aug 2018 / updated 2019 129 => 985 
  * ShiF data as of 13th Aug 2018 / updated 2019 989>129  
  **CHECK** Could you check there has been an inversion in two series when compared to last year. So there is a least one mistake. I put the two series with qal_id 4
  * stra 349 inserted 2019 by Derek Evans


Series info => thanks for the updated description, it's in  !
* **MISSING** I have no data for sites Grey (which is now an official series as > 10 years), BroG (8 years), BeeG (11 years), FlaE (10 years), FlaG ...






  
  
  
  
  

 
