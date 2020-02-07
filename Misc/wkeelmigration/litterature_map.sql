select * from wkeelmigration."Literature_table_final"

alter table wkeelmigration."Literature_table_final" add column habitat_type text;
alter table wkeelmigration."Literature_table_final" rename to litterature

select distinct on ("River, lagoon, estuary") "River, lagoon, estuary" from wkeelmigration."Literature_table_final"
alter table wkeelmigration.litterature rename column "River, lagoon, estuary" to habitat;
select distinct on (habitat) habitat from wkeelmigration.litterature
UPDATE wkeelmigration.litterature set habitat_type ='C' where habitat='coastal'; --4
UPDATE wkeelmigration.litterature set habitat_type ='T' where habitat in ('estuary','lagoon','fjord','estuary '); --26
UPDATE wkeelmigration.litterature set habitat_type ='FT' where habitat in ('lake+sea','rivers-lagoon','river estuary'); --26
UPDATE wkeelmigration.litterature set habitat_type ='F' WHERE habitat ='river' or  habitat='polder'; --26

alter table wkeelmigration.litterature rename column "Stage" to stage;

select distinct stage from wkeelmigration.litterature;
ALTER table wkeelmigration.litterature add column stage2 text;
UPDATE  wkeelmigration.litterature set stage2='Y' where stage ='BL';
UPDATE  wkeelmigration.litterature set stage2='GY' where stage ='E';
UPDATE  wkeelmigration.litterature set stage2='GY' where stage ='GE/Y';
UPDATE  wkeelmigration.litterature set stage2='GY' where stage ='GE/E/Y';
UPDATE  wkeelmigration.litterature set stage2='GY' where stage ='E/BT';
UPDATE  wkeelmigration.litterature set stage2='G' where stage ='GE';
UPDATE  wkeelmigration.litterature set stage2='S' where stage ='S';
UPDATE  wkeelmigration.litterature set stage='YS' where stage ='SY';
UPDATE  wkeelmigration.litterature set stage2='YS' where stage ='YS';
UPDATE  wkeelmigration.litterature set stage2='Y' where stage ='Y';

create table wkeelmigration.litteratured as select  "Author",  stage2, min("Year/s of observation") as first_year, max("Year/s of observation") as last_year,
habitat_type, geom from wkeelmigration.litterature group by "Author",  stage2, habitat_type, geom

alter table wkeelmigration.litteratured add column id serial primary key;
