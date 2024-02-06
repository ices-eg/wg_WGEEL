  
  
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
