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
select *, 
round(cast(st_distance(st_PointFromText('POINT(-61 25)',4326),geom)/1000 as numeric),2) as dist_sargasso from
datawg.t_series_ser ;