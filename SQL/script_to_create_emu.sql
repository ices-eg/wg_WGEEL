---------------------------------------------
--- script used to create the EMU
-- this script has used the wise layer to create a map of the EMUs
-- is is kept there to give an idea of how it was done
-- in the end the t_emuagreg_ema is called t_emusplit_ems
-- and is used in the referential tables of wgeel
---------------------------------------------


set search_path to carto,  european_wise2008,public;


 ALTER TABLE carto.uga ALTER COLUMN geom TYPE geometry(MultiPolygon, 3035) USING ST_Transform(geom,3035) ;

 ALTER TABLE carto.nuts_rg
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 3035) USING ST_Transform(ST_SetSRID(geom,4326),3035) ;
ALTER TABLE coastal
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 3035) USING ST_SetSRID(geom,3035);
 ALTER TABLE transitional
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 3035) USING ST_SetSRID(geom,3035);


 
create temporary sequence seq;
alter sequence seq restart with 1;
DROP TABLE IF EXISTS carto.t_emu_emu;

-- first creating the table from IE and UK layers
create table carto.t_emu_emu as
select 
nextval('seq') as emu_id,
null::character varying(100) as emu_name,
case when cty_id='IE' then 'IE'
when cty_id='UK' then 'GB' end as emu_coun_abrev,
name as emu_wisename,
lge_id as emu_lge_id,--language
cty_id as emu_cty_id,
name_engl as emu_name_engl,
areakm2 emu_areakm2,
eucd_rbd emu_eucd_rbd,
eucd_natrb emu_eucd_natrb,
hyd_syst_o emu_hyd_syst_o,
hyd_syst_s emu_hyd_syst_s,
rbd_hycode emu_rbd_hycode,
sea emu_sea,
the_geom as geom
from
 european_wise2008.rbd_f1v3
where cty_id in ('IE','UK');
update carto.t_emu_emu set emu_name=emu_wisename;

ALTER TABLE carto.t_emu_emu ADD CONSTRAINT c_pk_emu_id primary key (emu_id);
delete from carto.t_emu_emu where emu_name='Gibraltar';


--changing UK IE restored from pglog
delete from carto.t_emu_emu where emu_coun_abrev in ('IE','GB');--24
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		name as emu_name,
		case when cty_id='IE' then 'IE'
		when cty_id='UK' then 'GB' end as emu_coun_abrev,
		name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and cty_id in ('IE','UK')
		 and stat_levl_=0 )sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ;--24


--restoring erne
insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		b.name as emu_name,
		case when cty_id='IE' then 'IE'
		when cty_id='UK' then 'GB' end as emu_coun_abrev,
		b.name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and cty_id in ('IE','UK')
		 and stat_levl_=0
		 and b.id=191 )sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ;--24
-- PL restored from pglog
 select
	name as emu_name,
	'PL' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	ST_Intersection(a.geom, b.the_geom) AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='PL';   



/*
creating a sequence for the table, and changing type to multipolygon

CREATE SEQUENCE carto.t_emu_emu_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 10000
  START 36
  CACHE 1;
  */
ALTER TABLE carto.t_emu_emu ALTER COLUMN emu_id
SET DEFAULT nextval('carto.t_emu_emu_id_seq'::regclass);
-- Denmark, one EMU

insert into carto.t_emu_emu(emu_name,
emu_coun_abrev,
emu_areakm2,
geom)
select 
'DK_inland_waters' as emu_name,
'DK' as emu_coun_abrev,
sum(areakm2) emu_areakm2,
st_union(the_geom) as geom
from
 european_wise2008.rbd_f1v3
where cty_id='DK';

-- inserting French data
--select * from carto.uga
--select * from european_wise2008.rbd_f1v3 where cty_id='FR';
alter table carto.uga add column rbd_hycode character varying(25);
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=63)
	where libelle='Artois-Picardie';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=64)
	where libelle='Meuse';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=66)
	where libelle='Rhin';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=67)
	where gid=5;	
	
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=195)
	where libelle='Loire';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=194)
	where libelle='Garonne';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=194)
	where libelle='Adour';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=68)
	where libelle='Corse';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=196)
	where libelle='Seine-Normandie';
update carto.uga set
	rbd_hycode=(select rbd_hycode
	from  european_wise2008.rbd_f1v3
	where  gid=195)
	where libelle='Bretagne';	


insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
libelle emu_name,
cty_id as emu_coun_abrev,
name as emu_wisename,
lge_id as emu_lge_id,--language
cty_id as emu_cty_id,
name_engl as emu_name_engl,
areakm2 emu_areakm2,
eucd_rbd emu_eucd_rbd,
eucd_natrb emu_eucd_natrb,
hyd_syst_o emu_hyd_syst_o,
hyd_syst_s emu_hyd_syst_s,
w.rbd_hycode emu_rbd_hycode,
sea emu_sea,
geom as geom
from
 european_wise2008.rbd_f1v3 w join carto.uga 
 on uga.rbd_hycode=w.rbd_hycode
 where cty_id='FR'
 and name!='Sambre';--10
 
 --Danemark
select
	'DK_inland_waters' emu_name,
	'DK' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	b.rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='DK'; 
--italie restored from pglog
--sardaigne
select
	name as emu_name,
	'PL' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id=85;   
--comment
		
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		case when a.gid=1623 then 'Puglia'
		when a.gid=1636 then 'Lazio'
		when a.gid=1634 then 'Umbria'
		when a.gid=1633 then 'Toscana'
		when a.gid=1632 then 'Emilia-Romagna'
		when a.gid=1619 then 'Lombardia'
		when a.gid=1630 then 'Frioli-Venezia-Giulia'
		end as emu_name,
		'IT'::text as emu_coun_abrev,
		name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 --and stat_levl_=2 
		 and a.gid in (1623,1636,1634,1633,1632,1619,1630,1631);
--IT end
delete from carto.t_emu_emu where emu_name='nuts_id'
insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		nuts_id as emu_name,
		'IT'::text as emu_coun_abrev,
		b.name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 --and stat_levl_=2 
		 and a.gid not in (1623,1636,1634,1633,1632,1619,1630,1631,1627)
		 and substr(nuts_id,1,2)='IT'
		 and  stat_levl_=2
		 )sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ; --12


delete  from  carto.t_emu_emu where substring(emu_name,1,2)='IT';-- mostly borderline

 --NL

 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select
	'Netherlands' emu_name,
	'NL' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='NL'; --4

-- 
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select
	'Czech' emu_name,
	'CZ' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='CZ'
		and name_engl!='Danube'; --4

--LUXEMBURG
insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select
	'Luxemburg' emu_name,
	'LU' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='LU'; --4		
		

delete from carto.t_emu_emu where emu_coun_abrev='NL';
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select
	'Netherlands' emu_name,
	'NL' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom AS geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='NL'; --4
-- BE (Wallonia)
delete from carto.t_emu_emu where emu_coun_abrev='BE';
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
		select
		case when name like 'Escaut%' then 'Schelde'
		when name like 'Schelde' then 'Schelde'
		when name like 'Maas' then 'Meuse'
		else name end as emu_name,
		'BE'::text emu_coun_abrev,
		name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		the_geom AS geom
		from
		 european_wise2008.rbd_f1v3
		WHERE		
		 cty_id='BE';
--15


/*
-- BE (Flanders)
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		'Flanders'::text as emu_name,
		'BE'::text emu_coun_abrev,
		name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and nuts_id in ('BE2')
		 and stat_levl_=1 )sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ;--15
*/
--DE
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	name as emu_name,
	'DE' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='DE'
		and name !='Donau'; --9


--sweden


select substring(mscd_rbd,3,4) from rbd_f1v3 where cty_id='SE'
select * from rbd_f1v3 where cty_id='SE'
select * from sweden
alter table sweden add column eucd_rbd character varying(50);
update sweden set eucd_rbd=sub.eucd_rbd from  
(select rbd_f1v3.eucd_rbd, sweden.gid from rbd_f1v3 join sweden on distrikt=cast(substring(mscd_rbd,3,4) as integer) where cty_id='SE' and length(mscd_rbd)=3) sub
where sub.gid=sweden.gid;--15

 ALTER TABLE carto.sweden
 ALTER COLUMN geom TYPE geometry(MultiPolygon, 3035) USING ST_Transform(ST_SetSRID(geom,4326),3035) ;


delete from carto.t_emu_emu where emu_cty_id='SE';
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	namn as emu_name,
	'SE' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	sweden.areakm2 emu_areakm2,
	sweden.eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	sweden.geom
	from
	european_wise2008.rbd_f1v3  join 
	sweden on sweden.eucd_rbd=rbd_f1v3.eucd_rbd
	where cty_id='SE'; --15



--LV
delete from carto.t_emu_emu where emu_cty_id='LV';
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	'Latvia' as emu_name,
	'LV' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='LV'
		; --4
--LT
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	'Lithuania' as emu_name,
	'LT' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='LT'
		; --4	

-- Finland
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	'Finland' as emu_name,
	'FI' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='FI'
		; --8
--spain
update nuts_rg3 set name=NULL where gid in (1560,1561);
delete from carto.t_emu_emu where emu_coun_abrev in ('ES');--24
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		a.name as emu_name,
		'ES'::text emu_coun_abrev,
		b.name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and cty_id in ('ES')
		 and stat_levl_=2
		 and a.name is not null)sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ;--37	


 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom,emu_name_short)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom),
	emu_name_short
	from(
		select
		'Inner Spain'::text as emu_name,
		'ES'::text emu_coun_abrev,
		b.name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom,
		'ES_Inne'::text as emu_name_short
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and cty_id in ('ES')
		 and stat_levl_=3
		 and nuts_id='ES230')sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,emu_name_short ;--37	
--greece
update nuts_rg3 set name='Eastern Macedonia' where gid in (599,600,598,602,597);
update nuts_rg3 set name='Western Peloponnesos' where gid in (607,606,617);
update nuts_rg3 set name='North western' where gid in (581,578,579,577);
'Central greece - Aegean Islands'
select substring(nuts_id,1,2) a from nuts_rg3 order by nuts_id
select * from nuts_rg3 where name is null and substring(nuts_id,1,2)='EL' and stat_levl_=3
update nuts_rg3 set name='Central greece - Aegean Islands' where name is null and substring(nuts_id,1,2)='EL' and stat_levl_=3;
delete from carto.t_emu_emu where emu_cty_id ='GR';
insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
select emu_name,
	emu_coun_abrev,
	emu_wisename,
	emu_lge_id,
	emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea,
	st_union(geom)
	from(
		select
		a.name as emu_name,
		'GR'::text emu_coun_abrev,
		b.name as emu_wisename,
		lge_id as emu_lge_id,--language
		cty_id as emu_cty_id,
		name_engl as emu_name_engl,
		areakm2 emu_areakm2,
		eucd_rbd emu_eucd_rbd,
		eucd_natrb emu_eucd_natrb,
		hyd_syst_o emu_hyd_syst_o,
		hyd_syst_s emu_hyd_syst_s,
		b.rbd_hycode emu_rbd_hycode,
		sea emu_sea,
		ST_Intersection(a.geom, b.the_geom) AS geom
		from
		 carto.nuts_rg3 as a,
		 european_wise2008.rbd_f1v3 as b  
		WHERE
		 ST_Intersects(a.geom, b.the_geom)
		 and cty_id in ('GR')
		 and stat_levl_=3
		 and substring(nuts_id,1,2)='EL'
		 )sub
	group by emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
	emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
	emu_hyd_syst_s,emu_rbd_hycode,emu_sea ;--8

update	carto.t_emu_emu set emu_name_short='GR_EaMT'  where emu_name='Eastern Macedonia';
update	carto.t_emu_emu set emu_name_short='GR_WePe' where emu_name='Western Peloponnesos';
update	carto.t_emu_emu set emu_name_short='GR_NorW' where emu_name='North western';
update	carto.t_emu_emu set emu_name_short='GR_CeAe' where emu_name='Central greece - Aegean Islands';
		
-- portugal
 insert into carto.t_emu_emu
(emu_name,emu_coun_abrev,emu_wisename,emu_lge_id,emu_cty_id,
emu_name_engl,emu_areakm2,emu_eucd_rbd,emu_eucd_natrb,emu_hyd_syst_o,
emu_hyd_syst_s,emu_rbd_hycode,emu_sea,geom)
 select
	'Portugal' as emu_name,
	'PT' as emu_coun_abrev,
	name as emu_wisename,
	lge_id as emu_lge_id,--language
	cty_id as emu_cty_id,
	name_engl as emu_name_engl,
	areakm2 emu_areakm2,
	eucd_rbd emu_eucd_rbd,
	eucd_natrb emu_eucd_natrb,
	hyd_syst_o emu_hyd_syst_o,
	hyd_syst_s emu_hyd_syst_s,
	rbd_hycode emu_rbd_hycode,
	sea emu_sea,
	the_geom
	from
		european_wise2008.rbd_f1v3 w
		where cty_id='PT'
		; --10

select * from carto.t_emu_emu where emu_cty_id='PT'
update carto.t_emu_emu set (emu_name,emu_name_short)=('Portugal','PT_Port') where emu_cty_id='PT'
--germany update
--Ems: transitional waters included but coastal waters not
-- wise layer is just ugly
update carto.t_emu_emu set geom=(select ST_difference(st_union(a.geom), st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=243
and a.geom&&b.geom)
where emu_id=243;
--Weser coastal water not included
update carto.t_emu_emu set geom=(select ST_difference(st_union(a.geom), st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=244
and a.geom&&b.geom)
where emu_id=244;
--Elbe coastal water not included
update carto.t_emu_emu set geom=(select ST_difference(st_union(a.geom), st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=248
and a.geom&&b.geom)
where emu_id=248;

-- Eider split in two parts....
select * from carto.t_emu_emu where emu_id=242;
insert into carto.t_emu_emu (
"emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name")
select "emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name"
from carto.t_emu_emu where emu_id=242;
select * from carto.t_emu_emu where emu_name='Eider'; --242 483

update carto.t_emu_emu set geom=
(select st_intersection(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=483
and a.geom&&b.geom)
where emu_id=483;

update carto.t_emu_emu set geom=
(select st_difference(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
(select geom from carto.t_emu_emu where emu_id=483) b
where emu_id=242
and a.geom&&b.geom)
where emu_id=242;

--schlei trave
-- Eider split in two parts....

insert into carto.t_emu_emu (
"emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name")
select "emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name"
from carto.t_emu_emu where emu_id=246;
select * from carto.t_emu_emu where emu_name='Schlei/Trave'; --246 484
 
update carto.t_emu_emu set geom=
(select st_intersection(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=484
and a.geom&&b.geom)
where emu_id=484;

update carto.t_emu_emu set geom=
(select st_difference(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
(select geom from carto.t_emu_emu where emu_id=484) b
where emu_id=246
and a.geom&&b.geom)
where emu_id=246;

--schlei trave
-- Eider split in two parts....

insert into carto.t_emu_emu (
"emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name")
select "emu_name_short",
"geom",
"emu_sea",
"emu_rbd_hycode",
"emu_hyd_syst_s",
"emu_hyd_syst_o",
"emu_eucd_natrb",
"emu_eucd_rbd",
"emu_areakm2",
"emu_name_engl",
"emu_cty_id",
"emu_lge_id",
"emu_wisename",
"emu_coun_abrev",
"emu_name"
from carto.t_emu_emu where emu_id=247;
select * from carto.t_emu_emu where emu_name='Warnow/Peene'; --247 485
 
update carto.t_emu_emu set geom=
(select st_intersection(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=485
and a.geom&&b.geom)
where emu_id=485;

update carto.t_emu_emu set geom=
(select st_difference(st_union(a.geom),st_union(b.geom))
from carto.t_emu_emu a,
(select geom from carto.t_emu_emu where emu_id=485) b
where emu_id=247
and a.geom&&b.geom)
where emu_id=247;
/*
drop table essai;
create table essai as select ST_difference(st_union(a.geom), st_union(b.geom))
from carto.t_emu_emu a,
european_wise2008.coastal b
where emu_id=243
and a.geom&&b.geom;
*/
-- travail final
--getting rid of pb with Polish layers
update carto.t_emu_emu set emu_name=sub._name 
	from (select regexp_replace(emu_name,'Obszar Dorzecza ','') _name,emu_id from carto.t_emu_emu)sub
	where sub.emu_id=t_emu_emu.emu_id;
update carto.t_emu_emu set emu_name='Inland water' where emu_name like '%DK%'; --4
update carto.t_emu_emu set emu_name='Inland water' where emu_name like 'EE%'; --5
update carto.t_emu_emu set emu_name='Shannon' where emu_id=236; --1
update carto.t_emu_emu set emu_name=sub._name 
	from (select regexp_replace(emu_name,'Arquipelago da ','') _name,emu_id from carto.t_emu_emu)sub
	where sub.emu_id=t_emu_emu.emu_id;
update carto.t_emu_emu set emu_name=sub._name 
from (select regexp_replace(emu_name,'Arquipelago dos ','') _name,emu_id from carto.t_emu_emu)sub
where sub.emu_id=t_emu_emu.emu_id;

update carto.t_emu_emu set emu_wisename=emu_name where emu_coun_abrev='SE';--15
update carto.t_emu_emu set emu_name=emu_name_engl where emu_coun_abrev='SE';--15
alter table carto.t_emu_emu add column emu_name_short character varying (7);

update carto.t_emu_emu set emu_name_short=emu_coun_abrev||'_'||substring(emu_name,1,4);
delete from carto.t_emu_emu where emu_name_short='GB_Gibr';
delete from carto.t_emu_emu where emu_name_short='GB_Shan';
delete from carto.t_emu_emu where emu_name_short='IE_Neag';
delete from carto.t_emu_emu where emu_name='North Western';

insert into carto.t_emu_emu select * from carto.restoreme;
select * from carto.restoreme


update  carto.t_emu_emu  set emu_name_short='FR_Rhon' where emu_name_short like 'FR_Rho%';
update  carto.t_emu_emu  set emu_name='Rhone Mediterranee' where emu_name like 'Rho%';
--don't use this
--update carto.t_emu_emu set emu_name_short=emu_coun_abrev||'_'||substring(emu_name,1,4);
update carto.t_emuagreg_ema set emu_name_short='GB_NorE' where emu_name='North Eastern';
update carto.t_emuagreg_ema set emu_name_short='GB_NorW' where emu_name_short='North West';


select * from carto.t_emu_emu where emu_cty_id='EE'
update carto.t_emu_emu set emu_name='Narva' where emu_id=64
update carto.t_emu_emu set emu_name_short='EE_Narv' where emu_name_short='EE_Inla'

--0000000000000000000000000000000000000000000000000
--creating the joined layer
-- this is for carto.t_emuagreg_ema
--0000000000000000000000000000000000000000000000000
drop table if exists carto.t_emuagreg_ema ;
create table carto.t_emuagreg_ema as
select emu_name_short,emu_name,emu_coun_abrev,emu_hyd_syst_s,emu_sea, sum(emu_areakm2),st_union(geom) as geom from 
carto.t_emu_emu
group by emu_name_short,emu_name,emu_coun_abrev,emu_hyd_syst_s,emu_sea;
alter table carto.t_emuagreg_ema add column centre geometry;
alter table carto.t_emuagreg_ema add column gid serial primary key;
update carto.t_emuagreg_ema set centre = sub.centre from
(select st_centroid(geom) centre, gid  from carto.t_emuagreg_ema)sub
where t_emuagreg_ema.gid=sub.gid; --113
alter table carto.t_emuagreg_ema add column x numeric;
update carto.t_emuagreg_ema set x=st_x(centre);
alter table carto.t_emuagreg_ema add column y numeric;
update carto.t_emuagreg_ema set y=st_y(centre);
alter table carto.t_emuagreg_ema add column emu_cty_id character varying(2);
update carto.t_emuagreg_ema set emu_cty_id=emu_coun_abrev;
update carto.t_emuagreg_ema set emu_cty_id='UK' where emu_cty_id='GB';--17
-- creating indexes
create index id_t_emuagreg_ema on carto.t_emuagreg_ema using gist(geom);
create index idxbtree_t_emuagreg_ema on carto.t_emuagreg_ema using btree(gid);
alter table carto.t_emuagreg_ema add column dist_Sargasso_km numeric;
update carto.t_emuagreg_ema set dist_sargasso_km=
round(cast(st_distance(st_transform(st_PointFromText('POINT(-66 26)',4326),3035),geom)/1000 as numeric),2);-- ici je suis allé sur google maps pour chercher les coordonnées


--------------------------
-- 2017 Updating table now named
-- ref.tr_emusplit_ems
-- ref.tr_emu_emu
---------------------------------

-- the problem below is that the primary key must be set on both emu and country
-- as there are transboundary emus....
alter table ref.tr_emu_emu drop constraint enforce_srid_the_geom;
alter table ref.tr_emusplit_ems drop constraint c_fk_emu_nameshort;
alter table datawg.t_series_ser drop constraint c_fk_emu_name_short;
--
alter table datawg.t_eelstock_eel drop constraint c_fk_emu_name_short;
alter table  ref.tr_emu_emu drop constraint tr_emu_emu_pkey ;
alter table ref.tr_emu_emu rename column emu_coun_abrev to emu_cou_code;
-- missing luxembourg which is in the emu table
update ref.tr_country_cou set cou_order= cou_order+1 where cou_order >=15; 
insert into ref.tr_country_cou values ('LU','Luxembourg',15);
-- Vattican missing can you believe that ?
insert into ref.tr_country_cou values ('VA','Vattican',46);
alter table ref.tr_emu_emu add constraint c_fk_cou_code foreign key (emu_cou_code) references ref.tr_country_cou(cou_code);
alter table ref.tr_emu_emu add constraint tr_emu_emu_pkey primary key(emu_nameshort,emu_cou_code);

----
--- the emu table was wrong
-- I'm re-creating it clean
------
delete from ref.tr_emu_emu;
insert into ref.tr_emu_emu (emu_nameshort,emu_cou_code,geom) 
select emu_nameshort,
emu_coun_abrev,
st_transform(st_union(geom),4326) as geom from 
ref.tr_emusplit_ems
group by emu_nameshort,emu_coun_abrev;


alter table ref.tr_emu_emu ADD CONSTRAINT enforce_srid_the_geom CHECK (st_srid(geom) = 4326);
alter table datawg.t_eelstock_eel add constraint c_fk_emu foreign key (eel_emu_nameshort,eel_cou_code) references ref.tr_emu_emu(emu_nameshort,emu_cou_code);

--select * from datawg.t_series_ser where ser_emu_nameshort='NL_Neth';
update datawg.t_series_ser set ser_emu_nameshort='DE_Ems' where ser_nameshort='Ems'; 
-- inserting total countries in emu table
insert into  ref.tr_emu_emu (emu_nameshort,emu_cou_code) 
select cou_code||'_total',cou_code from ref.tr_country_cou ;--46 lines inserted

insert into ref.tr_emu_emu (emu_nameshort,emu_cou_code) 
select cou_code||'_outside_emu',cou_code from ref.tr_country_cou ;-- 46 lines inserted

alter table datawg.t_series_ser add constraint c_fk_emu foreign key (ser_emu_nameshort,ser_cou_code) 
	references ref.tr_emu_emu(emu_nameshort,emu_cou_code);
	
	
/*
dos script used to create this table (using shp2pgsql and psql):
f:
cd F:\workspace\wgeeldata\shp
REM -d drops de table, table is in wgs84
shp2pgsql -s 4326 -g geom -W "LATIN1" -I ISO3Code_2014 ref.tempwcountries>tempwcountries.sql 
REM IMPORT INTO POSTGRES
psql -U postgres -f "tempwcountries.sql " wgeel
*/
--removing west from -20 °
delete from ref.tempwcountries where st_x(st_centroid(geom))<-20;
-- removing south from 20 °
delete from ref.tempwcountries where st_y(st_centroid(geom))<20;
delete  from ref.tempwcountries
where st_x(st_centroid(geom))>40 and  iso!='RUS';
-----
-- splitting russia to only keep baltic part
-----------------
drop table ref.tempru;
create temporary sequence seq;
create table ref.tempru as select nextval('seq'),(st_dump(geom)).geom as geom from ref.tempwcountries where iso='RUS';
select st_x(st_centroid(geom)) from ref.tempru;
delete from ref.tempru where  st_x(st_centroid(geom))>30;
-------------------------------------
update ref.tempwcountries set geom =
(select
st_multi(st_union(tempru.geom)) from ref.tempru)
where iso='RUS';

delete  from ref.tempwcountries where iso='MDA';
delete  from ref.tempwcountries where iso='UKR';
delete  from ref.tempwcountries where iso='JOR';
delete  from ref.tempwcountries where iso='BGR';
delete  from ref.tempwcountries where iso='BLR';
delete  from ref.tempwcountries where iso='ROU';
delete  from ref.tempwcountries where iso='SRB';
delete  from ref.tempwcountries where iso='AUT';
delete  from ref.tempwcountries where iso='HUN';
delete  from ref.tempwcountries where iso='SVK';
delete  from ref.tempwcountries where iso='CHE';
delete  from ref.tempwcountries where iso='MRT';




------------------------
-- I need to make the correspondance between iso2 (ICES) and iso3 standard country codes
drop table	ref.tmpcountrynames;
create table ref.tmpcountrynames (
name text,
iso2 text,
iso3 text,
iso_UNM49_numeric numeric);
set CLIENT_ENCODING to 'WIN1252'
copy  ref.tmpcountrynames from 'F:/workspace/wgeeldata/shp/country_names_iso2_iso3.csv' WITH CSV header delimiter as ';';
select * from ref.tr_country_cou;
select * from ref.tmpcountrynames;

comment on column  ref.tr_country_cou.cou_code is 'ISO2 two letter code'
alter table ref.tr_country_cou add column cou_iso3code character varying(3);



comment on column  ref.tr_country_cou.cou_iso3code is 'ISO3 three letter code'
update ref.tr_country_cou set cou_iso3code=iso3 from  ref.tmpcountrynames  
where cou_code =iso2 


-- now reintegrating the shapes into the tr_country_cou file
select cou_code from ref.tr_country_cou;
select * from ref.tempwcountries 
full outer join 
ref.tr_country_cou on cou_iso3code=iso
-- removing some countries from the black sea
delete from ref.tr_emu_emu where emu_cou_code in ('RO','MD','UA','GE','BG','AT','SK');
delete from ref.tr_country_cou where cou_code in ('RO','MD','UA','GE','BG','AT','SK');


-----------------------------------------
-- adding missing  geom to the countries table
-------------------------------------------
update ref.tr_country_cou set geom = tempwcountries.geom from
ref.tempwcountries where  cou_iso3code=iso;


---------------------------------
-- adding missing geom to the emu tables
-------------------------------------------

select * from ref.tr_emu_emu limit 10
alter table ref.tr_emu_emu add column emu_wholecountry boolean;
update ref.tr_emu_emu set emu_wholecountry=false where geom is not null;
update ref.tr_emu_emu set emu_wholecountry=true where emu_nameshort  like '%_total';
update ref.tr_emu_emu set geom=tr_country_cou.geom from
ref.tr_country_cou
where emu_wholecountry
and emu_cou_code=cou_code;--39 rows updated



-------------------
--- removing geom for countries where we have a shapefile
-- at a level more detailed than the national level
--------------------------
update  ref.tr_emu_emu set geom =null where emu_nameshort in (
select emu_nameshort from ref.tr_emu_emu  where emu_cou_code in
(select distinct emu_cou_code from ref.tr_emu_emu where emu_nameshort not like '%total'
and emu_nameshort not like '%outside_emu%') -- countries with shapefile coming from the wise layer
and emu_nameshort like '%total%');

-------------------
--- There is a part of russia far to the east, I must remove it
-- and then russia must be integrated with emu again
--------------------------


select * from ref.tr_country_cou where cou_code = 'RU'

drop table ref.tempru;
create temporary sequence seq;
create table ref.tempru as select nextval('seq'),(st_dump(geom)).geom as geom from ref.tr_country_cou where cou_code = 'RU'
select st_x(st_centroid(geom)) from ref.tempru;
delete from ref.tempru where  st_x(st_centroid(geom))>30;
delete from ref.tempru where  st_x(st_centroid(geom))<0;
BEGIN;
delete from ref.tr_emu_emu where emu_cou_code='RU';
delete from ref.tr_country_cou where cou_code = 'RU' ;
COMMIT;

-- re-inserting RUSSIA
insert into ref.tr_country_cou (cou_code, cou_country, cou_order, geom, cou_iso3code) 
SELECT 'RU','Russia',8,st_multi(st_union(tempru.geom)),'RUS' from ref.tempru;
drop table ref.tempru;
select * from ref.tr_emu_emu limit 10

insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) values ('RU_outside_emu',NULL,'RU',NULL,FALSE);
insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) select 'RU_total',NULL,'RU',geom,TRUE 
		FROM ref.tr_country_cou where cou_code='RU';

---------------------------
-- remove all outside emu
-- the wgeel chanded its mind, these outside_emu catergories should not be used
-- you can't plot them on a map
-- in fact we only had one emu with them and it was a mistake
-----------------------------

delete from ref.tr_emu_emu where emu_nameshort like '%outside_emu';

------------------------------
-- Tunisia has three new emus
------------------------------


insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) values ('TN_Nor','Tunisia North','TN',NULL,FALSE);
insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) values ('TN_NE','Tunisia North East Medjerda','TN',NULL,FALSE);
insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) values ('TN_EC','Tunisia East and centre','TN',NULL,FALSE);
insert into ref.tr_emu_emu(emu_nameshort, emu_name, emu_cou_code,geom,emu_wholecountry) values ('TN_SO','Tunisia South','TN',NULL,FALSE);