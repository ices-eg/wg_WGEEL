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


SELECT eel_dta_code FROM datawg.t_eelstock_eel;
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
--
UPDATE ref.tr_typeseries_typ SET typ_name = LOWER(typ_name);


-- minor correction
COMMENT ON COLUMN datawg.t_series_ser.geom IS 'internal use, a postgis geometry point in EPSG:3035 (ETRS89 / ETRS-LAEA)';

select * from ref.tr_quality_qal;
BEGIN;
INSERT INTO ref.tr_quality_qal (qal_id ,
  qal_level,
  qal_text,
  qal_kept) VALUES
(
19,
'discarded_wgeel_2019',
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2019',
FALSE);--1
COMMIT;


select * from ref.tr_datasource_dts;
BEGIN;
INSERT INTO ref.tr_datasource_dts  VALUES
(
'dc_2019',
'Joint EIFAAC/GFCM/ICES Eel Data Call 2019');--1
COMMIT;
  
-- grant rights to wgeel otherwise problems with shiny
GRANT ALL ON SEQUENCE datawg.log_log_id_seq TO wgeel;
GRANT ALL ON schema datawg TO wgeel;

GRANT ALL ON SEQUENCE datawg.t_eelstock_eel_eel_id_seq to wgeel;



-- two lines with the wrong area division, I remove them from insertion but correct with a script
BEGIN;
with smallproblem as (select * from datawg.t_eelstock_eel 
where eel_cou_code='ES'
AND eel_typ_id in (4)
and eel_emu_nameshort='ES_Cata'
and eel_year in (2015,2016,2017,2018)
AND eel_lfs_code='G'
AND eel_area_division!='37.1.1')
update datawg.t_eelstock_eel set eel_area_division='37.1.1' where eel_id in (select eel_id from smallproblem)
COMMIT;

-- => Détail :La clé « (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id, eel_area_division)=(2017, G, ES_Cata, 4, T, 1, 37.1.1) » existe déjà.

with smallproblem as (select * from datawg.t_eelstock_eel 
where eel_cou_code='ES'
AND eel_typ_id in (4)
and eel_emu_nameshort ='ES_Cata'
and eel_year in (2017,2018)
AND eel_lfs_code='G'
)
SELECT * from smallproblem

-- OK one line in 2017 correct, the other not
-- still I can remove both wrong values


select * from datawg.t_eelstock_eel  where eel_area_division in ('37.1.2','37.1.3') and eel_cou_code='ES'--2

BEGIN;
DELETE FROM datawg.t_eelstock_eel  where eel_area_division in ('37.1.2','37.1.3') and eel_cou_code='ES';
COMMIT;




SELECT * FROM datawg.t_eelstock_eel where (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id)=(2018, 'YS', 'DK_Inla', 6, 'F', 1);


select * from datawg.t_eelstock_eel 
where eel_cou_code='ES'
AND eel_typ_id in (4)
and eel_emu_nameshort ='ES_Gali'
and eel_year = 2014
AND eel_lfs_code='YS'


/* 07/08 restauration of the daba */
/*
grant all on database wgeel to wgeel;
GRANT ALL ON SCHEMA ref to wgeel
GRANT ALL ON SCHEMA datawg to wgeel
GRANT ALL ON ALL TABLES IN SCHEMA datawg TO wgeel; 
GRANT ALL ON ALL TABLES IN SCHEMA ref TO wgeel; 
GRANT ALL ON SEQUENCE datawg.log_log_id_seq TO wgeel;
GRANT ALL ON SEQUENCE datawg.t_eelstock_eel_eel_id_seq to wgeel;
GRANT ALL ON SEQUENCE datawg.t_biometry_bio_bio_id_seq to wgeel;
GRANT ALL ON ALL TABLES IN SCHEMA public TO wgeel; 
GRANT ALL ON SCHEMA public to wgeel
*/

GRANT ALL ON TABLE datawg.t_biometry_series_bis  to wgeel;
GRANT ALL ON TABLE datawg.t_biometry_other_bit  to wgeel;
GRANT ALL ON TABLE datawg.t_biometry_bio  to wgeel;


-- remove two wrong lines for SWEDEN (Jan Dag -Cédric)

SELECT * FROM datawg.t_eelstock_eel WHERE eel_id in(422628,422631)
BEGIN;
DELETE FROM datawg.t_eelstock_eel WHERE eel_id in(422628,422631)
COMMIT;

-- correction of lines for the portugal

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code='PT' AND eel_year < 1985 AND eel_lfs_code='Y'
eel_area_division
BEGIN;
UPDATE datawg.t_eelstock_eel SET (eel_qal_id,eel_qal_comment)=(19,'No yellow eel for PT at that date, there are glass eel with wrong code, removed')
WHERE eel_cou_code='PT' AND eel_year < 1985 AND eel_lfs_code='Y';
COMMIT;

SELECT * FROM datawg.t_eelstock_eel  WHERE eel_cou_code='SE' AND eel_emu_nameshort='SE_East' AND eel_hty_code='C' AND eel_typ_id=4;
-- areas in sweden
BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_area_division='27.3.d'  WHERE eel_cou_code='SE' AND eel_emu_nameshort='SE_East' AND eel_hty_code='C' AND eel_typ_id=4;
COMMIT;
SELECT * FROM datawg.t_eelstock_eel  WHERE eel_cou_code='SE' AND eel_emu_nameshort='SE_West' AND eel_hty_code='C' AND eel_typ_id=4;


BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_area_division='27.3.a'  WHERE eel_cou_code='SE' AND eel_emu_nameshort='SE_West' AND eel_hty_code='C' AND eel_typ_id=4;
COMMIT;

SELECT DISTINCT eel_emu_nameshort FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 AND eel_emu_nameshort NOT LIKE '%total%'

SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 AND eel_cou_code='FI'
SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='FI_Finl' 

BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort='FI_total' WHERE eel_emu_nameshort='FI_Finl' AND eel_typ_id=11 
COMMIT;


BEGIN;
WITH emu_based_aquaculture AS (
SELECT DISTINCT eel_emu_nameshort FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 AND eel_emu_nameshort NOT LIKE '%total%'),
lines_to_update AS (
SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 AND (eel_qal_id=1) 
AND eel_emu_nameshort IN (SELECT eel_emu_nameshort FROM emu_based_aquaculture))
--SELECT count(*) FROM lines_to_update --151
--SELECT count(*),eel_emu_nameshort FROM lines_to_update GROUP BY eel_emu_nameshort
UPDATE datawg.t_eelstock_eel SET eel_qal_id=19 WHERE eel_id IN (SELECT eel_id FROM lines_to_update);
COMMIT;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 AND eel_emu_nameshort='ES_Vale' AND eel_qal_id=1


SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=11 ORDER BY eel_id DESC LIMIT 150


--- problems of duplicates with Lithuania
SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=1995 AND eel_year<=1999;


BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort= 'LT_total' WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=1995 AND eel_year<=1999;--15
COMMIT;

SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=2000 AND eel_qal_id=1 AND eel_typ_id=4;
BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_qal_id=19 WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=2000 AND eel_qal_id=1 AND eel_typ_id=4;--27
COMMIT;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=2000 AND eel_qal_id=1 AND eel_typ_id=6;
BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_qal_id=19 WHERE eel_emu_nameshort='LT_Lith' AND eel_year>=2000 AND eel_qal_id=1 AND eel_typ_id=6;--6
COMMIT;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_lfs_code='GY'
/*
SELECT * FROM ref.tr_emu_emu WHERE emu_nameshort='GB_NorW'
SELECT * FROM "ref".tr_emusplit_ems WHERE emu_nameshort='GB_NorW'
SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='IE_NorW'; -- NOTHING
SELECT * FROM datawg.t_series_ser WHERE ser_emu_nameshort='GB_NorW'; -- NOTHING
BEGIN;
DELETE FROM ref.tr_emu_emu WHERE emu_nameshort='GB_NorW'
ROLLBACK;
*/


