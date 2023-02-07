-------------------------------------------------------------
-- ALREADY RUN
-------------------------------------------------------------



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

    
-------------------------------------------------------------
-- TO BE RUN BEFORE GENERATING THE TEMPLATES
-------------------------------------------------------------

--we add a column to store identifiers from national database so that data providers
--can easily find their fishes
alter table datawg.t_fishsamp_fisa add column fi_idcou varchar(50);


--avoid recursive triggers fires
drop trigger update_coordinates on datawg.t_series_ser ;
create trigger update_coordinates after
update
    of geom on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_coordinates()

drop trigger update_geom on datawg.t_series_ser;
create trigger update_geom after
insert
    or
update
    of ser_x,
    ser_y on
    datawg.t_series_ser for each row WHEN (pg_trigger_depth() < 1) execute function datawg.update_geom()

    
