insert into ref.tr_datasource_dts values ('dc_2026', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2026');

insert into ref.tr_quality_qal values (26, 'discarded_wgeel 2026','This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2026', FALSE);
    

-- CHECK mean weight silver eel med release

WITH weights AS (
SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id = 8 AND eel_cou_code = 'FR' AND eel_lfs_code = 'S' 
AND eel_emu_nameshort = 'FR_Rhon'
AND eel_qal_id = 1),
numbers AS (
SELECT * FROM datawg.t_eelstock_eel WHERE eel_typ_id = 9 AND eel_cou_code = 'FR' AND eel_lfs_code = 'S'
AND eel_emu_nameshort = 'FR_Rhon'
AND eel_qal_id = 1)
SELECT numbers.eel_year, weights.eel_value / numbers.eel_value AS mean_weight FROM numbers inner JOIN weights ON 
weights.eel_year = numbers.eel_year;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_id = 552578

SELECT * FROM datawg.t_eelstock_eel WHERE eel_year >= 2100


SELECT * FROM datawg.t_dataseries_das WHERE das_year = 2025 AND das_ser_id IN
(SELECT ser_id FROM datawg.t_series_ser WHERE ser_nameshort IN ('FlaG', 'FlaGY', 'FlaY'));

-- adding the das_qal_comment in comment for warning table
UPDATE datawg.t_dataseries_das
  SET das_comment='Occasional problem with solar panel. Updated count to mid November 2025. Updated from 2276 to 3052.'
  WHERE das_id=9497;
UPDATE datawg.t_dataseries_das
  SET das_comment='Occasional problem with solar panel. Updated count to mid November 2025. Updated from 371 to 861.'
  WHERE das_id=9498;
UPDATE datawg.t_dataseries_das
  SET das_comment='Occasional problem with solar panel. Updated count to mid November 2025. Updated from 36 to 41.'
  WHERE das_id=9499;

SELECT ser_nameshort, das.*  FROM datawg.t_dataseries_das das JOIN datawg.t_series_ser ON ser_id=das_ser_id WHERE das_year >2021  AND das_qal_comment IS NOT NULL;

-- update comment in LevS
UPDATE datawg.t_dataseries_das
  SET das_qal_comment='No counter data from 3rd October onwards',das_comment='No counter data from 3rd October onwards. Das_value updated from 26 to 43 by Ayesha Taylor'
  WHERE das_id=7968;


SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code = 'TR' AND eel_year = 2025 AND eel_typ_id = 4;


-- fix values in RT reported in tons instead of kg
UPDATE datawg.t_eelstock_eel
  SET eel_value=267000
  WHERE eel_id=615908;


-- error NL #396
SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code = 'NL'  AND eel_typ_id = 11
ORDER BY  eel_lfs_code,eel_year


UPDATE datawg.t_eelstock_eel
  SET eel_value=2200000
  WHERE eel_id=615672;

