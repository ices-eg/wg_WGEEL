-- server
SELECT count(*) FROM datawg.t_series_ser -- 230
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --5070
--localhost
SELECT count(*) FROM datawg.t_series_ser -- 185
SELECT count(*) FROM datawg.t_dataseries_das tdd ; --4150

INSERT INTO REF.tr_datasource_dts  VALUES ('dc_2021', 'Joint EIFAAC/GFCM/ICES Eel Data Call 2021');
INSERT INTO ref.tr_quality_qal SELECT 21,	'discarded_wgeel_2021',	
'This data has either been removed from the database in favour of new data, or corresponds to new data not kept in the database during datacall 2021',	FALSE;

-- insert into tr_typeseries_typ values ('Bcurrent_perc_F','percentage of freshwater habitat taken into account in Bcurrent estimation','%');
-- insert into tr_typeseries_typ values ('Bcurrent_perc_T','percentage of transitional habitat taken into account in Bcurrent estimation','%');
-- insert into tr_typeseries_typ values ('Bcurrent_perc_C','percentage of coastal habitat taken into account in Bcurrent estimation','%');
-- insert into tr_typeseries_typ values ('Bcurrent_perc_MO','percentage of marine open habitat taken into account in Bcurrent estimation','%');
-- insert into tr_typeseries_typ values ('Bbest_perc_F','percentage of freshwater habitat taken into account in Bbest estimation','%');
-- insert into tr_typeseries_typ values ('Bbest_perc_T','percentage of transitional habitat taken into account in Bbest estimation','%');
-- insert into tr_typeseries_typ values ('Bbest_perc_C','percentage of coastal habitat taken into account in Bbest estimation','%');
-- insert into tr_typeseries_typ values ('Bbest_perc_MO','percentage of marine open habitat taken into account in Bbest estimation','%');
-- insert into tr_typeseries_typ values ('B0_perc_F','percentage of freshwater habitat taken into account in B0 estimation','%');
-- insert into tr_typeseries_typ values ('B0_perc_T','percentage of transitional habitat taken into account in B0 estimation','%');
-- insert into tr_typeseries_typ values ('B0_perc_C','percentage of coastal habitat taken into account in B0 estimation','%');
-- insert into tr_typeseries_typ values ('B0_perc_MO','percentage of marine open habitat taken into account in B0 estimation','%');

-- insert into tr_typeseries_typ values ('suma_perc_F','percentage of freshwater habitat taken into account in suma estimation','%');
-- insert into tr_typeseries_typ values ('suma_perc_T','percentage of transitional habitat taken into account in suma estimation','%');
-- insert into tr_typeseries_typ values ('suma_perc_C','percentage of coastal habitat taken into account in suma estimation','%');
-- insert into tr_typeseries_typ values ('suma_perc_MO','percentage of marine open habitat taken into account in suma estimation','%');
-- insert into tr_typeseries_typ values ('sumf_perc_F','percentage of freshwater habitat taken into account in sumf estimation','%');
-- insert into tr_typeseries_typ values ('sumf_perc_T','percentage of transitional habitat taken into account in sumf estimation','%');
-- insert into tr_typeseries_typ values ('sumf_perc_C','percentage of coastal habitat taken into account in sumf estimation','%');
-- insert into tr_typeseries_typ values ('sumf_perc_MO','percentage of marine open habitat taken into account in sumf estimation','%');
-- insert into tr_typeseries_typ values ('sumh_perc_F','percentage of freshwater habitat taken into account in sumh estimation','%');
-- insert into tr_typeseries_typ values ('sumh_perc_T','percentage of transitional habitat taken into account in sumh estimation','%');
-- insert into tr_typeseries_typ values ('sumh_perc_C','percentage of coastal habitat taken into account in sumh estimation','%');
-- insert into tr_typeseries_typ values ('sumh_perc_MO','percentage of marine open habitat taken into account in sumh estimation','%');



create table datawg.t_eelstock_eel_percent (
	percent_id integer primary key references datawg.t_eelstock_eel(eel_id),
	perc_f numeric check((perc_f >=0 and perc_f<=0) or perc_f is null) ,
	perc_t numeric check((perc_t >=0 and perc_f<=0) or perc_t is null),
	perc_c numeric check((perc_c >=0 and perc_c<=0) or perc_c is null),
	perc_mo numeric check((perc_mo >=0 and perc_f<=0) or perc_mo is null)
);
