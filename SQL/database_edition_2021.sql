-- server
SELECT count(*) FROM datawg.t_series_ser -- 230
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --5070
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150


-- DONE ON SERVER

INSERT INTO REF.tr_datasource_dts  VALUES ('dc_2021', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2021');
INSERT INTO ref.tr_quality_qal SELECT 21,	'discarded_wgeel_2021',	
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2021',	FALSE;



SELECT * FROM datawg.t_eelstock_eel 
JOIN REF.tr_typeseries_typ ON typ_id=eel_typ_id
WHERE eel_typ_id IN (14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,24) 
--AND eel_qal_id=3;




/*
 *  THIS PART (about series)  HAS BEEN LAUNCHED ON SERVER
 */






-- Adding a table of gears, sent a mail to Inigo to see if there is a vocabulary in ICES data portal
-- Otherwise there is someting suitable in FAO here
--http://www.fao.org/cwp-on-fishery-statistics/handbook/capture-fisheries-statistics/fishing-gear-classification/en/
-- There is a hierachy that we don't really need but we can keep the original codes

DROP TABLE IF EXISTS ref.tr_gear_gea;
CREATE TABLE ref.tr_gear_gea (
gea_id INTEGER PRIMARY KEY,     -- this will correspond to the identifier column in the original dataset
gea_issscfg_code TEXT,	
gea_name_en	TEXT);

-- see import_gear.R where I created the table using structure

SELECT * FROM ref.tr_gear_gea ;
INSERT INTO ref.tr_gear_gea SELECT * FROM gear;

ALTER TABLE datawg.t_series_ser ADD COLUMN ser_sam_gear INTEGER REFERENCES ref.tr_gear_gea(gea_id);
UPDATE datawg.t_series_ser SET ser_sam_gear= 226 WHERE ser_effort_uni_code='nr fyke.day'; --8 Fyke net
UPDATE datawg.t_series_ser SET ser_sam_gear= 214 WHERE ser_effort_uni_code='nr haul'; -- 9 Portable lift nets
UPDATE datawg.t_series_ser SET ser_sam_gear= 242 WHERE ser_effort_uni_code='nr electrofishing'; --59 Electric fishing
UPDATE datawg.t_series_ser SET ser_sam_gear= 226 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%fyke net%'; --10 --Fyke net
UPDATE datawg.t_series_ser SET ser_sam_gear= 230 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%trap%' OR ser_comment ILIKE '%pass%'; --58 --Trap
UPDATE datawg.t_series_ser SET ser_sam_gear= 242 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%electrofishing%'; --7
UPDATE datawg.t_series_ser SET ser_comment ='partial monitoring of one gate, with a model reconstructing the total migration' WHERE ser_id = 224;

ALTER TABLE datawg.t_series_ser ADD COLUMN ser_distanceseakm NUMERIC;
COMMENT ON COLUMN datawg.t_series_ser.ser_distanceseakm IS 
'Distance to the saline limit in km, for group of data, e.g. a set of electrofishing points 
in a basin, this is the average distance of the different points';


ALTER TABLE datawg.t_series_ser ADD COLUMN ser_method TEXT;
COMMENT ON COLUMN datawg.t_series_ser.ser_method IS 
'Description of the method used, includes precisions about the sampling method, period and life stages collected';


ALTER TABLE datawg.t_biometry_bio ADD COLUMN bio_number NUMERIC;
COMMENT ON COLUMN datawg.t_biometry_bio.bio_number IS 'number of individual corresponding to the measures';


ALTER TABLE datawg.t_series_ser ADD COLUMN ser_restocking BOOLEAN;
COMMENT ON COLUMN datawg.t_series_ser.ser_restocking IS 
'Is the series affected by restocking, if yes you need to describe the effect in series description';


/*
Table for percent habitat related to stock indicators
*/
drop table if exists datawg.t_eelstock_eel_percent;
create table datawg.t_eelstock_eel_percent (
    percent_id integer primary key references datawg.t_eelstock_eel(eel_id) ON DELETE CASCADE;,
    perc_f numeric check((perc_f >=0 and perc_f<=100) or perc_f is null or perc_f=-1) ,
    perc_t numeric check((perc_t >=0 and perc_t<=100) or perc_t is null or perc_t=-1),
    perc_c numeric check((perc_c >=0 and perc_c<=100) or perc_c is null or perc_c=-1),
    perc_mo numeric check((perc_mo >=0 and perc_f<=100) or perc_mo is null or perc_mo=-1)
);


-- DONE apply server 30/08



INSERT INTO "ref".tr_quality_qal (qal_id, qal_level, qal_text,qal_kept) VALUES (-21,'discarded 2021 biom mort',
'This data has either been removed from the database in favour of new data, this has been done systematically in 2021 for biomass and mortality types', 
FALSE);

SELECT * FROM datawg.t_eelstock_eel JOIN REF.tr_typeseries_typ ttt ON ttt. typ_id=eel_typ_id
WHERE eel_typ_id IN (13,14,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31) and eel_qal_id IN(1,2,3,4);
-- DONE apply server 30/08

UPDATE datawg.t_eelstock_eel SET (eel_qal_id,eel_qal_comment)=(-21,'discarded prior to datacall 2021, all data will be replaced')
WHERE eel_typ_id IN (13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,24) and eel_qal_id IN(1,2,3,4); --4922

/*
SELECT * FROM datawg.t_biometry_series_bis tbs 
JOIN  datawg.t_series_ser ON ser_id=bis_ser_id
WHERE bio_sex_ratio IS NOT NULL;
*/

ALTER TABLE datawg.t_biometry_bio RENAME COLUMN bio_sex_ratio TO bio_perc_female; 



 -- SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id = 7 ; -- nothing OK
 
SELECT * FROM ref.tr_typeseries_typ ttt  WHERE typ_id=7
UPDATE ref.tr_typeseries_typ SET (typ_name,typ_description) = ('rec_discard_kg', 'Recreational discard (catch and release) kg') WHERE typ_id = 7;


-- Problems of duplicates in biometry 
select * from datawg.t_biometry_series_bis where bis_ser_id=50 and bio_year=1994


begin;
create temporary table  rankedtable as (
select bio_id,rank() over (partition by bio_year,bis_ser_id order by bio_id) rankbio from datawg.t_biometry_series_bis tbsb );--2234

delete from datawg.t_biometry_series_bis tb where exists (select t2.bio_id from rankedtable t2 where rankbio>1 and t2.bio_id=tb.bio_id);--2 

select bio_year,bis_ser_id, count(*)
from datawg.t_biometry_series_bis  
group by bio_year,bis_ser_id
HAVING count(*)
 > 1;--0

CREATE UNIQUE INDEX idx_biometry_series1 ON datawg.t_biometry_series_bis 
USING btree (bio_year, bio_lfs_code, bis_ser_id,  bio_qal_id) 
WHERE (bio_qal_id IS NOT NULL);

CREATE UNIQUE INDEX idx_biometry_series2 ON datawg.t_biometry_series_bis 
USING btree (bio_year, bio_lfs_code, bis_ser_id) 
WHERE (bio_qal_id IS NULL);


--add foreign key to datasources in biometry_series_bis
ALTER TABLE datawg.t_biometry_series_bis ADD CONSTRAINT c_fk_bio_series_bis_dts_datasource FOREIGN KEY (bio_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource);




/*
* THIS PART SHOULD BE LAUNCHED AFTER TEMPLATES GENERATION BUT BEFORE DATA INTEGRATION
*/



/*
Update view to include perc
*/
CREATE OR REPLACE VIEW datawg.b0
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 13 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  
  
  
CREATE OR REPLACE VIEW datawg.bbest
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 14 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  
  
  
  
CREATE OR REPLACE VIEW datawg.bcurrent
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 15 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  
  
  
  
CREATE OR REPLACE VIEW datawg.sigmaa
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 17 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  
  
  
CREATE OR REPLACE VIEW datawg.sigmaf
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 18 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  
  
  
  
CREATE OR REPLACE VIEW datawg.sigmah
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
   WHERE t_eelstock_eel.eel_typ_id = 19 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));

-- issue #171  
  
SELECT count(*) FROM datawg.t_eelstock_eel WHERE eel_lfs_code='OG' ; --519
  
 SELECT DISTINCT eel_typ_id FROM datawg.t_eelstock_eel t JOIN REF.tr_typeseries_typ ttt  ON ttt.typ_id = t.eel_typ_id 
 WHERE eel_lfs_code='OG'
 AND eel_qal_id IN (0,1,2,3,4);
 

 SELECT DISTINCT eel_typ_id, typ_name FROM datawg.t_eelstock_eel t JOIN REF.tr_typeseries_typ ttt  ON ttt.typ_id = t.eel_typ_id 
 WHERE eel_lfs_code='OG'
 AND eel_qal_id IN (0,1,2,3,4);
 
 SELECT DISTINCT count(*), eel_typ_id, typ_name, eel_emu_nameshort FROM datawg.t_eelstock_eel t JOIN REF.tr_typeseries_typ ttt  ON ttt.typ_id = t.eel_typ_id 
 WHERE eel_lfs_code='OG'
 AND eel_qal_id IN (0,1,2,3,4)
 GROUP BY eel_typ_id, typ_name, eel_emu_nameshort;
 
-- REMOVE "test" from database 

SELECT count(*) FROM datawg.t_eelstock_eel WHERE eel_datasource ='test';--812
SELECT count(*) FROM datawg.t_series_ser tss WHERE ser_dts_datasource ='test';--0
SELECT count(*) FROM datawg.t_dataseries_das tss WHERE das_dts_datasource ='test';--7
SELECT count(*) FROM datawg.t_biometry_series_bis WHERE bio_dts_datasource ='test'; --275

DELETE FROM datawg.t_eelstock_eel WHERE eel_datasource ='test'; --812
DELETE FROM datawg.t_series_ser tss WHERE ser_dts_datasource ='test';--0
DELETE FROM datawg.t_dataseries_das tss WHERE das_dts_datasource ='test';--7
DELETE FROM datawg.t_biometry_series_bis WHERE bio_dts_datasource ='test';--275


SELECT * FROM datawg.t_dataseries_das ORDER BY das_year desc;
SELECT * FROM datawg.t_dataseries_das ORDER BY das_last_update desc;

psql -U postgres -d wgeel -h localhost -c "ALTER USER wgeel WITH PASSWORD 'XXXXXXX'"


SELECT * FROM datawg.t_series_ser WHERE ser_cou_code ='GB';

--ALTER TABLE datawg.t_dataseries_das DROP CONSTRAINT c_fk_ser_id;
--ALTER TABLE datawg.t_biometry_series_bis  DROP CONSTRAINT c_fk_ser_id;


UPDATE datawg.t_series_ser SET ser_nameshort= 'OatGY' WHERE ser_nameshort='OatY'; --1


SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'wgeel' -- ← change this to your DB
  AND pid <> pg_backend_pid();

 
 SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = current_database()
  AND pid <> pg_backend_pid();

 
 SELECT * FROM pg_stat_activity WHERE datname = 'wgeel' and state = 'active';
  SELECT * FROM pg_stat_activity WHERE state='idle';
 
 SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'wgeel' -- ← change this to your DB
  AND pid <> pg_backend_pid()
 AND state='idle';


