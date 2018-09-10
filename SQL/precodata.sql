drop view if exists DATAWG.biomass_synthesis;
create or REPLACE view DATAWG.biomass_synthesis AS
with B0_avg AS
	(with B0_AL AS
		(select EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_YEAR, sum(eel_value) from DATAWG.B0
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR)
	select EEL_COU_CODE,EEL_EMU_NAMESHORT, AVG(SUM) as b0_avg from B0_AL
	group by EEL_COU_CODE,EEL_EMU_NAMESHORT),
	B0_AL AS
		(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR, sum(eel_value) as b0 from DATAWG.B0
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR),
	Bbest_AL AS
		(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR, sum(eel_value) as bbest from DATAWG.Bbest
		group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR), 
	Bcurrent_AL as
	(select EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR, sum(eel_value) as bcurrent from DATAWG.BCURRENT
group by EEL_COU_CODE,EEL_EMU_NAMESHORT, EEL_YEAR)
select EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year, COALESCE(b0, b0_avg) as b0, bbest, bcurrent from bcurrent_AL 
join B0_avg using(EEL_COU_CODE,EEL_EMU_NAMESHORT) 
left outer join Bbest_AL using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
left OUTER join B0_AL using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
;

SELECT * from DATAWG.BIOMASS_SYNTHESIS;

-- aggregation at the country level
SELECT EEL_COU_CODE, eel_year, SUM(B0) as B0, SUM(BBest) as Bbest, SUM(Bcurrent) as Bcurrent
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
drop view if exists DATAWG.precodata_emu;
create or REPLACE view DATAWG.precodata_emu as
select EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_EMU_NAMESHORT as aggreg_area, eel_year, round(b0/1000) as b0, round(BIOMASS_SYNTHESIS.bbest/1000) as bbest, round(bcurrent/1000) as bcurrent, 
round(case when BIOMASS_SYNTHESIS.bbest > 0 then sum(sab)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as suma,
round(case when BIOMASS_SYNTHESIS.bbest > 0 then sum(sfb)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as sumf,
round(case when BIOMASS_SYNTHESIS.bbest > 0 then sum(shb)/(BIOMASS_SYNTHESIS.bbest) ELSE NULL end, 2) as sumh
from DATAWG.MORTALITY_SYNTHESIS left outer join DATAWG.BIOMASS_SYNTHESIS using(EEL_COU_CODE,EEL_EMU_NAMESHORT, eel_year)
group by EEL_COU_CODE, EEL_EMU_NAMESHORT, eel_year, b0, BIOMASS_SYNTHESIS.bbest, bcurrent
;

-- precodata at the country level
drop view if exists DATAWG.precodata_country;
create or REPLACE view DATAWG.precodata_country as
with country_biomass as
	(SELECT EEL_COU_CODE, eel_year, SUM(B0) as B0, SUM(BBest) as Bbest, SUM(Bcurrent) as Bcurrent
	from DATAWG.BIOMASS_SYNTHESIS
	group by EEL_COU_CODE, eel_year)
select EEL_COU_CODE, EEL_COU_CODE as aggreg_area, eel_year, round(b0/1000) as b0, round(country_biomass.bbest/1000) as bbest, round(bcurrent/1000) as bcurrent, 
round(case when country_biomass.bbest > 0 then sum(sab)/(country_biomass.bbest) ELSE NULL end, 2) as suma,
round(case when country_biomass.bbest > 0 then sum(sfb)/(country_biomass.bbest) ELSE NULL end, 2) as sumf,
round(case when country_biomass.bbest > 0 then sum(shb)/(country_biomass.bbest) ELSE NULL end, 2) as sumh
from DATAWG.MORTALITY_SYNTHESIS left outer join country_biomass using(EEL_COU_CODE, eel_year)
group by EEL_COU_CODE, eel_year, b0, country_biomass.bbest, bcurrent
;
