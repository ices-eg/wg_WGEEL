-------------
-- script to create a table with log file
-- there is already a table with user names, this table will have to be edited to add the new names
---------------
alter table datawg.participants add constraint c_pk_name PRIMARY KEY (name);



drop table if exists datawg.log;
create table datawg.log (
log_id serial PRIMARY KEY,
log_cou_code character varying(2) REFERENCES ref.tr_country_cou (cou_code)  ON UPDATE CASCADE on DELETE NO ACTION,
log_data text, -- to what kind of data (sheet) does this refers to in the datacall
log_evaluation_name  text , -- name of the evaluation (check, duplicates, new data integration)
log_main_assessor text REFERENCES datawg.participants(name) ON UPDATE CASCADE on DELETE NO ACTION,
log_secondary_assessor text REFERENCES datawg.participants(name) ON UPDATE CASCADE on DELETE NO ACTION,
log_contact_person_name text, -- this comes from the datacall sheet
log_method text, -- this comes from the datacall sheet
log_message text, -- this is the message sent to the console
log_date date);