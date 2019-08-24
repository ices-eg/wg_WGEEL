---------------------
-- 2019 script to grant rights
---------------------

create user wgeel;
grant ALL on schema datawg to wgeel;
grant ALL on schema ref to wgeel;

grant all on ALL TABLES IN schema "ref"  to wgeel;
grant all on ALL TABLES IN schema "datawg" to wgeel;

GRANT ALL ON SEQUENCE datawg.log_log_id_seq TO wgeel;
GRANT ALL ON SEQUENCE datawg.t_eelstock_eel_eel_id_seq to wgeel;
GRANT ALL ON SEQUENCE datawg.t_eelstock_eel_eel_id_seq to wgeel; 
GRANT ALL ON SEQUENCE datawg.t_biometry_bio_bio_id_seq to wgeel; 
GRANT ALL ON SCHEMA public to wgeel 