select *
 from  datawg.t_eelstock_eel 
where eel_emu_nameshort='ES_Cata' and eel_typ_id in (13,14,15)
order by eel_typ_id;


begin;
update datawg.t_eelstock_eel 
set (eel_qal_id,eel_value, eel_comment) = 
(2,115003, COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel')
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2008 and eel_hty_code='AL';
commit;

/*
select eel_value,
 COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel'
 from  datawg.t_eelstock_eel 
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2008 and eel_hty_code='T';
*/

begin;
update datawg.t_eelstock_eel 
set (eel_qal_id,eel_value, eel_comment) = 
(2,67515, COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel')
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2008 and eel_hty_code='T';
commit;

/*
select eel_value,
 COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel'
 from  datawg.t_eelstock_eel 
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2017 and eel_hty_code='AL';
*/
begin;
update datawg.t_eelstock_eel 
set (eel_qal_id,eel_value, eel_comment) = 
(2,95415, COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel')
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2017 and eel_hty_code='AL';
commit;
/*
select eel_value,
 COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel'
 from  datawg.t_eelstock_eel 
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2017 and eel_hty_code='T';
*/
begin;
update datawg.t_eelstock_eel 
set (eel_qal_id,eel_value, eel_comment) = 
(2,63820, COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel')
where eel_emu_nameshort='ES_Cata' and eel_typ_id=15 and eel_year=2017 and eel_hty_code='T';
commit;
/*
select eel_value,
 COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel'
 from  datawg.t_eelstock_eel 
where eel_emu_nameshort='ES_Cata' and eel_typ_id=14 and eel_year=2017 and eel_hty_code='AL';
*/
begin;
update datawg.t_eelstock_eel 
set (eel_qal_id,eel_value, eel_comment) = 
(2,196371, COALESCE(eel_comment,' ')||'value updated by Esti Diaz after wgeel')
where eel_emu_nameshort='ES_Cata' and eel_typ_id=14 and eel_year=2017 and eel_hty_code='AL';
commit;
