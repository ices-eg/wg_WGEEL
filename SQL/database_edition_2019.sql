-------------------------------
-- Update tested on rasberry
-- TODO update database living
-------------------------------


CREATE TABLE ref.tr_dataaccess_dta(
dta_code text primary key,
dta_description text);
INSERT INTO ref.tr_dataaccess_dta(dta_code,dta_description) values ('Public','Public access according to ICES Data Policy');
INSERT INTO ref.tr_dataaccess_dta(dta_code,dta_description) values ('Restricted','Restricted access (wgeel find a definition)');
-- inserting a new column and refering to the new referential table
ALTER TABLE datawg.t_eelstock_eel add column eel_dta_code TEXT DEFAULT 'Public';
ALTER TABLE datawg.t_eelstock_eel add constraint c_fk_eel_dta_code FOREIGN KEY (eel_dta_code)
      REFERENCES ref.tr_dataaccess_dta (dta_code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;
      
     
ALTER TABLE ref.tr_quality_qal ADD COLUMN qal_kept boolean;
UPDATE ref.tr_quality_qal SET qal_kept=true WHERE qal_id in (1,2,4);
UPDATE ref.tr_quality_qal SET qal_kept=false WHERE not qal_id in (1,2,4);

-- correct a wrong comment
COMMENT ON COLUMN datawg.t_series_ser.geom IS 'internal use, a postgis geometry point in EPSG:4326 (WGS 84)';


SELECT * from datawg.t_eelstock_eel limit 10

UPDATE datawg.t_eelstock_eel set eel_dta_code = 'Public'; -- does not work


SELECT COUNT(*) 
 	 	FROM   datawg.t_eelstock_eel
 	 	WHERE  eel_area_division is not null
 	 	AND  eel_hty_code = 'F'

DROP TRIGGER trg_check_no_ices_area ON datawg.t_eelstock_eel;

with search_duplicated as (
SELECT das_ser_id, das_year,count(*) FROM datawg.t_dataseries_das GROUP BY das_year, das_ser_id )
select * from search_duplicated where count>1

--SELECT eel_dta_code FROM datawg.t_eelstock_eel;
/*
 * WHEN we remove eel_area_division there is a duplicate stepping in, we delete it
 */
-- find the culprit
WITH gp as (SELECT NULL::TEXT AS eel_area_division,eel_emu_nameshort,eel_typ_id, eel_year FROM datawg.t_eelstock_eel WHERE
		eel_area_division is not null
 	 	AND  eel_hty_code = 'F'
 	 	AND eel_qal_id=18),
pp AS (SELECT eel_area_division,eel_emu_nameshort,eel_typ_id, eel_year FROM datawg.t_eelstock_eel WHERE
		eel_area_division is null
 	 	AND  eel_hty_code = 'F'
 	 	AND eel_qal_id=18)
SELECT * FROM gp JOIN pp ON (gp.eel_emu_nameshort,gp.eel_typ_id,gp.eel_year)=
(pp.eel_emu_nameshort,pp.eel_typ_id,pp.eel_year)


--kill it
DELETE FROM datawg.t_eelstock_eel WHERE eel_id IN (SELECT eel_id
 FROM datawg.t_eelstock_eel WHERE
		eel_area_division IS NOT null
 	 	AND  eel_hty_code = 'F'
 	 	AND eel_qal_id=18
 	 	AND eel_emu_nameshort= 'LT_total'
 	 	AND eel_typ_id=11
 	 	AND eel_year=2013);
-- correct the whole database 	 	
UPDATE datawg.t_eelstock_eel  SET eel_area_division=NULL WHERE  eel_area_division is not null
 	 	AND  eel_hty_code = 'F';


--add trigger again
CREATE TRIGGER trg_check_no_ices_area
  AFTER INSERT OR UPDATE
  ON datawg.t_eelstock_eel
  FOR EACH ROW
  EXECUTE PROCEDURE datawg.check_no_ices_area();
  
 UPDATE datawg.t_eelstock_eel set eel_dta_code = 'Public'; -- does not WORK
 
 
 DROP TRIGGER trg_check_the_stage ON datawg.t_eelstock_eel;
 
SELECT * FROM datawg.t_eelstock_eel
 	 	WHERE  eel_lfs_code in ('GY','OG','QG')
 	 	 	 	AND eel_typ_id in (4,5,6,7,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
 	 	 	 ORDER BY eel_year;
 	 	
--SELECT * FROM ref.tr_typeseries_typ WHERE typ_id =24 	
--SELECT * FROM ref.tr_typeseries_typ WHERE typ_id =4 
 	 
SELECT * FROM datawg.t_eelstock_eel  
	WHERE  eel_lfs_code in ('GY','OG','QG')
	AND eel_typ_id in (4,5,6,7,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
	AND eel_cou_code = 'IE'; --216
 	 	 	 
DELETE FROM datawg.t_eelstock_eel WHERE  eel_lfs_code in ('GY','OG','QG')
	AND eel_typ_id in (4,5,6,7,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)
	AND eel_cou_code = 'IE'; --216
	
BEGIN;	
UPDATE datawg.t_eelstock_eel SET eel_lfs_code='G' WHERE eel_typ_id=24 AND eel_cou_code='SE' AND eel_lfs_code='QG';
COMMIT;	

BEGIN;	
UPDATE datawg.t_eelstock_eel SET eel_lfs_code='G' WHERE eel_typ_id=4 AND eel_cou_code='PT' AND eel_lfs_code='GY';
COMMIT;	

CREATE TRIGGER trg_check_the_stage
  AFTER INSERT OR UPDATE
  ON datawg.t_eelstock_eel
  FOR EACH ROW
  EXECUTE PROCEDURE datawg.check_the_stage();
 
 UPDATE datawg.t_eelstock_eel  SET eel_area_division=NULL WHERE  eel_area_division is not null
 	 	AND  eel_hty_code = 'F';
 	 
 SELECT * FROM datawg.t_eelstock_eel LIMIT 10; 

UPDATE datawg.t_eelstock_eel set eel_dta_code = 'Public'; --18193
--ALTER TABLE datawg.t_eelstock_eel ALTER COLUMN eel_dta_code SET DEFAULT  'Public';


-- tolower type name to match data from xls files
UPDATE ref.tr_typeseries_typ SET typ_name = LOWER(typ_name);

	