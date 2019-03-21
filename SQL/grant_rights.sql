---------------------
-- 2019 script to grant rights
---------------------

create user wgeel;
grant USAGE on schema datawg to wgeel;
<<<<<<< HEAD
=======
grant USAGE on schema ref to wgeel;
>>>>>>> remove_postgres
grant all on ALL TABLES IN schema "ref"  to wgeel;
grant all on ALL TABLES IN schema "datawg" to wgeel;
