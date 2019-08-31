-- various UPDATE TO the DATABASE
ALTER TABLE datawg.t_series_ser ADD CONSTRAINT unique_name_short UNIQUE (ser_nameshort);