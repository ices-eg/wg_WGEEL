INSERT INTO "ref".tr_datasource_dts (dts_datasource,dts_description)
  VALUES ('wkemp_2025','WKEMP 2025 special request');



INSERT INTO "ref".tr_quality_qal (qal_id,qal_level,qal_text,qal_kept)
  VALUES (-24,'correction wkemp 2025','This data has either been removed from the database in favour of new data, these corrections have been implemented after asking for revised data for 2024 datacall',false);


SELECT * FROM  datawg.precodata WHERE eel_cou_code = 'EE'

