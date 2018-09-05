---------------------------------------------
-- test app 2018
---------------------------------------------

select distinct eel_datasource  FROM datawg.t_eelstock_eel where eel_cou_code='FR';
select distinct eel_qal_id  FROM datawg.t_eelstock_eel where eel_cou_code='FR';


select * from datawg.t_eelstock_eel where  eel_cou_code='VA' ;


delete from datawg.t_eelstock_eel where eel_datasource='test' and eel_cou_code = 'VA'; --9
update datawg.t_eelstock_eel set eel_qal_id = 1 where eel_qal_id=18 and eel_cou_code='VA' ; -- 3

update datawg.t_eelstock_eel set eel_qal_id = 1 where eel_qal_id=18;
delete from datawg.t_eelstock_eel where eel_datasource='test' and eel_cou_code = 'VA';

delete from datawg.log;