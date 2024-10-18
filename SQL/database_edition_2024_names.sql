#----------ref-----
COMMENT ON TABLE ref.tr_country_cou IS 'Table of ISO 3166 country codes';
COMMENT ON TABLE ref.tr_dataaccess_dta IS 'Table of possible values for data access, public or restricted. Currently all data in wgeel DB are public';
COMMENT ON TABLE ref.tr_emu_emu IS 'Table of eel management units. It most often corresponds to a river basin district (RBD) as defined in the WFD (EU, 2000), when countries have followed recommendation in the regulation. Some countries have kept a more complex system based on regions or autonomies instead of river basins (Spain and Italy). For countries outside the EU, EMUs have also been defined, either as being the management units used by the country (e.g. Tunisia) or as the whole country. In practice, data provision from some EMUs can be divided into further geographical subunits. This is, for instance, the case for Sweden where the EMU is national, but data can be provided to the WGEEL according to Inland, West and East coasts subunits. The catch from coastal areas does include eels migrating from other countries or parts of the Baltic.';
COMMENT ON TABLE ref.tr_emusplit_ems IS 'Table of eel management units with polygons split by sea, for instance in Spain EMUs can be both in Mediterranean and Atlantic,so they are split in this Table';
COMMENT ON TABLE ref.tr_faoareas IS 'These codes are for use only in the case of Coatsal and Marine Open waters';
COMMENT ON TABLE ref.tr_gear_gea IS 'Table of fishing gears coming from FAO';
COMMENT ON TABLE ref.tr_habitattype_hty IS 'Table of habitat habitat type F, T, MO, C,..';
COMMENT ON TABLE ref.tr_ices_ecoregions IS 'Table of Ices ecoregions https://vocab.ices.dk/?codetypeguid=5c4fc316-99f8-413c-8d42-8bbd11f88ab3';
COMMENT ON TABLE ref.tr_lifestage_lfs IS 'Table of lifestages of eel, allowed values may change according the table';
COMMENT ON TABLE ref.tr_metrictype_mty IS 'Table of metric type';
COMMENT ON TABLE ref.tr_model_mod IS 'Table of model reference during working groups';
COMMENT ON TABLE ref.tr_quality_qal IS 'Table of quality rating, 1 = good quality, 2 = modified 4 = warnings, 0 = missing';
COMMENT ON TABLE ref.tr_samplingtype_sam IS 'Table of sampling types for recruitment series, commercial catch
commercial CPUE, scientific estimate, trapping all,trapping partial';
COMMENT ON TABLE ref.tr_sea_sea IS 'Reference table of sea,this was taken from the wise layer as ICES seas do not cover the Mediterranean. It is consistent with the emu table which was built from the wise layer... spatial analyses such as ICES_wgeel_2008 (Hamburg) used this table, though it has been replaced in recruitment scripts by the use of ICES divisions';
COMMENT ON TABLE ref.tr_station IS 'Reference table of station based on station dictionary (https://vocab.ices.dk/?codetypeguid=dd591b83-fa5c-4ad9-b6f2-6d875d2eb320) the column names are not standardized for postgres as the ICES does not follow that format and we wish our data to be exported in the ICES dictionary';
-- check if the station table is still OK
COMMENT ON TABLE ref.tr_units_uni IS 'Table of units, see MUnit https://vocab.ices.dk/?codetypeguid=c6aa874e-7477-43e4-af10-547f83b8779f';
 -- TODO check consistency with ICES codes, there are addititional codes related to effort that come from FAO (check)
COMMENT ON TABLE "ref".tr_gear_gea IS 'Table of gears from FAO
http://www.fao.org/cwp-on-fishery-statistics/handbook/capture-fisheries-statistics/fishing-gear-classification/en/
There is a hierachy that we don''t really need but we can keep the original codes'
-- TODO should we shift here or adapt ? This doesn't seem to be consistent with ICES https://vocab.ices.dk/?codetypeguid=e0fbe0a9-50c7-4dfd-b8d4-6f0efb29dd90

-- COLUMNS -------------------------------------------------------------------------------

COMMENT ON COLUMN ref.tr_country_cou.cou_code IS 'Country codeISO 3166-1 (two letter code)';
COMMENT ON COLUMN ref.tr_country_cou.cou_country IS 'Name of the country ISO 3166 Name';
COMMENT ON COLUMN ref.tr_country_cou.cou_order IS 'Order of the countries, from North to South starting from the Baltic, including UK and Ireland in the North Sea, legacy of ordering of recruitment tables';
COMMENT ON COLUMN ref.tr_country_cou.geom IS 'Geometry (polygon) of the country,  multipolygons from addy pope, University of Edimburg
which is based on the GADM Version 2 data which is available at http://www.gadm.org/. The geom from Russia has been split and only the Baltic part (Kaliningrad) is now remaining on the map.
Mediterranean countries and some that do have emu have been added to the dataset. The current projection is the projection used by JRC for CCM (SRID 3035)';
COMMENT ON COLUMN ref.tr_country_cou.cou_iso3code IS 'codes ISO 3166-1 alpha-2 (2 letters), one column relates to ISO 3166-1 alpha-2 (three letter code)';

COMMENT ON COLUMN ref.tr_dataaccess_dta.dta_code IS 'Code public or restricted';
COMMENT ON COLUMN ref.tr_dataaccess_dta.dta_description IS 'Description of data access';

COMMENT ON COLUMN ref.tr_datasource_dta.dts_datasource IS 'Source of data, either wgeel_<year> or dc_<year>, the data was either collected directly by wgeel or during a datacall';
COMMENT ON COLUMN ref.tr_dataaccess_dta.dts_description IS 'Description of the source of data';

COMMENT ON COLUMN ref.tr_emu_emu.emu_nameshort IS 'The short names of EMU'; 
COMMENT ON COLUMN ref.tr_emu_emu.emu_name IS 'The name of EMU';
COMMENT ON COLUMN ref.tr_emu_emu.emu_cou_code IS ' The country codes of EMU references tr_country_code';
COMMENT ON COLUMN ref.tr_emu_emu.geom IS 'Geometry, the current projection ESPG 4326, total for countries e.g. `BE_total` does not have geometry';
COMMENT ON COLUMN ref.tr_emu_emu.emu_wholecountry IS 'Does the emu covers the whole country';
COMMENT ON COLUMN ref.tr_emu_emu.geom_buffered IS ' Buffered (10 km) geometry used to check if coordinates of individual fishes fall within the EMU, ESPG 4326';
COMMENT ON COLUMN ref.tr_emu_emu.deprec IS 'Is this EMU deprecated (no longer used) ?';

SELECT * FROM "ref".tr_emu_emu WHERE geom IS NULL AND NOT emu_wholecountry; -- ES_Mino, DK_Mari

COMMENT ON COLUMN ref.tr_emusplit_ems.gid IS 'Identifier of the unit';
COMMENT ON COLUMN ref.tr_emusplit_ems.emu_nameshort IS 'The short names of EMU, always ';
COMMENT ON COLUMN ref.tr_emusplit_ems.emu_name IS 'The names of EMU';
COMMENT ON COLUMN ref.tr_emusplit_ems.emu_cou_code IS 'The EMU country codes';
COMMENT ON COLUMN ref.tr_emusplit_ems.emu_hyd_syst_s IS ' ';
COMMENT ON COLUMN ref.tr_emusplit_ems.emu_sea IS 'Sea code references tr_sea_sea table';

COMMENT ON COLUMN ref.tr_emusplit_ems.geom IS 'Polygon geometry for the emusplit_ems table, espg 3035';
COMMENT ON COLUMN ref.tr_emusplit_ems.centre IS 'Centre coordinates for emusplit';
ALTER TABLE ref.tr_emusplit drop column x;
ALTER TABLE ref.tr_emusplit drop column y;
ALTER TABLE ref.tr_emusplit drop column sum;
ALTER TABLE ref.tr_emusplit drop column meu_dist_sargasso_km;
ALTER TABLE ref.tr_emusplit DROP COLUMN ref.emu_cty_id;


COMMENT ON COLUMN ref.tr_faoareas.gid IS 'Identifier';
COMMENT ON COLUMN ref.tr_emusplit_ems.fid IS 'Another identified';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_level IS 'Level of the ';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_code IS 'Code of the area';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_status IS 'Status of the area';
COMMENT ON COLUMN ref.tr_emusplit_ems.ocean IS 'Ocean code';
COMMENT ON COLUMN ref.tr_emusplit_ems.subocean IS 'Subocean code';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_area IS 'Code of the sea area';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_subarea IS 'Subarea level';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_division IS 'Subdivision level, this is the code used in t_eelstock_eel';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_subdivis IS 'Subdivision level';
COMMENT ON COLUMN ref.tr_emusplit_ems.f_subunit IS 'Subunit level';
COMMENT ON COLUMN ref.tr_emusplit_ems.surface IS 'Surface area m2';
COMMENT ON COLUMN ref.tr_emusplit_ems.geom IS 'Geometry SRID 4326';

SELECT gid, fid, f_level, f_code, f_status, ocean, subocean, f_area, f_subarea, f_division, f_subdivis, f_subunit, surface
FROM "ref".tr_faoareas;

/*
SELECT st_area(st_transform(geom, 3035)), surface FROM "ref".tr_faoareas WHERE gid = 80;
SELECT st_srid(geom)  FROM "ref".tr_emu_emu
SELECT * FROM "ref".tr_faoareas WHERE gid = 80;
*/

COMMENT ON COLUMN ref.tr_gear_gea.gea_id IS 'Id of the gear';
COMMENT ON COLUMN ref.tr_gear_gea.gea_issscfg_code IS 'Isssfg code of the gear';
COMMENT ON COLUMN ref.tr_gear_gea.gea_name_en IS 'English name of the gear';

COMMENT ON COLUMN ref.tr_habitattype_hty.hty_code IS 'Habitat type code';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_description IS 'Habitat descriptilon';

COMMENT ON COLUMN ref.tr_ices_ecoregions.gid IS 'Id of the ecoregion';
COMMENT ON COLUMN ref.tr_ices_ecoregions.ecoregion IS 'Ecoregion name';
-- I have no idea what this is, comes from the original table, so I'm removing it
ALTER TABLE ref.tr_ices_ecoregions DROP COLUMN shape_leng;
ALTER TABLE ref.tr_ices_ecoregions DROP COLUMN shape_le_1;
ALTER TABLE ref.tr_ices_ecoregions DROP COLUMN shape_area;
-- I have no idea what this is, comes from the original table, so I'm removing it

COMMENT ON COLUMN ref.tr_ices_ecoregions.geom IS 'Geometry ESPG 4326';

COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_code IS 'The code of lifestage';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_name IS 'The name of lifestage';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_definition IS 'Definition of the lifestage';

COMMENT ON COLUMN ref.tr_metrictype_mty.mty_id IS 'Id of metric type';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_name IS 'Name of the metric';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_individual_name IS 'Alternative name for the metric';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_description IS 'Definition of metric type';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_type IS 'Type of metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_method IS 'Method used to obtain metrics, note that for anguillicola prevalence or female proportion, the method has been included as a metric type, so the database requires both the metric and a metric on the method used.';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_metrictype_mty.mty_max IS 'Maximum allowed value';

COMMENT ON COLUMN ref.tr_model_mod.mod_nameshort IS 'A short name for the assessment model used';
COMMENT ON COLUMN ref.tr_model_mod.mod_description IS 'Description of the model';
 
COMMENT ON COLUMN ref.tr_quality_qal.qal_id IS 'Data uality code';
COMMENT ON COLUMN ref.tr_quality_qal.qal_level IS 'Data quality score';
COMMENT ON COLUMN ref.tr_quality_qal.qal_text IS 'Description of the quality of data';
COMMENT ON COLUMN ref.tr_quality_qal.qal_kept IS 'Are the data with this score kept for analysis';

COMMENT ON COLUMN ref.tr_samplingtype_sam.sam_id IS 'Id of sampling type';
COMMENT ON COLUMN ref.tr_samplingtype_sam.sam_samplingtype IS 'Type of sampling commercial catch, commercial CPUE, scientific estimate, ...';


-- I cannot find again where this comes from
-- Is there something in ICES that would cover also the med.
-- Otherwise there is something from the environment agency https://sdi.eea.europa.eu/data/51035cd2-3dea-4b39-94c7-e53946603c2a?path=%2FGPKG

COMMENT ON COLUMN ref.tr_sea_sea.sea_o IS '';
COMMENT ON COLUMN ref.tr_sea_sea.sea_s IS ' ';
COMMENT ON COLUMN ref.tr_sea_sea.sea_code IS ' ';

-- TODO this is not the structure of stations now, 
-- it seems coldes are code, active from (year), active until (year)
-- geom
-- description
-- long description
-- > SO THERE IS NO LONGER ANY ORGANISATION ?
COMMENT ON COLUMN ref.tr_station.tblCodeID IS ' ';
COMMENT ON COLUMN ref.tr_station.Station_Code IS ' ';
COMMENT ON COLUMN ref.tr_station.Organisation IS ' ';
COMMENT ON COLUMN ref.tr_station.Station_Name IS 'The name of station';
COMMENT ON COLUMN ref.tr_station.Lat IS ' ';
COMMENT ON COLUMN ref.tr_station.Lon IS ' ';
COMMENT ON COLUMN ref.tr_station.StartYear IS ' ';
COMMENT ON COLUMN ref.tr_station.EndYear IS ' ';
COMMENT ON COLUMN ref.tr_station.tr_station_pkey IS ' ';

COMMENT ON COLUMN ref.tr_typeseries_typ.typ_id IS ' ';
COMMENT ON COLUMN ref.tr_typeseries_typ.typ_description IS ' ';
COMMENT ON COLUMN ref.tr_typeseries_typ.typ_uni_code IS ' ';
 
#------------datawg ---- table comments
 
COMMENT ON TABLE "datawg".aquaculture IS 'Table of aquaculture';
COMMENT ON TABLE "datawg".b0 IS 'Table of b0 values';
COMMENT ON TABLE "datawg".bbest IS 'Table of bbest values';
COMMENT ON TABLE "datawg".bcurrent IS 'Table of bcurrent values';
COMMENT ON TABLE "datawg".bcurrent_without_stocking IS 'Table of bcurrent without stocking values';
COMMENT ON TABLE "datawg".bigtable IS '';
COMMENT ON TABLE "datawg".bigtable_by_habitat IS 'Table of all habitat types';
COMMENT ON TABLE "datawg".landings IS 'Table of landings';
COMMENT ON TABLE "datawg".log IS 'Table of log during data integration';
COMMENT ON TABLE "datawg".other_landings IS 'Table of other landings';
COMMENT ON TABLE "datawg".participants IS 'List of participants';
COMMENT ON TABLE "datawg".potential_available_habitat IS 'Table of potential available habitats';
COMMENT ON TABLE "datawg".precodata IS ' ';
COMMENT ON TABLE "datawg".precodata_all IS '';
COMMENT ON TABLE "datawg".precodata_country IS '';
COMMENT ON TABLE "datawg".precodata_country_test IS '';
COMMENT ON TABLE "datawg".precodata_emu IS '';
COMMENT ON TABLE "datawg".release IS '';
COMMENT ON TABLE "datawg".series_stats IS '';
COMMENT ON TABLE "datawg".series_summary IS '';
COMMENT ON TABLE "datawg".sigmaa IS '';
COMMENT ON TABLE "datawg".sigmaf IS '';
COMMENT ON TABLE "datawg".precodata_country IS '';
COMMENT ON TABLE "datawg".precodata_country_test IS '';
COMMENT ON TABLE "datawg".precodata_emu IS '';
COMMENT ON TABLE "datawg".release IS '';
COMMENT ON TABLE "datawg".series_stats IS '';
COMMENT ON TABLE "datawg".series_summary IS '';
COMMENT ON TABLE "datawg".sigmaa IS '';
COMMENT ON TABLE "datawg".sigmaf IS '';
COMMENT ON TABLE "datawg".sigmafallcat IS '';
COMMENT ON TABLE "datawg".sigmah IS '';
COMMENT ON TABLE "datawg".silver_eel_equivalents IS '';
COMMENT ON TABLE "datawg".t_biometry_other_bit IS '';
COMMENT ON TABLE "datawg".t_biometry_series_bis IS '';
COMMENT ON TABLE "datawg".t_biometrygroupseries_bio IS '';
COMMENT ON TABLE "datawg".t_dataseries_das IS '';

#---datawg column comments ----


COMMENT ON COLUMN datawg.aquaculture IS 'Table of aquaculture';
COMMENT ON COLUMN datawg.b0 IS 'Table of b0';
COMMENT ON COLUMN datawg.bbest IS 'Table of bbest values';
COMMENT ON COLUMN datawg.bcurrent IS 'Table of bcurrent values';
COMMENT ON COLUMN datawg.bcurrent_without_stocking IS 'Table of bcurrent without stocking values';
COMMENT ON COLUMN datawg.bigtable IS '';
COMMENT ON COLUMN datawg.bigtable_by_habitat IS 'Table of all habitat types';
COMMENT ON COLUMN datawg.landings IS 'Table of landings';
COMMENT ON COLUMN datawg.other_landings IS 'Table of other landings';
COMMENT ON COLUMN datawg.potential_available_habitat IS 'Table of potential available habitats';
COMMENT ON COLUMN datawg.precodata IS ' ';
COMMENT ON COLUMN datawg.precodata_all IS '';
COMMENT ON COLUMN datawg.precodata_country IS '';
COMMENT ON COLUMN datawg.precodata_country_test IS '';
COMMENT ON COLUMN datawg.precodata_emu IS '';
COMMENT ON COLUMN datawg.release IS '';
COMMENT ON COLUMN datawg.series_stats IS '';
COMMENT ON COLUMN datawg.series_summary IS '';
COMMENT ON COLUMN datawg.sigmaa IS '';
COMMENT ON COLUMN datawg.sigmaf IS '';
COMMENT ON COLUMN datawg.precodata_country IS '';
COMMENT ON COLUMN datawg.precodata_country_test IS '';
COMMENT ON COLUMN datawg.precodata_emu IS '';
COMMENT ON COLUMN datawg.release IS '';
COMMENT ON COLUMN datawg.series_stats IS '';
COMMENT ON COLUMN datawg.series_summary IS '';
COMMENT ON COLUMN datawg.sigmaa IS '';
COMMENT ON COLUMN datawg.sigmaf IS '';
COMMENT ON COLUMN datawg.sigmafallcat IS '';
COMMENT ON COLUMN datawg.sigmah IS '';
COMMENT ON COLUMN datawg.sigmahallcat IS ' ';
COMMENT ON COLUMN datawg.silver_eel_equivalents IS ' ';

#---- datawg --- columns of tables....

COMMENT ON COLUMN datawg.t_eelstock_eel.eel_year IS 'Year';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_value IS 'The value in kg';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_emu_nameshort IS 'The short name of EMU';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_cou_code IS 'Country code';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_lfs_code IS 'Lifestage code';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_hty_code IS 'Habitat type code';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_area_division IS 'Eel area division';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_id IS 'Quality code of data';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_comment IS 'Comments on eel quality';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_comment IS 'comment';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_datelastupdate IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_datasource IS 'datasource';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_dta_code IS '';

COMMENT ON COLUMN datawg.log.log_id IS 'internal use, an auto_incremented integer';
COMMENT ON COLUMN datawg.log.log_cou_code IS '';
COMMENT ON COLUMN datawg.log.log_data IS '';
COMMENT ON COLUMN datawg.log.log_evaluation_name IS '';
COMMENT ON COLUMN datawg.log.log_main_assessor IS '';
COMMENT ON COLUMN datawg.log.log_secondary_assessor IS '';
COMMENT ON COLUMN datawg.log.log_contact_person_name IS 'the name of contact person';
COMMENT ON COLUMN datawg.log.log_method IS '';
COMMENT ON COLUMN datawg.log.log_message IS '';
COMMENT ON COLUMN datawg.log.log_date IS '';
COMMENT ON COLUMN datawg.log.log_cou_code IS '';

COMMENT ON COLUMN datawg.participants.name IS 'Name of participant';

COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_id IS 'Internal use, an auto-incremented integer';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_lfs_code IS 'lifestage code';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_year IS 'year during which biological samples where collected';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_length IS 'individual length in mm';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_weight IS 'individual weight in g';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_age IS 'age of individual';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_perc_female IS 'Proportion of female; betwen 0 (all males) and 100 (all females)';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_length_f IS 'length of the female';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_weight_f IS 'weight of the female';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_age_f IS 'age of the female';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_length_m IS 'length of the male';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_weight_m IS 'weight of the male';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_age_m IS 'age of the male';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_comment IS 'comments';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_last_update IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_qal_id IS 'Quality code of data';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_dts_datasource IS 'datasource';
COMMENT ON COLUMN datawg.t_biometry_other_bit.bio_number IS '';

COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_id IS '';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_lfs_code IS 'lifestage code';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_year IS 'year during which biological samples where collected';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_length IS 'individual length in mm';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_weight IS 'individual weight in g';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_age IS 'age of individual';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_perc_female IS 'Proportion of female; betwen 0 (all males) and 100 (all females)';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_length_f IS 'length of the female in mm';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_weight_f IS 'weight of the female in g';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_age_f IS 'age of the female';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_length_m IS 'length of the male in mm';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_weight_m IS 'weight of the male in g';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_age_m IS 'age of the male';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_comment IS 'comments';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_last_update IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_qal_id IS 'Quality code of data';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_dts_datasource IS 'datasource';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bio_number IS '';
COMMENT ON COLUMN datawg.t_biometry_other_bis.bis_ser_id IS '';

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_lfs_code IS 'lifestage code';
COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_last_update IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_qal_id IS 'Quality code of data';
COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_dts_datasource IS 'datasource';

COMMENT ON COLUMN datawg.t_dataseries_das.das_dts_datasource IS 'Datasource generated automatically';
COMMENT ON COLUMN datawg.t_dataseries_das.das_qal_comment IS 'data quality comment';

COMMENT ON COLUMN datawg.t_eelstock_eel.eel_year IS 'year during which biological samples where collected';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_value IS 'The value in kg';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_emu_nameshort IS 'The short name of the EMU';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_cou_code IS 'Country code';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_lfs_code IS 'Lifestage of eel';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_hty_code IS 'Habitat type code';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_area_division IS 'Eel area division';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_id IS 'Quality code of data';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_comment IS 'Quality comment';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_datelastupdate IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_dta_code IS '';

COMMENT ON COLUMN datawg.t_eelstock_eel_percent.percent_id IS ' ';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_f IS 'Percentage of the freshwater habitat taken into account into the estimates';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_t IS 'Percentage of the transitional habitat taken into account into the estimates';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_c IS 'Percentage of the coastal habitat taken into account into the estimates';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_mo IS 'Percentage of the marine open habitat taken into account into the estimates';

COMMENT ON COLUMN datawg.t_fish_fi.fi_id IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_date IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_year IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_comment IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_lastupdate IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_dts_datasource IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_lfs_code IS ' ';
COMMENT ON COLUMN datawg.t_fish_fi.fi_id_cou IS ' ';

COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_id IS 'Identifier of the individual metrics data';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_date IS 'Date of sampling';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_year IS 'The year of data collection';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_lastupdate IS ' ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_dts_datasource IS ' ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_lfs_code IS 'Lifestage code';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_id_cou IS '';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_sai_id IS ' ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_x_4326 IS ' ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_y_4326 IS ' ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_geom IS ' ';

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id IS 'Data ID ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_date IS 'The date of sampling ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_year IS 'The year ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_comment IS 'Comment ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lastupdate IS 'The last aupdated date of the data';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_dts_datasource IS ' ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lfs_code IS ' ';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id_cou IS 'Indentifier used by data provider to identify the fish in its national database';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fiser_ser_id IS ' ';

COMMENT ON COLUMN datawg.t_group_gr.gr_id IS 'Group ID';
COMMENT ON COLUMN datawg.t_group_gr.gr_year IS 'The year';
COMMENT ON COLUMN datawg.t_group_gr.gr_number IS ' ';
COMMENT ON COLUMN datawg.t_group_gr.gr_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_group_gr.gr_lastupdate IS 'The last aupdated date of the data';
COMMENT ON COLUMN datawg.t_group_gr.gr_dts_datasource IS ' ';

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_id IS 'Group ID';
COMMENT ON COLUMN datawg.t_group_gr.gr_year IS 'The year';
COMMENT ON COLUMN datawg.t_group_gr.gr_number IS ' ';
COMMENT ON COLUMN datawg.t_group_gr.gr_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_group_gr.gr_lastupdate IS 'The last aupdated date of the data';
COMMENT ON COLUMN datawg.t_group_gr.gr_dts_datasource IS 'Datasource';
COMMENT ON COLUMN datawg.t_group_gr.grsa_sai_id IS ' ';
COMMENT ON COLUMN datawg.t_group_gr.grsa_lfs_code IS 'Lifestage code';


COMMENT ON COLUMN datawg.t_groupseries_grser.gr_id IS 'Identifier of the group metrics data, this will be filled in automatically in the new_group_metrics and will be used in the updated_group_metrics';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_year IS 'Sampling year';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_number IS 'Number of measured individuals';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_comment IS 'comment';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_lastupdate IS 'The last updated date of data';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_dts_datasource IS 'datasource';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_ser_id Is ' ';

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_id IS '';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_gr_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_mty_id IS '';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_meg_value IS ' ';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_last_update IS ' ';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_qal_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_dts_datasource ' ';


COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_gr_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_mty_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_value IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_last_update IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_qal_id IS ' ';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_dts_datasource IS ' ';

COMMENT ON COLUMN datawg.t_metricind_mei.mei_id IS ' ';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_fi_id IS ' ';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_mty_id IS ' ';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_value IS 'Eel value';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_lastupdate IS ' ';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_qal_id IS ' ';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_dts_datasource IS ' ';

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_fi_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_mty_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_value IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_last_update IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_qal_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_dts_datasource IS ' ';

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_fi_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_mty_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_value IS 'Eel value in kg ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_last_update IS ' ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_qal_id IS ' ';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_dts_datasource IS ' ';

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_id IS' ';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_run_id IS ' ';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_id IS ' ';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_year IS 'The sampling year';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_das_value IS 'Eel value';

COMMENT ON COLUMN datawg.t_modelrun_run.run_id IS ' ';
COMMENT ON COLUMN datawg.t_modelrun_run.run_date IS '';
COMMENT ON COLUMN datawg.t_modelrun_run.run_mod_nameshort IS 'The short name of model';
COMMENT ON COLUMN datawg.t_modelrun_run.run_description IS 'Description of model';

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_id IS '';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_name IS 'Identifier of the sampling scheme';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_cou_code IS 'Country code';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_emu_nameshort IS 'The short names of EMU';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_area_division IS 'FAO code of sea region';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_hty_code IS 'Habitat type';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_samplingstrategy IS 'Indicate sampling scheme';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_protocol IS 'Description of the method used to capture fish and period of sampling';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_qal_id IS 'Sampling scheme quality id, used internally by the working group';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_lastupdate IS 'Automatically generated';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_dts_datasource IS 'Automatically generated';

COMMENT ON COLUMN datawg.t_series_ser.ser_ccm_wso_id IS '';
COMMENT ON COLUMN datawg.t_series_ser.ser_dts_datasource IS ' ';
COMMENT ON COLUMN datawg.t_series_ser.ser_sam_gear IS ' ';

COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_ser_id IS ' ';
COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_year IS 'The year'


