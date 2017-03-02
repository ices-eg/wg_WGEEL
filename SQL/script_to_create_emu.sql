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

