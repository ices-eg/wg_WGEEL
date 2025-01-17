----------ref-----
COMMENT ON TABLE ref.tr_country_cou IS 'Table of ISO 3166 country codes';
COMMENT ON TABLE ref.tr_dataaccess_dta IS 'Table of possible values for data access, public or restricted. Currently all data in wgeel DB are public';
COMMENT ON TABLE ref.tr_emu_emu IS 'Table of eel management units. It most often corresponds to a river basin district (RBD) as defined in the WFD (EU, 2000), when countries have followed recommendation in the regulation. Some countries have kept a more complex system based on regions or autonomies instead of river basins (Spain and Italy). 
For countries outside the EU, EMUs have also been defined, 
either as being the management units used by the country (e.g. Tunisia) or as the whole country.
 In practice, data provision from some EMUs can be divided into further geographical subunits. 
This is, for instance, the case for Sweden where the EMU is national, 
but data can be provided to the WGEEL according to Inland, West and East coasts subunits.
 The catch from coastal areas does include eels migrating from other countries or parts of the Baltic.';
COMMENT ON TABLE ref.tr_emusplit_ems IS 'Table of eel management units with polygons split by sea, for instance in Spain EMUs can be both in Mediterranean and Atlantic,so they are split in this Table. This table is kept for archive';
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
COMMENT ON TABLE ref.tr_sea_sea IS 'Reference table of sea, 
this was taken from the wise layer as ICES seas do not cover the Mediterranean.
 It is consistent with the emu table which was built from the wise layer... spatial analyses such as
 ICES_wgeel_2008 (Hamburg) used this table, though it has been replaced in recruitment scripts
 by the use of ICES divisions';
COMMENT ON TABLE ref.tr_station IS 'Reference table of station based on station dictionary;
(https://vocab.ices.dk/?codetypeguid=dd591b83-fa5c-4ad9-b6f2-6d875d2eb320) the column names
 are not standardized for postgres as the ICES does not follow that format and we wish our data
 to be exported in the ICES dictionary';
-- check if the station table is still OK
COMMENT ON TABLE ref.tr_units_uni IS 'Table of units, see MUnit https://vocab.ices.dk/?codetypeguid=c6aa874e-7477-43e4-af10-547f83b8779f';
 -- TODO check consistency with ICES codes, there are addititional codes related to effort that come from FAO (check)
COMMENT ON TABLE "ref".tr_gear_gea IS 'Table of gears from FAO;
http://www.fao.org/cwp-on-fishery-statistics/handbook/capture-fisheries-statistics/fishing-gear-classification/en/
There is a hierachy that we don''t really need but we can keep the original codes';
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

COMMENT ON COLUMN ref.tr_datasource_dts.dts_datasource IS 
'Source of data, either wgeel_<year> or dc_<year>, the data was either collected directly by wgeel 
or during a datacall';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_description IS 'Description of the source of data';

COMMENT ON COLUMN ref.tr_emu_emu.emu_nameshort IS 'The short names of EMU'; 
COMMENT ON COLUMN ref.tr_emu_emu.emu_name IS 'The name of EMU';
COMMENT ON COLUMN ref.tr_emu_emu.emu_cou_code IS ' The country codes of EMU references tr_country_code';
COMMENT ON COLUMN ref.tr_emu_emu.geom IS 'Geometry, the current projection ESPG 4326, total for countries e.g. `BE_total` does not have geometry';
COMMENT ON COLUMN ref.tr_emu_emu.emu_wholecountry IS 'Does the emu covers the whole country';
COMMENT ON COLUMN ref.tr_emu_emu.geom_buffered IS ' Buffered (10 km) geometry used to check if coordinates of individual fishes fall within the EMU, ESPG 4326';
COMMENT ON COLUMN ref.tr_emu_emu.deprec IS 'Is this EMU deprecated (no longer used) ?';

--SELECT * FROM "ref".tr_emu_emu WHERE geom IS NULL AND NOT emu_wholecountry; -- ES_Mino, DK_Mari





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
--SELECT  * FROM  "ref".tr_sea_sea
COMMENT ON COLUMN ref.tr_sea_sea.sea_o IS 'Name of the sea (large oceanic units)';
COMMENT ON COLUMN ref.tr_sea_sea.sea_s IS 'Name of the sea (smaller units)';
COMMENT ON COLUMN ref.tr_sea_sea.sea_code IS 'Code of the sea (smaller units)';

-- TODO this is not the structure of stations now, 
-- it seems coldes are code, active from (year), active until (year)
-- geom
-- description
-- long description
-- > SO THERE IS NO LONGER ANY ORGANISATION ?
COMMENT ON COLUMN ref.tr_station."tblCodeID" IS 'CodeID of the station';
COMMENT ON COLUMN ref.tr_station."Station_Code" IS 'Code OF the station';
COMMENT ON COLUMN ref.tr_station."Organisation" IS 'Organisation';
COMMENT ON COLUMN ref.tr_station."Station_Name" IS 'The name of station in the wgeel database';
COMMENT ON COLUMN ref.tr_station."Lat" IS 'Latitude (WGS84)';
COMMENT ON COLUMN ref.tr_station."Lon" IS 'Longitude (WGS84';
COMMENT ON COLUMN ref.tr_station."StartYear" IS 'First year';
COMMENT ON COLUMN ref.tr_station."EndYear" IS 'End year (eventually)';

--TODO CHECK IF station has COLUMNS PURPM 
--TODO check if station has column notes

--SELECT * FROM ref.tr_station

--SELECT * FROM ref.tr_typeseries_typ

COMMENT ON COLUMN ref.tr_typeseries_typ.typ_id IS 'Id (integer) indentifying the data type';
COMMENT ON COLUMN ref.tr_typeseries_typ.typ_name IS 'Name of the series type';
COMMENT ON COLUMN ref.tr_typeseries_typ.typ_description IS 'Descritption of the series type';
COMMENT ON COLUMN ref.tr_typeseries_typ.typ_uni_code IS 'Unit code of the series';
 
#------------datawg ---- table comments
 
COMMENT ON VIEW "datawg".aquaculture IS 'View of aquaculture';
COMMENT ON VIEW "datawg".b0 IS 'View of B0 (pristine biomass) values';
COMMENT ON VIEW "datawg".bbest IS 'View of bbest (Bcurrent without mortality at the current recruitment) values';
COMMENT ON VIEW "datawg".bcurrent IS 'View of Bcurrent values';
COMMENT ON VIEW "datawg".bcurrent_without_stocking IS 'View of bcurrent without stocking values';
COMMENT ON VIEW "datawg".bigtable IS 'View of stock indicators';
COMMENT ON VIEW "datawg".bigtable_by_habitat IS 'View of stock indicators (from bigtable) with data summed by years, country, emu, habitats';
COMMENT ON VIEW "datawg".landings IS 'View of landings';
COMMENT ON TABLE "datawg".log IS 'Table of log during data integration';
COMMENT ON VIEW "datawg".other_landings IS 'View of other landings data (pseudo landings during trap and transport to account for the loss at the donor area';
COMMENT ON TABLE "datawg".participants IS 'List of participants';
COMMENT ON VIEW "datawg".potential_available_habitat IS 'View of potential available habitats (DEPRECATED)';
COMMENT ON VIEW "datawg".precodata IS 'This table joins view bbest bcurrent ... selecting data of good quality (1,2 4) or missing data labelled NP ';
COMMENT ON VIEW "datawg".precodata_all IS 'Pull the latest year from precodata either at the emu, the country or all level';

COMMENT ON VIEW "datawg".precodata_country IS 'Latest year from precodata grouped at country level';
COMMENT ON VIEW "datawg".precodata_country_test IS 'No idea what that is';
COMMENT ON VIEW "datawg".precodata_emu IS 'View of precodata per emu, starts from data in bigtable_per_area, then do some corrections before plotting';
COMMENT ON VIEW "datawg".release IS 'View of release data cyrrently eel_typ_id in (8,9,10)';
COMMENT ON VIEW "datawg".series_stats IS 'This view collects min, max year and number of missing values per ser_id (series id) in table datawg.t_dataseries_das';
COMMENT ON VIEW "datawg".series_summary IS 'This view is very similar to series_stats but adds some information about samplingtype (commercial catch, commencial cpue ...)';
COMMENT ON VIEW "datawg".sigmaa IS 'View of sumA data, table from t_eel_stock using eel_typ_id = 17,, only corresponds to t_eelstock_eel.eel_qal_id in (1,2,4) ' ;
COMMENT ON VIEW "datawg".sigmaf IS 'View of sumF data, table from t_eel_stock using eel_typ_id = 18, only corresponds to t_eelstock_eel.eel_qal_id in (1,2,4)';
COMMENT ON VIEW "datawg".sigmafallcat IS 'View of sumF data, table from t_eel_stock using eel_typ_id in (18, 20, 21) (20 corresponds to commercial landings (sumFcom) only and 21 to recreational landings) (sumFrec) and t_eelstock_eel.eel_qal_id in (1,2,4)';
COMMENT ON VIEW "datawg".sigmah IS 'View of sumH data, table from t_eel_stock using eel_typ_id =19 only corresponds to t_eelstock_eel.eel_qal_id in (1,2,4)';
COMMENT ON VIEW "datawg".sigmahallcat IS 'View of sumH data, table from t_eel_stock using eel_typ_id in (19, 22, 23, 24, 25) 19 sumh, 22 sumh hydro, 23 sumh habitat, 24 sumh release, 25 sumh other only corresponds to t_eelstock_eel.eel_qal_id in (1,2,4)';
COMMENT ON VIEW "datawg".silver_eel_equivalents IS 'View of silver eel equivalents, table from t_eel_stock using eel_typ_id in (26,27,28,29,30,31) all see, corresponds to t_eelstock_eel.eel_qal_id in (1,2,4)';

ALTER TABLE "datawg".t_biometry_other_bit rename to t_biometry_other_bit_deprecated;
ALTER TABLE "datawg".t_biometry_series_bis rename to t_biometry_series_bis_deprecated;
COMMENT ON TABLE "datawg".t_biometry_other_bit_deprecated IS 'Deprecated table, replaced by groupmetrics for sampling;';
COMMENT ON TABLE "datawg".t_biometry_series_bis_deprecated IS 'Deprecated table, replaced by groupmetrics for series;';
ALTER TABLE "datawg".t_biometrygroupseries_bio rename to t_biometrygroupseries_bio_deprecated;
COMMENT ON TABLE "datawg".t_biometrygroupseries_bio_deprecated IS 'Deprecated table, replaced by groupmetrics for series;';
COMMENT ON TABLE "datawg".t_dataseries_das IS 'Table of annual abundance data for series in datawg.t_series_ser, these are recruitment or silver eel run data;';


COMMENT ON COLUMN datawg.t_eelstock_eel.eel_year IS 'Year NOT NULL';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_typ_id IS 'type of series FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_value IS 'Value corresponding to type, if NA then there must be a value in eel_missvaluequal';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_emu_nameshort IS 'The short name of EMU references table tr_emu_emu';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_cou_code IS 'Country code references table tr_country_cou';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_lfs_code IS 'Lifestage code references table tr_lifestage_lfs';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_hty_code IS 'Habitat type code references table tr_habitattype_hty';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_area_division IS 'FAO subareas, reference table of division level tr_faoareas';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_id IS 'Quality code of data, see tr_quality_qal';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_qal_comment IS 'Comments on eel quality';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_comment IS 'Comment';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_datelastupdate IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_datasource IS 'Datasource see tr_datasource_dts';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_dta_code IS 'Access to the data, ie public or restricted, currently there is no restricted data in the wgeel database';

COMMENT ON COLUMN datawg.log.log_id IS 'Internal use, an auto_incremented integer';
COMMENT ON COLUMN datawg.log.log_cou_code IS 'Country';
COMMENT ON COLUMN datawg.log.log_data IS 'Dataset analysed, corresponds to an annex type, biomass, catch_landings';
COMMENT ON COLUMN datawg.log.log_evaluation_name IS 'Step in data analysis, check, new data integration';
COMMENT ON COLUMN datawg.log.log_main_assessor IS 'Main assessor, the national correspondent checking the data';
COMMENT ON COLUMN datawg.log.log_secondary_assessor IS 'Secondary assessor, the one who helps.';
COMMENT ON COLUMN datawg.log.log_contact_person_name IS 'The name of contact person, used to be in metadata, now not recorded (2024)';
COMMENT ON COLUMN datawg.log.log_method IS 'Method in metadata, no longer recorded (2024)';
COMMENT ON COLUMN datawg.log.log_message IS 'Message of error reported by the shiny app';
COMMENT ON COLUMN datawg.log.log_date IS 'Date';

COMMENT ON COLUMN datawg.participants.name IS 'Name of participant, stored from shiny integration tool';

COMMENT ON COLUMN datawg.t_dataseries_das.das_dts_datasource IS 'Datasource generated automatically';
COMMENT ON COLUMN datawg.t_dataseries_das.das_qal_comment IS 'Comment on data quality';

COMMENT ON COLUMN datawg.t_eelstock_eel_percent.percent_id IS 'Foreign key, corresponds to eel_id';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_f IS 'Percentage of the freshwater habitat taken into account into the estimates, if numeric must be between -1 (NP) AND 100, otherwise can be NULL';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_t IS 'Percentage of the transitional habitat taken into account into the estimates , if numeric must be between -1 (NP) AND 100, otherwise can be NULL';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_c IS 'Percentage of the coastal habitat taken into account into the estimates, if numeric must be between -1 (NP) AND 100, otherwise can be NULL';
COMMENT ON COLUMN datawg.t_eelstock_eel_percent.perc_mo IS 'Percentage of the marine open habitat taken into account into the estimates, if numeric must be between -1 (NP) AND 100, otherwise can be NULL';

COMMENT ON COLUMN datawg.t_fish_fi.fi_id IS 'Autoincremented integer, primary key of the table';
COMMENT ON COLUMN datawg.t_fish_fi.fi_date IS 'Date of fish collection';
COMMENT ON COLUMN datawg.t_fish_fi.fi_year IS 'Year';
COMMENT ON COLUMN datawg.t_fish_fi.fi_comment IS 'Comment on the fish';
COMMENT ON COLUMN datawg.t_fish_fi.fi_lastupdate IS 'Last change (auto) in the database';
COMMENT ON COLUMN datawg.t_fish_fi.fi_dts_datasource IS 'Data source see tr_datasource_dts';
COMMENT ON COLUMN datawg.t_fish_fi.fi_lfs_code IS 'Code of the lifestage';
COMMENT ON COLUMN datawg.t_fish_fi.fi_id_cou IS 'Code of the fish in the national countrepart database';

COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_id IS 'Identifier, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_date IS 'Date of sampling, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_year IS 'The year of data collection, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_comment IS 'Comment, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_lastupdate IS 'Last change (auto) in the database, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_dts_datasource IS 'Datasource inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_lfs_code IS 'Lifestage code, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fi_id_cou IS 'Identifier used by data provider to identify the fish in its national database, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_sai_id IS 'Sai_id, identifier of the sampling';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_x_4326 IS 'X in espg 4326 (WGS84)';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_y_4326 IS 'Y in espg 4326 (WGS84) ';
COMMENT ON COLUMN datawg.t_fishsamp_fisa.fisa_geom IS 'Point geometry in postgis';

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id IS 'Identifier, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_date IS 'Date of sampling, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_year IS 'The year of data collection, inherited from table t_fish_fi';;
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_comment IS 'Comment, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lastupdate IS 'Last change (auto) in the database, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_dts_datasource IS 'Datasource inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lfs_code IS 'Lifestage code, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id_cou IS 'Identifier used by data provider to identify the fish in its national database, inherited from table t_fish_fi';
COMMENT ON COLUMN datawg.t_fishseries_fiser.fiser_ser_id IS 'Series id';

COMMENT ON COLUMN datawg.t_group_gr.gr_id IS 'Group ID, serial primary key';
COMMENT ON COLUMN datawg.t_group_gr.gr_year IS 'The year';
COMMENT ON COLUMN datawg.t_group_gr.gr_number IS 'Number of fish in the group';
COMMENT ON COLUMN datawg.t_group_gr.gr_comment IS 'Comment on the group metric';
COMMENT ON COLUMN datawg.t_group_gr.gr_lastupdate IS 'Last update, inserted automatically';
COMMENT ON COLUMN datawg.t_group_gr.gr_dts_datasource IS 'Datasource see tr_datasource_dts';

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_id IS 'Group ID, inherited from t_groupsamp_grsa';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_year IS 'The year, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_number IS 'Number of fish in the group, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_comment IS 'Comment, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_lastupdate IS 'The last updated date of the data';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_dts_datasource IS 'Last change (auto) in the database, inherited from tablet_group_gr ';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.grsa_sai_id IS 'Sampling id from t_sampling_sai';
COMMENT ON COLUMN datawg.t_groupsamp_grsa.grsa_lfs_code IS 'Lifestage code';


COMMENT ON COLUMN datawg.t_groupseries_grser.gr_id IS 'Identifier of the group metrics data, this will be filled in automatically in the new_group_metrics and will be used in the updated_group_metrics';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_year IS 'Sampling year, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_number IS 'Number of measured individuals, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_comment IS 'comment, inherited from t_group_gr';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_lastupdate IS 'Last change (auto) in the database, inherited from tablet_group_gr ';
COMMENT ON COLUMN datawg.t_groupseries_grser.gr_dts_datasource IS 'Datasource inherited from t_group_gr see tr_datasource_dts';
COMMENT ON COLUMN datawg.t_groupseries_grser.grser_ser_id Is 'Series id';

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_id IS 'Group metric id';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_gr_id IS 'Id of the group in t_group_gr';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_value IS 'Value of the metric';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_last_update IS 'Last change (auto) in the database';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal';
COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_dts_datasource IS 'Datasource see tr_datasource_dts';


COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_id IS 'Group metric id, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_gr_id IS 'Group id, references tr_group_gr, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_value IS 'Value of the metric, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_last_update IS 'Last change (auto) in the database, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal , inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_dts_datasource IS 'Datasource see tr_datasource_dts , inherited from t_groupseries_grser';

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_id IS 'Group metric id, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_gr_id IS 'Group id, references tr_group_gr, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_value IS 'Value of the metric, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_last_update IS 'Last change (auto) in the database, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal, inherited from t_groupseries_grser';
COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from t_groupseries_grser';


COMMENT ON COLUMN datawg.t_metricind_mei.mei_id IS 'Id of the individual metric';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_fi_id IS 'Fish id of the individual metric, see tr_fish_fi';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_value IS 'Value of the metric';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_last_update IS 'Last change (auto) in the database';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,';
COMMENT ON COLUMN datawg.t_metricind_mei.mei_dts_datasource IS 'Datasource see tr_datasource_dts';

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_id IS 'Id of the individual metric, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_fi_id IS 'Fish id of the individual metric, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_value IS 'Value of the metric, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_last_update IS 'Last change (auto) in the database, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from table t_metricind_mei';

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_id IS 'Id of the individual metric, inherited from table t_metricind_mei';;
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_fi_id IS 'Fish id of the individual metric, inherited from table t_metricind_mei';;
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_value IS 'Value of the metric, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_last_update IS 'Last change (auto) in the database, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,, inherited from table t_metricind_mei';
COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from table t_metricind_mei';

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_id IS 'Id of the data in the table of model data';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_run_id IS 'Id of the model run see t_modelrun_run';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_id IS 'Series Id, see tr_series_ser';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_year IS 'Corresponds to das_year in the db, year of observation';
COMMENT ON COLUMN datawg.t_modeldata_dat.dat_das_value IS 'Value';

COMMENT ON COLUMN datawg.t_modelrun_run.run_id IS 'Id of the model run';
COMMENT ON COLUMN datawg.t_modelrun_run.run_date IS 'Date of the model run';
COMMENT ON COLUMN datawg.t_modelrun_run.run_mod_nameshort IS 'The short name of model';
COMMENT ON COLUMN datawg.t_modelrun_run.run_description IS 'Description of model';

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_id IS 'Identifier of the sampling scheme. If the sampling scheme does
 not already exist, please provide a code starting with emu name and few letters 
and/or an integer (e.g. FR_Adou_biom, FR_Adou_cont), primary key';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_name IS 'Name of the sampling';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_cou_code IS 'Country code';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_emu_nameshort IS
'EMU, see the codes of the emu (emu_nameshort) in table tr_emu_emu';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_area_division IS
'Fao code of sea region (division level) see  tr_fao_area (column division)
(https://github.com/ices-eg/WGEEL/wiki). Do not provide an ICES area for freshwater, 
this is only for habitat  T, C and MO.';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_hty_code IS 
'Habitat type see tr_habitattype_hty  (F=Freshwater, MO=Marine Open,T=transitional, AL=aggregate...)';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_comment IS 
'Comment on sampling scheme';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_samplingstrategy IS 
'Indicate sampling scheme (e.g. commercial fisheries, scientific survey)';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_samplingobjective IS
'Indicate the program the data is coming from (e.g. EU DCF, GFCM etc.)';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_protocol IS
'Description of the method used to capture fish and period of sampling';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_qal_id IS 
'Sampling scheme quality id, used internally by the working group';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_lastupdate IS 'Automatically generated';
COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_dts_datasource IS 'Automatically generated';

COMMENT ON COLUMN datawg.t_series_ser.ser_ccm_wso_id IS 'wso_id (identifier) of the basin in the CCM (Catchment Caracterization DB from the JRC';
COMMENT ON COLUMN datawg.t_series_ser.ser_dts_datasource IS 'Source of data (datacall id)';
COMMENT ON COLUMN datawg.t_series_ser.ser_sam_gear IS 'Sampling gear see tr_gear_gea';
COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_ser_id IS 'Series ID';
COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_year IS 'The year';


-- APPLIED TO DB 24/12/2024