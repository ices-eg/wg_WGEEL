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
 * CREATE A TABLE TO STORE BIOMETRY ON INDIVIDUAL DATA
 * HERE set as wgs84 do we set this in 3035 ?
 * NOT TESTED YET
 */

CREATE TABLE datawg.t_biometry_indiv_bii (
  bii_id serial PRIMARY KEY,
  bii_cou_code varchar(2),
  bii_emu_nameshort varchar(20),
  bii_area_division varchar(254),
  bii_hty_code varchar(2),
  bii_latitude_4326 numeric,
  bii_longitude_4326 numeric,
  --bii_lfs_code varchar(2), -- this might be a problem FOR individual DATA (maybe correct later)
  bii_date date ,
  bii_lengthmm numeric,
  bii_weightg numeric,
  bii_age numeric,
  bii_eye_diam_horizontal  numeric, --in mm
  bii_eye_diam_vertical numeric, --in mm
  bii_pectoral_fin_length NUMERIC, --in mm
  bii_comment TEXT,
  bii_last_update date,
  --bii_qal_id int4, -- Do we want that AT ALL ?
  bii_dts_datasource varchar(100),
  bii_geom geometry(point, 4326),
  CONSTRAINT c_fk_bii_dts_datasource FOREIGN KEY (bii_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource),
  --CONSTRAINT c_fk_bii_lfs_code FOREIGN KEY (bio_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  --CONSTRAINT c_fk_bii_qal_id FOREIGN KEY (bii_qal_id) REFERENCES "ref".tr_quality_qal(qal_id)
  CONSTRAINT c_fk_bii_area_code FOREIGN KEY (bii_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_bii_cou_code FOREIGN KEY (bii_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_bii_emu FOREIGN KEY (bii_emu_nameshort,bii_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_bii_hty_code FOREIGN KEY (bii_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_nn_bii_date CHECK (bii_date) NOT NULL,
  CONSTRAINT c_ck_bii_lengthmm CHECK (bii_lengthmm>0 OR bii_lengthmm IS NULL),
  CONSTRAINT c_ck_bii_lengthmm CHECK (bii_weightg>0 OR bii_weightg IS NULL),
  CONSTRAINT c_ck_bii_bii_age CHECK (bii_age>0 OR bii_age IS NULL),
  CONSTRAINT c_ck_bii_eye_diam_horizontal CHECK (bii_eye_diam_horizontal>0 OR bii_eye_diam_horizontal IS NULL),
  CONSTRAINT c_ck_bii_eye_diam_vertical CHECK (bii_eye_diam_vertical>0 OR bii_eye_diam_vertical IS NULL),
  CONSTRAINT c_ck_bii_pectoral_fin_length CHECK (bii_pectoral_fin_length>0 OR bii_pectoral_fin_length IS NULL)
)
;

--TODO add trigger on bii_last_update


