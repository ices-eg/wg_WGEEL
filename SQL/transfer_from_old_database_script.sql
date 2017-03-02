-----------------------------------------------------------------
-- SCRIPT TO TRANSFERT THE CURRENT DATABASE TO THE NEW DATABASE
-----------------------------------------------------------------

-- This will take the data from the current sea table which was built on the wise EU layer


insert into ref.tr_sea_sea 
(select distinct on (emu_sea)
emu_hyd_syst_o as sea_o, 
emu_hyd_syst_s as sea_s,
 emu_sea as sea_code  from carto.t_emu_emu
 where emu_sea is not null);


-----------------------------------
-- TODO insert definitions
------------------------------------

insert into ref.tr_lifestage_lfs select 'G' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='glass eel';
insert into ref.tr_lifestage_lfs select 'Y' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='yellow eel';
insert into ref.tr_lifestage_lfs select 'S' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='silver eel';
insert into ref.tr_lifestage_lfs select 'YS' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='yellow + silver eel';
insert into ref.tr_lifestage_lfs select 'GY' , lfs_name,  lfs_definition from ts.tr_lifestage_lfs where lfs_name='glass + yellow eel';


--------------------------
-- tr_emu_emu
-------------------------
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;


--------------------------
-- tr_emu_emu
-------------------------
insert into ref.tr_emu_emu select distinct on (emu_name_short) * from carto.emu;
--select * from ref.tr_emu_emu;

--select * from ref.tr_country_cou;
insert into ref.tr_country_cou select distinct on ("order") * from carto.country_order order by "order"; -- 44

insert into  ref.tr_emu_emu (emu_name_short,emu_name) 
select cou_code||'_total',cou_code from ref.tr_country_cou ;--44 lines inserted

insert into ref.tr_emu_emu (emu_name_short,emu_name) 
select cou_code||'_outside_emu',cou_code from ref.tr_country_cou ;-- 44 lines inserted



--------------------------
-- ref.tr_emusplit_ems
-------------------------
insert into ref.tr_emusplit_ems (
  gid, 
  emu_name_short, 
  emu_name, 
  emu_coun_abrev, 
  emu_hyd_syst_s, 
  emu_sea, 
  sum, 
  geom, 
  centre, 
  x, 
  y, 
  emu_cty_id, 
  meu_dist_sargasso_km)

select   
  t_emuagreg_ema.gid, 
  t_emuagreg_ema.emu_name_short, 
  t_emuagreg_ema.emu_name, 
  t_emuagreg_ema.emu_coun_abrev, 
  t_emuagreg_ema.emu_hyd_syst_s, 
  t_emuagreg_ema.emu_sea, 
  t_emuagreg_ema.sum, 
  t_emuagreg_ema.geom, 
  t_emuagreg_ema.centre, 
  t_emuagreg_ema.y, 
  t_emuagreg_ema.x, 
  t_emuagreg_ema.emu_cty_id, 
  t_emuagreg_ema.dist_sargasso_km 
  from carto.t_emuagreg_ema;-- 126 lines inserted
--------------------------
-- tr_habitattype_hty
-------------------------
delete from ref.tr_habitattype_hty;
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('F','Freshwater');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('T','WFD Transitional water - implies reduced salinity');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('C','WFD Coastal water');
insert into ref.tr_habitattype_hty (hty_code,hty_description) values ('MO','Marine water (open sea)');






