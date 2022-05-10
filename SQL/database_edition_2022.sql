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
 mty_group TEXT CHECK (mty_group='quality' OR mty_group='biometry'), -- this will be used in triggers later
 mty_uni_code varchar(20),
 CONSTRAINT c_fk_uni_code FOREIGN KEY (mty_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE
 );
 
  /* REMOVE THIS COMMENT LATER JUST FOR KEEPING INFO
  bii_lengthmm numeric,
  bii_weightg numeric,
  bii_age numeric,
  bii_eye_diam_horizontal  numeric, --in mm
  bii_eye_diam_vertical numeric, --in mm
  bii_pectoral_fin_length NUMERIC, --in mm
  qui_percentagelipidcontent NUMERIC,
  qui_contaminant,
  bii_anguillicolaprevalence numeric,
  bii_anguillicolameanintensity numeric,
  */
 
  
 
/*
 * CREATE A TABLE TO STORE BIOMETRY ON INDIVIDUAL DATA
 * HERE set as wgs84 do we set this in 3035 ?
 * NOT TESTED YET
 */
DROP TABLE IF EXISTS datawg.t_sampinginfo_sai;
CREATE TABLE datawg.t_sampinginfo_sai(
  sai_id serial PRIMARY KEY,
  sai_cou_code VARCHAR(2),
  sai_emu_nameshort VARCHAR(20),
  sai_area_division VARCHAR(254),
  --SOME DISCUSSION NEEDED THERE --------------------
  sai_comment TEXT, 
  sai_year INTEGER,
  sai_samplingobjective TEXT,
  sai_metadata TEXT,
  sai_qal_id INTEGER,
  sai_lastupdate DATE NOT NULL DEFAULT CURRENT_DATE,
  sai_dts_datasource VARCHAR(100),
  CONSTRAINT c_fk_sai_qal_id FOREIGN KEY (sai_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_cou_code FOREIGN KEY (sai_cou_code) REFERENCES "ref".tr_country_cou(cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_emu FOREIGN KEY (sai_emu_nameshort,sai_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_area_division FOREIGN KEY (sai_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sai_dts_datasource FOREIGN KEY (sai_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE
);

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
--TODO add trigger on last_update

 
CREATE TABLE  datawg.t_fishseries_fiser(
fiser_ser_id INTEGER NOT NULL, --CHECK WITH HILAIRE NOT REALLY SURE WE NEED THIS 
fiser_year INTEGER NOT NULL,
CONSTRAINT c_fk_fiser_ser_id FOREIGN KEY (fiser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE
)
INHERITS (datawg.t_fish_fi);
-- TODO ADD TRIGGER TO SEE IF DATA ARE PRESENT IN datawg.t_dataseries_das IN THAT YEAR 
-- TODO add trigger extract(year FROM fi_date)=fiser_yera

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

-- TODO trigger  length, weight, age, eyediameter,pectoral_fin with bounds
-- TODO ADD TRIGGER TO CHECK THAT QUALITY IS NOT INTEGRATED IN THIS TABLE
--TODO add trigger on last_update
/*
 * TABLE OF QUALITY MEASUREMENTS this table has exactly the same structure as t_biometry_bii 
 * FOR THE SAKE OF SIMPLICIY WE DON't SET INHERITANCE
 * 
 */
DROP TABLE IF EXISTS  datawg.t_qualityind_qui;
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

-- TODO trigger check that prevalence is not collected at the individual level
-- TODO ADD TRIGGER TO CHECK THAT BIOMETRY IS NOT INTEGRATED IN THIS TABLE ()
--TODO add trigger on last_update
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

--TODO add trigger on last_update

-- Group information for samples, should contain information for both yellow and silver eel
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

--TODO add trigger on last_update
-- TODO ADD TRIGGER TO CHECK THAT BIOMETRY IS NOT INTEGRATED IN THIS TABLE

