-- add a deprecated column to emu
begin;
alter table ref.tr_emu_emu add column deprec boolean default false;
update ref.tr_emu_emu set "deprec" = false;
select emu_nameshort from ref.tr_emu_emu tee where emu_nameshort like '%$_o' ESCAPE '$';
update ref.tr_emu_emu set "deprec" = true where emu_nameshort like '%$_o' ESCAPE '$';
commit;
  
  CREATE OR REPLACE VIEW datawg.landings
AS SELECT t_eelstock_eel.eel_id,
        --CASE
            --WHEN t_eelstock_eel.eel_typ_id = NULL::integer THEN NULL::integer
            --WHEN t_eelstock_eel.eel_typ_id = 5 THEN 4
            --WHEN t_eelstock_eel.eel_typ_id = 7 THEN 6
            --WHEN t_eelstock_eel.eel_typ_id = 4 THEN 4
           -- WHEN t_eelstock_eel.eel_typ_id = 6 THEN 6
            --WHEN t_eelstock_eel.eel_typ_id = 32 THEN 32
            --WHEN t_eelstock_eel.eel_typ_id = 33 THEN 33
            --ELSE NULL::integer
        --END AS eel_typ_id,
        eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
  WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 32])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
  --WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 5, 7, 32, 33])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));


-- CHECK for issue # 296

SELECT x.* FROM datawg.t_series_ser x
WHERE ser_nameshort ='BeeGY';


------create table to track history of recruitment models
drop table if exists ref.tr_model_mod cascade;

create table ref.tr_model_mod (
mod_nameshort text not null,
mod_description text,
constraint tr_model_mod_pkey primary key (mod_nameshort)
);
grant all on ref.tr_model_mod to wgeel;
grant select on ref.tr_model_mod to wgeel_read;

drop table if exists datawg.t_modelrun_run cascade;
create table datawg.t_modelrun_run(
run_id serial4,
run_date date not null,
run_mod_nameshort text not null,
run_description text,
constraint tr_modelrun_run_pkey primary key (run_id),
constraint c_fk_run_mod_nameshort foreign key (run_mod_nameshort) references ref.tr_model_mod(mod_nameshort) on update cascade on delete cascade
);


grant all on datawg.t_modelrun_run_run_id_seq to wgeel;
grant all on datawg.t_modelrun_run to wgeel;
grant select on datawg.t_modelrun_run to wgeel_read;


drop table if exists datawg.t_modeldata_dat cascade;
create table datawg.t_modeldata_dat(
dat_id serial4,
dat_run_id int4 not null,
dat_ser_id int4 not null,
dat_ser_year int4 not null,
dat_das_value numeric,
constraint tr_model_mod_pkey primary key (dat_id),
constraint c_uk_modeldata_das_id_run_id unique(dat_run_id,dat_ser_year,dat_ser_id),
CONSTRAINT c_fk_dat_ser_id FOREIGN KEY (dat_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE on delete cascade,
constraint c_fk_dat_run_id foreign key (dat_run_id) references datawg.t_modelrun_run(run_id) on update cascade on delete cascade
);

grant all on datawg.t_modeldata_dat to wgeel;
grant select on datawg.t_modeldata_dat to wgeel_read;
grant all on datawg.t_modeldata_dat_dat_id_seq to wgeel;
------------------------

UPDATE datawg.t_series_ser
  SET (ser_qal_id, ser_qal_comment)=(3,'Duplicated series from BeeG, this series will not be used in the analysis')
  WHERE ser_id=317; 





ALTER SEQUENCE "ref".tr_metrictype_mty_mty_id_seq RESTART WITH 27;
UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method,mty_individual_name) =('female_proportion', 'check method in method_sex','is_female(1=female,0=male)') WHERE mty_name ='female_proportion (from size)';

/* fix changes
UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method,mty_individual_name) =
('method_sex_(1=visual,0=use_length)',NULL,'method_sex_(1=visual,0=use_length)')
WHERE mty_id =27;

SELECT * FROM ref.tr_metrictype_mty WHERE mty_id =27;
UPDATE "ref".tr_metrictype_mty
  SET mty_individual_name='method_sex_(1=visual,0=use_length)',mty_name='method_sex_(1=visual,0=use_length)',mty_description='Method used for sex determination',mty_method=''
  WHERE mty_id=27;
UPDATE "ref".tr_metrictype_mty
  SET mty_individual_name='anguillicola_presence(1=present,0=absent)',mty_name='anguillicola_proportion',mty_method='check method in method_anguillicola'
  WHERE mty_id=8;
UPDATE "ref".tr_metrictype_mty
  SET mty_description='Method used for anguillicola intensity and proportion'
  WHERE mty_id=28;
*/



/*
 * SELECT * FROM pg_stat_get_activity(NULL::integer) 
 */
 



-- note the names is the same in individual and group series
INSERT INTO "ref".tr_metrictype_mty 
(mty_name,
mty_individual_name,
mty_description,
mty_type,
mty_method,
mty_uni_code,
mty_group,
mty_min,
mty_max) 
SELECT
'method_sex_(1=visual,0=use_length)' AS mty_name
,'method_sex_(1=visual,0=use_length)' AS mty_individual_name
,mty.mty_description
,mty.mty_type
,NULL AS mty_method
,mty.mty_uni_code
,mty.mty_group
,mty.mty_min
,mty.mty_max
FROM "ref".tr_metrictype_mty mty WHERE 
mty_name = 'female_proportion (from size)';


UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method, mty_individual_name) = 
('anguillicola_proportion (visual)' , 'Visual inspection of the swimbladder','anguillicola_presence_visual(1=present,0=absent)')
WHERE mty_name ='anguillicola_proportion';

/* fix since we changed our mind, not to be run again
UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method, mty_individual_name) = 
('anguillicola_proportion' , 'Check method in method_anguillicola','anguillicola_presence(1=present,0=absent)')
WHERE mty_name ='anguillicola_proportion (visual)';

UPDATE "ref".tr_metrictype_mty SET (mty_name,mty_method, mty_individual_name) = 
('method_anguillicola_(1=stereomicroscope,0=visual_obs)
' , NULL,'method_anguillicola_(1=stereomicroscope,0=visual_obs)')
WHERE mty_name ='anguillicola_proportion (microscope)';
*/


INSERT INTO "ref".tr_metrictype_mty 
(mty_name
,mty_individual_name
,mty_description
,mty_type
,mty_method
,mty_uni_code
,mty_group
,mty_min
,mty_max) 
SELECT
'method_anguillicola_(1=stereomicroscope,0=visual_obs)' AS mty_name
,'method_anguillicola_(1=stereomicroscope,0=visual_obs)' AS mty_individual_name
,mty.mty_description
,mty.mty_type
,NULL AS mty_method
,mty.mty_uni_code
,mty.mty_group
,mty.mty_min
,mty.mty_max
FROM "ref".tr_metrictype_mty mty WHERE 
mty_name = 'anguillicola_proportion (visual)';




----add ccm wso_id to series
update datawg.t_series_ser set ser_ccm_wso_id = '{84095}' where ser_id=293;
update datawg.t_series_ser set ser_ccm_wso_id = '{84080}' where ser_id=294;
update datawg.t_series_ser set ser_ccm_wso_id = '{83811}' where ser_id=286;
update datawg.t_series_ser set ser_ccm_wso_id = '{85376}' where ser_id=283;
update datawg.t_series_ser set ser_ccm_wso_id = '{442395}' where ser_id=241;
update datawg.t_series_ser set ser_ccm_wso_id = '{377}' where ser_id=240;
update datawg.t_series_ser set ser_ccm_wso_id = '{83762}' where ser_id=203;
update datawg.t_series_ser set ser_ccm_wso_id = '{95713}' where ser_id=202;
update datawg.t_series_ser set ser_ccm_wso_id = '{83762}' where ser_id=248;
update datawg.t_series_ser set ser_ccm_wso_id = '{83747}' where ser_id=37;
update datawg.t_series_ser set ser_ccm_wso_id = '{1402}' where ser_id=39;
update datawg.t_series_ser set ser_ccm_wso_id = '{291498}' where ser_id=212;
update datawg.t_series_ser set ser_ccm_wso_id = '{83751}' where ser_id=186;
update datawg.t_series_ser set ser_ccm_wso_id = '{85504}' where ser_id=183;
update datawg.t_series_ser set ser_ccm_wso_id = '{83747}' where ser_id=229;
update datawg.t_series_ser set ser_ccm_wso_id = '{250}' where ser_id=38;
update datawg.t_series_ser set ser_ccm_wso_id = '{1287}' where ser_id=33;
update datawg.t_series_ser set ser_ccm_wso_id = '{257}' where ser_id=34;
update datawg.t_series_ser set ser_ccm_wso_id = '{1034895}' where ser_id=35;
update datawg.t_series_ser set ser_ccm_wso_id = '{83812}' where ser_id=260;
update datawg.t_series_ser set ser_ccm_wso_id = '{1034745}' where ser_id=30;
update datawg.t_series_ser set ser_ccm_wso_id = '{1035550}' where ser_id=31;
update datawg.t_series_ser set ser_ccm_wso_id = '{235}' where ser_id=32;
update datawg.t_series_ser set ser_ccm_wso_id = '{84133}' where ser_id=263;
update datawg.t_series_ser set ser_ccm_wso_id = '{83795}' where ser_id=259;
update datawg.t_series_ser set ser_ccm_wso_id = '{84065}' where ser_id=296;
update datawg.t_series_ser set ser_ccm_wso_id = '{88600}' where ser_id=226;
update datawg.t_series_ser set ser_ccm_wso_id = '{83762}' where ser_id=201;
update datawg.t_series_ser set ser_ccm_wso_id = '{85623,124563,124704,124617}' where ser_id=264;
update datawg.t_series_ser set ser_ccm_wso_id = '{85624}' where ser_id=265;
update datawg.t_series_ser set ser_ccm_wso_id = '{88600}' where ser_id=228;
update datawg.t_series_ser set ser_ccm_wso_id = '{83812}' where ser_id=267;
update datawg.t_series_ser set ser_ccm_wso_id = '{83750}' where ser_id=8;
update datawg.t_series_ser set ser_ccm_wso_id = '{92458}' where ser_id=274;
update datawg.t_series_ser set ser_ccm_wso_id = '{84129}' where ser_id=271;
update datawg.t_series_ser set ser_ccm_wso_id = '{83796}' where ser_id=272;
update datawg.t_series_ser set ser_ccm_wso_id = '{85522}' where ser_id=255;
update datawg.t_series_ser set ser_ccm_wso_id = '{89411}' where ser_id=253;
update datawg.t_series_ser set ser_ccm_wso_id = '{83779}' where ser_id=261;
update datawg.t_series_ser set ser_ccm_wso_id = '{83762}' where ser_id=171;
update datawg.t_series_ser set ser_ccm_wso_id = '{6}' where ser_id=167;
update datawg.t_series_ser set ser_ccm_wso_id = '{84653}' where ser_id=257;
update datawg.t_series_ser set ser_ccm_wso_id = '{83750}' where ser_id=279;
update datawg.t_series_ser set ser_ccm_wso_id = '{83945}' where ser_id=254;
update datawg.t_series_ser set ser_ccm_wso_id = '{83751}' where ser_id=266;
update datawg.t_series_ser set ser_ccm_wso_id = '{92}' where ser_id=210;
update datawg.t_series_ser set ser_ccm_wso_id = '{84087}' where ser_id=273;
update datawg.t_series_ser set ser_ccm_wso_id = '{84083}' where ser_id=292;
update datawg.t_series_ser set ser_ccm_wso_id = '{83773}' where ser_id=252;
update datawg.t_series_ser set ser_ccm_wso_id = '{95713}' where ser_id=249;
update datawg.t_series_ser set ser_ccm_wso_id = '{83947}' where ser_id=251;
update datawg.t_series_ser set ser_ccm_wso_id = '{83797}' where ser_id=258;
update datawg.t_series_ser set ser_ccm_wso_id = '{83795,83748}' where ser_id=268;
update datawg.t_series_ser set ser_ccm_wso_id = '{85591}' where ser_id=269;
update datawg.t_series_ser set ser_ccm_wso_id = '{85617}' where ser_id=275;
update datawg.t_series_ser set ser_ccm_wso_id = '{83770}' where ser_id=288;
update datawg.t_series_ser set ser_ccm_wso_id = '{84045}' where ser_id=291;
update datawg.t_series_ser set ser_ccm_wso_id = '{83959}' where ser_id=290;
update datawg.t_series_ser set ser_ccm_wso_id = '{83762}' where ser_id=247;
update datawg.t_series_ser set ser_ccm_wso_id = '{84107}' where ser_id=289;
update datawg.t_series_ser set ser_ccm_wso_id = '{83809}' where ser_id=295;
update datawg.t_series_ser set ser_ccm_wso_id = '{5342}' where ser_id=285;
update datawg.t_series_ser set ser_ccm_wso_id = '{84124}' where ser_id=276;
update datawg.t_series_ser set ser_ccm_wso_id = '{92611}' where ser_id=277;
update datawg.t_series_ser set ser_ccm_wso_id = '{84134}' where ser_id=281;
update datawg.t_series_ser set ser_ccm_wso_id = '{84128}' where ser_id=282;
update datawg.t_series_ser set ser_ccm_wso_id = '{85608}' where ser_id=284;
update datawg.t_series_ser set ser_ccm_wso_id = '{1034751}' where ser_id=36;
update datawg.t_series_ser set ser_ccm_wso_id = '{84101}' where ser_id=287;
update datawg.t_series_ser set ser_ccm_wso_id = '{442395}' where ser_id=243;
update datawg.t_series_ser set ser_ccm_wso_id = '{442355}' where ser_id=205;
update datawg.t_series_ser set ser_ccm_wso_id = '{88690}' where ser_id=262;

-- ADDING b_current_without_stocking

--SELECT * FROM "ref".tr_typeseries_typ ORDER BY typ_id 

INSERT INTO "ref".tr_typeseries_typ (typ_name, typ_description, typ_uni_code)
SELECT 'b_current_without_stocking_kg', 
'Current biomass of silver eel (kg) if there hadn''t been any stocking', 
'kg';

UPDATE "ref".tr_typeseries_typ 
SET typ_description = 'Current biomass of silver eel (kg) (including stocking)'
WHERE typ_id = 15;
UPDATE "ref".tr_typeseries_typ 
SET typ_description = 'Maximum potential biomass of silver eel (sumA=0) (kg) (stocking should not be included in calculations)'
WHERE typ_id = 16;
UPDATE "ref".tr_typeseries_typ 
SET typ_description = typ_description || ' DEPRECATED'
WHERE typ_name ILIKE 'see_%'; --6



DROP VIEW IF EXISTS datawg.bcurrent_without_stocking;
CREATE OR REPLACE VIEW datawg.bcurrent_without_stocking
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource,
    perc_f biom_perc_f,
    perc_t biom_perc_t,
    perc_c biom_perc_c,
    perc_mo biom_perc_mo
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
     LEFT JOIN datawg.t_eelstock_eel_percent on percent_id=eel_id
  WHERE t_eelstock_eel.eel_typ_id = 34 AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));
GRANT SELECT ON datawg.bcurrent_without_stocking TO wgeel_read;
ALTER VIEW datawg.bcurrent_without_stocking OWNER TO wgeel; 
  

-- is there any data from luxemburg ?

SELECT * FROM "ref".tr_country_cou WHERE cou_code='LU'; 
SELECT * FROM datawg.t_eelstock_eel WHERE eel_cou_code='LU';

SELECT* FROM datawg.t_series_ser 
JOIN datawg.t_fishseries_fiser  ON fiser_ser_id =ser_id
JOIN datawg.t_metricindseries_meiser ON mei_fi_id=fi_id
--LEFT JOIN datawg.t_metricgroupseries_megser ON meg_gr_id = gr_id
WHERE ser_cou_code = 'IE'
AND ser_typ_id = 1


-- fixe metrics, correct on cedric labtop but somehow wrong in the db

SELECT * FROM datawg.t_metricindseries_meiser WHERE mei_mty_id  IN (27,28); -- nothing
SELECT * FROM datawg.t_metricgroupseries_megser WHERE meg_mty_id  IN (27,28);-- nothing
SELECT * FROM datawg.t_metricgroupsamp_megsa WHERE meg_mty_id  IN (27,28);-- NOTHING
SELECT * FROM datawg.t_metricindsamp_meisa WHERE mei_mty_id  IN (27,28);-- NOTHING

UPDATE "ref".tr_metrictype_mty
  SET mty_name='female_proportion'
  ,mty_individual_name='is_female(1=female,0=male)'
  ,mty_description='Female status (is_female) or female proportion in the population female/(male+female) for group'
  ,mty_method='Check method in method_sex'
  WHERE mty_id=6;

UPDATE "ref".tr_metrictype_mty
  SET mty_name='anguillicola_proportion'
  ,mty_individual_name='anguillicola_presence(1=present,0=absent)'
  ,mty_description='Presence of anguillicola or prevalence in proportion in group (between 0 and 1)'
  ,mty_method='check method in method_anguillicola'
  WHERE mty_id=8;


UPDATE "ref".tr_metrictype_mty
  SET mty_name='method_sex_(1=visual,0=use_length)'
  ,mty_individual_name=NULL
  ,mty_description='Method used for sex determination'
  ,mty_method=NULL
  WHERE mty_id=27;

UPDATE "ref".tr_metrictype_mty
  SET mty_name='method_anguillicola_(1=stereomicroscope,0=visual_obs)'
  ,mty_individual_name=NULL
  ,mty_description='Method used for sex determination'
  ,mty_method=NULL
  WHERE mty_id=28;


SELECT * FROM datawg.t_groupseries_grser AS tgg WHERE gr_id = 1684;


--creation of the datasource (OK)

insert into ref.tr_datasource_dts values ('dc_2024', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2024');

insert into ref.tr_quality_qal values (24, 'discarded_wgeel 2024','This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2024', FALSE);
    


--SELECT * FROM datawg.t_eelstock_eel AS tee WHERE eel_datasource ='dc_2024'
-- DELETE FROM datawg.t_eelstock_eel AS tee WHERE eel_datasource ='dc_2024'

SELECT * FROM datawg.log WHERE log_date >= '2024-09-03'




begin;
update ref.tr_metrictype_mty set mty_individual_name ='is_female_(1=female,0=male)' where mty_individual_name ='is_female(1=female,0=male)';
update ref.tr_metrictype_mty set mty_individual_name ='anguillicola_presence_(1=present,0=absent)' where mty_individual_name ='anguillicola_presence(1=present,0=absent)';
commit;



--fix IMPORT issue #339
-- check why we removed the values from landings last year
CREATE OR REPLACE VIEW datawg.landings
AS SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
    tr_typeseries_typ.typ_name,
    tr_typeseries_typ.typ_uni_code,
    t_eelstock_eel.eel_year,
    t_eelstock_eel.eel_value,
    t_eelstock_eel.eel_missvaluequal,
    t_eelstock_eel.eel_emu_nameshort,
    t_eelstock_eel.eel_cou_code,
    tr_country_cou.cou_country,
    tr_country_cou.cou_order,
    tr_country_cou.cou_iso3code,
    t_eelstock_eel.eel_lfs_code,
    tr_lifestage_lfs.lfs_name,
    t_eelstock_eel.eel_hty_code,
    tr_habitattype_hty.hty_description,
    t_eelstock_eel.eel_area_division,
    t_eelstock_eel.eel_qal_id,
    tr_quality_qal.qal_level,
    tr_quality_qal.qal_text,
    t_eelstock_eel.eel_qal_comment,
    t_eelstock_eel.eel_comment,
    t_eelstock_eel.eel_datasource
   FROM t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
  WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 32, 33])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4]));

SELECT * FROM datawg.t_eelstock_eel_percent AS teep WHERE percent_id =513222
UPDATE datawg.t_eelstock_eel_percent set perc_f=100, perc_t=100,perc_c=0, perc_mo=0 WHERE percent_id =513222
SELECT * FROM datawg.t_eelstock_eel WHERE eel_id = 513222



update datawg.t_series_ser set ser_qal_id=1, ser_qal_comment = 'now reaches the 10 years thresholds, validated by Ciara O''Leary'
 where ser_nameshort = 'CorGY';

update datawg.t_series_ser set ser_qal_id=1, ser_qal_comment = 'now reaches the 10 years thresholds, validated by Jan-Dag Pohlman'
 where ser_nameshort = 'EmsHG';
 
 
 
 
CREATE OR REPLACE VIEW datawg.bigtable
AS WITH b0 AS (
         SELECT b0_1.eel_cou_code,
            b0_1.eel_emu_nameshort,
            b0_1.eel_hty_code,
            b0_1.eel_year,
            b0_1.eel_lfs_code,
            round(sum(b0_1.eel_value)) AS b0
           FROM datawg.b0 b0_1
          GROUP BY b0_1.eel_cou_code, b0_1.eel_emu_nameshort, b0_1.eel_hty_code, b0_1.eel_year, b0_1.eel_lfs_code
        ), bbest AS (
         SELECT bbest_1.eel_cou_code,
            bbest_1.eel_emu_nameshort,
            bbest_1.eel_hty_code,
            bbest_1.eel_year,
            bbest_1.eel_lfs_code,
            round(sum(bbest_1.eel_value)) AS bbest
           FROM datawg.bbest bbest_1
          GROUP BY bbest_1.eel_cou_code, bbest_1.eel_emu_nameshort, bbest_1.eel_hty_code, bbest_1.eel_year, bbest_1.eel_lfs_code
        ), bcurrent AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            round(sum(bcurrent_1.eel_value)) AS bcurrent
           FROM datawg.bcurrent bcurrent_1
          GROUP BY bcurrent_1.eel_cou_code, bcurrent_1.eel_emu_nameshort, bcurrent_1.eel_hty_code, bcurrent_1.eel_year, bcurrent_1.eel_lfs_code
        ), bcurrent_without_stocking AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            round(sum(bcurrent_1.eel_value)) AS bcurrent_without_stocking
           FROM datawg.bcurrent_without_stocking bcurrent_1
          GROUP BY bcurrent_1.eel_cou_code, bcurrent_1.eel_emu_nameshort, bcurrent_1.eel_hty_code, bcurrent_1.eel_year, bcurrent_1.eel_lfs_code
        ), suma AS (
         SELECT sigmaa.eel_cou_code,
            sigmaa.eel_emu_nameshort,
            sigmaa.eel_hty_code,
            sigmaa.eel_year,
            sigmaa.eel_lfs_code,
            round(
                CASE
                    WHEN sigmaa.eel_missvaluequal::text = 'NP'::text THEN 0::numeric
                    ELSE sigmaa.eel_value
                END, 3) AS suma
           FROM datawg.sigmaa
        ), sumf AS (
         SELECT sigmaf.eel_cou_code,
            sigmaf.eel_emu_nameshort,
            sigmaf.eel_hty_code,
            sigmaf.eel_year,
            sigmaf.eel_lfs_code,
            round(
                CASE
                    WHEN sigmaf.eel_missvaluequal::text = 'NP'::text THEN 0::numeric
                    ELSE sigmaf.eel_value
                END, 3) AS sumf
           FROM datawg.sigmaf
        ), sumh AS (
         SELECT sigmah.eel_cou_code,
            sigmah.eel_emu_nameshort,
            sigmah.eel_hty_code,
            sigmah.eel_year,
            sigmah.eel_lfs_code,
            round(
                CASE
                    WHEN sigmah.eel_missvaluequal::text = 'NP'::text THEN 0::numeric
                    ELSE sigmah.eel_value
                END, 3) AS sumh
           FROM datawg.sigmah
        ), habitat_ha AS (
         SELECT potential_available_habitat.eel_cou_code,
            potential_available_habitat.eel_emu_nameshort,
            potential_available_habitat.eel_hty_code,
            potential_available_habitat.eel_year,
            potential_available_habitat.eel_lfs_code,
            round(potential_available_habitat.eel_value, 3) AS habitat_ha
           FROM datawg.potential_available_habitat
        ), countries AS (
         SELECT tr_country_cou.cou_code,
            tr_country_cou.cou_country AS country,
            tr_country_cou.cou_order
           FROM ref.tr_country_cou
        ), emu AS (
         SELECT tr_emu_emu.emu_nameshort,
            tr_emu_emu.emu_wholecountry
           FROM ref.tr_emu_emu
        ), habitat AS (
         SELECT tr_habitattype_hty.hty_code,
            tr_habitattype_hty.hty_description AS habitat
           FROM ref.tr_habitattype_hty
        ), life_stage AS (
         SELECT tr_lifestage_lfs.lfs_code,
            tr_lifestage_lfs.lfs_name AS life_stage
           FROM ref.tr_lifestage_lfs
        )
 SELECT eel_year,
    eel_cou_code,
    countries.country,
    countries.cou_order,
    eel_emu_nameshort,
    emu.emu_wholecountry,
    eel_hty_code,
    habitat.habitat,
    eel_lfs_code,
    life_stage.life_stage,
    b0.b0,
    bbest.bbest,
    bcurrent.bcurrent,
    suma.suma,
    sumf.sumf,
    sumh.sumh,
    habitat_ha.habitat_ha,
    bcurrent_without_stocking.bcurrent_without_stocking
   FROM b0
     FULL JOIN bbest USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN bcurrent_without_stocking USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN bcurrent USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN suma USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN sumf USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN sumh USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN habitat_ha USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code)
     FULL JOIN countries ON eel_cou_code::text = countries.cou_code::text
     JOIN emu ON eel_emu_nameshort::text = emu.emu_nameshort::text
     JOIN habitat ON eel_hty_code::text = habitat.hty_code::text
     JOIN life_stage ON eel_lfs_code::text = life_stage.lfs_code::text
  ORDER BY eel_year, countries.cou_order, eel_emu_nameshort, (
        CASE
            WHEN eel_hty_code::text = 'F'::text THEN 1
            WHEN eel_hty_code::text = 'T'::text THEN 2
            WHEN eel_hty_code::text = 'C'::text THEN 3
            WHEN eel_hty_code::text = 'MO'::text THEN 4
            WHEN eel_hty_code::text = 'AL'::text THEN 5
            ELSE NULL::integer
        END), (
        CASE
            WHEN eel_lfs_code::text = 'G'::text THEN 1
            WHEN eel_lfs_code::text = 'QG'::text THEN 2
            WHEN eel_lfs_code::text = 'OG'::text THEN 3
            WHEN eel_lfs_code::text = 'GY'::text THEN 4
            WHEN eel_lfs_code::text = 'Y'::text THEN 5
            WHEN eel_lfs_code::text = 'YS'::text THEN 6
            WHEN eel_lfs_code::text = 'S'::text THEN 7
            WHEN eel_lfs_code::text = 'AL'::text THEN 8
            ELSE NULL::integer
        END);
        
        
CREATE OR REPLACE VIEW datawg.bigtable_by_habitat
AS SELECT eel_year,
    eel_cou_code,
    country,
    cou_order,
    eel_emu_nameshort,
    emu_wholecountry,
    eel_hty_code,
    habitat,
    sum(b0) AS b0,
    sum(bbest) AS bbest,
    sum(bcurrent) AS bcurrent,
    sum(suma) AS suma,
    sum(sumf) AS sumf,
    sum(sumh) AS sumh,
    sum(habitat_ha) AS habitat_ha,
    string_agg(eel_lfs_code::text, ', '::text) AS aggregated_lfs,
    sum(bcurrent_without_stocking) AS bcurrent_without_stocking
   FROM datawg.bigtable
  GROUP BY eel_year, eel_cou_code, country, cou_order, eel_emu_nameshort, emu_wholecountry, eel_hty_code, habitat
  ORDER BY eel_year, cou_order, eel_emu_nameshort, (
        CASE
            WHEN eel_hty_code::text = 'F'::text THEN 1
            WHEN eel_hty_code::text = 'T'::text THEN 2
            WHEN eel_hty_code::text = 'C'::text THEN 3
            WHEN eel_hty_code::text = 'MO'::text THEN 4
            WHEN eel_hty_code::text = 'AL'::text THEN 5
            ELSE NULL::integer
        END);
        
CREATE OR REPLACE VIEW datawg.precodata_emu
AS WITH b0_unique AS (
         SELECT bigtable_by_habitat_1.eel_emu_nameshort,
            sum(bigtable_by_habitat_1.b0) AS unique_b0
           FROM datawg.bigtable_by_habitat bigtable_by_habitat_1
          WHERE bigtable_by_habitat_1.eel_year = 0 AND bigtable_by_habitat_1.eel_emu_nameshort::text <> 'ES_Murc'::text OR bigtable_by_habitat_1.eel_year = 0 AND bigtable_by_habitat_1.eel_emu_nameshort::text = 'ES_Murc'::text AND bigtable_by_habitat_1.eel_hty_code::text = 'C'::text
          GROUP BY bigtable_by_habitat_1.eel_emu_nameshort
        )
 SELECT bigtable_by_habitat.eel_year,
    bigtable_by_habitat.eel_cou_code,
    bigtable_by_habitat.country,
    bigtable_by_habitat.cou_order,
    bigtable_by_habitat.eel_emu_nameshort,
    bigtable_by_habitat.emu_wholecountry,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE COALESCE(b0_unique.unique_b0, sum(bigtable_by_habitat.b0))
        END AS b0,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bbest)
        END AS bbest,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bcurrent)
        END AS bcurrent,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['ES_Cata'::character varying::text, 'LT_total'::character varying::text]) THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.suma * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.suma)
        END AS suma,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['ES_Cata'::character varying::text, 'LT_total'::character varying::text]) THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.sumf * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.sumf)
        END AS sumf,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = ANY (ARRAY['IT_Camp'::character varying::text, 'IT_Emil'::character varying::text, 'IT_Frio'::character varying::text, 'IT_Lazi'::character varying::text, 'IT_Pugl'::character varying::text, 'IT_Sard'::character varying::text, 'IT_Sici'::character varying::text, 'IT_Tosc'::character varying::text, 'IT_Vene'::character varying::text, 'IT_Abru'::character varying::text, 'IT_Basi'::character varying::text, 'IT_Cala'::character varying::text, 'IT_Ligu'::character varying::text, 'IT_Lomb'::character varying::text, 'IT_Marc'::character varying::text, 'IT_Moli'::character varying::text, 'IT_Piem'::character varying::text, 'IT_Tren'::character varying::text, 'IT_Umbr'::character varying::text, 'IT_Vall'::character varying::text]) THEN round(sum(bigtable_by_habitat.sumh * bigtable_by_habitat.bbest) / sum(bigtable_by_habitat.bbest), 3)
            ELSE sum(bigtable_by_habitat.sumh)
        END AS sumh,
    'emu'::text AS aggreg_level,
    bigtable_by_habitat.aggregated_lfs,
    string_agg(bigtable_by_habitat.eel_hty_code::text, ', '::text) AS aggregated_hty,
        CASE
            WHEN bigtable_by_habitat.eel_emu_nameshort::text = 'LT_total'::text THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bcurrent_without_stocking)
        END AS bcurrent_without_stocking
   FROM datawg.bigtable_by_habitat
     LEFT JOIN b0_unique USING (eel_emu_nameshort)
  WHERE bigtable_by_habitat.eel_year > 1850 AND bigtable_by_habitat.aggregated_lfs = 'S'::text AND bigtable_by_habitat.eel_emu_nameshort::text <> 'ES_Murc'::text OR bigtable_by_habitat.eel_year > 1850 AND bigtable_by_habitat.eel_emu_nameshort::text = 'ES_Murc'::text AND bigtable_by_habitat.eel_hty_code::text = 'C'::text
  GROUP BY bigtable_by_habitat.eel_year, bigtable_by_habitat.eel_cou_code, bigtable_by_habitat.country, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort, bigtable_by_habitat.emu_wholecountry, bigtable_by_habitat.aggregated_lfs, b0_unique.unique_b0
  ORDER BY bigtable_by_habitat.eel_year, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort;
  
  
  
  
  
  
  
  
  
  drop table datawg.t_modeldata_dat ;
CREATE TABLE datawg.t_modeldata_dat (
	dat_id serial4 NOT NULL,
	dat_run_id int4 NOT NULL,
	dat_ser_id int4 NOT NULL,
	dat_ser_year int4 NOT NULL,
	dat_das_value numeric NULL,
	dat_das_qal_id int4,
	CONSTRAINT tr_model_mod_pkey PRIMARY KEY (dat_id),
	CONSTRAINT c_fk_dat_run_id FOREIGN KEY (dat_run_id) REFERENCES datawg.t_modelrun_run(run_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT c_fk_dat_ser_id FOREIGN KEY (dat_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON DELETE CASCADE ON UPDATE CASCADE
);
GRANT REFERENCES, TRIGGER, UPDATE, DELETE, SELECT, INSERT, TRUNCATE ON TABLE datawg.t_modeldata_dat TO wgeel;
GRANT SELECT ON TABLE datawg.t_modeldata_dat TO wgeel_read;
GRANT USAGE, UPDATE, SELECT ON SEQUENCE datawg.t_modeldata_dat_dat_id_seq TO wgeel;

GRANT SELECT ON TABLE datawg.precodata_country TO wgeel_read;


begin;
update datawg.t_eelstock_eel set eel_qal_id = 1,
eel_qal_comment ='those data were incorrectly deleted during dc_2024 so reintegrated back afterwards' 
where eel_typ_id =4 and eel_qal_id =24 and eel_value is not null and eel_cou_code = 'DK';
commit;
-- fix function , should be mty_group not type

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

    IF (the_mty_group = 'group') THEN
    RAISE EXCEPTION 'table t_metricind_mei, metric --> % is not an individual metric', the_mty_name ;
    END IF  ;
    if (the_mty_unit = 'wo' and new.mei_value not in (0,1)) then
  raise exception 'metric % should have only 0 or 1 for individuals', the_mty_name;
    end if;
    RETURN NEW ;
  END  ;
$function$
;





CREATE OR REPLACE VIEW datawg.precodata
AS WITH b0 AS (
         SELECT b0_1.eel_cou_code,
            b0_1.eel_emu_nameshort,
            b0_1.eel_hty_code,
            b0_1.eel_year,
            b0_1.eel_lfs_code,
            b0_1.eel_qal_id,
            b0_1.eel_value AS b0
           FROM datawg.b0 b0_1
          WHERE (b0_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR b0_1.eel_qal_id = 0 AND b0_1.eel_missvaluequal::text = 'NP'::text
        ), bbest AS (
         SELECT bbest_1.eel_cou_code,
            bbest_1.eel_emu_nameshort,
            bbest_1.eel_hty_code,
            bbest_1.eel_year,
            bbest_1.eel_lfs_code,
            bbest_1.eel_qal_id,
            bbest_1.eel_value AS bbest
           FROM datawg.bbest bbest_1
          WHERE (bbest_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bbest_1.eel_qal_id = 0 AND bbest_1.eel_missvaluequal::text = 'NP'::text
        ), bcurrent AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            bcurrent_1.eel_qal_id,
            bcurrent_1.eel_value AS bcurrent
           FROM datawg.bcurrent bcurrent_1
          WHERE (bcurrent_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bcurrent_1.eel_qal_id = 0 AND bcurrent_1.eel_missvaluequal::text = 'NP'::text
        ), bcurrent_without_stocking AS (
         SELECT bcurrent_without_stocking_1.eel_cou_code,
            bcurrent_without_stocking_1.eel_emu_nameshort,
            bcurrent_without_stocking_1.eel_hty_code,
            bcurrent_without_stocking_1.eel_year,
            bcurrent_without_stocking_1.eel_lfs_code,
            bcurrent_without_stocking_1.eel_qal_id,
            bcurrent_without_stocking_1.eel_value AS bcurrent_without_stocking
           FROM datawg.bcurrent_without_stocking bcurrent_without_stocking_1
          WHERE (bcurrent_without_stocking_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bcurrent_without_stocking_1.eel_qal_id = 0 AND bcurrent_without_stocking_1.eel_missvaluequal::text = 'NP'::text
        ), suma AS (
         SELECT sigmaa.eel_cou_code,
            sigmaa.eel_emu_nameshort,
            sigmaa.eel_hty_code,
            sigmaa.eel_year,
            sigmaa.eel_lfs_code,
            sigmaa.eel_qal_id,
            round(sigmaa.eel_value, 3) AS suma
           FROM datawg.sigmaa
          WHERE (sigmaa.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmaa.eel_qal_id = 0 AND sigmaa.eel_missvaluequal::text = 'NP'::text
        ), sumf AS (
         SELECT sigmaf.eel_cou_code,
            sigmaf.eel_emu_nameshort,
            sigmaf.eel_hty_code,
            sigmaf.eel_year,
            sigmaf.eel_lfs_code,
            sigmaf.eel_qal_id,
            round(sigmaf.eel_value, 3) AS sumf
           FROM datawg.sigmaf
          WHERE (sigmaf.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmaf.eel_qal_id = 0 AND sigmaf.eel_missvaluequal::text = 'NP'::text
        ), sumh AS (
         SELECT sigmah.eel_cou_code,
            sigmah.eel_emu_nameshort,
            sigmah.eel_hty_code,
            sigmah.eel_year,
            sigmah.eel_lfs_code,
            sigmah.eel_qal_id,
            round(sigmah.eel_value, 3) AS sumh
           FROM datawg.sigmah
          WHERE (sigmah.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmah.eel_qal_id = 0 AND sigmah.eel_missvaluequal::text = 'NP'::text
        ), countries AS (
         SELECT tr_country_cou.cou_code,
            tr_country_cou.cou_country AS country,
            tr_country_cou.cou_order
           FROM ref.tr_country_cou
        ), emu AS (
         SELECT tr_emu_emu.emu_nameshort,
            tr_emu_emu.emu_wholecountry
           FROM ref.tr_emu_emu
        ), life_stage AS (
         SELECT tr_lifestage_lfs.lfs_code,
            tr_lifestage_lfs.lfs_name AS life_stage
           FROM ref.tr_lifestage_lfs
        )
 SELECT eel_year,
    eel_cou_code,
    countries.country,
    countries.cou_order,
    eel_emu_nameshort,
    emu.emu_wholecountry,
    eel_hty_code,
    eel_lfs_code,
    life_stage.life_stage,
    eel_qal_id,
    b0.b0,
    bbest.bbest,
    bcurrent.bcurrent,
    suma.suma,
    sumf.sumf,
    sumh.sumh,
    bcurrent_without_stocking.bcurrent_without_stocking
   FROM b0
     FULL JOIN bbest USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN bcurrent USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN bcurrent_without_stocking USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN suma USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN sumf USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN sumh USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN countries ON eel_cou_code::text = countries.cou_code::text
     JOIN emu ON eel_emu_nameshort::text = emu.emu_nameshort::text
     JOIN life_stage ON eel_lfs_code::text = life_stage.lfs_code::text
  ORDER BY eel_year, countries.cou_order, eel_emu_nameshort, eel_qal_id;
  
  
  
  
  CREATE OR REPLACE VIEW datawg.precodata_country
as

WITH 
 nr_emu_per_country AS (
         SELECT tr_emu_emu.emu_cou_code,
            sum((NOT tr_emu_emu.emu_wholecountry)::integer) AS nr_emu
           FROM ref.tr_emu_emu
          GROUP BY tr_emu_emu.emu_cou_code
        ), mimimun_met AS (
         SELECT precodata.eel_year,
            precodata.eel_cou_code,
            precodata.country,
            precodata.eel_emu_nameshort,
            precodata.bbest,
            precodata.bcurrent,
            precodata.bcurrent_without_stocking,
            precodata.suma,
            precodata.sumf,
            precodata.sumh,
            precodata.bbest IS NOT NULL AS bbestt,
            precodata.bcurrent IS NOT NULL AS bcurrentt,
            precodata.bcurrent_without_stocking IS NOT NULL AS bcurrentt_without_stocking,
            precodata.suma IS NOT NULL AS sumat,
            precodata.sumf IS NOT NULL AS sumft,
            precodata.sumh IS NOT NULL AS sumht
           FROM datawg.precodata
          WHERE precodata.eel_qal_id <> 0 AND NOT precodata.emu_wholecountry
        ), analyse_emu_total AS (
         SELECT precodata.eel_year,
            precodata.eel_cou_code,
            precodata.country,
            precodata.bbest,
            precodata.bcurrent,
            precodata.bcurrent_without_stocking,
            precodata.suma,
            precodata.sumf,
            precodata.sumh,
            (precodata.bbest IS NOT NULL)::integer AS bbest_total,
            (precodata.bcurrent IS NOT NULL)::integer AS bcurrent_total,
            (precodata.bcurrent_without_stocking IS NOT NULL)::integer AS bcurrent_total_without_stocking,
            (precodata.suma IS NOT NULL)::integer AS suma_total,
            (precodata.sumf IS NOT NULL)::integer AS sumf_total,
            (precodata.sumh IS NOT NULL)::integer AS sumh_total
           FROM datawg.precodata
          WHERE precodata.eel_qal_id <> 0 AND precodata.emu_wholecountry
        ), analyse_emu AS (
         SELECT mimimun_met.eel_year,
            mimimun_met.eel_cou_code,
            mimimun_met.country,
            count(*) AS counted_emu,
            sum(mimimun_met.bbestt::integer) AS bbest_emu,
            sum(mimimun_met.bcurrentt::integer) AS bcurrent_emu,
            sum(mimimun_met.bcurrentt_without_stocking::integer) AS bcurrent_emu_without_stocking,
            sum(mimimun_met.sumat::integer) AS suma_emu,
            sum(mimimun_met.sumft::integer) AS sumf_emu,
            sum(mimimun_met.sumht::integer) AS sumh_emu,
            sum(mimimun_met.bbest) AS bbest,
            sum(mimimun_met.bcurrent) AS bcurrent,
            sum(mimimun_met.bcurrent_without_stocking) AS bcurrent_without_stocking,
            round(sum(mimimun_met.suma * mimimun_met.bbest) / sum(mimimun_met.bbest), 3) AS suma,
            round(sum(mimimun_met.sumf * mimimun_met.bbest) / sum(mimimun_met.bbest), 3) AS sumf,
            round(sum(mimimun_met.sumh * mimimun_met.bbest) / sum(mimimun_met.bbest), 3) AS sumh
           FROM mimimun_met
          GROUP BY mimimun_met.eel_year, mimimun_met.eel_cou_code, mimimun_met.country
        ),  analyse_b0 as(
               select sum(eel_value) b0, emu_cou_code  eel_cou_code, count(*) b0_emu 
                     from datawg.b0 left join ref.tr_emu_emu on eel_emu_nameshort = emu_nameshort where not emu_wholecountry and eel_value is not null group by emu_cou_code),
        analyse_b0_total as(select eel_value b0, emu_cou_code  eel_cou_code, b0 is not null b0_total 
                     from datawg.b0 left join ref.tr_emu_emu on eel_emu_nameshort = emu_nameshort where emu_wholecountry

        )
         SELECT eel_year,
            eel_cou_code::character varying(2),
            country,
            nr_emu_per_country.nr_emu,
            'country'::text AS aggreg_level,
            NULL::character varying(20) AS eel_emu_nameshort,
                CASE
                    WHEN analyse_b0_total.b0_total THEN analyse_b0_total.b0
                    ELSE analyse_b0.b0
                END AS b0,
                CASE
                    WHEN analyse_emu_total.bbest_total = 1 THEN analyse_emu_total.bbest
                    ELSE analyse_emu.bbest
                END AS bbest,
                CASE
                    WHEN analyse_emu_total.bcurrent_total = 1 THEN analyse_emu_total.bcurrent
                    ELSE analyse_emu.bcurrent
                END AS bcurrent,
                CASE
                    WHEN analyse_emu_total.suma_total = 1 THEN analyse_emu_total.suma
                    ELSE analyse_emu.suma
                END AS suma,
                CASE
                    WHEN analyse_emu_total.sumf_total = 1 THEN analyse_emu_total.sumf
                    ELSE analyse_emu.sumf
                END AS sumf,
                CASE
                    WHEN analyse_emu_total.sumh_total = 1 THEN analyse_emu_total.sumh
                    ELSE analyse_emu.sumh
                END AS sumh,
                CASE
                    WHEN analyse_b0_total.b0_total  THEN 'EMU_Total'::text
                    WHEN analyse_b0.b0_emu = nr_emu_per_country.nr_emu THEN 'Sum of all EMU'::text
                    WHEN analyse_b0.b0_emu > 0 THEN (('Sum of '::text || analyse_b0.b0_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_b0,
                CASE
                    WHEN analyse_emu_total.bbest_total = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bbest_emu = nr_emu_per_country.nr_emu THEN 'Sum of all EMU'::text
                    WHEN analyse_emu.bbest_emu > 0 THEN (('Sum of '::text || analyse_emu.bbest_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_bbest,
                CASE
                    WHEN analyse_emu_total.bcurrent_total = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bcurrent_emu = nr_emu_per_country.nr_emu THEN 'Sum of all EMU'::text
                    WHEN analyse_emu.bcurrent_emu > 0 THEN (('Sum of '::text || analyse_emu.bcurrent_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_bcurrent,
                CASE
                    WHEN analyse_emu_total.suma_total = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bbest_emu = nr_emu_per_country.nr_emu AND analyse_emu.suma_emu = nr_emu_per_country.nr_emu THEN 'Weighted average by Bbest of all EMU'::text
                    WHEN analyse_emu.bbest_emu < nr_emu_per_country.nr_emu AND analyse_emu.suma_emu < nr_emu_per_country.nr_emu AND analyse_emu.suma_emu > 0 THEN (('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.suma_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_suma,
                CASE
                    WHEN analyse_emu_total.sumf_total = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bbest_emu = nr_emu_per_country.nr_emu AND analyse_emu.sumf_emu = nr_emu_per_country.nr_emu THEN 'Weighted average by Bbest of all EMU'::text
                    WHEN analyse_emu.bbest_emu < nr_emu_per_country.nr_emu AND analyse_emu.sumf_emu < nr_emu_per_country.nr_emu AND analyse_emu.sumf_emu > 0 THEN (('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumf_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_sumf,
                CASE
                    WHEN analyse_emu_total.sumh_total = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bbest_emu = nr_emu_per_country.nr_emu AND analyse_emu.sumh_emu = nr_emu_per_country.nr_emu THEN 'Weighted average by Bbest of all EMU'::text
                    WHEN analyse_emu.bbest_emu < nr_emu_per_country.nr_emu AND analyse_emu.sumh_emu < nr_emu_per_country.nr_emu AND analyse_emu.sumh_emu > 0 THEN (('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumh_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_sumh,
                CASE
                    WHEN analyse_emu_total.bcurrent_total_without_stocking = 1 THEN analyse_emu_total.bcurrent_without_stocking
                    ELSE analyse_emu.bcurrent_without_stocking
                END AS bcurrent_without_stocking,
                CASE
                    WHEN analyse_emu_total.bcurrent_total_without_stocking = 1 THEN 'EMU_Total'::text
                    WHEN analyse_emu.bcurrent_emu_without_stocking = nr_emu_per_country.nr_emu THEN 'Sum of all EMU'::text
                    WHEN analyse_emu.bcurrent_emu_without_stocking > 0 THEN (('Sum of '::text || analyse_emu.bcurrent_emu_without_stocking) || ' EMU out of '::text) || nr_emu_per_country.nr_emu
                    ELSE NULL::text
                END AS method_bcurrent_without_stocking
                
           FROM analyse_emu_total
             FULL JOIN analyse_emu USING (eel_year, eel_cou_code, country)
             full join analyse_b0 using(eel_cou_code)
             full join analyse_b0_total using (eel_cou_code)
             JOIN nr_emu_per_country ON eel_cou_code::text = nr_emu_per_country.emu_cou_code
     JOIN ref.tr_country_cou ON eel_cou_code::text = tr_country_cou.cou_code::text
  ORDER BY eel_year, tr_country_cou.cou_order;
        
-- datawg.precodata source
CREATE OR REPLACE VIEW datawg.precodata
as
 WITH b0 AS (
         SELECT b0_1.eel_cou_code,
            b0_1.eel_emu_nameshort,
            b0_1.eel_hty_code,
            b0_1.eel_lfs_code,
            b0_1.eel_qal_id,
            b0_1.eel_value AS b0
           FROM datawg.b0 b0_1
          WHERE (b0_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR b0_1.eel_qal_id = 0 AND b0_1.eel_missvaluequal::text = 'NP'::text
        ), bbest AS (
         SELECT bbest_1.eel_cou_code,
            bbest_1.eel_emu_nameshort,
            bbest_1.eel_hty_code,
            bbest_1.eel_year,
            bbest_1.eel_lfs_code,
            bbest_1.eel_qal_id,
            bbest_1.eel_value AS bbest
           FROM datawg.bbest bbest_1
          WHERE (bbest_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bbest_1.eel_qal_id = 0 AND bbest_1.eel_missvaluequal::text = 'NP'::text
        ), bcurrent AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            bcurrent_1.eel_qal_id,
            bcurrent_1.eel_value AS bcurrent
           FROM datawg.bcurrent bcurrent_1
          WHERE (bcurrent_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bcurrent_1.eel_qal_id = 0 AND bcurrent_1.eel_missvaluequal::text = 'NP'::text
        ), bcurrent_without_stocking AS (
         SELECT bcurrent_without_stocking_1.eel_cou_code,
            bcurrent_without_stocking_1.eel_emu_nameshort,
            bcurrent_without_stocking_1.eel_hty_code,
            bcurrent_without_stocking_1.eel_year,
            bcurrent_without_stocking_1.eel_lfs_code,
            bcurrent_without_stocking_1.eel_qal_id,
            bcurrent_without_stocking_1.eel_value AS bcurrent_without_stocking
           FROM datawg.bcurrent_without_stocking bcurrent_without_stocking_1
          WHERE (bcurrent_without_stocking_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR bcurrent_without_stocking_1.eel_qal_id = 0 AND bcurrent_without_stocking_1.eel_missvaluequal::text = 'NP'::text
        ), suma AS (
         SELECT sigmaa.eel_cou_code,
            sigmaa.eel_emu_nameshort,
            sigmaa.eel_hty_code,
            sigmaa.eel_year,
            sigmaa.eel_lfs_code,
            sigmaa.eel_qal_id,
            round(sigmaa.eel_value, 3) AS suma
           FROM datawg.sigmaa
          WHERE (sigmaa.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmaa.eel_qal_id = 0 AND sigmaa.eel_missvaluequal::text = 'NP'::text
        ), sumf AS (
         SELECT sigmaf.eel_cou_code,
            sigmaf.eel_emu_nameshort,
            sigmaf.eel_hty_code,
            sigmaf.eel_year,
            sigmaf.eel_lfs_code,
            sigmaf.eel_qal_id,
            round(sigmaf.eel_value, 3) AS sumf
           FROM datawg.sigmaf
          WHERE (sigmaf.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmaf.eel_qal_id = 0 AND sigmaf.eel_missvaluequal::text = 'NP'::text
        ), sumh AS (
         SELECT sigmah.eel_cou_code,
            sigmah.eel_emu_nameshort,
            sigmah.eel_hty_code,
            sigmah.eel_year,
            sigmah.eel_lfs_code,
            sigmah.eel_qal_id,
            round(sigmah.eel_value, 3) AS sumh
           FROM datawg.sigmah
          WHERE (sigmah.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR sigmah.eel_qal_id = 0 AND sigmah.eel_missvaluequal::text = 'NP'::text
        ), countries AS (
         SELECT tr_country_cou.cou_code,
            tr_country_cou.cou_country AS country,
            tr_country_cou.cou_order
           FROM ref.tr_country_cou
        ), emu AS (
         SELECT tr_emu_emu.emu_nameshort,
            tr_emu_emu.emu_wholecountry
           FROM ref.tr_emu_emu
        ), life_stage AS (
         SELECT tr_lifestage_lfs.lfs_code,
            tr_lifestage_lfs.lfs_name AS life_stage
           FROM ref.tr_lifestage_lfs
        )
 SELECT eel_year,
    eel_cou_code,
    countries.country,
    countries.cou_order,
    eel_emu_nameshort,
    emu.emu_wholecountry,
    eel_hty_code,
    eel_lfs_code,
    life_stage.life_stage,
    eel_qal_id,
    b0.b0,
    bbest.bbest,
    bcurrent.bcurrent,
    suma.suma,
    sumf.sumf,
    sumh.sumh,
    bcurrent_without_stocking.bcurrent_without_stocking
   FROM b0
     FULL JOIN bbest USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_lfs_code, eel_qal_id)
     FULL JOIN bcurrent USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN bcurrent_without_stocking USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN suma USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN sumf USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN sumh USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id)
     FULL JOIN countries ON eel_cou_code::text = countries.cou_code::text
     JOIN emu ON eel_emu_nameshort::text = emu.emu_nameshort::text
     JOIN life_stage ON eel_lfs_code::text = life_stage.lfs_code::text
  ORDER BY eel_year, countries.cou_order, eel_emu_nameshort, eel_qal_id;
  
  
  
  -- datawg.precodata_all source

CREATE OR REPLACE VIEW datawg.precodata_all
AS WITH all_level AS (
        ( WITH last_year_emu AS (
                 SELECT precodata.eel_emu_nameshort,
                    max(precodata.eel_year) AS last_year
                   FROM datawg.precodata
                  WHERE precodata.bbest IS NOT NULL AND precodata.bcurrent IS NOT NULL AND precodata.suma IS NOT NULL
                  GROUP BY precodata.eel_emu_nameshort
                )
         
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            NULL::text AS aggreg_comment,
            b0.eel_value AS b0,
            p.bbest,
            p.bcurrent,
            p.suma,
            p.sumf,
            p.sumh,
            'all'::text AS aggreg_level,
            last_year_emu.last_year
           FROM datawg.precodata p
             LEFT JOIN last_year_emu USING (eel_emu_nameshort)
             LEFT JOIN datawg.b0 USING (eel_emu_nameshort))
        UNION ( WITH last_year_emu AS (
                 SELECT precodata.eel_emu_nameshort,
                    max(precodata.eel_year) AS last_year
                   FROM datawg.precodata
                  WHERE precodata.bbest IS NOT NULL AND precodata.bcurrent IS NOT NULL AND precodata.suma IS NOT NULL
                  GROUP BY precodata.eel_emu_nameshort
                )
         
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            NULL::text AS aggreg_comment,
            b0.eel_value AS b0,
            p.bbest,
            p.bcurrent,
            p.suma,
            p.sumf,
            p.sumh,
            'emu'::text AS aggreg_level,
            last_year_emu.last_year
           FROM datawg.precodata p
             LEFT JOIN last_year_emu USING (eel_emu_nameshort)
             LEFT JOIN datawg.b0 USING (eel_emu_nameshort))
        
        
        
        
        
        
        
        
        UNION
        ( WITH last_year_country AS (
                 SELECT precodata_country.eel_cou_code,
                    max(precodata_country.eel_year) AS last_year
                   FROM datawg.precodata_country
                  WHERE precodata_country.bbest IS NOT NULL AND precodata_country.bcurrent IS NOT NULL AND precodata_country.suma IS NOT NULL
                  GROUP BY precodata_country.eel_cou_code
                )
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            ((((((((((('<B0>'::text || p.method_b0) || '<\B0><Bbest>'::text) || p.method_bbest) || '<\Bbest><Bcurrent>'::text) || p.method_bcurrent) || '<\Bcurrent><suma>'::text) || p.method_suma) || '<\suma><sumf>'::text) || p.method_sumf) || '<\sumf><sumh>'::text) || p.method_sumh) || '<\sumah>'::text AS aggreg_comment,
            b0,
            p.bbest,
            p.bcurrent,
            p.suma,
            p.sumf,
            p.sumh,
            p.aggreg_level,
            last_year_country.last_year
           FROM datawg.precodata_country p
             LEFT JOIN last_year_country USING (eel_cou_code))
        UNION
         SELECT precodata_country.eel_year,
            NULL::character varying AS eel_cou_code,
            NULL::character varying AS eel_emu_nameshort,
            ((('All ('::text || count(*)) || ' countries: '::text) || string_agg(precodata_country.eel_cou_code::text, ','::text)) || ')'::text AS aggreg_comment,
            sum(precodata_country.b0) AS b0,
            sum(precodata_country.bbest) AS bbest,
            sum(precodata_country.bcurrent) AS bcurrent,
            round(sum(precodata_country.suma * precodata_country.bbest) / sum(precodata_country.bbest), 3) AS suma,
                CASE
                    WHEN count(precodata_country.sumf) < count(*) THEN NULL::numeric
                    ELSE round(sum(precodata_country.sumf * precodata_country.bbest) / sum(precodata_country.bbest), 3)
                END AS sumf,
                CASE
                    WHEN count(precodata_country.sumh) < count(*) THEN NULL::numeric
                    ELSE round(sum(precodata_country.sumh * precodata_country.bbest) / sum(precodata_country.bbest), 3)
                END AS sumf,
            'all'::text AS aggreg_level,
            NULL::integer AS last_year
           FROM datawg.precodata_country
          WHERE precodata_country.b0 IS NOT NULL AND precodata_country.bbest IS NOT NULL AND precodata_country.bcurrent IS NOT NULL AND precodata_country.suma IS NOT NULL
          GROUP BY precodata_country.eel_year
        )
 SELECT all_level.eel_year,
    all_level.eel_cou_code,
    all_level.eel_emu_nameshort,
    all_level.aggreg_comment,
    all_level.b0,
    all_level.bbest,
    all_level.bcurrent,
    all_level.suma,
    all_level.sumf,
    all_level.sumh,
    all_level.aggreg_level,
    all_level.last_year
   FROM all_level
     LEFT JOIN ref.tr_country_cou ON all_level.eel_cou_code::text = tr_country_cou.cou_code::text
  ORDER BY all_level.eel_year, (
        CASE
            WHEN all_level.aggreg_level = 'emu'::text THEN 1
            WHEN all_level.aggreg_level = 'country'::text THEN 2
            WHEN all_level.aggreg_level = 'all'::text THEN 3
            ELSE NULL::integer
        END), tr_country_cou.cou_order, all_level.eel_emu_nameshort;