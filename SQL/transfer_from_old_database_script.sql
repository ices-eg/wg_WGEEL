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
update ref.tr_lifestage_lfs set  lfs_definition ='Life-stage resident in continental waters. Often defined as a sedentary phase, but migration within and between rivers, and to and from coastal waters occurs and therefore includes young pigmented eels (‘elvers’ and bootlace).' from ts.tr_lifestage_lfs where lfs_code='Y';
update ref.tr_lifestage_lfs set  lfs_definition ='Migratory phase following the yellow eel phase. Eel in this phase are characterized by darkened back, silvery belly with a clearly contrasting black lateral line, enlarged eyes. Silver eel undertake downstream migration towards the sea, and subsequently westwards. This phase mainly occurs in the second half of calendar years, although some are observed throughout winter and following spring.' from ts.tr_lifestage_lfs where lfs_code='S';
update ref.tr_lifestage_lfs set  lfs_definition ='' from ts.tr_lifestage_lfs where lfs_code='YS';
update ref.tr_lifestage_lfs set  lfs_definition ='A mixture of glass and yellow eel, some traps have historical set of data where glass eel and yellow eel were not separated,
they were dominated by glass eel' from ts.tr_lifestage_lfs where lfs_code='GY';


--------------------------
-- tr_emu_emu
-------------------------
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;


--------------------------
-- tr_emu_emu
-------------------------
delete from ref.tr_emu_emu;
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;
--select emu_name_short,emu_name,emu_coun_abrev from ref.tr_emu_emu order by emu_coun_abrev,emu_name_short


insert into  ref.tr_emu_emu (emu_name_short,emu_coun_abrev) 
select cou_code||'_total',cou_code from ref.tr_country_cou ;--44 lines inserted

insert into ref.tr_emu_emu (emu_name_short,emu_coun_abrev) 
select cou_code||'_outside_emu',cou_code from ref.tr_country_cou ;-- 44 lines inserted


--------------------------
-- tr_country_coun
-------------------------
--select * from ref.tr_country_cou;
insert into ref.tr_country_cou select distinct on ("order") * from carto.country_order order by "order"; -- 44





--------------------------
-- ref.tr_emusplit_ems
-------------------------
insert into ref.tr_emusplit_ems (
  gid, 
  emu_name_short, 
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

------------------------------
-- ref.tr_typeseries_typ
---------------------------
insert into ref.tr_typeseries_typ select class_id, class_name,class_description from ts.tr_dataclass_class ;--3

---------------------
-- data.t_series_ser 
---------------------

/*
select * from ts.t_location_loc
select * from data.t_series_ser
*/

/*
--- before launching to check join and create case when script
 select * from ref.tr_units_uni right  join 
  (select lower(rec_unit::text) unit from ts.t_recruitment_rec) lowercaserec 
  on lowercaserec.unit=uni_code

select distinct rec_lfs_name from ts.t_recruitment_rec
select * from ref.tr_lifestage_lfs 
 */
DELETE FROM data.t_series_ser;
INSERT INTO  data.t_series_ser
 (ser_id, 
  ser_order, 
  ser_nameshort, 
  ser_namelong, 
  -- ser_typ_id, update using join with data
  ser_comment, 
  ser_uni_code, 
  ser_lfs_code, 
  ser_habitat_name, 
  ser_emu_name_short, 
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
       WHEN rec_unit='nb/h' THEN 'nr/h'
  ELSE lower(rec_unit) END AS ser_uni_code, 
  CASE WHEN rec_lfs_name='glass eel' THEN 'G'
	WHEN rec_lfs_name='yellow eel' THEN 'Y' 
	WHEN rec_lfs_name='glass eel + yellow eel' THEN 'GY'
	ELSE NULL END AS ser_lfs_code,
  rec_location AS ser_habitat_name, 
  CASE WHEN loc_emu_name_short='NO_Norw' THEN 'NO_total'
  ELSE loc_emu_name_short
  END AS  ser_emu_name_short, 
  cou_code AS ser_cou_code, 
  loc_x AS ser_x, 
  loc_y AS ser_y, 
  the_geom AS geom
FROM 
  ts.t_location_loc JOIN   ts.t_recruitment_rec ON t_location_loc.loc_id=t_recruitment_rec.rec_loc_id
  LEFT JOIN ref.tr_country_cou ON t_location_loc.loc_country= tr_country_cou.cou_country
 ORDER BY ser_id;--52 OK all line in !

/*
for some reasons GB didn't pass
correcting manually
*/
select * from data.t_series_ser where ser_emu_name_short like '%GB_%';
update data.t_series_ser set ser_cou_code='GB' where ser_emu_name_short like '%GB_%';--3


--select * from data.t_series_ser

--------------------------------------------------------
-- unit of effort updating (they were in data and are brought one table upper in ts_series_ser
-- ser_id are the same than loc_id in the old table
-----------------------------------------------------------
update data.t_series_ser  set ser_effort_uni_code=subquery.ser_effort_unit from (
select distinct on (dat_loc_id) dat_loc_id, 
case when dat_eft_id=1 then 'nr haul'
when dat_eft_id=2 then 'nr electrofishing' end as ser_effort_unit  
from data.t_series_ser join ts.t_data_dat on dat_loc_id=ser_id
where dat_eft_id is not null) AS subquery
where subquery.dat_loc_id=ser_id; --10 



--------------------------------------------------------
-- ser_typ_id
-- all series entered so far are recruitment series
-----------------------------------------------------------
update data.t_series_ser set ser_typ_id=1;--52


--------------------------------------------------------
-- some lfs code still missing
-----------------------------------------------------------

--select * from data.t_series_ser where ser_namelong like '%glass eel + yellow eel%';
update data.t_series_ser set ser_lfs_code='GY' where  ser_namelong like '%glass eel + yellow eel%';--5
--select * from data.t_series_ser where ser_namelong like '%glass eel and yellow eel%';
update data.t_series_ser set ser_lfs_code='GY' where  ser_namelong like '%glass eel and yellow eel%';--5
update data.t_series_ser set ser_lfs_code='G' where ser_lfs_code is null; -- only glass eel remaining--40

------------------------------
-- habitat type
-- "C";"WFD Coastal water"
-- "F";"Freshwater"
-- "MO";"Marine water (open sea)"
-- "T";"WFD Transitional water - implies reduced salinity"
-------------------------------


update data.t_series_ser set ser_hty_code='MO' where ser_nameshort='YFS1';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ring';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Visk';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Bann';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Erne';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='ShaA';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='SeEA';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='SeHM';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Vida';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Ems';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Lauw';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='RhDO';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='RhIj';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Katw';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Stel';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Yser';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Vil';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Loi';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='SevN';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='GiTC';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='GiCP';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='AdTC';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='AdCP';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Nalo';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Albu';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='MiSp';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='MiPo';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='Tibe';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Imsa';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Dala';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Mota';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Morr';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Kavl';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ronn';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Laga';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Gota';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='ShaP';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Gude';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Hart';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Meus';
update data.t_series_ser set ser_hty_code='MO' where ser_nameshort='YFS2';
update data.t_series_ser set ser_hty_code='T' where ser_nameshort='GiSc';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Ebro';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='AlCP';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Feal';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Maig';
update data.t_series_ser set ser_hty_code=NULL where ser_nameshort='Inag';
update data.t_series_ser set ser_hty_code='F' where ser_nameshort='Bres';
update data.t_series_ser set ser_hty_code='F' where ser_nameshort='Fre';
update data.t_series_ser set ser_hty_code='F' where ser_nameshort='Sle';
update data.t_series_ser set ser_hty_code='F' where ser_nameshort='Klit';
update data.t_series_ser set ser_hty_code='F' where ser_nameshort='Nors';


-----------------------------------------------------------------------------
-- updating long lat where st_x and st_y are missing
-----------------------------------------------------------------------------
update data.t_series_ser set (ser_x,ser_y)=(st_x(st_transform(geom,4326)),st_y(st_transform(geom,4326)))
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
  from data.t_series_ser LEFT JOIN 
  ref.tr_country_cou on ser_cou_code=cou_code LEFT JOIN
  ts.series_stats on loc_id=ser_id; --52

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
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Ems';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Lauw';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='RhDO';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='RhIj';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Katw';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Stel';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Yser';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Vil';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Loi';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='SevN';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='GiTC';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='GiCP';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='AdTC';
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
update ref.tr_station set "Organisation"=NULL where "Station_Name"='GiSc';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Ebro';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='AlCP';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Feal';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Maig';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Inag';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Bres';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Fre';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Sle';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Klit';
update ref.tr_station set "Organisation"=NULL where "Station_Name"='Nors';


------------------------------------
-- Inserting data data.t_dataseries_das
------------------------------------
-- the 58 is a yellow eel series
INSERT INTO data.t_dataseries_das (
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