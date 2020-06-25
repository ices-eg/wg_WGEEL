-- server
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150

SELECT * FROM datawg.t_series_ser WHERE ser_cou_code IS NULL;
/*
Pandalus
NS-IBTS
BITS-4
BITS-1
*/

-- saving wkeelmigration data to the database
GRANT ALL ON SCHEMA wkeelmigration  TO wgeel ;



SELECT DISTINCT ser