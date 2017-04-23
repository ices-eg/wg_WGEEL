copy datawg.t_dataseries_das to 'F:/projets/GRISAM/2017/WKDATA/table/t_dataseries_das.csv' with CSV delimiter ';' HEADER;
copy datawg.t_eelstock_eel to 'F:/projets/GRISAM/2017/WKDATA/table/t_eelstock_eel.csv' with CSV delimiter ';' HEADER;
copy datawg.t_series_ser to 'F:/projets/GRISAM/2017/WKDATA/table/t_series_ser.csv' with CSV delimiter ';' HEADER;


 copy  (select   tr_country_cou.cou_code, 
  tr_country_cou.cou_country, 
  tr_country_cou.cou_order, 
  tr_country_cou.cou_iso3code from ref.tr_country_cou) to 'F:/projets/GRISAM/2017/WKDATA/table/tr_country_cou.csv' with CSV delimiter ';' HEADER;
 copy (select tr_emu_emu.emu_nameshort, 
  tr_emu_emu.emu_name, 
  tr_emu_emu.emu_cou_code from ref.tr_emu_emu) to 'F:/projets/GRISAM/2017/WKDATA/table/tr_emu_emu.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_habitattype_hty to 'F:/projets/GRISAM/2017/WKDATA/table/tr_habitattype_hty.csv' with CSV delimiter ';' HEADER; 
  copy  ref.tr_lifestage_lfs to 'F:/projets/GRISAM/2017/WKDATA/table/tr_lifestage_lfs.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_quality_qal to 'F:/projets/GRISAM/2017/WKDATA/table/tr_quality_qal.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_samplingtype_sam to 'F:/projets/GRISAM/2017/WKDATA/table/tr_samplingtype_sam.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_sea_sea to 'F:/projets/GRISAM/2017/WKDATA/table/tr_sea_sea.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_station to 'F:/projets/GRISAM/2017/WKDATA/table/tr_station .csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_typeseries_typ to 'F:/projets/GRISAM/2017/WKDATA/table/tr_typeseries_typ.csv' with CSV delimiter ';' HEADER; 
 copy  ref.tr_units_uni to 'F:/projets/GRISAM/2017/WKDATA/table/tr_units_uni.csv' with CSV delimiter ';' HEADER;
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
  tr_faoareas.surface from ref.tr_faoareas) to 'F:/projets/GRISAM/2017/WKDATA/table/tr_faoareas.csv' with CSV delimiter ';' HEADER; 