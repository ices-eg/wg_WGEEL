-- server
SELECT count(*) FROM datawg.t_series_ser -- 230
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --5070
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150

INSERT INTO REF.tr_datasource_dts  VALUES ('dc_2021', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2020');

