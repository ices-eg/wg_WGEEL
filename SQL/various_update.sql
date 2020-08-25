-- various UPDATE TO the DATABASE
---------------------------------------

ALTER TABLE datawg.t_series_ser ADD CONSTRAINT unique_name_short UNIQUE (ser_nameshort);

-- update the geom 
CREATE OR REPLACE FUNCTION datawg.update_geom()	
RETURNS TRIGGER AS $$
BEGIN
    NEW.geom = ST_GeomFromText('POINT('||NEW.ser_x||' '||NEW.ser_y||')',4326);
    RETURN NEW;	
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_geom ON datawg.t_series_ser;
CREATE TRIGGER update_geom BEFORE INSERT OR UPDATE ON datawg.t_series_ser FOR EACH ROW EXECUTE PROCEDURE  datawg.update_geom();

-- correct missing stat
-- change 2020 removed ser_order replaced with cou_order
CREATE OR REPLACE VIEW datawg.series_stats
AS SELECT t_series_ser.ser_id,
    t_series_ser.ser_nameshort AS site,
    t_series_ser.ser_namelong AS namelong,
    min(t_dataseries_das.das_year) AS min,
    max(t_dataseries_das.das_year) AS max,
    max(t_dataseries_das.das_year) - min(t_dataseries_das.das_year) + 1 AS duration,
    count(*) - count(das_value) AS missing
   FROM datawg.t_dataseries_das
     JOIN datawg.t_series_ser ON t_dataseries_das.das_ser_id = t_series_ser.ser_id
     LEFT JOIN REF.tr_country_cou ON cou_code=ser_cou_code 
  GROUP BY t_series_ser.ser_id, cou_order
  ORDER BY cou_order;
