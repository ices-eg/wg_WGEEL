---------------------
-- 2019 script to grant rights
---------------------

create user wgeel;
grant USAGE on schema datawg to wgeel;
grant USAGE on schema ref to wgeel;
grant all on ALL TABLES IN schema "ref"  to wgeel;
grant all on ALL TABLES IN schema "datawg" to wgeel;
