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

