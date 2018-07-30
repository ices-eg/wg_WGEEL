-------------
-- script to create a table with log file
-- there is already a table with user names, this table will have to be edited to add the new names
---------------
alter table datawg.participants add constraint c_pk_name PRIMARY KEY (name);

create table datawg.log (
log_data text,
log_evaluation_name  text ,
log_main_assessor text REFERENCES datawg.participants(name) ON UPDATE CASCADE on DELETE CASCADE,
log_secondary_assessor text REFERENCES datawg.participants(name) ON UPDATE CASCADE on DELETE CASCADE,
log_date date);