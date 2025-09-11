--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.0

-- Started on 2025-02-03 11:14:03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 43 (class 2615 OID 2552915)
-- Name: datawg; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA datawg;


ALTER SCHEMA datawg OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 2552916)
-- Name: ref; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ref;


ALTER SCHEMA ref OWNER TO postgres;

--
-- TOC entry 34 (class 2615 OID 7185242)
-- Name: tempo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tempo;


ALTER SCHEMA tempo OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 2552917)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- TOC entry 35 (class 2615 OID 2552918)
-- Name: wkeelmigration; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA wkeelmigration;


ALTER SCHEMA wkeelmigration OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 2552919)
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- TOC entry 3 (class 3079 OID 2552926)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 4 (class 3079 OID 2552937)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 5 (class 3079 OID 2553968)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- TOC entry 1205 (class 1255 OID 2554128)
-- Name: check_no_ices_area(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.check_no_ices_area() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   

 	DECLARE nbareadivisionF INTEGER ;

 	BEGIN
 	 	-- no wrong stages for landings biomass and mortalities
 	 	SELECT COUNT(*) INTO nbareadivisionF
 	 	FROM   datawg.t_eelstock_eel
 	 	WHERE  NEW.eel_area_division is not null
 	 	AND  NEW.eel_hty_code = 'F'
 	 	;

		
 	 	IF (nbareadivisionF > 0) THEN
 	 	 	RAISE EXCEPTION 'eel_area_division should be NULL in Freshwater' ;
 	 	END IF  ;

		RETURN NEW ;
 	END  ;
$$;


ALTER FUNCTION datawg.check_no_ices_area() OWNER TO postgres;

--
-- TOC entry 1219 (class 1255 OID 6989819)
-- Name: check_notnull_qal_id(); Type: FUNCTION; Schema: datawg; Owner: postgres
--
DROP FUNCTION IF EXISTS datawg.check_notnull_qal_id() ;
CREATE FUNCTION datawg.check_notnull_qal_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
BEGIN
IF NEW.eel_qal_id IS NULL THEN 
      RAISE EXCEPTION 'qal_id should not be null on insertion, row year -->%, emu -->%,lfs_code -->%',NEW.eel_year,NEW.eel_emu_nameshort,NEW.eel_lfs_code 
    USING HINT = 'Please check your table for missing qal_id';
END IF  ;
RETURN NEW ;
END  ;
$$;


ALTER FUNCTION datawg.check_notnull_qal_id() OWNER TO postgres;

--
-- TOC entry 1183 (class 1255 OID 2554129)
-- Name: check_the_stage(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.check_the_stage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   

 	DECLARE nbwrongstages INTEGER ;

 	BEGIN
 	 	-- no wrong stages for landings biomass and mortalities
 	 	SELECT COUNT(*) INTO nbwrongstages
 	 	FROM   datawg.t_eelstock_eel
 	 	WHERE  NEW.eel_lfs_code in ('GY','OG','QG')
 	 	AND NEW.eel_typ_id in (4,5,6,7,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31) 	
 	 	;

		
 	 	IF (nbwrongstages > 0) THEN
 	 	 	RAISE EXCEPTION 'Stage GY, OG or QG not authorized for this type' ;
 	 	END IF  ;

		RETURN NEW ;
 	END  ;
$$;


ALTER FUNCTION datawg.check_the_stage() OWNER TO postgres;

--
-- TOC entry 1221 (class 1255 OID 2554130)
-- Name: checkemu_whole_country(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.checkemu_whole_country() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
DECLARE nberror INTEGER ;
BEGIN
SELECT COUNT(*) INTO nberror 
FROM ref.tr_emu_emu
where tr_emu_emu.emu_nameshort = NEW.eel_emu_nameshort
and NEW.eel_qal_id =1 AND 
NEW.eel_typ_id = 11 AND NOT emu_wholecountry ;
IF (nberror > 0) THEN
      RAISE EXCEPTION 'Aquaculture must be applied to an emu where emu_wholecountry = TRUE' ;
END IF  ;
RETURN NEW ;
END  ;
$$;


ALTER FUNCTION datawg.checkemu_whole_country() OWNER TO postgres;

--
-- TOC entry 1206 (class 1255 OID 2554131)
-- Name: checkemu_whole_country(text); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.checkemu_whole_country(emu text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
declare
exist boolean;
begin
 exist:=false;
 perform * from ref.tr_emu_emu where emu_nameshort=emu and emu_wholecountry=true;
 exist:=FOUND;
 RETURN exist;
end
$$;


ALTER FUNCTION datawg.checkemu_whole_country(emu text) OWNER TO postgres;

--
-- TOC entry 1207 (class 1255 OID 2554132)
-- Name: fi_lastupdate(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.fi_lastupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fi_lastupdate = now()::date;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION datawg.fi_lastupdate() OWNER TO postgres;

--
-- TOC entry 1208 (class 1255 OID 2554133)
-- Name: fi_year(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.fi_year() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
 
  BEGIN
   
    IF NOT (NEW.fi_year in (EXTRACT(YEAR FROM NEW.fi_date), EXTRACT(YEAR FROM NEW.fi_date)-1, EXTRACT(YEAR FROM NEW.fi_date)+1)) THEN
      RAISE EXCEPTION 'table t_fisheries_fiser, column fi_year % does not match the date of fish collection % (table t_fish_fi)', NEW.fi_year,NEW.fi_date ;
    END IF  ;

    RETURN NEW ;
  END  ;
$$;


ALTER FUNCTION datawg.fi_year() OWNER TO postgres;

--
-- TOC entry 1220 (class 1255 OID 2554134)
-- Name: fish_in_emu(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.fish_in_emu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
  DECLARE inpolygon bool;
  DECLARE fish integer;
  BEGIN
  if (new.fisa_y_4326 is null and new.fisa_x_4326 is null) then
  	return new;
  end if;

  SELECT INTO
  inpolygon coalesce(st_contains(geom_buffered, st_setsrid(st_point(new.fisa_x_4326,new.fisa_y_4326),4326)), true) FROM
  datawg.t_samplinginfo_sai
  JOIN REF.tr_emu_emu ON emu_nameshort=sai_emu_nameshort where new.fisa_sai_id = sai_id;
  IF (inpolygon = false) THEN
    RAISE EXCEPTION 'the fish % - % coordinates do not fall into the corresponding emu (% - %)', new.fi_id, new.fi_id_cou, new.fisa_x_4326, new.fisa_y_4326 ;
    END IF  ;

    RETURN NEW ;
  END  ;
$$;


ALTER FUNCTION datawg.fish_in_emu() OWNER TO postgres;

--
-- TOC entry 1209 (class 1255 OID 2554135)
-- Name: gr_lastupdate(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.gr_lastupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.gr_lastupdate = now()::date;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION datawg.gr_lastupdate() OWNER TO postgres;

--
-- TOC entry 1210 (class 1255 OID 2554136)
-- Name: meg_last_update(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.meg_last_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.meg_last_update = now()::date;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION datawg.meg_last_update() OWNER TO postgres;

--
-- TOC entry 1211 (class 1255 OID 2554137)
-- Name: meg_mty_is_group(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.meg_mty_is_group() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name   
  mty_type, mty_name FROM REF.tr_metrictype_mty where mty_id=NEW.meg_mty_id;

    IF (the_mty_type = 'individual') THEN
    RAISE EXCEPTION 'table t_metricgroup_meg, metric --> % is not a group metric', the_mty_name ;
    END IF  ;

    RETURN NEW ;
  END  ;
$$;


ALTER FUNCTION datawg.meg_mty_is_group() OWNER TO postgres;

--
-- TOC entry 1212 (class 1255 OID 2554138)
-- Name: mei_last_update(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.mei_last_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.mei_last_update = now()::date;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION datawg.mei_last_update() OWNER TO postgres;

--
-- TOC entry 1222 (class 1255 OID 2554139)
-- Name: mei_mty_is_individual(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.mei_mty_is_individual() RETURNS trigger
    LANGUAGE plpgsql
    AS $$   
  DECLARE the_mty_type TEXT;
          the_mty_name TEXT;
          the_mty_unit text;
 
  BEGIN
   
  SELECT INTO
  the_mty_type , the_mty_name, the_mty_unit 
  mty_type, mty_name,mty_uni_code FROM REF.tr_metrictype_mty where mty_id=NEW.mei_mty_id;

    IF (the_mty_type = 'group') THEN
    RAISE EXCEPTION 'table t_metricind_mei, metric --> % is not an individual metric', the_mty_name ;
    END IF  ;
    if (the_mty_unit = 'wo' and new.mei_value not in (0,1)) then
	raise exception 'metric % should have only 0 or 1 for individuals', the_mty_name;
    end if;
    RETURN NEW ;
  END  ;
$$;


ALTER FUNCTION datawg.mei_mty_is_individual() OWNER TO postgres;

--
-- TOC entry 1213 (class 1255 OID 2554140)
-- Name: sai_lastupdate(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.sai_lastupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.sai_lastupdate = now()::date;
    RETURN NEW; 
END;
$$;


ALTER FUNCTION datawg.sai_lastupdate() OWNER TO postgres;

--
-- TOC entry 1214 (class 1255 OID 2554141)
-- Name: update_bio_last_update(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.update_bio_last_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.bio_last_update = now()::date;
    RETURN NEW;	
END;
$$;


ALTER FUNCTION datawg.update_bio_last_update() OWNER TO postgres;

--
-- TOC entry 1215 (class 1255 OID 2554142)
-- Name: update_coordinates(); Type: FUNCTION; Schema: datawg; Owner: wgeel
--

CREATE FUNCTION datawg.update_coordinates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.ser_x = st_x(NEW.geom);
NEW.ser_y = st_y(NEW.geom);
RETURN NEW;
END;
$$;


ALTER FUNCTION datawg.update_coordinates() OWNER TO wgeel;

--
-- TOC entry 1216 (class 1255 OID 2554143)
-- Name: update_das_last_update(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.update_das_last_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.das_last_update = now()::date;
    RETURN NEW;	
END;
$$;


ALTER FUNCTION datawg.update_das_last_update() OWNER TO postgres;

--
-- TOC entry 1217 (class 1255 OID 2554144)
-- Name: update_eel_last_update(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.update_eel_last_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.eel_datelastupdate = now()::date;
    RETURN NEW;	
END;
$$;


ALTER FUNCTION datawg.update_eel_last_update() OWNER TO postgres;

--
-- TOC entry 1218 (class 1255 OID 2554145)
-- Name: update_geom(); Type: FUNCTION; Schema: datawg; Owner: postgres
--

CREATE FUNCTION datawg.update_geom() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.geom = ST_GeomFromText('POINT('||NEW.ser_x||' '||NEW.ser_y||')',4326);
    RETURN NEW;	
END;
$$;


ALTER FUNCTION datawg.update_geom() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 264 (class 1259 OID 2554146)
-- Name: t_eelstock_eel; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_eelstock_eel (
    eel_id integer NOT NULL,
    eel_typ_id integer NOT NULL,
    eel_year integer NOT NULL,
    eel_value numeric,
    eel_emu_nameshort character varying(20) NOT NULL,
    eel_cou_code character varying(2),
    eel_lfs_code character varying(2) NOT NULL,
    eel_hty_code character varying(2),
    eel_area_division character varying(254),
    eel_qal_id integer NOT NULL,
    eel_qal_comment text,
    eel_comment text,
    eel_datelastupdate date,
    eel_missvaluequal character varying(2),
    eel_datasource character varying(100),
    eel_dta_code text DEFAULT 'Public'::text,
    CONSTRAINT ck_eel_missvaluequal CHECK ((((eel_missvaluequal)::text = 'NP'::text) OR ((eel_missvaluequal)::text = 'NR'::text) OR ((eel_missvaluequal)::text = 'NC'::text) OR ((eel_missvaluequal)::text = 'ND'::text))),
    CONSTRAINT ck_notnull_value_and_missvalue CHECK ((((eel_missvaluequal IS NULL) AND (eel_value IS NOT NULL)) OR ((eel_missvaluequal IS NOT NULL) AND (eel_value IS NULL)))),
    CONSTRAINT ck_qal_id_and_missvalue CHECK (((eel_missvaluequal IS NULL) OR (eel_qal_id <> 0))),
    CONSTRAINT ck_removed_typid CHECK (((COALESCE(eel_qal_id, 1) > 5) OR (eel_typ_id <> ALL (ARRAY[12, 7, 5]))))
);


ALTER TABLE datawg.t_eelstock_eel OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN t_eelstock_eel.eel_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_eelstock_eel.eel_id IS 'Serial code (unique) generated by the database';


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN t_eelstock_eel.eel_typ_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_eelstock_eel.eel_typ_id IS 'type of series FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)';


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN t_eelstock_eel.eel_missvaluequal; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_eelstock_eel.eel_missvaluequal IS 'NP: Not Pertinent, where the question asked does not apply to the individual case (for example where catch data are absent as there is no fishery or where a habitat type does not exist in an EMU). 
 NR: Not Reported, data or activity exist but numbers are not reported to authorities (for example for commercial confidentiality reasons). NC: Not Collected, activity / habitat exists but data are not collected by authorities (for example where a fishery exists but the catch data are not collected at the relevant level or at all). 
 ND: No Data, where there are insufficient data to estimate a derived parameter (for example where there are insufficient data to estimate the stock indicators (biomass and/or mortality)).';


--
-- TOC entry 265 (class 1259 OID 2554156)
-- Name: tr_country_cou; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_country_cou (
    cou_code character varying(2) NOT NULL,
    cou_country text NOT NULL,
    cou_order integer NOT NULL,
    geom public.geometry,
    cou_iso3code character varying(3)
);


ALTER TABLE ref.tr_country_cou OWNER TO postgres;

--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 265
-- Name: COLUMN tr_country_cou.cou_iso3code; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_country_cou.cou_iso3code IS 'ISO3 three letter code';


--
-- TOC entry 266 (class 1259 OID 2554161)
-- Name: tr_emu_emu; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_emu_emu (
    emu_nameshort character varying(20) NOT NULL,
    emu_name character varying(100),
    emu_cou_code text NOT NULL,
    geom public.geometry,
    emu_wholecountry boolean,
    geom_buffered public.geometry,
    deprec boolean DEFAULT false,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(geom) = 4326))
);


ALTER TABLE ref.tr_emu_emu OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 2554168)
-- Name: tr_habitattype_hty; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_habitattype_hty (
    hty_code character varying(2) NOT NULL,
    hty_description text
);


ALTER TABLE ref.tr_habitattype_hty OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 2554173)
-- Name: tr_lifestage_lfs; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_lifestage_lfs (
    lfs_code character varying(2) NOT NULL,
    lfs_name character varying(30) NOT NULL,
    lfs_definition text
);


ALTER TABLE ref.tr_lifestage_lfs OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 2554178)
-- Name: tr_quality_qal; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_quality_qal (
    qal_id integer NOT NULL,
    qal_level text,
    qal_text text,
    qal_kept boolean
);


ALTER TABLE ref.tr_quality_qal OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 2554183)
-- Name: tr_typeseries_typ; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_typeseries_typ (
    typ_id integer NOT NULL,
    typ_name character varying(40),
    typ_description text,
    typ_uni_code character varying(20)
);


ALTER TABLE ref.tr_typeseries_typ OWNER TO postgres;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE tr_typeseries_typ; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON TABLE ref.tr_typeseries_typ IS 'table containing the type of series (recruitment, yellow eel standing stock, silver eel to be used by ICES-EIFAAC-GFCM wgeel,
  note that recruitment can be made of different life stages';


--
-- TOC entry 271 (class 1259 OID 2554188)
-- Name: aquaculture; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.aquaculture AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE (((t_eelstock_eel.eel_typ_id = 11) OR (t_eelstock_eel.eel_typ_id = 12)) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.aquaculture OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 2554193)
-- Name: t_eelstock_eel_percent; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_eelstock_eel_percent (
    percent_id integer NOT NULL,
    perc_f numeric,
    perc_t numeric,
    perc_c numeric,
    perc_mo numeric,
    CONSTRAINT t_eelstock_eel_percent_check CHECK ((((perc_mo >= ('-1'::integer)::numeric) AND (perc_mo <= (100)::numeric)) OR (perc_mo IS NULL))),
    CONSTRAINT t_eelstock_eel_percent_perc_c_check CHECK ((((perc_c >= ('-1'::integer)::numeric) AND (perc_c <= (100)::numeric)) OR (perc_c IS NULL))),
    CONSTRAINT t_eelstock_eel_percent_perc_f_check CHECK ((((perc_f >= ('-1'::integer)::numeric) AND (perc_f <= (100)::numeric)) OR (perc_f IS NULL))),
    CONSTRAINT t_eelstock_eel_percent_perc_t_check CHECK ((((perc_t >= ('-1'::integer)::numeric) AND (perc_t <= (100)::numeric)) OR (perc_t IS NULL)))
);


ALTER TABLE datawg.t_eelstock_eel_percent OWNER TO wgeel;

--
-- TOC entry 273 (class 1259 OID 2554202)
-- Name: b0; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.b0 AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 13) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.b0 OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 2554207)
-- Name: bbest; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.bbest AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 14) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.bbest OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 2554212)
-- Name: bcurrent; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.bcurrent AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 15) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.bcurrent OWNER TO postgres;

--
-- TOC entry 361 (class 1259 OID 7735556)
-- Name: bcurrent_without_stocking; Type: VIEW; Schema: datawg; Owner: wgeel
--

CREATE VIEW datawg.bcurrent_without_stocking AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 34) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.bcurrent_without_stocking OWNER TO wgeel;

--
-- TOC entry 276 (class 1259 OID 2554217)
-- Name: potential_available_habitat; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.potential_available_habitat AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = 16) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.potential_available_habitat OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 2554222)
-- Name: sigmaa; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.sigmaa AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 17) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.sigmaa OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 2554227)
-- Name: sigmaf; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.sigmaf AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 18) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.sigmaf OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 2554232)
-- Name: sigmah; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.sigmah AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
    t_eelstock_eel.eel_datasource,
    t_eelstock_eel_percent.perc_f AS biom_perc_f,
    t_eelstock_eel_percent.perc_t AS biom_perc_t,
    t_eelstock_eel_percent.perc_c AS biom_perc_c,
    t_eelstock_eel_percent.perc_mo AS biom_perc_mo
   FROM (((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
     LEFT JOIN datawg.t_eelstock_eel_percent ON ((t_eelstock_eel_percent.percent_id = t_eelstock_eel.eel_id)))
  WHERE ((t_eelstock_eel.eel_typ_id = 19) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.sigmah OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 2554237)
-- Name: bigtable; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.bigtable AS
 WITH b0 AS (
         SELECT b0_1.eel_cou_code,
            b0_1.eel_emu_nameshort,
            b0_1.eel_hty_code,
            b0_1.eel_year,
            b0_1.eel_lfs_code,
            round(sum(b0_1.eel_value)) AS b0
           FROM datawg.b0 b0_1
          GROUP BY b0_1.eel_cou_code, b0_1.eel_emu_nameshort, b0_1.eel_hty_code, b0_1.eel_year, b0_1.eel_lfs_code
        ), bbest AS (
         SELECT bbest_1.eel_cou_code,
            bbest_1.eel_emu_nameshort,
            bbest_1.eel_hty_code,
            bbest_1.eel_year,
            bbest_1.eel_lfs_code,
            round(sum(bbest_1.eel_value)) AS bbest
           FROM datawg.bbest bbest_1
          GROUP BY bbest_1.eel_cou_code, bbest_1.eel_emu_nameshort, bbest_1.eel_hty_code, bbest_1.eel_year, bbest_1.eel_lfs_code
        ), bcurrent AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            round(sum(bcurrent_1.eel_value)) AS bcurrent
           FROM datawg.bcurrent bcurrent_1
          GROUP BY bcurrent_1.eel_cou_code, bcurrent_1.eel_emu_nameshort, bcurrent_1.eel_hty_code, bcurrent_1.eel_year, bcurrent_1.eel_lfs_code
        ), bcurrent_without_stocking AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            round(sum(bcurrent_1.eel_value)) AS bcurrent_without_stocking
           FROM datawg.bcurrent_without_stocking bcurrent_1
          GROUP BY bcurrent_1.eel_cou_code, bcurrent_1.eel_emu_nameshort, bcurrent_1.eel_hty_code, bcurrent_1.eel_year, bcurrent_1.eel_lfs_code
        ), suma AS (
         SELECT sigmaa.eel_cou_code,
            sigmaa.eel_emu_nameshort,
            sigmaa.eel_hty_code,
            sigmaa.eel_year,
            sigmaa.eel_lfs_code,
            round(
                CASE
                    WHEN ((sigmaa.eel_missvaluequal)::text = 'NP'::text) THEN (0)::numeric
                    ELSE sigmaa.eel_value
                END, 3) AS suma
           FROM datawg.sigmaa
        ), sumf AS (
         SELECT sigmaf.eel_cou_code,
            sigmaf.eel_emu_nameshort,
            sigmaf.eel_hty_code,
            sigmaf.eel_year,
            sigmaf.eel_lfs_code,
            round(
                CASE
                    WHEN ((sigmaf.eel_missvaluequal)::text = 'NP'::text) THEN (0)::numeric
                    ELSE sigmaf.eel_value
                END, 3) AS sumf
           FROM datawg.sigmaf
        ), sumh AS (
         SELECT sigmah.eel_cou_code,
            sigmah.eel_emu_nameshort,
            sigmah.eel_hty_code,
            sigmah.eel_year,
            sigmah.eel_lfs_code,
            round(
                CASE
                    WHEN ((sigmah.eel_missvaluequal)::text = 'NP'::text) THEN (0)::numeric
                    ELSE sigmah.eel_value
                END, 3) AS sumh
           FROM datawg.sigmah
        ), habitat_ha AS (
         SELECT potential_available_habitat.eel_cou_code,
            potential_available_habitat.eel_emu_nameshort,
            potential_available_habitat.eel_hty_code,
            potential_available_habitat.eel_year,
            potential_available_habitat.eel_lfs_code,
            round(potential_available_habitat.eel_value, 3) AS habitat_ha
           FROM datawg.potential_available_habitat
        ), countries AS (
         SELECT tr_country_cou.cou_code,
            tr_country_cou.cou_country AS country,
            tr_country_cou.cou_order
           FROM ref.tr_country_cou
        ), emu AS (
         SELECT tr_emu_emu.emu_nameshort,
            tr_emu_emu.emu_wholecountry
           FROM ref.tr_emu_emu
        ), habitat AS (
         SELECT tr_habitattype_hty.hty_code,
            tr_habitattype_hty.hty_description AS habitat
           FROM ref.tr_habitattype_hty
        ), life_stage AS (
         SELECT tr_lifestage_lfs.lfs_code,
            tr_lifestage_lfs.lfs_name AS life_stage
           FROM ref.tr_lifestage_lfs
        )
 SELECT eel_year,
    eel_cou_code,
    countries.country,
    countries.cou_order,
    eel_emu_nameshort,
    emu.emu_wholecountry,
    eel_hty_code,
    habitat.habitat,
    eel_lfs_code,
    life_stage.life_stage,
    b0.b0,
    bbest.bbest,
    bcurrent.bcurrent,
    suma.suma,
    sumf.sumf,
    sumh.sumh,
    habitat_ha.habitat_ha,
    bcurrent_without_stocking.bcurrent_without_stocking
   FROM (((((((((((b0
     FULL JOIN bbest USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN bcurrent_without_stocking USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN bcurrent USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN suma USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN sumf USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN sumh USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN habitat_ha USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code))
     FULL JOIN countries ON (((eel_cou_code)::text = (countries.cou_code)::text)))
     JOIN emu ON (((eel_emu_nameshort)::text = (emu.emu_nameshort)::text)))
     JOIN habitat ON (((eel_hty_code)::text = (habitat.hty_code)::text)))
     JOIN life_stage ON (((eel_lfs_code)::text = (life_stage.lfs_code)::text)))
  ORDER BY eel_year, countries.cou_order, eel_emu_nameshort,
        CASE
            WHEN ((eel_hty_code)::text = 'F'::text) THEN 1
            WHEN ((eel_hty_code)::text = 'T'::text) THEN 2
            WHEN ((eel_hty_code)::text = 'C'::text) THEN 3
            WHEN ((eel_hty_code)::text = 'MO'::text) THEN 4
            WHEN ((eel_hty_code)::text = 'AL'::text) THEN 5
            ELSE NULL::integer
        END,
        CASE
            WHEN ((eel_lfs_code)::text = 'G'::text) THEN 1
            WHEN ((eel_lfs_code)::text = 'QG'::text) THEN 2
            WHEN ((eel_lfs_code)::text = 'OG'::text) THEN 3
            WHEN ((eel_lfs_code)::text = 'GY'::text) THEN 4
            WHEN ((eel_lfs_code)::text = 'Y'::text) THEN 5
            WHEN ((eel_lfs_code)::text = 'YS'::text) THEN 6
            WHEN ((eel_lfs_code)::text = 'S'::text) THEN 7
            WHEN ((eel_lfs_code)::text = 'AL'::text) THEN 8
            ELSE NULL::integer
        END;


ALTER TABLE datawg.bigtable OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 2554242)
-- Name: bigtable_by_habitat; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.bigtable_by_habitat AS
 SELECT bigtable.eel_year,
    bigtable.eel_cou_code,
    bigtable.country,
    bigtable.cou_order,
    bigtable.eel_emu_nameshort,
    bigtable.emu_wholecountry,
    bigtable.eel_hty_code,
    bigtable.habitat,
    sum(bigtable.b0) AS b0,
    sum(bigtable.bbest) AS bbest,
    sum(bigtable.bcurrent) AS bcurrent,
    sum(bigtable.suma) AS suma,
    sum(bigtable.sumf) AS sumf,
    sum(bigtable.sumh) AS sumh,
    sum(bigtable.habitat_ha) AS habitat_ha,
    string_agg((bigtable.eel_lfs_code)::text, ', '::text) AS aggregated_lfs,
    sum(bigtable.bcurrent_without_stocking) AS bcurrent_without_stocking
   FROM datawg.bigtable
  GROUP BY bigtable.eel_year, bigtable.eel_cou_code, bigtable.country, bigtable.cou_order, bigtable.eel_emu_nameshort, bigtable.emu_wholecountry, bigtable.eel_hty_code, bigtable.habitat
  ORDER BY bigtable.eel_year, bigtable.cou_order, bigtable.eel_emu_nameshort,
        CASE
            WHEN ((bigtable.eel_hty_code)::text = 'F'::text) THEN 1
            WHEN ((bigtable.eel_hty_code)::text = 'T'::text) THEN 2
            WHEN ((bigtable.eel_hty_code)::text = 'C'::text) THEN 3
            WHEN ((bigtable.eel_hty_code)::text = 'MO'::text) THEN 4
            WHEN ((bigtable.eel_hty_code)::text = 'AL'::text) THEN 5
            ELSE NULL::integer
        END;


ALTER TABLE datawg.bigtable_by_habitat OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 2554247)
-- Name: landings; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.landings AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = ANY (ARRAY[4, 6, 32, 33])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.landings OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 2554252)
-- Name: log; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.log (
    log_id integer NOT NULL,
    log_cou_code character varying(2),
    log_data text,
    log_evaluation_name text,
    log_main_assessor text,
    log_secondary_assessor text,
    log_contact_person_name text,
    log_method text,
    log_message text,
    log_date date
);


ALTER TABLE datawg.log OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 2554257)
-- Name: log_log_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.log_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.log_log_id_seq OWNER TO postgres;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 284
-- Name: log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.log_log_id_seq OWNED BY datawg.log.log_id;


--
-- TOC entry 285 (class 1259 OID 2554258)
-- Name: other_landings; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.other_landings AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE (t_eelstock_eel.eel_typ_id = ANY (ARRAY[32, 33]));


ALTER TABLE datawg.other_landings OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 2554263)
-- Name: participants; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.participants (
    name text NOT NULL
);


ALTER TABLE datawg.participants OWNER TO postgres;

--
-- TOC entry 362 (class 1259 OID 7736366)
-- Name: precodata; Type: VIEW; Schema: datawg; Owner: wgeel
--

CREATE VIEW datawg.precodata AS
 WITH b0 AS (
         SELECT b0_1.eel_cou_code,
            b0_1.eel_emu_nameshort,
            b0_1.eel_hty_code,
            b0_1.eel_lfs_code,
            b0_1.eel_qal_id,
            b0_1.eel_value AS b0
           FROM datawg.b0 b0_1
          WHERE ((b0_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((b0_1.eel_qal_id = 0) AND ((b0_1.eel_missvaluequal)::text = 'NP'::text)))
        ), bbest AS (
         SELECT bbest_1.eel_cou_code,
            bbest_1.eel_emu_nameshort,
            bbest_1.eel_hty_code,
            bbest_1.eel_year,
            bbest_1.eel_lfs_code,
            bbest_1.eel_qal_id,
            bbest_1.eel_value AS bbest
           FROM datawg.bbest bbest_1
          WHERE ((bbest_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((bbest_1.eel_qal_id = 0) AND ((bbest_1.eel_missvaluequal)::text = 'NP'::text)))
        ), bcurrent AS (
         SELECT bcurrent_1.eel_cou_code,
            bcurrent_1.eel_emu_nameshort,
            bcurrent_1.eel_hty_code,
            bcurrent_1.eel_year,
            bcurrent_1.eel_lfs_code,
            bcurrent_1.eel_qal_id,
            bcurrent_1.eel_value AS bcurrent
           FROM datawg.bcurrent bcurrent_1
          WHERE ((bcurrent_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((bcurrent_1.eel_qal_id = 0) AND ((bcurrent_1.eel_missvaluequal)::text = 'NP'::text)))
        ), bcurrent_without_stocking AS (
         SELECT bcurrent_without_stocking_1.eel_cou_code,
            bcurrent_without_stocking_1.eel_emu_nameshort,
            bcurrent_without_stocking_1.eel_hty_code,
            bcurrent_without_stocking_1.eel_year,
            bcurrent_without_stocking_1.eel_lfs_code,
            bcurrent_without_stocking_1.eel_qal_id,
            bcurrent_without_stocking_1.eel_value AS bcurrent_without_stocking
           FROM datawg.bcurrent_without_stocking bcurrent_without_stocking_1
          WHERE ((bcurrent_without_stocking_1.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((bcurrent_without_stocking_1.eel_qal_id = 0) AND ((bcurrent_without_stocking_1.eel_missvaluequal)::text = 'NP'::text)))
        ), suma AS (
         SELECT sigmaa.eel_cou_code,
            sigmaa.eel_emu_nameshort,
            sigmaa.eel_hty_code,
            sigmaa.eel_year,
            sigmaa.eel_lfs_code,
            sigmaa.eel_qal_id,
            round(sigmaa.eel_value, 3) AS suma
           FROM datawg.sigmaa
          WHERE ((sigmaa.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((sigmaa.eel_qal_id = 0) AND ((sigmaa.eel_missvaluequal)::text = 'NP'::text)))
        ), sumf AS (
         SELECT sigmaf.eel_cou_code,
            sigmaf.eel_emu_nameshort,
            sigmaf.eel_hty_code,
            sigmaf.eel_year,
            sigmaf.eel_lfs_code,
            sigmaf.eel_qal_id,
            round(sigmaf.eel_value, 3) AS sumf
           FROM datawg.sigmaf
          WHERE ((sigmaf.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((sigmaf.eel_qal_id = 0) AND ((sigmaf.eel_missvaluequal)::text = 'NP'::text)))
        ), sumh AS (
         SELECT sigmah.eel_cou_code,
            sigmah.eel_emu_nameshort,
            sigmah.eel_hty_code,
            sigmah.eel_year,
            sigmah.eel_lfs_code,
            sigmah.eel_qal_id,
            round(sigmah.eel_value, 3) AS sumh
           FROM datawg.sigmah
          WHERE ((sigmah.eel_qal_id = ANY (ARRAY[1, 2, 4])) OR ((sigmah.eel_qal_id = 0) AND ((sigmah.eel_missvaluequal)::text = 'NP'::text)))
        ), countries AS (
         SELECT tr_country_cou.cou_code,
            tr_country_cou.cou_country AS country,
            tr_country_cou.cou_order
           FROM ref.tr_country_cou
        ), emu AS (
         SELECT tr_emu_emu.emu_nameshort,
            tr_emu_emu.emu_wholecountry
           FROM ref.tr_emu_emu
        ), life_stage AS (
         SELECT tr_lifestage_lfs.lfs_code,
            tr_lifestage_lfs.lfs_name AS life_stage
           FROM ref.tr_lifestage_lfs
        )
 SELECT eel_year,
    eel_cou_code,
    countries.country,
    countries.cou_order,
    eel_emu_nameshort,
    emu.emu_wholecountry,
    eel_hty_code,
    eel_lfs_code,
    life_stage.life_stage,
    eel_qal_id,
    b0.b0,
    bbest.bbest,
    bcurrent.bcurrent,
    suma.suma,
    sumf.sumf,
    sumh.sumh,
    bcurrent_without_stocking.bcurrent_without_stocking
   FROM (((((((((b0
     FULL JOIN bbest USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_lfs_code, eel_qal_id))
     FULL JOIN bcurrent USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id))
     FULL JOIN bcurrent_without_stocking USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id))
     FULL JOIN suma USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id))
     FULL JOIN sumf USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id))
     FULL JOIN sumh USING (eel_cou_code, eel_emu_nameshort, eel_hty_code, eel_year, eel_lfs_code, eel_qal_id))
     FULL JOIN countries ON (((eel_cou_code)::text = (countries.cou_code)::text)))
     JOIN emu ON (((eel_emu_nameshort)::text = (emu.emu_nameshort)::text)))
     JOIN life_stage ON (((eel_lfs_code)::text = (life_stage.lfs_code)::text)))
  ORDER BY eel_year, countries.cou_order, eel_emu_nameshort, eel_qal_id;


ALTER TABLE datawg.precodata OWNER TO wgeel;

--
-- TOC entry 363 (class 1259 OID 7736371)
-- Name: precodata_country; Type: VIEW; Schema: datawg; Owner: wgeel
--

CREATE VIEW datawg.precodata_country AS
 WITH nr_emu_per_country AS (
         SELECT tr_emu_emu.emu_cou_code,
            sum(((NOT tr_emu_emu.emu_wholecountry))::integer) AS nr_emu
           FROM ref.tr_emu_emu
          GROUP BY tr_emu_emu.emu_cou_code
        ), mimimun_met AS (
         SELECT precodata.eel_year,
            precodata.eel_cou_code,
            precodata.country,
            precodata.eel_emu_nameshort,
            precodata.bbest,
            precodata.bcurrent,
            precodata.bcurrent_without_stocking,
            precodata.suma,
            precodata.sumf,
            precodata.sumh,
            (precodata.bbest IS NOT NULL) AS bbestt,
            (precodata.bcurrent IS NOT NULL) AS bcurrentt,
            (precodata.bcurrent_without_stocking IS NOT NULL) AS bcurrentt_without_stocking,
            (precodata.suma IS NOT NULL) AS sumat,
            (precodata.sumf IS NOT NULL) AS sumft,
            (precodata.sumh IS NOT NULL) AS sumht
           FROM datawg.precodata
          WHERE ((precodata.eel_qal_id <> 0) AND (NOT precodata.emu_wholecountry))
        ), analyse_emu_total AS (
         SELECT precodata.eel_year,
            precodata.eel_cou_code,
            precodata.country,
            precodata.bbest,
            precodata.bcurrent,
            precodata.bcurrent_without_stocking,
            precodata.suma,
            precodata.sumf,
            precodata.sumh,
            ((precodata.bbest IS NOT NULL))::integer AS bbest_total,
            ((precodata.bcurrent IS NOT NULL))::integer AS bcurrent_total,
            ((precodata.bcurrent_without_stocking IS NOT NULL))::integer AS bcurrent_total_without_stocking,
            ((precodata.suma IS NOT NULL))::integer AS suma_total,
            ((precodata.sumf IS NOT NULL))::integer AS sumf_total,
            ((precodata.sumh IS NOT NULL))::integer AS sumh_total
           FROM datawg.precodata
          WHERE ((precodata.eel_qal_id <> 0) AND precodata.emu_wholecountry)
        ), analyse_emu AS (
         SELECT mimimun_met.eel_year,
            mimimun_met.eel_cou_code,
            mimimun_met.country,
            count(*) AS counted_emu,
            sum((mimimun_met.bbestt)::integer) AS bbest_emu,
            sum((mimimun_met.bcurrentt)::integer) AS bcurrent_emu,
            sum((mimimun_met.bcurrentt_without_stocking)::integer) AS bcurrent_emu_without_stocking,
            sum((mimimun_met.sumat)::integer) AS suma_emu,
            sum((mimimun_met.sumft)::integer) AS sumf_emu,
            sum((mimimun_met.sumht)::integer) AS sumh_emu,
            sum(mimimun_met.bbest) AS bbest,
            sum(mimimun_met.bcurrent) AS bcurrent,
            sum(mimimun_met.bcurrent_without_stocking) AS bcurrent_without_stocking,
            round((sum((mimimun_met.suma * mimimun_met.bbest)) / sum(mimimun_met.bbest)), 3) AS suma,
            round((sum((mimimun_met.sumf * mimimun_met.bbest)) / sum(mimimun_met.bbest)), 3) AS sumf,
            round((sum((mimimun_met.sumh * mimimun_met.bbest)) / sum(mimimun_met.bbest)), 3) AS sumh
           FROM mimimun_met
          GROUP BY mimimun_met.eel_year, mimimun_met.eel_cou_code, mimimun_met.country
        ), analyse_b0 AS (
         SELECT sum(b0.eel_value) AS b0,
            tr_emu_emu.emu_cou_code AS eel_cou_code,
            count(*) AS b0_emu
           FROM (datawg.b0
             LEFT JOIN ref.tr_emu_emu ON (((b0.eel_emu_nameshort)::text = (tr_emu_emu.emu_nameshort)::text)))
          WHERE ((NOT tr_emu_emu.emu_wholecountry) AND (b0.eel_value IS NOT NULL))
          GROUP BY tr_emu_emu.emu_cou_code
        ), analyse_b0_total AS (
         SELECT b0.eel_value AS b0,
            tr_emu_emu.emu_cou_code AS eel_cou_code,
            (b0.* IS NOT NULL) AS b0_total
           FROM (datawg.b0
             LEFT JOIN ref.tr_emu_emu ON (((b0.eel_emu_nameshort)::text = (tr_emu_emu.emu_nameshort)::text)))
          WHERE tr_emu_emu.emu_wholecountry
        )
 SELECT eel_year,
    (eel_cou_code)::character varying(2) AS eel_cou_code,
    country,
    nr_emu_per_country.nr_emu,
    'country'::text AS aggreg_level,
    NULL::character varying(20) AS eel_emu_nameshort,
        CASE
            WHEN analyse_b0_total.b0_total THEN analyse_b0_total.b0
            ELSE analyse_b0.b0
        END AS b0,
        CASE
            WHEN (analyse_emu_total.bbest_total = 1) THEN analyse_emu_total.bbest
            ELSE analyse_emu.bbest
        END AS bbest,
        CASE
            WHEN (analyse_emu_total.bcurrent_total = 1) THEN analyse_emu_total.bcurrent
            ELSE analyse_emu.bcurrent
        END AS bcurrent,
        CASE
            WHEN (analyse_emu_total.suma_total = 1) THEN analyse_emu_total.suma
            ELSE analyse_emu.suma
        END AS suma,
        CASE
            WHEN (analyse_emu_total.sumf_total = 1) THEN analyse_emu_total.sumf
            ELSE analyse_emu.sumf
        END AS sumf,
        CASE
            WHEN (analyse_emu_total.sumh_total = 1) THEN analyse_emu_total.sumh
            ELSE analyse_emu.sumh
        END AS sumh,
        CASE
            WHEN analyse_b0_total.b0_total THEN 'EMU_Total'::text
            WHEN (analyse_b0.b0_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_b0.b0_emu > 0) THEN ((('Sum of '::text || analyse_b0.b0_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_b0,
        CASE
            WHEN (analyse_emu_total.bbest_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.bbest_emu > 0) THEN ((('Sum of '::text || analyse_emu.bbest_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_bbest,
        CASE
            WHEN (analyse_emu_total.bcurrent_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bcurrent_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.bcurrent_emu > 0) THEN ((('Sum of '::text || analyse_emu.bcurrent_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_bcurrent,
        CASE
            WHEN (analyse_emu_total.suma_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.suma_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_suma,
        CASE
            WHEN (analyse_emu_total.sumf_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumf_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_sumf,
        CASE
            WHEN (analyse_emu_total.sumh_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumh_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_sumh,
        CASE
            WHEN (analyse_emu_total.bcurrent_total_without_stocking = 1) THEN analyse_emu_total.bcurrent_without_stocking
            ELSE analyse_emu.bcurrent_without_stocking
        END AS bcurrent_without_stocking,
        CASE
            WHEN (analyse_emu_total.bcurrent_total_without_stocking = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bcurrent_emu_without_stocking = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.bcurrent_emu_without_stocking > 0) THEN ((('Sum of '::text || analyse_emu.bcurrent_emu_without_stocking) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_bcurrent_without_stocking
   FROM (((((analyse_emu_total
     FULL JOIN analyse_emu USING (eel_year, eel_cou_code, country))
     FULL JOIN analyse_b0 USING (eel_cou_code))
     FULL JOIN analyse_b0_total USING (eel_cou_code))
     JOIN nr_emu_per_country ON (((eel_cou_code)::text = nr_emu_per_country.emu_cou_code)))
     JOIN ref.tr_country_cou ON (((eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
  ORDER BY eel_year, tr_country_cou.cou_order;


ALTER TABLE datawg.precodata_country OWNER TO wgeel;

--
-- TOC entry 364 (class 1259 OID 7736376)
-- Name: precodata_all; Type: VIEW; Schema: datawg; Owner: wgeel
--

CREATE VIEW datawg.precodata_all AS
 WITH all_level AS (
        ( WITH last_year_emu AS (
                 SELECT precodata.eel_emu_nameshort,
                    max(precodata.eel_year) AS last_year
                   FROM datawg.precodata
                  WHERE ((precodata.bbest IS NOT NULL) AND (precodata.bcurrent IS NOT NULL) AND (precodata.suma IS NOT NULL))
                  GROUP BY precodata.eel_emu_nameshort
                )
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            NULL::text AS aggreg_comment,
            b0.eel_value AS b0,
            p.bbest,
            p.bcurrent,
            p.bcurrent_without_stocking,
            p.suma,
            p.sumf,
            p.sumh,
            'all'::text AS aggreg_level,
            last_year_emu.last_year
           FROM ((datawg.precodata p
             LEFT JOIN last_year_emu USING (eel_emu_nameshort))
             LEFT JOIN datawg.b0 USING (eel_emu_nameshort)))
        UNION
        ( WITH last_year_emu AS (
                 SELECT precodata.eel_emu_nameshort,
                    max(precodata.eel_year) AS last_year
                   FROM datawg.precodata
                  WHERE ((precodata.bbest IS NOT NULL) AND (precodata.bcurrent IS NOT NULL) AND (precodata.suma IS NOT NULL))
                  GROUP BY precodata.eel_emu_nameshort
                )
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            NULL::text AS aggreg_comment,
            b0.eel_value AS b0,
            p.bbest,
            p.bcurrent,
            p.bcurrent_without_stocking,
            p.suma,
            p.sumf,
            p.sumh,
            'emu'::text AS aggreg_level,
            last_year_emu.last_year
           FROM ((datawg.precodata p
             LEFT JOIN last_year_emu USING (eel_emu_nameshort))
             LEFT JOIN datawg.b0 USING (eel_emu_nameshort)))
        UNION
        ( WITH last_year_country AS (
                 SELECT precodata_country.eel_cou_code,
                    max(precodata_country.eel_year) AS last_year
                   FROM datawg.precodata_country
                  WHERE ((precodata_country.bbest IS NOT NULL) AND (precodata_country.bcurrent IS NOT NULL) AND (precodata_country.suma IS NOT NULL))
                  GROUP BY precodata_country.eel_cou_code
                )
         SELECT p.eel_year,
            p.eel_cou_code,
            p.eel_emu_nameshort,
            (((((((((((('<B0>'::text || p.method_b0) || '<\B0><Bbest>'::text) || p.method_bbest) || '<\Bbest><Bcurrent>'::text) || p.method_bcurrent) || '<\Bcurrent><suma>'::text) || p.method_suma) || '<\suma><sumf>'::text) || p.method_sumf) || '<\sumf><sumh>'::text) || p.method_sumh) || '<\sumah>'::text) AS aggreg_comment,
            p.b0,
            p.bbest,
            p.bcurrent,
            p.bcurrent_without_stocking,
            p.suma,
            p.sumf,
            p.sumh,
            p.aggreg_level,
            last_year_country.last_year
           FROM (datawg.precodata_country p
             LEFT JOIN last_year_country USING (eel_cou_code)))
        UNION
         SELECT precodata_country.eel_year,
            NULL::character varying AS eel_cou_code,
            NULL::character varying AS eel_emu_nameshort,
            (((('All ('::text || count(*)) || ' countries: '::text) || string_agg((precodata_country.eel_cou_code)::text, ','::text)) || ')'::text) AS aggreg_comment,
            sum(precodata_country.b0) AS b0,
            sum(precodata_country.bbest) AS bbest,
            sum(precodata_country.bcurrent) AS bcurrent,
            sum(precodata_country.bcurrent_without_stocking) AS bcurrent_without_stocking,
            round((sum((precodata_country.suma * precodata_country.bbest)) / sum(precodata_country.bbest)), 3) AS suma,
                CASE
                    WHEN (count(precodata_country.sumf) < count(*)) THEN NULL::numeric
                    ELSE round((sum((precodata_country.sumf * precodata_country.bbest)) / sum(precodata_country.bbest)), 3)
                END AS sumf,
                CASE
                    WHEN (count(precodata_country.sumh) < count(*)) THEN NULL::numeric
                    ELSE round((sum((precodata_country.sumh * precodata_country.bbest)) / sum(precodata_country.bbest)), 3)
                END AS sumf,
            'all'::text AS aggreg_level,
            NULL::integer AS last_year
           FROM datawg.precodata_country
          WHERE ((precodata_country.b0 IS NOT NULL) AND (precodata_country.bbest IS NOT NULL) AND (precodata_country.bcurrent IS NOT NULL) AND (precodata_country.suma IS NOT NULL) AND (precodata_country.bcurrent_without_stocking IS NOT NULL))
          GROUP BY precodata_country.eel_year
        )
 SELECT all_level.eel_year,
    all_level.eel_cou_code,
    all_level.eel_emu_nameshort,
    all_level.aggreg_comment,
    all_level.b0,
    all_level.bbest,
    all_level.bcurrent,
    all_level.suma,
    all_level.sumf,
    all_level.sumh,
    all_level.aggreg_level,
    all_level.last_year,
    all_level.bcurrent_without_stocking
   FROM (all_level
     LEFT JOIN ref.tr_country_cou ON (((all_level.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
  ORDER BY all_level.eel_year,
        CASE
            WHEN (all_level.aggreg_level = 'emu'::text) THEN 1
            WHEN (all_level.aggreg_level = 'country'::text) THEN 2
            WHEN (all_level.aggreg_level = 'all'::text) THEN 3
            ELSE NULL::integer
        END, tr_country_cou.cou_order, all_level.eel_emu_nameshort;


ALTER TABLE datawg.precodata_all OWNER TO wgeel;

--
-- TOC entry 287 (class 1259 OID 2554268)
-- Name: precodata_emu; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.precodata_emu AS
 WITH b0_unique AS (
         SELECT bigtable_by_habitat_1.eel_emu_nameshort,
            sum(bigtable_by_habitat_1.b0) AS unique_b0
           FROM datawg.bigtable_by_habitat bigtable_by_habitat_1
          WHERE (((bigtable_by_habitat_1.eel_year = 0) AND ((bigtable_by_habitat_1.eel_emu_nameshort)::text <> 'ES_Murc'::text)) OR ((bigtable_by_habitat_1.eel_year = 0) AND ((bigtable_by_habitat_1.eel_emu_nameshort)::text = 'ES_Murc'::text) AND ((bigtable_by_habitat_1.eel_hty_code)::text = 'C'::text)))
          GROUP BY bigtable_by_habitat_1.eel_emu_nameshort
        )
 SELECT bigtable_by_habitat.eel_year,
    bigtable_by_habitat.eel_cou_code,
    bigtable_by_habitat.country,
    bigtable_by_habitat.cou_order,
    bigtable_by_habitat.eel_emu_nameshort,
    bigtable_by_habitat.emu_wholecountry,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = 'LT_total'::text) THEN NULL::numeric
            ELSE COALESCE(b0_unique.unique_b0, sum(bigtable_by_habitat.b0))
        END AS b0,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = 'LT_total'::text) THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bbest)
        END AS bbest,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = 'LT_total'::text) THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bcurrent)
        END AS bcurrent,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = ANY (ARRAY[('ES_Cata'::character varying)::text, ('LT_total'::character varying)::text])) THEN NULL::numeric
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = ANY (ARRAY[('IT_Camp'::character varying)::text, ('IT_Emil'::character varying)::text, ('IT_Frio'::character varying)::text, ('IT_Lazi'::character varying)::text, ('IT_Pugl'::character varying)::text, ('IT_Sard'::character varying)::text, ('IT_Sici'::character varying)::text, ('IT_Tosc'::character varying)::text, ('IT_Vene'::character varying)::text, ('IT_Abru'::character varying)::text, ('IT_Basi'::character varying)::text, ('IT_Cala'::character varying)::text, ('IT_Ligu'::character varying)::text, ('IT_Lomb'::character varying)::text, ('IT_Marc'::character varying)::text, ('IT_Moli'::character varying)::text, ('IT_Piem'::character varying)::text, ('IT_Tren'::character varying)::text, ('IT_Umbr'::character varying)::text, ('IT_Vall'::character varying)::text])) THEN round((sum((bigtable_by_habitat.suma * bigtable_by_habitat.bbest)) / sum(bigtable_by_habitat.bbest)), 3)
            ELSE sum(bigtable_by_habitat.suma)
        END AS suma,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = ANY (ARRAY[('ES_Cata'::character varying)::text, ('LT_total'::character varying)::text])) THEN NULL::numeric
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = ANY (ARRAY[('IT_Camp'::character varying)::text, ('IT_Emil'::character varying)::text, ('IT_Frio'::character varying)::text, ('IT_Lazi'::character varying)::text, ('IT_Pugl'::character varying)::text, ('IT_Sard'::character varying)::text, ('IT_Sici'::character varying)::text, ('IT_Tosc'::character varying)::text, ('IT_Vene'::character varying)::text, ('IT_Abru'::character varying)::text, ('IT_Basi'::character varying)::text, ('IT_Cala'::character varying)::text, ('IT_Ligu'::character varying)::text, ('IT_Lomb'::character varying)::text, ('IT_Marc'::character varying)::text, ('IT_Moli'::character varying)::text, ('IT_Piem'::character varying)::text, ('IT_Tren'::character varying)::text, ('IT_Umbr'::character varying)::text, ('IT_Vall'::character varying)::text])) THEN round((sum((bigtable_by_habitat.sumf * bigtable_by_habitat.bbest)) / sum(bigtable_by_habitat.bbest)), 3)
            ELSE sum(bigtable_by_habitat.sumf)
        END AS sumf,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = 'LT_total'::text) THEN NULL::numeric
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = ANY (ARRAY[('IT_Camp'::character varying)::text, ('IT_Emil'::character varying)::text, ('IT_Frio'::character varying)::text, ('IT_Lazi'::character varying)::text, ('IT_Pugl'::character varying)::text, ('IT_Sard'::character varying)::text, ('IT_Sici'::character varying)::text, ('IT_Tosc'::character varying)::text, ('IT_Vene'::character varying)::text, ('IT_Abru'::character varying)::text, ('IT_Basi'::character varying)::text, ('IT_Cala'::character varying)::text, ('IT_Ligu'::character varying)::text, ('IT_Lomb'::character varying)::text, ('IT_Marc'::character varying)::text, ('IT_Moli'::character varying)::text, ('IT_Piem'::character varying)::text, ('IT_Tren'::character varying)::text, ('IT_Umbr'::character varying)::text, ('IT_Vall'::character varying)::text])) THEN round((sum((bigtable_by_habitat.sumh * bigtable_by_habitat.bbest)) / sum(bigtable_by_habitat.bbest)), 3)
            ELSE sum(bigtable_by_habitat.sumh)
        END AS sumh,
    'emu'::text AS aggreg_level,
    bigtable_by_habitat.aggregated_lfs,
    string_agg((bigtable_by_habitat.eel_hty_code)::text, ', '::text) AS aggregated_hty,
        CASE
            WHEN ((bigtable_by_habitat.eel_emu_nameshort)::text = 'LT_total'::text) THEN NULL::numeric
            ELSE sum(bigtable_by_habitat.bcurrent_without_stocking)
        END AS bcurrent_without_stocking
   FROM (datawg.bigtable_by_habitat
     LEFT JOIN b0_unique USING (eel_emu_nameshort))
  WHERE (((bigtable_by_habitat.eel_year > 1850) AND (bigtable_by_habitat.aggregated_lfs = 'S'::text) AND ((bigtable_by_habitat.eel_emu_nameshort)::text <> 'ES_Murc'::text)) OR ((bigtable_by_habitat.eel_year > 1850) AND ((bigtable_by_habitat.eel_emu_nameshort)::text = 'ES_Murc'::text) AND ((bigtable_by_habitat.eel_hty_code)::text = 'C'::text)))
  GROUP BY bigtable_by_habitat.eel_year, bigtable_by_habitat.eel_cou_code, bigtable_by_habitat.country, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort, bigtable_by_habitat.emu_wholecountry, bigtable_by_habitat.aggregated_lfs, b0_unique.unique_b0
  ORDER BY bigtable_by_habitat.eel_year, bigtable_by_habitat.cou_order, bigtable_by_habitat.eel_emu_nameshort;


ALTER TABLE datawg.precodata_emu OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 2554283)
-- Name: precodata_country_test; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.precodata_country_test AS
 WITH nr_emu_per_country AS (
         SELECT tr_emu_emu.emu_cou_code,
            sum(((NOT tr_emu_emu.emu_wholecountry))::integer) AS nr_emu
           FROM ref.tr_emu_emu
          GROUP BY tr_emu_emu.emu_cou_code
        ), mimimun_met AS (
         SELECT precodata_emu.eel_year,
            precodata_emu.eel_cou_code,
            precodata_emu.country,
            precodata_emu.eel_emu_nameshort,
            precodata_emu.b0,
            precodata_emu.bbest,
            precodata_emu.bcurrent,
            precodata_emu.suma,
            precodata_emu.sumf,
            precodata_emu.sumh,
            (precodata_emu.b0 IS NOT NULL) AS b0t,
            (precodata_emu.bbest IS NOT NULL) AS bbestt,
            (precodata_emu.bcurrent IS NOT NULL) AS bcurrentt,
            (precodata_emu.suma IS NOT NULL) AS sumat,
            (precodata_emu.sumf IS NOT NULL) AS sumft,
            (precodata_emu.sumh IS NOT NULL) AS sumht
           FROM datawg.precodata_emu
          WHERE (NOT precodata_emu.emu_wholecountry)
        ), analyse_emu_total AS (
         SELECT precodata_emu.eel_year,
            precodata_emu.eel_cou_code,
            precodata_emu.country,
            precodata_emu.b0,
            precodata_emu.bbest,
            precodata_emu.bcurrent,
            precodata_emu.suma,
            precodata_emu.sumf,
            precodata_emu.sumh,
            ((precodata_emu.b0 IS NOT NULL))::integer AS b0_total,
            ((precodata_emu.bbest IS NOT NULL))::integer AS bbest_total,
            ((precodata_emu.bcurrent IS NOT NULL))::integer AS bcurrent_total,
            ((precodata_emu.suma IS NOT NULL))::integer AS suma_total,
            ((precodata_emu.sumf IS NOT NULL))::integer AS sumf_total,
            ((precodata_emu.sumh IS NOT NULL))::integer AS sumh_total
           FROM datawg.precodata_emu
          WHERE precodata_emu.emu_wholecountry
        ), analyse_emu AS (
         SELECT mimimun_met.eel_year,
            mimimun_met.eel_cou_code,
            mimimun_met.country,
            count(*) AS counted_emu,
            sum((mimimun_met.b0t)::integer) AS b0_emu,
            sum((mimimun_met.bbestt)::integer) AS bbest_emu,
            sum(((mimimun_met.b0t)::integer * (mimimun_met.bcurrentt)::integer)) AS bcurrent_b0_emu,
            sum((((mimimun_met.sumat)::integer * (mimimun_met.sumft)::integer) * (mimimun_met.bbestt)::integer)) AS sumfsuma_emu,
            sum((mimimun_met.bcurrentt)::integer) AS bcurrent_emu,
            sum((mimimun_met.sumat)::integer) AS suma_emu,
            sum((mimimun_met.sumft)::integer) AS sumf_emu,
            sum((mimimun_met.sumht)::integer) AS sumh_emu,
            sum(mimimun_met.b0) AS b0,
            sum(mimimun_met.bbest) AS bbest,
            sum(mimimun_met.bcurrent) AS bcurrent,
            (sum((mimimun_met.bcurrent * ((mimimun_met.b0t)::integer)::numeric)) / sum((mimimun_met.b0 * ((mimimun_met.bcurrentt)::integer)::numeric))) AS bcurrent_b0,
            round((- ln((sum((exp((- mimimun_met.suma)) * mimimun_met.bbest)) / sum((mimimun_met.bbest * ((mimimun_met.sumat)::integer)::numeric))))), 3) AS suma,
            round((- ln((sum((exp((- mimimun_met.sumf)) * mimimun_met.bbest)) / sum((mimimun_met.bbest * ((mimimun_met.sumft)::integer)::numeric))))), 3) AS sumf,
            round((- ln((sum((exp((- mimimun_met.sumh)) * mimimun_met.bbest)) / sum((mimimun_met.bbest * ((mimimun_met.sumht)::integer)::numeric))))), 3) AS sumh,
                CASE
                    WHEN (sum((((mimimun_met.sumat)::integer * (mimimun_met.sumft)::integer) * (mimimun_met.bbestt)::integer)) = 0) THEN NULL::numeric
                    ELSE round((ln(sum(((exp((- mimimun_met.sumf)) * mimimun_met.bbest) * ((mimimun_met.sumat)::integer)::numeric))) / ln(sum(((exp((- mimimun_met.suma)) * mimimun_met.bbest) * ((mimimun_met.sumft)::integer)::numeric)))), 3)
                END AS sumfsuma
           FROM mimimun_met
          GROUP BY mimimun_met.eel_year, mimimun_met.eel_cou_code, mimimun_met.country
        )
 SELECT eel_year,
    eel_cou_code,
    country,
    nr_emu_per_country.nr_emu,
    'country'::text AS aggreg_level,
    NULL::character varying(20) AS eel_emu_nameshort,
        CASE
            WHEN (analyse_emu_total.b0_total = 1) THEN analyse_emu_total.b0
            ELSE analyse_emu.b0
        END AS b0,
        CASE
            WHEN (analyse_emu_total.bbest_total = 1) THEN analyse_emu_total.bbest
            ELSE analyse_emu.bbest
        END AS bbest,
        CASE
            WHEN (analyse_emu_total.bcurrent_total = 1) THEN analyse_emu_total.bcurrent
            ELSE analyse_emu.bcurrent
        END AS bcurrent,
        CASE
            WHEN (analyse_emu_total.suma_total = 1) THEN analyse_emu_total.suma
            ELSE analyse_emu.suma
        END AS suma,
        CASE
            WHEN (analyse_emu_total.sumf_total = 1) THEN analyse_emu_total.sumf
            ELSE analyse_emu.sumf
        END AS sumf,
        CASE
            WHEN (analyse_emu_total.sumh_total = 1) THEN analyse_emu_total.sumh
            ELSE analyse_emu.sumh
        END AS sumh,
        CASE
            WHEN (analyse_emu_total.b0_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.b0_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.b0_emu > 0) THEN ((('Sum of '::text || analyse_emu.b0_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_b0,
        CASE
            WHEN (analyse_emu_total.bbest_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.bbest_emu > 0) THEN ((('Sum of '::text || analyse_emu.bbest_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_bbest,
        CASE
            WHEN (analyse_emu_total.bcurrent_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bcurrent_emu = nr_emu_per_country.nr_emu) THEN 'Sum of all EMU'::text
            WHEN (analyse_emu.bcurrent_emu > 0) THEN ((('Sum of '::text || analyse_emu.bcurrent_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_bcurrent,
        CASE
            WHEN (analyse_emu_total.suma_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.suma_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.suma_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_suma,
        CASE
            WHEN (analyse_emu_total.sumf_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumf_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumf_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_sumf,
        CASE
            WHEN (analyse_emu_total.sumh_total = 1) THEN 'EMU_Total'::text
            WHEN ((analyse_emu.bbest_emu = nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu = nr_emu_per_country.nr_emu)) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.bbest_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumh_emu > 0)) THEN ((('Weighted average by Bbest of '::text || LEAST(analyse_emu.bbest_emu, analyse_emu.sumh_emu)) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_sumh,
        CASE
            WHEN (analyse_emu_total.bcurrent_total = 1) THEN (analyse_emu_total.bcurrent / analyse_emu_total.b0)
            ELSE analyse_emu.bcurrent_b0
        END AS ratio_bcurrent_b0,
        CASE
            WHEN (analyse_emu_total.sumf_total = 1) THEN (analyse_emu_total.sumf / analyse_emu_total.suma)
            ELSE analyse_emu.sumfsuma
        END AS ratio_sumfsuma,
        CASE
            WHEN (analyse_emu_total.b0_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.bcurrent_b0_emu = nr_emu_per_country.nr_emu) THEN 'Biomasses summed over all EMU'::text
            WHEN ((analyse_emu.bcurrent_b0_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.bcurrent_b0_emu > 0)) THEN ((('Biomasses summed over '::text || analyse_emu.bcurrent_b0_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_ratio_bcurrent_b0_emu,
        CASE
            WHEN (analyse_emu_total.suma_total = 1) THEN 'EMU_Total'::text
            WHEN (analyse_emu.sumfsuma_emu = nr_emu_per_country.nr_emu) THEN 'Weighted average by Bbest of all EMU'::text
            WHEN ((analyse_emu.sumfsuma_emu < nr_emu_per_country.nr_emu) AND (analyse_emu.sumfsuma_emu > 0)) THEN ((('Weighted average by Bbest of '::text || analyse_emu.sumfsuma_emu) || ' EMU out of '::text) || nr_emu_per_country.nr_emu)
            ELSE NULL::text
        END AS method_ratio_sumfsuma
   FROM (((analyse_emu_total
     FULL JOIN analyse_emu USING (eel_year, eel_cou_code, country))
     JOIN nr_emu_per_country ON (((eel_cou_code)::text = nr_emu_per_country.emu_cou_code)))
     JOIN ref.tr_country_cou ON (((eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
  ORDER BY eel_year, tr_country_cou.cou_order;


ALTER TABLE datawg.precodata_country_test OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 2554288)
-- Name: release; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.release AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = ANY (ARRAY[8, 9, 10])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.release OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 7184007)
-- Name: series_stats; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.series_stats AS
SELECT
    NULL::integer AS ser_id,
    NULL::text AS site,
    NULL::text AS namelong,
    NULL::integer AS min,
    NULL::integer AS max,
    NULL::integer AS duration,
    NULL::bigint AS missing;


ALTER TABLE datawg.series_stats OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 2554297)
-- Name: t_series_ser; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_series_ser (
    ser_id integer NOT NULL,
    ser_nameshort text,
    ser_namelong text,
    ser_typ_id integer,
    ser_effort_uni_code character varying(20),
    ser_comment text,
    ser_uni_code character varying(20),
    ser_lfs_code character varying(2),
    ser_hty_code character varying(2),
    ser_locationdescription text,
    ser_emu_nameshort character varying(20),
    ser_cou_code character varying(2),
    ser_area_division character varying(254),
    ser_tblcodeid integer,
    ser_x numeric,
    ser_y numeric,
    geom public.geometry,
    ser_sam_id integer,
    ser_qal_id integer,
    ser_qal_comment text,
    ser_ccm_wso_id integer[],
    ser_dts_datasource character varying(100),
    ser_distanceseakm numeric,
    ser_method text,
    ser_sam_gear integer,
    ser_restocking boolean,
    CONSTRAINT c_ck_ser_typ_id CHECK ((ser_typ_id = ANY (ARRAY[1, 2, 3]))),
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(geom) = 4326)),
    CONSTRAINT ser_nameshortchk CHECK ((char_length(ser_nameshort) <= 10))
);


ALTER TABLE datawg.t_series_ser OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE t_series_ser; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON TABLE datawg.t_series_ser IS 'This table contains geographical informations 
and comments on the recruitment, silver eel migration and yellow eel standing stock survey series';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_id IS 'serial number internal use, identifier of the series';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_nameshort; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_nameshort IS 'short name of the recuitment series eg `Vil` for the Vilaine';


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_namelong; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_namelong IS 'long name of the recuitment series eg `Vilaine estuary` for the Vilaine';


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_typ_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_typ_id IS 'type of series 1= recruitment series, FOREIGN KEY to table ref.tr_typeseries_ser(ser_typ_id)';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_effort_uni_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_effort_uni_code IS 'unit used for effort, it is different from the unit used in the series, for instance some
 of the Dutch series rely on the number hauls made to collect the glass eel to qualify the series,
 FOREIGN KEY to ref.tr_units_uni ';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_comment; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_comment IS 'Comment for the series, this should be part of the metadata describing the whole series';


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_uni_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_uni_code IS 'unit of the series kg, ton, kg/boat/day ... FOREIGN KEY to table ref.tr_units_uni(uni_code)';


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_lfs_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_lfs_code IS 'lifestage id, FOREIGN KEY to tr_lifestage_lfs, possible values G, Y, S, GY, YS';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_hty_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_hty_code IS 'habitat FOREIGN KEY to table t_habitattype_hty (F=Freshwater, MO=Marine Open,T=transitional...)';


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_locationdescription; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_locationdescription IS 'Description for the river, the habitat where the series is collected eg. IYFS/IBTS sampling in the Skagerrak-Kattegat';


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_emu_nameshort; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_emu_nameshort IS 'The emu code, FOREIGN KEY to ref.tr_emu_emu';


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_cou_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_cou_code IS 'country code, FOREIGN KEY to ref.tr_country_cou';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_area_division; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_area_division IS 'code of ICES area, FOREIGN KEY to ref.tr_faoareas(f_division)';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_tblcodeid; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_tblcodeid IS 'code of the station, FOREIGN KEY to ref.tr_station';


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_x; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_x IS 'x (longitude) EPSG:4326. WGS 84 (Google it)';


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_y; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_y IS 'y (latitude) EPSG:4326. WGS 84 (Google it)';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.geom; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.geom IS 'internal use, a postgis geometry point in EPSG:3035 (ETRS89 / ETRS-LAEA)';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_sam_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_sam_id IS 'The sampling type corresponds to trap partial, trap total, ...., FOREIGN KEY to ref.tr_samplingtype_sam';


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_qal_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_qal_id IS 'Code to assess the quality of the data, this will allow to discard a whole series from the recruitment analysis FOREIGN KEY on table ref.tr_quality_qal';


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_qal_comment; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_qal_comment IS 'Comment on quality of data, why was the series retained or discarded from later analysis ? ';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_ccm_wso_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_ccm_wso_id IS 'wso_id (identifier) of the basin in the CCM (Catchment Caracterization DB from the JRC';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_dts_datasource; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_dts_datasource IS 'Source of data (datacall id)';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_distanceseakm; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_distanceseakm IS 'Distance to the saline limit in km, for group of data, e.g. a set of electrofishing points 
in a basin, this is the average distance of the different points';


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_method; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_method IS 'Description of the method used, includes precisions about the sampling method, period and life stages collected';


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_sam_gear; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_sam_gear IS 'Sampling gear see tr_gear_gea';


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 290
-- Name: COLUMN t_series_ser.ser_restocking; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_series_ser.ser_restocking IS 'Is the series affected by restocking, if yes you need to describe the effect in series description';


--
-- TOC entry 291 (class 1259 OID 2554306)
-- Name: tr_samplingtype_sam; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_samplingtype_sam (
    sam_id integer NOT NULL,
    sam_samplingtype character varying
);


ALTER TABLE ref.tr_samplingtype_sam OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 7184012)
-- Name: series_summary; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.series_summary AS
 SELECT ss.site,
    ss.namelong,
    ss.min,
    ss.max,
    ss.duration,
    ss.missing,
    ser.ser_lfs_code AS life_stage,
    tr_samplingtype_sam.sam_samplingtype AS sampling_type,
    ser.ser_uni_code AS unit,
    ser.ser_hty_code AS habitat_type,
    tr_country_cou.cou_order AS "order",
    ser.ser_typ_id,
    ser.ser_qal_id AS series_kept
   FROM (((datawg.series_stats ss
     JOIN datawg.t_series_ser ser ON ((ss.ser_id = ser.ser_id)))
     LEFT JOIN ref.tr_samplingtype_sam ON ((ser.ser_sam_id = tr_samplingtype_sam.sam_id)))
     LEFT JOIN ref.tr_country_cou ON (((tr_country_cou.cou_code)::text = (ser.ser_cou_code)::text)))
  ORDER BY tr_country_cou.cou_order, ser.ser_y;


ALTER TABLE datawg.series_summary OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 2554316)
-- Name: sigmafallcat; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.sigmafallcat AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = ANY (ARRAY[18, 20, 21])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.sigmafallcat OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 2554321)
-- Name: sigmahallcat; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.sigmahallcat AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = ANY (ARRAY[19, 22, 23, 24, 25])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.sigmahallcat OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 2554326)
-- Name: silver_eel_equivalents; Type: VIEW; Schema: datawg; Owner: postgres
--

CREATE VIEW datawg.silver_eel_equivalents AS
 SELECT t_eelstock_eel.eel_id,
    t_eelstock_eel.eel_typ_id,
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
   FROM ((((((datawg.t_eelstock_eel
     LEFT JOIN ref.tr_lifestage_lfs ON (((t_eelstock_eel.eel_lfs_code)::text = (tr_lifestage_lfs.lfs_code)::text)))
     LEFT JOIN ref.tr_quality_qal ON ((t_eelstock_eel.eel_qal_id = tr_quality_qal.qal_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_eelstock_eel.eel_cou_code)::text = (tr_country_cou.cou_code)::text)))
     LEFT JOIN ref.tr_typeseries_typ ON ((t_eelstock_eel.eel_typ_id = tr_typeseries_typ.typ_id)))
     LEFT JOIN ref.tr_habitattype_hty ON (((t_eelstock_eel.eel_hty_code)::text = (tr_habitattype_hty.hty_code)::text)))
     LEFT JOIN ref.tr_emu_emu ON ((((tr_emu_emu.emu_nameshort)::text = (t_eelstock_eel.eel_emu_nameshort)::text) AND (tr_emu_emu.emu_cou_code = (t_eelstock_eel.eel_cou_code)::text))))
  WHERE ((t_eelstock_eel.eel_typ_id = ANY (ARRAY[26, 27, 28, 29, 30, 31])) AND (t_eelstock_eel.eel_qal_id = ANY (ARRAY[1, 2, 4])));


ALTER TABLE datawg.silver_eel_equivalents OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 2554331)
-- Name: t_biometrygroupseries_bio; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_biometrygroupseries_bio (
    bio_id integer NOT NULL,
    bio_lfs_code character varying(2) NOT NULL,
    bio_year numeric,
    bio_length numeric,
    bio_weight numeric,
    bio_age numeric,
    bio_perc_female numeric,
    bio_length_f numeric,
    bio_weight_f numeric,
    bio_age_f numeric,
    bio_length_m numeric,
    bio_weight_m numeric,
    bio_age_m numeric,
    bio_comment text,
    bio_last_update date,
    bio_qal_id integer,
    bio_dts_datasource character varying(100),
    bio_number numeric
);


ALTER TABLE datawg.t_biometrygroupseries_bio OWNER TO postgres;

--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_id IS 'Internal use, an auto-incremented integer';


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_year; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_year IS 'year during which biological samples where collected';


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_length; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_length IS 'mean length in mm';


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_weight; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_weight IS 'mean individual weight in g';


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_age; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_age IS 'mean age';


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_perc_female; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_perc_female IS 'sex ratio expressed as a proportion of female ; between 0 (all males) and 100 (all females)';


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_length_f; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_length_f IS 'mean length in mm of the female fraction';


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_weight_f; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_weight_f IS 'mean individual weight in g of the female fraction';


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_age_f; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_age_f IS 'mean age of the female fraction';


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_length_m; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_length_m IS 'mean length in mm of the male fraction';


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_weight_m; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_weight_m IS 'mean individual weight in g of the male fraction';


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_age_m; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_age_m IS 'mean age of the male fraction';


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_comment; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_comment IS 'Comment (including comments about data quality for this year)';


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 295
-- Name: COLUMN t_biometrygroupseries_bio.bio_number; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometrygroupseries_bio.bio_number IS 'number of individual corresponding to the measures';


--
-- TOC entry 296 (class 1259 OID 2554336)
-- Name: t_biometry_bio_bio_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_biometry_bio_bio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_biometry_bio_bio_id_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 296
-- Name: t_biometry_bio_bio_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_biometry_bio_bio_id_seq OWNED BY datawg.t_biometrygroupseries_bio.bio_id;


--
-- TOC entry 297 (class 1259 OID 2554337)
-- Name: t_biometry_other_bit; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_biometry_other_bit (
    bit_loc_name text,
    bit_cou_code character varying(2),
    bit_emu_nameshort character varying(20),
    bit_area_division character varying(254),
    bit_hty_code character varying(2),
    bit_latitude numeric,
    bit_longitude numeric,
    bit_geom public.geometry(Point,3035),
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(bit_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((public.geometrytype(bit_geom) = 'POINT'::text) OR (bit_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(bit_geom) = 3035))
)
INHERITS (datawg.t_biometrygroupseries_bio);


ALTER TABLE datawg.t_biometry_other_bit OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_loc_name; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_loc_name IS 'name for the location where the sample where taken';


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_cou_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_cou_code IS 'country code, FOREIGN KEY to ref.tr_country_cou';


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_emu_nameshort; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_emu_nameshort IS 'The emu code, FOREIGN KEY to ref.tr_emu_emu';


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_area_division; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_area_division IS 'code of ICES area, FOREIGN KEY to ref.tr_faoareas(f_division)';


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_hty_code; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_hty_code IS 'habitat FOREIGN KEY to table t_habitattype_hty (F=Freshwater, MO=Marine Open,T=transitional...)';


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_latitude; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_latitude IS 'latitude EPSG:4326. WGS 84 (Google it)';


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_longitude; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_longitude IS 'longitude EPSG:4326. WGS 84 (Google it)';


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN t_biometry_other_bit.bit_geom; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_other_bit.bit_geom IS 'internal use, a postgis geometry point in EPSG:3035 (ETRS89 / ETRS-LAEA)';


--
-- TOC entry 298 (class 1259 OID 2554345)
-- Name: t_biometry_series_bis; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_biometry_series_bis (
    bis_g_in_gy numeric,
    bis_ser_id integer
)
INHERITS (datawg.t_biometrygroupseries_bio);


ALTER TABLE datawg.t_biometry_series_bis OWNER TO postgres;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_biometry_series_bis.bis_g_in_gy; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_biometry_series_bis.bis_g_in_gy IS 'proportion (in %) of glass eel [100 for only glass eel ; 0 for only yellow eel ; the proportion if mix of glass and yellow eel]';


--
-- TOC entry 299 (class 1259 OID 2554350)
-- Name: t_dataseries_das; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_dataseries_das (
    das_id integer NOT NULL,
    das_value real,
    das_ser_id integer NOT NULL,
    das_year integer,
    das_comment text,
    das_effort numeric,
    das_last_update date,
    das_qal_id integer,
    das_dts_datasource character varying(100),
    das_qal_comment text
);


ALTER TABLE datawg.t_dataseries_das OWNER TO postgres;

--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE t_dataseries_das; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON TABLE datawg.t_dataseries_das IS 'table holding the information on the series, one line per year
	an indication of the effort associated with the series is present for some of the series';


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_id IS 'Internal use, an auto-incremented integer';


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_value; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_value IS 'The value';


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_ser_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_ser_id IS 'Foreign key to join t_series_ser (id of the series) internal use';


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_year; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_year IS 'Year for the data';


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_comment; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_comment IS 'Comment for the particular year';


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_effort; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_effort IS 'Effort value if present (nb of electrofishing, nb of hauls)';


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_last_update; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_last_update IS 'Date of last update inserted automatically with a trigger';


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN t_dataseries_das.das_qal_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_dataseries_das.das_qal_id IS 'Code to assess the quality of the data, FOREIGN KEY on table ref.tr_quality_qal';


--
-- TOC entry 300 (class 1259 OID 2554355)
-- Name: t_dataseries_das_das_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_dataseries_das_das_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 10000000
    CACHE 1;


ALTER TABLE datawg.t_dataseries_das_das_id_seq OWNER TO postgres;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 300
-- Name: t_dataseries_das_das_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_dataseries_das_das_id_seq OWNED BY datawg.t_dataseries_das.das_id;


--
-- TOC entry 301 (class 1259 OID 2554356)
-- Name: t_eelstock_eel_eel_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_eelstock_eel_eel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_eelstock_eel_eel_id_seq OWNER TO postgres;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 301
-- Name: t_eelstock_eel_eel_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_eelstock_eel_eel_id_seq OWNED BY datawg.t_eelstock_eel.eel_id;


--
-- TOC entry 302 (class 1259 OID 2554357)
-- Name: t_fish_fi; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_fish_fi (
    fi_id integer NOT NULL,
    fi_date date,
    fi_year integer,
    fi_comment text,
    fi_lastupdate date DEFAULT CURRENT_DATE NOT NULL,
    fi_dts_datasource character varying(100),
    fi_lfs_code character varying(2),
    fi_id_cou character varying(50),
    CONSTRAINT ck_fi_date_fi_year CHECK (((fi_date IS NOT NULL) OR (fi_year IS NOT NULL)))
);


ALTER TABLE datawg.t_fish_fi OWNER TO wgeel;

--
-- TOC entry 303 (class 1259 OID 2554364)
-- Name: t_fish_fi_fi_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_fish_fi_fi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_fish_fi_fi_id_seq OWNER TO wgeel;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 303
-- Name: t_fish_fi_fi_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_fish_fi_fi_id_seq OWNED BY datawg.t_fish_fi.fi_id;


--
-- TOC entry 304 (class 1259 OID 2554365)
-- Name: t_fishsamp_fisa; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_fishsamp_fisa (
    fisa_sai_id integer,
    fisa_x_4326 numeric,
    fisa_y_4326 numeric,
    fisa_geom public.geometry(Point,4326),
    CONSTRAINT ck_fi_lfs_code CHECK ((fi_lfs_code IS NOT NULL))
)
INHERITS (datawg.t_fish_fi);


ALTER TABLE datawg.t_fishsamp_fisa OWNER TO wgeel;

--
-- TOC entry 305 (class 1259 OID 2554373)
-- Name: t_fishseries_fiser; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_fishseries_fiser (
    fiser_ser_id integer NOT NULL
)
INHERITS (datawg.t_fish_fi);


ALTER TABLE datawg.t_fishseries_fiser OWNER TO wgeel;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id IS 'Identifier, inherited from table t_fish_fi';


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_date; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_date IS 'Date of sampling, inherited from table t_fish_fi';


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_year; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_year IS 'The year of data collection, inherited from table t_fish_fi';


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_comment; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_comment IS 'Comment, inherited from table t_fish_fi';


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_lastupdate; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lastupdate IS 'Last change (auto) in the database, inherited from table t_fish_fi';


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_dts_datasource IS 'Datasource inherited from table t_fish_fi';


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_lfs_code; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_lfs_code IS 'Lifestage code, inherited from table t_fish_fi';


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fiser_ser_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fiser_ser_id IS 'Series id';


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN t_fishseries_fiser.fi_id_cou; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_fishseries_fiser.fi_id_cou IS 'Identifier used by data provider to identify the fish in its national database, inherited from table t_fish_fi';


--
-- TOC entry 306 (class 1259 OID 2554380)
-- Name: t_group_gr; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_group_gr (
    gr_id integer NOT NULL,
    gr_year integer,
    gr_number integer,
    gr_comment text,
    gr_lastupdate date DEFAULT CURRENT_DATE NOT NULL,
    gr_dts_datasource character varying(100)
);


ALTER TABLE datawg.t_group_gr OWNER TO wgeel;

--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_id IS 'Group ID, serial primary key';


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_year; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_year IS 'The year';


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_number; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_number IS 'Number of fish in the group';


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_comment; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_comment IS 'Comment on the group metric';


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_lastupdate; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_lastupdate IS 'Last update, inserted automatically';


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 306
-- Name: COLUMN t_group_gr.gr_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_group_gr.gr_dts_datasource IS 'Datasource see tr_datasource_dts';


--
-- TOC entry 307 (class 1259 OID 2554386)
-- Name: t_group_gr_gr_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_group_gr_gr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_group_gr_gr_id_seq OWNER TO wgeel;

--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 307
-- Name: t_group_gr_gr_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_group_gr_gr_id_seq OWNED BY datawg.t_group_gr.gr_id;


--
-- TOC entry 308 (class 1259 OID 2554387)
-- Name: t_groupsamp_grsa; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_groupsamp_grsa (
    grsa_sai_id integer,
    grsa_lfs_code character varying(2) NOT NULL
)
INHERITS (datawg.t_group_gr);


ALTER TABLE datawg.t_groupsamp_grsa OWNER TO wgeel;

--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_id IS 'Group ID, inherited from t_groupsamp_grsa';


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_year; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_year IS 'The year, inherited from t_group_gr';


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_number; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_number IS 'Number of fish in the group, inherited from t_group_gr';


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_comment; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_comment IS 'Comment, inherited from t_group_gr';


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_lastupdate; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_lastupdate IS 'The last updated date of the data';


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.gr_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.gr_dts_datasource IS 'Last change (auto) in the database, inherited from tablet_group_gr ';


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.grsa_sai_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.grsa_sai_id IS 'Sampling id from t_sampling_sai';


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN t_groupsamp_grsa.grsa_lfs_code; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupsamp_grsa.grsa_lfs_code IS 'Lifestage code';


--
-- TOC entry 309 (class 1259 OID 2554393)
-- Name: t_groupseries_grser; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_groupseries_grser (
    grser_ser_id integer NOT NULL
)
INHERITS (datawg.t_group_gr);


ALTER TABLE datawg.t_groupseries_grser OWNER TO wgeel;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_id IS 'Identifier of the group metrics data, this will be filled in automatically in the new_group_metrics and will be used in the updated_group_metrics';


--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_year; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_year IS 'Sampling year, inherited from t_group_gr';


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_number; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_number IS 'Number of measured individuals, inherited from t_group_gr';


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_comment; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_comment IS 'comment, inherited from t_group_gr';


--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_lastupdate; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_lastupdate IS 'Last change (auto) in the database, inherited from tablet_group_gr ';


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.gr_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.gr_dts_datasource IS 'Datasource inherited from t_group_gr see tr_datasource_dts';


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 309
-- Name: COLUMN t_groupseries_grser.grser_ser_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_groupseries_grser.grser_ser_id IS 'Series id';


--
-- TOC entry 310 (class 1259 OID 2554399)
-- Name: t_metricgroup_meg; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricgroup_meg (
    meg_id integer NOT NULL,
    meg_gr_id integer NOT NULL,
    meg_mty_id integer NOT NULL,
    meg_value numeric NOT NULL,
    meg_last_update date DEFAULT CURRENT_DATE NOT NULL,
    meg_qal_id integer,
    meg_dts_datasource character varying(100)
);


ALTER TABLE datawg.t_metricgroup_meg OWNER TO wgeel;

--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_id IS 'Group metric id';


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_gr_id IS 'Id of the group in t_group_gr';


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty';


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_value IS 'Value of the metric';


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_last_update IS 'Last change (auto) in the database';


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal';


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN t_metricgroup_meg.meg_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroup_meg.meg_dts_datasource IS 'Datasource see tr_datasource_dts';


--
-- TOC entry 311 (class 1259 OID 2554405)
-- Name: t_metricgroup_meg_meg_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_metricgroup_meg_meg_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_metricgroup_meg_meg_id_seq OWNER TO wgeel;

--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 311
-- Name: t_metricgroup_meg_meg_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_metricgroup_meg_meg_id_seq OWNED BY datawg.t_metricgroup_meg.meg_id;


--
-- TOC entry 312 (class 1259 OID 2554406)
-- Name: t_metricgroupsamp_megsa; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricgroupsamp_megsa (
)
INHERITS (datawg.t_metricgroup_meg);


ALTER TABLE datawg.t_metricgroupsamp_megsa OWNER TO wgeel;

--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_id IS 'Group metric id, inherited from t_groupseries_grser';


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_gr_id IS 'Group id, references tr_group_gr, inherited from t_groupseries_grser';


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from t_groupseries_grser';


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_value IS 'Value of the metric, inherited from t_groupseries_grser';


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_last_update IS 'Last change (auto) in the database, inherited from t_groupseries_grser';


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal, inherited from t_groupseries_grser';


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN t_metricgroupsamp_megsa.meg_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupsamp_megsa.meg_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from t_groupseries_grser';


--
-- TOC entry 313 (class 1259 OID 2554412)
-- Name: t_metricgroupseries_megser; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricgroupseries_megser (
)
INHERITS (datawg.t_metricgroup_meg);


ALTER TABLE datawg.t_metricgroupseries_megser OWNER TO wgeel;

--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_id IS 'Group metric id, inherited from t_groupseries_grser';


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_gr_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_gr_id IS 'Group id, references tr_group_gr, inherited from t_groupseries_grser';


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from t_groupseries_grser';


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_value IS 'Value of the metric, inherited from t_groupseries_grser';


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_last_update IS 'Last change (auto) in the database, inherited from t_groupseries_grser';


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_qal_id IS 'Quality id of the metric, see tr_quality_qal , inherited from t_groupseries_grser';


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN t_metricgroupseries_megser.meg_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricgroupseries_megser.meg_dts_datasource IS 'Datasource see tr_datasource_dts , inherited from t_groupseries_grser';


--
-- TOC entry 314 (class 1259 OID 2554418)
-- Name: t_metricind_mei; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricind_mei (
    mei_id integer NOT NULL,
    mei_fi_id integer NOT NULL,
    mei_mty_id integer NOT NULL,
    mei_value numeric NOT NULL,
    mei_last_update date DEFAULT CURRENT_DATE NOT NULL,
    mei_qal_id integer,
    mei_dts_datasource character varying(100)
);


ALTER TABLE datawg.t_metricind_mei OWNER TO wgeel;

--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_id IS 'Id of the individual metric';


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_fi_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_fi_id IS 'Fish id of the individual metric, see tr_fish_fi';


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty';


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_value IS 'Value of the metric';


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_last_update IS 'Last change (auto) in the database';


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,';


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 314
-- Name: COLUMN t_metricind_mei.mei_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricind_mei.mei_dts_datasource IS 'Datasource see tr_datasource_dts';


--
-- TOC entry 315 (class 1259 OID 2554424)
-- Name: t_metricind_mei_mei_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_metricind_mei_mei_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_metricind_mei_mei_id_seq OWNER TO wgeel;

--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 315
-- Name: t_metricind_mei_mei_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_metricind_mei_mei_id_seq OWNED BY datawg.t_metricind_mei.mei_id;


--
-- TOC entry 316 (class 1259 OID 2554425)
-- Name: t_metricindsamp_meisa; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricindsamp_meisa (
)
INHERITS (datawg.t_metricind_mei);


ALTER TABLE datawg.t_metricindsamp_meisa OWNER TO wgeel;

--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_id IS 'Id of the individual metric, inherited from table t_metricind_mei';


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_fi_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_fi_id IS 'Fish id of the individual metric, inherited from table t_metricind_mei';


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from table t_metricind_mei';


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_value IS 'Value of the metric, inherited from table t_metricind_mei';


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_last_update IS 'Last change (auto) in the database, inherited from table t_metricind_mei';


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,, inherited from table t_metricind_mei';


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 316
-- Name: COLUMN t_metricindsamp_meisa.mei_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindsamp_meisa.mei_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from table t_metricind_mei';


--
-- TOC entry 317 (class 1259 OID 2554431)
-- Name: t_metricindseries_meiser; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_metricindseries_meiser (
)
INHERITS (datawg.t_metricind_mei);


ALTER TABLE datawg.t_metricindseries_meiser OWNER TO wgeel;

--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_id IS 'Id of the individual metric, inherited from table t_metricind_mei';


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_fi_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_fi_id IS 'Fish id of the individual metric, inherited from table t_metricind_mei';


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_mty_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_mty_id IS 'Id of the metrictype see tr_metrictype_mty, inherited from table t_metricind_mei';


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_value; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_value IS 'Value of the metric, inherited from table t_metricind_mei';


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_last_update; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_last_update IS 'Last change (auto) in the database, inherited from table t_metricind_mei';


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_qal_id IS 'Quality id of the metric, see tr_quality_qal,, inherited from table t_metricind_mei';


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 317
-- Name: COLUMN t_metricindseries_meiser.mei_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_metricindseries_meiser.mei_dts_datasource IS 'Datasource see tr_datasource_dts, inherited from table t_metricind_mei';


--
-- TOC entry 366 (class 1259 OID 7922800)
-- Name: t_modeldata_dat; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_modeldata_dat (
    dat_id integer NOT NULL,
    dat_run_id integer NOT NULL,
    dat_ser_id integer NOT NULL,
    dat_ser_year integer NOT NULL,
    dat_das_value numeric,
    dat_das_qal_id integer
);


ALTER TABLE datawg.t_modeldata_dat OWNER TO postgres;

--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN t_modeldata_dat.dat_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_id IS 'Id of the data in the table of model data';


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN t_modeldata_dat.dat_run_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_run_id IS 'Id of the model run see t_modelrun_run';


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN t_modeldata_dat.dat_ser_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_id IS 'Series Id, see tr_series_ser';


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN t_modeldata_dat.dat_ser_year; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_ser_year IS 'Corresponds to das_year in the db, year of observation';


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN t_modeldata_dat.dat_das_value; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modeldata_dat.dat_das_value IS 'Value';


--
-- TOC entry 365 (class 1259 OID 7922799)
-- Name: t_modeldata_dat_dat_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_modeldata_dat_dat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_modeldata_dat_dat_id_seq OWNER TO postgres;

--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 365
-- Name: t_modeldata_dat_dat_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_modeldata_dat_dat_id_seq OWNED BY datawg.t_modeldata_dat.dat_id;


--
-- TOC entry 360 (class 1259 OID 7735052)
-- Name: t_modelrun_run; Type: TABLE; Schema: datawg; Owner: postgres
--

CREATE TABLE datawg.t_modelrun_run (
    run_id integer NOT NULL,
    run_date date NOT NULL,
    run_mod_nameshort text NOT NULL,
    run_description text
);


ALTER TABLE datawg.t_modelrun_run OWNER TO postgres;

--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN t_modelrun_run.run_id; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modelrun_run.run_id IS 'Id of the model run';


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN t_modelrun_run.run_date; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modelrun_run.run_date IS 'Date of the model run';


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN t_modelrun_run.run_mod_nameshort; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modelrun_run.run_mod_nameshort IS 'The short name of model';


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 360
-- Name: COLUMN t_modelrun_run.run_description; Type: COMMENT; Schema: datawg; Owner: postgres
--

COMMENT ON COLUMN datawg.t_modelrun_run.run_description IS 'Description of model';


--
-- TOC entry 359 (class 1259 OID 7735051)
-- Name: t_modelrun_run_run_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_modelrun_run_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_modelrun_run_run_id_seq OWNER TO postgres;

--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 359
-- Name: t_modelrun_run_run_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_modelrun_run_run_id_seq OWNED BY datawg.t_modelrun_run.run_id;


--
-- TOC entry 318 (class 1259 OID 2554437)
-- Name: t_samplinginfo_sai; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_samplinginfo_sai (
    sai_id integer NOT NULL,
    sai_name character varying(40),
    sai_cou_code character varying(2),
    sai_emu_nameshort character varying(20),
    sai_area_division character varying(254),
    sai_hty_code character varying(2),
    sai_comment text,
    sai_samplingobjective text,
    sai_samplingstrategy text,
    sai_protocol text,
    sai_qal_id integer,
    sai_lastupdate date DEFAULT CURRENT_DATE NOT NULL,
    sai_dts_datasource character varying(100)
);


ALTER TABLE datawg.t_samplinginfo_sai OWNER TO wgeel;

--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_id IS 'Identifier of the sampling scheme. If the sampling scheme does
 not already exist, please provide a code starting with emu name and few letters 
and/or an integer (e.g. FR_Adou_biom, FR_Adou_cont), primary key';


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_name; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_name IS 'Name of the sampling';


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_cou_code; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_cou_code IS 'Country code';


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_emu_nameshort; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_emu_nameshort IS 'EMU, see the codes of the emu (emu_nameshort) in table tr_emu_emu';


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_area_division; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_area_division IS 'Fao code of sea region (division level) see  tr_fao_area (column division)
(https://github.com/ices-eg/WGEEL/wiki). Do not provide an ICES area for freshwater, 
this is only for habitat  T, C and MO.';


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_hty_code; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_hty_code IS 'Habitat type see tr_habitattype_hty  (F=Freshwater, MO=Marine Open,T=transitional, AL=aggregate...)';


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_comment; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_comment IS 'Comment on sampling scheme';


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_samplingobjective; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_samplingobjective IS 'Indicate the program the data is coming from (e.g. EU DCF, GFCM etc.)';


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_samplingstrategy; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_samplingstrategy IS 'Indicate sampling scheme (e.g. commercial fisheries, scientific survey)';


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_protocol; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_protocol IS 'Description of the method used to capture fish and period of sampling';


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_qal_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_qal_id IS 'Sampling scheme quality id, used internally by the working group';


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_lastupdate; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_lastupdate IS 'Automatically generated';


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN t_samplinginfo_sai.sai_dts_datasource; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_samplinginfo_sai.sai_dts_datasource IS 'Automatically generated';


--
-- TOC entry 319 (class 1259 OID 2554443)
-- Name: t_samplinginfo_sai_sai_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_samplinginfo_sai_sai_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_samplinginfo_sai_sai_id_seq OWNER TO wgeel;

--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 319
-- Name: t_samplinginfo_sai_sai_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_samplinginfo_sai_sai_id_seq OWNED BY datawg.t_samplinginfo_sai.sai_id;


--
-- TOC entry 320 (class 1259 OID 2554444)
-- Name: t_series_ser_ser_id_seq; Type: SEQUENCE; Schema: datawg; Owner: postgres
--

CREATE SEQUENCE datawg.t_series_ser_ser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_series_ser_ser_id_seq OWNER TO postgres;

--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 320
-- Name: t_series_ser_ser_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: postgres
--

ALTER SEQUENCE datawg.t_series_ser_ser_id_seq OWNED BY datawg.t_series_ser.ser_id;


--
-- TOC entry 321 (class 1259 OID 2554445)
-- Name: t_seriesglm_sgl; Type: TABLE; Schema: datawg; Owner: wgeel
--

CREATE TABLE datawg.t_seriesglm_sgl (
    sgl_ser_id integer NOT NULL,
    sgl_year integer
);


ALTER TABLE datawg.t_seriesglm_sgl OWNER TO wgeel;

--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN t_seriesglm_sgl.sgl_ser_id; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_ser_id IS 'Series ID';


--
-- TOC entry 5355 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN t_seriesglm_sgl.sgl_year; Type: COMMENT; Schema: datawg; Owner: wgeel
--

COMMENT ON COLUMN datawg.t_seriesglm_sgl.sgl_year IS 'The year';


--
-- TOC entry 322 (class 1259 OID 2554448)
-- Name: t_seriesglm_sgl_sgl_ser_id_seq; Type: SEQUENCE; Schema: datawg; Owner: wgeel
--

CREATE SEQUENCE datawg.t_seriesglm_sgl_sgl_ser_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datawg.t_seriesglm_sgl_sgl_ser_id_seq OWNER TO wgeel;

--
-- TOC entry 5357 (class 0 OID 0)
-- Dependencies: 322
-- Name: t_seriesglm_sgl_sgl_ser_id_seq; Type: SEQUENCE OWNED BY; Schema: datawg; Owner: wgeel
--

ALTER SEQUENCE datawg.t_seriesglm_sgl_sgl_ser_id_seq OWNED BY datawg.t_seriesglm_sgl.sgl_ser_id;


--
-- TOC entry 323 (class 1259 OID 2554449)
-- Name: gear; Type: TABLE; Schema: public; Owner: wgeel
--

CREATE TABLE public.gear (
    gea_id double precision,
    gea_isscfg_code double precision,
    gea_nameen text
);


ALTER TABLE public.gear OWNER TO wgeel;

--
-- TOC entry 324 (class 1259 OID 2554454)
-- Name: temp_data_fr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_data_fr (
    eel_id integer NOT NULL,
    eel_typ_id integer NOT NULL,
    eel_year integer NOT NULL,
    eel_value numeric,
    eel_emu_nameshort character varying(20) NOT NULL,
    eel_cou_code character varying(2),
    eel_lfs_code character varying(2) NOT NULL,
    eel_hty_code character varying(2),
    eel_area_division character varying(254),
    eel_qal_id integer NOT NULL,
    eel_qal_comment text,
    eel_comment text,
    eel_datelastupdate date,
    eel_missvaluequal character varying(2),
    eel_datasource character varying(100),
    eel_dta_code text
);


ALTER TABLE public.temp_data_fr OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 2554459)
-- Name: temp_dataseries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_dataseries (
    das_id integer,
    das_value real,
    das_ser_id integer,
    das_year integer,
    das_comment text,
    das_effort numeric,
    das_last_update date,
    das_qal_id integer,
    das_dts_datasource character varying(100)
);


ALTER TABLE public.temp_dataseries OWNER TO postgres;

--
-- TOC entry 5362 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE temp_dataseries; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.temp_dataseries IS 'dataseries before integration';


--
-- TOC entry 326 (class 1259 OID 2554464)
-- Name: temp_dataserieslast; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_dataserieslast (
    das_id integer,
    das_value real,
    das_ser_id integer,
    das_year integer,
    das_comment text,
    das_effort numeric,
    das_last_update date,
    das_qal_id integer,
    das_dts_datasource character varying(100)
);


ALTER TABLE public.temp_dataserieslast OWNER TO postgres;

--
-- TOC entry 5364 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE temp_dataserieslast; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.temp_dataserieslast IS 'dataseries inserted during wgeel 2022 after the table was deleted';


--
-- TOC entry 327 (class 1259 OID 2554469)
-- Name: temp_groupsamp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_groupsamp (
    sai_name character varying(40),
    gr_id integer,
    gr_year integer,
    gr_number integer,
    gr_comment text,
    gr_lastupdate date,
    gr_dts_datasource character varying(100),
    grsa_sai_id integer,
    grsa_lfs_code character varying(2)
);


ALTER TABLE public.temp_groupsamp OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 2554474)
-- Name: temp_groupseries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_groupseries (
    ser_nameshort text,
    ser_id integer,
    gr_id integer,
    gr_year integer,
    gr_number integer,
    gr_comment text,
    gr_lastupdate date,
    gr_dts_datasource character varying(100),
    grser_ser_id integer
);


ALTER TABLE public.temp_groupseries OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 2554479)
-- Name: temp_groupseries0609; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_groupseries0609 (
    ser_nameshort text,
    ser_id integer,
    gr_id integer,
    gr_year integer,
    gr_number integer,
    gr_comment text,
    gr_lastupdate date,
    gr_dts_datasource character varying(100),
    grser_ser_id integer
);


ALTER TABLE public.temp_groupseries0609 OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 2554484)
-- Name: temp_removed_mort_biom_spain_2021; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_removed_mort_biom_spain_2021 (
    eel_id integer,
    eel_typ_id integer,
    eel_year integer,
    eel_value numeric,
    eel_emu_nameshort character varying(20),
    eel_cou_code character varying(2),
    eel_lfs_code character varying(2),
    eel_hty_code character varying(2),
    eel_area_division character varying(254),
    eel_qal_id integer,
    eel_qal_comment text,
    eel_comment text,
    eel_datelastupdate date,
    eel_missvaluequal character varying(2),
    eel_datasource character varying(100),
    eel_dta_code text
);


ALTER TABLE public.temp_removed_mort_biom_spain_2021 OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 2554489)
-- Name: temp_t_eelstock_eel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.temp_t_eelstock_eel (
    eel_id integer,
    eel_typ_id integer,
    eel_year integer,
    eel_value numeric,
    eel_emu_nameshort character varying(20),
    eel_cou_code character varying(2),
    eel_lfs_code character varying(2),
    eel_hty_code character varying(2),
    eel_area_division character varying(254),
    eel_qal_id integer,
    eel_qal_comment text,
    eel_comment text,
    eel_datelastupdate date,
    eel_missvaluequal character varying(2),
    eel_datasource character varying(100),
    eel_dta_code text
);


ALTER TABLE public.temp_t_eelstock_eel OWNER TO postgres;

--
-- TOC entry 332 (class 1259 OID 2554494)
-- Name: tr_dataaccess_dta; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_dataaccess_dta (
    dta_code text NOT NULL,
    dta_description text
);


ALTER TABLE ref.tr_dataaccess_dta OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 2554499)
-- Name: tr_datasource_dts; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_datasource_dts (
    dts_datasource character varying(100) NOT NULL,
    dts_description text
);


ALTER TABLE ref.tr_datasource_dts OWNER TO postgres;

--
-- TOC entry 5372 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE tr_datasource_dts; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON TABLE ref.tr_datasource_dts IS 'source of data';


--
-- TOC entry 334 (class 1259 OID 2554504)
-- Name: tr_emusplit_ems; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_emusplit_ems (
    gid integer NOT NULL,
    emu_nameshort character varying(7),
    emu_name character varying(100),
    emu_cou_code text,
    emu_hyd_syst_s character varying(50),
    emu_sea character varying(50),
    sum numeric,
    geom public.geometry,
    centre public.geometry,
    x numeric,
    y numeric,
    emu_cty_id character varying(2),
    meu_dist_sargasso_km numeric,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(geom) = 2)),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(geom) = 4326))
);


ALTER TABLE ref.tr_emusplit_ems OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 2554511)
-- Name: tr_emusplit_ems_gid_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_emusplit_ems_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_emusplit_ems_gid_seq OWNER TO postgres;

--
-- TOC entry 5375 (class 0 OID 0)
-- Dependencies: 335
-- Name: tr_emusplit_ems_gid_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_emusplit_ems_gid_seq OWNED BY ref.tr_emusplit_ems.gid;


--
-- TOC entry 336 (class 1259 OID 2554512)
-- Name: tr_faoareas; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_faoareas (
    gid integer NOT NULL,
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
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE ref.tr_faoareas OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 2554517)
-- Name: tr_faoareas_gid_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_faoareas_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_faoareas_gid_seq OWNER TO postgres;

--
-- TOC entry 5378 (class 0 OID 0)
-- Dependencies: 337
-- Name: tr_faoareas_gid_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_faoareas_gid_seq OWNED BY ref.tr_faoareas.gid;


--
-- TOC entry 338 (class 1259 OID 2554518)
-- Name: tr_gear_gea; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_gear_gea (
    gea_id integer NOT NULL,
    gea_issscfg_code text,
    gea_name_en text
);


ALTER TABLE ref.tr_gear_gea OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 2554523)
-- Name: tr_ices_ecoregions; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_ices_ecoregions (
    gid integer NOT NULL,
    ecoregion character varying(254),
    shape_leng numeric,
    shape_le_1 numeric,
    shape_area numeric,
    geom public.geometry(MultiPolygon,4326)
);


ALTER TABLE ref.tr_ices_ecoregions OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 2554528)
-- Name: tr_ices_ecoregions_gid_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_ices_ecoregions_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_ices_ecoregions_gid_seq OWNER TO postgres;

--
-- TOC entry 5382 (class 0 OID 0)
-- Dependencies: 340
-- Name: tr_ices_ecoregions_gid_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_ices_ecoregions_gid_seq OWNED BY ref.tr_ices_ecoregions.gid;


--
-- TOC entry 341 (class 1259 OID 2554529)
-- Name: tr_metrictype_mty; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_metrictype_mty (
    mty_id integer NOT NULL,
    mty_name text,
    mty_individual_name text,
    mty_description text,
    mty_type text,
    mty_method text,
    mty_uni_code character varying(20),
    mty_group text,
    mty_min numeric,
    mty_max numeric,
    CONSTRAINT c_ck_mty_group CHECK (((mty_group = 'individual'::text) OR (mty_group = 'group'::text) OR (mty_group = 'both'::text))),
    CONSTRAINT c_ck_mty_type CHECK (((mty_type = 'quality'::text) OR (mty_type = 'biometry'::text) OR (mty_type = 'migration'::text)))
);


ALTER TABLE ref.tr_metrictype_mty OWNER TO postgres;

--
-- TOC entry 5384 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN tr_metrictype_mty.mty_individual_name; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_metrictype_mty.mty_individual_name IS 'In datacall spreadsheets, names replaced by those for better reading';


--
-- TOC entry 5385 (class 0 OID 0)
-- Dependencies: 341
-- Name: COLUMN tr_metrictype_mty.mty_group; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_metrictype_mty.mty_group IS 'Indicate whether the variable can be use for individual, group, or both';


--
-- TOC entry 342 (class 1259 OID 2554536)
-- Name: tr_metrictype_mty_mty_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_metrictype_mty_mty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_metrictype_mty_mty_id_seq OWNER TO postgres;

--
-- TOC entry 5387 (class 0 OID 0)
-- Dependencies: 342
-- Name: tr_metrictype_mty_mty_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_metrictype_mty_mty_id_seq OWNED BY ref.tr_metrictype_mty.mty_id;


--
-- TOC entry 358 (class 1259 OID 7735044)
-- Name: tr_model_mod; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_model_mod (
    mod_nameshort text NOT NULL,
    mod_description text
);


ALTER TABLE ref.tr_model_mod OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 2554537)
-- Name: tr_samplingtype_sam_sam_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_samplingtype_sam_sam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_samplingtype_sam_sam_id_seq OWNER TO postgres;

--
-- TOC entry 5389 (class 0 OID 0)
-- Dependencies: 343
-- Name: tr_samplingtype_sam_sam_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_samplingtype_sam_sam_id_seq OWNED BY ref.tr_samplingtype_sam.sam_id;


--
-- TOC entry 344 (class 1259 OID 2554538)
-- Name: tr_sea_sea; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_sea_sea (
    sea_o character varying(50) NOT NULL,
    sea_s character varying(50) NOT NULL,
    sea_code character varying(2) NOT NULL
);


ALTER TABLE ref.tr_sea_sea OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 2554541)
-- Name: tr_station; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_station (
    "tblCodeID" double precision NOT NULL,
    "Station_Code" double precision,
    "Country" text,
    "Organisation" text,
    "Station_Name" text,
    "WLTYP" text,
    "Lat" double precision,
    "Lon" double precision,
    "StartYear" double precision,
    "EndYear" double precision,
    "PURPM" text,
    "Notes" text
);


ALTER TABLE ref.tr_station OWNER TO postgres;

--
-- TOC entry 5392 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN tr_station."Country"; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_station."Country" IS 'country responsible of the data collection ?';


--
-- TOC entry 5393 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN tr_station."WLTYP"; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_station."WLTYP" IS 'Water and land station types ';


--
-- TOC entry 5394 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN tr_station."PURPM"; Type: COMMENT; Schema: ref; Owner: postgres
--

COMMENT ON COLUMN ref.tr_station."PURPM" IS 'Purpose of monitoring http://vocab.ices.dk/?ref=1399';


--
-- TOC entry 346 (class 1259 OID 2554546)
-- Name: tr_typeseries_typ_typ_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.tr_typeseries_typ_typ_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ref.tr_typeseries_typ_typ_id_seq OWNER TO postgres;

--
-- TOC entry 5396 (class 0 OID 0)
-- Dependencies: 346
-- Name: tr_typeseries_typ_typ_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.tr_typeseries_typ_typ_id_seq OWNED BY ref.tr_typeseries_typ.typ_id;


--
-- TOC entry 347 (class 1259 OID 2554547)
-- Name: tr_units_uni; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.tr_units_uni (
    uni_code character varying(20) NOT NULL,
    uni_name text NOT NULL
);


ALTER TABLE ref.tr_units_uni OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 7185274)
-- Name: datacall_stats_2023; Type: TABLE; Schema: tempo; Owner: wgeel
--

CREATE TABLE tempo.datacall_stats_2023 (
    cou character varying(2),
    annex text,
    n bigint
);


ALTER TABLE tempo.datacall_stats_2023 OWNER TO wgeel;

--
-- TOC entry 348 (class 1259 OID 2554552)
-- Name: litterature; Type: TABLE; Schema: wkeelmigration; Owner: postgres
--

CREATE TABLE wkeelmigration.litterature (
    id integer NOT NULL,
    geom public.geometry(Point,4326),
    "Author" character varying,
    "Year of publication" integer,
    "Type" character varying,
    "Reference" character varying,
    "Area FAO" character varying,
    "Country" character varying,
    "EMU" character varying,
    "Site" character varying,
    "Lat" double precision,
    "Lon" double precision,
    habitat character varying,
    "Surface/Catchment area" character varying,
    "Distance from sea/length of the channel" character varying,
    "Barrier/sluice/gate" character varying,
    "Other" character varying,
    "Y/N" character varying,
    "Management period" character varying,
    "Migration type" character varying,
    stage character varying,
    "Data type" character varying,
    "Data frequency" character varying,
    "Monitoring typology" character varying,
    "Gear" character varying,
    "Year/s of observation" character varying,
    "Jan" character varying,
    "Feb" double precision,
    "Mar" double precision,
    "Apr" character varying,
    "May" character varying,
    "June" character varying,
    "July" double precision,
    "Aug" double precision,
    "Sept" double precision,
    "Oct" double precision,
    "Nov" character varying,
    "Dec" double precision,
    "Total" character varying,
    "Quality of data" character varying,
    "Other info" character varying,
    "Notes" character varying,
    field_41 character varying,
    field_42 character varying,
    field_43 character varying,
    habitat_type text,
    stage2 text
);


ALTER TABLE wkeelmigration.litterature OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 2554557)
-- Name: Literature_table_final_id_seq; Type: SEQUENCE; Schema: wkeelmigration; Owner: postgres
--

CREATE SEQUENCE wkeelmigration."Literature_table_final_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wkeelmigration."Literature_table_final_id_seq" OWNER TO postgres;

--
-- TOC entry 5401 (class 0 OID 0)
-- Dependencies: 349
-- Name: Literature_table_final_id_seq; Type: SEQUENCE OWNED BY; Schema: wkeelmigration; Owner: postgres
--

ALTER SEQUENCE wkeelmigration."Literature_table_final_id_seq" OWNED BY wkeelmigration.litterature.id;


--
-- TOC entry 350 (class 1259 OID 2554558)
-- Name: closure; Type: TABLE; Schema: wkeelmigration; Owner: wgeel
--

CREATE TABLE wkeelmigration.closure (
    typ_name text,
    country text,
    emu_nameshort text,
    lfs_code text,
    hty_code text,
    year double precision,
    month text,
    duplicate integer,
    fishery_closure_percent double precision,
    fishery_closure_type text,
    reason_for_closure text,
    comment text
);


ALTER TABLE wkeelmigration.closure OWNER TO wgeel;

--
-- TOC entry 351 (class 1259 OID 2554563)
-- Name: litteratured; Type: TABLE; Schema: wkeelmigration; Owner: postgres
--

CREATE TABLE wkeelmigration.litteratured (
    "Author" character varying,
    stage2 text,
    first_year text,
    last_year text,
    habitat_type text,
    geom public.geometry(Point,4326),
    id integer NOT NULL
);


ALTER TABLE wkeelmigration.litteratured OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 2554568)
-- Name: litteratured_id_seq; Type: SEQUENCE; Schema: wkeelmigration; Owner: postgres
--

CREATE SEQUENCE wkeelmigration.litteratured_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wkeelmigration.litteratured_id_seq OWNER TO postgres;

--
-- TOC entry 5403 (class 0 OID 0)
-- Dependencies: 352
-- Name: litteratured_id_seq; Type: SEQUENCE OWNED BY; Schema: wkeelmigration; Owner: postgres
--

ALTER SEQUENCE wkeelmigration.litteratured_id_seq OWNED BY wkeelmigration.litteratured.id;


--
-- TOC entry 353 (class 1259 OID 2554569)
-- Name: t_monitoring_mon; Type: TABLE; Schema: wkeelmigration; Owner: wgeel
--

CREATE TABLE wkeelmigration.t_monitoring_mon (
    mon_ser_nameshort text,
    mon_value double precision,
    mon_year double precision,
    mon_month double precision,
    mon_comment text,
    mon_effort double precision,
    mon_source text,
    mon_country text,
    mon_datasource text
);


ALTER TABLE wkeelmigration.t_monitoring_mon OWNER TO wgeel;

--
-- TOC entry 354 (class 1259 OID 2554574)
-- Name: t_seriesseasonality_ser; Type: TABLE; Schema: wkeelmigration; Owner: wgeel
--

CREATE TABLE wkeelmigration.t_seriesseasonality_ser (
    ser_nameshort text,
    ser_nameshort_base text,
    existing boolean,
    ser_namelong text,
    ser_typ_id text,
    ser_effort_uni_code text,
    ser_comment text,
    ser_uni_code text,
    ser_lfs_code text,
    ser_hty_code text,
    ser_locationdescription text,
    ser_emu_nameshort text,
    ser_cou_code text,
    ser_area_division text,
    ser_tblcodeid text,
    ser_x double precision,
    ser_y double precision
);


ALTER TABLE wkeelmigration.t_seriesseasonality_ser OWNER TO wgeel;

--
-- TOC entry 4622 (class 2604 OID 2554579)
-- Name: log log_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.log ALTER COLUMN log_id SET DEFAULT nextval('datawg.log_log_id_seq'::regclass);


--
-- TOC entry 4630 (class 2604 OID 2554580)
-- Name: t_biometry_other_bit bio_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_other_bit ALTER COLUMN bio_id SET DEFAULT nextval('datawg.t_biometry_bio_bio_id_seq'::regclass);


--
-- TOC entry 4634 (class 2604 OID 2554581)
-- Name: t_biometry_series_bis bio_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_series_bis ALTER COLUMN bio_id SET DEFAULT nextval('datawg.t_biometry_bio_bio_id_seq'::regclass);


--
-- TOC entry 4629 (class 2604 OID 2554582)
-- Name: t_biometrygroupseries_bio bio_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometrygroupseries_bio ALTER COLUMN bio_id SET DEFAULT nextval('datawg.t_biometry_bio_bio_id_seq'::regclass);


--
-- TOC entry 4635 (class 2604 OID 2554583)
-- Name: t_dataseries_das das_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_dataseries_das ALTER COLUMN das_id SET DEFAULT nextval('datawg.t_dataseries_das_das_id_seq'::regclass);


--
-- TOC entry 4609 (class 2604 OID 2554584)
-- Name: t_eelstock_eel eel_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel ALTER COLUMN eel_id SET DEFAULT nextval('datawg.t_eelstock_eel_eel_id_seq'::regclass);


--
-- TOC entry 4637 (class 2604 OID 2554585)
-- Name: t_fish_fi fi_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fish_fi ALTER COLUMN fi_id SET DEFAULT nextval('datawg.t_fish_fi_fi_id_seq'::regclass);


--
-- TOC entry 4639 (class 2604 OID 2554586)
-- Name: t_fishsamp_fisa fi_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishsamp_fisa ALTER COLUMN fi_id SET DEFAULT nextval('datawg.t_fish_fi_fi_id_seq'::regclass);


--
-- TOC entry 4640 (class 2604 OID 2554587)
-- Name: t_fishsamp_fisa fi_lastupdate; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishsamp_fisa ALTER COLUMN fi_lastupdate SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4643 (class 2604 OID 2554588)
-- Name: t_fishseries_fiser fi_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishseries_fiser ALTER COLUMN fi_id SET DEFAULT nextval('datawg.t_fish_fi_fi_id_seq'::regclass);


--
-- TOC entry 4644 (class 2604 OID 2554589)
-- Name: t_fishseries_fiser fi_lastupdate; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishseries_fiser ALTER COLUMN fi_lastupdate SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4647 (class 2604 OID 2554590)
-- Name: t_group_gr gr_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_group_gr ALTER COLUMN gr_id SET DEFAULT nextval('datawg.t_group_gr_gr_id_seq'::regclass);


--
-- TOC entry 4648 (class 2604 OID 2554591)
-- Name: t_groupsamp_grsa gr_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa ALTER COLUMN gr_id SET DEFAULT nextval('datawg.t_group_gr_gr_id_seq'::regclass);


--
-- TOC entry 4649 (class 2604 OID 2554592)
-- Name: t_groupsamp_grsa gr_lastupdate; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa ALTER COLUMN gr_lastupdate SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4650 (class 2604 OID 2554593)
-- Name: t_groupseries_grser gr_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupseries_grser ALTER COLUMN gr_id SET DEFAULT nextval('datawg.t_group_gr_gr_id_seq'::regclass);


--
-- TOC entry 4651 (class 2604 OID 2554594)
-- Name: t_groupseries_grser gr_lastupdate; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupseries_grser ALTER COLUMN gr_lastupdate SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4653 (class 2604 OID 2554595)
-- Name: t_metricgroup_meg meg_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg ALTER COLUMN meg_id SET DEFAULT nextval('datawg.t_metricgroup_meg_meg_id_seq'::regclass);


--
-- TOC entry 4654 (class 2604 OID 2554596)
-- Name: t_metricgroupsamp_megsa meg_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa ALTER COLUMN meg_id SET DEFAULT nextval('datawg.t_metricgroup_meg_meg_id_seq'::regclass);


--
-- TOC entry 4655 (class 2604 OID 2554597)
-- Name: t_metricgroupsamp_megsa meg_last_update; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa ALTER COLUMN meg_last_update SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4656 (class 2604 OID 2554598)
-- Name: t_metricgroupseries_megser meg_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser ALTER COLUMN meg_id SET DEFAULT nextval('datawg.t_metricgroup_meg_meg_id_seq'::regclass);


--
-- TOC entry 4657 (class 2604 OID 2554599)
-- Name: t_metricgroupseries_megser meg_last_update; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser ALTER COLUMN meg_last_update SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4659 (class 2604 OID 2554600)
-- Name: t_metricind_mei mei_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei ALTER COLUMN mei_id SET DEFAULT nextval('datawg.t_metricind_mei_mei_id_seq'::regclass);


--
-- TOC entry 4660 (class 2604 OID 2554601)
-- Name: t_metricindsamp_meisa mei_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa ALTER COLUMN mei_id SET DEFAULT nextval('datawg.t_metricind_mei_mei_id_seq'::regclass);


--
-- TOC entry 4661 (class 2604 OID 2554602)
-- Name: t_metricindsamp_meisa mei_last_update; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa ALTER COLUMN mei_last_update SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4662 (class 2604 OID 2554603)
-- Name: t_metricindseries_meiser mei_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser ALTER COLUMN mei_id SET DEFAULT nextval('datawg.t_metricind_mei_mei_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 2554604)
-- Name: t_metricindseries_meiser mei_last_update; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser ALTER COLUMN mei_last_update SET DEFAULT CURRENT_DATE;


--
-- TOC entry 4678 (class 2604 OID 7922803)
-- Name: t_modeldata_dat dat_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modeldata_dat ALTER COLUMN dat_id SET DEFAULT nextval('datawg.t_modeldata_dat_dat_id_seq'::regclass);


--
-- TOC entry 4677 (class 2604 OID 7735055)
-- Name: t_modelrun_run run_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modelrun_run ALTER COLUMN run_id SET DEFAULT nextval('datawg.t_modelrun_run_run_id_seq'::regclass);


--
-- TOC entry 4665 (class 2604 OID 2554605)
-- Name: t_samplinginfo_sai sai_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai ALTER COLUMN sai_id SET DEFAULT nextval('datawg.t_samplinginfo_sai_sai_id_seq'::regclass);


--
-- TOC entry 4623 (class 2604 OID 2554606)
-- Name: t_series_ser ser_id; Type: DEFAULT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser ALTER COLUMN ser_id SET DEFAULT nextval('datawg.t_series_ser_ser_id_seq'::regclass);


--
-- TOC entry 4666 (class 2604 OID 2554607)
-- Name: t_seriesglm_sgl sgl_ser_id; Type: DEFAULT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_seriesglm_sgl ALTER COLUMN sgl_ser_id SET DEFAULT nextval('datawg.t_seriesglm_sgl_sgl_ser_id_seq'::regclass);


--
-- TOC entry 4667 (class 2604 OID 2554608)
-- Name: tr_emusplit_ems gid; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emusplit_ems ALTER COLUMN gid SET DEFAULT nextval('ref.tr_emusplit_ems_gid_seq'::regclass);


--
-- TOC entry 4670 (class 2604 OID 2554609)
-- Name: tr_faoareas gid; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_faoareas ALTER COLUMN gid SET DEFAULT nextval('ref.tr_faoareas_gid_seq'::regclass);


--
-- TOC entry 4671 (class 2604 OID 2554610)
-- Name: tr_ices_ecoregions gid; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_ices_ecoregions ALTER COLUMN gid SET DEFAULT nextval('ref.tr_ices_ecoregions_gid_seq'::regclass);


--
-- TOC entry 4672 (class 2604 OID 2554611)
-- Name: tr_metrictype_mty mty_id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_metrictype_mty ALTER COLUMN mty_id SET DEFAULT nextval('ref.tr_metrictype_mty_mty_id_seq'::regclass);


--
-- TOC entry 4628 (class 2604 OID 2554612)
-- Name: tr_samplingtype_sam sam_id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_samplingtype_sam ALTER COLUMN sam_id SET DEFAULT nextval('ref.tr_samplingtype_sam_sam_id_seq'::regclass);


--
-- TOC entry 4617 (class 2604 OID 2554613)
-- Name: tr_typeseries_typ typ_id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_typeseries_typ ALTER COLUMN typ_id SET DEFAULT nextval('ref.tr_typeseries_typ_typ_id_seq'::regclass);


--
-- TOC entry 4675 (class 2604 OID 2554614)
-- Name: litterature id; Type: DEFAULT; Schema: wkeelmigration; Owner: postgres
--

ALTER TABLE ONLY wkeelmigration.litterature ALTER COLUMN id SET DEFAULT nextval('wkeelmigration."Literature_table_final_id_seq"'::regclass);


--
-- TOC entry 4676 (class 2604 OID 2554615)
-- Name: litteratured id; Type: DEFAULT; Schema: wkeelmigration; Owner: postgres
--

ALTER TABLE ONLY wkeelmigration.litteratured ALTER COLUMN id SET DEFAULT nextval('wkeelmigration.litteratured_id_seq'::regclass);


--
-- TOC entry 4741 (class 2606 OID 2555199)
-- Name: t_groupsamp_grsa c_ck_uk_grsa_gr; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa
    ADD CONSTRAINT c_ck_uk_grsa_gr UNIQUE (grsa_sai_id, gr_year, grsa_lfs_code);


--
-- TOC entry 4746 (class 2606 OID 2555201)
-- Name: t_groupseries_grser c_ck_uk_grser_gr; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupseries_grser
    ADD CONSTRAINT c_ck_uk_grser_gr UNIQUE (grser_ser_id, gr_year);


--
-- TOC entry 4751 (class 2606 OID 2555203)
-- Name: t_metricgroup_meg c_ck_uk_meg_gr; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT c_ck_uk_meg_gr UNIQUE (meg_gr_id, meg_mty_id);


--
-- TOC entry 4756 (class 2606 OID 2555205)
-- Name: t_metricgroupsamp_megsa c_ck_uk_megsa_gr; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa
    ADD CONSTRAINT c_ck_uk_megsa_gr UNIQUE (meg_gr_id, meg_mty_id);


--
-- TOC entry 4759 (class 2606 OID 2555207)
-- Name: t_metricgroupseries_megser c_ck_uk_megser_gr; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser
    ADD CONSTRAINT c_ck_uk_megser_gr UNIQUE (meg_gr_id, meg_mty_id);


--
-- TOC entry 4714 (class 2606 OID 2555209)
-- Name: participants c_pk_name; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.participants
    ADD CONSTRAINT c_pk_name PRIMARY KEY (name);


--
-- TOC entry 4770 (class 2606 OID 2555211)
-- Name: t_samplinginfo_sai c_uk_sai_name; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_uk_sai_name UNIQUE (sai_name);


--
-- TOC entry 4772 (class 2606 OID 2555213)
-- Name: t_samplinginfo_sai ch_unique_sai_name; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT ch_unique_sai_name UNIQUE (sai_name);


--
-- TOC entry 4728 (class 2606 OID 2555215)
-- Name: t_dataseries_das das_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_dataseries_das
    ADD CONSTRAINT das_pkey PRIMARY KEY (das_id);


--
-- TOC entry 4712 (class 2606 OID 2555217)
-- Name: log log_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4724 (class 2606 OID 2555219)
-- Name: t_biometrygroupseries_bio t_biometry_bio_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometrygroupseries_bio
    ADD CONSTRAINT t_biometry_bio_pkey PRIMARY KEY (bio_id);


--
-- TOC entry 4710 (class 2606 OID 2555221)
-- Name: t_eelstock_eel_percent t_eelstock_eel_percent_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_eelstock_eel_percent
    ADD CONSTRAINT t_eelstock_eel_percent_pkey PRIMARY KEY (percent_id);


--
-- TOC entry 4694 (class 2606 OID 2555223)
-- Name: t_eelstock_eel t_eelstock_eel_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT t_eelstock_eel_pkey PRIMARY KEY (eel_id);


--
-- TOC entry 4731 (class 2606 OID 2555225)
-- Name: t_fish_fi t_fish_fi_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fish_fi
    ADD CONSTRAINT t_fish_fi_pkey PRIMARY KEY (fi_id);


--
-- TOC entry 4734 (class 2606 OID 2555227)
-- Name: t_fishsamp_fisa t_fishseries_fisa_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishsamp_fisa
    ADD CONSTRAINT t_fishseries_fisa_pkey PRIMARY KEY (fi_id);


--
-- TOC entry 4737 (class 2606 OID 2555229)
-- Name: t_fishseries_fiser t_fishseries_fiser_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishseries_fiser
    ADD CONSTRAINT t_fishseries_fiser_pkey PRIMARY KEY (fi_id);


--
-- TOC entry 4739 (class 2606 OID 2555231)
-- Name: t_group_gr t_group_go_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_group_gr
    ADD CONSTRAINT t_group_go_pkey PRIMARY KEY (gr_id);


--
-- TOC entry 4744 (class 2606 OID 2555233)
-- Name: t_groupsamp_grsa t_group_gsa_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa
    ADD CONSTRAINT t_group_gsa_pkey PRIMARY KEY (gr_id);


--
-- TOC entry 4749 (class 2606 OID 2555235)
-- Name: t_groupseries_grser t_group_gser_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupseries_grser
    ADD CONSTRAINT t_group_gser_pkey PRIMARY KEY (gr_id);


--
-- TOC entry 4754 (class 2606 OID 2555237)
-- Name: t_metricgroup_meg t_metricgroup_meg_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT t_metricgroup_meg_pkey PRIMARY KEY (meg_id);


--
-- TOC entry 4763 (class 2606 OID 2555239)
-- Name: t_metricind_mei t_metricind_mei_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei
    ADD CONSTRAINT t_metricind_mei_pkey PRIMARY KEY (mei_id);


--
-- TOC entry 4774 (class 2606 OID 2555241)
-- Name: t_samplinginfo_sai t_samplinginfo_sai_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT t_samplinginfo_sai_pkey PRIMARY KEY (sai_id);


--
-- TOC entry 4716 (class 2606 OID 2555243)
-- Name: t_series_ser t_series_ser_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT t_series_ser_pkey PRIMARY KEY (ser_id);


--
-- TOC entry 4776 (class 2606 OID 2555245)
-- Name: t_seriesglm_sgl t_seriesglm_sgl_pkey; Type: CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_seriesglm_sgl
    ADD CONSTRAINT t_seriesglm_sgl_pkey PRIMARY KEY (sgl_ser_id);


--
-- TOC entry 4818 (class 2606 OID 7922807)
-- Name: t_modeldata_dat tr_model_mod_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modeldata_dat
    ADD CONSTRAINT tr_model_mod_pkey PRIMARY KEY (dat_id);


--
-- TOC entry 4816 (class 2606 OID 7735059)
-- Name: t_modelrun_run tr_modelrun_run_pkey; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modelrun_run
    ADD CONSTRAINT tr_modelrun_run_pkey PRIMARY KEY (run_id);


--
-- TOC entry 4718 (class 2606 OID 2555247)
-- Name: t_series_ser unique_name_short; Type: CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT unique_name_short UNIQUE (ser_nameshort);


--
-- TOC entry 4720 (class 2606 OID 2555249)
-- Name: tr_samplingtype_sam c_pk_sam_samplingtype; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_samplingtype_sam
    ADD CONSTRAINT c_pk_sam_samplingtype PRIMARY KEY (sam_id);


--
-- TOC entry 4802 (class 2606 OID 2555251)
-- Name: tr_sea_sea c_pk_sea; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_sea_sea
    ADD CONSTRAINT c_pk_sea PRIMARY KEY (sea_code);


--
-- TOC entry 4780 (class 2606 OID 2555253)
-- Name: tr_datasource_dts c_pk_tr_datasource_dts; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_datasource_dts
    ADD CONSTRAINT c_pk_tr_datasource_dts PRIMARY KEY (dts_datasource);


--
-- TOC entry 4786 (class 2606 OID 2555255)
-- Name: tr_faoareas c_uk_f_division; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_faoareas
    ADD CONSTRAINT c_uk_f_division UNIQUE (f_division);


--
-- TOC entry 4788 (class 2606 OID 2555257)
-- Name: tr_faoareas c_uk_fid; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_faoareas
    ADD CONSTRAINT c_uk_fid UNIQUE (fid);


--
-- TOC entry 4722 (class 2606 OID 2555259)
-- Name: tr_samplingtype_sam c_uk_sam_samplingtype; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_samplingtype_sam
    ADD CONSTRAINT c_uk_sam_samplingtype UNIQUE (sam_samplingtype);


--
-- TOC entry 4702 (class 2606 OID 2555261)
-- Name: tr_lifestage_lfs pk_lfs; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_lifestage_lfs
    ADD CONSTRAINT pk_lfs PRIMARY KEY (lfs_code);


--
-- TOC entry 4806 (class 2606 OID 2555263)
-- Name: tr_units_uni pk_uni; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_units_uni
    ADD CONSTRAINT pk_uni PRIMARY KEY (uni_code);


--
-- TOC entry 4784 (class 2606 OID 2555265)
-- Name: tr_emusplit_ems t_emuagreg_ema_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emusplit_ems
    ADD CONSTRAINT t_emuagreg_ema_pkey PRIMARY KEY (gid);


--
-- TOC entry 4696 (class 2606 OID 2555267)
-- Name: tr_country_cou tr_country_cou_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_country_cou
    ADD CONSTRAINT tr_country_cou_pkey PRIMARY KEY (cou_code);


--
-- TOC entry 4778 (class 2606 OID 2555269)
-- Name: tr_dataaccess_dta tr_dataaccess_dta_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_dataaccess_dta
    ADD CONSTRAINT tr_dataaccess_dta_pkey PRIMARY KEY (dta_code);


--
-- TOC entry 4698 (class 2606 OID 2555271)
-- Name: tr_emu_emu tr_emu_emu_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emu_emu
    ADD CONSTRAINT tr_emu_emu_pkey PRIMARY KEY (emu_nameshort, emu_cou_code);


--
-- TOC entry 4791 (class 2606 OID 2555273)
-- Name: tr_faoareas tr_faoareas_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_faoareas
    ADD CONSTRAINT tr_faoareas_pkey PRIMARY KEY (gid);


--
-- TOC entry 4793 (class 2606 OID 2555275)
-- Name: tr_gear_gea tr_gear_gea_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_gear_gea
    ADD CONSTRAINT tr_gear_gea_pkey PRIMARY KEY (gea_id);


--
-- TOC entry 4700 (class 2606 OID 2555277)
-- Name: tr_habitattype_hty tr_habitattype_hty_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_habitattype_hty
    ADD CONSTRAINT tr_habitattype_hty_pkey PRIMARY KEY (hty_code);


--
-- TOC entry 4796 (class 2606 OID 2555279)
-- Name: tr_ices_ecoregions tr_ices_ecoregions_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_ices_ecoregions
    ADD CONSTRAINT tr_ices_ecoregions_pkey PRIMARY KEY (gid);


--
-- TOC entry 4798 (class 2606 OID 2555281)
-- Name: tr_metrictype_mty tr_metrictype_mty_mty_individual_name_key; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_metrictype_mty
    ADD CONSTRAINT tr_metrictype_mty_mty_individual_name_key UNIQUE (mty_individual_name);


--
-- TOC entry 4800 (class 2606 OID 2555283)
-- Name: tr_metrictype_mty tr_metrictype_mty_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_metrictype_mty
    ADD CONSTRAINT tr_metrictype_mty_pkey PRIMARY KEY (mty_id);


--
-- TOC entry 4814 (class 2606 OID 7735050)
-- Name: tr_model_mod tr_model_mod_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_model_mod
    ADD CONSTRAINT tr_model_mod_pkey PRIMARY KEY (mod_nameshort);


--
-- TOC entry 4706 (class 2606 OID 2555285)
-- Name: tr_quality_qal tr_quality_qal_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_quality_qal
    ADD CONSTRAINT tr_quality_qal_pkey PRIMARY KEY (qal_id);


--
-- TOC entry 4804 (class 2606 OID 2555287)
-- Name: tr_station tr_station_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_station
    ADD CONSTRAINT tr_station_pkey PRIMARY KEY ("tblCodeID");


--
-- TOC entry 4708 (class 2606 OID 2555289)
-- Name: tr_typeseries_typ typ_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_typeseries_typ
    ADD CONSTRAINT typ_pkey PRIMARY KEY (typ_id);


--
-- TOC entry 4704 (class 2606 OID 2555291)
-- Name: tr_lifestage_lfs uk_lfs_name; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_lifestage_lfs
    ADD CONSTRAINT uk_lfs_name UNIQUE (lfs_name);


--
-- TOC entry 4808 (class 2606 OID 2555293)
-- Name: tr_units_uni uk_uni_name; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_units_uni
    ADD CONSTRAINT uk_uni_name UNIQUE (uni_name);


--
-- TOC entry 4810 (class 2606 OID 2555295)
-- Name: litterature Literature_table_final_pkey; Type: CONSTRAINT; Schema: wkeelmigration; Owner: postgres
--

ALTER TABLE ONLY wkeelmigration.litterature
    ADD CONSTRAINT "Literature_table_final_pkey" PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 2555297)
-- Name: litteratured litteratured_pkey; Type: CONSTRAINT; Schema: wkeelmigration; Owner: postgres
--

ALTER TABLE ONLY wkeelmigration.litteratured
    ADD CONSTRAINT litteratured_pkey PRIMARY KEY (id);


--
-- TOC entry 4725 (class 1259 OID 2555298)
-- Name: idx_biometry_series1; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_biometry_series1 ON datawg.t_biometry_series_bis USING btree (bio_year, bio_lfs_code, bis_ser_id, bio_qal_id) WHERE (bio_qal_id IS NOT NULL);


--
-- TOC entry 4726 (class 1259 OID 2555299)
-- Name: idx_biometry_series2; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_biometry_series2 ON datawg.t_biometry_series_bis USING btree (bio_year, bio_lfs_code, bis_ser_id) WHERE (bio_qal_id IS NULL);


--
-- TOC entry 4729 (class 1259 OID 2555300)
-- Name: idx_dataseries_1; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_dataseries_1 ON datawg.t_dataseries_das USING btree (das_year, das_ser_id) WHERE ((das_qal_id IS NULL) OR (das_qal_id < 5));


--
-- TOC entry 4689 (class 1259 OID 2555301)
-- Name: idx_eelstock_1; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_eelstock_1 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id, eel_area_division) WHERE ((eel_hty_code IS NOT NULL) AND (eel_area_division IS NOT NULL));


--
-- TOC entry 4690 (class 1259 OID 2555302)
-- Name: idx_eelstock_2; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_eelstock_2 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_qal_id, eel_area_division) WHERE ((eel_hty_code IS NULL) AND (eel_area_division IS NOT NULL));


--
-- TOC entry 4691 (class 1259 OID 2555303)
-- Name: idx_eelstock_3; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_eelstock_3 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id) WHERE ((eel_hty_code IS NOT NULL) AND (eel_area_division IS NULL));


--
-- TOC entry 4692 (class 1259 OID 2555304)
-- Name: idx_eelstock_4; Type: INDEX; Schema: datawg; Owner: postgres
--

CREATE UNIQUE INDEX idx_eelstock_4 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_qal_id) WHERE ((eel_hty_code IS NULL) AND (eel_area_division IS NULL));


--
-- TOC entry 4732 (class 1259 OID 2555305)
-- Name: idx_fishsa_fk; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX idx_fishsa_fk ON datawg.t_fishsamp_fisa USING btree (fisa_sai_id);


--
-- TOC entry 4735 (class 1259 OID 2555306)
-- Name: idx_fishser_fk; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX idx_fishser_fk ON datawg.t_fishseries_fiser USING btree (fiser_ser_id);


--
-- TOC entry 4742 (class 1259 OID 2555307)
-- Name: idx_groupsa_fk; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX idx_groupsa_fk ON datawg.t_groupsamp_grsa USING btree (grsa_sai_id);


--
-- TOC entry 4747 (class 1259 OID 2555308)
-- Name: idx_groupser_fk; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX idx_groupser_fk ON datawg.t_groupseries_grser USING btree (grser_ser_id);


--
-- TOC entry 4752 (class 1259 OID 2555309)
-- Name: t_meg_group_gr_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_meg_group_gr_fkey ON datawg.t_metricgroup_meg USING btree (meg_gr_id);


--
-- TOC entry 4757 (class 1259 OID 2555310)
-- Name: t_meg_group_grsa_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_meg_group_grsa_fkey ON datawg.t_metricgroupsamp_megsa USING btree (meg_gr_id);


--
-- TOC entry 4760 (class 1259 OID 2555311)
-- Name: t_meg_group_grser_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_meg_group_grser_fkey ON datawg.t_metricgroupseries_megser USING btree (meg_gr_id);


--
-- TOC entry 4761 (class 1259 OID 2555312)
-- Name: t_mei_fish_fi_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_mei_fish_fi_fkey ON datawg.t_metricind_mei USING btree (mei_fi_id);


--
-- TOC entry 4764 (class 1259 OID 2555313)
-- Name: t_mei_fish_fisa_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_mei_fish_fisa_fkey ON datawg.t_metricindsamp_meisa USING btree (mei_fi_id);


--
-- TOC entry 4767 (class 1259 OID 2555314)
-- Name: t_mei_fish_fiser_fkey; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_mei_fish_fiser_fkey ON datawg.t_metricindseries_meiser USING btree (mei_fi_id);


--
-- TOC entry 4765 (class 1259 OID 2555315)
-- Name: t_metricindsamp_meisa_mei_fi_id_idx; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_metricindsamp_meisa_mei_fi_id_idx ON datawg.t_metricindsamp_meisa USING btree (mei_fi_id);


--
-- TOC entry 4766 (class 1259 OID 2555316)
-- Name: t_metricindsamp_meisa_mei_fi_id_idx1; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_metricindsamp_meisa_mei_fi_id_idx1 ON datawg.t_metricindsamp_meisa USING btree (mei_fi_id);


--
-- TOC entry 4768 (class 1259 OID 2555317)
-- Name: t_metricindseries_meiser_mei_fi_id_idx; Type: INDEX; Schema: datawg; Owner: wgeel
--

CREATE INDEX t_metricindseries_meiser_mei_fi_id_idx ON datawg.t_metricindseries_meiser USING btree (mei_fi_id);


--
-- TOC entry 4781 (class 1259 OID 2555318)
-- Name: id_tr_emusplit_ems; Type: INDEX; Schema: ref; Owner: postgres
--

CREATE INDEX id_tr_emusplit_ems ON ref.tr_emusplit_ems USING gist (geom);


--
-- TOC entry 4782 (class 1259 OID 2555319)
-- Name: idxbtree_t_emusplit_ems; Type: INDEX; Schema: ref; Owner: postgres
--

CREATE INDEX idxbtree_t_emusplit_ems ON ref.tr_emusplit_ems USING btree (gid);


--
-- TOC entry 4789 (class 1259 OID 2555320)
-- Name: tr_faoareas_geom_gist; Type: INDEX; Schema: ref; Owner: postgres
--

CREATE INDEX tr_faoareas_geom_gist ON ref.tr_faoareas USING gist (geom);


--
-- TOC entry 4794 (class 1259 OID 2555321)
-- Name: tr_ices_ecoregions_geom_gist; Type: INDEX; Schema: ref; Owner: postgres
--

CREATE INDEX tr_ices_ecoregions_geom_gist ON ref.tr_ices_ecoregions USING gist (geom);


--
-- TOC entry 5098 (class 2618 OID 7184010)
-- Name: series_stats _RETURN; Type: RULE; Schema: datawg; Owner: postgres
--

CREATE OR REPLACE VIEW datawg.series_stats AS
 SELECT t_series_ser.ser_id,
    t_series_ser.ser_nameshort AS site,
    t_series_ser.ser_namelong AS namelong,
    min(t_dataseries_das.das_year) AS min,
    max(t_dataseries_das.das_year) AS max,
    ((max(t_dataseries_das.das_year) - min(t_dataseries_das.das_year)) + 1) AS duration,
    (((max(t_dataseries_das.das_year) - min(t_dataseries_das.das_year)) + 1) - count(*)) AS missing
   FROM ((datawg.t_dataseries_das
     JOIN datawg.t_series_ser ON ((t_dataseries_das.das_ser_id = t_series_ser.ser_id)))
     LEFT JOIN ref.tr_country_cou ON (((t_series_ser.ser_cou_code)::text = (tr_country_cou.cou_code)::text)))
  WHERE (t_dataseries_das.das_qal_id = ANY (ARRAY[1, 2, 4]))
  GROUP BY t_series_ser.ser_id, tr_country_cou.cou_order
  ORDER BY tr_country_cou.cou_order;


--
-- TOC entry 4916 (class 2620 OID 2555323)
-- Name: t_fishsamp_fisa check_fish_in_emu; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_fish_in_emu AFTER INSERT OR UPDATE ON datawg.t_fishsamp_fisa FOR EACH ROW EXECUTE FUNCTION datawg.fish_in_emu();


--
-- TOC entry 4923 (class 2620 OID 2555324)
-- Name: t_metricgroup_meg check_meg_mty_is_group; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();


--
-- TOC entry 4925 (class 2620 OID 2555325)
-- Name: t_metricgroupsamp_megsa check_meg_mty_is_group; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON datawg.t_metricgroupsamp_megsa FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();


--
-- TOC entry 4927 (class 2620 OID 2555326)
-- Name: t_metricgroupseries_megser check_meg_mty_is_group; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_meg_mty_is_group AFTER INSERT OR UPDATE ON datawg.t_metricgroupseries_megser FOR EACH ROW EXECUTE FUNCTION datawg.meg_mty_is_group();


--
-- TOC entry 4929 (class 2620 OID 2555327)
-- Name: t_metricind_mei check_mei_mty_is_individual; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_mei_mty_is_individual AFTER INSERT OR UPDATE ON datawg.t_metricind_mei FOR EACH ROW EXECUTE FUNCTION datawg.mei_mty_is_individual();


--
-- TOC entry 4931 (class 2620 OID 7183697)
-- Name: t_metricindsamp_meisa check_meisa_mty_is_individual; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_meisa_mty_is_individual AFTER INSERT OR UPDATE ON datawg.t_metricindsamp_meisa FOR EACH ROW EXECUTE FUNCTION datawg.mei_mty_is_individual();


--
-- TOC entry 4933 (class 2620 OID 7183696)
-- Name: t_metricindseries_meiser check_meiser_mty_is_individual; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_meiser_mty_is_individual AFTER INSERT OR UPDATE ON datawg.t_metricindseries_meiser FOR EACH ROW EXECUTE FUNCTION datawg.mei_mty_is_individual();


--
-- TOC entry 4918 (class 2620 OID 2555328)
-- Name: t_fishseries_fiser check_year_and_date; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER check_year_and_date AFTER INSERT OR UPDATE ON datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fi_year();


--
-- TOC entry 4910 (class 2620 OID 7182776)
-- Name: t_eelstock_eel trg_check_emu_whole_aquaculture; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER INSERT OR UPDATE ON datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.checkemu_whole_country();


--
-- TOC entry 4907 (class 2620 OID 2555330)
-- Name: t_eelstock_eel trg_check_no_ices_area; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER trg_check_no_ices_area AFTER INSERT OR UPDATE ON datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.check_no_ices_area();


--
-- TOC entry 4908 (class 2620 OID 2555331)
-- Name: t_eelstock_eel trg_check_the_stage; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER trg_check_the_stage AFTER INSERT OR UPDATE ON datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.check_the_stage();


--
-- TOC entry 4913 (class 2620 OID 2555332)
-- Name: t_biometrygroupseries_bio update_bio_time; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER update_bio_time BEFORE INSERT OR UPDATE ON datawg.t_biometrygroupseries_bio FOR EACH ROW EXECUTE FUNCTION datawg.update_bio_last_update();


--
-- TOC entry 4912 (class 2620 OID 7184067)
-- Name: t_series_ser update_coordinates; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER update_coordinates BEFORE UPDATE OF geom ON datawg.t_series_ser FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION datawg.update_coordinates();


--
-- TOC entry 4914 (class 2620 OID 2555334)
-- Name: t_dataseries_das update_das_time; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER update_das_time BEFORE INSERT OR UPDATE ON datawg.t_dataseries_das FOR EACH ROW EXECUTE FUNCTION datawg.update_das_last_update();


--
-- TOC entry 4909 (class 2620 OID 2555335)
-- Name: t_eelstock_eel update_eel_time; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER update_eel_time BEFORE INSERT OR UPDATE ON datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.update_eel_last_update();


--
-- TOC entry 4915 (class 2620 OID 2555336)
-- Name: t_fish_fi update_fi_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_fish_fi FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();


--
-- TOC entry 4917 (class 2620 OID 2555337)
-- Name: t_fishsamp_fisa update_fi_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_fishsamp_fisa FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();


--
-- TOC entry 4919 (class 2620 OID 2555338)
-- Name: t_fishseries_fiser update_fi_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_fi_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_fishseries_fiser FOR EACH ROW EXECUTE FUNCTION datawg.fi_lastupdate();


--
-- TOC entry 4911 (class 2620 OID 7184066)
-- Name: t_series_ser update_geom; Type: TRIGGER; Schema: datawg; Owner: postgres
--

CREATE TRIGGER update_geom BEFORE INSERT OR UPDATE OF ser_x, ser_y ON datawg.t_series_ser FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION datawg.update_geom();


--
-- TOC entry 4920 (class 2620 OID 2555340)
-- Name: t_group_gr update_gr_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_gr_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_group_gr FOR EACH ROW EXECUTE FUNCTION datawg.gr_lastupdate();


--
-- TOC entry 4921 (class 2620 OID 2555341)
-- Name: t_groupsamp_grsa update_gr_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_gr_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_groupsamp_grsa FOR EACH ROW EXECUTE FUNCTION datawg.gr_lastupdate();


--
-- TOC entry 4922 (class 2620 OID 2555342)
-- Name: t_groupseries_grser update_gr_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_gr_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_groupseries_grser FOR EACH ROW EXECUTE FUNCTION datawg.gr_lastupdate();


--
-- TOC entry 4924 (class 2620 OID 2555343)
-- Name: t_metricgroup_meg update_meg_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION datawg.meg_last_update();


--
-- TOC entry 4926 (class 2620 OID 2555344)
-- Name: t_metricgroupsamp_megsa update_meg_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricgroupsamp_megsa FOR EACH ROW EXECUTE FUNCTION datawg.meg_last_update();


--
-- TOC entry 4928 (class 2620 OID 2555345)
-- Name: t_metricgroupseries_megser update_meg_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_meg_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricgroupseries_megser FOR EACH ROW EXECUTE FUNCTION datawg.meg_last_update();


--
-- TOC entry 4930 (class 2620 OID 2555346)
-- Name: t_metricind_mei update_mei_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_mei_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricind_mei FOR EACH ROW EXECUTE FUNCTION datawg.mei_last_update();


--
-- TOC entry 4932 (class 2620 OID 7183699)
-- Name: t_metricindsamp_meisa update_meisa_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_meisa_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricindsamp_meisa FOR EACH ROW EXECUTE FUNCTION datawg.mei_last_update();


--
-- TOC entry 4934 (class 2620 OID 7183698)
-- Name: t_metricindseries_meiser update_meiser_last_update; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_meiser_last_update BEFORE INSERT OR UPDATE ON datawg.t_metricindseries_meiser FOR EACH ROW EXECUTE FUNCTION datawg.mei_last_update();


--
-- TOC entry 4935 (class 2620 OID 2555347)
-- Name: t_samplinginfo_sai update_sai_lastupdate; Type: TRIGGER; Schema: datawg; Owner: wgeel
--

CREATE TRIGGER update_sai_lastupdate BEFORE INSERT OR UPDATE ON datawg.t_samplinginfo_sai FOR EACH ROW EXECUTE FUNCTION datawg.sai_lastupdate();


--
-- TOC entry 4833 (class 2606 OID 2555348)
-- Name: t_series_ser c_fk_area_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_area_code FOREIGN KEY (ser_area_division) REFERENCES ref.tr_faoareas(f_division) ON UPDATE CASCADE;


--
-- TOC entry 4819 (class 2606 OID 2555353)
-- Name: t_eelstock_eel c_fk_area_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_area_code FOREIGN KEY (eel_area_division) REFERENCES ref.tr_faoareas(f_division) ON UPDATE CASCADE;


--
-- TOC entry 4849 (class 2606 OID 2555358)
-- Name: t_biometry_other_bit c_fk_area_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_other_bit
    ADD CONSTRAINT c_fk_area_code FOREIGN KEY (bit_area_division) REFERENCES ref.tr_faoareas(f_division) ON UPDATE CASCADE;


--
-- TOC entry 4846 (class 2606 OID 2555363)
-- Name: t_biometrygroupseries_bio c_fk_bio_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometrygroupseries_bio
    ADD CONSTRAINT c_fk_bio_dts_datasource FOREIGN KEY (bio_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource);


--
-- TOC entry 4853 (class 2606 OID 2555368)
-- Name: t_biometry_series_bis c_fk_bio_series_bis_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_series_bis
    ADD CONSTRAINT c_fk_bio_series_bis_dts_datasource FOREIGN KEY (bio_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource);


--
-- TOC entry 4834 (class 2606 OID 2555373)
-- Name: t_series_ser c_fk_cou_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_cou_code FOREIGN KEY (ser_cou_code) REFERENCES ref.tr_country_cou(cou_code);


--
-- TOC entry 4820 (class 2606 OID 2555378)
-- Name: t_eelstock_eel c_fk_cou_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_cou_code FOREIGN KEY (eel_cou_code) REFERENCES ref.tr_country_cou(cou_code);


--
-- TOC entry 4850 (class 2606 OID 2555383)
-- Name: t_biometry_other_bit c_fk_cou_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_other_bit
    ADD CONSTRAINT c_fk_cou_code FOREIGN KEY (bit_cou_code) REFERENCES ref.tr_country_cou(cou_code);


--
-- TOC entry 4855 (class 2606 OID 2555388)
-- Name: t_dataseries_das c_fk_das_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_dataseries_das
    ADD CONSTRAINT c_fk_das_dts_datasource FOREIGN KEY (das_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource);


--
-- TOC entry 4905 (class 2606 OID 7922808)
-- Name: t_modeldata_dat c_fk_dat_run_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modeldata_dat
    ADD CONSTRAINT c_fk_dat_run_id FOREIGN KEY (dat_run_id) REFERENCES datawg.t_modelrun_run(run_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4906 (class 2606 OID 7922813)
-- Name: t_modeldata_dat c_fk_dat_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modeldata_dat
    ADD CONSTRAINT c_fk_dat_ser_id FOREIGN KEY (dat_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4821 (class 2606 OID 2555393)
-- Name: t_eelstock_eel c_fk_eel_dta_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_eel_dta_code FOREIGN KEY (eel_dta_code) REFERENCES ref.tr_dataaccess_dta(dta_code) ON UPDATE CASCADE;


--
-- TOC entry 4835 (class 2606 OID 2555398)
-- Name: t_series_ser c_fk_emu; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_emu FOREIGN KEY (ser_emu_nameshort, ser_cou_code) REFERENCES ref.tr_emu_emu(emu_nameshort, emu_cou_code);


--
-- TOC entry 4822 (class 2606 OID 2555403)
-- Name: t_eelstock_eel c_fk_emu; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_emu FOREIGN KEY (eel_emu_nameshort, eel_cou_code) REFERENCES ref.tr_emu_emu(emu_nameshort, emu_cou_code);


--
-- TOC entry 4851 (class 2606 OID 2555408)
-- Name: t_biometry_other_bit c_fk_emu; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_other_bit
    ADD CONSTRAINT c_fk_emu FOREIGN KEY (bit_emu_nameshort, bit_cou_code) REFERENCES ref.tr_emu_emu(emu_nameshort, emu_cou_code);


--
-- TOC entry 4858 (class 2606 OID 2555413)
-- Name: t_fish_fi c_fk_fi_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fish_fi
    ADD CONSTRAINT c_fk_fi_dts_datasource FOREIGN KEY (fi_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4859 (class 2606 OID 2555418)
-- Name: t_fish_fi c_fk_fi_lfs_code; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fish_fi
    ADD CONSTRAINT c_fk_fi_lfs_code FOREIGN KEY (fi_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE;


--
-- TOC entry 4860 (class 2606 OID 2555423)
-- Name: t_fishsamp_fisa c_fk_fisa_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishsamp_fisa
    ADD CONSTRAINT c_fk_fisa_dts_datasource FOREIGN KEY (fi_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 2555428)
-- Name: t_fishsamp_fisa c_fk_fisa_sai_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishsamp_fisa
    ADD CONSTRAINT c_fk_fisa_sai_id FOREIGN KEY (fisa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4862 (class 2606 OID 2555433)
-- Name: t_fishseries_fiser c_fk_fiser_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishseries_fiser
    ADD CONSTRAINT c_fk_fiser_dts_datasource FOREIGN KEY (fi_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4863 (class 2606 OID 2555438)
-- Name: t_fishseries_fiser c_fk_fiser_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_fishseries_fiser
    ADD CONSTRAINT c_fk_fiser_ser_id FOREIGN KEY (fiser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 2555443)
-- Name: t_group_gr c_fk_gr_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_group_gr
    ADD CONSTRAINT c_fk_gr_dts_datasource FOREIGN KEY (gr_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 2555448)
-- Name: t_groupsamp_grsa c_fk_grsa_lfs_code; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa
    ADD CONSTRAINT c_fk_grsa_lfs_code FOREIGN KEY (grsa_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE;


--
-- TOC entry 4866 (class 2606 OID 2555453)
-- Name: t_groupsamp_grsa c_fk_grsa_sai_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupsamp_grsa
    ADD CONSTRAINT c_fk_grsa_sai_id FOREIGN KEY (grsa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id);


--
-- TOC entry 4867 (class 2606 OID 2555458)
-- Name: t_groupseries_grser c_fk_grser_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_groupseries_grser
    ADD CONSTRAINT c_fk_grser_ser_id FOREIGN KEY (grser_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4836 (class 2606 OID 2555463)
-- Name: t_series_ser c_fk_hty_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_hty_code FOREIGN KEY (ser_hty_code) REFERENCES ref.tr_habitattype_hty(hty_code) ON UPDATE CASCADE;


--
-- TOC entry 4823 (class 2606 OID 2555468)
-- Name: t_eelstock_eel c_fk_hty_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_hty_code FOREIGN KEY (eel_hty_code) REFERENCES ref.tr_habitattype_hty(hty_code) ON UPDATE CASCADE;


--
-- TOC entry 4852 (class 2606 OID 2555473)
-- Name: t_biometry_other_bit c_fk_hty_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_other_bit
    ADD CONSTRAINT c_fk_hty_code FOREIGN KEY (bit_hty_code) REFERENCES ref.tr_habitattype_hty(hty_code) ON UPDATE CASCADE;


--
-- TOC entry 4837 (class 2606 OID 2555478)
-- Name: t_series_ser c_fk_lfs_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_lfs_code FOREIGN KEY (ser_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE;


--
-- TOC entry 4824 (class 2606 OID 2555483)
-- Name: t_eelstock_eel c_fk_lfs_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_lfs_code FOREIGN KEY (eel_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE;


--
-- TOC entry 4847 (class 2606 OID 2555488)
-- Name: t_biometrygroupseries_bio c_fk_lfs_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometrygroupseries_bio
    ADD CONSTRAINT c_fk_lfs_code FOREIGN KEY (bio_lfs_code) REFERENCES ref.tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE;


--
-- TOC entry 4868 (class 2606 OID 2555493)
-- Name: t_metricgroup_meg c_fk_meg_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT c_fk_meg_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4869 (class 2606 OID 2555498)
-- Name: t_metricgroup_meg c_fk_meg_gr_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT c_fk_meg_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_group_gr(gr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4870 (class 2606 OID 2555503)
-- Name: t_metricgroup_meg c_fk_meg_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT c_fk_meg_mty_id FOREIGN KEY (meg_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4871 (class 2606 OID 2555508)
-- Name: t_metricgroup_meg c_fk_meg_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroup_meg
    ADD CONSTRAINT c_fk_meg_qal_id FOREIGN KEY (meg_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4872 (class 2606 OID 2555513)
-- Name: t_metricgroupsamp_megsa c_fk_megsa_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa
    ADD CONSTRAINT c_fk_megsa_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4873 (class 2606 OID 2555518)
-- Name: t_metricgroupsamp_megsa c_fk_megsa_gr_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa
    ADD CONSTRAINT c_fk_megsa_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_groupsamp_grsa(gr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4874 (class 2606 OID 2555523)
-- Name: t_metricgroupsamp_megsa c_fk_megsa_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa
    ADD CONSTRAINT c_fk_megsa_mty_id FOREIGN KEY (meg_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4875 (class 2606 OID 2555528)
-- Name: t_metricgroupsamp_megsa c_fk_megsa_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupsamp_megsa
    ADD CONSTRAINT c_fk_megsa_qal_id FOREIGN KEY (meg_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4876 (class 2606 OID 2555533)
-- Name: t_metricgroupseries_megser c_fk_megser_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser
    ADD CONSTRAINT c_fk_megser_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4877 (class 2606 OID 2555538)
-- Name: t_metricgroupseries_megser c_fk_megser_gr_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser
    ADD CONSTRAINT c_fk_megser_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_groupseries_grser(gr_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4878 (class 2606 OID 2555543)
-- Name: t_metricgroupseries_megser c_fk_megser_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser
    ADD CONSTRAINT c_fk_megser_mty_id FOREIGN KEY (meg_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4879 (class 2606 OID 2555548)
-- Name: t_metricgroupseries_megser c_fk_megser_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricgroupseries_megser
    ADD CONSTRAINT c_fk_megser_qal_id FOREIGN KEY (meg_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4880 (class 2606 OID 2555553)
-- Name: t_metricind_mei c_fk_mei_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei
    ADD CONSTRAINT c_fk_mei_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4881 (class 2606 OID 2555558)
-- Name: t_metricind_mei c_fk_mei_fi_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei
    ADD CONSTRAINT c_fk_mei_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fish_fi(fi_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4882 (class 2606 OID 2555563)
-- Name: t_metricind_mei c_fk_mei_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei
    ADD CONSTRAINT c_fk_mei_mty_id FOREIGN KEY (mei_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4883 (class 2606 OID 2555568)
-- Name: t_metricind_mei c_fk_mei_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricind_mei
    ADD CONSTRAINT c_fk_mei_qal_id FOREIGN KEY (mei_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4884 (class 2606 OID 2555573)
-- Name: t_metricindsamp_meisa c_fk_meisa_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa
    ADD CONSTRAINT c_fk_meisa_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4885 (class 2606 OID 2555578)
-- Name: t_metricindsamp_meisa c_fk_meisa_fi_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa
    ADD CONSTRAINT c_fk_meisa_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishsamp_fisa(fi_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4886 (class 2606 OID 2555583)
-- Name: t_metricindsamp_meisa c_fk_meisa_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa
    ADD CONSTRAINT c_fk_meisa_mty_id FOREIGN KEY (mei_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4887 (class 2606 OID 2555588)
-- Name: t_metricindsamp_meisa c_fk_meisa_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindsamp_meisa
    ADD CONSTRAINT c_fk_meisa_qal_id FOREIGN KEY (mei_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4888 (class 2606 OID 2555593)
-- Name: t_metricindseries_meiser c_fk_meiser_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser
    ADD CONSTRAINT c_fk_meiser_dts_datasource FOREIGN KEY (mei_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4889 (class 2606 OID 2555598)
-- Name: t_metricindseries_meiser c_fk_meiser_fi_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser
    ADD CONSTRAINT c_fk_meiser_fi_id FOREIGN KEY (mei_fi_id) REFERENCES datawg.t_fishseries_fiser(fi_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4890 (class 2606 OID 2555603)
-- Name: t_metricindseries_meiser c_fk_meiser_mty_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser
    ADD CONSTRAINT c_fk_meiser_mty_id FOREIGN KEY (mei_mty_id) REFERENCES ref.tr_metrictype_mty(mty_id) ON UPDATE CASCADE;


--
-- TOC entry 4891 (class 2606 OID 2555608)
-- Name: t_metricindseries_meiser c_fk_meiser_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_metricindseries_meiser
    ADD CONSTRAINT c_fk_meiser_qal_id FOREIGN KEY (mei_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4856 (class 2606 OID 2555613)
-- Name: t_dataseries_das c_fk_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_dataseries_das
    ADD CONSTRAINT c_fk_qal_id FOREIGN KEY (das_qal_id) REFERENCES ref.tr_quality_qal(qal_id);


--
-- TOC entry 4838 (class 2606 OID 2555618)
-- Name: t_series_ser c_fk_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_qal_id FOREIGN KEY (ser_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4825 (class 2606 OID 2555623)
-- Name: t_eelstock_eel c_fk_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_qal_id FOREIGN KEY (eel_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4848 (class 2606 OID 2555628)
-- Name: t_biometrygroupseries_bio c_fk_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometrygroupseries_bio
    ADD CONSTRAINT c_fk_qal_id FOREIGN KEY (bio_qal_id) REFERENCES ref.tr_quality_qal(qal_id);


--
-- TOC entry 4904 (class 2606 OID 7735060)
-- Name: t_modelrun_run c_fk_run_mod_nameshort; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_modelrun_run
    ADD CONSTRAINT c_fk_run_mod_nameshort FOREIGN KEY (run_mod_nameshort) REFERENCES ref.tr_model_mod(mod_nameshort) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4892 (class 2606 OID 2555633)
-- Name: t_samplinginfo_sai c_fk_sai_area_division; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_area_division FOREIGN KEY (sai_area_division) REFERENCES ref.tr_faoareas(f_division) ON UPDATE CASCADE;


--
-- TOC entry 4893 (class 2606 OID 2555638)
-- Name: t_samplinginfo_sai c_fk_sai_cou_code; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_cou_code FOREIGN KEY (sai_cou_code) REFERENCES ref.tr_country_cou(cou_code) ON UPDATE CASCADE;


--
-- TOC entry 4894 (class 2606 OID 2555643)
-- Name: t_samplinginfo_sai c_fk_sai_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_dts_datasource FOREIGN KEY (sai_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource) ON UPDATE CASCADE;


--
-- TOC entry 4895 (class 2606 OID 2555648)
-- Name: t_samplinginfo_sai c_fk_sai_emu; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_emu FOREIGN KEY (sai_emu_nameshort, sai_cou_code) REFERENCES ref.tr_emu_emu(emu_nameshort, emu_cou_code) ON UPDATE CASCADE;


--
-- TOC entry 4896 (class 2606 OID 2555653)
-- Name: t_samplinginfo_sai c_fk_sai_hty_code; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_hty_code FOREIGN KEY (sai_hty_code) REFERENCES ref.tr_habitattype_hty(hty_code) ON UPDATE CASCADE;


--
-- TOC entry 4897 (class 2606 OID 2555658)
-- Name: t_samplinginfo_sai c_fk_sai_qal_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_samplinginfo_sai
    ADD CONSTRAINT c_fk_sai_qal_id FOREIGN KEY (sai_qal_id) REFERENCES ref.tr_quality_qal(qal_id) ON UPDATE CASCADE;


--
-- TOC entry 4839 (class 2606 OID 2555663)
-- Name: t_series_ser c_fk_sam_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_sam_id FOREIGN KEY (ser_sam_id) REFERENCES ref.tr_samplingtype_sam(sam_id);


--
-- TOC entry 4840 (class 2606 OID 2555668)
-- Name: t_series_ser c_fk_ser_dts_datasource; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_ser_dts_datasource FOREIGN KEY (ser_dts_datasource) REFERENCES ref.tr_datasource_dts(dts_datasource);


--
-- TOC entry 4841 (class 2606 OID 2555673)
-- Name: t_series_ser c_fk_ser_effort_uni_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_ser_effort_uni_code FOREIGN KEY (ser_effort_uni_code) REFERENCES ref.tr_units_uni(uni_code) ON UPDATE CASCADE;


--
-- TOC entry 4857 (class 2606 OID 2555678)
-- Name: t_dataseries_das c_fk_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_dataseries_das
    ADD CONSTRAINT c_fk_ser_id FOREIGN KEY (das_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE;


--
-- TOC entry 4854 (class 2606 OID 2555683)
-- Name: t_biometry_series_bis c_fk_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_biometry_series_bis
    ADD CONSTRAINT c_fk_ser_id FOREIGN KEY (bis_ser_id) REFERENCES datawg.t_series_ser(ser_id) ON UPDATE CASCADE;


--
-- TOC entry 4898 (class 2606 OID 2555688)
-- Name: t_seriesglm_sgl c_fk_sql_ser_id; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_seriesglm_sgl
    ADD CONSTRAINT c_fk_sql_ser_id FOREIGN KEY (sgl_ser_id) REFERENCES datawg.t_series_ser(ser_id);


--
-- TOC entry 4842 (class 2606 OID 2555693)
-- Name: t_series_ser c_fk_tblcodeid; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_tblcodeid FOREIGN KEY (ser_tblcodeid) REFERENCES ref.tr_station("tblCodeID") ON UPDATE CASCADE;


--
-- TOC entry 4843 (class 2606 OID 2555698)
-- Name: t_series_ser c_fk_typ_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_typ_id FOREIGN KEY (ser_typ_id) REFERENCES ref.tr_typeseries_typ(typ_id) ON UPDATE CASCADE;


--
-- TOC entry 4826 (class 2606 OID 2555703)
-- Name: t_eelstock_eel c_fk_typ_id; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_eelstock_eel
    ADD CONSTRAINT c_fk_typ_id FOREIGN KEY (eel_typ_id) REFERENCES ref.tr_typeseries_typ(typ_id) ON UPDATE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 2555708)
-- Name: t_series_ser c_fk_uni_code; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT c_fk_uni_code FOREIGN KEY (ser_uni_code) REFERENCES ref.tr_units_uni(uni_code);


--
-- TOC entry 4830 (class 2606 OID 2555713)
-- Name: log log_log_cou_code_fkey; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.log
    ADD CONSTRAINT log_log_cou_code_fkey FOREIGN KEY (log_cou_code) REFERENCES ref.tr_country_cou(cou_code) ON UPDATE CASCADE;


--
-- TOC entry 4831 (class 2606 OID 2555718)
-- Name: log log_log_main_assessor_fkey; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.log
    ADD CONSTRAINT log_log_main_assessor_fkey FOREIGN KEY (log_main_assessor) REFERENCES datawg.participants(name) ON UPDATE CASCADE;


--
-- TOC entry 4832 (class 2606 OID 2555723)
-- Name: log log_log_secondary_assessor_fkey; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.log
    ADD CONSTRAINT log_log_secondary_assessor_fkey FOREIGN KEY (log_secondary_assessor) REFERENCES datawg.participants(name) ON UPDATE CASCADE;


--
-- TOC entry 4829 (class 2606 OID 2555728)
-- Name: t_eelstock_eel_percent t_eelstock_eel_percent_percent_id_fkey; Type: FK CONSTRAINT; Schema: datawg; Owner: wgeel
--

ALTER TABLE ONLY datawg.t_eelstock_eel_percent
    ADD CONSTRAINT t_eelstock_eel_percent_percent_id_fkey FOREIGN KEY (percent_id) REFERENCES datawg.t_eelstock_eel(eel_id) ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 2555733)
-- Name: t_series_ser t_series_ser_ser_sam_gear_fkey; Type: FK CONSTRAINT; Schema: datawg; Owner: postgres
--

ALTER TABLE ONLY datawg.t_series_ser
    ADD CONSTRAINT t_series_ser_ser_sam_gear_fkey FOREIGN KEY (ser_sam_gear) REFERENCES ref.tr_gear_gea(gea_id);


--
-- TOC entry 4827 (class 2606 OID 2555738)
-- Name: tr_emu_emu c_fk_cou_code; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emu_emu
    ADD CONSTRAINT c_fk_cou_code FOREIGN KEY (emu_cou_code) REFERENCES ref.tr_country_cou(cou_code);


--
-- TOC entry 4899 (class 2606 OID 2555743)
-- Name: tr_emusplit_ems c_fk_cou_code; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emusplit_ems
    ADD CONSTRAINT c_fk_cou_code FOREIGN KEY (emu_cou_code) REFERENCES ref.tr_country_cou(cou_code);


--
-- TOC entry 4900 (class 2606 OID 2555748)
-- Name: tr_emusplit_ems c_fk_emu_nameshort; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emusplit_ems
    ADD CONSTRAINT c_fk_emu_nameshort FOREIGN KEY (emu_nameshort, emu_cou_code) REFERENCES ref.tr_emu_emu(emu_nameshort, emu_cou_code) ON UPDATE CASCADE;


--
-- TOC entry 4901 (class 2606 OID 2555753)
-- Name: tr_emusplit_ems c_fk_emu_sea; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_emusplit_ems
    ADD CONSTRAINT c_fk_emu_sea FOREIGN KEY (emu_sea) REFERENCES ref.tr_sea_sea(sea_code) ON UPDATE CASCADE;


--
-- TOC entry 4903 (class 2606 OID 2555758)
-- Name: tr_station c_fk_station_name; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_station
    ADD CONSTRAINT c_fk_station_name FOREIGN KEY ("Station_Name") REFERENCES datawg.t_series_ser(ser_nameshort) ON UPDATE CASCADE;


--
-- TOC entry 4828 (class 2606 OID 2555763)
-- Name: tr_typeseries_typ c_fk_uni_code; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_typeseries_typ
    ADD CONSTRAINT c_fk_uni_code FOREIGN KEY (typ_uni_code) REFERENCES ref.tr_units_uni(uni_code) ON UPDATE CASCADE;


--
-- TOC entry 4902 (class 2606 OID 2555768)
-- Name: tr_metrictype_mty c_fk_uni_code; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.tr_metrictype_mty
    ADD CONSTRAINT c_fk_uni_code FOREIGN KEY (mty_uni_code) REFERENCES ref.tr_units_uni(uni_code) ON UPDATE CASCADE;


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 43
-- Name: SCHEMA datawg; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA datawg TO wgeel;
GRANT USAGE ON SCHEMA datawg TO wgeel_read;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO wgeel_read;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 11
-- Name: SCHEMA ref; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA ref TO wgeel;
GRANT USAGE ON SCHEMA ref TO wgeel_read;


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 34
-- Name: SCHEMA tempo; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA tempo TO wgeel;


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 35
-- Name: SCHEMA wkeelmigration; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA wkeelmigration TO wgeel;


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 1220
-- Name: FUNCTION fish_in_emu(); Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON FUNCTION datawg.fish_in_emu() TO wgeel;


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE layer; Type: ACL; Schema: topology; Owner: postgres
--

GRANT SELECT ON TABLE topology.layer TO wgeel;


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE topology; Type: ACL; Schema: topology; Owner: postgres
--

GRANT SELECT ON TABLE topology.topology TO wgeel;


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE t_eelstock_eel; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_eelstock_eel TO wgeel;
GRANT SELECT ON TABLE datawg.t_eelstock_eel TO wgeel_read;


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 265
-- Name: TABLE tr_country_cou; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_country_cou TO wgeel;
GRANT SELECT ON TABLE ref.tr_country_cou TO wgeel_read;


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE tr_emu_emu; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_emu_emu TO wgeel;
GRANT SELECT ON TABLE ref.tr_emu_emu TO wgeel_read;


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 267
-- Name: TABLE tr_habitattype_hty; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_habitattype_hty TO wgeel;
GRANT SELECT ON TABLE ref.tr_habitattype_hty TO wgeel_read;


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE tr_lifestage_lfs; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_lifestage_lfs TO wgeel;
GRANT SELECT ON TABLE ref.tr_lifestage_lfs TO wgeel_read;


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE tr_quality_qal; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_quality_qal TO wgeel;
GRANT SELECT ON TABLE ref.tr_quality_qal TO wgeel_read;


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE tr_typeseries_typ; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_typeseries_typ TO wgeel;
GRANT SELECT ON TABLE ref.tr_typeseries_typ TO wgeel_read;


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE aquaculture; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.aquaculture TO wgeel;
GRANT SELECT ON TABLE datawg.aquaculture TO wgeel_read;


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE t_eelstock_eel_percent; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_eelstock_eel_percent TO wgeel_read;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE b0; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.b0 TO wgeel;
GRANT SELECT ON TABLE datawg.b0 TO wgeel_read;


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE bbest; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.bbest TO wgeel;
GRANT SELECT ON TABLE datawg.bbest TO wgeel_read;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE bcurrent; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.bcurrent TO wgeel;
GRANT SELECT ON TABLE datawg.bcurrent TO wgeel_read;


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE bcurrent_without_stocking; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.bcurrent_without_stocking TO wgeel_read;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE potential_available_habitat; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.potential_available_habitat TO wgeel;
GRANT SELECT ON TABLE datawg.potential_available_habitat TO wgeel_read;


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 277
-- Name: TABLE sigmaa; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.sigmaa TO wgeel;
GRANT SELECT ON TABLE datawg.sigmaa TO wgeel_read;


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE sigmaf; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.sigmaf TO wgeel;
GRANT SELECT ON TABLE datawg.sigmaf TO wgeel_read;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE sigmah; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.sigmah TO wgeel;
GRANT SELECT ON TABLE datawg.sigmah TO wgeel_read;


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE bigtable; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.bigtable TO wgeel;
GRANT SELECT ON TABLE datawg.bigtable TO wgeel_read;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE bigtable_by_habitat; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.bigtable_by_habitat TO wgeel;
GRANT SELECT ON TABLE datawg.bigtable_by_habitat TO wgeel_read;


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE landings; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.landings TO wgeel;
GRANT SELECT ON TABLE datawg.landings TO wgeel_read;


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE log; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.log TO wgeel;
GRANT SELECT ON TABLE datawg.log TO wgeel_read;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 284
-- Name: SEQUENCE log_log_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.log_log_id_seq TO wgeel;


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE other_landings; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.other_landings TO wgeel;
GRANT SELECT ON TABLE datawg.other_landings TO wgeel_read;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE participants; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.participants TO wgeel;
GRANT SELECT ON TABLE datawg.participants TO wgeel_read;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE precodata; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.precodata TO wgeel_read;


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE precodata_country; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.precodata_country TO wgeel_read;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE precodata_all; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.precodata_all TO wgeel_read;


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE precodata_emu; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.precodata_emu TO wgeel;
GRANT SELECT ON TABLE datawg.precodata_emu TO wgeel_read;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE precodata_country_test; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT SELECT ON TABLE datawg.precodata_country_test TO wgeel_read;


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE release; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.release TO wgeel;
GRANT SELECT ON TABLE datawg.release TO wgeel_read;


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE series_stats; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.series_stats TO wgeel;
GRANT ALL ON TABLE datawg.series_stats TO wgeel_read;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE t_series_ser; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_series_ser TO wgeel;
GRANT SELECT ON TABLE datawg.t_series_ser TO wgeel_read;


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 291
-- Name: TABLE tr_samplingtype_sam; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_samplingtype_sam TO wgeel;
GRANT SELECT ON TABLE ref.tr_samplingtype_sam TO wgeel_read;


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE series_summary; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.series_summary TO wgeel;
GRANT ALL ON TABLE datawg.series_summary TO wgeel_read;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE sigmafallcat; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.sigmafallcat TO wgeel;
GRANT SELECT ON TABLE datawg.sigmafallcat TO wgeel_read;


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE sigmahallcat; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.sigmahallcat TO wgeel;
GRANT SELECT ON TABLE datawg.sigmahallcat TO wgeel_read;


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE silver_eel_equivalents; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.silver_eel_equivalents TO wgeel;
GRANT SELECT ON TABLE datawg.silver_eel_equivalents TO wgeel_read;


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE t_biometrygroupseries_bio; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_biometrygroupseries_bio TO wgeel;
GRANT SELECT ON TABLE datawg.t_biometrygroupseries_bio TO wgeel_read;


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 296
-- Name: SEQUENCE t_biometry_bio_bio_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_biometry_bio_bio_id_seq TO wgeel;


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 297
-- Name: TABLE t_biometry_other_bit; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_biometry_other_bit TO wgeel;
GRANT SELECT ON TABLE datawg.t_biometry_other_bit TO wgeel_read;


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE t_biometry_series_bis; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_biometry_series_bis TO wgeel;
GRANT SELECT ON TABLE datawg.t_biometry_series_bis TO wgeel_read;


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE t_dataseries_das; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_dataseries_das TO wgeel;
GRANT SELECT ON TABLE datawg.t_dataseries_das TO wgeel_read;


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 300
-- Name: SEQUENCE t_dataseries_das_das_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_dataseries_das_das_id_seq TO wgeel;


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 301
-- Name: SEQUENCE t_eelstock_eel_eel_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_eelstock_eel_eel_id_seq TO wgeel;


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE t_fish_fi; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_fish_fi TO wgeel_read;


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE t_fishsamp_fisa; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_fishsamp_fisa TO wgeel_read;


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE t_fishseries_fiser; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_fishseries_fiser TO wgeel_read;


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE t_group_gr; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_group_gr TO wgeel_read;


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE t_groupsamp_grsa; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_groupsamp_grsa TO wgeel_read;


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE t_groupseries_grser; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_groupseries_grser TO wgeel_read;


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE t_metricgroup_meg; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricgroup_meg TO wgeel_read;


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE t_metricgroupsamp_megsa; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricgroupsamp_megsa TO wgeel_read;


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE t_metricgroupseries_megser; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricgroupseries_megser TO wgeel_read;


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE t_metricind_mei; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricind_mei TO wgeel_read;


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE t_metricindsamp_meisa; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricindsamp_meisa TO wgeel_read;


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 317
-- Name: TABLE t_metricindseries_meiser; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_metricindseries_meiser TO wgeel_read;


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE t_modeldata_dat; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_modeldata_dat TO wgeel;
GRANT SELECT ON TABLE datawg.t_modeldata_dat TO wgeel_read;


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 365
-- Name: SEQUENCE t_modeldata_dat_dat_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_modeldata_dat_dat_id_seq TO wgeel;


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE t_modelrun_run; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON TABLE datawg.t_modelrun_run TO wgeel;
GRANT SELECT ON TABLE datawg.t_modelrun_run TO wgeel_read;


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 359
-- Name: SEQUENCE t_modelrun_run_run_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_modelrun_run_run_id_seq TO wgeel;


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE t_samplinginfo_sai; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_samplinginfo_sai TO wgeel_read;


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 320
-- Name: SEQUENCE t_series_ser_ser_id_seq; Type: ACL; Schema: datawg; Owner: postgres
--

GRANT ALL ON SEQUENCE datawg.t_series_ser_ser_id_seq TO wgeel;


--
-- TOC entry 5356 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE t_seriesglm_sgl; Type: ACL; Schema: datawg; Owner: wgeel
--

GRANT SELECT ON TABLE datawg.t_seriesglm_sgl TO wgeel_read;


--
-- TOC entry 5358 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE gear; Type: ACL; Schema: public; Owner: wgeel
--

GRANT SELECT ON TABLE public.gear TO wgeel_read;


--
-- TOC entry 5359 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE geography_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geography_columns TO wgeel;
GRANT SELECT ON TABLE public.geography_columns TO wgeel_read;


--
-- TOC entry 5360 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE geometry_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geometry_columns TO wgeel;
GRANT SELECT ON TABLE public.geometry_columns TO wgeel_read;


--
-- TOC entry 5361 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE spatial_ref_sys; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.spatial_ref_sys TO wgeel;
GRANT SELECT ON TABLE public.spatial_ref_sys TO wgeel_read;


--
-- TOC entry 5363 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE temp_dataseries; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_dataseries TO wgeel_read;


--
-- TOC entry 5365 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE temp_dataserieslast; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_dataserieslast TO wgeel_read;


--
-- TOC entry 5366 (class 0 OID 0)
-- Dependencies: 327
-- Name: TABLE temp_groupsamp; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_groupsamp TO wgeel_read;


--
-- TOC entry 5367 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE temp_groupseries; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_groupseries TO wgeel_read;


--
-- TOC entry 5368 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE temp_groupseries0609; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_groupseries0609 TO wgeel_read;


--
-- TOC entry 5369 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE temp_removed_mort_biom_spain_2021; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_removed_mort_biom_spain_2021 TO wgeel_read;


--
-- TOC entry 5370 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE temp_t_eelstock_eel; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.temp_t_eelstock_eel TO wgeel_read;


--
-- TOC entry 5371 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE tr_dataaccess_dta; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT ON TABLE ref.tr_dataaccess_dta TO wgeel;
GRANT SELECT ON TABLE ref.tr_dataaccess_dta TO wgeel_read;


--
-- TOC entry 5373 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE tr_datasource_dts; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_datasource_dts TO wgeel;
GRANT SELECT ON TABLE ref.tr_datasource_dts TO wgeel_read;


--
-- TOC entry 5374 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE tr_emusplit_ems; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_emusplit_ems TO wgeel;
GRANT SELECT ON TABLE ref.tr_emusplit_ems TO wgeel_read;


--
-- TOC entry 5376 (class 0 OID 0)
-- Dependencies: 335
-- Name: SEQUENCE tr_emusplit_ems_gid_seq; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE ref.tr_emusplit_ems_gid_seq TO wgeel;


--
-- TOC entry 5377 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE tr_faoareas; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_faoareas TO wgeel;
GRANT SELECT ON TABLE ref.tr_faoareas TO wgeel_read;


--
-- TOC entry 5379 (class 0 OID 0)
-- Dependencies: 337
-- Name: SEQUENCE tr_faoareas_gid_seq; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE ref.tr_faoareas_gid_seq TO wgeel;


--
-- TOC entry 5380 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE tr_gear_gea; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_gear_gea TO wgeel;
GRANT SELECT ON TABLE ref.tr_gear_gea TO wgeel_read;


--
-- TOC entry 5381 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE tr_ices_ecoregions; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_ices_ecoregions TO wgeel;
GRANT SELECT ON TABLE ref.tr_ices_ecoregions TO wgeel_read;


--
-- TOC entry 5383 (class 0 OID 0)
-- Dependencies: 340
-- Name: SEQUENCE tr_ices_ecoregions_gid_seq; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE ref.tr_ices_ecoregions_gid_seq TO wgeel;


--
-- TOC entry 5386 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE tr_metrictype_mty; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_metrictype_mty TO wgeel;
GRANT SELECT ON TABLE ref.tr_metrictype_mty TO wgeel_read;


--
-- TOC entry 5388 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE tr_model_mod; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_model_mod TO wgeel;
GRANT SELECT ON TABLE ref.tr_model_mod TO wgeel_read;


--
-- TOC entry 5390 (class 0 OID 0)
-- Dependencies: 343
-- Name: SEQUENCE tr_samplingtype_sam_sam_id_seq; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE ref.tr_samplingtype_sam_sam_id_seq TO wgeel;


--
-- TOC entry 5391 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE tr_sea_sea; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_sea_sea TO wgeel;
GRANT SELECT ON TABLE ref.tr_sea_sea TO wgeel_read;


--
-- TOC entry 5395 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE tr_station; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_station TO wgeel;
GRANT SELECT ON TABLE ref.tr_station TO wgeel_read;


--
-- TOC entry 5397 (class 0 OID 0)
-- Dependencies: 346
-- Name: SEQUENCE tr_typeseries_typ_typ_id_seq; Type: ACL; Schema: ref; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE ref.tr_typeseries_typ_typ_id_seq TO wgeel;


--
-- TOC entry 5398 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE tr_units_uni; Type: ACL; Schema: ref; Owner: postgres
--

GRANT ALL ON TABLE ref.tr_units_uni TO wgeel;
GRANT SELECT ON TABLE ref.tr_units_uni TO wgeel_read;


--
-- TOC entry 5399 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE topology_id_seq; Type: ACL; Schema: topology; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE topology.topology_id_seq TO wgeel;


--
-- TOC entry 5400 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE litterature; Type: ACL; Schema: wkeelmigration; Owner: postgres
--

GRANT ALL ON TABLE wkeelmigration.litterature TO wgeel;


--
-- TOC entry 5402 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE litteratured; Type: ACL; Schema: wkeelmigration; Owner: postgres
--

GRANT ALL ON TABLE wkeelmigration.litteratured TO wgeel;


-- Completed on 2025-02-03 11:16:53

--
-- PostgreSQL database dump complete
--


insert into ref.tr_datasource_dts values ('dc_2025', 'dc_2025	Joint EIFAAC/GFCM/ICES Eel Data Call 2025');



--- add a drop by cascade on sampling info
ALTER TABLE datawg.t_fishsamp_fisa drop constraint c_fk_fisa_sai_id;
ALTER TABLE datawg.t_fishsamp_fisa ADD CONSTRAINT c_fk_fisa_sai_id FOREIGN KEY (fisa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE cascade;


alter TABLE datawg.t_groupsamp_grsa drop CONSTRAINT c_fk_grsa_sai_id;
ALTER TABLE datawg.t_groupsamp_grsa ADD CONSTRAINT c_fk_grsa_sai_id FOREIGN KEY (grsa_sai_id) REFERENCES datawg.t_samplinginfo_sai(sai_id) ON UPDATE CASCADE ON DELETE cascade;
