# INFORMATIONS ABOUT DATA CALL INTEGRATION 2019

# General notes

Some files are in WGEEL accession, the rest have been collected by Jan Dag

https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment.xlsx
=> nothing, don't know what country it is.

* **NOTE**  For recruitment check that series now > 10 years are included
* **NOTE**  There is nothing in our sheets to enter data for the station table, for next year insert a sheet with fields <br/>
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
* **NOTE**  The reference list for emu is wrong in landings original file, it should not integrate outside emu, there is a script to generate referential tables, run it to provide the right references during wgeel

# Series integration 

## Greece

Recruitment
https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment_GR.xlsx
=> No data

## Lithuania

Recruitment => No data 

## Denmark

### Recruitment 

* *MISSING*  I need png 300x225px for all Danish stations to illustrate in shiny.
 ** => new series Hellebaekken**


* *CHECK* I guess the `ser_uni_cod` is number (nr). It was left blank in the description file.
* *CHECK* My guess is that the trap is in transitional waters is it TRUE ?
* *CHECK*  The organisation doing the monitoring is DTU Aqua ? this is necessary for the station table for ICES
* **NOTE**  This series will be named hell :-) !		
* **NOTE** Cannot use the effort as it stands, it should be a numeric, with effort, so I'm putting the season monitored which never changes (total season 1 april-1 november) into the series description.
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
 
* **NOTE** There are 3 lines for Dk_Inla but only one EMU, you cannot have area division in Freshwater, 
 so I've added the 3 lines.
 
 
## Spain
 
### Landings
 
* **NOTE**  MARIA or Esti praise for you for spotting the wrong `eel_area_division` the best was to remove those lines
 and re-inserting again.
 
 
```sql
  BEGIN;
DELETE FROM datawg.t_eelstock_eel  where eel_area_division in ('37.1.2','37.1.3') and eel_cou_code='ES';
COMMIT;
```
* **NOTE** Value for datacall 2019 was dc_2019 => corrected

```
13 new values inserted in the database
For duplicates 6 values replaced in the database (old values kept with code eel_qal_id=19),
            0 values not replaced (values from current datacall stored with code eel_qal_id 19)
```

### Release
 
* **NOTE** All names should be `release_n`, it's later on that the script will split up the two columns `release_n` and `release_kg`
* *CHECK* You have values for 2020 I this is obviously a mistake, I changed to 2019 correct ?
 
| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 6    | 0         | 0         |
| 2019 | 10   | 0         | 0         |

* **NOTE** The last line is a duplicate fom previous line but with values wrong (57 kg glass eel is about 17000 not 170000 + this was the 2020 line ... I'm dropping this line.  

```
 16 new values inserted in the database
 ```
 * *MISSING* You have not submitted aquaculture but you have some no ?
 
 
## Estonia

### Landings

| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 6    | 0         | 0         |


### Releases

* **NOTE** `Removed eel_missvaluequal`
| year | new  | conflicts | no change |
|:----:|:----:|:---------:|:---------:|
| 2018 | 2    | 0         | 0         |

### Aquaculture
 
 

 
 