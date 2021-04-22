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


/*
Table for percent habitat related to stock indicators
*/
drop table if exists datawg.t_eelstock_eel_percent;
create table datawg.t_eelstock_eel_percent (
    percent_id integer primary key references datawg.t_eelstock_eel(eel_id) ON DELETE CASCADE;,
    perc_f numeric check((perc_f >=0 and perc_f<=100) or perc_f is null) ,
    perc_t numeric check((perc_t >=0 and perc_t<=100) or perc_t is null),
    perc_c numeric check((perc_c >=0 and perc_c<=100) or perc_c is null),
    perc_mo numeric check((perc_mo >=0 and perc_f<=100) or perc_mo is null)
);


  -- TODO apply server

UPDATE datawg.t_eelstock_eel SET (eel_qal_id,eel_qal_comment)=(20,'discarded prior to datacall 2021, all data will be replaced')
WHERE eel_typ_id IN (13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,24) and eel_qal_id IN(1,2,3,4); --4922

/*
SELECT * FROM datawg.t_biometry_series_bis tbs 
JOIN  datawg.t_series_ser ON ser_id=bis_ser_id
WHERE bio_sex_ratio IS NOT NULL;
*/

ALTER TABLE datawg.t_biometry_bio RENAME COLUMN bio_sex_ratio TO bio_perc_female; 





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

