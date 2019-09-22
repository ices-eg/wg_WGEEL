----------------------------------------------------
-- Insert new series for Denmark
-- Note shift to script_manual_insertion.R
---------------------------------------------------------
SELECT * FROM datawg.t_series_ser where ser_cou_code='DK';
SELECT * FROM datawg.t_series_ser where ser_nameshort='Hell'; -- nothing 
-- we're gona have a hell :-) !!
-- correction of a mistake from last year
UPDATE ref.tr_station set "Country"='PORTUGAL' where "Country"='PT';--1
SELECT * FROM ref.tr_station where "Country"='DENMARK';
-- the new value will be inserted in the last row from Denmark (8) so 8 becomes 9

begin;
-- first we need to insert the station
INSERT INTO ref.tr_station( "tblCodeID",
"Station_Code",
"Country",
"Organisation",
"Station_Name",
"WLTYP",
"Lat",
"Lon",
"StartYear",
"EndYear",
"PURPM",
"Notes") 
select max("tblCodeID")+1,
       max("Station_Code")+1,
       'DANEMARK' as "Country",
       'DTU Aqua' as "Organisation",
	'Hell' as "Station_Name",
	 NULL as "WLTYP",
         12.55 as "Lat",
	 56.07 as "Lon",
	2011 as "StartYear",
	NULL as "EndYear",
	'S~T' as "PURPM", -- Not sure there
	NULL as "Notes"
from ref.tr_station; --1 
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=8; --86
INSERT INTO  datawg.t_series_ser(
          ser_order, 
          ser_nameshort, 
          ser_namelong, 
          ser_typ_id, 
          ser_effort_uni_code, 
          ser_comment, 
          ser_uni_code, 
          ser_lfs_code, 
          ser_hty_code, 
          ser_locationdescription, 
          ser_emu_nameshort, 
          ser_cou_code, 
          ser_area_division,
          ser_tblcodeid,
          ser_x, 
          ser_y, 
          ser_sam_id,
          ser_qal_id,
          ser_qal_comment,
          geom) 
          SELECT   
          8 as ser_order, 
          'Hell' ser_nameshort, 
          'Hellebaekken' as ser_namelong, 
          1 as ser_typ_id, 
          NULL as ser_effort_uni_code, 
          'Glass and young of the year trap at the interface of freshwater/marine' as ser_comment, 
          'nr' as ser_uni_code, 
          'GY' as ser_lfs_code, 
          'T' as ser_hty_code, -- TODO check that
          'Trap in small stream at the marine borderline, monitored from 1 april to 1 november ' as ser_locationdescription, 
          'DK_Inla' as ser_emu_nameshort, 
          'DK' as ser_cou_code, 
          '27.3.a' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
          12.55 as ser_x, 
          56.07 as ser_y, 
          3 as ser_sam_id, -- scientific estimate
          0 as ser_qal_id, -- currenly 8 years
          'Series too short yet < 10 years to be included' as ser_qal_comment,
          ST_SetSRID(ST_MakePoint(12.55, 56.07),4326)
          from ref.tr_station
          where  "Station_Name" = 'Hell';--1
COMMIT;

BEGIN;
UPDATE datawg.t_series_ser SET geom=ST_SetSRID(ST_MakePoint(12.55,56.07),4326) WHERE ser_nameshort='Hell';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'Hell';
COMMIT;
------------------------
-- Change location of Ronn
-------------------------
begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(13.11598,56.12357),4326) where ser_nameshort='Ronn';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'Ronn';
commit;


select ser_comment from  datawg.t_series_ser where ser_nameshort='Ring';
SELECT ser_locationdescription from  datawg.t_series_ser where ser_nameshort='Ring';

BEGIN;
UPDATE datawg.t_series_ser set ser_locationdescription = 
'The Ringhals nuclear power plant is located on the Swedish west coast in the Kattegat. This site is located at the coast. The monitoring takes place near the intake of cooling water to the nuclear power plant.'
where ser_nameshort='Ring';

UPDATE datawg.t_series_ser set  ser_comment  = 
'The Ringhals series consists of transparent glass eel. The time of arrival of the glass eels to the sampling site varies between years, probably as a consequence of hydrographical conditions, but the peak in abundance normally occurred in late March to early April. Abundance has decreased by 96% if the recent years are compared to the peak in 1981-1983. From 2012 the series has been corrected and now only concerns glass eel collected during March and April (weeks 9-18). The sampling at Ringhals is performed twice weekly in February-April, using a modified Isaacs-Kidd Midwater trawl (IKMT). The trawl is fixed in the current of incoming cooling water, fishing passively during entire nights. Sampling is depending on the operation of the power plant and changes in the strength of the current may occur so data are corrected for variations in water flow.'
where ser_nameshort='Ring';
select ser_comment from  datawg.t_series_ser
COMMIT;
SELECT ser_locationdescription from  datawg.t_series_ser where ser_nameshort='Ring';
SELECT ser_comment from  datawg.t_series_ser where ser_nameshort='Ring';


begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(12.210629,57.226613),4326) where ser_nameshort='Visk';
commit;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(12.105802,57.261890),4326) where ser_nameshort='Ring';
commit;

----------------------------
-- insert new series for mino scientific sampling MiSc
---------------------------
SELECT * FROM datawg.t_series_ser where ser_cou_code='PT';
-- will insert the series at postition 64 just after MiPo
begin;
-- first we need to insert the station
INSERT INTO ref.tr_station( "tblCodeID",
"Station_Code",
"Country",
"Organisation",
"Station_Name",
"WLTYP",
"Lat",
"Lon",
"StartYear",
"EndYear",
"PURPM",
"Notes") 
select max("tblCodeID")+1,
       max("Station_Code")+1,
       'PORTUGAL' as "Country",
       'PLEASE UPDATE' as "Organisation",
	'MiSc' as "Station_Name",
	 NULL as "WLTYP",
         41.90 as "Lat",
	 -8.2 as "Lon",
	2018 as "StartYear",
	NULL as "EndYear",
	'T' as "PURPM", -- Not sure there
	'Mino scientific recruitment monitoring' as "Notes"
from ref.tr_station; --1 
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=64; --32
INSERT INTO  datawg.t_series_ser(
          ser_order, 
          ser_nameshort, 
          ser_namelong, 
          ser_typ_id, 
          ser_effort_uni_code, 
          ser_comment, 
          ser_uni_code, 
          ser_lfs_code, 
          ser_hty_code, 
          ser_locationdescription, 
          ser_emu_nameshort, 
          ser_cou_code, 
          ser_area_division,
          ser_tblcodeid,
          ser_x, 
          ser_y, 
          ser_sam_id,
          ser_qal_id,
          ser_qal_comment,
          geom) 
          SELECT   
          64 as ser_order, 
          'MiSc' ser_nameshort, 
          'Minho scientific monitoring' as ser_namelong, 
          1 as ser_typ_id, 
          'nr day' as ser_effort_uni_code, 
          'Experimental fishing using Tela net in the Minho estuary. Started in 2018' as ser_comment, 
          'nr/h' as ser_uni_code, 
          'G' as ser_lfs_code, 
          'T' as ser_hty_code, -- TODO check that
          'Minho river 5 km from the sea' as ser_locationdescription, 
          'DK_Inla' as ser_emu_nameshort, 
          'DK' as ser_cou_code, 
          '27.9.a' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
          -8.2 as ser_x, 
          41.9 as ser_y, 
          3 as ser_sam_id, -- scientific estimate
          0 as ser_qal_id, -- currenly 2 years
          'Series too short yet < 10 years to be included' as ser_qal_comment,
          ST_SetSRID(ST_MakePoint(-8.2, 43.29),4326)
          from ref.tr_station
          where  "Station_Name" = 'MiSc';--1
COMMIT;

BEGIN;
UPDATE ref.tr_station SET "Organisation"='Ciimar' WHERE  "Station_Name" ='MiSc';
COMMIT;


----------------------------
-- insert new series for Oria scientific sampling Oria
---------------------------
SELECT * FROM datawg.t_series_ser where ser_cou_code='ES';
-- will insert the series at postition 60 just before the Nalo
BEGIN;
-- first we need to insert the station
INSERT INTO ref.tr_station( "tblCodeID",
"Station_Code",
"Country",
"Organisation",
"Station_Name",
"WLTYP",
"Lat",
"Lon",
"StartYear",
"EndYear",
"PURPM",
"Notes") 
select max("tblCodeID")+1,
       max("Station_Code")+1,
       'SPAIN' as "Country",
       'AZTI' as "Organisation",
	'Oria' as "Station_Name",
	 NULL as "WLTYP",
      43.282790 as "Lat",
	  -2.130729 as "Lon",
	2018 as "StartYear",
	NULL as "EndYear",
	'T' as "PURPM", -- Not sure there
	'Oria scientific monitoring' as "Notes"
from ref.tr_station; --1 

update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=60; --37
INSERT INTO  datawg.t_series_ser(
          ser_order, 
          ser_nameshort, 
          ser_namelong, 
          ser_typ_id, 
          ser_effort_uni_code, 
          ser_comment, 
          ser_uni_code, 
          ser_lfs_code, 
          ser_hty_code, 
          ser_locationdescription, 
          ser_emu_nameshort, 
          ser_cou_code, 
          ser_area_division,
          ser_tblcodeid,
          ser_x, 
          ser_y, 
          ser_sam_id,
          ser_qal_id,
          ser_qal_comment,
          geom) 
          SELECT   
          60 as ser_order, 
          'Oria' ser_nameshort, 
          'Oria scientific monitoring' as ser_namelong, 
          1 as ser_typ_id, 
          'nr day' as ser_effort_uni_code, 
          'Scientific sampling from a boat equipped with sieves. from 2005 - 2019, during Oct - Mar [missing 2008, 2012-2017] at the sampling point (1) in the estuary at new moon. There are statistically significant differences in depth, month and season on the density of GE. Thus, the value for GE density was predicted (glm) for each season in the highest values month/depth.' as ser_comment, 
          'nr/m3' as ser_uni_code, 
          'G' as ser_lfs_code, 
          'T' as ser_hty_code, 
          'The Oria River is 77 km long, drains an area of 888 km2, and has a mean river flow of 25.7 m3 per second. It flows into the Bay of Biscay in the Basque country, on the Northern coast of Spain' as ser_locationdescription, 
          'ES_Basq' as ser_emu_nameshort, 
          'ES' as ser_cou_code, 
          '27.8.b' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
          -2.1307297 as ser_x, 
          43.2827 as ser_y, 
          3 as ser_sam_id, -- scientific estimate
          0 as ser_qal_id, -- currenly 8 years
          'Series too short yet < 10 years to be included' as ser_qal_comment,
          ST_SetSRID(ST_MakePoint(-2.1307297, 43.28276),4326)
          from ref.tr_station
          where  "Station_Name" = 'Oria';--1
COMMIT;
--ROLLBACK;

------------------------
-- Ireland
------------------------

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(-8.176306,54.499848),4326) where ser_nameshort='Erne';
commit;

select * from  datawg.t_series_ser where  ser_nameshort in ('Erne');

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(-6.3143036,53.346488),4326) where ser_nameshort='Liff';
commit;


begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(-8.475329,52.761225),4326) where ser_nameshort='ShaP';
commit;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(-8.614108,52.705742),4326) where ser_nameshort='ShaA';
commit;



begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(-0.724741,45.258087),4326) where ser_nameshort='GiSc';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'GiSc';
commit;

BEGIN;
SELECT ser_x,ser_y, ser_nameshort FROM datawg.t_series_ser;
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort IN ('ShaP','Liff','Erne','Ronn','Ring','Visk','ShaA');
COMMIT;


select site,namelong,min,max,duration,missing,life_stage,sampling_type,unit,habitat_type,"order",series_kept
 from datawg.series_summary where site='Oria'
 
 SELECT * FROM datawg.t_dataseries_das WHERE das_ser_id = (
 SELECT ser_id FROM datawg.t_series_ser WHERE ser_nameshort='Oria')
 58.58894, 
 
begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(16.18392,58.58894),4326) where ser_nameshort='Mota';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'Mota';
commit;


SELECT * FROM datawg.t_series_ser where ser_cou_code='ES';
-- I need to insert in position 67
BEGIN;
-- first we need to insert the station
INSERT INTO ref.tr_station( "tblCodeID",
"Station_Code",
"Country",
"Organisation",
"Station_Name",
"WLTYP",
"Lat",
"Lon",
"StartYear",
"EndYear",
"PURPM",
"Notes") 
select max("tblCodeID")+1,
       max("Station_Code")+1,
       'SPAIN' as "Country",
       'UCO' as "Organisation", -- Universidad de Córdoba
	'Guadalquivir' as "Station_Name",
	 NULL as "WLTYP",
      36.801823 as "Lat", 
	  -6.341810 as "Lon",
	1998 as "StartYear",
	NULL as "EndYear",
	'T' as "PURPM", 
	'Scientific monitoring in the Guadalquivir' as "Notes"
from ref.tr_station; --1 
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=67; --37
INSERT INTO  datawg.t_series_ser(
          ser_order, 
          ser_nameshort, 
          ser_namelong, 
          ser_typ_id, 
          ser_effort_uni_code, 
          ser_comment, 
          ser_uni_code, 
          ser_lfs_code, 
          ser_hty_code, 
          ser_locationdescription, 
          ser_emu_nameshort, 
          ser_cou_code, 
          ser_area_division,
          ser_tblcodeid,
          ser_x, 
          ser_y, 
          ser_sam_id,
          ser_qal_id,
          ser_qal_comment,
          geom) 
          SELECT   
          67 as ser_order, 
          'Guad' ser_nameshort, 
          'Guadalquivir scientific monitoring' as ser_namelong, 
          1 as ser_typ_id, 
          'nr day' as ser_effort_uni_code, 
          'Scientific sampling from a boat equipped with with the local fishery gear that has been traditionally used for the commercial cayches of glass eels in the Guadalquivir estuary. 
Catches are done at three sites (see Arribas et al., 2012). The catch is done all arround the year and all month but only month 11-5 are used in the analysis. A zero inflated negative binomial
model is used to predict number of glass eel caught with volume filtered as a weighting variable in the regression. The predictions are made for the fishing season, month 1, and site = Bonanza, near
the mouth of the estuary.'
 as ser_comment, 
          'index' as ser_uni_code, 
          'G' as ser_lfs_code, 
          'T' as ser_hty_code, 
          'The Guadalquivir river is 657 km long and drains an area of about 58000 km2.  It flows into the Atlantic, and is located not far from Gilbraltar' as ser_locationdescription, 
          'ES_Anda' as ser_emu_nameshort, 
          'ES' as ser_cou_code, 
          '27.9.a' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
          -6.341810 as ser_x, 
           36.801823 as ser_y, 
          3 as ser_sam_id, -- scientific estimate
          0 as ser_qal_id, -- currenly 9 years
          'Series too short yet < 10 years to be included' as ser_qal_comment,
          ST_SetSRID(ST_MakePoint(-6.341810, 36.801823),4326)
          from ref.tr_station
          where  "Station_Name" = 'Guadalquivir';--1
COMMIT;
--ROLLBACK;
SELECT * FROM ref.tr_station WHERE "Station_Name"='Guadalquivir'; 
SELECT * FROM datawg.t_series_ser WHERE ser_nameshort='Guad' ; 


SELECT * FROM datawg.t_series_ser where ser_cou_code='BE';
-- I need to insert in position 16
BEGIN;
-- first we need to insert the station
INSERT INTO ref.tr_station( "tblCodeID",
"Station_Code",
"Country",
"Organisation",
"Station_Name",
"WLTYP",
"Lat",
"Lon",
"StartYear",
"EndYear",
"PURPM",
"Notes") 
select max("tblCodeID")+1,
       max("Station_Code")+1,
       'BELGIUM' as "Country",
       'ANB' as "Organisation", 
	'Veurne-Ambacht' as "Station_Name",
	 NULL as "WLTYP",
      51.126958 as "Lat", 	
	  2.760691 as "Lon",
	2018 as "StartYear",
	NULL as "EndYear",
	'T' as "PURPM", 
	'Scientific monitoring in the Veurne-Ambacht' as "Notes"
from ref.tr_station; --1 
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=16; --37
INSERT INTO  datawg.t_series_ser(
          ser_order, 
          ser_nameshort, 
          ser_namelong, 
          ser_typ_id, 
          ser_effort_uni_code, 
          ser_comment, 
          ser_uni_code, 
          ser_lfs_code, 
          ser_hty_code, 
          ser_locationdescription, 
          ser_emu_nameshort, 
          ser_cou_code, 
          ser_area_division,
          ser_tblcodeid,
          ser_x, 
          ser_y, 
          ser_sam_id,
          ser_qal_id,
          ser_qal_comment,
          geom) 
          SELECT   
          16 as ser_order, 
          'VeAm' as ser_nameshort, 
          'Veurne-Ambacht canal scientific estimate' as ser_namelong, 
          1 as ser_typ_id, 
          'nr day' as ser_effort_uni_code, 
          'Two eel ladders trap at both sides of a pumping station'
 as ser_comment, 
          'index' as ser_uni_code, 
          'GY' as ser_lfs_code, 
          'T' as ser_hty_code, 
          'East of Nieuwpoort, in the Veurne-Ambacht canal, nearby the pumping station' as ser_locationdescription, 
          'BE_Sche' as ser_emu_nameshort, 
          'BE' as ser_cou_code, 
          '27.4.c' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
           2.760691 as ser_x, 
           51.126958 as ser_y, 
          4 as ser_sam_id, -- trapping all
          0 as ser_qal_id, -- currenly 3 years
          'Series too short yet < 10 years to be included' as ser_qal_comment,
          ST_SetSRID(ST_MakePoint(2.760691, 51.126958),4326)
          from ref.tr_station
          where  "Station_Name" = 'Veurne-Ambacht';--1
COMMIT;
--ROLLBACK;

SELECT * FROM datawg.t_series_ser WHERE ser_cou_code='BE'
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=52; --37
update datawg.t_series_ser SET ser_order=52 WHERE ser_nameshort='VeAm'

-- change the Den Oever series, the location was really wrong
begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(5.327523,53.073100),4326) where ser_nameshort='RhDO';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'RhDO';
commit;
 

-- change position YFS1
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=2; 
update datawg.t_series_ser SET ser_order=2 WHERE ser_nameshort='YFS1'


begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(17.43453,60.55913),4326) where ser_nameshort='Dala';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'Dala';
commit;


begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(2.758001,51.134565),4326) where ser_nameshort='Yser';
UPDATE datawg.t_series_ser set (ser_x,ser_y)=(st_x(geom),st_y(geom)) where ser_nameshort = 'Yser';
commit;


, 
