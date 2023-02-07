-------------------------------------------------------------
-- ALREADY RUN
-------------------------------------------------------------



-------------------------------------------------------------
-- TO BE RUN BEFORE GENERATING THE TEMPLATES
-------------------------------------------------------------

--we add a column to store identifiers from national database so that data providers
--can easily find their fishes
alter table datawg.t_fishsamp_fisa add column fi_id_cou varchar(50);
