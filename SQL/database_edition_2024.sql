  
  
  CREATE OR REPLACE VIEW datawg.landings
AS SELECT t_eelstock_eel.eel_id,
        --CASE
            --WHEN t_eelstock_eel.eel_typ_id = NULL::integer THEN NULL::integer
            --WHEN t_eelstock_eel.eel_typ_id = 5 THEN 4
            --WHEN t_eelstock_eel.eel_typ_id = 7 THEN 6
            --WHEN t_eelstock_eel.eel_typ_id = 4 THEN 4
           -- WHEN t_eelstock_eel.eel_typ_id = 6 THEN 6
            --WHEN t_eelstock_eel.eel_typ_id = 32 THEN 32
            --WHEN t_eelstock_eel.eel_typ_id = 33 THEN 33
            --ELSE NULL::integer
        --END AS eel_typ_id,
        eel_typ_id,
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
    t_eelstock_eel.eel_datasource
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
  WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 32])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  --WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 5, 7, 32, 33])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));


-- CHECK for issue # 296

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='BeeGY';

UPDATE datawg.t_series_ser
  SET (ser_qal_id, ser_qal_comment)=(3,'Duplicated series from BeeG, this series will not be used in the analysis')
  WHERE ser_id=317; 





ALTER SEQUENCE "ref".tr_metrictype_mty_mty_id_seq RESTART WITH 27;
UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method,mty_individual_name) =
('female_proportion (from size)', 'macroscopic inspection of size','is_female_size(1=female,0=male)')
WHERE mty_name ='female_proportion';

INSERT INTO "ref".tr_metrictype_mty 
(mty_name,
mty_individual_name,
mty_description,
mty_type,
mty_method,
mty_uni_code,
mty_group,
mty_min,
mty_max) 
SELECT
'Female proportion (from gonads)' AS mty_name
,'has_female_gonads(1=female,0=male)' AS mty_individual_name
,mty.mty_description
,mty.mty_type
,'Dissection and visual inspection of gonads' AS mty_method
,mty.mty_uni_code
,mty.mty_group
,mty.mty_min
,mty.mty_max
FROM "ref".tr_metrictype_mty mty WHERE 
mty_name = 'female_proportion (from size)';


UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method, mty_individual_name) = 
('anguillicola_proportion (visual)' , 'Visual inspection of the swimbladder','anguillicola_presence_visual(1=present,0=absent)')
WHERE mty_name ='anguillicola_proportion';


INSERT INTO "ref".tr_metrictype_mty 
(mty_name
,mty_individual_name
,mty_description
,mty_type
,mty_method
,mty_uni_code
,mty_group
,mty_min
,mty_max) 
SELECT
'anguillicola_proportion (microscope)' AS mty_name
,'anguillicola_presence_microscope(1=present,0=absent)' AS mty_individual_name
,mty.mty_description
,mty.mty_type
,'Use of a stereo microscope to count the number of parasites in the swimbladder' AS mty_method
,mty.mty_uni_code
,mty.mty_group
,mty.mty_min
,mty.mty_max
FROM "ref".tr_metrictype_mty mty WHERE 
mty_name = 'anguillicola_proportion (visual)';