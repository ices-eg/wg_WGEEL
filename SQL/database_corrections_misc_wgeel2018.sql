
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


select  *  from datawg.t_eelstock_eel  where eel_cou_code = 'ES'  and eel_typ_id in (11,12) and eel_lfs_code='OG' order by eel_emu_nameshort, eel_year ;



----GB YS

select * from datawg.t_eelstock_eel  where  eel_lfs_code='GY' 
-- there are just 0 all stages, remove them
select * from datawg.t_eelstock_eel  where  eel_lfs_code='GY' and eel_cou_code='IE' and eel_typ_id=6;
begin;
delete from datawg.t_eelstock_eel  where  eel_lfs_code='GY' and eel_cou_code='IE' and eel_typ_id=6; --24
commit;

delete from 


select * from datawg.t_eelstock_eel  where eel_cou_code = 'ES'  and eel_typ_id in (11,12) and eel_hty_code='F' and eel_area_division is not null order by eel_emu_nameshort, eel_year ;
begin;
update datawg.t_eelstock_eel set (eel_qal_id,eel_qal_comment)=(18, 'removed as duplicated') where eel_cou_code = 'ES'  and eel_typ_id in (11,12) and eel_hty_code='F' and eel_area_division is not null  ;
commit;


select count(*), eel_datasource,eel_qal_id from datawg.t_eelstock_eel group by eel_datasource, eel_qal_id order by eel_datasource

begin;
delete from datawg.t_eelstock_eel where eel_datasource='test0';
commit;


set search_path to datawg, ref, public;
select * from t_eelstock_eel where eel_year>2012 
	and eel_emu_nameshort='GR_total'
	and eel_typ_id= 4

begin;
update t_eelstock_eel set eel_value=10*eel_value
	where eel_year<=2012 
	and eel_emu_nameshort='GR_total'
	and eel_typ_id= 4;
commit;

begin;
update  t_eelstock_eel set (eel_qal_id, eel_qal_comment) =(18,'duplicate with EMUs')
	where eel_year>2012 
	and eel_emu_nameshort='GR_total'
	and eel_typ_id= 4;	
commit;	




begin;
update t_eelstock_eel a set (eel_qal_id, eel_qal_comment) =(18,'duplicates about area division') where eel_id in (
 select eel_id from t_eelstock_eel where
 eel_year>=2013 and
 eel_typ_id=4 and 
 eel_cou_code='GR' and
 eel_area_division is null
 and eel_qal_id=1);
 commit;


 select * from t_eelstock_eel where eel_year=2017 and eel_typ_id=4 and eel_cou_code='GR'



	
------------delete biomasses for GR_tot

begin;
update  t_eelstock_eel set (eel_qal_id, eel_qal_comment) =(18,'duplicate with EMUs')
 where eel_emu_nameshort='GR_total'
 and eel_typ_id in (13,14,15);
commit;

 select * from t_eelstock_eel
 where eel_cou_code='GR'
 and eel_typ_id in (13,14,15)

 *
 ----- corrections IE and GB

 select * from datawg.t_eelstock_eel where eel_cou_code = 'GB' and eel_typ_id=4 and eel_lfs_code='GY'


begin;
update datawg.t_eelstock_eel set (eel_lfs_code,eel_qal_id)=('YS',18) where eel_cou_code = 'GB' and eel_typ_id=4 and eel_lfs_code='GY';
commit;

select * from datawg.t_eelstock_eel where eel_cou_code = 'GB' and eel_typ_id=4

select * from datawg.t_eelstock_eel where eel_cou_code = 'IE' and eel_typ_id=4 and eel_year= 2008

select * from datawg.t_eelstock_eel where eel_id=379451

update datawg.t_eelstock_eel set eel_qal_id = 18 where eel_id=379451

-- spain 19780 B0
select  * from datawg.t_eelstock_eel where eel_cou_code = 'ES' and eel_typ_id=13  and eel_hty_code='AL' order ;
begin;
update datawg.t_eelstock_eel set (eel_qal_id , eel_qal_comment) = (3, 'Rejected because it''s a true duplicate with emus details') 
where eel_cou_code = 'ES' and eel_typ_id=13 and eel_emu_nameshort='ES_Cata' and eel_hty_code='AL';
commit;


begin;
update datawg.t_eelstock_eel set (eel_qal_id , eel_qal_comment) = (3, 'Rejected because it''s a true duplicate with emus details') 
where eel_cou_code = 'ES' and eel_typ_id=13 and eel_emu_nameshort='ES_Cata' and eel_hty_code='AL';
commit;


begin;
update datawg.t_eelstock_eel set (eel_qal_id , eel_qal_comment) = (3, 'Rejected because it''s a true duplicate with emus details') 
where eel_cou_code = 'ES' and eel_typ_id=13 and eel_emu_nameshort='ES_Anda' and eel_hty_code='AL';
commit;


begin;
update datawg.t_eelstock_eel set (eel_qal_id , eel_qal_comment) = (3, 'Rejected because it''s a true duplicate with emus details') 
where eel_cou_code = 'ES' and eel_typ_id=13 and eel_emu_nameshort='ES_Vale' and eel_hty_code='AL';
commit;

select * from datawg.t_eelstock_eel where eel_cou_code ='IE'  and eel_typ_id in (13,14,15,17,18,19,20,21,22,23,24,25);

-- aquaculture no eel_area_division


select * from datawg.t_eelstock_eel where eel_area_division is not null and eel_typ_id= 11 and eel_qal_id in (1,2,4) ;


begin;
update datawg.t_eelstock_eel set eel_area_division= NULL where eel_area_division is not null and eel_typ_id= 11 and eel_qal_id in (1,2,4) ; --72
commit;


-- sweden duplicates

select * from datawg.t_eelstock_eel where eel_cou_code ='SE'  and eel_year>= 2008 and eel_year<=2016 and eel_typ_id=11 and eel_datasource='dc_2017';

begin;

update datawg.t_eelstock_eel set eel_qal_id=18 where eel_cou_code ='SE'  and eel_year>= 2008 and eel_year<=2016 and eel_typ_id=11 and eel_datasource='dc_2017'; --9
commit;


-- sweden YS => S
select * from datawg.t_eelstock_eel where eel_cou_code ='SE'  and eel_typ_id=11 and eel_lfs_code ='YS' and eel_qal_id =1


begin;
update datawg.t_eelstock_eel set eel_lfs_code = 'S' where eel_cou_code ='SE'  and eel_typ_id=11 and eel_lfs_code ='YS' and eel_qal_id =1;
commit;


select * from datawg.t_eelstock_eel where eel_cou_code='VA'
delete from datawg.t_eelstock_eel where eel_cou_code='VA';

------
-- export for willem

set search_path to datawg, ref;



select * from b0 union 
select * from bbest union
select * from bcurrent union
select * from sigmaa union
select * from sigmaf union
select * from sigmah


-- GR sumA 17
 select * from t_eelstock_eel
 where eel_cou_code='GR'
 and eel_typ_id in (17)


select * from datawg.t_eelstock_eel where eel_cou_code ='SE' and eel_typ_id in  (8,9,10) and eel_lfs_code='G'

begin;
update datawg.t_eelstock_eel set eel_lfs_code='QG' where eel_cou_code ='SE' and eel_typ_id in  (8,9,10) and eel_lfs_code='G';
commit;

 