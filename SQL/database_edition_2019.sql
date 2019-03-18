-------------------------------
-- Update tested on rasberry
-- TODO update database living
-------------------------------


CREATE TABLE ref.tr_dataaccess_dta(
dta_code text primary key,
dta_description text);
INSERT INTO ref.tr_dataaccess_dta(dta_code,dta_description) values ('Public','Public access according to ICES Data Policy');
INSERT INTO ref.tr_dataaccess_dta(dta_code,dta_description) values ('Restricted','Restricted access (wgeel find a definition)');
-- inserting a new column and refering to the new referential table
ALTER TABLE datawg.t_eelstock_eel add column eel_dta_code TEXT;
ALTER TABLE datawg.t_eelstock_eel add constraint c_fk_eel_dta_code FOREIGN KEY (eel_dta_code)
      REFERENCES ref.tr_dataaccess_dta (dta_code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;
      
     
ALTER TABLE ref.tr_quality_qal ADD COLUMN qal_kept boolean;
UPDATE ref.tr_quality_qal SET qal_kept=true WHERE qal_id in (1,2,4);
UPDATE ref.tr_quality_qal SET qal_kept=false WHERE not qal_id in (1,2,4);
