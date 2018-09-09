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


select * from datawg.t_eelstock_eel where  eel_cou_code='IE' and eel_typ_id=4


select * from datawg.t_eelstock_eel where  eel_cou_code='ES' and eel_datasource is null;
update datawg.t_eelstock_eel set eel_datasource='dc_2018' where eel_cou_code='ES' and eel_datasource is null;


select * from datawg.t_eelstock_eel where  eel_cou_code='FR' and eel_datasource='test';

select * from datawg.t_eelstock_eel where  eel_cou_code='LT' and eel_typ_id=11

select * from datawg.t_eelstock_eel where  eel_cou_code='DK' and eel_typ_id=19
update datawg.t_eelstock_eel set eel_qal_id=2 where eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =18;
update datawg.t_eelstock_eel set eel_qal_id=18 where eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =1;
update datawg.t_eelstock_eel set eel_qal_id=1 where eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =2;
update datawg.t_eelstock_eel set eel_comment='value 0.059 used insead of 0.009' where eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =18;
update datawg.t_eelstock_eel set eel_comment='Manual change after error in data integration, this value has been chosen' where eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =1;
select * from datawg.t_eelstock_eel where  eel_cou_code='DK' and eel_typ_id=19 and eel_qal_id =18

select * from datawg.t_eelstock_eel where  eel_cou_code='UK' and eel_typ_id=16 ;


select * from datawg.t_eelstock_eel where  eel_cou_code='LV' and eel_typ_id in (8,9,10);
delete from datawg.t_eelstock_eel where  eel_cou_code='FR' and eel_typ_id in (13,14,15,16,17,18,19,20,21,22,23,24,25) and eel_datasource='test';
select * from datawg.t_eelstock_eel where  eel_cou_code='FR' and eel_typ_id in (13,14,15,16,17,18,19,20,21,22,23,24,25);
update datawg.t_eelstock_eel set eel_datasource='dc_2018' where  eel_cou_code='FR' and eel_datasource='test';

select * from datawg.t_eelstock_eel where eel_datasource='test';


select count (*),eel_hty_code, eel_cou_code, eel_typ_id from datawg.t_eelstock_eel where eel_area_division is not null  
group by eel_hty_code, eel_cou_code, eel_typ_id order by  eel_cou_code, eel_hty_code  ;


select * from datawg.t_eelstock_eel where eel_cou_code='IT' and eel_typ_id=4 and eel_year>=2009 and eel_year<=2014 and eel_lfs_code='S' and eel_hty_code='T'
and eel_emu_nameshort='IT_Frio'



 
select distinct  eel_cou_code from datawg.t_eelstock_eel where  eel_typ_id in (8,9,10) order by eel_cou_code ;

select * from datawg.t_eelstock_eel where  eel_typ_id in (8,9,10) and eel_cou_code ;

begin;
update  datawg.t_eelstock_eel set eel_typ_id= 32 where eel_emu_nameshort= 'GB_Neag' and eel_typ_id = '4' and eel_lfs_code='G';
commit;


update  datawg.t_eelstock_eel set eel_typ_id= 32 where eel_emu_nameshort= 'GB_Neag'


select * from datawg.t_eelstock_eel where eel_emu_nameshort= 'GB_total' and eel_datasource


delete from datawg.t_eelstock_eel where eel_cou_code='LT' and eel_typ_id=11 and eel_year <2017 and eel_year>2012 and eel_qal_id=1 and eel_datasource='dc_2017'



select * from datawg.t_eelstock_eel where eel_emu_nameshort= 'GB_Scot' 

begin;
delete from datawg.t_eelstock_eel where eel_cou_code='LV'  and eel_typ_id in (4,6) and eel_datasource='dc_2018'
commit;


select * from datawg.t_eelstock_eel where eel_cou_code='LV'

begin;
update datawg.t_eelstock_eel set eel_emu_nameshort= 'LV_Latv' where eel_cou_code='LV';
commit;


select * from datawg.t_eelstock_eel where eel_cou_code ='NO'  and eel_typ_id in (13,14,15,17,18,19,20,21,22,23,24,25);

update datawg.t_eelstock_eel set (eel_qal_id, eel_emu_nameshort) = (18, 'LT_Lith') where eel_cou_code='LT' and eel_typ_id=4 and eel_year <=2017
 and eel_year>=1995 and eel_qal_id=1 and eel_emu_nameshort='LT_total' ;

begin;
update datawg.t_eelstock_eel set eel_qal_id=18 where eel_cou_code ='LV'  and eel_typ_id in (4)  and eel_year>=2000  and eel_year <=2016 and eel_datasource ='dc_2017'
commit;


update datawg.t_eelstock_eel set eel_area_division=NULL  where eel_cou_code ='LV'  and eel_typ_id in (8,9,10) 


 select * FROM datawg.t_eelstock_eel  where eel_cou_code ='LT'  and eel_typ_id in (13,14,15,17,18,19,20,21,22,23,24,25);


select * from datawg.t_eelstock_eel  where eel_cou_code = 'IT' and eel_year=2015 and eel_lfs_code ='G'


select * from tempit


begin;
update datawg.t_eelstock_eel d set eel_value = t.eel_value  from tempit t 
where 
d.eel_year= t.eel_year
and
d.eel_hty_code = t.eel_hty_code
and
d. eel_emu_nameshort = t. eel_emu_nameshort
and 
d.eel_lfs_code = t.eel_lfs_code
and
d.eel_typ_id = 4
and
t.eel_typ_name='com_landings_kg'
and d.eel_qal_id =1 
commit;


select 