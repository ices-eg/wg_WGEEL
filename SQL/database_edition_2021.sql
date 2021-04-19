-- server
SELECT count(*) FROM datawg.t_series_ser -- 230
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --5070
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150

INSERT INTO REF.tr_datasource_dts  VALUES ('dc_2021', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2021');
INSERT INTO ref.tr_quality_qal SELECT 21,	'discarded_wgeel_2021',	
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2021',	FALSE;
