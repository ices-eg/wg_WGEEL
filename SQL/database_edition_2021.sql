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
    perc_f numeric check((perc_f >=-1 and perc_f<=100) or perc_f is null or perc_f=-1) ,
    perc_t numeric check((perc_t >=-1 and perc_t<=100) or perc_t is null or perc_t=-1),
    perc_c numeric check((perc_c >=-1 and perc_c<=100) or perc_c is null or perc_c=-1),
    perc_mo numeric check((perc_mo >=-1 and perc_f<=100) or perc_mo is null or perc_mo=-1)
);

ALTER TABLE datawg.t_eelstock_eel_percent drop constraint t_eelstock_eel_percent_check;
ALTER TABLE datawg.t_eelstock_eel_percent ADD CONSTRAINT t_eelstock_eel_percent_check CHECK ((((perc_mo >= (-1)::numeric) AND (perc_mo <= (100)::numeric)) OR (perc_mo IS NULL)));

ALTER TABLE datawg.t_eelstock_eel_percent drop constraint t_eelstock_eel_percent_perc_c_check;
ALTER TABLE datawg.t_eelstock_eel_percent ADD CONSTRAINT t_eelstock_eel_percent_perc_c_check CHECK ((((perc_c >= (-1)::numeric) AND (perc_c <= (-1)::numeric)) OR (perc_c IS NULL)));

ALTER TABLE datawg.t_eelstock_eel_percent drop constraint t_eelstock_eel_percent_perc_f_check;
ALTER TABLE datawg.t_eelstock_eel_percent ADD CONSTRAINT t_eelstock_eel_percent_perc_f_check CHECK ((((perc_f >= (-1)::numeric) AND (perc_f <= (100)::numeric)) OR (perc_f IS NULL)));

ALTER TABLE datawg.t_eelstock_eel_percent drop constraint t_eelstock_eel_percent_perc_t_check;
ALTER TABLE datawg.t_eelstock_eel_percent ADD CONSTRAINT t_eelstock_eel_percent_perc_t_check CHECK ((((perc_t >= (-1)::numeric) AND (perc_t <= (100)::numeric)) OR (perc_t IS NULL)));

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
 
 
-- modifications of Swedish data 
begin;
update datawg.t_eelstock_eel tee 
	set eel_comment = 'assisted migration'
	where eel_typ_id in (32,33) and eel_cou_code ='SE' and eel_qal_id = 1;

SELECT * FROM datawg.t_eelstock_eel tee where eel_typ_id in (32,33) and eel_cou_code ='SE' and eel_qal_id = 1;

update datawg.t_eelstock_eel tee set eel_qal_id = 21,
	eel_qal_comment='all data were updated in 2021 by Rob Van Gemert'
    where eel_typ_id in (10,8, 9) and eel_cou_code ='SE' and eel_qal_id = 1;
   
SELECT * FROM datawg.t_eelstock_eel tee WHERE
	eel_qal_comment='all data were updated in 2021 by Rob Van Gemert'
    AND eel_typ_id in (10,8,9) and eel_cou_code ='SE' ;

commit;

SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=8 AND eel_lfs_code='Y' AND 


SELECT log_cou_code, log_data,  log_message FROM datawg.log WHERE NOT log_evaluation_name ILIKE '%check%'
AND NOT log_message ILIKE '%error%' 
AND log_date>= '2021-09-07'
ORDER BY log_cou_code, log_data;

*-- The LABEL was wrong IN the program

UPDATE datawg.log SET log_evaluation_name= 'write duplicates'  WHERE log_evaluation_name ILIKE '%check duplicates%'; --92


SELECT eel_typ_id, count(*) FROM datawg.t_eelstock_eel WHERE eel_cou_code='IT' 
AND eel_datasource='dc_2021' 
GROUP BY eel_typ_id

SELECT eel_typ_id, count(*) FROM datawg.t_eelstock_eel WHERE eel_cou_code='IT' 
AND eel_year> 2020
GROUP BY eel_typ_id


SELECT eel_typ_id, count(*) FROM datawg.t_eelstock_eel WHERE eel_cou_code='GB' 
AND eel_datasource='dc_2021' 
GROUP BY eel_typ_id


SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=4 AND eel_cou_code='DK' AND eel_year='2020'
SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=4 AND eel_cou_code='DK' ORDER BY eel_year desc


SELECT ser_typ_id, count(*) FROM datawg.t_dataseries_das
JOIN datawg.t_series_ser ON das_ser_id=ser_id
WHERE ser_cou_code='GB' 
AND das_dts_datasource='dc_2021' 
GROUP BY ser_typ_id;

SELECT ser_typ_id, count(*) FROM datawg.t_biometry_series_bis
JOIN datawg.t_series_ser ON bis_ser_id=ser_id
WHERE ser_cou_code='GB' 
AND bio_dts_datasource='dc_2021' 
GROUP BY ser_typ_id;


SELECT log_cou_code, log_data,  log_message FROM datawg.log WHERE NOT log_evaluation_name ILIKE '%check%'
AND NOT log_message ILIKE '%error%' 
AND log_date>= '2021-09-07'
AND log_cou_code='GB'
ORDER BY log_date;

SELECT ser_typ_id, count(*) FROM datawg.t_dataseries_das
JOIN datawg.t_series_ser ON das_ser_id=ser_id
WHERE ser_cou_code='GB' 
AND das_dts_datasource='dc_2021' 
GROUP BY ser_typ_id;

SELECT log_cou_code, log_data,  log_message FROM datawg.log WHERE NOT log_evaluation_name ILIKE '%check%'
AND NOT log_message ILIKE '%error%' 
AND log_date>= '2021-09-07'
AND log_cou_code='DK'
ORDER BY log_date;

-- delete some lines from Portugal

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code= 'PT' AND eel_typ_id=11 
AND eel_year>= 2013 AND eel_year<=2017 AND eel_qal_id=1;

UPDATE  datawg.t_eelstock_eel SET eel_qal_id=21 WHERE eel_cou_code= 'PT' AND eel_typ_id=11 
AND eel_year>= 2013 AND eel_year<=2017 AND eel_qal_id=1; --4

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code= 'PT' AND eel_typ_id=11 AND eel_datasource='dc_2021' ORDER BY eel_year 
DELETE FROM datawg.t_eelstock_eel WHERE eel_cou_code= 'PT' AND eel_typ_id=11 AND eel_datasource='dc_2021' AND eel_qal_id=21;--2




SELECT DISTINCT ser_nameshort, ser_id FROM datawg.t_series_ser 
WHERE ser_cou_code='GB' ORDER BY ser_nameshort


-- DELETE LINES FOR SWEDEN

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code= 'SE' AND eel_typ_id=11 
  AND eel_qal_id IN (1,2) ORDER BY eel_year;


UPDATE datawg.t_eelstock_eel SET eel_qal_id=21 WHERE eel_cou_code= 'SE' AND eel_typ_id=11 
 AND eel_qal_id=2 AND eel_year>=2008; --11
 
UPDATE datawg.t_eelstock_eel SET eel_qal_id=1 WHERE eel_cou_code= 'SE' AND eel_typ_id=11 
  AND eel_qal_id IN (2); --4

SELECT * FROM  datawg.t_eelstock_eel WHERE  eel_typ_id=11 AND eel_cou_code= 'SE' ORDER BY eel_lfs_code, eel_typ_id, eel_year

-- checking italy

SELECT log_cou_code, log_data,  log_message FROM datawg.log WHERE NOT log_evaluation_name ILIKE '%check%'
AND NOT log_message ILIKE '%error%' 
AND log_date>= '2021-09-07'
AND log_cou_code='IT'
ORDER BY log_date;

SELECT eel_typ_id, count(*) FROM datawg.t_eelstock_eel WHERE eel_cou_code='IT' 
AND eel_year> 2020
GROUP BY eel_typ_id;

SELECT eel_typ_id, count(*) FROM datawg.t_eelstock_eel WHERE eel_cou_code='IT' 
AND eel_datasource ='dc_2021'
GROUP BY eel_typ_id;


-- ticket 186 

select eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code, 
count(*)  
from datawg.t_eelstock_eel where eel_qal_id in (0,1) 
group by eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code 
having count(*) >1


-- 194 some of those correspond to coastal waters with area division 
-- two separate columns for area division

WITH cc AS (
select 
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1))
SELECT * FROM cc WHERE n>1 
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id;

WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal,
eel_qal_comment,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (1,2,4)),
dd AS (
SELECT * FROM cc WHERE n>1)
SELECT * FROM dd 

UPDATE datawg.t_eelstock_eel SET 
(eel_qal_id, eel_qal_comment) = (21, 'transfered from emu to total but entered again later on, duplicate removed by cedric during dc 2021') 
WHERE eel_id IN (423409,423410);--2


-- in germany there is clearly a new row where before was NC and 0 I will use the new value
WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1)),

remove_me AS (
SELECT * FROM cc WHERE n>1 
AND eel_cou_code='DE'
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

--SELECT * FROM remove_me
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(21,coalesce(eel_qal_comment,'This is a duplicate, removed')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
; --3


-- in the UK some values are reported both as NP one as 0 one as 1
WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1)
AND eel_missvaluequal='NP'),

remove_me AS (
SELECT * FROM cc WHERE n>1 
AND eel_cou_code='GB'
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(21,coalesce(eel_qal_comment,'This is a duplicate, removed')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
; --55


-- table for Tea
WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1,21)
),

remove_me AS (
SELECT * FROM cc WHERE n>1 AND n<=2
AND eel_cou_code='GB'
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

--SELECT * FROM remove_me

UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(21,coalesce(eel_qal_comment,'This is a duplicate, removed')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
;--20

WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1,21)
),

remove_me AS (
SELECT * FROM cc WHERE n>1 
AND eel_cou_code='GB'
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

--SELECT * FROM remove_me

UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(20,coalesce(eel_qal_comment,'This is a duplicate, removed')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
;--8


-- in Lithuania and turkey and tunisia and sweden and POLAND there is clearly a new row where before was NC and 0 I will use the new value
WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1)),

remove_me AS (
SELECT * FROM cc WHERE n>1 
AND eel_cou_code IN ('DE','TN','TR','PL','LT','SE')
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

--SELECT * FROM remove_me
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(21,coalesce(eel_qal_comment,'This is a duplicate, there is one line more recent with qal_id=1 with a value, and a line with qal_id=0 that is older. I remove the old one')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
; --9 ROWS + 4 ROWS SE

-- ES and DE have confirmed that lines with 0 were to be deleted
WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1)),

remove_me AS (
SELECT * FROM cc WHERE n>1 
AND eel_cou_code IN ('ES','DE')
AND eel_qal_id =0
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

--SELECT * FROM remove_me
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment) =(21,coalesce(eel_qal_comment,'=> This is a duplicate confirmed with data provider, we remove it')) 
FROM remove_me 
WHERE remove_me.eel_id=t_eelstock_eel.eel_id
; --3

-- remaining to be solved

WITH cc AS (
select 
eel_id,
eel_typ_id,
eel_qal_id,
eel_year,
eel_emu_nameshort, 
eel_lfs_code,
eel_hty_code, 
eel_area_division,
eel_value, 
eel_missvaluequal, 
eel_datasource,
eel_datelastupdate, 
eel_cou_code,
count(*) OVER (PARTITION BY eel_typ_id,eel_year,eel_emu_nameshort, eel_lfs_code,eel_hty_code,eel_area_division)  AS n
from datawg.t_eelstock_eel where eel_qal_id in (0,1)),

remove_me AS (
SELECT * FROM cc WHERE n>1 
ORDER BY eel_typ_id,  eel_emu_nameshort,eel_year, eel_lfs_code, eel_hty_code, eel_qal_id)

SELECT * FROM remove_me
; --62 lines GB AND ES

SELECT * FROM 
datawg.t_series_ser JOIN 
datawg.t_dataseries_das 
ON das_ser_id = ser_id
WHERE das_id IN (4435,4436,4438,4465)


-- there was no catch

UPDATEdata_error_series$error_messaget_dataseries_das SET (das_value, das_comment, das_qal_id) = 
(NULL,'there was no sampling, no data, corrected in 2021', 0)
WHERE das_id IN (4435,4436,4438,4465); --4


-- delete lines for NL

UPDATE datawg.t_eelstock_eel SET (eel_qal_id,eel_qal_comment) = ('21', coalesce(eel_qal_comment,'')|| ' =>Marqued as DELETE for dc_2021')
WHERE eel_id IN (380096,
380097,
380098,
380099,
380100,
380101,
380102,
380116,
380117,
392278,
392298,
392306,
422851,
422852);--14


SELECT coalesce(eel_qal_comment,'')|| ' =>Marqued as DELETE for dc_2021' FROM datawg.t_eelstock_eel LIMIT 100

WITH remove_me AS (
	SELECT * FROM datawg.t_eelstock_eel 
	WHERE eel_typ_id IN (8,9,10) 
	 AND eel_qal_id IN (1,2,4)
	 AND eel_cou_code='DE'
	 AND eel_id NOT IN (
	SELECT eel_id FROM datawg.t_eelstock_eel  
	 WHERE eel_typ_id IN (8,9,10) 
	 AND eel_qal_id =21
	 AND eel_cou_code='DE')
	 )
UPDATE datawg.t_eelstock_eel  
SET (eel_qal_id, eel_qal_comment)= (21, coalesce(t_eelstock_eel.eel_qal_comment || ' =>Everything remove from the db in 2021')) 
FROM remove_me WHERE remove_me.eel_id=t_eelstock_eel.eel_id; --101



 
DELETE FROM datawg.t_eelstock_eel WHERE 
eel_comment='DELETE'
 AND eel_typ_id IN (8,9,10) 
 AND eel_qal_id IN (1,2,4)
AND eel_cou_code='DE'; --460

SELECT *  FROM datawg.t_eelstock_eel WHERE 
eel_datasource='dc_2021'
 AND eel_typ_id IN (8,9,10) 
 --AND eel_qal_id IN (21)
AND eel_cou_code='DE';

DELETE FROM datawg.t_eelstock_eel WHERE 
eel_datasource='dc_2021'
 AND eel_typ_id IN (8,9,10) 
 AND eel_qal_id =1
AND eel_cou_code='DE'; --425

SELECT * FROM datawg.t_eelstock_eel  WHERE eel_year = 1985
AND eel_lfs_code='Y'
AND eel_emu_nameshort='DE_Oder'
AND eel_typ_id =9
AND eel_hty_code= 'F'
 
 SELECT count(*), eel_qal_id, eel_year, eel_typ_id  FROM datawg.t_eelstock_eel 
 WHERE eel_typ_id IN (8,9,10) 
 AND eel_qal_id IN (1,2,4)
 AND eel_cou_code='DE'
 GROUP BY eel_qal_id, eel_year, eel_typ_id
 ORDER BY eel_typ_id, eel_qal_id, eel_year;

SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id=6 AND  eel_cou_code='DE' AND eel_qal_id =1 AND eel_missvaluequal  IS NULL


-- ALL GERMAN LANDINGS FOR RECREATIONAL ARE DUBIOUS ACCORDING TO LASSE
UPDATE datawg.t_eelstock_eel SET eel_qal_id =4 WHERE eel_typ_id=6
AND  eel_cou_code='DE' 
AND eel_qal_id =1
AND eel_missvaluequal  IS NULL;--420


-- BE

-- BEFORE inserting, remove  VeAmG as it has been split into two series 

SELECT * FROM datawg.t_series_ser WHERE ser_nameshort='VeAmGY' ; --ser_id 209

SELECT * FROM  datawg.t_dataseries_das WHERE das_ser_id =209; -- 4 lines

DELETE FROM  datawg.t_dataseries_das WHERE das_ser_id =209;--4
-- there is a crisscross of constraints, so I need to remove the ser_tblcodeid first
UPDATE  datawg.t_series_ser  set   ser_tblcodeid =NULL WHERE ser_nameshort ='VeAmGY';--1
DELETE FROM ref.tr_station WHERE "Station_Name"='VeAmGY' ;--1
DELETE  FROM datawg.t_series_ser WHERE ser_nameshort='VeAmGY' ;--1


SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code ='AL'

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code ='EG'

SELECT * FROM datawg.t_series_ser tss WHERE ser_cou_code='GB'







-------------------------------------
-- modify views for preco diag
--------------------------------------
CREATE OR REPLACE VIEW datawg.precodata_emu
AS WITH b0_unique AS (
         SELECT bigtable_by_habitat_1.eel_emu_nameshort,
            sum(bigtable_by_habitat_1.b0) AS unique_b0
           FROM datawg.bigtable_by_habitat bigtable_by_habitat_1
          WHERE bigtable_by_habitat_1.eel_year = 0 AND bigtable_by_habitat_1.eel_emu_nameshort::text <> 'ES_Murc'::text OR bigtable_by_habitat_1.eel_year = 0 AND bigtable_by_habitat_1.eel_emu_nameshort::text = 'ES_Murc'::text AND bigtable_by_habitat_1.eel_hty_code::text = 'C'::text
          GROUP BY bigtable_by_habitat_1.eel_emu_nameshort
        )
 SELECT bigtable_by_habitat.eel_year,
    bigtable_by_habitat.eel_cou_code,
    bigtable_by_habitat.country,
    bigtable_by_habitat.cou_order,
    bigtable_by_habitat.eel_emu_nameshort,
    bigtable_by_habitat.emu_wholecountry,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE COALESCE(b0_unique.unique_b0, sum(bigtable_by_habitat.b0))
        END AS b0,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bbest)
        END AS bbest,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bcurrent)
        END AS bcurrent,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['ES_Cata'::character varying::text, 'LT_total'::character varying::text]) THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.suma * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.suma)
        END AS suma,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['ES_Cata'::character varying::text, 'LT_total'::character varying::text]) THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.sumf * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.sumf)
        END AS sumf,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.sumh * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.sumh)
        END AS sumh,
    'emu'::text AS aggreg_level,
    bigtable_by_habitat.aggregated_lfs,
    string_agg(bigtable_by_habitat.eel_hty_code::text, ', '::text) AS aggregated_hty
   FROM datawg.bigtable_by_habitat
     LEFT JOIN b0_unique USING (eel_emu_nameshort)
  WHERE bigtable_by_habitat.eel_year > 1850 AND bigtable_by_habitat.eel_emu_nameshort::text <> 'ES_Murc'::text OR bigtable_by_habitat.eel_year > 1850 AND bigtable_by_habitat.eel_emu_nameshort::text = 'ES_Murc'::text AND bigtable_by_habitat.eel_hty_code::text = 'C'::text
  GROUP BY bigtable_by_habitat.eel_year, bigtable_by_habitat.eel_cou_code, bigtable_by_habitat.country, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort, bigtable_by_habitat.emu_wholecountry, bigtable_by_habitat.aggregated_lfs, b0_unique.unique_b0
  ORDER BY bigtable_by_habitat.eel_year, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort;

 
-- check problem with h
SELECT eel_typ_id ,eel_cou_code, count(*) FROM datawg.t_eelstock_eel tee 
WHERE  eel_qal_comment ILIKE '%deleted in%' AND eel_qal_id=21
GROUP BY eel_cou_code, eel_typ_id
 

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code ='VA';

DROP TABLE IF EXISTS datawg.t_seriesglm_sgl;
CREATE TABLE datawg.t_seriesglm_sgl (
sgl_ser_id serial4 PRIMARY KEY,
sgl_year integer,
CONSTRAINT c_fk_sql_ser_id FOREIGN KEY (sgl_ser_id) REFERENCES datawg.t_series_ser(ser_id));

INSERT INTO datawg.t_seriesglm_sgl SELECT ser_id FROM datawg.t_series_ser WHERE ser_typ_id=1 AND ser_qal_id=1 OR ser_qal_id=0;--93


SELECT * FROM datawg.t_seriesglm_sgl
ALTER TABLE datawg.t_seriesglm_sgl OWNER TO wgeel;

UPDATE datawg.t_seriesglm_sgl SET sgl_year=2021 WHERE sgl_ser_id IN (
SELECT ser_id FROM datawg.t_series_ser WHERE ser_nameshort IN ('LiffGY','BrokGY','StraGY','BeeGY','BeeY','MillY','MertY'));--7



SELECT ser_qal_id, ser_qal_comment FROM  datawg.t_series_ser WHERE  ser_nameshort IN ('LiffGY','BrokGY','StraGY','BeeGY','BeeY','MillY','MertY');
UPDATE datawg.t_series_ser SET (ser_qal_id, ser_qal_comment)=(1, '>=10 years')  WHERE ser_nameshort IN ('LiffGY','BrokGY','StraGY','BeeGY','BeeY','MillY','MertY');--7

WITH troubleyelloweel AS (
SELECT * FROM datawg.t_dataseries_das
JOIN datawg.t_series_ser ON das_ser_id = ser_id
WHERE das_year= 2021 AND 
ser_typ_id=1
AND ser_lfs_code ='Y'
AND ser_qal_id = 1
AND das_qal_id IS NULL)

UPDATE datawg.t_dataseries_das
SET (das_qal_id,das_comment) = (4,t_dataseries_das.das_comment||'temporarily removed from the analmysis in 2021 (only two series for yellow eel) PUT BACK das_qal_id TO 1 next year !!!')
FROM troubleyelloweel
WHERE troubleyelloweel.das_id=t_dataseries_das.das_id;--2



SELECT sgl.*, ser.ser_nameshort, ser_cou_code FROM datawg.t_seriesglm_sgl sgl 
JOIN datawg.t_series_ser ser ON
ser_id = sgl_ser_id


SELECT * FROM datawg.t_dataseries_das WHERE das_ser_id=318;


SELECT * FROM datawg.t_series_ser WHERE ser_nameshort='BeeG';

SELECT * FROM datawg.t_dataseries_das WHERE das_ser_id=184;

SELECT * FROM datawg.t_series_ser WHERE ser_nameshort='SeEAG';

SELECT * FROM datawg.t_dataseries_das  WHERE das_ser_id = 7

UPDATE datawg.t_dataseries_das 
SET (das_comment, das_qal_id)= 
(das_comment || ', Because of Brexit we shouldn''t be using the 2021 series at all.', 3)
WHERE das_ser_id = 7
AND das_year=2021; --1



SELECT geom FROM datawg.t_series_ser;
SELECT ST_transform(ST_SETSRID(ST_MakePoint(6779552.138, 417768.557),3067),4326)

-- the trigger is not working I drop it for the time of the integration


DROP TRIGGER update_coordinates ON  datawg.t_series_ser ;--0

UPDATE datawg.t_series_ser SET geom =
ST_transform(ST_SETSRID(ST_MakePoint(417768.557,6779552.138 ),3067),4326)
WHERE ser_nameshort='VesiY';--1

UPDATE datawg.t_series_ser SET (ser_x,ser_y)=(st_x(geom),st_y(geom)) WHERE ser_nameshort = 'VesiY';

SELECT * FROM datawg.t_series_ser WHERE ser_nameshort = 'VesiY';

CREATE TRIGGER update_coordinates AFTER
UPDATE
    OF geom ON
    datawg.t_series_ser FOR EACH ROW EXECUTE FUNCTION datawg.update_coordinates()
    
    
SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort ='ES_Gali'
AND eel_lfs_code= 'YS'
AND eel_qal_id =1 
AND eel_typ_id=4
AND eel_hty_code='T'
AND eel_year >= 2010
ORDER BY eel_year;



-- removing lines from spain with chiara.

SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort ='ES_Gali'
AND eel_lfs_code= 'Y'
AND eel_typ_id=4
AND eel_qal_id =1 
AND eel_year >= 2010
AND eel_hty_code='T'
ORDER BY eel_year;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort ='ES_Gali'
AND eel_lfs_code= 'S'
AND eel_typ_id=4
AND eel_qal_id =1 
AND eel_year >= 2010
AND eel_hty_code='T'
ORDER BY eel_year;


WITH remove_eel_not_fished_as_silver AS(
SELECT * FROM datawg.t_eelstock_eel WHERE eel_emu_nameshort ='ES_Gali'
AND eel_lfs_code= 'YS'
AND eel_qal_id =1 
AND eel_typ_id=4
AND eel_hty_code='T'
AND eel_year >= 2010
ORDER BY eel_year)
UPDATE datawg.t_eelstock_eel SET (eel_qal_id, eel_qal_comment)= (t_eelstock_eel.eel_qal_id, 
COALESCE(t_eelstock_eel.eel_qal_comment,'')||'There is no fishery authorised for silver, this has been replaced with yellow in the database.')
FROM remove_eel_not_fished_as_silver
WHERE t_eelstock_eel.eel_id= remove_eel_not_fished_as_silver.eel_id;--10

-- Missing areas FOR UK

UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=184;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=317;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=318;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=185;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=187;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=186;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=182;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=183;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=377;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.7.g'
	WHERE ser_id=188;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=324;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=321;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=323;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=319;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.4.c'
	WHERE ser_id=322;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.7.f'
	WHERE ser_id=7;
UPDATE datawg.t_series_ser
	SET ser_area_division='27.7.f'
	WHERE ser_id=8;

