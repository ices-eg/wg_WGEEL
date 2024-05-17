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


-- this is view.sql  but repeat here to launch
DROP VIEW IF EXISTS datawg.bcurrent_without_stocking CASCADE;
CREATE OR REPLACE VIEW datawg.bcurrent_without_stocking AS 
 SELECT 
    eel_id,
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
   FROM datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON t_eelstock_eel.eel_lfs_code::text = tr_lifestage_lfs.lfs_code::text
     LEFT JOIN ref.tr_quality_qal ON t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id
     LEFT JOIN ref.tr_country_cou ON t_eelstock_eel.eel_cou_code::text = tr_country_cou.cou_code::text
     LEFT JOIN ref.tr_typeseries_typ ON t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id
     LEFT JOIN ref.tr_habitattype_hty ON t_eelstock_eel.eel_hty_code::text = tr_habitattype_hty.hty_code::text
     LEFT JOIN ref.tr_emu_emu ON tr_emu_emu.emu_nameshort::text = t_eelstock_eel.eel_emu_nameshort::text AND tr_emu_emu.emu_cou_code = t_eelstock_eel.eel_cou_code::text
  WHERE (t_eelstock_eel.eel_typ_id = 34) 
  --AND (t_eelstock_eel.eel_qal_id in (1,2,4))
  ;


