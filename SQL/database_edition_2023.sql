-------------------------------------------------------------
-- ALREADY RUN
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION datawg.checkemu_whole_country()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
DECLARE nberror INTEGER ;
BEGIN
SELECT COUNT(*) INTO nberror 
FROM ref.tr_emu_emu
where tr_emu_emu.emu_nameshort = NEW.eel_emu_nameshort
and NEW.eel_qal_id =1 AND 
NEW.eel_typ_id = 11 AND NOT emu_wholecountry ;
IF (nberror > 0) THEN
      RAISE EXCEPTION 'Aquaculture must be applied to an emu where emu_wholecountry = TRUE' ;
END IF  ;
RETURN NEW ;
END  ;
$function$
;

---
- avoid deprectated eel_typ_id
---
begin;
alter table datawg.t_eelstock_eel drop constraint ck_removed_typid;
ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT ck_removed_typid CHECK (coalesce(eel_qal_id,1)>5 or eel_typ_id not in (12,7,5));
commit;


CREATE OR REPLACE FUNCTION datawg.fish_in_emu()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE inpolygon bool;
  DECLARE fish integer;
  BEGIN
  if (new.fisa_y_4326 is null and new.fisa_x_4326 is null) then
  	return new;
  end if;

  SELECT INTO
  inpolygon coalesce(st_contains(geom_buffered, st_setsrid(st_point(new.fisa_x_4326,new.fisa_y_4326),4326)), true) FROM
  datawg.t_samplinginfo_sai
  JOIN REF.tr_emu_emu ON emu_nameshort=sai_emu_nameshort where new.fisa_sai_id = sai_id;
  IF (inpolygon = false) THEN
    RAISE EXCEPTION 'the fish % - % coordinates do not fall into the corresponding emu (% - %)', new.fi_id, new.fi_id_cou, new.fisa_x_4326, new.fisa_y_4326 ;
    END IF  ;

    RETURN NEW ;
  END  ;
$function$
;

ALTER FUNCTION checkemu_whole_country SET SCHEMA datawg;
ALTER TABLE datawg.t_eelstock_eel DROP CONSTRAINT ck_emu_whole_aquaculture;

/*
 * 
--- works but not as a check, replaced with a trigger
SELECT * FROM datawg.t_eelstock_eel
WHERE eel_qal_id =1
AND eel_typ_id = 11 
AND NOT datawg.checkemu_whole_country(eel_emu_nameshort::text);
 */



CREATE OR REPLACE FUNCTION datawg.checkemu_whole_country()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
DECLARE nberror INTEGER ;
BEGIN
SELECT COUNT(*) INTO nberror 
FROM NEW JOIN   ref.tr_emu_emu
ON tr_emu_emu.emu_nameshort = NEW.emu_nameshort
WHERE NEW.eel_qal_id =1 AND 
NEW.eel_typ_id = 11 AND NOT emu_wholecountry ;
IF (nberror > 0) THEN
      RAISE EXCEPTION 'Aquaculture must be applied to an emu where emu_wholecountry = TRUE' ;
END IF  ;
RETURN NEW ;
END  ;
$function$
;


CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION checkemu_whole_country();



--we add a column to store identifiers from national database so that data providers
--can easily find their fishes
alter table datawg.t_fishsamp_fisa add column fi_idcou varchar(50);
alter table datawg.t_fishsamp_fisa drop column fi_idcou;
alter table datawg.t_fish_fi add column fi_id_cou varchar(50);


--avoid recursive triggers fires
drop trigger update_coordinates on datawg.t_series_ser ;
create trigger update_coordinates after
update
    of geom on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_coordinates();

drop trigger update_geom on datawg.t_series_ser;
create trigger update_geom after
insert
    or
update
    of ser_x,
    ser_y on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_geom();


update ref.tr_gear_gea set gea_issscfg_code='01.9' where gea_name_en='Surrounding nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.9' where gea_name_en='Gear nei';
update ref.tr_gear_gea set gea_issscfg_code='01.2' where gea_name_en='Surrounding nets without purse lines';
update ref.tr_gear_gea set gea_issscfg_code='02.1' where gea_name_en='Beach seines';
update ref.tr_gear_gea set gea_issscfg_code='02.2' where gea_name_en='Boat seines';
update ref.tr_gear_gea set gea_issscfg_code='02.9' where gea_name_en='Seine nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='03.19' where gea_name_en='Bottom trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='03.13' where gea_name_en='Twin bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.14' where gea_name_en='Multiple bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.3' where gea_name_en='Semipelagic trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.9' where gea_name_en='Trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='04.1' where gea_name_en='Towed dredges';
update ref.tr_gear_gea set gea_issscfg_code='04.2' where gea_name_en='Hand dredges';
update ref.tr_gear_gea set gea_issscfg_code='05.1' where gea_name_en='Portable lift nets';
update ref.tr_gear_gea set gea_issscfg_code='05.2' where gea_name_en='Boat-operated lift nets';
update ref.tr_gear_gea set gea_issscfg_code='05.9' where gea_name_en='Lift nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='06.1' where gea_name_en='Cast nets';
update ref.tr_gear_gea set gea_issscfg_code='06.2' where gea_name_en='Cover pots/Lantern nets';
update ref.tr_gear_gea set gea_issscfg_code='07.1' where gea_name_en='Set gillnets (anchored)';
update ref.tr_gear_gea set gea_issscfg_code='07.2' where gea_name_en='Drift gillnets';
update ref.tr_gear_gea set gea_issscfg_code='07.3' where gea_name_en='Encircling gillnets';
update ref.tr_gear_gea set gea_issscfg_code='07.5' where gea_name_en='Trammel nets';
update ref.tr_gear_gea set gea_issscfg_code='07.9' where gea_name_en='Gillnets and entangling nets (nei)';
update ref.tr_gear_gea set gea_issscfg_code='08.2' where gea_name_en='Pots';
update ref.tr_gear_gea set gea_issscfg_code='08.3' where gea_name_en='Fyke nets';
update ref.tr_gear_gea set gea_issscfg_code='08.4' where gea_name_en='Stow nets';
update ref.tr_gear_gea set gea_issscfg_code='08.5' where gea_name_en='Barriers, fences, weirs, etc.';
update ref.tr_gear_gea set gea_issscfg_code='08.6' where gea_name_en='Aerial traps';
update ref.tr_gear_gea set gea_issscfg_code='08.9' where gea_name_en='Traps (nei)';
update ref.tr_gear_gea set gea_issscfg_code='09.4' where gea_name_en='Vertical lines';
update ref.tr_gear_gea set gea_issscfg_code='09.31' where gea_name_en='Set longlines';
update ref.tr_gear_gea set gea_issscfg_code='09.32' where gea_name_en='Drifting longlines';
update ref.tr_gear_gea set gea_issscfg_code='09.39' where gea_name_en='Longlines (nei)';
update ref.tr_gear_gea set gea_issscfg_code='09.5' where gea_name_en='Trolling lines';
update ref.tr_gear_gea set gea_issscfg_code='09.9' where gea_name_en='Hooks and lines (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.1' where gea_name_en='Harpoons';
update ref.tr_gear_gea set gea_issscfg_code='10.3' where gea_name_en='Pumps';
update ref.tr_gear_gea set gea_issscfg_code='04.3' where gea_name_en='Mechanized dredges';
update ref.tr_gear_gea set gea_issscfg_code='04.9' where gea_name_en='Dredges (nei)';
update ref.tr_gear_gea set gea_issscfg_code='10.4' where gea_name_en='Electric fishing';
update ref.tr_gear_gea set gea_issscfg_code='99.9' where gea_name_en='Gear not known';
update ref.tr_gear_gea set gea_issscfg_code='08.1' where gea_name_en='Stationary uncovered pound nets';
update ref.tr_gear_gea set gea_issscfg_code='07.4' where gea_name_en='Fixed gillnets (on stakes)';
update ref.tr_gear_gea set gea_issscfg_code='09.1' where gea_name_en='Handlines and hand-operated pole-and-lines';
update ref.tr_gear_gea set gea_issscfg_code='01.1' where gea_name_en='Purse seines';
update ref.tr_gear_gea set gea_issscfg_code='07.6' where gea_name_en='Combined gillnets-trammel nets';
update ref.tr_gear_gea set gea_issscfg_code='10.5' where gea_name_en='Pushnets';
update ref.tr_gear_gea set gea_issscfg_code='10.6' where gea_name_en='Scoopnets';
update ref.tr_gear_gea set gea_issscfg_code='05.3' where gea_name_en='Shore-operated stationary lift nets';
update ref.tr_gear_gea set gea_issscfg_code='03.11' where gea_name_en='Beam trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.12' where gea_name_en='Single boat bottom otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.15' where gea_name_en='Bottom pair trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.21' where gea_name_en='Single boat midwater otter trawls';
update ref.tr_gear_gea set gea_issscfg_code='03.22' where gea_name_en='Midwater pair trawls';
update ref.tr_gear_gea set gea_issscfg_code='09.2' where gea_name_en='Mechanized lines and pole-and-lines';
update ref.tr_gear_gea set gea_issscfg_code='10.2' where gea_name_en='Hand Implements (Wrenching gear, Clamps, Tongs, Rakes, Spears)';
update ref.tr_gear_gea set gea_issscfg_code='10.7' where gea_name_en='Drive-in nets';
update ref.tr_gear_gea set gea_issscfg_code='10.8' where gea_name_en='Diving';
update ref.tr_gear_gea set gea_issscfg_code='03.29' where gea_name_en='Midwater trawls (nei)';
update ref.tr_gear_gea set gea_issscfg_code='06.9' where gea_name_en='Falling gear (nei)';


--creation of the datasource
insert into ref.tr_datasource_dts values ('dc_2023', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2023');

insert into ref.tr_quality_qal values (23, 'discarded_wgeel 2023','This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2023', FALSE);
    
-------------------------------------------------------------
-- TO BE RUN BEFORE GENERATING THE TEMPLATES
-------------------------------------------------------------


-- Argiryos
-- for Annex 3 in the tab â€œexisting_group_metricsâ€� there are data until 2020, but we have provided data for 2021. 
-- Can we check that if the data are in the database, or other case to re-enter them in the â€œnew_group_metricsâ€�.
--SELECT * FROM datawg.t_groupseries_grser JOIN datawg.t_series_ser
--ON grser_ser_id = ser_id WHERE ser_nameshort= 'EamtS';


-- to be run with Tjoborn and JD during integration
begin;
--5738 rows to be deleted
select count(fi_id) from datawg.t_fishsamp_fisa tff2 left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id where tss.sai_cou_code ='DE'; 
--5738 rows deleted
delete from datawg.t_fishsamp_fisa tff1 where exists (select fi_id from datawg.t_fishsamp_fisa tff2 left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id where tss.sai_cou_code ='DE' and tff1.fi_id=tff2.fi_id);

--3812 rows to be deleted
select count(fi_id) from datawg.t_fishseries_fiser tff2  left join datawg.t_series_ser tss on tff2.fiser_ser_id =tss.ser_id where tss.ser_cou_code ='SE' and tss.ser_lfs_code in ('Y','S','YS'); 
--3812 rows deleted
delete from datawg.t_fishseries_fiser tff1 where exists (select fi_id from datawg.t_fishseries_fiser tff2  left join datawg.t_series_ser tss on tff2.fiser_ser_id =tss.ser_id where tss.ser_cou_code ='SE' and tss.ser_lfs_code in ('Y','S','YS') and tff1.fi_id=tff2.fi_id); 

--32792 rows to be deleted
select count(fi_id) from datawg.t_fishsamp_fisa tff2 left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id where tss.sai_cou_code ='SE'; 
--32792 rows deleted
delete from datawg.t_fishsamp_fisa tff1 where exists (select fi_id from datawg.t_fishsamp_fisa tff2 left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id where tss.sai_cou_code ='SE' and tff1.fi_id=tff2.fi_id);

rollback;


-- 27 series for Sweden OK
SELECT DISTINCT(sai_name)  from datawg.t_fishsamp_fisa tff2
left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id  WHERE sai_cou_code ='SE'


-- no das_qal_comment in DB
-- TODO in DB server 
ALTER TABLE datawg.t_dataseries_das ADD COLUMN das_qal_comment TEXT;


-- change group metrics for recruitment in Ireland

SELECT * FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code ='IE'
AND meg_mty_id =24


WITH wrong AS (
SELECT * FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code ='IE'
AND meg_mty_id =24)
UPDATE datawg.t_metricgroupseries_megser SET meg_value=meg_value/100 
WHERE meg_id IN (SELECT meg_id FROM wrong);

-- fix all series with wrong data




BEGIN;
WITH fixme AS (
SELECT ser_cou_code, meg_id, meg_value FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
AND meg_mty_id =24
AND meg_value >1)
UPDATE datawg.t_metricgroupseries_megser SET meg_value=meg_value/100 
WHERE meg_id IN (SELECT meg_id FROM fixme); --15
COMMIT;    


SELECT * FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code= 'IE'
AND ser_id =5


SELECT * FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_id =5
AND gr_year = 2023

SELECT * FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id 
WHERE  grser_ser_id = 5
AND gr_year = 2023



SELECT * FROM datawg.t_groupseries_grser
WHERE  grser_ser_id = 5
AND gr_year = 2023


SELECT * from datawg.t_fishsamp_fisa tff2 
left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id 
where tss.sai_cou_code ='SE'; 


begin;
--32792 rows to be deleted
select count(fi_id) from datawg.t_fishsamp_fisa tff2 
left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id 
where tss.sai_cou_code ='SE'; 
--32792 rows deleted
delete from datawg.t_fishsamp_fisa tff1 where exists (
select fi_id from datawg.t_fishsamp_fisa tff2 
left join datawg.t_samplinginfo_sai tss on tff2.fisa_sai_id =tss.sai_id 
where tss.sai_cou_code ='SE' and tff1.fi_id=tff2.fi_id); --32792


-- edit data in DK for landings in Marine waters

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code = 'DK' AND eel_typ_id = 4 AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_Inla'

SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code = 'DK' AND eel_typ_id = 4 AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' AND eel_year >= 2000



SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code = 'DK' AND eel_typ_id = 4 AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' AND eel_hty_code= 'F' AND eel_value>0


DROP TRIGGER trg_check_emu_whole_aquaculture ON datawg.t_eelstock_eel;
UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = 'DK_Inla' 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total'
AND eel_hty_code= 'F' 
AND eel_value>0; --74


SELECT * FROM datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_hty_code !='F'
AND eel_year >= 2000
AND eel_area_division IS NULL


-- setting Coastal water always with '27.3.b, c' after 2000
UPDATE datawg.t_eelstock_eel SET eel_area_division =  '27.3.b, c'
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_hty_code !='F'
AND eel_year >= 2000
AND eel_area_division IS NULL; --52


-- We want to use DK_Mari instead of DK_total after 2000
SELECT * FROM datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_hty_code !='F'
AND eel_year = 2021
AND eel_value>0; --42


SELECT * FROM datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_hty_code !='F'
AND eel_year >= 2000
AND eel_value>0; --42

SELECT * FROM 
datawg.t_eelstock_eel 
WHERE eel_cou_code IN ('DK') 
AND eel_typ_id =4 
AND eel_hty_code='C' 
AND eel_lfs_code in ('Y','S') 
and eel_emu_nameshort='DK_Mari' 
and eel_value IS NULL


UPDATE 
datawg.t_eelstock_eel SET eel_qal_id = 23
WHERE 
eel_cou_code IN ('DK') 
AND eel_typ_id =4 
AND eel_hty_code='C' 
AND eel_lfs_code in ('Y','S') 
and eel_emu_nameshort='DK_Mari' 
and eel_value IS NULL; --6

UPDATE datawg.t_eelstock_eel SET eel_emu_nameshort = 'DK_Mari'
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_hty_code !='F'
AND eel_year >= 2000
AND eel_value>0; --46


SELECT * FROM datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 

SELECT * FROM datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_cou_code='DK'


-- remove area division from dk_total
UPDATE datawg.t_eelstock_eel 
SET eel_area_division =NULL
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_emu_nameshort ='DK_total' 
AND eel_area_division IS NOT NULL; --170


SELECT * FROM  datawg.t_eelstock_eel 
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_area_division IS NOT NULL
AND eel_hty_code NOT IN ('MO','C')


UPDATE datawg.t_eelstock_eel SET eel_area_division = NULL
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_area_division IS NOT NULL
AND eel_hty_code NOT IN ('MO','C');--132

UPDATE datawg.t_eelstock_eel SET eel_area_division = NULL
WHERE eel_cou_code = 'DK' 
AND eel_typ_id = 4 
AND eel_qal_id IN (1,2,3,4)
AND eel_area_division IS NOT NULL
AND eel_hty_code NOT IN ('MO','C');


SELECT * FROM  datawg.t_eelstock_eel 
WHERE 
 eel_qal_id IN (1,2,3,4)
AND eel_area_division IS NOT NULL
AND eel_hty_code IN ('F');


create trigger check_meiser_mty_is_individual after
insert
    or
update
    on
    datawg.t_metricindseries_meiser for each row execute function datawg.mei_mty_is_individual();
    
   
create trigger check_meisa_mty_is_individual after
insert
    or
update
    on
    datawg.t_metricindsamp_meisa  for each row execute function datawg.mei_mty_is_individual();
    
   
create trigger update_meiser_last_update before
insert
    or
update
    on
    datawg.t_metricindseries_meiser for each row execute function datawg.mei_last_update();
   
   
create trigger update_meisa_last_update before
insert
    or
update
    on
    datawg.t_metricindsamp_meisa for each row execute function datawg.mei_last_update();


-- remove calculated weight from group series in UK

SELECT count(*) AS n, ser_nameshort FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id
JOIN datawg.t_metricgroupseries_megser ON meg_gr_id=gr_id
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code = 'GB'
AND ser_typ_id = 2
AND meg_mty_id=2
AND ser_nameshort NOT IN ('KilY', 'LagY', 'BadY', 'GirY','ShiY' )
GROUP BY ser_nameshort
ORDER BY ser_nameshort


DELETE FROM datawg.t_metricgroupseries_megser WHERE meg_id IN (
SELECT meg_id FROM datawg.t_series_ser 
JOIN datawg.t_groupseries_grser AS tgg ON grser_ser_id =ser_id
JOIN datawg.t_metricgroupseries_megser ON meg_gr_id=gr_id
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code = 'GB'
AND ser_typ_id = 2
AND meg_mty_id=2
AND ser_nameshort NOT IN ('KilY', 'LagY', 'BadY', 'GirY','ShiY' )) --756;


SELECT count(*) AS n, ser_nameshort FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code = 'GB'
AND ser_typ_id = 2
AND mei_mty_id=2
AND ser_nameshort NOT IN ('KilY', 'LagY', 'BadY', 'GirY','ShiY' )
GROUP BY ser_nameshort
ORDER BY ser_nameshort


SELECT count(*) FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code = 'GB'
AND ser_typ_id = 2
AND mei_mty_id=2
AND ser_nameshort NOT IN ('KilY', 'LagY', 'BadY', 'GirY','ShiY' )


DELETE FROM datawg.t_metricindseries_meiser WHERE mei_id IN (
SELECT mei_id  FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE ser_cou_code = 'GB'
AND ser_typ_id = 2
AND mei_mty_id=2
AND ser_nameshort NOT IN ('KilY', 'LagY', 'BadY', 'GirY','ShiY' )); --83472


-- fix wrong series in 2023 in individual data GirY should be GirnY

SELECT * FROM datawg.t_series_ser JOIN datawg. t_dataseries_das ON das_ser_id = ser_id WHERE ser_nameshort='GirY'

SELECT t_metricindseries_meiser.* FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE ser_nameshort='GirY'
AND fi_year = 2022


SELECT t_metricindseries_meiser.* FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
WHERE ser_nameshort='GirnY'
AND mei_dts_datasource= 'dc_2023';

-- remove crap series with nothing in it ever and clear comments always to drop it
SELECT * FROM t_series_ser WHERE ser_nameshort= 'ClwY'
DELETE FROM t_series_ser WHERE ser_nameshort= 'ClwY';
SELECT * FROM datawg.t_dataseries_das WHERE das_ser_id= 256;
DELETE FROM datawg.t_dataseries_das WHERE das_ser_id= 256; --13
SELECT * FROM t_biometry_series_bis WHERE bis_ser_id= 256;
DELETE FROM t_biometry_series_bis WHERE bis_ser_id= 256;
DELETE FROM ref.tr_station WHERE "Station_Name" = 'ClwY';
 UPDATE t_series_ser SET ser_tblcodeid=NULL WHERE ser_nameshort= 'ClwY';
 
--fix a trigger 
CREATE OR REPLACE FUNCTION datawg.mei_mty_is_individual()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
          the_mty_unit text;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name, the_mty_unit 
  mty_type, mty_name,mty_uni_code FROM REF.tr_metrictype_mty where mty_id=NEW.mei_mty_id;

    IF (the_mty_type = 'group') THEN
    RAISE EXCEPTION 'table t_metricind_mei, metric --> % is not an individual metric', the_mty_name ;
    END IF  ;
    if (the_mty_unit = 'wo' and new.mei_value not in (0,1)) then
	raise exception 'metric % should have only 0 or 1 for individuals', the_mty_name;
    end if;
    RETURN NEW ;
  END  ;
$function$
;
     
begin;
update datawg.t_series_ser set ser_nameshort = 'CurlY' where ser_nameshort ='ClY';
update datawg.t_series_ser set ser_nameshort = 'CurlS' where ser_nameshort ='ClS';
update datawg.t_series_ser set ser_nameshort = 'KrolY' where ser_nameshort ='KrLY';
update datawg.t_series_ser set ser_nameshort = 'DoijS' where ser_nameshort ='DOIJS';


with notok as (select count (das_id) nbpoint, das_ser_id  from datawg.t_dataseries_das tdd where das_qal_id in (1,2,4) and das_value is not null group by das_ser_id having count (das_id)<10),
tobeupdated as (select tss.ser_nameshort from datawg.t_series_ser tss inner join notok on ser_id=das_ser_id where ser_qal_id=1)
update datawg.t_series_ser tss2 set ser_qal_id =0 where tss2.ser_nameshort in (select tss3.ser_nameshort from tobeupdated tss3);
commit;

ALTER USER wgeel WITH PASSWORD '*******'


select count (das_id) nbpoint, das_ser_id  from datawg.t_dataseries_das tdd 
where das_qal_id in (1,2,4) and das_value is not null group by das_ser_id having count (das_id)<10 



SELECT * FROM datawg.t_dataseries_das WHERE das_qal_id IS NULL;--419

SELECT count(*), ser_nameshort, ser_cou_code, ser_id, max(ser_qal_id) AS ser_qal_id FROM datawg.t_dataseries_das JOIN datawg.t_series_ser ON ser_id=das_ser_id
WHERE das_qal_id IS NULL
GROUP BY ser_nameshort, ser_cou_code, ser_id
ORDER BY ser_cou_code;

SELECT * FROM datawg.t_dataseries_das WHERE das_qal_id IS NULL AND das_ser_id=29;--47 missing FOR Imsa




-- correct NULL geometries from datawg.t_series_ser AS tss 

SELECT ser_nameshort, ser_cou_code, round(st_x(geom)::numeric,2) x_geometry,round(ser_x::numeric,2) ser_x , round(st_y(geom)::NUMERIC ,2) y_geometry,round(ser_y::NUMERIC,2) ser_y FROM t_series_ser 
WHERE round(st_x(geom)::numeric,2)!=round(ser_x::numeric,2) OR round(st_y(geom)::NUMERIC ,2)!=round(ser_y::NUMERIC,2)
ORDER BY ser_cou_code, ser_nameshort;
SELECT * FROM t_series_ser WHERE geom IS NULL; --48
UPDATE t_series_ser SET geom=ST_SetSRID(ST_MakePoint(ser_x , ser_y),4326) WHERE geom IS NULL;  -- 48

-- WaSEY > 10 years
UPDATE datawg.t_series_ser
  SET ser_qal_id=1,ser_qal_comment='2023 Cédric > 10 years'
  WHERE ser_id=163;

-- Soustons > 10 years
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='SousGY';

UPDATE datawg.t_series_ser
  SET ser_qal_comment='> 10 years',ser_qal_id=1
  WHERE ser_id=300;

-- OoaGY > 10 years 
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='OatGY';

UPDATE datawg.t_series_ser
  SET ser_qal_id=1,ser_qal_comment='Cédric 2023 >= 10 years'
  WHERE ser_id=320;

-- LangGY > 10 years 
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='LangGY';

UPDATE datawg.t_series_ser
	SET ser_qal_id=1,ser_qal_comment='2023 : cédric now long enough to be considered'
	WHERE ser_id=161;

-- corrected values in Imsa	
	
UPDATE datawg.t_series_ser SET ser_qal_id = 1 WHERE ser_id = 29;
UPDATE datawg.t_series_ser
	SET ser_qal_comment='Cédric : Series corrected manually in 2023 for missing das_qal_id, it should be retained'
	WHERE ser_id=29;
	
UPDATE datawg.t_dataseries_das SET (das_qal_id, das_qal_comment)=
(1,'Set to one as was still NULL after the datacall 2024, please check') WHERE das_ser_id =29 AND das_qal_id IS NULL;--47


-- HHKGY > 10 years ?
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='HHKGY';

UPDATE datawg.t_dataseries_das SET das_qal_id =0 WHERE das_ser_id = 158 AND das_year = 2022;
SELECT * FROM datawg.t_dataseries_das WHERE das_ser_id = 158;
UPDATE datawg.t_series_ser
  SET ser_qal_id=3,ser_qal_comment='2023 : will always be > 4 years, series stopped'
  WHERE ser_id=158;
  
-- EmsHG > 10 years 

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='EmsHG';
UPDATE datawg.t_series_ser
	SET ser_qal_id=0,ser_qal_comment='Cédric : 2023 series only 9 years when removing wrong qal_id'
	WHERE ser_id=169;
	
	
-- InaG
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort IN ('InagG')	;

UPDATE datawg.t_series_ser
	SET ser_qal_comment='Cédric : Too short, attention this might also become a duplicate from InagGY, to be checked when this series gets to 10 years';
	WHERE ser_id=425;
	
	
-- WaSG > 10 years
	
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='WaSG'; 
UPDATE datawg.t_series_ser
	SET ser_qal_id=0,ser_qal_comment='2023 Cédric : this series more than 10 years but only 7 when accounting for missing values'
	WHERE ser_id=162;

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='WaSEY' ;	

UPDATE datawg.t_series_ser
	SET ser_qal_id=0,ser_qal_comment='2023 Cédric < 10 years when removing wrong values'
	WHERE ser_id=163;
	
	
-- LangGY is only 9 years when considering correct values 
	SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='LangGY' ;  

UPDATE datawg.t_series_ser
  SET ser_qal_id=0,ser_qal_comment='2023 Cédric < 10 years when removing wrong values'
  WHERE ser_id=161;
	
-- MondG 	
	
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='MondG';
UPDATE datawg.t_series_ser
	SET ser_qal_id=1
	WHERE ser_id=191;

-- ShiLG EE is just 10 years
SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='ShiMG';
UPDATE datawg.t_series_ser
  SET (ser_qal_id, ser_qal_comment)=(1,'2023 series is now 10 years long')
  WHERE ser_id=172;	

-- Esti says that EMSBGY is to be put to 3

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='EmsBGY';
UPDATE datawg.t_series_ser
  SET (ser_qal_id, ser_qal_comment)=(3,'There is a series downstream')
  WHERE ser_id=170; 



	--- fix trigger ser_x and ser_y
drop trigger update_geom on datawg.t_series_ser ;


create trigger update_geom before
insert
    or
update
    of ser_x,
    ser_y on
    datawg.t_series_ser for each row
    when ((pg_trigger_depth() < 1)) execute function datawg.update_geom();
   
drop trigger update_coordinates on datawg.t_series_ser;


-- Change view series stats to exclude missing values and 3

DROP VIEW IF EXISTS datawg.series_stats CASCADE;
CREATE OR REPLACE VIEW datawg.series_stats AS 
 SELECT ser_id, 
 ser_nameshort AS site,
 ser_namelong AS namelong,
 min(das_year) AS min,
 max(das_year) AS max, 
 max(das_year) - min(das_year) + 1 AS duration,
 max(das_year) - min(das_year) + 1 - count(*) AS missing
   FROM datawg.t_dataseries_das
   JOIN datawg.t_series_ser ON das_ser_id=ser_id
   LEFT JOIN ref.tr_country_cou ON ser_cou_code=cou_code
   WHERE das_qal_id IN (1,2,4)
  GROUP BY ser_id, cou_order
  ORDER BY cou_order;

create trigger update_coordinates before
update
    of geom on
    datawg.t_series_ser for each row
    when ((pg_trigger_depth() < 1)) execute function datawg.update_coordinates();
 
	
GRANT ALL ON TABLE datawg.series_stats TO wgeel_read; 
 ----------------------------------------------
-- SERIES SUMMARY
----------------------------------------------
DROP VIEW IF EXISTS datawg.series_summary CASCADE;
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
 cou_order as order,
 ser_typ_id,
 ser_qal_id AS series_kept
   FROM datawg.series_stats ss
   JOIN datawg.t_series_ser ser ON ss.ser_id = ser.ser_id
   LEFT JOIN ref.tr_samplingtype_sam on ser_sam_id=sam_id
   LEFT JOIN REF.tr_country_cou ON cou_code=ser_cou_code
  ORDER BY cou_order, ser_y;

ALTER TABLE datawg.series_summary
  OWNER TO postgres;
 GRANT ALL ON TABLE datawg.series_summary TO wgeel; 	
 GRANT ALL ON TABLE datawg.series_summary TO wgeel_read;  
 
 
 -- the Meuse is influence by stocking. In ser_qal_id it uses a 4
 -- we did not really expect to use the ser_qal_id 4 it creates trouble in the
 -- counting of data. I'll update it to 3 and change the  program to include 4
 
 
 -- Esti says that EMSBGY is to be put to 3

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ilike '%Meu%';
UPDATE datawg.t_series_ser
  SET ser_qal_id=3
  WHERE ser_id=40; 

-- corG is corGY


SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ilike 'corG';

UPDATE datawg.t_series_ser SET ser_nameshort='CorGY' WHERE ser_nameshort = 'CorG';
