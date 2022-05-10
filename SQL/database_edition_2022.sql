-------------------
-- WKEELDATA4 09/05/2022
-------------------

-- dump on server 09/05


-- CURRENT CODE

-- DROP TABLE datawg.t_biometry_series_bis;
/*
CREATE TABLE datawg.t_biometry_series_bis (
  bis_g_in_gy numeric NULL,
  bis_ser_id int4 NULL,
  CONSTRAINT c_fk_bio_series_bis_dts_datasource FOREIGN KEY (bio_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource),
  CONSTRAINT c_fk_ser_id FOREIGN KEY (bis_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE
)
INHERITS (datawg.t_biometry_bio);
CREATE UNIQUE INDEX idx_biometry_series1 ON datawg.t_biometry_series_bis USING btree (bio_year, bio_lfs_code, bis_ser_id, bio_qal_id) WHERE (bio_qal_id IS NOT NULL);
CREATE UNIQUE INDEX idx_biometry_series2 ON datawg.t_biometry_series_bis USING btree (bio_year, bio_lfs_code, bis_ser_id) WHERE (bio_qal_id IS NULL);


-- DROP TABLE datawg.t_biometry_bio;

CREATE TABLE datawg.t_biometry_bio (
  bio_id serial4 NOT NULL,
  bio_lfs_code varchar(2) NOT NULL, -- this might be a problem FOR individual DATA (maybe correct later)
  bio_year numeric NULL,
  bio_length numeric NULL,
  bio_weight numeric NULL,
  bio_age numeric NULL,
  bio_perc_female numeric NULL,
  bio_length_f numeric NULL,
  bio_weight_f numeric NULL,
  bio_age_f numeric NULL,
  bio_length_m numeric NULL,
  bio_weight_m numeric NULL,
  bio_age_m numeric NULL,
  bio_comment text NULL,
  bio_last_update date NULL,
  bio_qal_id int4 NULL,
  bio_dts_datasource varchar(100) NULL,
  bio_number numeric NULL,
  CONSTRAINT t_biometry_bio_pkey PRIMARY KEY (bio_id),
  CONSTRAINT c_fk_bio_dts_datasource FOREIGN KEY (bio_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource),
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (bio_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (bio_qal_id) REFERENCES "ref".tr_quality_qal(qal_id)
);

-- Table Triggers

CREATE TRIGGER update_bio_time BEFORE
INSERT
    OR
UPDATE
    ON
    datawg.t_biometry_bio FOR EACH ROW EXECUTE FUNCTION datawg.update_bio_last_update();


-- DROP TABLE datawg.t_biometry_other_bit;

CREATE TABLE datawg.t_biometry_other_bit (
  bit_n int4 NULL,
  bit_loc_name text NULL,
  bit_cou_code varchar(2) NULL,
  bit_emu_nameshort varchar(20) NULL,
  bit_area_division varchar(254) NULL,
  bit_hty_code varchar(2) NULL,
  bit_latitude numeric NULL,
  bit_longitude numeric NULL,
  bit_geom geometry(point, 3035) NULL,
  CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(bit_geom) = 2)),
  CONSTRAINT enforce_geotype_the_geom CHECK (((geometrytype(bit_geom) = 'POINT'::text) OR (bit_geom IS NULL))),
  CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(bit_geom) = 3035)),
  CONSTRAINT c_fk_area_code FOREIGN KEY (bit_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (bit_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_emu FOREIGN KEY (bit_emu_nameshort,bit_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_hty_code FOREIGN KEY (bit_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE
)
INHERITS (datawg.t_biometry_bio);


SELECT * FROM datawg.t_biometry_bio;

SELECT count(*) FROM datawg.t_biometry_bio; --2841
SELECT count(*) FROM datawg.t_biometry_other_bit tbob; --180
-- silvering data from wgeel 2010(?) they have a location, correspond to 'average data'
SELECT coun
*/

--------------------------------------------------------------------------------------
-- the column bio_number is now a duplicate with the column in t_biometryother_bit
-- pass column bit_n to bio_number
--------------------------------------------------------------------------------------

With alldat as(
SELECT * FROM datawg.t_biometry_other_bit)

UPDATE datawg.t_biometry_bio SET bio_number=alldat.bit_n FROM alldat WHERE 
alldat.bio_id=t_biometry_bio.bio_id; --180

ALTER TABLE datawg.t_biometry_other_bit DROP COLUMN bit_n;


/*
 * 
 * QUALITY AND INDIVIDUAL AND GROUP SERIES INTEGRATION

 * [ ] add link
 * 
 */




-- t_biometry_bio  => rename so that it reflects group sample

ALTER TABLE datawg.t_biometry_bio RENAME TO t_biometrygroupseries_bio;
 
 /*
  * 
  * TABLE OF MEASURES TYPE, CORRESPONDS TO BOTH individual and quality measures
  * 
  * 
  */ 
DROP TABLE IF EXISTS ref.tr_mesuretype_mty;
 CREATE TABLE ref.tr_mesuretype_mty(
 mty_id INTEGER PRIMARY KEY,
 mty_name TEXT,
 mty_description TEXT,
 mty_type TEXT CHECK (mty_type='quality' OR mty_type='biometry'), -- this will be used in triggers later
 mty_group TEXT CHECK (mty_group='individual' OR mty_type='group'), -- this will be used in triggers later
 mty_uni_code varchar(20),
 CONSTRAINT c_fk_uni_code FOREIGN KEY (mty_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE
 );
 

  
 
/*
 * CREATE A TABLE TO STORE BIOMETRY ON INDIVIDUAL DATA

 */
DROP TABLE IF EXISTS datawg.t_sampinginfo_sai;
CREATE TABLE datawg.t_sampinginfo_sai(
  sai_id serial PRIMARY KEY,
  sai_cou_code VARCHAR(2),
  sai_emu_nameshort VARCHAR(20),
  sai_area_division VARCHAR(254),
  sai_comment TEXT, -- this could be DCF ... other CHECK IF we need a referential TABLE....
  sai_year INTEGER,
  sai_samplingobjective TEXT,
  sai_metadata TEXT, -- this must contain information TO rebuild the stratification scheme rename ?
  sai_qal_id INTEGER, 
  sai_lastupdate DATE NOT NULL DEFAULT CURRENT_DATE,
  sai_dts_datasource VARCHAR(100),
  CONSTRAINT c_fk_sai_qal_id FOREIGN KEY (sai_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_cou_code FOREIGN KEY (sai_cou_code) REFERENCES "ref".tr_country_cou(cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_emu FOREIGN KEY (sai_emu_nameshort,sai_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_area_division FOREIGN KEY (sai_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_dts_datasource FOREIGN KEY (sai_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
);

-- Table Triggers

CREATE OR REPLACE FUNCTION datawg.sai_lastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.sai_lastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;

CREATE TRIGGER update_sai_lastupdate  BEFORE INSERT OR UPDATE ON
   datawg.t_sampinginfo_sai FOR EACH ROW EXECUTE FUNCTION datawg.sai_lastupdate();

/*
 * 
 * Fish are related to either a sampling or a series
 * the table for fish is created and two tables with additional information relate to it
 * the first 
 */
DROP TABLE  datawg.t_fish_fi CASCADE;
CREATE TABLE datawg.t_fish_fi(
  fi_id SERIAL PRIMARY KEY,
  fi_lfs_code varchar(2) NOT NULL, 
  fi_date DATE NOT NULL,
  fi_lastupdate DATE NOT NULL DEFAULT CURRENT_DATE,
  fi_dts_datasource varchar(100),
  CONSTRAINT c_fk_fi_lfs_code FOREIGN KEY (fi_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_fi_dts_datasource FOREIGN KEY (fi_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
  );

-- Table Triggers

CREATE OR REPLACE FUNCTION datawg.fi_lastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.fi_lastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON
   datawg.t_fish_fi FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();

/*
 * 
 * Table fish for series
 *
 */ 
DROP TABLE IF EXISTS  t_fishseries_fiser;
CREATE TABLE  datawg.t_fishseries_fiser(
fiser_ser_id INTEGER NOT NULL,  
fiser_year INTEGER NOT NULL,
CONSTRAINT c_fk_fiser_ser_id FOREIGN KEY (fiser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE
)
INHERITS (datawg.t_fish_fi);


CREATE OR REPLACE FUNCTION datawg.fiser_year()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
 
  BEGIN
   
    IF NEW.fiser_year <> EXTRACT(YEAR FROM NEW.fi_date) THEN
      RAISE EXCEPTION 'table t_fisheries_fiser, column fiser_year does not match the date of fish collection (table t_fish_fi)' ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_year_and_date ON datawg.t_fishseries_fiser ;
CREATE TRIGGER check_year_and_date AFTER INSERT OR UPDATE ON
   datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fiser_year();



/*
* HERE set as wgs84 do we set this in 3035 ?
*/
DROP TABLE IF EXISTS  datawg.t_fishsamp_fisa;
CREATE TABLE  datawg.t_fishsamp_fisa(
fisa_sai_id INTEGER,
fisa_x_4326 NUMERIC NOT NULL,
fisa_y_4326 NUMERIC NOT NULL,
fisa_geom geometry(point, 4326),
fisa_area_division varchar(254),
fisa_hty_code varchar(2),
CONSTRAINT c_fk_fisa_sai_id FOREIGN KEY (fisa_sai_id) REFERENCES datawg.t_sampinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE RESTRICT,
CONSTRAINT c_fk_fisa_hty_code FOREIGN KEY (fisa_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE
)
INHERITS (datawg.t_fish_fi);



  
/*
 * TABLE OF INDIVIDUAL MEASUREMENTS
 * I put a DELETE cascade on the table so if a fish is removed all biometries and qualities attached are dropped
 * 
 */  
  
DROP TABLE IF EXISTS datawg.t_biometryind_bii CASCADE;
CREATE TABLE datawg.t_biometryind_bii (
  bii_id serial PRIMARY KEY,
  bii_fi_id INTEGER,  
  bii_mty_id INTEGER,
  bii_value NUMERIC,
  bii_comment TEXT,
  bii_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  bii_qal_id INTEGER, 
  bii_dts_datasource varchar(100),
  CONSTRAINT c_fk_bii_fi_id FOREIGN KEY (bii_fi_id) REFERENCES datawg.t_fish_fi(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_bii_mty_id FOREIGN KEY (bii_mty_id) REFERENCES "ref".tr_mesuretype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_bii_qal_id FOREIGN KEY (bii_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_bii_dts_datasource FOREIGN KEY (bii_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
)
;
-- Add trigger on last_update
CREATE OR REPLACE FUNCTION datawg.bii_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.bii_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_bii_last_update ON datawg.t_biometryind_bii ;
CREATE TRIGGER update_bii_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_biometryind_bii FOR EACH ROW EXECUTE FUNCTION  datawg.bii_last_update();

-- TODO trigger  length, weight, age, eyediameter,pectoral_fin with bounds

-- trigger check that only invividual measures are used
CREATE OR REPLACE FUNCTION datawg.bii_mty_is_individual()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.bii_mty_id;

    IF (the_mty_type <> 'Individual') THEN
    RAISE EXCEPTION 'table t_biometryind_bii, Measure --> % is not an individual measure', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_bii_mty_is_individual ON datawg.t_biometryind_bii;
CREATE TRIGGER check_bii_mty_is_individual AFTER INSERT OR UPDATE ON
   datawg.t_biometryind_bii FOR EACH ROW EXECUTE FUNCTION datawg.bii_mty_is_individual();
 
-- trigger check that only biometry measures are used
--TODO TEST THIS TRIGGER
CREATE OR REPLACE FUNCTION datawg.bii_mty_is_biometry()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_group TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_group , the_mty_name   
  mty_group, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.bii_mty_id;

    IF (the_mty_type <> 'Biometry') THEN
    RAISE EXCEPTION 'table t_qualityind_bii, Measure --> % is not a measure of biometry', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_bii_mty_is_biometry ON datawg.t_biometryind_bii;
CREATE TRIGGER check_bii_mty_is_quality AFTER INSERT OR UPDATE ON
   datawg.t_biometryind_bii FOR EACH ROW EXECUTE FUNCTION datawg.bii_mty_is_biometry();

 



/*
 * TABLE OF QUALITY MEASUREMENTS this table has exactly the same structure as t_biometry_bii 
 * FOR THE SAKE OF SIMPLICIY WE DON't SET INHERITANCE
 * 
 */
DROP TABLE IF EXISTS  datawg.t_qualityind_big;
CREATE TABLE datawg.t_qualityind_qui(
  qui_id SERIAL PRIMARY KEY, 
  qui_fi_id INTEGER,  
  qui_mty_id INTEGER,
  qui_value NUMERIC,
  qui_comment TEXT,
  qui_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  qui_qal_id INTEGER, 
  qui_dts_datasource varchar(100),
  CONSTRAINT c_fk_qui_fi_id FOREIGN KEY (qui_fi_id) REFERENCES datawg.t_fish_fi(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_qui_mty_id FOREIGN KEY (qui_mty_id) REFERENCES "ref".tr_mesuretype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qui_qal_id FOREIGN KEY (qui_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qui_dts_datasource FOREIGN KEY (qui_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE

) 
;

--  trigger on last_update
CREATE OR REPLACE FUNCTION datawg.qui_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.qui_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_qui_last_update ON datawg.t_qualityind_qui ;
CREATE TRIGGER update_qui_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_qualityind_qui FOR EACH ROW EXECUTE FUNCTION  datawg.qui_last_update();


-- trigger check that only invividual measures are used
--TODO TEST THIS TRIGGER
CREATE OR REPLACE FUNCTION datawg.qui_mty_is_individual()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.qui_mty_id;

    IF (the_mty_type <> 'Individual') THEN
    RAISE EXCEPTION 'table t_qualityind_qui, Measure --> % is not an individual measure', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_qui_mty_is_individual ON datawg.t_qualityind_qui;
CREATE TRIGGER check_qui_mty_is_individual AFTER INSERT OR UPDATE ON
   datawg.t_qualityind_qui FOR EACH ROW EXECUTE FUNCTION datawg.qui_mty_is_individual();
 
-- trigger check that only quality measures are used
--TODO TEST THIS TRIGGER
CREATE OR REPLACE FUNCTION datawg.qui_mty_is_quality()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_group TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_group , the_mty_name   
  mty_group, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.qui_mty_id;

    IF (the_mty_type <> 'Quality') THEN
    RAISE EXCEPTION 'table t_qualityind_qui, Measure --> % is not a measure of quality', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_qui_mty_is_quality ON datawg.t_qualityind_qui;
CREATE TRIGGER check_qui_mty_is_quality AFTER INSERT OR UPDATE ON
   datawg.t_qualityind_qui FOR EACH ROW EXECUTE FUNCTION datawg.qui_mty_is_quality();

 
 


DROP TABLE IF EXISTS datawg.t_biometrygroup_big CASCADE;
CREATE TABLE datawg.t_biometrygroup_big (
  big_id serial PRIMARY KEY,
  big_sai_id INTEGER,
  big_year INTEGER,
  big_mty_id INTEGER,
  big_value NUMERIC,
  big_comment TEXT,
  big_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  big_qal_id int4, 
  big_dts_datasource varchar(100),
  CONSTRAINT c_ck_uk_big_sai UNIQUE (big_sai_id, big_year, big_mty_id),
  CONSTRAINT c_fk_big_sai_id FOREIGN KEY (big_sai_id) REFERENCES datawg.t_sampinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_big_mty_id FOREIGN KEY (big_mty_id) REFERENCES "ref".tr_mesuretype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_big_qal_id FOREIGN KEY (big_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_big_dts_datasource FOREIGN KEY (big_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
)
;

-- Add trigger on last_update
CREATE OR REPLACE FUNCTION datawg.big_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.big_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_big_last_update ON datawg.t_biometrygroup_big ;
CREATE TRIGGER update_big_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_biometrygroup_big FOR EACH ROW EXECUTE FUNCTION  datawg.big_last_update();

-- trigger check that only group measures are used

CREATE OR REPLACE FUNCTION datawg.big_mty_is_group()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.big_mty_id;

    IF (the_mty_type <> 'Group') THEN
    RAISE EXCEPTION 'table t_biometrygroup_big, Measure --> % is not a group measure', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_big_mty_is_group ON datawg.t_biometrygroup_big;
CREATE TRIGGER check_big_mty_is_group AFTER INSERT OR UPDATE ON
   datawg.t_biometrygroup_big FOR EACH ROW EXECUTE FUNCTION datawg.big_mty_is_group();

-- trigger check that only biometry measures are used

CREATE OR REPLACE FUNCTION datawg.big_mty_is_biometry()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_group TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_group , the_mty_name   
  mty_group, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.big_mty_id;

    IF (the_mty_type <> 'Biometry') THEN
    RAISE EXCEPTION 'table t_biometrygroup_big, Measure --> % is not a measure of biometry', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_big_mty_is_biometry ON datawg.t_biometrygroup_big;
CREATE TRIGGER check_big_mty_is_quality AFTER INSERT OR UPDATE ON
   datawg.t_biometrygroup_big FOR EACH ROW EXECUTE FUNCTION datawg.big_mty_is_biometry();

 
/*
 * 
 * Table for quality of grouped data
 * 
 */

DROP TABLE IF EXISTS datawg.t_qualitygroup_qug;
CREATE TABLE datawg.t_qualitygroup_qug (  
  qug_id SERIAL PRIMARY KEY,
  qug_sai_id INTEGER,
  qug_year INTEGER,
  qug_mty_id INTEGER,
  qug_value NUMERIC,
  qug_comment TEXT,
  qug_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  qug_qal_id int4, 
  qug_dts_datasource varchar(100),
  CONSTRAINT c_ck_uk_qug_sai UNIQUE (qug_sai_id, qug_year, qug_mty_id),
  CONSTRAINT c_fk_qug_sai_id FOREIGN KEY (qug_sai_id) REFERENCES datawg.t_sampinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_qug_mty_id FOREIGN KEY (qug_mty_id) REFERENCES "ref".tr_mesuretype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qug_qal_id FOREIGN KEY (qug_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qug_dts_datasource FOREIGN KEY (qug_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
) 
;

-- Add trigger on last_update
CREATE OR REPLACE FUNCTION datawg.qug_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.qug_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_qug_last_update ON datawg.t_qualitygroup_qug;
CREATE TRIGGER update_qug_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_qualitygroup_qug FOR EACH ROW EXECUTE FUNCTION  datawg.qug_last_update();


-- trigger check that only group measures are used

CREATE OR REPLACE FUNCTION datawg.qug_mty_is_group()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.qug_mty_id;

    IF (the_mty_type <> 'Group') THEN
    RAISE EXCEPTION 'table t_qualitygroup_qug, Measure --> % is not a group measure', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_qug_mty_is_group ON datawg.t_qualitygroup_qug;
CREATE TRIGGER check_qug_mty_is_group AFTER INSERT OR UPDATE ON
   datawg.t_qualitygroup_qug FOR EACH ROW EXECUTE FUNCTION datawg.qug_mty_is_group();

-- trigger check that only quality measures are used

CREATE OR REPLACE FUNCTION datawg.qug_mty_is_quality()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_group TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_group , the_mty_name   
  mty_group, mty_name FROM NEW 
  JOIN REF.tr_mesuretype_mty ON mty_id=NEW.qug_mty_id;

    IF (the_mty_type <> 'Quality') THEN
    RAISE EXCEPTION 'table t_qualitygroup_qug, Measure --> % is not a measure of quality', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_qug_mty_is_biometry ON datawg.t_qualitygroup_qug;
CREATE TRIGGER check_qug_mty_is_quality AFTER INSERT OR UPDATE ON
   datawg.t_qualitygroup_qug FOR EACH ROW EXECUTE FUNCTION datawg.qug_mty_is_biometry();
   
   
   
   
------------
-- fix issue 189
-- TO BE RUN
------------
begin;
-- deprecate wrong missing values that create duplicates
update datawg.t_eelstock_eel set eel_qal_id =21 where eel_id in(521655,436466,436467,486606,486607,486608,486609,486610,486611);

--set qal_id = 1 for NP, NC, NR...
update datawg.t_eelstock_eel set eel_qal_id =1 where eel_qal_id =0 and (eel_missvaluequal is not null);

--add a constraint to avoid having new duplicates
ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT ck_qal_id_and_missvalue CHECK ((eel_missvaluequal IS NULL) or (eel_qal_id != 0));
commit;


------------
-- fix issue 201 (emu for NL)
-- TO BE RUN
--		TODO: add a comment in eel_qal_comment? (NOT overwritten, coalesce)
------------

--		Correcting Netherland: NL_Neth, NL_total (without geom)
--		Correct the EMU in t_eelstock_eel table because always the EMU appears as NL_total
-- select count(*) from datawg.t_eelstock_eel where eel_cou_code = 'NL';					-- 1354
begin; 		
update datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'NL_total', 'NL_Neth');
--		Droping 'NL_total' (without geom)
delete from ref.tr_emu_emu where emu_nameshort = 'NL_total';								-- It works!
commit;


------------
-- fix issue 126 (EMU_total and EMU_country)
-- TO BE RUN
--		TODO: add a comment in eel_qal_comment? (NOT overwritten, coalesce)
------------

--		Correcting Finland: 'FI_Finl', 'FI_total' (without geom)
-- select count(*) from datawg.t_eelstock_eel where eel_cou_code = 'FI'; 									-- 631 rows
BEGIN;
update datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'FI_total', 'FI_Finl');
--		Droping 'FI_total' (without geom)
delete from ref.tr_emu_emu where emu_nameshort = 'FI_total';
COMMIT;

-- 		When the whole country corresponds to one single EMU, '%_total' is replaced by the first three letters of the country
select emu_nameshort from ref.tr_emu_emu where emu_nameshort like '%_total' and geom is not null; 		-- 20 rows
select distinct eel_emu_nameshort from datawg.t_eelstock_eel where eel_emu_nameshort in 
	(select emu_nameshort from ref.tr_emu_emu where emu_nameshort like '%_total' and geom is not null) 	-- AL, DZ, EG, HR, MA, NO, SI, TN, TR

--		(in the main table of EMUs and t_eelstock_eel table)
--			AL_total	Albania (Alb)
BEGIN;
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'AL_total', 'AL_Alb');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'AL_total', 'AL_Alb');
--			AX_total	Aland (Ala)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'AX_total', 'AX_Ala');
--			BA_total	Bosnia-Herzegovina (Bih)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'BA_total', 'BA_Bos');
--			CY_total	Cyprus (Cyp)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'CY_total', 'CY_Cyp');
-- 			DZ_total 	Algeria (Dza)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'DZ_total', 'DZ_Alg');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'DZ_total', 'DZ_Alg');
-- 			EG_total	Egypt (Egy)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'EG_total', 'EG_Egy');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'EG_total', 'EG_Egy');
-- 			HR_total	Croatia (Hrv)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'HR_total', 'HR_Cro');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'HR_total', 'HR_Cro');
--			IL_total	Israel (Isr)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'IL_total', 'IL_Isr');
--			IS_total	Iceland (Isl)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'IS_total', 'IS_Isl');
--			LB_total	Lebanon (Lbn)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'LB_total', 'LB_Leb');
--			LY_total	Libya (Lby)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'LY_total', 'LY_Lib');
-- 			MA_total	Morocco (Mar)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'MA_total', 'MA_Mor');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'MA_total', 'MA_Mor');
--			ME_total	Montenegro (Mne)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'ME_total', 'ME_Mon');
--			MT_total	Malta (Mlt)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'MT_total', 'MT_Mal');
-- 			NO_total	Norway (Nor)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'NO_total', 'NO_Nor');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'NO_total', 'NO_Nor');
--			RU_total	Russia (Rus)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'RU_total', 'RU_Rus');
--			SI_total	Slovenia (Svn)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'SI_total', 'SI_Slo');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'SI_total', 'SI_Slo');
--			SY_total	Syria (Syr)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'SY_total', 'SY_Syr');
--			TN_total	Tunisia (Tun)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'TN_total', 'TN_Tun');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'TN_total', 'TN_Tun');
-- 			TR_total	Turkey (Tur)
UPDATE ref.tr_emu_emu SET emu_nameshort = REPLACE (emu_nameshort, 'TR_total', 'TR_Tur');
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'TR_total', 'TR_Tur');
COMMIT;
