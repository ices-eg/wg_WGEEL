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
DROP TABLE IF EXISTS datawg.t_samplinginfo_sai CASCADE;
CREATE TABLE datawg.t_samplinginfo_sai(
  sai_id serial PRIMARY KEY,
  sai_name VARCHAR(20),
  sai_cou_code VARCHAR(2),
  sai_emu_nameshort VARCHAR(20),
  sai_locationdescription VARCHAR(254),
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
  CONSTRAINT c_fk_sai_hty_code FOREIGN KEY (sai_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE
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
CREATE OR REPLACE FUNCTION datawg.fiser_year()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
 
  BEGIN
   
    IF NOT (NEW.fis_year in (EXTRACT(YEAR FROM NEW.fi_date), EXTRACT(YEAR FROM NEW.fi_date)-1)) THEN
      RAISE EXCEPTION 'table t_fisheries_fiser, column fi_year does not match the date of fish collection (table t_fish_fi)' ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

DROP TRIGGER IF EXISTS check_year_and_date ON datawg.t_fishseries_fiser ;
CREATE TRIGGER check_year_and_date AFTER INSERT OR UPDATE ON
   datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fiser_year();

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
  inpolygon coalesce(st_contains(geom,st_point(new.fisa_x_4326, new.fisa_y_4326, 4326)), true) FROM  
  datawg.t_samplinginfo_sai
  JOIN REF.tr_emu_emu ON emu_nameshort=sai_emu_nameshort where new.fisa_sai_id = sai_id;
  IF (inpolygon = false) THEN
    RAISE EXCEPTION 'the fish % coordinates do not fall into the corresponding emu', new.fi_id ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

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
commit;
ALTER ROLE wgeel WITH PASSWORD 'wgeel_2021'

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
eel_qal_comment = 'deprecated' where eel_emu_nameshort ='ES_Spai';
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
(select 'DK_Mari' emu_nameshort,'Danish coastal and marine waters' emu_name,e.emu_cou_code,e.emu_hyd_syst_s,e.emu_sea,e.emu_cty_id,e.meu_dist_sargasso_km from ref.tr_emusplit_ems e where e.emu_nameshort ='DK_Inla')

commit; 



-- fix problem with table sampling_gear
GRANT ALL ON TABLE REF.tr_gear_gea TO wgeel;


----
--preparation for data integration
----
insert into ref.tr_quality_qal values (22, 'discarded_wgeel_2022', 'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2022', false);
insert into ref.tr_datasource_dts values ('dc_2022', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2022');





)
