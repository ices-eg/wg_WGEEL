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

/* EMU details
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
drop view if exists datawg.precodata_emu cascade;
create or replace view datawg.precodata_emu AS
WITH b0_unique AS
	(SELECT eel_emu_nameshort, B0 AS unique_b0
	FROM datawg.bigtable_by_habitat
	WHERE eel_year = 1800
	)
select eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, 
	case 
		when eel_emu_nameshort in ('IT_Abru', 'IT_Basi', 'IT_Cala', 'IT_Ligu', 'IT_Lomb', 'IT_Marc', 'IT_Moli', 'IT_Piem', 'IT_Tren', 'IT_Umbr', 'IT_Vall', 'LT_total') then null
		else COALESCE(sum(unique_b0), sum(b0)) 
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
	'emu' as aggreg_level, aggregated_lfs, string_agg(eel_hty_code , ', ') as aggregated_hty
from datawg.bigtable_by_habitat 
LEFT OUTER JOIN B0_unique USING(eel_emu_nameshort)
WHERE eel_year > 1850
group by eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, aggregated_lfs
order by eel_year, cou_order, eel_emu_nameshort
;

-- check everything went well (1 line per EMU/year)
select eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry, count(*)
from datawg.precodata_emu
group by eel_year, eel_cou_code, country, eel_emu_nameshort, emu_wholecountry
having count(*) > 1
;

-- handle B0
SELECT eel_emu_nameshort, count(*), min(b0) - max(b0)
FROM datawg.precodata_emu
WHERE b0 IS NOT NULL
GROUP BY eel_emu_nameshort
ORDER BY eel_emu_nameshort;
-- the only only having changing B0 are GB and SE

SELECT eel_typ_id, 1800 AS eel_year, eel_value, eel_emu_nameshort, eel_cou_code, eel_lfs_code, eel_hty_code, eel_area_division, eel_qal_id, eel_qal_comment, eel_comment, eel_datelastupdate, eel_missvaluequal, eel_datasource
FROM datawg.t_eelstock_eel
WHERE eel_typ_id = 13 AND eel_cou_code NOT IN ('GB', 'SE') AND eel_qal_id IN (1,2,4)
GROUP BY eel_typ_id, eel_value, eel_emu_nameshort, eel_cou_code, eel_lfs_code, eel_hty_code, eel_area_division, eel_qal_id, eel_qal_comment, eel_comment, eel_datelastupdate, eel_missvaluequal, eel_datasource
ORDER BY eel_emu_nameshort;

-- add unique B0 in 1800 for all but SE and GB
BEGIN;
INSERT INTO datawg.t_eelstock_eel(eel_typ_id, eel_year, eel_value, eel_emu_nameshort, eel_cou_code, eel_lfs_code, eel_hty_code, eel_area_division, eel_qal_id, eel_qal_comment, eel_comment, eel_datelastupdate, eel_missvaluequal, eel_datasource)
SELECT eel_typ_id, 1800::NUMERIC AS eel_year, eel_value, eel_emu_nameshort, eel_cou_code, eel_lfs_code, eel_hty_code, eel_area_division, eel_qal_id, eel_qal_comment, eel_comment, eel_datelastupdate, eel_missvaluequal, eel_datasource
FROM datawg.t_eelstock_eel
WHERE eel_typ_id = 13 AND eel_cou_code NOT IN ('GB', 'SE') AND eel_qal_id IN (1,2,4)
GROUP BY eel_typ_id, eel_value, eel_emu_nameshort, eel_cou_code, eel_lfs_code, eel_hty_code, eel_area_division, eel_qal_id, eel_qal_comment, eel_comment, eel_datelastupdate, eel_missvaluequal, eel_datasource
ORDER BY eel_emu_nameshort;

COMMIT;
--ROLLBACK;

-- change quality for all B0 but SE and GB
BEGIN;
UPDATE datawg.t_eelstock_eel SET eel_qal_id = 18, eel_qal_comment = eel_qal_comment || ', change for year 1800'
WHERE eel_typ_id = 13 AND eel_cou_code NOT IN ('GB', 'SE') AND eel_qal_id IN (1,2,4) AND eel_year > 1850;

COMMIT;
--ROLLBACK;


-- aggregation the country level
drop view if exists DATAWG.precodata_country  cascade;
create or REPLACE view DATAWG.precodata_country as
WITH
	nr_emu_per_country AS
		(SELECT emu_cou_code, sum((NOT emu_wholecountry)::int) AS nr_emu 
		FROM "ref".tr_emu_emu
		GROUP BY emu_cou_code),
	mimimun_met AS
		(SELECT eel_year, eel_cou_code, country, eel_emu_nameshort, b0, bbest, bcurrent, suma, sumf, sumh,
		b0  IS NOT NULL AS b0t, bbest IS NOT NULL AS bbestt, bcurrent IS NOT NULL AS bcurrentt, suma IS NOT NULL AS sumat, sumf IS NOT NULL AS sumft, sumh IS NOT NULL AS sumht
		FROM datawg.precodata_emu
		WHERE NOT emu_wholecountry
		),
	analyse_EMU_Total AS
		(SELECT eel_year, eel_cou_code, country, b0, bbest, bcurrent, suma, sumf, sumh,
		(b0  IS NOT NULL)::int AS b0_total, (bbest IS NOT NULL)::int AS bbest_total, (bcurrent IS NOT NULL)::int AS bcurrent_total,
		(suma IS NOT NULL)::int AS suma_total, (sumf IS NOT NULL)::int AS sumf_total, (sumh IS NOT NULL)::int AS sumh_total
		FROM datawg.precodata_emu
		WHERE emu_wholecountry
		),
	analyse_EMU AS
		(SELECT eel_year, eel_cou_code AS eel_cou_code, country, count(*) AS counted_emu, 
		sum(b0t::int) AS b0_emu, sum(bbestt::int) AS bbest_emu, sum(bcurrentt::int) AS bcurrent_emu,
		sum(sumat::int) AS suma_emu, sum(sumft::int) AS sumf_emu, sum(sumht::int) AS sumh_emu,
		sum(b0) AS b0, sum(bbest) AS bbest, sum(bcurrent) AS bcurrent,
		round(sum(suma*bbest)/sum(bbest),3) AS suma, 
		round(sum(sumf*bbest)/sum(bbest),3) AS sumf, 
		round(sum(sumh*bbest)/sum(bbest),3) AS sumh
		FROM mimimun_met
		GROUP BY eel_year, eel_cou_code, country
		)
SELECT eel_year, eel_cou_code, country, nr_emu, 'country' aggreg_level, NULL eel_emu_nameshort,
	CASE
		WHEN b0_total = 1 THEN analyse_EMU_Total.b0
		ELSE analyse_EMU.b0
	END AS b0,
	CASE
		WHEN bbest_total = 1 THEN analyse_EMU_Total.bbest
		ELSE analyse_EMU.bbest
	END AS bbest,
	CASE
		WHEN bcurrent_total = 1 THEN analyse_EMU_Total.bcurrent
		ELSE analyse_EMU.bcurrent
	END AS bcurrent,
	CASE
		WHEN suma_total = 1 THEN analyse_EMU_Total.suma
		ELSE analyse_EMU.suma
	END AS suma,
	CASE
		WHEN sumf_total = 1 THEN analyse_EMU_Total.sumf
		ELSE analyse_EMU.sumf
	END AS sumf,
	CASE
		WHEN sumh_total = 1 THEN analyse_EMU_Total.sumh
		ELSE analyse_EMU.sumh
	END AS sumh,
	CASE
		WHEN b0_total = 1 THEN 'EMU_Total'
		WHEN b0_emu = nr_emu THEN 'Sum of all EMU'
		WHEN b0_emu > 0 THEN 'Sum of ' || b0_emu || ' EMU out of ' || nr_emu
	END AS method_b0,
	CASE
		WHEN bbest_total = 1 THEN 'EMU_Total'
		WHEN bbest_emu = nr_emu THEN 'Sum of all EMU'
		WHEN bbest_emu > 0 THEN 'Sum of ' || bbest_emu || ' EMU out of ' || nr_emu
		--TODO: nb of EMU aggregate my differ between indicator ; should we do somethong special ?
	END AS method_bbest,
	CASE
		WHEN bcurrent_total = 1 THEN 'EMU_Total'
		WHEN bcurrent_emu = nr_emu THEN 'Sum of all EMU'
		WHEN bcurrent_emu > 0 THEN 'Sum of ' || bcurrent_emu || ' EMU out of ' || nr_emu
	END AS method_bcurrent,
	CASE
		WHEN suma_total = 1 THEN 'EMU_Total'
		WHEN bbest_emu = nr_emu AND suma_emu = nr_emu THEN 'Weighted average by Bbest of all EMU'
		WHEN bbest_emu < nr_emu AND suma_emu < nr_emu AND suma_emu>0  THEN 'Weighted average by Bbest of ' || least(bbest_emu, suma_emu) || ' EMU out of ' || nr_emu
	END AS method_suma,
	CASE
		WHEN sumf_total = 1 THEN 'EMU_Total'
		WHEN bbest_emu = nr_emu AND sumf_emu = nr_emu THEN 'Weighted average by Bbest of all EMU'
		WHEN bbest_emu < nr_emu AND sumf_emu < nr_emu AND sumf_emu>0  THEN 'Weighted average by Bbest of ' || least(bbest_emu, sumf_emu) || ' EMU out of ' || nr_emu
	END AS method_sumf,
	CASE
		WHEN sumh_total = 1 THEN 'EMU_Total'
		WHEN bbest_emu = nr_emu AND sumh_emu = nr_emu THEN 'Weighted average by Bbest of all EMU'
		WHEN bbest_emu < nr_emu AND sumh_emu < nr_emu AND sumh_emu>0  THEN 'Weighted average by Bbest of ' || least(bbest_emu, sumh_emu) || ' EMU out of ' || nr_emu
	END AS method_sumh
FROM analyse_EMU_Total 
	FULL OUTER JOIN analyse_EMU USING(eel_year, eel_cou_code, country)
	JOIN nr_emu_per_country ON (eel_cou_code = emu_cou_code)
	JOIN "ref".tr_country_cou ON (eel_cou_code = cou_code)
ORDER BY eel_year, cou_order
;

-- precodata for all country
drop view if exists DATAWG.precodata_all;
create or REPLACE view DATAWG.precodata_all as
with all_level as
(
	(with last_year_emu as
		(select EEL_EMU_NAMESHORT, max(EEL_YEAR) as last_year from DATAWG.PRECODATA_emu 
		where b0 is not null and bbest is not null and bcurrent is not null and suma is not null group by EEL_EMU_NAMESHORT) --last year should the last COMPLETE (b0, bbest, bcurrent, suma) year
	select eel_year, eel_cou_code, eel_emu_nameshort, '<lfs>' || aggregated_lfs || '<\lfs><hty>' || aggregated_hty || '<\hty>' AS aggreg_comment, b0, bbest, bcurrent, suma, sumf, sumh, aggreg_level, last_year from DATAWG.precodata_emu LEFT OUTER JOIN last_year_emu using(EEL_EMU_NAMESHORT))
	union
	(with last_year_country as
		(select EEL_COU_CODE, max(EEL_YEAR) as last_year from DATAWG.PRECODATA_COUNTRY
		where b0 is not null and bbest is not null and bcurrent is not null and suma is not null group by EEL_COU_CODE) --last year should the last COMPLETE (b0, bbest, bcurrent, suma) year
	select eel_year, eel_cou_code, eel_emu_nameshort,
	'<B0>' || method_b0 || '<\B0><Bbest>' || method_bbest || '<\Bbest><Bcurrent>' || method_bcurrent || '<\Bcurrent><suma>' || method_suma || '<\suma><sumf>'  || method_sumf || '<\sumf><sumh>'  || method_sumh || '<\sumah>'AS aggreg_comment,
	b0, bbest, bcurrent, suma, sumf, sumh, aggreg_level, last_year
	from DATAWG.precodata_country LEFT OUTER JOIN last_year_country using(EEL_COU_CODE))
	union
	(select eel_year, null EEL_COU_CODE, null EEL_EMU_NAMESHORT, 'All (' || count(*) || ' countries: ' || string_agg(EEL_COU_CODE, ',') || ')' aggreg_comment,  
		sum(b0) as b0, sum(bbest)as bbest, sum(bcurrent)as bcurrent,
		round(sum(suma*bbest)/sum(bbest), 3) as suma, 
		case when count(sumf)< COUNT(*) then null else round(sum(sumf*bbest)/sum(bbest), 3) end as sumf, -- by default sum of null and value is not a null value, this part correct that
		case when count(sumh)< COUNT(*) then null else round(sum(sumh*bbest)/sum(bbest), 3) end as sumf, -- by default sum of null and value is not a null value, this part correct that
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