/*
Database treatment to remove duplicates
Values from SE, FR and TN have been saved in excel files and will have to be reprocessed
*/


-- selection of duplicates values
-- using a groub_by and count(*=>1)
-- merge back with database to retrieve all rows

select ee.* from datawg.t_eelstock_eel ee join 
(select eel_cou_code, eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id, count(*)
from datawg.t_eelstock_eel
where eel_area_division is null
group by eel_cou_code,eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id
HAVING count(*) > 1 )sub
 on (ee.eel_year, ee.eel_lfs_code, ee.eel_emu_nameshort, ee.eel_typ_id, ee.eel_hty_code, ee.eel_qal_id)=
(sub.eel_year, sub.eel_lfs_code, sub.eel_emu_nameshort, sub.eel_typ_id, sub.eel_hty_code, sub.eel_qal_id)
order by eel_emu_nameshort, eel_year,eel_lfs_code,eel_hty_code;



delete from datawg.t_eelstock_eel where eel_id in (

select ee.eel_id from datawg.t_eelstock_eel ee join 
(select eel_cou_code, eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id, count(*)
from datawg.t_eelstock_eel
where eel_area_division is null
group by eel_cou_code,eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id
HAVING count(*) > 1 )sub
 on (ee.eel_year, ee.eel_lfs_code, ee.eel_emu_nameshort, ee.eel_typ_id, ee.eel_hty_code, ee.eel_qal_id)=
(sub.eel_year, sub.eel_lfs_code, sub.eel_emu_nameshort, sub.eel_typ_id, sub.eel_hty_code, sub.eel_qal_id)
) --103 row removed



