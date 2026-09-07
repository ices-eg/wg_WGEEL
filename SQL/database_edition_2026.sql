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
weights.eel_year = numbers.eel_year




