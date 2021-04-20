-- server
SELECT count(*) FROM datawg.t_series_ser -- 230
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --5070
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150


-- DONE ON SERVER

INSERT INTO REF.tr_datasource_dts  VALUES ('dc_2021', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2021');
INSERT INTO ref.tr_quality_qal SELECT 21,	'discarded_wgeel_2021',	
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2021',	FALSE;



SELECT * FROM datawg.t_eelstock_eel 
JOIN REF.tr_typeseries_typ ON typ_id=eel_typ_id
WHERE eel_typ_id IN (14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,24) 
--AND eel_qal_id=3;

-- TODO apply server

UPDATE datawg.t_eelstock_eel SET (eel_qal_id,eel_qal_comment)=(20,'discarded prior to datacall 2021, all data will be replaced')
WHERE eel_typ_id IN (13,14,15,17,18,19,20,21,22,23,25,26,27,28,29,30,31,24) and eel_qal_id IN(1,2,3,4); --4922


/*
 *  THIS PART (about series)  HAS BEEN LAUNCHED ON SERVER
 */
ALTER TABLE datawg.t_series_ser ADD COLUMN ser_distanceseakm NUMERIC;
COMMENT ON COLUMN datawg.t_series_ser.ser_distanceseakm IS 
'Distance to the saline limit in km, for group of data, e.g. a set of electrofishing points 
in a basin, this is the average distance of the different points':





-- Adding a table of gears, sent a mail to Inigo to see if there is a vocabulary in ICES data portal
-- Otherwise there is someting suitable in FAO here
--http://www.fao.org/cwp-on-fishery-statistics/handbook/capture-fisheries-statistics/fishing-gear-classification/en/
-- There is a hierachy that we don't really need but we can keep the original codes

DROP TABLE IF EXISTS ref.tr_gear_gea;
CREATE TABLE ref.tr_gear_gea (
gea_id INTEGER PRIMARY KEY,     -- this will correspond to the identifier column in the original dataset
gea_issscfg_code TEXT,	
gea_name_en	TEXT);

-- see import_gear.R where I created the table using structure

SELECT * FROM ref.tr_gear_gea ;
INSERT INTO ref.tr_gear_gea SELECT * FROM gear;

ALTER TABLE datawg.t_series_ser ADD COLUMN ser_sam_gear INTEGER REFERENCES ref.tr_gear_gea(gea_id);
UPDATE datawg.t_series_ser SET ser_sam_gear= 226 WHERE ser_effort_uni_code='nr fyke.day'; --8 Fyke net
UPDATE datawg.t_series_ser SET ser_sam_gear= 214 WHERE ser_effort_uni_code='nr haul'; -- 9 Portable lift nets
UPDATE datawg.t_series_ser SET ser_sam_gear= 242 WHERE ser_effort_uni_code='nr electrofishing'; --59 Electric fishing
UPDATE datawg.t_series_ser SET ser_sam_gear= 226 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%fyke net%'; 10 --Fyke net
UPDATE datawg.t_series_ser SET ser_sam_gear= 230 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%trap%' OR ser_comment ILIKE '%pass%'; 58 --Trap
UPDATE datawg.t_series_ser SET ser_sam_gear= 242 WHERE ser_sam_gear IS NULL AND ser_comment ILIKE '%electrofishing%'; --7
UPDATE datawg.t_series_ser SET ser_comment ='partial monitoring of one gate, with a model reconstructing the total migration' WHERE ser_id = 224;

/*
Table for percent habitat related to stock indicators
*/
create table datawg.t_eelstock_eel_percent (
    percent_id integer primary key references datawg.t_eelstock_eel(eel_id),
    perc_f numeric check((perc_f >=0 and perc_f<=0) or perc_f is null) ,
    perc_t numeric check((perc_t >=0 and perc_f<=0) or perc_t is null),
    perc_c numeric check((perc_c >=0 and perc_c<=0) or perc_c is null),
    perc_mo numeric check((perc_mo >=0 and perc_f<=0) or perc_mo is null)
);
