------------------
-- transfer yellow AND silver index series from old db to the new
------------------
------------------
-- common issues
------------------

-----
-- unit
-- create a temp table to convert unit
CREATE TEMP TABLE unit_conversion (
	uni_code varchar(20),
	old_unit TEXT
);

-- unit used
SELECT DISTINCT yss_unit FROM ts.t_yellowstdstock_yss
UNION
SELECT DISTINCT sil_unit FROM ts.t_silverprod_sil
;

-- current ref unit
SELECT * FROM "ref".tr_units_uni;
-- insert new ref
INSERT INTO "ref".tr_units_uni
VALUES
	('nr/haul', 'number per haul'),
	('kg/ha', 'weight in kilogrammes per surface in hectare')
;

-- fill in conversion table
INSERT INTO unit_conversion
VALUES 
	('nr/m2', 'eel/m2'),
	('index', 'Index'),
	('nr/haul', 'eel.haul-1'),
	(NULL, 'CPUE'),
	('kg/ha', 'kg/ha'),
	('nr', 'number'),
	('nr electrofishing', 'nb electrofishing'),
	('nr haul', 'nb haul')
;


------------------
-- yellow eel
------------------
---- transfer the series
-- old data to be transfered
SELECT *
FROM ts.t_yellowstdstock_yss JOIN ts.t_location_loc ON yss_loc_id = loc_id;

-- current ref series
SELECT ser_id,  ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_area_division, ser_tblcodeid, ser_x, ser_y, geom, ser_sam_id, ser_qal_id, ser_qal_comment
FROM datawg.t_series_ser;

-- extract data from old db and insert into new db
INSERT INTO datawg.t_series_ser ( ser_nameshort, ser_namelong, ser_typ_id, ser_comment, ser_uni_code, ser_lfs_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_x, ser_y, geom)
WITH 
	series_type AS
(SELECT typ_id FROM "ref".tr_typeseries_typ WHERE typ_name = 'Yellow eel index'),
	unit AS
(SELECT uni_code, yss_loc_id FROM ts.t_yellowstdstock_yss JOIN unit_conversion ON yss_unit = old_unit),
	lfs AS
(SELECT lfs_code FROM "ref".tr_lifestage_lfs WHERE lfs_name = 'yellow eel'),
	country AS
(SELECT cou_code, cou_country FROM "ref".tr_country_cou)
SELECT 
	 yss_nameshort AS ser_nameshort, yss_namelong AS ser_namelong, typ_id AS ser_typ_id, 
	 yss_remark || ' / ' || loc_comment AS ser_comment, uni_code AS ser_uni_code, lfs_code AS ser_lfs_code,
	 loc_name AS ser_locationdescription, loc_emu_name_short AS ser_emu_nameshort, cou_code AS ser_cou_code,
	 round(st_x(st_transform(the_geom, 4326))::numeric, 5) AS ser_x, round(st_y(st_transform(the_geom, 4326))::numeric, 5) AS ser_y,
	 st_transform(the_geom, 4326) AS geom
FROM series_type, lfs, ts.t_yellowstdstock_yss 
	JOIN ts.t_location_loc ON yss_loc_id = loc_id
	JOIN unit USING(yss_loc_id)
	JOIN country ON (cou_country = loc_country)
;

---- transfer the data itself
-- old data
SELECT dat_id, dat_value, dat_class_id, dat_loc_id, dat_year, dat_stage, dat_comment, dat_effort, dat_eft_id, eft_name
FROM ts.t_data_dat JOIN ts.tr_efforttype_eft ON dat_eft_id = eft_id
;

-- current table
SELECT das_id, das_value, das_ser_id, das_year, das_comment, das_effort, das_last_update, das_qal_id
FROM datawg.t_dataseries_das;

INSERT INTO datawg.t_dataseries_das(das_value, das_ser_id, das_year, das_comment, das_effort)
WITH
	series AS
(SELECT ser_id, ser_nameshort, yss_loc_id
FROM datawg.t_series_ser 
	JOIN ts.t_yellowstdstock_yss ON yss_nameshort = ser_nameshort)
SELECT 
	round(dat_value::NUMERIC, 5) AS das_value, ser_id AS das_ser_id, dat_year AS das_year,
	dat_comment AS das_comment, dat_effort AS das_effort
FROM ts.t_data_dat
	JOIN series ON yss_loc_id = dat_loc_id
;

-- effort unit to be updated in series table
WITH
	series AS
(SELECT ser_id, ser_nameshort, yss_loc_id
FROM datawg.t_series_ser 
	JOIN ts.t_yellowstdstock_yss ON yss_nameshort = ser_nameshort),
	effort_unit AS
(SELECT DISTINCT ser_id AS ef_ser_id, dat_eft_id, eft_name, uni_code
FROM ts.t_data_dat 
	JOIN series ON yss_loc_id = dat_loc_id
	JOIN ts.tr_efforttype_eft ON dat_eft_id = eft_id
	JOIN unit_conversion ON old_unit = eft_name
WHERE dat_eft_id IS NOT NULL)
UPDATE datawg.t_series_ser SET ser_effort_uni_code = uni_code 
FROM effort_unit
WHERE ser_id = ef_ser_id
;

--todo: !!! duplicate in ts.t_data_dat
SELECT dat_loc_id, dat_year, count(*)
FROM ts.t_data_dat
GROUP BY dat_loc_id, dat_year
HAVING count(*) > 1
;

SELECT dat_year, count(*), min(dat_value) != max(dat_value)
FROM ts.t_data_dat
WHERE dat_loc_id = 49
GROUP BY dat_year
ORDER BY dat_year
;

------------------
-- silver eel
------------------
---- transfer the series
-- old data
SELECT sil_id, sil_loc_id, sil_river, sil_location, sil_samplingtype, sil_remark, sil_order, sil_unit, sil_nameshort, sil_namelong
FROM ts.t_silverprod_sil;
SELECT *
FROM ts.t_silverprod_sil
JOIN ts.t_location_loc ON sil_loc_id = loc_id;

-- extract data from old db and insert into new db
INSERT INTO datawg.t_series_ser ( ser_nameshort, ser_namelong, ser_typ_id, ser_comment, ser_uni_code, ser_lfs_code, ser_locationdescription, ser_emu_nameshort, ser_cou_code, ser_x, ser_y, geom)
WITH 
	series_type AS
(SELECT typ_id FROM "ref".tr_typeseries_typ WHERE typ_name = 'silver eel series'),
	unit AS
(SELECT uni_code, sil_loc_id FROM ts.t_silverprod_sil JOIN unit_conversion ON sil_unit = old_unit),
	lfs AS
(SELECT lfs_code FROM "ref".tr_lifestage_lfs WHERE lfs_name = 'silver eel'),
	country AS
(SELECT cou_code, cou_country FROM "ref".tr_country_cou)
SELECT 
	 sil_nameshort AS ser_nameshort, sil_namelong AS ser_namelong, typ_id AS ser_typ_id, 
	 sil_remark || ' / ' || loc_comment AS ser_comment, uni_code AS ser_uni_code, lfs_code AS ser_lfs_code,
	 loc_name AS ser_locationdescription, loc_emu_name_short AS ser_emu_nameshort, cou_code AS ser_cou_code,
	 round(st_x(st_centroid(st_transform(the_geom, 4326)))::numeric, 5) AS ser_x, round(st_y(st_centroid(st_transform(the_geom, 4326)))::numeric, 5) AS ser_y,
	 st_transform(the_geom, 4326) AS geom
FROM series_type, lfs, ts.t_silverprod_sil 
	JOIN ts.t_location_loc ON sil_loc_id = loc_id
	JOIN unit USING(sil_loc_id)
	LEFT OUTER JOIN country ON (cou_country = loc_country)
;

---- transfer the data itself
-- old data
SELECT dat_id, dat_value, dat_class_id, dat_loc_id, dat_year, dat_stage, dat_comment, dat_effort, dat_eft_id, eft_name
FROM ts.t_data_dat JOIN ts.tr_efforttype_eft ON dat_eft_id = eft_id
;

-- current table
SELECT das_id, das_value, das_ser_id, das_year, das_comment, das_effort, das_last_update, das_qal_id
FROM datawg.t_dataseries_das;

INSERT INTO datawg.t_dataseries_das(das_value, das_ser_id, das_year, das_comment, das_effort)
WITH
	series AS
(SELECT ser_id, ser_nameshort, sil_loc_id
FROM datawg.t_series_ser 
	JOIN ts.t_silverprod_sil ON sil_nameshort = ser_nameshort)
SELECT 
	round(dat_value::NUMERIC, 5) AS das_value, ser_id AS das_ser_id, dat_year AS das_year,
	dat_comment AS das_comment, dat_effort AS das_effort
FROM ts.t_data_dat
	JOIN series ON sil_loc_id = dat_loc_id
;

-- effort unit to be updated in series table
WITH
	series AS
(SELECT ser_id, ser_nameshort, sil_loc_id
FROM datawg.t_series_ser 
	JOIN ts.t_silverprod_sil ON sil_nameshort = ser_nameshort),
	effort_unit AS
(SELECT DISTINCT ser_id AS ef_ser_id, dat_eft_id, eft_name, uni_code
FROM ts.t_data_dat 
	JOIN series ON sil_loc_id = dat_loc_id
	JOIN ts.tr_efforttype_eft ON dat_eft_id = eft_id
	JOIN unit_conversion ON old_unit = eft_name
WHERE dat_eft_id IS NOT NULL)
UPDATE datawg.t_series_ser SET ser_effort_uni_code = uni_code 
FROM effort_unit
WHERE ser_id = ef_ser_id
;

------------------
-- final check
------------------
---- yellow eel
-- series
SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
WHERE ser_typ_id = typ_id AND typ_name = 'Yellow eel index';
-- data
WITH series AS
(SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
	WHERE ser_typ_id = typ_id AND typ_name = 'Yellow eel index')
SELECT * FROM datawg.t_dataseries_das JOIN series ON das_ser_id = ser_id
;
-- data summary
WITH series AS
(SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
	WHERE ser_typ_id = typ_id AND typ_name = 'Yellow eel index'),
data_series AS
(SELECT * FROM datawg.t_dataseries_das JOIN series ON das_ser_id = ser_id)
SELECT ser_nameshort, ser_namelong, ser_cou_code, ser_emu_nameshort, count(*), min(das_year), max(das_year)
FROM data_series
GROUP BY ser_nameshort, ser_namelong, ser_cou_code, ser_emu_nameshort
;

---- silver eel
-- series
SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
WHERE ser_typ_id = typ_id AND typ_name = 'silver eel series';
-- data
WITH series AS
(SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
	WHERE ser_typ_id = typ_id AND typ_name = 'silver eel series')
SELECT * FROM datawg.t_dataseries_das JOIN series ON das_ser_id = ser_id
;
-- data summary
WITH series AS
(SELECT * FROM datawg.t_series_ser, "ref".tr_typeseries_typ
	WHERE ser_typ_id = typ_id AND typ_name = 'silver eel series'),
data_series AS
(SELECT * FROM datawg.t_dataseries_das JOIN series ON das_ser_id = ser_id)
SELECT ser_nameshort, ser_namelong, ser_cou_code, ser_emu_nameshort, count(*), min(das_year), max(das_year)
FROM data_series
GROUP BY ser_nameshort, ser_namelong, ser_cou_code, ser_emu_nameshort
;


-- duplicated values, I will remove the faulty series
-- series 
with search_duplicated as (
SELECT das_ser_id, das_year,count(*) FROM datawg.t_dataseries_das GROUP BY das_year, das_ser_id )
select * from search_duplicated where count>1;


select * from 	datawg.t_series_ser where ser_id=194;
DELETE FROM datawg.t_dataseries_das where das_ser_id in (select ser_id from datawg.t_series_ser where ser_nameshort='VVed');
ALTER TABLE datawg.t_dataseries_das add constraint c_uk_year_ser_id unique(das_year,das_ser_id);


------------------------
-- biometry DATA
------------------------
-- old
SELECT code, loc_code, loc_name, country, yr, lat, long, "temp", expl, dens, dist, sal, n, fem_len, mal_len, fem_age, mal_age, the_geom, si_loc_id
FROM ts.silver;

-- new
SELECT bio_id, bio_lfs_code, bio_year, bio_length, bio_weight, bio_age, bio_sex_ratio, bio_length_f, bio_weight_f, bio_age_f, bio_length_m, bio_weight_m, bio_age_m, bio_comment, bio_last_update, bio_qal_id, bit_n, bit_loc_name, bit_cou_code, bit_emu_nameshort, bit_area_division, bit_hty_code, bit_latitude, bit_longitude, bit_geom
FROM datawg.t_biometry_other_bit;

SELECT cou_code, cou_country FROM "ref".tr_country_cou ORDER BY cou_order;

-- to be inserted
INSERT INTO datawg.t_biometry_other_bit(bio_lfs_code, bio_year, bio_length_f, bio_age_f, bio_length_m, bio_age_m, bit_n, bit_loc_name, bit_cou_code, bit_emu_nameshort, bit_latitude, bit_longitude, bit_geom, bio_comment)
SELECT 
	'S' AS bio_lfs_code, 
	CASE WHEN yr = -1 THEN NULL ELSE yr END AS bio_year, 
	CASE WHEN fem_len = -1 THEN NULL ELSE fem_len END AS bio_length_f, 
	CASE WHEN fem_age = -1 THEN NULL ELSE fem_age END AS bio_age_f, 
	CASE WHEN mal_len = -1 THEN NULL ELSE mal_len END AS bio_length_m, 
	CASE WHEN mal_age = -1 THEN NULL ELSE mal_age END AS bio_age_m, 
	CASE WHEN n = -1 THEN NULL ELSE n END AS bit_n,
	silver.loc_name AS bit_loc_name,
	CASE WHEN country = 'LIT' THEN 'LT'
		 WHEN country = 'GE' THEN 'DE'
		 WHEN country = 'PO' THEN 'PL'
		 WHEN country = 'UK' THEN 'GB'
		 WHEN country = 'HU' THEN NULL -- hungary doesn't exists in our ref table, only concern Balaton lake
		 ELSE country END AS bit_cou_code, 
	loc_emu_name_short AS bit_emu_nameshort,
	round(lat::numeric,2) AS bit_latitude, round(long::NUMERIC, 2) AS bit_longitude, silver.the_geom AS bit_geom,
	'temp = ' || temp   || '|expl = ' || expl || '|dist = ' || dist || ' |sal = ' || sal || ' |loc_code = ' || loc_code AS bio_comment
FROM ts.silver LEFT OUTER JOIN ts.t_location_loc ON (loc_id = si_loc_id);

------------------------------
-- query to the table for yellow and silver series
-------------------------------

SELECT das.*,  ser_id,  ser_nameshort, ser_namelong, ser_typ_id, ser_effort_uni_code, 
ser_comment, ser_uni_code, ser_lfs_code, ser_hty_code, ser_locationdescription, ser_emu_nameshort, 
ser_cou_code, ser_area_division, ser_tblcodeid, ser_x, ser_y, ser_sam_id, ser_qal_id, ser_qal_comment
 FROM datawg.t_dataseries_das das join datawg.t_series_ser ser ON das_ser_id=ser_id WHERE ser_typ_id=3;
