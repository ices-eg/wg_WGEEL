---------------------
-- 2019 script to grant rights
---------------------

create user wgeel;
grant ALL on schema datawg to wgeel;
grant ALL on schema ref to wgeel;

grant all on ALL TABLES IN schema "ref"  to wgeel;
grant all on ALL TABLES IN schema "datawg" to wgeel;
