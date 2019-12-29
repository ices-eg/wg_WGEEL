copy datawg.t_dataseries_das to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/t_dataseries_das.csv' with CSV delimiter ';' HEADER;
copy datawg.t_eelstock_eel to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/t_eelstock_eel.csv' with CSV delimiter ';' HEADER;
copy datawg.t_series_ser to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/t_series_ser.csv' with CSV delimiter ';' HEADER;


 copy  (select   tr_country_cou.cou_code, 
  tr_country_cou.cou_country, 
  tr_country_cou.cou_order, 
  tr_country_cou.cou_iso3code from ref.tr_country_cou) to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_country_cou.csv' with CSV delimiter ';' HEADER;
 copy (select tr_emu_emu.emu_nameshort, 
  tr_emu_emu.emu_name, 
  tr_emu_emu.emu_cou_code,
 emu_wholecountry from ref.tr_emu_emu ORDER BY emu_nameshort,emu_wholecountry) to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_emu_emu.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_habitattype_hty to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_habitattype_hty.csv' with CSV delimiter ';' HEADER; 
  copy  ref.tr_lifestage_lfs to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_lifestage_lfs.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_quality_qal to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_quality_qal.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_samplingtype_sam to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_samplingtype_sam.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_sea_sea to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_sea_sea.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_station to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_station .csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_typeseries_typ to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_typeseries_typ.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_units_uni to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_units_uni.csv' with CSV delimiter ';' HEADER;
 copy (select 
  tr_faoareas.fid, 
  tr_faoareas.f_level, 
  tr_faoareas.f_code, 
  tr_faoareas.f_status, 
  tr_faoareas.ocean, 
  tr_faoareas.subocean, 
  tr_faoareas.f_area, 
  tr_faoareas.f_subarea, 
  tr_faoareas.f_division, 
  tr_faoareas.f_subdivis, 
  tr_faoareas.f_subunit, 
  tr_faoareas.surface from ref.tr_faoareas) to 'C:/Users/cedric.briand/OneDrive - EPTB Vilaine/Projets/GRISAM/2019/seasonality/tr_faoareas.csv' with CSV delimiter ';' HEADER; 
  
  --save shp files
  /*
  cd C:\Users\cedric.briand\Documents\projets\GRISAM\2017\WKDATA\table
  pgsql2shp -u postgres -f wgeel ref.t_emu_emu