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



SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code IS NULL; -- vattican for test, two rows
DELETE FROM datawg.t_eelstock_eel WHERE eel_cou_code IS NULL;



alter table datawg.t_series_ser add column ser_ccm_wso_id integer[];
update datawg.t_series_ser set 	ser_ccm_wso_id=ARRAY[88600] where ser_nameshort like 'Burr%';
update datawg.t_series_ser set 	ser_ccm_wso_id=ARRAY[88600] where ser_nameshort like 'BurS%';
update datawg.t_series_ser set 	ser_ccm_wso_id=ARRAY[88600] where ser_nameshort like 'BFuY%';
update datawg.t_series_ser set 	ser_ccm_wso_id=ARRAY[88600] where ser_nameshort like 'BuBY%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291194] where ser_nameshort like'AdTC%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291194] where ser_nameshort like'AdCP%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442593] where ser_nameshort like 'Albu%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[83746] where ser_nameshort like 'Bann%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291601] where ser_nameshort like 'BreS%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442353] where ser_nameshort like'Ebro%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[107] where ser_nameshort like 'EmsB%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[83773] where ser_nameshort like 'Erne%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[302338] where ser_nameshort like'Fre%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291126,291125] where ser_nameshort like'GiTC%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291126,291125] where ser_nameshort like'GiSc%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291126,291125] where ser_nameshort like'GiCP%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[92641] where ser_nameshort like'Yser%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[1055408] where ser_nameshort like'Imsa%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291110] where ser_nameshort like'Katw%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291110] where ser_nameshort like'Lauw%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291111] where ser_nameshort like'Loi%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442355] where ser_nameshort like'MiPo%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442355] where ser_nameshort like'MiSp%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291498] where ser_nameshort like'Nalo%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291110] where ser_nameshort like'RhDO%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[-2] where ser_nameshort like'Ring%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[84043] where ser_nameshort like 'Feal%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[85040] where ser_nameshort like 'Inag%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[84035] where ser_nameshort like'Maig%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[83750] where ser_nameshort like'SeEA%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291345] where ser_nameshort like'SevN%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[83747] where ser_nameshort like 'ShaA%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291110] where ser_nameshort like'Stel%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[129496] where ser_nameshort like'Tibe%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[1561] where ser_nameshort like'Vida%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291146] where ser_nameshort like'Vil%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[18491] where ser_nameshort like 'Visk%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[432326] where ser_nameshort like'Vac%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442355] where ser_nameshort like'Min%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442365] where ser_nameshort like'GuadG%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[442395] where ser_nameshort like'Mond%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[432326] where ser_nameshort like'Vac%';
update datawg.t_series_ser set ser_ccm_wso_id=ARRAY[291126] where ser_nameshort like 'GarY%';


-- check that no entry for glass eel stage and biometries in France
SELECT DISTINCT bio_lfs_code FROM datawg.t_biometry_series_bis 
JOIN datawg.t_series_ser ON bis_ser_id=ser_id
WHERE ser_cou_code='FR'
LIMIT 10 

update datawg.t_eelstock_eel set eel_area_division='27.3.d' 
where eel_emu_nameshort='EE_West' 
and eel_area_division is NULL
and eel_hty_code='C'
AND eel_typ_id IN (4,6);--(shiny + local)

/*
 * ISSUE #124
 * 
 */

UPDATE ref.tr_station SET ("Lat","Lon")=(ser_y, ser_x) from
(SELECT tr_station.*, ser_x, ser_y FROM ref.tr_station  JOIN
	 datawg.t_series_ser ON ser_nameshort="Station_Name") sub 
	WHERE tr_station."Station_Name"=sub."Station_Name"; --86 (shiny + local)
	 
/*
 * 
  * ISSUE #110 GY stages should be reserved for time series
 *  
 * */
	
SELECT * FROM datawg.t_eelstock_eel WHERE eel_lfs_code='GY'


/*
 * 
 * # 90 there is two series for yellow NO (ska and SkaY) ==> check for duplicates
*/

SELECT * FROM datawg.t_series_ser WHERE ser_cou_code='NO'
