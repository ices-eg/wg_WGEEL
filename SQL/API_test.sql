-- 


SELECT 
                ser_id,  ser_nameshort, ser_namelong, ser_typ_id, 
                ser_effort_uni_code,
                ser_comment, ser_uni_code, 
                ser_lfs_code, ser_hty_code, 
                ser_locationdescription,
                ser_emu_nameshort, 
                ser_cou_code, 
                ser_area_division,
                ser_x, 
                ser_y,             
                ser_sam_id, 
                ser_sam_gear,
                ser_qal_id, 
                ser_qal_comment,
                ser_ccm_wso_id,
                area_km2,
                cou_code, 
                cou_country, 
                cou_order 
                FROM datawg.t_series_ser 
                LEFT JOIN ref.tr_country_cou ON cou_code=ser_cou_code 
                LEFT JOIN ref.tr_lifestage_lfs ON ser_lfs_code=lfs_code
                LEFT JOIN ref.tr_faoareas ON ser_area_division=f_division
                LEFT JOIN ccm21.seaoutlets ON seaoutlets.wso_id = ANY(ser_ccm_wso_id)
                WHERE ser_nameshort IN ('GiTCG')