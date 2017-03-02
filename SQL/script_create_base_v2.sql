-------------------------------------
-- script for updating the database
-- created during WKDATAWGEEL Rennes
-- Cedric Briand Laurent Beaulaton
------------------------------------
set search_path to ref, data, public;

create schema ref -- refential to hold dictionnay
create schema data -- this schema will hold the data


-------------------------------------
-- Dictionnary tables
-------------------------------------
--------------------------------------------------
-- Reference table of typeseries names as used by WGEEL
-- (this refererence has been developped and used by WGEEL)
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
-- Reference table of countries, includes the order of the country as diplayed by wgeel
-- If transfered to ICES the country ordre will have to be stored somewhere else and loaded
-- this follows ISO_3166
-- todo fill in the geom for geometry and put appropriate constraints
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

-------------------------------------------------
-- Reference table of station
-- based on station dictionnay (http://ices.dk/marine-data/tools/Pages/Station-dictionary.aspx)
-- the format is not standardized there as the ICES does not follow that format and we wish
-- our data to be exported in the ICES dictionnary
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
-- this was taken from the wise layer as ICES seas do not cover the mediterranean
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
create table ref.tr_quality_qal (
qal_id integer,
qal_level integer,
qal_text text);
ALTER TABLE  ref.tr_quality_qal
  OWNER TO postgres;

-----------------------------------------------------------
-- REFERENCE TABLE FOR EMU
-- this table containt the EMU agregated
-----------------------------------------------------------
DROP TABLE IF EXISTS ref.tr_emu_emu;
CREATE TABLE ref.tr_emu_emu
(
  emu_name_short character varying(7) PRIMARY KEY,
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
  emu_name_short character varying(7),
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
 CONSTRAINT c_fk_emu_sea FOREIGN KEY (emu_sea) REFERENCES ref.tr_sea_sea(sea_code) ON UPDATE CASCADE ON DELETE NO ACTION 
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

 --------------------------------------------------
-- Some of the recruitment series have associated effort
-- Here is the referential table for those
---------------------------------------------------  
DROP TABLE IF EXISTS ref.tr_efforttype_eft;
CREATE TABLE ref.tr_efforttype_eft
(
  eft_id integer NOT NULL,
  eft_name character(40),
  eft_comment text,
  CONSTRAINT tr_efforttype_eft_pkey PRIMARY KEY (eft_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ref.tr_efforttype_eft
  OWNER TO postgres;
--------------------------------------------------
-- Table containing the series
-- this table contains geographical informations and comments on the series
--------------------------------------------------- 
drop table if exists data.t_series_ser;
create table data.t_series_ser (
ser_id serial PRIMARY KEY,  --number internal use
ser_order integer not null, -- order internal use
ser_nameshort character varying(4), --short name of the recuitment series eg Vil for Vilaine
ser_namelong character varying(50), -- long name of the recuitment series
ser_typ_id integer, -- type of series 1= recruitment series
ser_comment text, -- Comment for the series, this is the metadata describing the whole series
ser_unit character varying(12), -- unit of the series kg, ton
ser_lfs_id integer,
ser_habitat_name text,
ser_emu_name_short character varying(7),
ser_cou_code character varying(2),
ser_area_code character varying(2), -- this should be a sequence from ICES
ser_tblcodeid integer,
ser_x numeric,
ser_y numeric,
geom geometry,
CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(geom) = 2),
CONSTRAINT enforce_srid_the_geom CHECK (st_srid(geom) = 3035),
CONSTRAINT c_fk_cou_code FOREIGN KEY (ser_cou_code) REFERENCES ref.tr_country_cou (cou_code)
      ON UPDATE NO ACTION ON DELETE NO ACTION,
CONSTRAINT c_fk_emu_name_short FOREIGN KEY (ser_emu_name_short) REFERENCES ref.tr_emu_emu(emu_name_short) 
ON UPDATE CASCADE ON DELETE NO ACTION,
--CONSTRAINT c_fk_area_code FOREIGN KEY (ser_area_code) REFERENCES ref.tr_area(area_code) ON UPDATE CASCADE ON DELETE NO ACTION,
CONSTRAINT c_fk_tblcodeid FOREIGN KEY (ser_tblcodeid) REFERENCES ref.tr_station("tblCodeID") ON UPDATE CASCADE ON DELETE NO ACTION);

---------------------------------------
-- this table holds the main information
----------------------------------------
DROP TABLE IF EXISTS data.t_data_dat;
CREATE TABLE data.t_data_dat (
  dat_id serial NOT NULL,
  dat_value real,
  dat_ser_id integer NOT NULL, -- foreign key to join t_series_ser
  dat_year integer,
  dat_stage character varying(30),
  dat_comment text,
  dat_effort numeric,
  dat_eft_id integer,
  CONSTRAINT t_data_dat_pkey PRIMARY KEY (dat_id),
  CONSTRAINT c_fk_ser_id FOREIGN KEY (dat_ser_id)
      REFERENCES data.t_series_ser (ser_id)
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_fk_eft_id FOREIGN KEY (dat_eft_id)
      REFERENCES ref.tr_efforttype_eft (eft_id)
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT c_ck_dat_effort CHECK (dat_effort IS NULL AND dat_eft_id IS NULL OR dat_effort IS NOT NULL AND dat_eft_id IS NOT NULL)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE data.t_data_dat
  OWNER TO postgres;

