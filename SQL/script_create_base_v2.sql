-------------------------------------
-- script for updating the database
-- created during WKDATAWGEEL Rennes
-- Cedric Briand Laurent Beaulaton
------------------------------------


create schema ref; -- refential to hold dictionnay
create schema datawg; -- this schema will hold the data
set search_path to ref, datawg, public;

-------------------------------------
-- Dictionnary tables
-------------------------------------
--------------------------------------------------
-- Reference table of typeseries names as used by WGEEL
-- (this reference has been developed and used by WGEEL)
-- we have three type so far, yellow eel standing stock, silver eel escapement series, and glass eel recruitment series
---------------------------------------------------
DROP TABLE IF EXISTS ref.tr_typeseries_typ;
CREATE TABLE ref.tr_typeseries_typ
(
  typ_id serial NOT NULL,
  typ_name character varying(40),
  typ_description text,
  CONSTRAINT typ_pkey PRIMARY KEY (typ_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_typeseries_typ
  OWNER TO postgres;
COMMENT ON TABLE ref.tr_typeseries_typ
  IS 'table containing the type of series (recruitment, yellow eel standing stock, silver eel to be used by ICES-EIFAAC-GFCM wgeel,
  note that recruitment can be made of different life stages';
  -- After some thought, it is better to store the unit of the data with the type
ALTER TABLE ref.tr_typeseries_typ add column typ_uni_code character varying(20);
--------------------------------------------------
-- Reference table of lifestage name for eel 
-- (this refererence has been developped and used by WGEEL)
---------------------------------------------------
DROP TABLE IF EXISTS ref.tr_lifestage_lfs;
CREATE TABLE ref.tr_lifestage_lfs
(
  lfs_code character varying(2) NOT NULL,
  lfs_name character varying(30) NOT NULL,
  lfs_definition text,
  CONSTRAINT pk_lfs PRIMARY KEY (lfs_code),
  CONSTRAINT uk_lfs_name UNIQUE (lfs_name)
);
ALTER TABLE ref.tr_lifestage_lfs
  OWNER TO postgres;


--------------------------------------------------
-- Reference table of units
-- we checked that this follows ICES conventions
---------------------------------------------------
DROP TABLE IF EXISTS ref.tr_units_uni CASCADE;
CREATE TABLE ref.tr_units_uni
(
  uni_code character varying(20) NOT NULL,
  uni_name text NOT NULL,
  CONSTRAINT pk_uni PRIMARY KEY (uni_code),
  CONSTRAINT uk_uni_name UNIQUE (uni_name)
);
ALTER TABLE ref.tr_units_uni
  OWNER TO postgres;
ALTER TABLE ref.tr_typeseries_typ ADD CONSTRAINT c_fk_uni_code FOREIGN KEY (typ_uni_code) REFERENCES ref.tr_units_uni(uni_code) ON UPDATE CASCADE ON DELETE NO ACTION;  

--------------------------------------------------
-- Reference table of countries, includes the order of the country as diplayed by wgeel
-- If transfered to ICES the country ordre will have to be stored somewhere else and loaded
-- this follows ISO_3166

---------------------------------------------------
DROP TABLE IF EXISTS ref.tr_country_cou ;
CREATE TABLE ref.tr_country_cou 
(
  cou_code character varying(2) PRIMARY KEY,
  cou_country text not null,
  cou_order integer not null,
  geom geometry
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ref.tr_country_cou 
  OWNER TO postgres;
  
 -- adding in multipolygons from addy pope, University of Edimburg
 -- which is based on the GADM Version 2 data which is available at http://www.gadm.org/
 -- The geom from Russia has been split and only the Baltic part (Kaliningrad) is now remaining on the map.
 -- Mediterranean countries and some that do have emu have been added to the dataset
 

-------------------------------------------------
-- Reference table of station
-- based on station dictionary (http://ices.dk/marine-data/tools/Pages/Station-dictionary.aspx)
-- the format is not standardized there as the ICES does not follow that format and we wish
-- our data to be exported in the ICES dictionary
--------------------------------------------------- 
DROP TABLE IF EXISTS ref.tr_station;
CREATE TABLE ref.tr_station(
	"tblCodeID" DOUBLE PRECISION PRIMARY KEY,
	"Station_Code" DOUBLE PRECISION,
	"Country" TEXT,
	"Organisation" TEXT,
	"Station_Name" TEXT,
	"WLTYP" TEXT, -- Water and land station types 
	"Lat" DOUBLE PRECISION,
	"Lon" DOUBLE PRECISION,
	"StartYear" DOUBLE PRECISION,
	"EndYear" DOUBLE PRECISION,
	"PURPM" TEXT, -- Purpose of monitoring
	"Notes" TEXT
);

COMMENT ON COLUMN ref.tr_station."Country" IS 'country responsible of the data collection ?';
COMMENT ON COLUMN ref.tr_station."WLTYP" IS 'Water and land station types ';
COMMENT ON COLUMN ref.tr_station."PURPM" IS 'Purpose of monitoring';
	

--------------------------------------------------
-- Reference table of sea
-- this was taken from the wise layer as ICES seas do not cover the Mediterranean
-- It is consistent with the emu table which was built from the wise layer...
-- this is used to later attribute recruitment series to the two series 'Elsewhere Europe' and 'North Sea'
-- or build spatial analyses such as in ICES_wgeel_2008 (Hamburg)
--------------------------------------------------- 
DROP TABLE IF EXISTS  ref.tr_sea_sea;
create table ref.tr_sea_sea (
sea_o character varying(50) not null,
sea_s character varying(50) not null,
sea_code character varying(2),
CONSTRAINT c_pk_sea PRIMARY KEY(sea_code)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ref.tr_sea_sea
  OWNER TO postgres;

--------------------------------------------------
-- Reference table for quality
-- TODO describe this.... and fill in a table appropriate according
-- to ICES standards
---------------------------------------------------
DROP TABLE IF EXISTS  ref.tr_quality_qal;
CREATE TABLE ref.tr_quality_qal (
qal_id integer PRIMARY KEY,
qal_level text,
qal_text text);
ALTER TABLE  ref.tr_quality_qal
  OWNER TO postgres;

-----------------------------------------------------------
-- REFERENCE TABLE FOR EMU
-- this table containt the EMU agregated
-----------------------------------------------------------
DROP TABLE IF EXISTS ref.tr_emu_emu CASCADE;
CREATE TABLE ref.tr_emu_emu
(
  emu_nameshort character varying(20) PRIMARY KEY,
  emu_name character varying(100),
  emu_coun_abrev text,
  geom geometry,
 CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(geom) = 2),
 CONSTRAINT enforce_srid_the_geom CHECK (st_srid(geom) = 3035)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ref.tr_emu_emu
  OWNER TO postgres;



-----------------------------------------------------------
-- ANOTHER TABLE FOR EMU but split into 
-- emu, country,sea (meaning a split between the mediterranean and the atlantic for some EMU for instance,
-- or a split for some EMU if they are transboundary
-- the current projection is the projection used by JRC for CCM (3035)
-------------------------------------------------------------

DROP TABLE IF EXISTS ref.tr_emusplit_ems;
CREATE TABLE ref.tr_emusplit_ems
(
  gid serial NOT NULL,
  emu_nameshort character varying(7),
  emu_name character varying(100),
  emu_coun_abrev text,
  emu_hyd_syst_s character varying(50),
  emu_sea character varying(50),
  sum numeric,
  geom geometry,
  centre geometry,  
  x numeric,
  y numeric,
  emu_cty_id character varying(2),
  meu_dist_sargasso_km numeric,
  CONSTRAINT t_emuagreg_ema_pkey PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(geom) = 3035),
 CONSTRAINT c_fk_emu_sea FOREIGN KEY (emu_sea) REFERENCES ref.tr_sea_sea(sea_code) ON UPDATE CASCADE ON DELETE NO ACTION, 
 CONSTRAINT c_fk_emu_nameshort FOREIGN KEY (emu_nameshort) REFERENCES ref.tr_emu_emu(emu_nameshort) ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_emusplit_ems
  OWNER TO postgres;


DROP INDEX IF EXISTS id_tr_emusplit_ems;

CREATE INDEX id_tr_emusplit_ems
  ON ref.tr_emusplit_ems
  USING gist
  (geom);

-- Index: carto.idxbtree_t_emuagreg_ema

DROP INDEX IF EXISTS idxbtree_t_emusplit_ems;

CREATE INDEX idxbtree_t_emusplit_ems
  ON ref.tr_emusplit_ems
  USING btree
  (gid);

-----------------------------------------------------------
-- REFERENCE TABLE for habitat type
-----------------------------------------------------------
drop table if exists ref.tr_habitattype_hty;
create table ref.tr_habitattype_hty
(
hty_code character varying(2) PRIMARY KEY,
hty_description text
)
WITH (
  OIDS=TRUE
);
ALTER TABLE  ref.tr_habitattype_hty
  OWNER TO postgres;


------------------------------------------------------
-- FAO area come from the shp files
-----------------------------------------------------
DROP TABLE if exists ref.tr_faoareas;
CREATE TABLE ref.tr_faoareas
(
  gid serial NOT NULL,
  fid numeric,
  f_level character varying(254),
  f_code character varying(254),
  f_status numeric,
  ocean character varying(254),
  subocean character varying(254),
  f_area character varying(254),
  f_subarea character varying(254),
  f_division character varying(254),
  f_subdivis character varying(254),
  f_subunit character varying(254),
  surface numeric,
  geom geometry(MultiPolygon,4326),
  CONSTRAINT tr_faoareas_pkey PRIMARY KEY (gid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_faoareas
  OWNER TO postgres;

delete from ref.tr_faoareas where f_level !='DIVISION';--182
--select * from ref.tr_faoareas
alter table ref.tr_faoareas add constraint c_uk_fid unique (fid);
alter table ref.tr_faoareas add constraint c_uk_f_division unique (f_division);
-- Index: ref.tr_faoareas_geom_gist


DROP INDEX IF EXISTS ref.tr_faoareas_geom_gist;
CREATE INDEX tr_faoareas_geom_gist
  ON ref.tr_faoareas
  USING gist
  (geom);


/*
dos script used to create this table (using shp2pgsql and psql):
f:
cd F:\projets\GRISAM\2017\WKDATA\FAO_AREAS
REM -d drops de table, table is in wgs84
shp2pgsql -s 4326 -d -g geom -I FAO_AREAS ref.tr_faoareas> tr_faoareas.sql 
REM IMPORT INTO POSTGRES
psql -U postgres -f "tr_faoareas.sql" wgeel
*/


------------------------------------------------------
-- ICES ecoregion come from the shp files
-----------------------------------------------------
CREATE TABLE ref.tr_ices_ecoregions
(
  gid serial NOT NULL,
  ecoregion character varying(254),
  shape_leng numeric,
  shape_le_1 numeric,
  shape_area numeric,
  geom geometry(MultiPolygon,4326),
  CONSTRAINT tr_ices_ecoregions_pkey PRIMARY KEY (gid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_ices_ecoregions
  OWNER TO postgres;

-- Index: ref.tr_ices_ecoregions_geom_gist

-- DROP INDEX ref.tr_ices_ecoregions_geom_gist;

CREATE INDEX tr_ices_ecoregions_geom_gist
  ON ref.tr_ices_ecoregions
  USING gist
  (geom);


/*
dos script used to create this table (using shp2pgsql and psql):
f:
cd F:\projets\GRISAM\2017\WKDATA\ices_ecoregions
REM -d drops de table, table is in wgs84
shp2pgsql -s 4326 -d -g geom -I ices_ecoregions ref.tr_ices_ecoregions> tr_ices_ecoregions.sql 
REM IMPORT INTO POSTGRES
psql -U postgres -f "tr_ices_ecoregions.sql" wgeel
*/

------------------------------------------------------
-- Sampling type
-----------------------------------------------------
CREATE TABLE ref.tr_samplingtype_sam
(
  sam_id serial NOT NULL,
  sam_samplingtype character varying,
  CONSTRAINT c_pk_sam_samplingtype PRIMARY KEY (sam_id),
  CONSTRAINT c_uk_sam_samplingtype UNIQUE (sam_samplingtype)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_samplingtype_sam
  OWNER TO postgres;

--------------------------------------------------
/* Table containing the series
 this table contains geographical informations and comments on the series
datatypes can be stored with the same table as tr_typeseries_typ but there is a need for additional check constraint
as we don't want to add landings or biomass indicators in the series table
It does not make sense to repeat a unit in this table again and again
*/
------------------------------------------------- 
CREATE TABLE datawg.t_series_ser
(
  ser_id serial NOT NULL, -- serial number internal use, identifier of the series
  ser_order integer NOT NULL, -- order internal, used to display the data from North to South
  ser_nameshort character varying(4), -- short name of the recuitment series eg `Vil` for the Vilaine
  ser_namelong character varying(50), -- long name of the recuitment series eg `Vilaine estuary` for the Vilaine
  ser_typ_id integer, -- type of series 1= recruitment series, FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)
  ser_effort_uni_code character varying(20), -- unit used for effort, it is different from the unit used in the series, for instance some...
  ser_comment text, -- Comment for the series, this should be part of the metadata describing the whole series
  ser_uni_code character varying(20), -- unit of the series kg, ton, kg/boat/day ... FOREIGN KEY to table ref.tr_units_uni(uni_code)
  ser_lfs_code character varying(2), -- lifestage id, FOREIGN KEY to tr_lifestage_lfs, possible values G, Y, S, GY, YS
  ser_hty_code character varying(2), -- habitat FOREIGN KEY to table t_habitattype_hty (F=Freshwater, MO=Marine Open,T=transitional...)
  ser_habitat_name text, -- Description for the river, the habitat where the series is collected eg. IYFS/IBTS sampling in the Skagerrak-Kattegat
  ser_emu_nameshort character varying(20), -- The emu code, FOREIGN KEY to ref.tr_emu_emu
  ser_cou_code character varying(2), -- country code, FOREIGN KEY to ref.tr_country_cou
  ser_area_division character varying(254), -- code of ICES area, FOREIGN KEY to ref.tr_faoareas(f_division)
  ser_tblcodeid integer, -- code of the station, FOREIGN KEY to ref.tr_station
  ser_x numeric, -- x (longitude) EPSG:4326. WGS 84 (Google it)
  ser_y numeric, -- y (latitude) EPSG:4326. WGS 84 (Google it)
  geom geometry, -- internal use, a postgis geometry point in EPSG:3035 (ETRS89 / ETRS-LAEA)
  ser_sam_id integer, -- The sampling type corresponds to trap partial, trap total, ...., FOREIGN KEY to ref.tr_samplingtype_sam
  CONSTRAINT t_series_ser_pkey PRIMARY KEY (ser_id),
  CONSTRAINT c_fk_area_code FOREIGN KEY (ser_area_division)
      REFERENCES ref.tr_faoareas (f_division) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (ser_cou_code)
      REFERENCES ref.tr_country_cou (cou_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT c_fk_emu_name_short FOREIGN KEY (ser_emu_nameshort)
      REFERENCES ref.tr_emu_emu (emu_nameshort) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_hty_code FOREIGN KEY (ser_hty_code)
      REFERENCES ref.tr_habitattype_hty (hty_code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (ser_lfs_code)
      REFERENCES ref.tr_lifestage_lfs (lfs_code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_sam_id FOREIGN KEY (ser_sam_id)
      REFERENCES ref.tr_samplingtype_sam (sam_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT c_fk_ser_effort_uni_code FOREIGN KEY (ser_effort_uni_code)
      REFERENCES ref.tr_units_uni (uni_code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_tblcodeid FOREIGN KEY (ser_tblcodeid)
      REFERENCES ref.tr_station ("tblCodeID") MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (ser_typ_id)
      REFERENCES ref.tr_typeseries_typ (typ_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_uni_code FOREIGN KEY (ser_uni_code)
      REFERENCES ref.tr_units_uni (uni_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT c_ck_ser_typ_id CHECK (ser_typ_id = ANY (ARRAY[1, 2, 3])),
  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(geom) = 3035)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE datawg.t_series_ser
  OWNER TO postgres;
COMMENT ON TABLE datawg.t_series_ser
  IS 'This table contains geographical informations 
and comments on the recruitment, silver eel migration and yellow eel standing stock survey series';
COMMENT ON COLUMN datawg.t_series_ser.ser_id IS 'serial number internal use, identifier of the series';
COMMENT ON COLUMN datawg.t_series_ser.ser_order IS 'order internal, used to display the data from North to South';
COMMENT ON COLUMN datawg.t_series_ser.ser_nameshort IS 'short name of the recuitment series eg `Vil` for the Vilaine';
COMMENT ON COLUMN datawg.t_series_ser.ser_namelong IS 'long name of the recuitment series eg `Vilaine estuary` for the Vilaine';
COMMENT ON COLUMN datawg.t_series_ser.ser_typ_id IS 'type of series 1= recruitment series, FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)';
COMMENT ON COLUMN datawg.t_series_ser.ser_effort_uni_code IS 'unit used for effort, it is different from the unit used in the series, for instance some
 of the Dutch series rely on the number hauls made to collect the glass eel to qualify the series,
 FOREIGN KEY to ref.tr_units_uni ';
COMMENT ON COLUMN datawg.t_series_ser.ser_comment IS 'Comment for the series, this should be part of the metadata describing the whole series';
COMMENT ON COLUMN datawg.t_series_ser.ser_uni_code IS 'unit of the series kg, ton, kg/boat/day ... FOREIGN KEY to table ref.tr_units_uni(uni_code)';
COMMENT ON COLUMN datawg.t_series_ser.ser_lfs_code IS 'lifestage id, FOREIGN KEY to tr_lifestage_lfs, possible values G, Y, S, GY, YS';
COMMENT ON COLUMN datawg.t_series_ser.ser_hty_code IS 'habitat FOREIGN KEY to table t_habitattype_hty (F=Freshwater, MO=Marine Open,T=transitional...)';
COMMENT ON COLUMN datawg.t_series_ser.ser_habitat_name IS 'Description for the river, the habitat where the series is collected eg. IYFS/IBTS sampling in the Skagerrak-Kattegat';
COMMENT ON COLUMN datawg.t_series_ser.ser_emu_nameshort IS 'The emu code, FOREIGN KEY to ref.tr_emu_emu';
COMMENT ON COLUMN datawg.t_series_ser.ser_cou_code IS 'country code, FOREIGN KEY to ref.tr_country_cou';
COMMENT ON COLUMN datawg.t_series_ser.ser_area_division IS 'code of ICES area, FOREIGN KEY to ref.tr_faoareas(f_division)';
COMMENT ON COLUMN datawg.t_series_ser.ser_tblcodeid IS 'code of the station, FOREIGN KEY to ref.tr_station';
COMMENT ON COLUMN datawg.t_series_ser.ser_x IS 'x (longitude) EPSG:4326. WGS 84 (Google it)';
COMMENT ON COLUMN datawg.t_series_ser.ser_y IS 'y (latitude) EPSG:4326. WGS 84 (Google it)';
COMMENT ON COLUMN datawg.t_series_ser.geom IS 'internal use, a postgis geometry point in EPSG:3035 (ETRS89 / ETRS-LAEA)';
COMMENT ON COLUMN datawg.t_series_ser.ser_sam_id IS 'The sampling type corresponds to trap partial, trap total, ...., FOREIGN KEY to ref.tr_samplingtype_sam';

----------------------------------
-- adding a column to check data quality
-----------------------------------
ALTER TABLE  datawg.t_series_ser add column ser_qal_id integer; -- Code to assess the quality of the data, FOREIGN KEY on table ref.tr_quality_qal
COMMENT ON COLUMN datawg.t_series_ser.ser_qal_id IS 'Code to assess the quality of the data, this will allow to discard a whole series from the recruitment analysis FOREIGN KEY on table ref.tr_quality_qal';
ALTER TABLE  datawg.t_series_ser ADD CONSTRAINT c_fk_qal_id FOREIGN KEY (ser_qal_id)
      REFERENCES ref.tr_quality_qal (qal_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE  datawg.t_series_ser add column ser_qal_comment text; 
COMMENT ON COLUMN datawg.t_series_ser.ser_qal_comment IS 'Comment on quality of data, why was the series retained or discarded from later analysis ? ';


---------------------------------------
-- this table holds the main information
----------------------------------------
CREATE TABLE datawg.t_dataseries_das
(
  das_id serial NOT NULL, -- internal use, an auto-incremented integer
  das_value real, -- the value
  das_ser_id integer NOT NULL, -- Foreign key to join t_series_ser (id of the series) internal use
  das_year integer, -- Year for the data
  das_comment text, -- Comment for the particular year
  das_effort numeric, -- Effort value if present (nb of electrofishing, nb of hauls)
  das_last_update date, -- Date of last update inserted automatically with a trigger
  das_qal_id integer, -- Code to assess the quality of the data, FOREIGN KEY on table ref.tr_quality_qal
  CONSTRAINT das_pkey PRIMARY KEY (das_id),
  CONSTRAINT c_fk_qal_id FOREIGN KEY (das_qal_id)
      REFERENCES ref.tr_quality_qal (qal_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT c_fk_ser_id FOREIGN KEY (das_ser_id)
      REFERENCES datawg.t_series_ser (ser_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE datawg.t_dataseries_das
  OWNER TO postgres;


COMMENT ON TABLE datawg.t_dataseries_das IS 'table holding the information on the series, one line per year
	an indication of the effort associated with the series is present for some of the series';
COMMENT ON COLUMN datawg.t_dataseries_das.das_id IS 'Internal use, an auto-incremented integer';
COMMENT ON COLUMN datawg.t_dataseries_das.das_value IS 'The value';
COMMENT ON COLUMN datawg.t_dataseries_das.das_ser_id IS 'Foreign key to join t_series_ser (id of the series) internal use';
COMMENT ON COLUMN datawg.t_dataseries_das.das_year IS 'Year for the data';
COMMENT ON COLUMN datawg.t_dataseries_das.das_comment IS 'Comment for the particular year';
COMMENT ON COLUMN datawg.t_dataseries_das.das_effort IS 'Effort value if present (nb of electrofishing, nb of hauls)';
COMMENT ON COLUMN datawg.t_dataseries_das.das_last_update IS 'Date of last update inserted automatically with a trigger';
COMMENT ON COLUMN datawg.t_dataseries_das.das_qal_id IS 'Code to assess the quality of the data, FOREIGN KEY on table ref.tr_quality_qal';

-- change sept 2017 forgot to integrate a unique constraint (only one data per yer)
ALTER TABLE datawg.t_dataseries_das ADD CONSTRAINT c_uk_year_id check unique(das_year,das_qal_id);

-------------------------------------------------------
-- Catch and stock indicators table
------------------------------------------------------





DROP TABLE IF EXISTS datawg.t_eelstock_eel;
CREATE TABLE datawg.t_eelstock_eel  (
	eel_id serial PRIMARY KEY,
	eel_typ_id integer, -- type of series FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)
	eel_year integer not null,
	eel_value numeric,
	eel_emu_nameshort  character varying(20),
	eel_cou_code character varying(2),
	eel_lfs_code character varying(2), -- lifestage id, FOREIGN KEY to tr_lifestage_lfs, possible values G, Y, S, GY, YS
	eel_hty_code character varying(2), -- habitat FOREIGN KEY to table t_habitattype_hty (F=Freshwater, MO=Marine Open,T=transitional...)
	eel_area_division character varying(254), -- code of ICES area, FOREIGN KEY to ref.tr_faoareas(f_division)
	eel_qal_id integer, -- Code to assess the quality of the data, FOREIGN KEY on table ref.tr_quality_qal
	eel_qal_comment text, -- Comment on the quality of data when processing by the wgeel
	eel_comment text, -- Comment on the data during the data calls
	eel_datelastupdate date,
	CONSTRAINT c_uk_year_lifestage_emu_code UNIQUE (eel_year,eel_lfs_code,eel_emu_nameshort),
	CONSTRAINT c_fk_emu_name_short FOREIGN KEY (eel_emu_nameshort)
	      REFERENCES ref.tr_emu_emu (emu_nameshort) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT c_fk_cou_code FOREIGN KEY (eel_cou_code)
	      REFERENCES ref.tr_country_cou (cou_code) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT c_fk_lfs_code FOREIGN KEY (eel_lfs_code)
	      REFERENCES ref.tr_lifestage_lfs (lfs_code) MATCH SIMPLE
	      ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT c_fk_hty_code FOREIGN KEY (eel_hty_code)
		REFERENCES ref.tr_habitattype_hty (hty_code) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT c_fk_area_code FOREIGN KEY (eel_area_division)
		REFERENCES ref.tr_faoareas (f_division) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT c_fk_qal_id FOREIGN KEY (eel_qal_id)
		REFERENCES ref.tr_quality_qal (qal_id) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT c_fk_typ_id FOREIGN KEY (eel_typ_id)
		REFERENCES ref.tr_typeseries_typ (typ_id) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE NO ACTION);
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_id IS 'Serial code (unique) generated by the database';
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_typ_id IS 'type of series FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)';

/* 
Change july 2017, added an information for missing values
*/

ALTER TABLE datawg.t_eelstock_eel add column eel_missvaluequal character varying(2);
ALTER TABLE datawg.t_eelstock_eel add constraint ck_eel_missvaluequal check (eel_missvaluequal='NP' or eel_missvaluequal='NR' or eel_missvaluequal='NC' or eel_missvaluequal='ND');
ALTER TABLE datawg.t_eelstock_eel add constraint ck_notnull_value_and_missvalue check(eel_missvaluequal IS NULL and eel_value IS NOT NULL OR 
eel_missvaluequal IS NOT NULL and eel_value IS NULL);
COMMENT ON COLUMN datawg.t_eelstock_eel.eel_missvaluequal IS 'NP: Not Pertinent, where the question asked does not apply to the individual case (for example where catch data are absent as there is no fishery or where a habitat type does not exist in an EMU). 
 NR: Not Reported, data or activity exist but numbers are not reported to authorities (for example for commercial confidentiality reasons). NC: Not Collected, activity / habitat exists but data are not collected by authorities (for example where a fishery exists but the catch data are not collected at the relevant level or at all). 
 ND: No Data, where there are insufficient data to estimate a derived parameter (for example where there are insufficient data to estimate the stock indicators (biomass and/or mortality)).'  

-- unique constraint should also be per type;
-- I have to add a check constraint on qal, this will allow to remove doubles
ALTER TABLE datawg.t_eelstock_eel drop constraint c_uk_year_lifestage_emu_code;
ALTER TABLE datawg.t_eelstock_eel drop constraint c_uk_eelstock;
ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT c_uk_eelstock UNIQUE (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_hty_code,eel_qal_id);

-- change 2018, this constraint will to be triggered when there are NULL values in eel_hty_code
alter table datawg.t_eelstock_eel ALTER COLUMN eel_qal_id SET NOT NULL;
alter table datawg.t_eelstock_eel ALTER COLUMN eel_emu_nameshort SET NOT NULL;
alter table datawg.t_eelstock_eel ALTER COLUMN eel_lfs_code SET NOT NULL;
alter table datawg.t_eelstock_eel ALTER COLUMN eel_typ_id SET NOT NULL;
select * from datawg.t_eelstock_eel where eel_lfs_code is null;
ALTER TABLE datawg.t_eelstock_eel drop constraint c_uk_eelstock;
-- NULL values will lead to ignore the constraint, this is the solution (values for eel_hty_id and eel_area_division can be null)
-- four cases must be considered
CREATE UNIQUE INDEX idx_eelstock_1 on datawg.t_eelstock_eel (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_hty_code,eel_qal_id,eel_area_division)
where eel_hty_code is not null and eel_area_division is not null;
CREATE UNIQUE INDEX idx_eelstock_2 on datawg.t_eelstock_eel (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_qal_id,eel_area_division)
where eel_hty_code is null and eel_area_division is not null;
CREATE UNIQUE INDEX idx_eelstock_3 on datawg.t_eelstock_eel (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_hty_code,eel_qal_id)
where eel_hty_code is not null and eel_area_division is null;
CREATE UNIQUE INDEX idx_eelstock_4 on datawg.t_eelstock_eel (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_qal_id)
where eel_hty_code is null and eel_area_division is null;

-- adding a new column for the eel_stock to trace the source of data
ALTER TABLE datawg.t_eelstock_eel ADD COLUMN eel_datasource character varying(100);


CREATE TABLE datawg.tr_datasource_dts (
dts_datasource character varying(100),
dts_description text
);
Comment on table datawg.tr_datasource_dts is 'source of data';

insert into datawg.tr_datasource_dts values ('wgeel_2016','');
insert into datawg.tr_datasource_dts values ('dc_2017');
insert into datawg.tr_datasource_dts values ('wgeel_2017');


-- unique constraint should also be per ICES sqare
-- I have to add a check constraint on qal, this will allow to remove doubles

ALTER TABLE datawg.t_eelstock_eel drop constraint c_uk_eelstock;
ALTER TABLE datawg.t_eelstock_eel ADD CONSTRAINT c_uk_eelstock UNIQUE (eel_year,eel_lfs_code,eel_emu_nameshort,eel_typ_id,eel_hty_code,eel_area_division,eel_qal_id);