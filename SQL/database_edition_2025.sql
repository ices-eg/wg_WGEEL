INSERT INTO "ref".tr_datasource_dts (dts_datasource,dts_description)
  VALUES ('wkemp_2025','WKEMP 2025 special request');



INSERT INTO "ref".tr_quality_qal (qal_id,qal_level,qal_text,qal_kept)
  VALUES (-24,'correction wkemp 2025','This data has either been removed from the database in favour of new data, these corrections have been implemented after asking for revised data for 2024 datacall',false);


SELECT * FROM  datawg.precodata WHERE eel_cou_code = 'EE'

SELECT* FROM "ref".tr_typeseries_typ AS ttt 

UPDATE  datawg.t_eelstock_eel 
SET eel_value= eel_value*1000 
WHERE eel_typ_id = 34 AND eel_cou_code ='PL'; --26

SELECT * FROM  datawg.t_eelstock_eel 
WHERE eel_typ_id = 34 AND eel_cou_code ='PL'; 


WITH bm AS(
SELECT 
eel_cou_code,
'biomass' AS annex,
2024 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (13,14,15,34) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'dc_2024'
GROUP BY eel_cou_code
UNION 
SELECT 
eel_cou_code,
'biomass' AS annex,
2025 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (13,14,15,34) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'wkemp_2025'
GROUP BY eel_cou_code
UNION 
SELECT 
eel_cou_code,
'biomass' AS annex,
2021 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (13,14,15,34) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'dc_2021'
GROUP BY eel_cou_code
UNION
SELECT 
eel_cou_code,
'mortality' AS annex,
2021 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (17,18,19) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'dc_2021'
GROUP BY eel_cou_code
UNION 
SELECT 
eel_cou_code,
'mortality' AS annex,
2025 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (17,18,19) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'wkemp_2024'
GROUP BY eel_cou_code
UNION 
SELECT 
eel_cou_code,
'mortality' AS annex,
2025 AS datacall, 
count(*) AS reported_indicators,
sum(case when eel_value IS NOT NULL then 1 else 0 end) AS value,
sum(case when eel_missvaluequal= 'NC' then 1 else 0 end) AS NC,
sum(case when eel_missvaluequal= 'NP' then 1 else 0 end) AS NP,
sum(case when eel_missvaluequal= 'NR' then 1 else 0 end) AS NR
FROM datawg.t_eelstock_eel 
where eel_typ_id in (17,18,19) 
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and eel_datasource = 'wkemp_2024'
GROUP BY eel_cou_code)
--SELECT * FROM bm ORDER BY  eel_cou_code, annex, datacall desc
SELECT * FROM  bm WHERE datacall=2025 OR datacall = 2024


-- Total number of reporting EMUs
-- (mortality)
WITH allemus AS (
SELECT 
*
FROM datawg.t_eelstock_eel 
where eel_typ_id in (17,18,19)  
AND eel_value IS NOT NULL
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and (eel_datasource = 'dc_2024' OR eel_datasource = 'wkemp_2025')
AND eel_cou_code != 'GB' 
AND eel_emu_nameshort NOT LIKE '%total'
),
ukemu AS (
SELECT DISTINCT ON (eel_emu_nameshort) * FROM allemus
)
SELECT count(*) FROM ukemu; -- 51

-- Total number of reporting EMUs
-- (biomass)
WITH allemus AS (
SELECT 
*
FROM datawg.t_eelstock_eel 
where eel_typ_id in (13,14,15,34)   
AND eel_value IS NOT NULL
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and (eel_datasource = 'dc_2024' OR eel_datasource = 'wkemp_2025')
AND eel_cou_code != 'GB' 
AND eel_emu_nameshort NOT LIKE '%total'
),
ukemu AS (
SELECT DISTINCT ON (eel_emu_nameshort) * FROM allemus
)
SELECT count(*) FROM ukemu; -- 52

-- nb EMU with more than 5 years reported during the last datacall (mortality)
WITH allemus AS (
SELECT 
count(*)/3 AS nbval, eel_emu_nameshort
FROM datawg.t_eelstock_eel 
where eel_typ_id in (17,18,19)  
AND eel_value IS NOT NULL
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and (eel_datasource = 'dc_2024' OR eel_datasource = 'wkemp_2025')
AND eel_cou_code != 'GB' 
AND eel_emu_nameshort NOT LIKE '%total'
GROUP BY eel_emu_nameshort
),
ukemu AS (
SELECT * FROM allemus WHERE nbval>=5 
)
SELECT count(*) FROM ukemu; -- 38


-- nb EMU with more than 5 years reported during the last datacall (biomass)
WITH allemus AS (
SELECT 
count(*)/4 AS nbval, eel_emu_nameshort
FROM datawg.t_eelstock_eel 
where eel_typ_id in (13,14,15,34)  
AND eel_value IS NOT NULL
AND eel_qal_id IN (0,1,2,4) 
AND eel_year > 2010
and (eel_datasource = 'dc_2024' OR eel_datasource = 'wkemp_2025')
AND eel_cou_code != 'GB' 
AND eel_emu_nameshort NOT LIKE '%total'
GROUP BY eel_emu_nameshort
),
ukemu AS (
SELECT * FROM allemus WHERE nbval>=5 
)
SELECT count(*) FROM ukemu; -- 34




SELECT count(*),  gea_issscfg_code , gea_name_en FROM datawg.t_series_ser AS tss
JOIN "ref".tr_gear_gea AS gea ON ser_sam_gear = gea_id
GROUP BY gea_issscfg_code, gea_name_en

