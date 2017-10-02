----------------------------------------------
-- DYNAMIC VIEWS FOR WGEEL
----------------------------------------------
DROP VIEW datawg.series_stats CASCADE;
CREATE OR REPLACE VIEW datawg.series_stats AS 
 SELECT ser_id, 
 ser_nameshort AS site,
 ser_namelong AS namelong,
 min(das_year) AS min, max(das_year) AS max, 
 max(das_year) - min(das_year) + 1 AS duration,
 max(das_year) - min(das_year) + 1 - count(*) AS missing
   FROM datawg.t_dataseries_das
   JOIN datawg.t_series_ser ON das_ser_id=ser_id
  GROUP BY ser_id
  ORDER BY ser_order;

ALTER TABLE datawg.series_stats
  OWNER TO postgres;
  
 --select * from datawg.series_stats
 
 
----------------------------------------------
-- SERIES SUMMARY
----------------------------------------------

CREATE OR REPLACE VIEW datawg.series_summary AS 
 SELECT ss.site AS site, 
 ss.namelong, 
 ss.min, 
 ss.max, 
 ss.duration,
 ss.missing,
 ser_lfs_code as life_stage,
 sam_samplingtype as sampling_type,
 ser_uni_code as unit,
 ser_hty_code as habitat_type,
 ser_order as order,
 ser_qal_id AS series_kept
   FROM datawg.series_stats ss
   JOIN datawg.t_series_ser ser ON ss.ser_id = ser.ser_id
   LEFT JOIN ref.tr_samplingtype_sam on ser_sam_id=sam_id
  ORDER BY ser_order;

ALTER TABLE datawg.series_summary
  OWNER TO postgres;
  
---
-- view with distance to the sargasso
----
drop view if exists  datawg.t_series_ser_dist ;
create view datawg.t_series_ser_dist as
select 
 ser.geom,
 ss.*,
round(cast(st_distance(st_PointFromText('POINT(-61 25)',4326),geom)/1000 as numeric),2) as dist_sargasso 
from
datawg.t_series_ser ser join 
datawg.series_summary ss on ss.site=ser_nameshort
;


-------------------------------------
-- View for catch
-- attention, foreign key to emu is on double pivot
-- this view refers to both commercial and recreational catch
---------------------------------------
DROP VIEW IF EXISTS datawg.catch CASCADE;
CREATE VIEW datawg.catch AS 
(
select  
         eel_typ_id,
	 tr_typeseries_typ.typ_name, 
	 tr_typeseries_typ.typ_uni_code,
         eel_year ,
         eel_value  ,
         eel_missvaluequal,
         eel_emu_nameshort,
         eel_cou_code,
         tr_country_cou.cou_country, 
	 tr_country_cou.cou_order, 
	 tr_country_cou.cou_iso3code, 
         eel_lfs_code,
	 tr_lifestage_lfs.lfs_name, 
         eel_hty_code,
         tr_habitattype_hty.hty_description, 
         eel_area_division,
         eel_qal_id,
         tr_quality_qal.qal_level, 
	 tr_quality_qal.qal_text, 
         eel_qal_comment,
         eel_comment
FROM 
  datawg.t_eelstock_eel 
JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code = tr_lifestage_lfs.lfs_code 
LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id 
LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code = tr_country_cou.cou_code 
JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id 
LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code = tr_habitattype_hty.hty_code
JOIN ref.tr_emu_emu ON  (emu_nameshort,emu_cou_code) = (eel_emu_nameshort,eel_cou_code)
WHERE eel_typ_id=5 or eel_typ_id=7);

-------------------------------------
-- View for landings
-- This view refer to both recreational and commercial landings
---------------------------------------

DROP VIEW IF EXISTS datawg.landings CASCADE;
CREATE VIEW datawg.landings AS 
(
select  
	 eel_typ_id,
	 tr_typeseries_typ.typ_name, 
	 tr_typeseries_typ.typ_uni_code,
         eel_year ,
         eel_value  ,
         eel_missvaluequal,
         eel_emu_nameshort,
         eel_cou_code,
         tr_country_cou.cou_country, 
	 tr_country_cou.cou_order, 
	 tr_country_cou.cou_iso3code, 
         eel_lfs_code,
	 tr_lifestage_lfs.lfs_name, 
         eel_hty_code,
         tr_habitattype_hty.hty_description, 
         eel_area_division,
         eel_qal_id,
         tr_quality_qal.qal_level, 
	 tr_quality_qal.qal_text, 
         eel_qal_comment,
         eel_comment
FROM 
  datawg.t_eelstock_eel 
JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code = tr_lifestage_lfs.lfs_code 
LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id 
LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code = tr_country_cou.cou_code 
JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id 
LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code = tr_habitattype_hty.hty_code
JOIN ref.tr_emu_emu ON  (emu_nameshort,emu_cou_code) = (eel_emu_nameshort,eel_cou_code)
WHERE eel_typ_id=4 or eel_typ_id=6);


-------------------------------------
-- View for catch and landgins
-- This view refer to both recreational and commercial catch and landings
---------------------------------------

DROP VIEW IF EXISTS datawg.catch_landings ;
CREATE VIEW datawg.catch_landings AS 
select * from datawg.catch union
select * from datawg.landings;
-------------------------------------
-- View for stocking
-- This view refer to stocking in kg or number or geel equivalents
---------------------------------------

DROP VIEW IF EXISTS datawg.stocking ;
CREATE VIEW datawg.stocking AS 
(
select  
         eel_typ_id,
	 tr_typeseries_typ.typ_name, 
	 tr_typeseries_typ.typ_uni_code,
         eel_year ,
         eel_value  ,
         eel_missvaluequal,
         eel_emu_nameshort,
         eel_cou_code,
         tr_country_cou.cou_country, 
	 tr_country_cou.cou_order, 
	 tr_country_cou.cou_iso3code, 
         eel_lfs_code,
	 tr_lifestage_lfs.lfs_name, 
         eel_hty_code,
         tr_habitattype_hty.hty_description, 
         eel_area_division,
         eel_qal_id,
         tr_quality_qal.qal_level, 
	 tr_quality_qal.qal_text, 
         eel_qal_comment,
         eel_comment
FROM 
  datawg.t_eelstock_eel 
JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code = tr_lifestage_lfs.lfs_code 
LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id 
LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code = tr_country_cou.cou_code 
JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id 
LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code = tr_habitattype_hty.hty_code
JOIN ref.tr_emu_emu ON  (emu_nameshort,emu_cou_code) = (eel_emu_nameshort,eel_cou_code)
WHERE eel_typ_id in (8,9,10));
-------------------------------------
-- View for aquaculture
---------------------------------------

DROP VIEW IF EXISTS datawg.aquaculture ;
CREATE VIEW datawg.aquaculture AS 
(
select  
         eel_typ_id,
	 tr_typeseries_typ.typ_name, 
	 tr_typeseries_typ.typ_uni_code,
         eel_year ,
         eel_value  ,
         eel_missvaluequal,
         eel_emu_nameshort,
         eel_cou_code,
         tr_country_cou.cou_country, 
	 tr_country_cou.cou_order, 
	 tr_country_cou.cou_iso3code, 
         eel_lfs_code,
	 tr_lifestage_lfs.lfs_name, 
         eel_hty_code,
         tr_habitattype_hty.hty_description, 
         eel_area_division,
         eel_qal_id,
         tr_quality_qal.qal_level, 
	 tr_quality_qal.qal_text, 
         eel_qal_comment,
         eel_comment
FROM 
  datawg.t_eelstock_eel 
JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code = tr_lifestage_lfs.lfs_code 
LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id 
LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code = tr_country_cou.cou_code 
JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id 
LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code = tr_habitattype_hty.hty_code
JOIN ref.tr_emu_emu ON  (emu_nameshort,emu_cou_code) = (eel_emu_nameshort,eel_cou_code)
WHERE eel_typ_id=11 or eel_typ_id=12);
