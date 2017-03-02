-- SCRIPT TO TRANSFERT THE CURRENT DATABASE TO THE NEW DATABASE

-- TODO For sea check if there is something different in ICES for seas
-- This will take the data from the current sea table which was built on the wise EU layer
-- I would like to have geometries there so anything else would be usefull

insert into ref.tr_sea_sea 
(select distinct on (emu_sea)
emu_hyd_syst_o as sea_o, 
emu_hyd_syst_s as sea_s,
 emu_sea as sea_code  from carto.t_emu_emu
 where emu_sea is not null);


create table ts_sea_sea as (
sea_o character varying(50) not null,
sea_s character varying(50) not null,
sea_code character varying(2) primary key);

