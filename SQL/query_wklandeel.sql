-- data from Ireland
-- commercial fishermen
 

select t.* from datawg.t_eelstock_eel t 
                            where eel_qal_id in (0,1,2,4) and 
                             eel_typ_id in (4) 
                             and eel_cou_code in ('IE')
                             and eel_lfs_code != 'G'
                             --and NOT emu_wholecountry 
                             
                             
SELECT cou_country FROM ref.tr_country_cou

select t.* from datawg.t_eelstock_eel t 
                            where eel_qal_id in (0,1,2,4) and 
                             eel_typ_id in (4,6) 
                             and eel_cou_code in ('CZ')
                             and eel_lfs_code != 'G'
                             --and NOT emu_wholecountry 