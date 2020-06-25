-- server
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150

SELECT * FROM datawg.t_series_ser WHERE ser_cou_code IS NULL;
/*
Pandalus
NS-IBTS
BITS-4
BITS-1
*/

-- saving wkeelmigration data to the database
GRANT ALL ON SCHEMA wkeelmigration  TO wgeel ;


SELECT * FROM ref.tr_station 

SELECT ser_nameshort FROM datawg.t_series_ser ORDER BY ser_nameshort;

UPDATE ref.tr_station SET "Station_Name"='GuadG' WHERE "Station_Name"='Guadalquivir';
UPDATE ref.tr_station SET "Station_Name"='VeAmGY' WHERE "Station_Name"='Veurne-Ambacht';



-- join by removing 'G' or 'Y' that has been added to series names

WITH joined_despite_the_mess AS (
SELECT "tblCodeID", "Station_Name", ser_nameshort
FROM ref.tr_station 
JOIN datawg.t_series_ser ON substring(ser_nameshort,1, length(ser_nameshort)-1)="Station_Name")

UPDATE ref.tr_station SET "Station_Name" =
ser_nameshort
FROM joined_despite_the_mess
WHERE joined_despite_the_mess."tblCodeID"=tr_station."tblCodeID"; --57


-- searching for those not joined on the first operation

SELECT * FROM ref.tr_station  
EXCEPT
SELECT tr_station.* FROM ref.tr_station  JOIN
	 datawg.t_series_ser ON ser_nameshort="Station_Name";
	 
-- remove duplicate bann
DELETE FROM ref.tr_station WHERE "tblCodeID" = 170080;
UPDATE ref.tr_station SET "Station_Name" ='BannGY' WHERE "Station_Name"='Bann';
UPDATE ref.tr_station SET "Station_Name" ='BeeG' WHERE "Station_Name"='beeG';
UPDATE ref.tr_station SET "Station_Name" ='BresGY' WHERE "Station_Name"='Bres';
UPDATE ref.tr_station SET "Station_Name" ='BrokGY' WHERE "Station_Name"='Brok';
UPDATE ref.tr_station SET "Station_Name" ='EmsBGY' WHERE "Station_Name"='EmsB';
UPDATE ref.tr_station SET "Station_Name" ='ErneGY' WHERE "Station_Name"='Erne';
UPDATE ref.tr_station SET "Station_Name" ='FarpGY' WHERE "Station_Name"='Farp';
UPDATE ref.tr_station SET "Station_Name" ='FealGY' WHERE "Station_Name"='Feal';
UPDATE ref.tr_station SET "Station_Name" ='GreyGY' WHERE "Station_Name"='Grey';
UPDATE ref.tr_station SET "Station_Name" ='HellGY' WHERE "Station_Name"='Hell';
UPDATE ref.tr_station SET "Station_Name" ='HHKGY' WHERE "Station_Name"='HHK';
UPDATE ref.tr_station SET "Station_Name" ='HoSGY' WHERE "Station_Name"='HoS';
UPDATE ref.tr_station SET "Station_Name" ='InagGY' WHERE "Station_Name"='Inag';
UPDATE ref.tr_station SET "Station_Name" ='LangGY' WHERE "Station_Name"='Lang';
UPDATE ref.tr_station SET "Station_Name" ='LiffGY' WHERE "Station_Name"='Liff';
UPDATE ref.tr_station SET "Station_Name" ='ShaAGY' WHERE "Station_Name"='ShaA';
UPDATE ref.tr_station SET "Station_Name" ='StraGY' WHERE "Station_Name"='Stran';
UPDATE ref.tr_station SET "Station_Name" ='VerlGY' WHERE "Station_Name"='Verl';
UPDATE ref.tr_station SET "Station_Name" ='ViskGY' WHERE "Station_Name"='Visk';
UPDATE ref.tr_station SET "Station_Name" ='WisWGY' WHERE "Station_Name"='WisW';

-- ADD constraint to avoid this kind of problem in the future

ALTER TABLE REF.tr_station ADD CONSTRAINT c_fk_Station_Name FOREIGN KEY ("Station_Name") REFERENCES datawg.t_series_ser(ser_nameshort);


