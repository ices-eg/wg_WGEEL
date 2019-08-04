----------------------------------------------------
-- Insert new series for Denmark
---------------------------------------------------------
SELECT * FROM datawg.t_series_ser where ser_cou_code='DK';
SELECT * FROM datawg.t_series_ser where ser_nameshort='Hell'; -- nothing 
-- we're gona have a hell :-) !!
-- correction of a mistake from last year
UPDATE ref.tr_station set "Country"='PORTUGAL' where "Country"='PT';--1
SELECT * FROM ref.tr_station where "Country"='DENMARK';
-- the new value will be inserted in the last row from Denmark (8) so 8 becomes 9

begin;

update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=8;

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
       'DK' as "Country",
       'DTU Aqua' as "Organisation",
	'Hell' as "Station_Name",
	 NULL as "WLTYP",
         12.55 as "Lat",
	 56.07 as "Lon",
	2011 as "StartYear",
	NULL as "EndYear",
	'S~T' as "PURPM", -- Not sure there
	NULL as "Notes"
from ref.tr_station;
update datawg.t_series_ser set ser_order=ser_order+1 where ser_order>=63;
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
          ser_qal_comment) 
          SELECT   
          63 as ser_order, 
          'Mond' ser_nameshort, 
          'Mondego estuary' as ser_namelong, 
          1 as ser_typ_id, 
          'nr day' as ser_effort_uni_code, 
          'Experimental fishing in Mondego estuary using stow net, 5 km from the sea' as ser_comment, 
          'kg' as ser_uni_code, 
          'G' as ser_lfs_code, 
          'T' as ser_hty_code, 
          'Mondego estuary 5 km from the sea' as ser_locationdescription, 
          'PT_Port' as ser_emu_nameshort, 
          'PT' as ser_cou_code, 
          '27.9.a' as ser_area_division,
          "tblCodeID" as ser_tblcodeid, -- this comes from station
          -8.82 as ser_x, 
          40.14 as ser_y, 
          3 as ser_sam_id, -- scientific estimate
          0 as ser_qal_id,
          'Series too short yet < 10 years to be included' as ser_qal_comment from ref.tr_station
          where  "Station_Name" = 'Mond';
COMMIT;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where ser_nameshort='HoS';
commit;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where ser_nameshort='FlaG';
commit;

begin;
update datawg.t_series_ser set geom=ST_SetSRID(ST_MakePoint(ser_x, ser_y),4326) where ser_nameshort='Mond';
commit;
