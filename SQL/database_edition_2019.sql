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