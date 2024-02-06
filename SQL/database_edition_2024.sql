  
  
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
