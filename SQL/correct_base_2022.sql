-- run IN tmpdb
ALTER DATABASE wgeel0609 RENAME TO wgeelhilaire;
--DROP SCHEMA datawg CASCADE;
-- psql -U postgres -f datawg.sql wgeelhilaire
CREATEDB -U postgres wgeel0609 
-- pg_restore -U postgres -d wgeel0609 wgeel_09_06_2022.dump 


TODO CHECK these two lines
/*
 * 
 * D�TAIL : La ligne en échec contient (408546, 11, 2015, 750000, IT_total, IT, Y, F, null, 1, Value updated from SIPAM GFCM, null, 2022-08-29, null, dc_2018, Public).
CONTEXTE : COPY t_eelstock_eel, ligne 147 : « 408546   11      2015    750000  IT_total        IT      Y       F   \N       1       Value updated from SIPAM GFCM   \N      2022-08-29      \N      dc_2018 Pu... »
pg_restore: de l'entr�e TOC 4447 ; 2606 5515293 FK CONSTRAINT t_eelstock_eel_percent t_eelstock_eel_percent_percent_id_fkey wgeel
pg_restore: erreur : could not execute query: ERREUR:  une instruction insert ou update sur la table « t_eelstock_eel_percent » viole la contrainte de clé
étrangère « t_eelstock_eel_percent_percent_id_fkey »
D�TAIL : La clé (percent_id)=(513110) n'est pas présente dans la table « t_eelstock_eel ».
La commande �tait : ALTER TABLE ONLY datawg.t_eelstock_eel_percent
    ADD CONSTRAINT t_eelstock_eel_percent_percent_id_fkey FOREIGN KEY (percent_id) REFERENCES datawg.t_eelstock_eel(eel_id) ON DELETE CASCADE;
 * 
 * 
 * 
 */
-- fixing problem with gr_id 



-- sur la base hilaire_db 
DROP TABLE IF EXISTS temp_dataseries
CREATE TABLE public.temp_dataseries AS SELECT ser_nameshort,das.* FROM datawg.t_series_ser JOIN datawg.t_dataseries_das das 
ON ser_id=das_ser_id; --5610
-- pg_dump -U postgres -f "temp_dataseries.sql" --table temp_dataseries wgeelhilaire
-- psql -U postgres -f "temp_dataseries.sql"  wgeel0609

-- sur la base wgeel0609 


SELECT count(*), das_last_update  FROM  temp_dataseries GROUP BY  das_last_update ORDER BY das_last_update
/*

2857  2020-08-27
16  2020-08-31
143 2020-09-01
990 2020-09-02
131 2020-09-03
82  2020-09-04
9 2020-09-05
5 2020-09-06
2 2020-09-10
8 2020-09-23
6 2020-09-25
265 2021-09-07
274 2021-09-08
226 2021-09-09
37  2021-09-10
2 2021-09-27
2 2021-09-28
178 2021-09-29
229 2021-09-30
147 2021-10-01
1 2022-02-21
 */

WITH ser AS (
SELECT ser_nameshort,das.* FROM datawg.t_series_ser JOIN datawg.t_dataseries_das das 
ON ser_id=das_ser_id)
SELECT 
h.das_id AS hdas_id ,
ser.das_id AS sdas_id
FROM temp_dataseries h JOIN ser
ON (ser.ser_nameshort, ser.das_year) = (h.ser_nameshort, h.das_year)
WHERE ser.das_id != h.das_id


-----------------------------------------

DROP TABLE IF EXISTS temp_t_eelstock_eel;
CREATE TABLE public.temp_t_eelstock_eel AS SELECT * FROM datawg.t_eelstock_eel; --78418
-- pg_dump -U postgres -f "temp_t_eelstock_eel.sql" --table temp_t_eelstock_eel  wgeelhilaire
-- psql -U postgres -f "temp_t_eelstock_eel.sql"  wgeel0609
SELECT 


SELECT * FROM datawg.t_eelstock_eel n JOIN temp_t_eelstock_eel h ON
(n.eel_typ_id,n.eel_year,n.eel_emu_nameshort,n.eel_cou_code,n.eel_missvaluequal, n.eel_lfs_code,n.eel_hty_code,n.eel_qal_id,n.eel_area_division)=
(h.eel_typ_id,h.eel_year,h.eel_emu_nameshort,h.eel_cou_code,h.eel_missvaluequal,h.eel_lfs_code,h.eel_hty_code,h.eel_qal_id,h.eel_area_division)
WHERE n.eel_id != h.eel_id


-- > the db is in the correct state

-- copy from old db
-- psql -U postgres -c "DROP TABLE datawg.t_groupsamp_grsa CASCADE" wgeel0609
-- psql -U postgres -c "DROP TABLE datawg.t_groupseries_grser CASCADE" wgeel0609
--psql -U postgres -f hilaire_db.sql wgeel0609
--pg_dump -U postgres --table temp_groupsamp --table temp_groupseries -f "temp_restore_group.sql" wgeel0609 
-- temp database : 
DROP TABLE IF EXISTS temp_groupsamp;
DROP TABLE IF EXISTS temp_groupseries;
CREATE TABLE temp_groupsamp AS SELECT sai.sai_name, grsa.* FROM datawg.t_groupsamp_grsa grsa  JOIN datawg.t_samplinginfo_sai sai ON (grsa_sai_id = sai_id)  ; --494 => 110
CREATE TABLE temp_groupseries AS SELECT ser.ser_nameshort, ser.ser_id, grser.* FROM datawg.t_groupseries_grser grser JOIN datawg.t_series_ser ser  ON (grser_ser_id = ser_id)  ; --2167
-- pg_dump -U postgres --table temp_groupsamp --table temp_groupseries -f "temp_restore_group.sql" wgeel
-- pg_dump -U postgres --table temp_groupsamp --table temp_groupseries -f "temp_restore_group.sql" wgeel0609
-- pg_dump -U postgres --table temp_groupseries -f "temp_groupseries.sql" wgeelhilaire

-- psql -U postgres -h 185.135.126.250 -f "temp_restore_group.sql" wgeel
-- psql -U postgres -h 185.135.126.250 -f "temp_groupseries.sql" wgeel



----------------------------------
-- SAMPLING
----------------------------------


SELECT count(*), gr_dts_datasource  FROM  temp_groupsamp GROUP BY  gr_dts_datasource
/*
179 NULL
315 dc_2022
*/
-- distant database
SELECT count(*), gr_dts_datasource  FROM  datawg.t_groupsamp_grsa GROUP BY  gr_dts_datasource
/*
 179 NULL
338 dc_2022
*/



SELECT count(*), gr_lastupdate  FROM  datawg.t_groupsamp_grsa GROUP BY  gr_lastupdate
/*
227 2022-09-06
55  2022-09-09
181 2022-09-08
109 2022-08-29
*/

SELECT count(*), gr_lastupdate  FROM  temp_groupsamp GROUP BY  gr_lastupdate

/*
172 2022-09-08
4 2022-08-29
139 2022-08-31
179 2022-05-19
*/

WITH oldgr AS (
SELECT * FROM temp_groupsamp WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT sai.sai_name, 
    grsa.*
FROM datawg.t_groupsamp_grsa grsa JOIN 
datawg.t_samplinginfo_sai sai ON grsa_sai_id= sai_id
)

SELECT o.gr_id AS ogr_id, n.gr_id AS ngrid FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.sai_name)=(n.gr_year, n.sai_name) --172 hurray

-- change t_metricgroupsamp_megsa

-- ALTER TABLE datawg.t_metricgroupsamp_megsa DROP CONSTRAINT c_fk_megsa_gr_id ;


-- we replace the new group id with the oldone (hilaire db) table t_metricgroupsamp_megsa
/*
WITH oldgr AS (
SELECT * FROM temp_groupsamp WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT sai.sai_name, 
    grsa.*
FROM datawg.t_groupsamp_grsa grsa JOIN 
datawg.t_samplinginfo_sai sai ON grsa_sai_id= sai_id
),
replacegr AS(
SELECT o.gr_id AS ogr_id, n.gr_id AS ngrid FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.sai_name)=(n.gr_year, n.sai_name)
)
UPDATE datawg.t_metricgroupsamp_megsa SET meg_gr_id = ogr_id FROM replacegr
WHERE replacegr.ngrid = meg_gr_id; --433
*/

-- we replace the new group id with the oldone (hilaire db) table t_groupsamp_grsa
-- it will cascade update on group_metrics
WITH oldgr AS (
SELECT * FROM temp_groupsamp WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT sai.sai_name, 
    grsa.*
FROM datawg.t_groupsamp_grsa grsa JOIN 
datawg.t_samplinginfo_sai sai ON grsa_sai_id= sai_id
),
replacegr AS(
SELECT o.gr_id AS ogr_id, n.gr_id AS ngrid FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.sai_name)=(n.gr_year, n.sai_name)
)
UPDATE datawg.t_groupsamp_grsa SET gr_id = ogr_id FROM replacegr
WHERE replacegr.ngrid = gr_id; --172

--ALTER TABLE datawg.t_metricgroupsamp_megsa ADD CONSTRAINT c_fk_megsa_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_groupsamp_grsa(gr_id) ON DELETE CASCADE ON UPDATE CASCADE

----------------------------------
-- SERIES
----------------------------------


SELECT count(*), gr_dts_datasource  FROM  temp_groupseries GROUP BY  gr_dts_datasource
/*
291 dc_2020
973 
3 dc_2022
900 dc_2021
*/
-- distant database
SELECT count(*), gr_dts_datasource  FROM  datawg.t_groupseries_grser GROUP BY  gr_dts_datasource
/*
290 dc_2020
972 
201 dc_2022
897 dc_2021
*/



SELECT count(*), gr_lastupdate  FROM  datawg.t_groupseries_grser GROUP BY  gr_lastupdate
/*
227 2022-09-06
55  2022-09-09
181 2022-09-08
109 2022-08-29
*/

SELECT count(*), gr_lastupdate  FROM  temp_groupseries GROUP BY  gr_lastupdate

/*
2 2022-09-07
2165  2022-05-19
*/

WITH oldgr AS (
SELECT * FROM temp_groupseries WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT ser.ser_nameshort, 
ser.ser_id,
    grser.*
FROM datawg.t_groupseries_grser grser JOIN 
datawg.t_series_ser ser ON grser_ser_id= ser_id
)

SELECT count(*) FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.ser_id)=(n.gr_year, n.ser_id) --2159 (6 lines missing)


--
SELECT min(gr_id), max(gr_id) FROM datawg.t_groupseries_grser; -- 1 3741
SELECT min(gr_id), max(gr_id) FROM temp_groupseries;  -- 1 2680

UPDATE datawg.t_groupseries_grser ser SET gr_id = gr_id+10000; --2365
SELECT min(gr_id), max(gr_id) FROM datawg.t_groupseries_grser; --10001  13741

-- insert missing id


WITH oldgr AS (
SELECT * FROM temp_groupseries WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT ser.ser_nameshort, 
ser.ser_id,
    grser.*
FROM datawg.t_groupseries_grser grser JOIN 
datawg.t_series_ser ser ON grser_ser_id= ser_id
),

joingr AS (
SELECT o.* FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.ser_id)=(n.gr_year, n.ser_id)
),

diff AS (
SELECT * FROM oldgr 
EXCEPT 
SELECT * FROM joingr)

/*
ser_nameshort ser_id gr_id gr_yera
MonY 241 1707  2020
OriY  212 1115  2019
MinS  244 170 2018
MonS  243 1068  2020
MinY  242 1684  2020
MonS  243 169 2018
 */
--SELECT count(*) FROM diff --206
INSERT INTO datawg.t_groupseries_grser (gr_id,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
gr_dts_datasource,
grser_ser_id) 
SELECT 
gr_id,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
gr_dts_datasource,
grser_ser_id FROM diff; --6


--2159 

-- I need to restore the lines that were deleted in the db and are different from hilaire's
/* USELESS BELOW
-- on wgeel0609
CREATE TABLE temp_groupseries0609 AS SELECT ser.ser_nameshort, ser.ser_id, grser.* FROM datawg.t_groupseries_grser grser JOIN datawg.t_series_ser ser  ON (grser_ser_id = ser_id)  ; --2165
 -- pg_dump -U postgres --table temp_groupseries0609 -f "temp_groupseries0609.sql" wgeel0609
 -- psql -U postgres -h 185.135.126.250 -f "temp_groupseries0609.sql" wgeel


WITH oldgr AS (
SELECT * FROM temp_groupseries0609 
),

newgr AS (
SELECT ser.ser_nameshort, 
ser.ser_id,
    grser.*
FROM datawg.t_groupseries_grser grser JOIN 
datawg.t_series_ser ser ON grser_ser_id= ser_id
),

--SELECT count(*) FROM oldgr o 
--JOIN newgr n ON (o.gr_year, o.ser_id)=(n.gr_year, n.ser_id) --2159

diff AS (
SELECT gr_year,ser_id FROM newgr 
EXCEPT 
SELECT o.gr_year,o.ser_id FROM
oldgr o 
JOIN newgr n ON (o.gr_year, o.ser_id)=(n.gr_year, n.ser_id))

--SELECT count(*) FROM diff ; --206

SELECT * FROM diff d JOIN newgr n
ON (n.gr_year, n.ser_id)=(d.gr_year, d.ser_id)
*/


-- we replace the new group id with the oldone (hilaire db) table t_groupseries_grser
-- this will cascade on metricgroup table
WITH oldgr AS (
SELECT * FROM temp_groupseries WHERE gr_lastupdate = '2022-05-19'
),

newgr AS (
SELECT ser_nameshort, 
    grser.*
FROM datawg.t_groupseries_grser grser JOIN 
datawg.t_series_ser ser ON grser_ser_id= ser_id
),
replacegr AS(
SELECT o.gr_id AS ogr_id, n.gr_id AS ngrid FROM oldgr o 
JOIN newgr n ON (o.gr_year, o.ser_nameshort)=(n.gr_year, n.ser_nameshort)
)
UPDATE datawg.t_groupseries_grser SET gr_id = ogr_id FROM replacegr
WHERE replacegr.ngrid = gr_id; --2165






