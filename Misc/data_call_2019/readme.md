# INFORMATIONS ABOUT DATA CALL INTEGRATION 2019

# General notes

Some files are in WGEEL accession, the rest have been collected by Jan Dag

https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment.xlsx
=> nothing, don't know what country it is.

* **NOTE**  For recruitment check that series now > 10 years are included



# Series integration 

## Greece

Recruitment
https://community.ices.dk/ExpertGroups/wgeel/WGEEL%20accessions/Data%20call%202019/Eel_Data_Call_Annex1_Recruitment_GR.xlsx
=> No data

## Lithuania

Recruitment => No data 

## Denmark

### Recruitment 

 ** => new series Hellebaekken**


* *CHECK* I guess the `ser_uni_cod` is number
* *CHECK* My guess is that the trap is in transitional waters is it TRUE ?
* *CHECK*  The organisation doing the monitoring is DTU Aqua ? this is necessary for the station table for ICES
* **NOTE**  There is nothing in our sheets to enter those data, insert a sheet with fields <br/>
			ref.tr_station( "tblCodeID",<br/>
			"Station_Code",<br/>
			"Country",<br/>
			"Organisation",<br/>
			"Station_Name",<br/>
			"WLTYP",<br/>
			"Lat",<br/>
			"Lon",<br/>
			"StartYear",<br/>
			"EndYear",<br/>
			"PURPM",<br/>
			"Notes") <br/>
			COMMENT ON COLUMN ref.tr_station."Country" IS 'country responsible of the data collection ?';<br/>
			COMMENT ON COLUMN ref.tr_station."WLTYP" IS 'Water and land station types ';<br/>
			COMMENT ON COLUMN ref.tr_station."PURPM" IS 'Purpose of monitoring http://vocab.ices.dk/?ref=1399';<br/>
* **NOTE**  This series will be names hell		
* **NOTE** Cannot use the effort as it stands, it should be a numeric, with effort, so I'm putting the season monitored which never changes (total season 1 april-1 november) into the series description.
* *CHECK* Biometry 70-100 mm is a text not a numeric what should I do ?
			



