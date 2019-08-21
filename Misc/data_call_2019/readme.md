# INFORMATIONS ABOUT DATA CALL INTEGRATION 2019

_Cédric Briand and Jan-Dag Pohlmann_

----------------------------------


# General notes

Some files are in WGEEL accession, the rest have been collected by Jan Dag. In this file *NOTE* means that we have done some work or change you need to be aware of but we think it's correct,
**CHECK** you need to check, **MISSING** corresponds to missing data, **IMPORTANT NOTE** is a big change we have brought to your data.

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
*  *CHECK* Rules for integration were currently 10 years. I think we should allow for long time series to be included even if shorter than 10 years. Discuss that within wgeel.

# Series integration 



---------------------------

 
## BELGIUM 

### recruitment

=> Missing file I need to update recruitment sites from Belgium (Yser and Meuse)

------------------------------------

## DENMARK

### Recruitment 

* *MISSING*  I need png 300x225px for all Danish stations to illustrate in shiny.  https://github.com/ices-eg/wg_WGEEL/issues/77


* new series Hellebaekken


  **CHECK** I guess the `ser_uni_cod` is number (nr). It was left blank in the description file.
  **CHECK** My guess is that the trap is in transitional waters is it TRUE ?
  **CHECK**  The organisation doing the monitoring is DTU Aqua ? this is necessary for the station table for ICES
   *NOTE*  This series will be named hell :-) !		
   *NOTE* Cannot use the effort as it stands, it should be a numeric, with effort, so I'm putting the season monitored which never changes (total season 1 april-1 november) into the series description.
   **CHECK** Biometry 70-100 mm is a text not a numeric what should I do ?

  
  
* NorsA Klet Sle


  **CHECK** description edited : Average densities (eel/m2) of pigmented glas eel and yellow eel (elvers)  from three electro surveys from may to august . The data represent in general 3 electrofishing surveys per season. Some years only one or two  electrofishing surveys have been possible. The max density is usally found in June/July. 
  **CHECK** locationdescription edited : Electrofishing in a small stream. 
  **CHECK** No new data ? 


			
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
 
-----------------------------
 

 
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

-----------------------------

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


-----------------------------

## FRANCE

### Landings

### releases

### recruitment

* OK for all series

*NOTE* What did we decide about the Soustons series ? 

**MISSING** No biometry sheet ?

TODO chech comment and location

**MISSING**  I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email.
https://github.com/ices-eg/wg_WGEEL/issues/77

-----------------------------------------------

## GERMANY

### recruitment

data uploaded on sharepoint 

### Landings

no updated data on landings was provided

### Releases

no update on releases was provided

### Aquaculture

data is delayed but will presumably provided for WGEEL

-----------------------------

## GREECE

Recruitment
https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment_GR.xlsx
=> No data OK

-----------------------------

## IRELAND

### Landings

**NOTE** No landings since not pertinent. Since files with no value at all cannot be integrated, nothing was integrated. Note to self: How should this be dealt with? 

### Releases

**Note** Same as landings

### Aquaculture

**Note** Same as landings
**Note** q_aqua_n is no longer used in the database

### Releases

###  Recruitment

Series info => Nothing

**MISSING**  I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email.
https://github.com/ices-eg/wg_WGEEL/issues/77

**MISSING**  The coordinates of the Irish Series are wrong https://github.com/ices-eg/wg_WGEEL/issues/49, and I may have trouble to exactly pinpoint the location of some of the traps. The reasons is that often coordinates have been provided with degree minutes second and that is not easy to convert. Below I took some time to figure out myself. But you will have to check. If it's wrong and you want to give me the coordinates, the easiest way is : https://www.lifewire.com/latitude-longitude-coordinates-google-maps-1683398, send me the coordinates in decimal degrees.

**MISSING**  Biometry of ascending eels. This is now necessary especially for mixed yellow / glass series.

* Erne  

   *NOTE* location : "The Erne at Ballyshannon, 6 km from the sea at the Cathaleen Fall Dam. "  
           
   *NOTE* comment : "Total trapping in kg glass eel + yellow. Full trapping of elvers on the Erne commenced in 1980. Some discrepancies in the time series came to light in 2009. The Erne elver dataset has now been double checked and the presented data has been agreed by DCAL and AFBINI, the ESB, NRFB and MI.  Any discrepancies were not major and the data trend and pattern has not changed. Full trapping of elvers took place on the Erne from 1980 onwards, before it was only partial. In 2011 the whole series corrected to include latest changes.  Traps were significantly upgraded in 2015.  3rd Trap inserted on opposite bank, catch reported as a comment." 
   
   **IMPORTANT NOTE** I have put `eel_qual_id` to 3 to all data before 1980. Is there another way (like was done for one of the French series where historical data were corrected for change in efficiency). This is a major change as we don't have that many series at that period.

  *NOTE* location coordinates 54.499848, -8.176306
  
  **CHECK** I have the figure for the third trap as a comment, was it updated in 2018 ?

* Liff   

   **CHECK** location : "Trap located on the first dam in river Liffey (Dublin, Islandbridge) at the tidal limit,  10 km from the sea."       
     
   **CHECK** coordinates Is it really there ? https://goo.gl/maps/8SvrJKbyPqD8r8L99 
   *NOTE Value updated.
		 
* Burr

   **CHECK** location "Trap located at Furnace at the tidal limit, at 3 km from the sea, on one of the outflow from lough Feeagh."
  
   *NOTE* Though you provided a new value for 2018 it not different from last year.
  
* Feal

   **MISSING** I have no idea where the trap is, help me please. Also provide a description of the trap (distance to the sea ...) and coordinates in decimal degree
   
   **CHECK** In the metadata you say that FEALE is trapping partial while it is currently classified as trapping total. I didn't change, will change if you can confirm that.
  
* Maig

   **MISSING** Though I have found the river, I have no idea where the trap is, help me please. Also provide a description of the trap (distance to the sea ...), and coordinates in decimal degree
  
  **MISSING**  Recruitment was not provided last year, please provide 2018 recruitment value.
  
* ShaA    

   *NOTE* Though you provided a new value for 2018 it not different from last year.
   
   **CHECK** location  : Ardnacrusha power station on the shannon, approximately 4 km from the tidal limit in the Shannon, on the western coast of Ireland.
   
   *NOTE* Updated coordinates of Parteen weir to here :    https://goo.gl/maps/f7nSYyDNPycg8TU28
  
* Shap
 
   *NOTE* Though you provided a new value for 2018 it not different from last year.
  
   **CHECK** location  : Parteen weir on the Shannon, approximately 16 km from the tidal limit. This is what I can do but you can probably do better.
   
   *NOTE* Updated coordinates of Parteen weir to here : https://goo.gl/maps/DfCg2PxXVyDz3G4QA
   
   *QUESTION* Ardnacrusha and Parteen weir are in fact on two separate branch of the Shannon. Is there a reason not to add the two series ?
   
-----------------------------

## ITALY

### Landings

**IMPORTANT NOTE** Duplicates could not be updated due to an error in the database, this needs to be solved by data group

### releases

**CHECK** Releases sheet was provided indicating ND. Since data is being collected andd could be provided at some point, this was not integrated

-----------------------------

## LATVIA

### Aquaculture

**CHECK** The comment in the aquaculture file says that aquaculture is solely for restocking. Thus it shouldn't have been reported and no data was integrated

-----------------------------

## LITHUANIA

### recruitment

Recruitment => No data OK

### releases

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2011 | 0 | 2 | 0 |
| 2012 | 0 | 1 | 1 |
| 2013 | 0 | 1 | 1 |
| 2014 | 0 | 1 | 1 |
| 2015 | 0 | 1 | 1 |
| 2016 | 0 | 1 | 1 |
| 2017 | 0 | 0 | 2 |

**CHECK** for most duplicates the number of stocked eels did not change but the mass in kg changed, is this correct?

### aquaculture

**CHECK** aquaculture uis restriced; yet, no data is provided after the data protection law was implemented - so is the previousely provided data public? In this case, if no new data is provided anyways, could the status be set to public

-----------------------------
   
## NETHERLANDS

### recruitment 

Thanks for providing all values, all recruitment values are very low!

* Katv OK

* Stel OK

* Lauw OK

* RhDO OK

* RhIj OK  

**MISSING** I need a description of the sampling site, and the sampling method on top of the actual comments, could you provide that to me. For location it's a description of the site where the sampling is taking place, I guess it's at the coast, at a particular location. What is the method used for haul, how the nets are placed retrieved...

**MISSING**  I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email.
https://github.com/ices-eg/wg_WGEEL/issues/77

**MISSING**  Biometry, no big deal, as those are only glass eel series.


------------------------------------


## NORWAY 

### recruitment

=> Missing file, I still need to udpate recruitment data for Imsa.

### Landings, Releases, Aquaculture

**CHECK** Nothing to report

-----------------------------

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

biometry integrated thanks !

* MiPo

**MISSING** I two pictures format png for this site, png 300x225px one of the gear used, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email.

**MISSING** Recruitment series of total catch. I know it's the same as Portugese landings in the Minho so I've used this file, please next year could you provide both ?

*NOTE*  The value from 2017 has increased from 2094 => 2178

**CHECK** Comment is  :"Glass eel fishery (total landings) in the River Minho. There has been a diminution in effort as the fishery used to be permitted from November to April before 2006/2007. It has gradually been reduced to the 1st February." 

*Is that still true, what is the current fishing season ? => please provide the right expertise on that.*

**CHECK** Location is  : "Glass eel commercial fishery in the Minho. The Minho forms the border between Spain and Portugal. It is the only place in Portugal where a glass eel fishery is authorized. Fishing takes place in the tidal part of the estuary using Tela net which are not operative when the flow is high."

* MiSc => new series

**MISSING** Please provide exact google coordinates for that site, you can  go to google maps, right click what's here, then click on the coordinates, once the new location appears on the right you can copy the coordinates in the following format
41.901412, -8.823340 (not with west and north...) or share a link with me. Since you said 5 km from the sea I've guessed the coordinates. https://www.lifewire.com/latitude-longitude-coordinates-google-maps-1683398

**CHECK** I need the name of the Organisation running that sampling. I guess it's Ciimar right ?

**NOTE** EMU names have changed, it's `ES_Minh` because this refers to the transboundary emu which is in country PT with name `ES_Minh`

**NOTE** Inserted biometry OK

**MISSING** I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email. https://github.com/ices-eg/wg_WGEEL/issues/77
(I have for Mondego, but not Minho catch and Minho Scientific catch)

-----------------------------
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
* **CHECK** You have values for 2020 I this is obviously a mistake, I changed to 2019 correct ?
 
| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 6    | 0         | 0         |
| 2019 | 10   | 0         | 0         |

* *NOTE* The last line is a duplicate fom previous line but with values wrong (57 kg glass eel is about 17000 not 170000 + this was the 2020 line ... I'm dropping this line.  
  
```
 16 new values inserted in the database
 ```
 * **MISSING** You have not submitted aquaculture but you have some no ?
 
 ### recruitment
 
TODO Guadaquivir (Data sent by Carlos Fernandez Delgado to finish integrating).

*NOTE* No biometry provided ... OK I'm really unsure of the interest of having those biometries for pure glass eel.

* Oria => new series

  *NOTE* You have provided the coordinates with -2.07 43.16 but what you have given is in fact a degree minute second coordinates.... I have corrected that.

  *NOTE* I have converted the Oria series to m3/s

  **CHECK** location :  'The Oria River is 77 km long, drains an area of 888 km2, and has a mean river flow of 25.7 m3 per second. It flows into the Bay of Biscay in the Basque country, on the Northern coast of Spain' 


  **CHECK** comment : 'Scientific sampling from a boat equipped with sieves. from 2005 - 2019, during Oct - Mar [missing 2008, 2012-2017] at the sampling point (1) in the estuary at new moon. There are statistically significant differences in depth, month and season on the density of GE. Thus, the value for GE density was predicted (glm) for each season in the highest values month/depth.' 
 
  *NOTE* For next year, please provide a measure of effort as number of days fished.
 
  *NOTE* This series will not be integrated in the final recruitment calculation as it is shorter than 10 years.
 
* Nalo OK
 
* MiSp  

  **CHECK**  Series is missing
 
* Albu  

  **CHECK** 2.6 for 2018, it is VERY VERY VERY low. The CPUE dropped by a factor 15, and the catch by a factor 125.
Since this is obviously a problem I have flagged both values with a 3 as quality (discarded). Please check.
 
* AlCp  

  *NOTE*  see above, I have flagged the value as 3. 
 
* Ebro OK
 
**MISSING** I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email. https://github.com/ices-eg/wg_WGEEL/issues/77

 
  **MISSING** No data for biometry. I'm not sure it's of any interest for pure glass eel series.
 
-----------------------------
 
## SWEDEN

### landings

* **CHECK** No value is given for the area division, supposably since it cannot be clearly distiguished (i.e. EMUs overlap with >1 area divisions). Correct? In the old data series, area divisions are given though... 

### releases

* **CHECK** In releases, GEE are reported. For those no kg estimate should be reported. Also, one of the kg values is reported as 0, which doesn't make sense if there is a number. How does T&T apply to glass eels?   

### recruitment

**MISSING** I need pictures format png for all sites, png 300x225px one of the pass, one of the location, to illustrate in shiny. Please bring them to wgeel or send by email. https://github.com/ices-eg/wg_WGEEL/issues/77

SERIES INFO

I have modified your comments, either because I had something longer or more precise already, or because I felt the description of the location was not detailed enough. Could you please check ?

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

=> OK everyhting has been updated and checked twice, **CHECK** I had a temporary value for Gota Alv last year, can you confirm it's still 20 ? What happened this year for the pass not be opened ?

BIOMETRIC DATA

**MISSING** There is only one line , I guess it's not done ? I would be good to have an idea of the size of ascending eels at all locations.

-----------------------------

## TUNISIA

### landings

* *NOTE* country code changed to TN instead of TUN

-----------------------------

## UNITED KINGDOM

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
  * Girn updated 2018 ( no data for 2019 yet)
  
> Jason :  it is still too early to provide the data for 2019 – the elvers are still running.

  * ShiM data as of 13 Aug 2018 / updated 2019 129 => 985 
  * ShiF data as of 13th Aug 2018 / updated 2019 989>129  
  
> Jason : Yes, the two series have got transposed somehow. For 2018, ShiM should be 129, and ShiF should be 989 (the previous value of 985 was preliminary data). I can provide preliminary data for 2019 for these two sites at the meeting.

> Cédric : OK thanks corrected now. 

  **CHECK** Could you check there has been an inversion in two series when compared to last year. So there is a least one mistake. I put the two series with qal_id 4
  * stra 349 inserted 2019 by Derek Evans


Series info => thanks for the updated description, it's in  !
* **MISSING** I have no data for sites Grey (which is now an official series as > 10 years), BroG (8 years), BeeG (11 years), FlaE (10 years), FlaG ...






