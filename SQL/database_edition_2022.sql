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
  * TABLE OF METRICS TYPE, CORRESPONDS TO BOTH individual and quality metrics
  * 
  * 
  */ 

----
-- first integrate new units
----
--SELECT * FROM ref.tr_units_uni
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('mm','milimeter');
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('percent','percentage');
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('ng/g','nanogram per gram');
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('nr year','number of years');
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('g','gram');
INSERT INTO ref.tr_units_uni (uni_code, uni_name) VALUES ('wo','without unit');


DROP TABLE IF EXISTS ref.tr_metrictype_mty CASCADE;
 CREATE TABLE ref.tr_metrictype_mty(
 mty_id serial PRIMARY KEY,
 mty_name TEXT,
 mty_individual_name TEXT UNIQUE,
 mty_description TEXT,
 mty_type TEXT , -- this will be used in triggers later
 mty_method TEXT,
mty_uni_code varchar(20), 
 mty_group TEXT, -- this will be used in triggers later
 mty_min NUMERIC,
 mty_max NUMERIC,
 CONSTRAINT c_fk_uni_code FOREIGN KEY (mty_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE,
 CONSTRAINT c_ck_mty_type CHECK (mty_type='quality' OR mty_type='biometry' OR mty_type='migration'),
 CONSTRAINT c_ck_mty_group CHECK (mty_group='individual' OR mty_group='group' OR mty_group='both')
 );
 
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_individual_name IS 'In datacall spreadsheets, names replaced by those for better reading';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_group IS 'Indicate whether the variable can be use for individual, group, or both';
GRANT ALL ON TABLE ref.tr_metrictype_mty TO wgeel;

--see database_edition_2022.R
-- the TABLE CONTENT IS CREATED BY LLINES
/*

tr_metrictype_mty_temp <- readxl::read_excel("C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2022/WKEELDATA4/tr_metrictype_mty.xlsx")
dbExecute(con, "DROP TABLE IF EXISTS tr_metrictype_mty_temp")
dbWriteTable(con,"tr_metrictype_mty_temp",tr_metrictype_mty_temp, overwrite=TRUE)

dbSendQuery(con, "INSERT INTO ref.tr_metrictype_mty SELECT * FROM tr_metrictype_mty_temp")
dbExecute(con, "DROP TABLE tr_metrictype_mty_temp")
 
 */
 
/*
 * CREATE A TABLE TO STORE BIOMETRY ON INDIVIDUAL DATA

 */

--ALTER TABLE datawg.t_samplinginfo_sai ALTER COLUMN sai_name TYPE VARCHAR(40);
DROP TABLE IF EXISTS datawg.t_samplinginfo_sai CASCADE;
CREATE TABLE datawg.t_samplinginfo_sai(
  sai_id serial PRIMARY KEY,
  sai_name VARCHAR(40),
  sai_cou_code VARCHAR(2),
  sai_emu_nameshort VARCHAR(20),
  sai_area_division VARCHAR(254),
  sai_hty_code varchar(2),
  sai_comment TEXT, -- this could be DCF ... other CHECK IF we need a referential TABLE....
  sai_samplingobjective TEXT,
  sai_samplingstrategy TEXT,
  sai_protocol TEXT,
  sai_qal_id INTEGER, 
  sai_lastupdate DATE NOT NULL DEFAULT CURRENT_DATE,
  sai_dts_datasource VARCHAR(100),
  CONSTRAINT c_fk_sai_qal_id FOREIGN KEY (sai_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
   CONSTRAINT c_fk_sai_cou_code FOREIGN KEY (sai_cou_code) REFERENCES "ref".tr_country_cou(cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_emu FOREIGN KEY (sai_emu_nameshort,sai_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_area_division FOREIGN KEY (sai_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_dts_datasource FOREIGN KEY (sai_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_hty_code FOREIGN KEY (sai_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_uk_sai_name UNIQUE (sai_name)
);
GRANT ALL ON TABLE datawg.t_samplinginfo_sai TO wgeel;
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
   datawg.t_samplinginfo_sai FOR EACH ROW EXECUTE FUNCTION datawg.sai_lastupdate();

/*
 * 
 * Fish are related to either a sampling or a series
 * the table for fish is created and two tables with additional information relate to it
 * the first 
 */
DROP TABLE  if exists datawg.t_fish_fi CASCADE;
CREATE TABLE datawg.t_fish_fi(
  fi_id SERIAL PRIMARY KEY,
  fi_date DATE NOT NULL,
  fi_year INTEGER,
  fi_comment TEXT,
  fi_lastupdate DATE NOT NULL DEFAULT CURRENT_DATE,
  fi_dts_datasource varchar(100),
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
DROP TABLE IF EXISTS  datawg.t_fishseries_fiser CASCADE;
CREATE TABLE  datawg.t_fishseries_fiser(
  fiser_ser_id INTEGER NOT NULL,  
  CONSTRAINT t_fishseries_fiser_pkey PRIMARY KEY (fi_id),
  CONSTRAINT c_fk_fiser_ser_id FOREIGN KEY (fiser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE
)
INHERITS (datawg.t_fish_fi);

ALTER TABLE datawg.t_fishseries_fiser ADD CONSTRAINT  c_fk_fiser_dts_datasource 
FOREIGN KEY (fi_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;

-- because of seasons (glass eel and silver), years can match the date of collection
-- or the previous year

/*
 * DROP function if exists datawg.fiser_year CASCADE
 * 
 * 
 */


CREATE OR REPLACE FUNCTION datawg.fi_year()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
 
  BEGIN
   
    IF NOT (NEW.fi_year in (EXTRACT(YEAR FROM NEW.fi_date), EXTRACT(YEAR FROM NEW.fi_date)-1, EXTRACT(YEAR FROM NEW.fi_date)+1)) THEN
      RAISE EXCEPTION 'table t_fisheries_fiser, column fi_year % does not match the date of fish collection % (table t_fish_fi)', NEW.fi_year,NEW.fi_date ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_year_and_date ON datawg.t_fishseries_fiser ;
CREATE TRIGGER check_year_and_date AFTER INSERT OR UPDATE ON
   datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fi_year();

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON
   datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();

/*
* HERE set as wgs84 
*/
DROP TABLE IF EXISTS  datawg.t_fishsamp_fisa CASCADE;
CREATE TABLE  datawg.t_fishsamp_fisa(
fisa_sai_id INTEGER,
fisa_lfs_code varchar(2) NOT NULL, 
fisa_x_4326 NUMERIC NOT NULL,
fisa_y_4326 NUMERIC NOT NULL,
fisa_geom geometry(point, 4326),
CONSTRAINT c_fk_fisa_lfs_code FOREIGN KEY (fisa_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
CONSTRAINT t_fishseries_fisa_pkey PRIMARY KEY (fi_id),
CONSTRAINT c_fk_fisa_sai_id FOREIGN KEY (fisa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE RESTRICT
)
INHERITS (datawg.t_fish_fi);


ALTER TABLE datawg.t_fishsamp_fisa ADD CONSTRAINT  c_fk_fisa_dts_datasource 
FOREIGN KEY (fi_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON
   datawg.t_fishsamp_fisa FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();
  
/*
 * TABLE OF INDIVIDUAL METRICS
 * I put a DELETE cascade on the table so if a fish is removed all biometries and qualities attached are dropped
 * 
 */  
  
DROP TABLE IF EXISTS datawg.t_metricind_mei CASCADE;
CREATE TABLE datawg.t_metricind_mei (
  mei_id serial PRIMARY KEY,
  mei_fi_id INTEGER not null,  
  mei_mty_id INTEGER not null,
  mei_value NUMERIC not null,
  mei_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  mei_qal_id INTEGER, 
  mei_dts_datasource varchar(100),
  CONSTRAINT c_fk_mei_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fish_fi(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_mei_mty_id FOREIGN KEY (mei_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_mei_qal_id FOREIGN KEY (mei_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_mei_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
)
;


DROP TABLE IF EXISTS datawg.t_metricindsamp_meisa CASCADE;
CREATE TABLE datawg.t_metricindsamp_meisa (
  CONSTRAINT c_fk_meisa_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishsamp_fisa(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_meisa_mty_id FOREIGN KEY (mei_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meisa_qal_id FOREIGN KEY (mei_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meisa_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
) inherits  (datawg.t_metricind_mei)
;

DROP TABLE IF EXISTS datawg.t_metricindseries_meiser CASCADE;
CREATE TABLE datawg.t_metricindseries_meiser (
  CONSTRAINT c_fk_meiser_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishseries_fiser(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_meiser_mty_id FOREIGN KEY (mei_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meiser_qal_id FOREIGN KEY (mei_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meiser_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
) inherits  (datawg.t_metricind_mei)
;



DROP TABLE IF EXISTS datawg.t_metricindsamp_meisa CASCADE;
CREATE TABLE datawg.t_metricindsamp_meisa (
  CONSTRAINT c_fk_meisa_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishsamp_fisa(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_meisa_mty_id FOREIGN KEY (mei_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meisa_qal_id FOREIGN KEY (mei_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meisa_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
) inherits (datawg.t_metricind_mei)
;



DROP TABLE IF EXISTS datawg.t_metricindseries_meiser CASCADE;
CREATE TABLE datawg.t_metricindseries_meiser (
  CONSTRAINT c_fk_meiser_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishseries_fiser(fi_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_meiser_mty_id FOREIGN KEY (mei_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meiser_qal_id FOREIGN KEY (mei_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meiser_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
) inherits (datawg.t_metricind_mei)
;




-- Add trigger on last_update
CREATE OR REPLACE FUNCTION datawg.mei_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.mei_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_mei_last_update ON datawg.t_metricind_mei ;
CREATE TRIGGER update_mei_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_metricind_mei FOR EACH ROW EXECUTE FUNCTION  datawg.mei_last_update();

-- TODO trigger  length, weight, age, eyediameter,pectoral_fin with bounds

-- trigger check that only invividual metrics are used
CREATE OR REPLACE FUNCTION datawg.mei_mty_is_individual()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM REF.tr_metrictype_mty where mty_id=NEW.mei_mty_id;

    IF (the_mty_type == 'group') THEN
    RAISE EXCEPTION 'table t_metricind_mei, metric --> % is not an individual metric', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_mei_mty_is_individual ON datawg.t_metricind_mei;
CREATE TRIGGER check_mei_mty_is_individual AFTER INSERT OR UPDATE ON
   datawg.t_metricind_mei FOR EACH ROW EXECUTE FUNCTION datawg.mei_mty_is_individual();


CREATE OR REPLACE FUNCTION datawg.fish_in_emu()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE inpolygon bool;
  DECLARE fish integer;
  BEGIN
  
  SELECT INTO
  inpolygon coalesce(st_dwithin(geom::geography, st_setsrid(st_point(new.fisa_x_4326, new.fisa_y_4326),4326)::geography,10000), true) FROM  
  datawg.t_samplinginfo_sai
  JOIN REF.tr_emu_emu ON emu_nameshort=sai_emu_nameshort where new.fisa_sai_id = sai_id;
  IF (inpolygon = false) THEN
    RAISE EXCEPTION 'the fish % coordinates X % Y % do not fall into the corresponding emu', new.fi_id, new.fisa_x_4326,new.fisa_y_4326 ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

--SELECT PostGIS_Version()
-- note st_point(x,y, int) is only available in postgis 3.2 we have 3.1

GRANT ALL ON FUNCTION  datawg.fish_in_emu TO wgeel;

DROP TRIGGER IF EXISTS check_fish_in_emu ON datawg.t_fishsamp_fisa;
CREATE TRIGGER check_fish_in_emu AFTER INSERT OR UPDATE ON
   datawg.t_fishsamp_fisa FOR EACH ROW EXECUTE FUNCTION datawg.fish_in_emu();


-- datawg.t_group_gr definition

DROP TABLE if exists datawg.t_group_gr CASCADE;

CREATE TABLE datawg.t_group_gr (
	gr_id serial4 NOT NULL,
	gr_year int4,
	gr_number integer,
	gr_comment TEXT,
	gr_lastupdate date NOT NULL DEFAULT CURRENT_DATE,
	gr_dts_datasource varchar(100) NULL,
	CONSTRAINT t_group_go_pkey PRIMARY KEY (gr_id),
	CONSTRAINT c_fk_gr_dts_datasource FOREIGN KEY (gr_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
);


DROP TABLE if exists datawg.t_groupsamp_grsa;

CREATE TABLE datawg.t_groupsamp_grsa (
	grsa_sai_id int4 NULL,
	grsa_lfs_code varchar(2) NOT NULL,
	CONSTRAINT t_group_gsa_pkey PRIMARY KEY (gr_id),
        CONSTRAINT c_ck_uk_grsa_gr UNIQUE (grsa_sai_id, gr_year),
        CONSTRAINT c_fk_grsa_sai_id FOREIGN KEY (grsa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id),
        CONSTRAINT c_fk_grsa_lfs_code FOREIGN KEY (grsa_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE
)
INHERITS (datawg.t_group_gr);


DROP TABLE if exists datawg.t_groupseries_grser;
CREATE TABLE datawg.t_groupseries_grser (
	grser_ser_id int4 NOT NULL,
	CONSTRAINT t_group_gser_pkey PRIMARY KEY (gr_id),
	CONSTRAINT c_fk_grser_ser_id FOREIGN KEY (grser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT c_ck_uk_grser_gr UNIQUE (grser_ser_id, gr_year)
)
INHERITS (datawg.t_group_gr);




CREATE OR REPLACE FUNCTION datawg.gr_lastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.gr_lastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;


create trigger update_gr_lastupdate BEFORE insert  OR update on
    datawg.t_group_gr for each row execute function datawg.gr_lastupdate();
    
    
create trigger update_gr_lastupdate BEFORE insert  OR update on
    datawg.t_groupseries_grser for each row execute function datawg.gr_lastupdate(); 
  
      
create trigger update_gr_lastupdate BEFORE insert  OR update on
    datawg.t_groupsamp_grsa for each row execute function datawg.gr_lastupdate(); 

 
/*
 * table of individual metrics
 */

DROP TABLE IF EXISTS datawg.t_metricgroup_meg CASCADE;
CREATE TABLE datawg.t_metricgroup_meg (
  meg_id serial PRIMARY KEY,
  meg_gr_id INTEGER not null,
  meg_mty_id INTEGER not null,
  meg_value NUMERIC not null,
  meg_last_update DATE NOT NULL DEFAULT CURRENT_DATE,
  meg_qal_id int4, 
  meg_dts_datasource varchar(100),
  CONSTRAINT c_ck_uk_meg_gr UNIQUE (meg_gr_id, meg_mty_id),
  CONSTRAINT c_fk_meg_mty_id FOREIGN KEY (meg_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meg_qal_id FOREIGN KEY (meg_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meg_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE,
  CONSTRAINT c_fk_meg_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_group_gr(gr_id) ON UPDATE CASCADE ON DELETE CASCADE
) 
;

DROP TABLE IF EXISTS datawg.t_metricgroupseries_megser CASCADE;
CREATE TABLE datawg.t_metricgroupseries_megser (
  CONSTRAINT c_ck_uk_megser_gr UNIQUE (meg_gr_id, meg_mty_id),
  CONSTRAINT c_fk_megser_mty_id FOREIGN KEY (meg_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megser_qal_id FOREIGN KEY (meg_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megser_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megser_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_groupseries_grser(gr_id) ON UPDATE CASCADE ON DELETE CASCADE
) inherits (datawg.t_metricgroup_meg)
;


DROP TABLE IF EXISTS datawg.t_metricgroupsamp_megsa CASCADE;
CREATE TABLE datawg.t_metricgroupsamp_megsa (
  CONSTRAINT c_ck_uk_megsa_gr UNIQUE (meg_gr_id, meg_mty_id),
  CONSTRAINT c_fk_megsa_mty_id FOREIGN KEY (meg_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megsa_qal_id FOREIGN KEY (meg_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megsa_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE,
  CONSTRAINT c_fk_megsa_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_groupsamp_grsa(gr_id) ON UPDATE CASCADE ON DELETE CASCADE
) inherits (datawg.t_metricgroup_meg)
;


-- Add trigger on last_update
CREATE OR REPLACE FUNCTION datawg.meg_last_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.meg_last_update = now()::date;
    RETURN NEW; 
END;
$function$
;
DROP TRIGGER IF EXISTS update_meg_last_update ON datawg.t_metricgroup_meg ;
CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION  datawg.meg_last_update();

DROP TRIGGER IF EXISTS update_meg_last_update ON datawg.t_metricgroupseries_megser ;
CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_metricgroupseries_megser FOR EACH ROW EXECUTE FUNCTION  datawg.meg_last_update();

DROP TRIGGER IF EXISTS update_meg_last_update ON datawg.t_metricgroupsamp_megsa ;
CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON
  datawg.t_metricgroupsamp_megsa FOR EACH ROW EXECUTE FUNCTION  datawg.meg_last_update();


-- trigger check that only group metrics are used

CREATE OR REPLACE FUNCTION datawg.meg_mty_is_group()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM REF.tr_metrictype_mty where mty_id=NEW.meg_mty_id;

    IF (the_mty_type = 'individual') THEN
    RAISE EXCEPTION 'table t_metricgroup_meg, metric --> % is not a group metric', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_meg_mty_is_group ON datawg.t_metricgroup_meg;
CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON
   datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();

 DROP TRIGGER IF EXISTS check_meg_mty_is_group ON datawg.t_metricgroupseries_megser;
CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON
   datawg.t_metricgroupseries_megser FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();
 
 DROP TRIGGER IF EXISTS check_meg_mty_is_group ON datawg.t_metricgroupsamp_megsa;
CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON
   datawg.t_metricgroupsamp_megsa FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();

 
alter table  datawg.t_fish_fi owner to wgeel ;
alter table  datawg.t_fishsamp_fisa owner to wgeel ;
alter table  datawg.t_fishseries_fiser owner to wgeel ;
alter table  datawg.t_group_gr owner to wgeel ;
alter table  datawg.t_groupsamp_grsa owner to wgeel ;
alter table  datawg.t_groupseries_grser owner to wgeel ;
alter table  datawg.t_metricgroup_meg owner to wgeel ;
alter table  datawg.t_metricgroupsamp_megsa owner to wgeel ;
alter table  datawg.t_metricgroupseries_megser owner to wgeel ;
alter table  datawg.t_metricind_mei owner to wgeel ;
alter table  datawg.t_metricindsamp_meisa owner to wgeel ;
alter table  datawg.t_metricindseries_meiser owner to wgeel ;
alter table  datawg.t_samplinginfo_sai owner to wgeel ;






  
 

-----
-- proportion g_in_gy, it's a mess, currently info with Burr, Liff, info with Y => no use, info with G => no use
-----

 SELECT DISTINCT bis_g_in_gy FROM datawg.t_series_ser tss  JOIN 
            datawg.t_mei_series_bis tbsb ON tbsb.bis_ser_id = ser_id;
          
          
    
/*
 * |bis_g_in_gy|
|-----------|
|0          |
|99.1       |
|55.9       |
|76.7       |
|50         |
|53.2       |
|90.4       |
|72.9       |
|100        |
|           |
|95.5       |
|98.2       |
|97.6       |

 */

  SELECT ser_nameshort,bis_g_in_gy FROM datawg.t_series_ser tss  JOIN 
            datawg.t_biometry_series_bis tbsb ON tbsb.bis_ser_id = ser_id 
            WHERE bis_g_in_gy IS NOT NULL;
/*
 * |ser_nameshort|bis_g_in_gy|
|-------------|-----------|
|GirnY        |0          |
|GirnY        |0          |
|ShiMG        |100        |
|ShiMG        |100        |
|ShiMG        |100        |
|ShiMG        |100        |
|ShiMG        |100        |
|MondG        |100        |
|MondG        |100        |
|ShiFG        |100        |
|ShiFG        |100        |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|GirnY        |0          |
|BurrG        |97.6       |
|LiffGY       |72.9       |
|ShaAGY       |50         |
|BurrG        |95.5       |
|BurrG        |98.2       |
|BurrG        |76.7       |
|BurrG        |99.1       |
|LiffGY       |90.4       |
|VistY        |0          |
|OriY         |0          |
|VisY         |0          |
|MiScG        |100        |
|MiScG        |100        |
|MondG        |100        |
|MondG        |100        |
|LiffGY       |55.9       |
|LiffGY       |53.2       |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
|BidY         |0          |
   
 */   
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
commit;--3710 29/08
ALTER ROLE wgeel WITH PASSWORD 'wgeel_2022'; --2021

------------
-- fix issue 201 (emu for NL)
-- TO BE RUN
--		TODO: add a comment in eel_qal_comment? (NOT overwritten, coalesce)
------------

--		Correcting Netherland: NL_Neth, NL_total (without geom)
--		Correct the EMU in t_eelstock_eel table because always the EMU appears as NL_total
-- select count(*) from datawg.t_eelstock_eel where eel_cou_code = 'NL';					-- 1354

-- NL_NEth, FI_Fin MA_Mor 


begin; 		

UPDATE ref.tr_emu_emu  SET
emu_wholecountry = TRUE
 WHERE  emu_nameshort IN ('FI_Finl','NL_Neth'); --2
 ALTER TABLE datawg.t_eelstock_eel DROP CONSTRAINT ck_emu_whole_aquaculture;
 CREATE OR REPLACE FUNCTION checkemu_whole_country(emu text) RETURNS boolean AS $$
declare
exist boolean;
begin
 exist:=false;
 perform * from ref.tr_emu_emu where emu_nameshort=emu and emu_wholecountry=true;
 exist:=FOUND;
 RETURN exist;
end
$$ LANGUAGE plpgsql IMMUTABLE STRICT; 

ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT ck_emu_whole_aquaculture CHECK (eel_qal_id!=1 or eel_typ_id != 11 or checkemu_whole_country(eel_emu_nameshort));

update datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'NL_total', 'NL_Neth'); --78418
--		Droping 'NL_total' (without geom)
delete from ref.tr_emu_emu where emu_nameshort = 'NL_total';	--1							-- It works!
commit;
rollback

------------
-- fix issue 126 (EMU_total and EMU_country)
-- TO BE RUN
--		TODO: add a comment in eel_qal_comment? (NOT overwritten, coalesce)
------------

--		Correcting Finland: 'FI_Finl', 'FI_total' (without geom)
-- select count(*) from datawg.t_eelstock_eel where eel_cou_code = 'FI'; 									-- 631 rows



--SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code='FI' AND  eel_lfs_code='QG' AND eel_typ_id =8 ORDER BY eel_year, eel_hty_code
--SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort='FI_Finl' AND  eel_lfs_code='QG' AND eel_typ_id =8 ORDER BY eel_year, eel_hty_code
--SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code='FI' AND eel_typ_id =9 ORDER BY eel_year, eel_hty_code
-
BEGIN;
-- remove duplicates
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment)=(21, 'remove duplicates') WHERE eel_emu_nameshort='FI_Finl' AND  eel_lfs_code='QG' AND eel_typ_id =8; --20
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment)=(21, 'remove duplicates') WHERE eel_emu_nameshort='FI_Finl' AND  eel_lfs_code='QG' AND eel_typ_id =9; --20

UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = REPLACE (eel_emu_nameshort, 'FI_total', 'FI_Finl'); --78418

--		Droping 'FI_total' (without geom)
delete from ref.tr_emu_emu where emu_nameshort = 'FI_total'; --78418
COMMIT;

-- 		When the whole country corresponds to one single EMU, '%_total' is replaced by the first three letters of the country
select emu_nameshort from ref.tr_emu_emu where emu_nameshort like '%_total' and geom is not null; 		-- 20 rows
select distinct eel_emu_nameshort from datawg.t_eelstock_eel where eel_emu_nameshort in 
	(select emu_nameshort from ref.tr_emu_emu where emu_nameshort like '%_total' and geom is not null) 	-- AL, DZ, EG, HR, MA, NO, SI, TN, TR

	
/*
 *  NOT RUN : this is not the emu names in templates
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
*/




--------
--fix issue #178
---------
begin;
UPDATE ref.tr_emusplit_ems SET geom = sub.geom FROM
(SELECT st_collect(geom) AS geom FROM ref.tr_emusplit_ems WHERE emu_nameshort IN ('ES_Inne', 'ES_Spai')) sub
WHERE emu_nameshort = 'ES_Inne';
DELETE FROM ref.tr_emusplit_ems WHERE emu_nameshort = 'ES_Spai';


--merge ES_Spai and ES_Inne polygons
UPDATE ref.tr_emu_emu SET geom = sub.geom FROM
(SELECT st_union(geom) AS geom FROM ref.tr_emu_emu WHERE emu_nameshort IN ('ES_Inne', 'ES_Spai')) sub
WHERE emu_nameshort = 'ES_Inne';
-- deprecate all ES_Spai data
update datawg.t_eelstock_eel set eel_qal_id  = 21,
eel_qal_comment = 'Was ES_Spai so deprecated' where eel_emu_nameshort ='ES_Spai';
-- assign ES_Spai to ES_Inne
update datawg.t_eelstock_eel set eel_emu_nameshort ='ES_Inne' where eel_emu_nameshort ='ES_Spai';
--remove ES_Spai
DELETE FROM ref.tr_emu_emu WHERE emu_nameshort = 'ES_Spai';
commit;

----
--fix issue 187
-------
begin;
insert into ref.tr_emu_emu (emu_nameshort,emu_name,emu_cou_code,emu_wholecountry) values('DK_Mari','Danish coastal and marine waters','DK',FALSE);
SELECT setval(pg_get_serial_sequence('ref.tr_emusplit_ems', 'gid'), COALESCE((SELECT MAX(gid) + 1 FROM ref.tr_emusplit_ems), 1), false);
insert into ref.tr_emusplit_ems (emu_nameshort,emu_name,emu_cou_code,emu_hyd_syst_s,emu_sea,emu_cty_id ,meu_dist_sargasso_km)
(select 'DK_Mari' emu_nameshort,'Danish coastal and marine waters' emu_name,e.emu_cou_code,e.emu_hyd_syst_s,e.emu_sea,e.emu_cty_id,e.meu_dist_sargasso_km 
from ref.tr_emusplit_ems e 
where e.emu_nameshort ='DK_Inla')

commit; 



-- fix problem with table sampling_gear
GRANT ALL ON TABLE REF.tr_gear_gea TO wgeel;


----
--preparation for data integration
----
insert into ref.tr_quality_qal values (22, 'discarded_wgeel_2022', 'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2022', false);
insert into ref.tr_datasource_dts values ('dc_2022', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2022');

SELECT tdd.* FROM datawg.t_dataseries_das tdd JOIN
datawg.t_series_ser tss ON tdd.das_ser_id= tss.ser_id WHERE 
ser_nameshort='EmsBGY' ORDER BY das_year


-- 29/08/2022 Execution of script till there on wgeel distant database



--change the trigger to allow missing coordinates
CREATE OR REPLACE FUNCTION datawg.fish_in_emu()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE inpolygon bool;
  DECLARE fish integer;
  BEGIN
  if (new.fisa_y_4326 is null and new.fisa_x_4326 is null) then
  	return new;
  end if;

  SELECT INTO
  inpolygon coalesce(st_dwithin(geom::geography, st_setsrid(st_point(new.fisa_x_4326,new.fisa_y_4326),4326)::geography,10000), true) FROM
  datawg.t_samplinginfo_sai
  JOIN REF.tr_emu_emu ON emu_nameshort=sai_emu_nameshort where new.fisa_sai_id = sai_id;
  IF (inpolygon = false) THEN
    RAISE EXCEPTION 'the fish % coordinates do not fall into the corresponding emu', new.fi_id ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;


alter table datawg.t_fishsamp_fisa  alter column fisa_x_4326 drop not null;
alter table datawg.t_fishsamp_fisa  alter column fisa_y_4326 drop not null;



-- 30/08/2022 Execution of script till there on wgeel distant database



ALTER TABLE datawg.t_samplinginfo_sai  ADD CONSTRAINT ch_unique_sai_name UNIQUE (sai_name);

ALTER TABLE datawg.t_fish_fi  ADD column fi_lfs_code varchar(2);
alter table datawg.t_fish_fi add constraint c_fk_fi_lfs_code FOREIGN KEY (fi_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE cascade
alter table datawg.t_fishsamp_fisa drop column fisa_lfs_code;
alter table datawg.t_fish_fi  alter column fi_year drop not null;
alter table datawg.t_fish_fi  alter column fi_date drop not null;
alter table datawg.t_fish_fi  add constraint ck_fi_date_fi_year check (fi_date is not null or fi_year is not null);


-- 31/08/2022 Execution of script till here on wgeel distant database
update datawg.t_samplinginfo_sai set sai_name='DE_Eide_Eider_HIST' where sai_name='DE_Elbe_Eider_HIST'; --fix incorrect name for an old sampling in DE

-- 01/09/2022 Execution of script till here on wgeel distant database

begin;

--Ireland


--72 rows deleted
update datawg.t_metricgroupsamp_megsa set meg_qal_id =22 where meg_gr_id in (2195,2196,2197,2198,2199,2201,2202,2203,2204,2205,2206,2207,2208,2209,2210,2212,2213,2214,2215,2216,2217,2218,2219,2220,2221,2260,2261);
--27 rows updated
update datawg.t_groupsamp_grsa set gr_comment ='all related metrics have qal_id=22 following data call 2022' where gr_id in (2195,2196,2197,2198,2199,2201,2202,2203,2204,2205,2206,2207,2208,2209,2210,2212,2213,2214,2215,2216,2217,2218,2219,2220,2221,2260,2261);

--GB
--48 rows deleted
update datawg.t_metricgroupsamp_megsa set meg_qal_id =22 where meg_gr_id in (2176,2177,2179,2180,2181,2182,2183,2169,2170,2171,2172,2173,2174,2175,2184,2185,2186,2187,2188,2190,2191,2192,2193,2194);
--24 rows updated
update datawg.t_groupsamp_grsa set gr_comment ='all related metrics have qal_id=22 following data call 2022' where gr_id in (2176,2177,2179,2180,2181,2182,2183,2169,2170,2171,2172,2173,2174,2175,2184,2185,2186,2187,2188,2190,2191,2192,2193,2194);


--DE
--34 rows deleted
update datawg.t_metricgroupsamp_megsa set meg_qal_id =22 where meg_gr_id in (2323,2334,2167,2222,2189,2200,2211,2178,2233,2244);
--10 rows updated
update datawg.t_groupsamp_grsa set gr_comment ='all related metrics have qal_id=22 following data call 2022' where gr_id in (2323,2334,2167,2222,2189,2200,2211,2178,2233,2244);

commit;




alter table datawg.t_fish_fi add column fi_lfs_code varchar(2);
ALTER TABLE datawg.t_fish_fi ADD CONSTRAINT c_fk_fi_lfs_code FOREIGN KEY (fi_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE cascade;
alter table datawg.t_fishsamp_fisa ADD CONSTRAINT ck_fi_lfs_code CHECK (fi_lfs_code IS NOT NULL);
update datawg.t_fishsamp_fisa set fi_lfs_code=fisa_lfs_code;
alter table datawg.t_fishsamp_fisa drop column fisa_lfs_code;

-- 06/09/2022 Execution of script till here on wgeel distant database

CREATE OR REPLACE FUNCTION datawg.fi_year()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
 
  BEGIN
   
    IF NOT (NEW.fi_year in (EXTRACT(YEAR FROM NEW.fi_date), EXTRACT(YEAR FROM NEW.fi_date)-1)) THEN
      RAISE EXCEPTION 'table t_fisheries_fiser, column fi_year does not match the date of fish collection (table t_fish_fi)' ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_year_and_date ON datawg.t_fishseries_fiser ;
CREATE TRIGGER check_year_and_date AFTER INSERT OR UPDATE ON
   datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fi_year();

--IT
--26 rows deleted
update datawg.t_metricgroupsamp_megsa set meg_qal_id =22 where meg_gr_id in (2262,2266,2272,2273,2274,2267,2268,2270,2271); 
--9 rows updated
update datawg.t_groupsamp_grsa set gr_comment ='all related metrics have qal_id=22 following data call 2022' where gr_id in (2262,2266,2272,2273,2274,2267,2268,2270,2271);


alter table datawg.t_groupsamp_grsa drop constraint c_ck_uk_grsa_gr;
ALTER TABLE datawg.t_groupsamp_grsa ADD CONSTRAINT c_ck_uk_grsa_gr UNIQUE (grsa_sai_id, gr_year, grsa_lfs_code);
--run during wgeel

--- problem with the db t_dataseries_das deleted

SELECT count(*), ser_cou_code FROM datawg.t_dataseries_das JOIN datawg.t_series_ser ON das_ser_id=ser_id 
GROUP by ser_cou_code
/*
|count|ser_cou_code|
|-----|------------|
|1    |PL          |
|10   |DK          |
|10   |LT          |
|4    |PT          |
|153  |NO          |
|16   |LV          |
|42   |GR          |
|3    |FI          |
|81   |BE          |
|9    |IE          |
*/
SELECT count(*) FROM datawg.t_dataseries_das; --329

-- old database 0609

CREATE TABLE temp_dataseries AS SELECT * FROM datawg.t_dataseries_das; --5621
SELECT count(*), ser_cou_code FROM datawg.t_dataseries_das JOIN datawg.t_series_ser ON das_ser_id=ser_id 
GROUP by ser_cou_code
/*
|count|ser_cou_code|
|-----|------------|
|380  |IE          |
|74   |            |
|4    |PL          |
|200  |DK          |
|24   |LT          |
|505  |ES          |
|71   |PT          |
|188  |NO          |
|752  |FR          |
|32   |IT          |
|1 628|GB          |
|20   |LV          |
|498  |NL          |
|16   |GR          |
|870  |SE          |
|18   |FI          |
|93   |BE          |
|248  |DE          |
*/

-- pg_dump -U postgres -f "dataseries.sql" --table public.temp_dataseries wgeel0609
-- pg_dump -U postgres -f "dataserieslast.sql" --table datawg.t_dataseries_das -h 185.135.126.250 wgeel

CREATE TABLE temp_dataserieslast AS SELECT * FROM datawg.t_dataseries_das; --329


SELECT count(*) FROM temp_dataseries
SELECT * FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_id=t0.das_id); -- NO rows 

SELECT count(*) FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year) --279



SELECT * FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_value != t0.das_value) ; --34 rows


-- not working too many rows :
SELECT * FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_value != t0.das_value) OR (tt.das_comment != t0.das_comment); --50

SELECT * FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_effort != t0.das_effort); -- 0

SELECT * FROM temp_dataseries t0 JOIN datawg.t_dataseries_das tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_qal_id != t0.das_qal_id); --1 ROW


-- tempdataseries = database saved before wgeel
-- temp_dataserieslast = last state of t_dataseries_das

DELETE FROM datawg.t_dataseries_das;

WITH changed_values_old_id AS (
SELECT t0.das_id FROM temp_dataseries t0 JOIN temp_dataserieslast tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_value != t0.das_value) OR (tt.das_comment != t0.das_comment)
UNION
SELECT t0.das_id FROM temp_dataseries t0 JOIN temp_dataserieslast tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_qal_id != t0.das_qal_id) 
),

changed_values_to_keep AS (
SELECT tt.* FROM temp_dataseries t0 JOIN temp_dataserieslast tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_value != t0.das_value) OR (tt.das_comment != t0.das_comment)
UNION
SELECT tt.* FROM temp_dataseries t0 JOIN temp_dataserieslast tt ON
(tt.das_ser_id,tt.das_year)=(t0.das_ser_id, t0.das_year)
WHERE (tt.das_qal_id != t0.das_qal_id) 
)

INSERT INTO datawg.t_dataseries_das
SELECT * FROM  temp_dataseries WHERE das_id IN (
SELECT das_id FROM temp_dataseries 
EXCEPT 
SELECT das_id FROM changed_values_old_id) --5571
UNION 
SELECT * FROM changed_values_to_keep   --5621

COMMENT ON TABLE temp_dataseries IS 'dataseries before integration';
COMMENT ON TABLE temp_dataserieslast IS 'dataseries inserted during wgeel 2022 after the table was deleted';


-- Country that have not entered data yet
SELECT * FROM (
SELECT DISTINCT ser_cou_code, ser_typ_id FROM datawg.t_dataseries_das JOIN datawg.t_series_ser ON das_ser_id=ser_id WHERE ser_cou_code IS NOT NULL
EXCEPT
SELECT DISTINCT ser_cou_code, ser_typ_id FROM datawg.t_dataseries_das JOIN datawg.t_series_ser ON das_ser_id=ser_id 
WHERE das_dts_datasource = 'dc_2022'
GROUP by ser_cou_code, ser_typ_id) sub
ORDER BY ser_cou_code, ser_typ_id;



SELECT * FROM datawg.t_eelstock_eel WHERE eel_id =408546

SELECT e.* FROM datawg.t_eelstock_eel e JOIN
ref.tr_emu_emu ON eel_emu_nameshort = emu_nameshort 
WHERE emu_wholecountry!=TRUE
AND eel_typ_id=11 AND eel_qal_id=1;

SELECT emu_wholecountry FROM ref.tr_emu_emu WHERE emu_nameshort= 'IT_total'


-- correction constraint
ALTER TABLE datawg.t_eelstock_eel DROP CONSTRAINT ck_emu_whole_aquaculture
ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT ck_emu_whole_aquaculture CHECK (NOT(eel_qal_id=1 AND eel_typ_id = 11 AND NOT checkemu_whole_country(eel_emu_nameshort)));


