-- bigtable, no modification just combining different table
drop view if exists datawg.bigtable cascade;
create or replace view datawg.bigtable as
with 
	b0 as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(sum(eel_value)) as b0 -- NO has biomass data per ICES division
		from datawg.b0
		group by eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code),
	bbest as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(sum(eel_value)) as bbest -- NO has biomass data per ICES division
		from datawg.bbest
		group by eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code),
	bcurrent as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(sum(eel_value)) as bcurrent -- NO has biomass data per ICES division
		from datawg.bcurrent
		group by eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code),
	suma as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(eel_value,3) as suma from datawg.sigmaa),
	sumf as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(eel_value,3) as sumf from datawg.sigmaf),
	sumh as
		(select eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, round(eel_value,3) as sumh from datawg.sigmah),
	countries as
		(select cou_code, cou_country as country, cou_order from "ref".tr_country_cou),
	emu as
		(select emu_nameshort, emu_wholecountry from "ref".tr_emu_emu),
	habitat as
		(select hty_code, hty_description as habitat from "ref".tr_habitattype_hty),
	life_stage as
		(select lfs_code, lfs_name as life_stage from "ref".tr_lifestage_lfs)
select eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat, eel_lfs_code, life_stage, b0, bbest, bcurrent, suma, sumf, sumh
from b0 
	full outer join bbest using(eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
	full outer join bcurrent using(eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
	full outer join suma using(eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
	full outer join sumf using(eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
	full outer join sumh using(eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
	full outer join countries on eel_cou_code = cou_code
	join emu on eel_emu_nameshort = emu_nameshort 
	join habitat on eel_hty_code = hty_code
	join life_stage on eel_lfs_code = lfs_code
order by eel_year, cou_order, eel_emu_nameshort,
case 
	when eel_hty_code = 'F' then 1
	when eel_hty_code = 'T' then 2
	when eel_hty_code = 'C' then 3
	when eel_hty_code = 'MO' then 4
	when eel_hty_code = 'AL' then 5
end,
case 
	when eel_lfs_code = 'G' then 1
	when eel_lfs_code = 'QG' then 2
	when eel_lfs_code = 'OG' then 3
	when eel_lfs_code = 'GY' then 4
	when eel_lfs_code = 'Y' then 5
	when eel_lfs_code = 'YS' then 6
	when eel_lfs_code = 'S' then 7
	when eel_lfs_code = 'AL' then 8
end
;

-- check for duplicate  at the life stage level
select eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat, eel_lfs_code, count(*)
from datawg.bigtable
group by eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat, eel_lfs_code
having count(*) > 1
; 
-- NO provide biomass data by ICES division

-- check for duplicate  at the habitat level
select eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat, count(*)
from datawg.bigtable
group by eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat
having count(*) > 1
; 
-- NL_total: provide mortality for YS, but biomass for S
-- SE_West: provide mortality for Y, but biomass for S
-- NO_total: provide mortality for YS (A & F) and AL (H), but biomass for S
-- PT_Port: provide mortality for AL, but biomass for S
-- conclusion: we can safely sum

-- bigtable aggregated by habitat
drop view if exists datawg.bigtable_by_habitat cascade;
create or replace view datawg.bigtable_by_habitat as
select eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat, sum(b0) as b0, sum(bbest) as bbest, sum(bcurrent) as bcurrent, sum(suma) as suma, sum(sumf) as sumf, sum(sumh) as sumh, string_agg(eel_lfs_code , ', ') as aggregated_lfs
from datawg.bigtable 
group by eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat
order by eel_year, cou_order, eel_emu_nameshort,
case 
	when eel_hty_code = 'F' then 1
	when eel_hty_code = 'T' then 2
	when eel_hty_code = 'C' then 3
	when eel_hty_code = 'MO' then 4
	when eel_hty_code = 'AL' then 5
end
;

-- check aggreg by habitat on biomass
select sum(b0), sum(bbest), sum(bcurrent) from datawg.bigtable;
select sum(b0), sum(bbest), sum(bcurrent) from datawg.bigtable_by_habitat;
-- pass

-- check for duplicate  at the emu level
with too_many_habitats as
	(select eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, count(*)
	from datawg.bigtable_by_habitat
	group by eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry
	having count(*) > 1)
select eel_emu_nameshort, count(*) from too_many_habitats group by eel_emu_nameshort order by eel_emu_nameshort
;
/*
-- ES
	ES_Anda: B in F, T & AL (being F + T) --> FIXME: remove Bcurrent for AL
	ES_Astu: data in F, T & AL --> can be added
	ES_Basq: data in F, T & AL --> can be added
	ES_Cant: data in F, T & AL --> can be added
	ES_Cast: data in F & AL --> can be added
	ES_Cata: B in F, T & AL (being F + T) --> FIXME: remove Bcurrent for AL / ! no mortality in F ==> (sumA, sum F) can't be calculated
	ES_Gali: B in F, T & AL --> B, sumA & sumH can be added / ! no  F mortality in T, but sumA in AL seems to be sumF in F + sumH in AL ==> can be added
	ES_Inne: data in F & AL --> can be added
	ES_Minh: data in T & AL --> can be added
	ES_Murc: in F, T & C --> nothing, but B0 can be calculated
	ES_Nava: data in F, AL --> can be added
	ES_Vale: B in F, T & AL (being F + T) --> FIXME: remove Bcurrent for AL for 2017
-- IE
	IE_East: data in F, T & AL --> can be added
	IE_NorW: data in F, T & AL --> can be added
	IE_Shan: data in F, T & AL --> can be added
	IE_SouE: data in F, T & AL --> can be added
	IE_SouW: data in F, T & AL --> can be added
	IE_West: data in F, T & AL --> can be added
-- IT
	IT_Abru: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Basi: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Cala: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Camp: data in F, T ==> B can be added & mortalities calculated
	IT_Emil: data in F, T ==> B can be added & mortalities calculated
	IT_Frio: data in F, T ==> B can be added & mortalities calculated
	IT_Lazi: data in F, T ==> B can be added & mortalities calculated
	IT_Ligu: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Lomb: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Marc: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Moli: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Piem: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Pugl: data in F, T ==> B can be added & mortalities calculated
	IT_Sard: data in F, T ==> B can be added & mortalities calculated
	IT_Sici: data in F, T ==> B can be added & mortalities calculated
	IT_Tosc: data in F, T ==> B can be added & mortalities calculated
	IT_Tren: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Umbr: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Vall: all data in F, only sumH in T ==> nothing, but sumH can be calculated
	IT_Vene: data in F, T ==> B can be added & mortalities calculated
-- LT
	LT_total: B0 in T, the rest in F ==> nothing can be calculated
-- PL
	PL_Vist: data in AL, sumH only in F (being turbines) ==> can be added
*/

-- correct the "FIXME" above
begin;
update datawg.t_eelstock_eel set eel_qal_id = 3, eel_qal_comment = "eel_qal_comment" || 'duplicate from F and T'
where eel_emu_nameshort in ('ES_Anda', 'ES_Cata') and eel_hty_code = 'AL' and eel_typ_id = 15
;
update datawg.t_eelstock_eel set eel_qal_id = 3, eel_qal_comment = "eel_qal_comment" || 'duplicate from F and T'
where eel_emu_nameshort in ('ES_Vale') and eel_hty_code = 'AL' and eel_typ_id = 15 and eel_year  = 2017
;

commit;
--rollback ;

-- bigtable aggregated by EMU
drop view if exists datawg.bigtable_by_emu cascade;
create or replace view datawg.bigtable_by_emu as
select eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, 
	case 
		when eel_emu_nameshort in ('IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		else sum(b0) 
	end as b0,
	case 
		when eel_emu_nameshort in ('ES_Murc', 'IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		else sum(bbest) 
	end as bbest,
	case 
		when eel_emu_nameshort in ('ES_Murc', 'IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		else sum(bcurrent) 
	end as bcurrent,
	case 
		when eel_emu_nameshort in ('ES_Cata', 'ES_Murc', 'IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		when eel_emu_nameshort in ('IT_Camp', 'IT_Emil', 'IT_Frio', 'IT_Lazi', 'IT_Pugl', 'IT_Sard', 'IT_Sici', 'IT_Tosc', 'IT_Vene') then round(sum(suma*bbest)/sum(bbest),3)
		else sum(suma) 
	end as suma,
	case 
		when eel_emu_nameshort in ('ES_Cata', 'ES_Murc', 'IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		when eel_emu_nameshort in ('IT_Camp', 'IT_Emil', 'IT_Frio', 'IT_Lazi', 'IT_Pugl', 'IT_Sard', 'IT_Sici', 'IT_Tosc', 'IT_Vene') then round(sum(sumf*bbest)/sum(bbest),3)
		else sum(sumf) 
	end as sumf,
	case 
		when eel_emu_nameshort in ('ES_Murc', 'LT_total') then null
		when eel_emu_nameshort in ('IT_Camp', 'IT_Emil', 'IT_Frio', 'IT_Lazi', 'IT_Pugl', 'IT_Sard', 'IT_Sici', 'IT_Tosc', 'IT_Vene') then round(sum(sumh*bbest)/sum(bbest),3)
		else sum(sumh) 
	end as sumh, 
	aggregated_lfs, string_agg(eel_hty_code , ', ') as aggregated_hty
from datawg.bigtable_by_habitat 
group by eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, aggregated_lfs
order by eel_year, cou_order, eel_emu_nameshort
;

-- check everything went well (1 line per EMU/year)
select eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, count(*)
from datawg.bigtable_by_emu
group by eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry
having count(*) > 1
; 






drop view if exists DATAWG.biomass_synthesis CASCADE;
create or REPLACE view DATAWG.biomass_synthesis AS
with B0_avg AS
	(with B0_AL AS
		(select EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_YEAR, 
		case when count(eel_value)< COUNT(*) then null else SUM(eel_value) end -- by default sum of null and value is not a null value, this part correct that
		from DATAWG.B0
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR)
		-- pour gerer la merde
	select EEL_COU_CODE,EEL_EMU_NAMESHORT, AVG(SUM) as b0_avg from B0_AL
	group by EEL_COU_CODE,EEL_EMU_NAMESHORT),
	B0_AL AS
		(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR,
		case when count(eel_value)< COUNT(*) then null else SUM(eel_value) end as b0-- by default sum of null and value is not a null value, this part correct that
		from DATAWG.B0
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR),
	Bbest_AL AS
		(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR, 
		case when count(eel_value)< COUNT(*) then null else SUM(eel_value) end as bbest -- by default sum of null and value is not a null value, this part correct that
		from DATAWG.Bbest
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR), 
	Bcurrent_AL as
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR,
	case when count(eel_value)< COUNT(*) then null else SUM(eel_value) end as bcurrent -- by default sum of null and value is not a null value, this part correct that 
	from DATAWG.BCURRENT
group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR)
select EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, COALESCE(b0, b0_avg) as b0, bbest, bcurrent from bcurrent_AL 
join B0_avg using(EEL_COU_CODE,EEL_EMU_NAMESHORT) 
left outer join Bbest_AL using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
left OUTER join B0_AL using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
;

SELECT * from DATAWG.BIOMASS_SYNTHESIS order by eel_emu_nameshort, eel_year;

-- aggregation at the country level
SELECT EEL_COU_CODE, eel_year, 
case when count(B0)< COUNT(*) then null else SUM(B0) end as B0,
case when count(Bbest)< COUNT(*) then null else SUM(Bbest) end as Bbest,
case when count(Bcurrent)< COUNT(*) then null else SUM(Bcurrent) end as Bcurrent
from DATAWG.BIOMASS_SYNTHESIS
group by EEL_COU_CODE, eel_year;

drop view if exists DATAWG.mortality_synthesis CASCADE ;
create or REPLACE view DATAWG.mortality_synthesis AS
with sigma AS
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code, eel_value as suma from DATAWG.SIGMAA),
	sigmaf AS
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code, eel_value as sumf from DATAWG.SIGMAf),
	sigmah AS
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code, eel_value as sumh from DATAWG.SIGMAh),
	Bbest AS
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR, eel_hty_code, eel_value as bbest from DATAWG.Bbest)
select *, suma*bbest as sab, sumf*bbest as sfb, sumh*bbest as shb from sigma
left outer join sigmaf using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code)
left outer join sigmah using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code)
left outer join bbest using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, eel_hty_code)
;

select * from DATAWG.MORTALITY_SYNTHESIS;



-- precodata at the emu level
drop view if exists DATAWG.precodata_emu CASCADE;
create or REPLACE view DATAWG.precodata_emu as
select EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_EMU_NAMESHORT as aggreg_area, eel_year, b0, BIOMASS_SYNTHESIS.bbest, bcurrent, 
round(case when EEL_COU_CODE = 'IE' THEN sum(suma) -- solved case when suma in AL only (IE)
	when BIOMASS_SYNTHESIS.bbest > 0 then sum(sab)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as suma,
round(case when EEL_COU_CODE = 'IE' THEN sum(sumf) -- solved case when suma in AL only (I
	when BIOMASS_SYNTHESIS.bbest > 0 then sum(sfb)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as sumf,
round(case when EEL_COU_CODE = 'IE' THEN sum(sumh) -- solved case when suma in AL only (I
	when BIOMASS_SYNTHESIS.bbest > 0 then sum(shb)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as sumh,
'emu' as aggreg_level
from DATAWG.MORTALITY_SYNTHESIS left outer join DATAWG.BIOMASS_SYNTHESIS using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
group by EEL_COU_CODE, EEL_EMU_NAMESHORT, eel_year, b0, BIOMASS_SYNTHESIS.bbest, bcurrent
;

select * from DATAWG.PRECODATA_EMU;

-- precodata at the country level
drop view if exists DATAWG.precodata_country  cascade;
create or REPLACE view DATAWG.precodata_country as
with country_biomass as
	(SELECT EEL_COU_CODE, eel_year, 
	case when count(B0)< COUNT(*) then null else SUM(B0) end as B0, -- by default sum of null and value is not a null value, this part correct that
	case when count(BBest)< COUNT(*) then null else SUM(BBest) end as BBest, -- by default sum of null and value is not a null value, this part correct that
	case when count(Bcurrent)< COUNT(*) then null else SUM(Bcurrent) end as Bcurrent-- by default sum of null and value is not a null value, this part correct that
	from DATAWG.PRECODATA_EMU 
	group by EEL_COU_CODE, eel_year)
select EEL_COU_CODE, null EEL_EMU_NAMESHORT, EEL_COU_CODE as aggreg_area, eel_year, round(country_biomass.b0/1000) as b0, round(country_biomass.bbest/1000) as bbest, round(country_biomass.bcurrent/1000) as bcurrent, 
round(case when country_biomass.bbest > 0 then sum(suma * PRECODATA_EMU.bbest)/(country_biomass.bbest) ELSE NULL end, 2) as suma,
round(case when country_biomass.bbest > 0 then sum(sumf * PRECODATA_EMU.bbest)/(country_biomass.bbest) ELSE NULL end, 2) as sumf,
round(case when country_biomass.bbest > 0 then sum(sumh * PRECODATA_EMU.bbest)/(country_biomass.bbest) ELSE NULL end, 2) as sumh,
'country' as aggreg_level
from DATAWG.PRECODATA_EMU left outer join country_biomass using(EEL_COU_CODE, eel_year)
group by EEL_COU_CODE, eel_year, country_biomass.b0, country_biomass.bbest, country_biomass.bcurrent
;

SELECT * from DATAWG.PRECODATA_COUNTRY ;

-- precodata for all country
drop view if exists DATAWG.precodata_all;
create or REPLACE view DATAWG.precodata_all as
with all_level as
(
	(with last_year_emu as
		(select EEL_EMU_NAMESHORT, max(EEL_YEAR) as last_year from DATAWG.PRECODATA_emu 
		where b0 is not null and bbest is not null and bcurrent is not null and suma is not null group by EEL_EMU_NAMESHORT) --last year should the last COMPLETE (b0, bbest, bcurrent, suma) year
	select eel_cou_code, eel_emu_nameshort, aggreg_area, eel_year, b0, bbest, bcurrent, suma, sumf, sumh, aggreg_level, last_year from DATAWG.precodata_emu join last_year_emu using(EEL_EMU_NAMESHORT))
	union
	(with last_year_country as
		(select EEL_COU_CODE, max(EEL_YEAR) as last_year from DATAWG.PRECODATA_COUNTRY
		where b0 is not null and bbest is not null and bcurrent is not null and suma is not null group by EEL_COU_CODE) --last year should the last COMPLETE (b0, bbest, bcurrent, suma) year
	select * from DATAWG.precodata_country join last_year_country using(EEL_COU_CODE))
	union
	(select null EEL_COU_CODE, null EEL_EMU_NAMESHORT, 'All (' || count(*) || ' countries: ' || string_agg(EEL_COU_CODE, ',') || ')' AGGREG_AREA, eel_year, 
		sum(b0) as b0, sum(bbest)as bbest, sum(bcurrent)as bcurrent,
		round(sum(suma*bbest)/sum(bbest),2) as suma, 
		case when count(sumf)< COUNT(*) then null else round(sum(sumf*bbest)/sum(bbest),2) end as sumf, -- by default sum of null and value is not a null value, this part correct that
		case when count(sumh)< COUNT(*) then null else round(sum(sumh*bbest)/sum(bbest),2) end as sumf, -- by default sum of null and value is not a null value, this part correct that
		'all' as aggreg_level, null last_year
	from DATAWG.precodata_country
	where b0 is not null and bbest is not null and BCURRENT is not NULL and SUMA is not null
	group by EEL_YEAR)
) select all_level.* from all_level left outer join "ref".TR_COUNTRY_COU on EEL_COU_CODE = cou_code
order by eel_year,
-- order my aggreg_level: emu, country, all
case 
	when aggreg_level = 'emu' then 1
	when aggreg_level = 'country' then 2
	when aggreg_level = 'all' then 3
end,
cou_order, EEL_EMU_NAMESHORT 
;

select * from DATAWG.precodata_all;