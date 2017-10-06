-----------------------------------------------------------------
-- SCRIPT TO TRANSFERT THE CURRENT DATABASE TO THE NEW DATABASE
-----------------------------------------------------------------

-- This will take the data from the current sea table which was built on the wise EU layer


insert into ref.tr_sea_sea 
(select distinct on (emu_sea)
emu_hyd_syst_o as sea_o, 
emu_hyd_syst_s as sea_s,
 emu_sea as sea_code  from carto.t_emu_emu
 where emu_sea is not null);


-----------------------------------
-- TODO insert definitions
------------------------------------

insert into ref.tr_lifestage_lfs select 'G' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='glass eel';
insert into ref.tr_lifestage_lfs select 'Y' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='yellow eel';
insert into ref.tr_lifestage_lfs select 'S' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='silver eel';
insert into ref.tr_lifestage_lfs select 'YS' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='yellow + silver eel';
insert into ref.tr_lifestage_lfs select 'GY' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='glass eel + yellow eel';

update ref.tr_lifestage_lfs set lfs_name='yellow eel+ silver eel' where lfs_name='yellow + silver eel';

/*
Insert definition for stages
*/

update ref.tr_lifestage_lfs set  lfs_definition ='Young, unpigmented eel, recruiting from the sea into continental waters. WGEEL consider the glass eel term to include all recruits of the 0+ cohort age. In some cases, however, also includes the early pigmented stages.' from ts.tr_lifestage_lfs where lfs_code='G';
update ref.tr_lifestage_lfs set  lfs_definition ='Migratory phase following the yellow eel phase. Eel in this phase are characterized by darkened back, silvery belly with a clearly contrasting black lateral line, enlarged eyes. Silver eel undertake downstream migration towards the sea, and subsequently westwards. This phase mainly occurs in the second half of calendar years, although some are observed throughout winter and following spring.' from ts.tr_lifestage_lfs where lfs_code='S';
update ref.tr_lifestage_lfs set  lfs_definition ='' from ts.tr_lifestage_lfs where lfs_code='YS';
update ref.tr_lifestage_lfs set  lfs_definition ='A mixture of glass and yellow eel, some traps have historical set of data where glass eel and yellow eel were not separated,
they were dominated by glass eel' from ts.tr_lifestage_lfs where lfs_code='GY';
-- from Russell's comment
update ref.tr_lifestage_lfs set  lfs_definition ='Life-stage resident in continental waters. Often defined as a sedentary phase, 
but migration within and between rivers, and to and from coastal waters occurs and therefore includes young pigmented eels (?lvers?and bootlace). In particular, some recruitment series either far up in the river (Meuse) or in the Baltic are made of multiple age class of young yellow eel, typically from 1 to 10+ years of age- the are referred to as Yellow eel Recruits.' from ts.tr_lifestage_lfs where lfs_code='Y';
insert into ref.tr_lifestage_lfs select 'QG' , 'quarantined eel', 'Ongrown eel (see definition above) that have been held in isolation between capture and restocking.';
insert into ref.tr_lifestage_lfs select 'OG' , 'ongrown eel', 'Eel that have been held in water tanks for some days or months between first capture and then release to a new water basin, and they have been fed and grown during that time.';
insert into ref.tr_lifestage_lfs select 'AL' , 'All stages',  'All stages combined';
--------------------------
-- tr_emu_emu
-------------------------
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;

-- tr_country_coun
-------------------------
--select * from ref.tr_country_cou;
insert into ref.tr_country_cou select distinct on ("order") * from carto.country_order order by "order"; -- 44

--------------------------
-- tr_emu_emu
-------------------------
delete from ref.tr_emu_emu;
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;
--select emu_name_short,emu_name,emu_coun_abrev from ref.tr_emu_emu order by emu_coun_abrev,emu_name_short


insert into  ref.tr_emu_emu (emu_nameshort,emu_coun_abrev) 
select cou_code||'_total',cou_code from ref.tr_country_cou ;--44 lines inserted

insert into ref.tr_emu_emu (emu_nameshort,emu_coun_abrev) 
select cou_code||'_outside_emu',cou_code from ref.tr_country_cou ;-- 44 lines inserted


--------------------------


------------------------------------------------------
-- Sampling type
-----------------------------------------------------
insert into ref.tr_samplingtype_sam select sam_id, sam_samplingtype from ts.tr_samplingtype_sam;--5



--------------------------
-- ref.tr_emusplit_ems
-------------------------
insert into ref.tr_emusplit_ems (
  gid, 
  emu_nameshort, 
  emu_name, 
  emu_coun_abrev, 
  emu_hyd_syst_s, 
  emu_sea, 
  sum, 
  geom, 
  centre, 
  x, 
  y, 
  emu_cty_id, 
  meu_dist_sargasso_km)

select   
  t_emuagreg_ema.gid, 
  t_emuagreg_ema.emu_name_short, 
  t_emuagreg_ema.emu_name, 
  t_emuagreg_ema.emu_coun_abrev, 
  t_emuagreg_ema.emu_hyd_syst_s, 
  t_emuagreg_ema.emu_sea, 
  t_emuagreg_ema.sum, 
  t_emuagreg_ema.geom, 
  t_emuagreg_ema.centre, 
  t_emuagreg_ema.y, 
  t_emuagreg_ema.x, 
  t_emuagreg_ema.emu_cty_id, 
  t_emuagreg_ema.dist_sargasso_km 
  from carto.t_emuagreg_ema;-- 126 lines inserted
--------------------------
-- tr_habitattype_hty
-------------------------
delete from ref.tr_habitattype_hty;
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('F','Freshwater');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('T','WFD Transitional water - implies reduced salinity');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('C','WFD Coastal water');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('MO','Marine water (open sea)');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('AL','All habitats combined');
----------------------
-- tr_units_uni
---------------------
delete from ref.tr_units_uni;
insert into ref.tr_units_uni values('kg','weight in kilogrammes');
insert into ref.tr_units_uni values('nr','number');
insert into ref.tr_units_uni values('index','calculated value following a specified protocol');
insert into ref.tr_units_uni values('t','weight in tonnes');
insert into ref.tr_units_uni values('nr/h','number per hour');
insert into ref.tr_units_uni values('nr/m2','number per square meter');
insert into ref.tr_units_uni values('kg/d','kilogramme per day');
insert into ref.tr_units_uni values('kg/boat/d','kilogramme per boat per day');
insert into ref.tr_units_uni values('nr haul','number of haul'); -- effort unit used for recruitment
insert into ref.tr_units_uni values('nr electrofishing','number of electrofishing campain in the year to collect the recruitment index');
insert into ref.tr_units_uni values('ha','Surface');
--2017
insert into ref.tr_units_uni values('nr day','number of days'); -- effort unit used for recruitment (germany)

------------------------------
-- ref.tr_typeseries_typ
---------------------------
insert into ref.tr_typeseries_typ select class_id, class_name,class_description from ts.tr_dataclass_class ;--3
---------------------
-- datawg.t_series_ser 
---------------------

/*
select * from ts.t_location_loc
select * from datawg.t_series_ser
*/

/*
--- before launching to check join and create case when script
 select * from ref.tr_units_uni right  join 
  (select lower(rec_unit::text) unit from ts.t_recruitment_rec) lowercaserec 
  on lowercaserec.unit=uni_code

select distinct rec_lfs_name from ts.t_recruitment_rec
select * from ref.tr_lifestage_lfs 
 */
DELETE FROM datawg.t_series_ser;
INSERT INTO  datawg.t_series_ser
 (ser_id, 
  ser_order, 
  ser_nameshort, 
  ser_namelong, 
  -- ser_typ_id, update using join with data
  ser_comment, 
  ser_uni_code, 
  ser_lfs_code, 
  ser_habitat_name, 
  ser_emu_nameshort, 
  ser_cou_code, 
  ser_x, 
  ser_y, 
  geom)
  SELECT
  rec_loc_id AS ser_id, 
  rec_order AS ser_order, 
  rec_nameshort AS ser_nameshort, 
  loc_name AS ser_namelong, 
  coalesce(t_location_loc.loc_comment,'')||  t_recruitment_rec.rec_remark AS ser_comment, -- to avoid problems with null
  CASE WHEN rec_unit='eel/m2' THEN 'nr/m2'
       WHEN rec_unit='cpue' THEN 'kg/boat/d'
       WHEN rec_unit='Number' THEN 'nr'
       WHEN rec_unit='number' THEN 'nr'
       WHEN rec_unit='nb/h' THEN 'nr/h'
  ELSE lower(rec_unit) END AS ser_uni_code, 
  CASE WHEN rec_lfs_name='glass eel' THEN 'G'
	WHEN rec_lfs_name='yellow eel' THEN 'Y' 
	WHEN rec_lfs_name='glass eel + yellow eel' THEN 'GY'
	ELSE NULL END AS ser_lfs_code,
  rec_location AS ser_habitat_name, 
  CASE WHEN loc_emu_name_short='NO_Norw' THEN 'NO_total'
  ELSE loc_emu_name_short
  END AS  ser_emu_nameshort, 
  cou_code AS ser_cou_code, 
  loc_x AS ser_x, 
  loc_y AS ser_y, 
  the_geom AS geom
FROM 
  ts.t_location_loc JOIN   ts.t_recruitment_rec ON t_location_loc.loc_id=t_recruitment_rec.rec_loc_id
  LEFT JOIN ref.tr_country_cou ON t_location_loc.loc_country= tr_country_cou.cou_country
 ORDER BY ser_id;--53 OK all line in !

/*
for some reasons GB didn't pass
correcting manually
*/
select * from datawg.t_series_ser where ser_emu_nameshort like '%GB_%';
update datawg.t_series_ser set ser_cou_code='GB' where ser_emu_nameshort like '%GB_%';--3


--select * from datawg.t_series_ser

--------------------------------------------------------
-- unit of effort updating (they were in data and are brought one table upper in ts_series_ser
-- ser_id are the same than loc_id in the old table
-----------------------------------------------------------
update datawg.t_series_ser  set ser_effort_uni_code=subquery.ser_effort_unit from (
select distinct on (dat_loc_id) dat_loc_id, 
case when dat_eft_id=1 then 'nr haul'
when dat_eft_id=2 then 'nr electrofishing' end as ser_effort_unit  
from datawg.t_series_ser join ts.t_data_dat on dat_loc_id=ser_id
where dat_eft_id is not null) AS subquery
where subquery.dat_loc_id=ser_id; --10 



--------------------------------------------------------
-- ser_typ_id
-- all series entered so far are recruitment series
-----------------------------------------------------------
update datawg.t_series_ser set ser_typ_id=1;--52


--------------------------------------------------------
-- some lfs code still missing
-----------------------------------------------------------

--select * from datawg.t_series_ser where ser_namelong like '%glass eel + yellow eel%';
update datawg.t_series_ser set ser_lfs_code='GY' where  ser_namelong like '%glass eel + yellow eel%';--5
--select * from datawg.t_series_ser where ser_namelong like '%glass eel and yellow eel%';
update datawg.t_series_ser set ser_lfs_code='GY' where  ser_namelong like '%glass eel and yellow eel%';--5
update datawg.t_series_ser set ser_lfs_code='G' where ser_lfs_code is null; -- only glass eel remaining--40

------------------------------
-- habitat type
-- "C";"WFD Coastal water"
-- "F";"Freshwater"
-- "MO";"Marine water (open sea)"
-- "T";"WFD Transitional water - implies reduced salinity"
-------------------------------

update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Erne';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='ShaA';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='ShaP';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Feal';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Maig';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Inag';
update datawg.t_series_ser set ser_hty_code='MO' where ser_nameshort='YFS1';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ring';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Visk';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Bann';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='SeEA';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='SeHM';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Vida';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Ems';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Lauw';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='RhDO';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='RhIj';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Katw';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Stel';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Yser';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Vil';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Loi';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='SevN';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='GiTC';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='GiCP';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='AdTC';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='AdCP';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Nalo';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Albu';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='MiSp';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='MiPo';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='Tibe';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Imsa';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Dala';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Mota';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Morr';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Kavl';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ronn';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Laga';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Gota';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Gude';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Hart';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Meus';
update datawg.t_series_ser set ser_hty_code='MO' where ser_nameshort='YFS2';
update datawg.t_series_ser set ser_hty_code='T' where ser_nameshort='GiSc';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ebro';
update datawg.t_series_ser set ser_hty_code=NULL where ser_nameshort='AlCP';
update datawg.t_series_ser set ser_hty_code='F' where ser_nameshort='Bres';
update datawg.t_series_ser set ser_hty_code='F' where ser_nameshort='Fre';
update datawg.t_series_ser set ser_hty_code='F' where ser_nameshort='Sle';
update datawg.t_series_ser set ser_hty_code='F' where ser_nameshort='Klit';
update datawg.t_series_ser set ser_hty_code='F' where ser_nameshort='Nors';


-----------------------------------------------------------------------------
-- updating long lat where st_x and st_y are missing
-----------------------------------------------------------------------------
update datawg.t_series_ser set (ser_x,ser_y)=(st_x(st_transform(geom,4326)),st_y(st_transform(geom,4326)))
	where ser_x is null;--2

----------------------------------------------------------------------------
-- Inserting data from station

-- PURPM possible values for the wgeel
--Code	Description			-
-- F	Fishery trawl surveys		
-- R	Research	
-- S	Spatial (geographical) distribution monitoring		
-- T	Temporal trend monitoring
----------------------------------------------------------------------------
drop sequence if exists seq_station;
create temporary sequence seq_station;
ALTER SEQUENCE seq_station restart with 170000;
drop sequence if exists seq_stationcode;
create temporary sequence seq_stationcode;
ALTER SEQUENCE seq_stationcode restart with 12000;


INSERT INTO ref.tr_station

SELECT
  nextval('seq_station') as "tblCodeID",
  nextval('seq_stationcode')as "Station_Code",
  upper(cou_country) as "Country",
  NULL as "Organisation",
  ser_nameshort as "Station_Name",
   NULL as "WLTYP", -- to be updated later
  ser_y as "Lat",
  ser_x as "Lon" ,
  min as "StartYear",
  case when max<=2014 then max ELSE NULL END AS "EndYear",
  CASE WHEN ser_nameshort in ('YFS1','YFS2','GISc') THEN 'F~S~T'
  ELSE 'S~T' END AS "PURPM",
  NULL as notes  
  from datawg.t_series_ser LEFT JOIN 
  ref.tr_country_cou on ser_cou_code=cou_code LEFT JOIN
  ts.series_stats on loc_id=ser_id; --53

-- need to update manually
-- https://github.com/ices-eg/WGEEL/issues/6

update ref.tr_station set "Organisation"=NULL where "Station_Name"='YFS1';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Ring';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Visk';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Bann';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Erne';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='ShaA';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='SeEA';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='SeHM';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Vida';
update ref.tr_station set "Organisation"='LAVES' where "Station_Name"='Ems';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Lauw';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='RhDO';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='RhIj';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Katw';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Stel';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Yser';
update ref.tr_station set "Organisation"='EPTB-Vilaine' where "Station_Name"='Vil';
update ref.tr_station set "Organisation"='IFREMER' where "Station_Name"='Loi';
update ref.tr_station set "Organisation"='Agrocampus Ouest' where "Station_Name"='SevN';
update ref.tr_station set "Organisation"='IRSTEA' where "Station_Name"='GiTC';
update ref.tr_station set "Organisation"='IRSTEA' where "Station_Name"='GiCP';
update ref.tr_station set "Organisation"='IFREMER' where "Station_Name"='AdTC';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='AdCP';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Nalo';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Albu';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='MiSp';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='MiPo';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Tibe';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Imsa';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Dala';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Mota';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Morr';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Kavl';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Ronn';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Laga';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Gota';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='ShaP';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Gude';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Hart';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Meus';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='YFS2';
update ref.tr_station set "Organisation"='IRSTEA' where "Station_Name"='GiSc';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Ebro';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='AlCP';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Feal';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Maig';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Inag';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Bres';
update ref.tr_station set "Organisation"='MNHN' where "Station_Name"='Fre';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Sle';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Klit';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Nors';


------------------------------------
-- Inserting data datawg.t_dataseries_das
------------------------------------
-- the 58 is a yellow eel series
INSERT INTO datawg.t_dataseries_das (
  das_id, 
  das_value, 
  das_ser_id, 
  das_year, 
  das_comment, 
  das_effort) 
  SELECT 
  t_data_dat.dat_id, 
  t_data_dat.dat_value, 
  t_data_dat.dat_loc_id, 
  t_data_dat.dat_year, 
  t_data_dat.dat_comment, 
  t_data_dat.dat_effort
FROM 
  ts.t_data_dat
  where dat_class_id=1 and dat_loc_id!=58;--2146


  ---------------------------------------
  -- inserting missing data class
  -------------------------------------


/*
So far we only have three values  
1;"Recruitment index";"Index of recruitment"
2;"Yellow eel index";"Index of standing stock abundance"
3;"silver eel series";"Index of silver eel "
Data come WKEELDATA on the sharepoint
There is no unit for recruitment series so far. Which is correct.
But the other series have a unit
select distinct on (name,unit) name,unit FROM datawgeel.summary_all ;
  select * from ref.tr_typeseries_typ;
*/

alter sequence ref.tr_typeseries_typ_typ_id_seq restart with 4;
delete from ref.tr_typeseries_typ where typ_id>=4;
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('com_landings_kg','Commercial landings (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('com_catch_kg','Commercial catch (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('rec_landings_kg','Recreational landings kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('rec_catch_kg','Recreational catch (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('q_stock_kg','Stocking quantity (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('q_stock_n','Stocking quantity (number)','nr');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('gee_n','Glass eel equivalents (n)','nr');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('q_aqua_kg','Aquaculture production (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('q_aqua_n','Aquaculture production (number)','kg');

/* 
OK once there can we finish the job and include stock indicators, first I'm looking at what historical data we have
select distinct on (name) name FROM datawgeel.summary_all ;
The following will have to be decided by the wgeel, I'm putting references to try to collect historical values into the database
for consistency the Bs are in kg, though historical values in the database are in tons
TODO check that the following is correct
*/
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('B0_kg','Pristine spawning of silver eel B0 (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('Bbest_kg','Maximum potential biomass of silver eel (sumA=0) (kg) ','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('Bcurrent_kg','Current biomass of silver eel (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('Pristine_habitat_ha','Wetted area (ha)','ha');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumA','Lifetime anthropogenic mortality',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumF','Lifetime fishing mortality',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumH','Lifetime mortality hydro and pumps',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('sumF_com','Mortality due to commercial fishery, summed over age groups in the stock.',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumF_rec' , 'Mortality due to recreational fisher, summed over age groups in the stock',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumH_hydro' , 'Mortality due to hydropower (plus water intakes etc) summed over the age groups in the stock (rate)',NULL);	
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumH_habitat' , 'Mortality due to anthropogenic influence on habitat (quality/qauntity) summed over the age groups in the stock (rate)',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumH_stocking' , 'Mortality due to stocking summed over the age groups in the stock (rate: negative rate indicates positive effect of stocking)',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SumH_other' , 'Mortality due to other anthropogenic influence summed over the age groups in the stock (rate)',NULL);
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE_com','Commercial fishery silver eel equivalents','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE rec','Recreational fishery silver eel equivalents (kg)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE_hydro' , 'Silver eel equivalents relating to hydropower and water intakes etc','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE_habitat' , 'Silver eel equivalents relating to anthropogenic influences on habitat (quantity/quality)','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE_stocking' , 'Silver eel equivalents relating to stocking activity','kg');
insert into ref.tr_typeseries_typ(typ_name,typ_description,typ_uni_code) values ('SEE_other' , 'Silver eel equivalents from `other` sources','kg');


/*
 * https://github.com/ices-eg/WGEEL/issues/7
 * find ices divisions
 * 
 */
-- first change projection
alter table datawg.t_series_ser drop CONSTRAINT enforce_srid_the_geom;
update datawg.t_series_ser set geom=st_transform(geom,4326);
alter table datawg.t_series_ser add constraint enforce_srid_the_geom CHECK (st_srid(geom) =4326 );
-- same for tr_emusplit_ems
alter table ref.tr_emusplit_ems drop CONSTRAINT enforce_srid_the_geom;
update ref.tr_emusplit_ems set geom=st_transform(geom,4326);
alter table ref.tr_emusplit_ems add constraint enforce_srid_the_geom CHECK (st_srid(geom) =4326 );

update datawg.t_series_ser set ser_area_division=sub.f_division from
(
select  ser_id,f_division,st_distance(ST_ClosestPoint(s.geom,f.geom),f.geom) 
from datawg.t_series_ser s,
ref.tr_faoareas f
where ser_id is not null and f_division is not null
order by st_distance(ST_ClosestPoint(s.geom,f.geom),f.geom) 
limit 52
) sub
where t_series_ser.ser_id=sub.ser_id;--45
-- some series missing, manual edit below
update datawg.t_series_ser set ser_area_division='27.7.b' where ser_nameshort='ShaA';
update datawg.t_series_ser set ser_area_division='27.4.b' where ser_nameshort='Ems';
update datawg.t_series_ser set ser_area_division='27.3.d' where ser_nameshort='Dala';
update datawg.t_series_ser set ser_area_division='27.3.d' where ser_nameshort='Morr';
update datawg.t_series_ser set ser_area_division='27.3.a' where ser_nameshort='Gota';
update datawg.t_series_ser set ser_area_division='27.3.a' where ser_nameshort='Gude';
update datawg.t_series_ser set ser_area_division='27.3.b, c' where ser_nameshort='Hart';
update datawg.t_series_ser set ser_area_division='27.4.c' where ser_nameshort='Meus';
update datawg.t_series_ser set ser_area_division='27.7.b' where ser_nameshort='Erne';

------------------------------
-- Sampling type
-- 1;"commercial catch"
--2;"commercial CPUE"
--3;"scientific estimate"
--4;"trapping all"
--5;"trapping partial"
--------------------------------
update datawg.t_series_ser set ser_sam_id=1 where ser_namelong like '%commercial catch%';--12
update datawg.t_series_ser set ser_sam_id=2 where ser_namelong like '%commercial CPUE%'; --4
update datawg.t_series_ser set ser_sam_id=3 where ser_namelong like '%scientific%'; --10
update datawg.t_series_ser set ser_sam_id=4 where ser_namelong like '%trapping all%';--14
update datawg.t_series_ser set ser_sam_id=5 where ser_namelong like '%trapping partial%';--3
select ser_nameshort, ser_namelong,ser_sam_id from datawg.t_series_ser where ser_sam_id is null;
update datawg.t_series_ser set ser_sam_id=4 where ser_nameshort in ('Feal','Maig','Inag','Fre');
update datawg.t_series_ser set ser_sam_id=5 where ser_nameshort in ('Bres','Vac');
update datawg.t_series_ser set ser_sam_id=3 where ser_nameshort in ('Sle','Klit','Nors');
update datawg.t_series_ser set ser_sam_id=1 where ser_nameshort in ('Ebro');
-------------------------------
-- one missing value
--------------------------------

update datawg.t_series_ser set ser ser_cou_code='FR' where ser_nameshort='Vac'

-------------------------------
-- Insert geom from new stations
--------------------------------

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where ser_nameshort='Lif';
commit;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where ser_nameshort='Bur';
commit;
-- I need to insert series inbetween the Irish series
begin;
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>9;
commit;



-- I need to insert series for german
begin;
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>9;
commit;
-----------------------------
-- We have added a quality statement at the series level.
-- Here we deal with it, removing SeHMRC and adding 1 to the other
-----------------------------
update datawg.t_series_ser set ser_qal_id=1;
select ser_nameshort from datawg.t_series_ser

BEGIN;
update datawg.t_series_ser set ser_qal_id=0 where ser_nameshort= 'SeHM';
COMMIT;
BEGIN;
update datawg.t_series_ser set ser_qal_comment ='Alan the HMRC dataset is based on a guesstimate of distribution
of nett trade data between glass vs yellow/silver until about 2008 and then much better
EA sales data in more recent years  so a mix of two methods of collecting data,
one of which is of uncertain quality. The Severn EA dataset is the catches reported 
by fishermen  we know there was under reporting in old years but it is better now, 
so there are quality issues too but at least the data source is consistent over time' where ser_nameshort= 'SeHM';
COMMIT;


begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where geom IS NULL;--17
commit;