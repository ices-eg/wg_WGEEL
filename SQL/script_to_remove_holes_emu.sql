--with b as (select st_union(geom) geom from emu.tr_emu_emu where emu_namesh='AX_total')
--update emu.tr_emu_emu set geom=st_Multi(st_difference(emu.tr_emu_emu.geom,b.geom)) from b where emu.tr_emu_emu.emu_namesh='FI_Finl';
drop table if exists emu.dumptable;

--we order by st_area(st_enveloppe(geom)) to ensure that gid will always remain the same
create table emu.dumptable as (select row_number() over() as gid, emu_namesh, geom from (
(select emu_namesh, (st_dump(geom)).geom as geom from emu.tr_emu_emu)
) as b order by emu_namesh, st_area(st_envelope(geom)));
update emu.dumptable set geom=st_makepolygon(st_exteriorring(geom)) where emu_namesh not in ('SE_East', 'FI_Finl','SE_Ea_o');

delete from emu.dumptable where gid in (
	select small.gid from emu.dumptable big inner join emu.dumptable small on st_containsproperly(big.geom, small.geom)) and emu_namesh not in ('AX_total','SE_Inla');

alter table emu.dumptable add column geom2 geometry('MULTIPOLYGON', 4326);
begin;
  DO $$
    DECLARE
      rec RECORD;
	  cur_rec RECORD;
	  nb_int int;
    BEGIN
      FOR rec in SELECT gid FROM emu.dumptable order by gid
     LOOP
        BEGIN
			select * from emu.dumptable where gid=rec.gid into cur_rec;
			RAISE INFO 'working on %',cur_rec.emu_namesh;
			select count(distinct d.gid) from emu.dumptable d where d.gid>rec.gid and st_intersects(cur_rec.geom,d.geom) into nb_int;
			if nb_int>0 then
				with x as (select st_buffer(st_union(d.geom),0) geom from emu.dumptable d where d.gid>rec.gid and st_intersects(cur_rec.geom,d.geom))
				update emu.dumptable set geom2=st_Multi(st_difference(cur_rec.geom,x.geom)) from x where emu.dumptable.gid=cur_rec.gid; 
			else
				update emu.dumptable set geom2=st_Multi(cur_rec.geom) where emu.dumptable.gid=cur_rec.gid; 
			end if;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'For geometry % % we got exception % (%)', rec.gid, cur_rec.emu_namesh, SQLERRM, SQLSTATE;
        END;
      END LOOP;
    END;
  $$ LANGUAGE 'plpgsql'; 
  

update emu.dumptable set geom2=st_Multi(geom) where geom2 is null; 
commit;


--we split again multipolygon in single polygon to facilitation latter cleaning
--we order by st_area(st_enveloppe(geom)) to ensure that gid will always remain the same
drop table if exists emu.dumptable_new;
create table emu.dumptable_new as (select row_number() over() as gid, emu_namesh, geom from (
(select emu_namesh, (st_dump(geom2)).geom as geom from emu.dumptable)
) as b order by emu_namesh, st_area(st_envelope(geom)));


update emu.dumptable_new set geom=st_transform(geom,3035);
delete from emu.dumptable_new where st_area(geom)<1e5; --we remove polygon of less than 0.1km²

--create a topology with a given tolerance
begin;
select droptopology('emu_topo');
SELECT topology.CreateTopology('emu_topo',3035);
SELECT AddTopoGeometryColumn('emu_topo', 'emu', 'dumptable_new', 'topogeom', 'POLYGON');
  DO $$
    DECLARE
      rec RECORD;
      tol FLOAT8;
    BEGIN
      tol := 100;
      FOR rec in SELECT gid,emu_namesh, geom FROM emu.dumptable_new where topogeom is null order by emu_namesh, gid
      LOOP
        BEGIN
          IF GeometryType(rec.geom) = 'POLYGON' THEN
		  	RAISE INFO 'working on % %',rec.gid, rec.emu_namesh;
            update emu.dumptable_new set topogeom=toTopoGeom(rec.geom, 'emu_topo', 1,tol) where gid=rec.gid; 
          END IF;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'For geometry % % we got exception % (%)', rec.gid, rec.emu_namesh, SQLERRM, SQLSTATE;
        END;
      END LOOP;
    END;
  $$ LANGUAGE 'plpgsql';


--for missing one, we put tolerance equals 0
   DO $$
    DECLARE
      rec RECORD;
      tol FLOAT8;
    BEGIN
      tol := 0;
      FOR rec in SELECT gid,emu_namesh, geom FROM emu.dumptable_new where topogeom is null order by emu_namesh, gid
      LOOP
        BEGIN
          IF GeometryType(rec.geom) = 'POLYGON' THEN
		  	RAISE INFO 'working on % %',rec.gid, rec.emu_namesh;
            update emu.dumptable_new set topogeom=toTopoGeom(rec.geom, 'emu_topo', 1,tol) where gid=rec.gid; 
          END IF;
        EXCEPTION WHEN OTHERS THEN
          RAISE WARNING 'For geometry % % we got exception % (%)', rec.gid, rec.emu_namesh, SQLERRM, SQLSTATE;
        END;
      END LOOP;
    END;
  $$ LANGUAGE 'plpgsql';
 
 
 
 
--the following statements are manual modifications that should be adapted to each situation

--select st_changeedgegeom('emu_topo',e.edge_id, st_snap(e.geom,n.geom,1)) from newnode n, emu_topo.edge_data e where n.gid=6 and e.edge_id=5758;
--select ST_ModEdgeSplit('emu_topo',edge_id, n.geom) from newnode n, emu_topo.edge_data e where gid=6 and e.edge_id=5758;
--with x as (select ((st_snap(st_snap(st_exteriorring(e.geom),n1.geom,10),n2.geom,10))) geom from emu.dumptable_new e join newnode n1 on st_dwithin(n1.geom,e.geom,200) join newnode n2 on st_dwithin(n1.geom,e.geom,200) where e.gid=4163 and n1.gid=3 and n2.gid=4),
-- newline as (select ST_LineSubstring(x.geom,ST_LineLocatePoint(x.geom, n1.geom), st_linelocatepoint(x.geom,n2.geom)) geom from x join newnode n1 on st_dwithin(n1.geom,x.geom,200) join newnode n2 on st_dwithin(n1.geom,x.geom,200) and n1.gid=3 and n2.gid=4)
--select ST_AddEdgeModFace('emu_topo',88580,88579,geom) from newline




--select ST_ModEdgeSplit('emu_topo',edge_id, st_snap(n.geom,e.geom,10)) from newnode n, emu_topo.edge_data e where gid=9 and e.edge_id=156374;
--select ST_ModEdgeSplit('emu_topo',edge_id, st_snap(n.geom,e.geom,10)) from newnode n, emu_topo.edge_data e where gid=13 and e.edge_id=156377;

--select st_changeedgegeom('emu_topo',156378, st_makeline(n1.geom,n2.geom)) from emu_topo.node n1, emu_topo.node n2 where n1.node_id=88590 and n2.node_id=88589;
--select ST_AddEdgeModFace('emu_topo',88590,88589,st_makeline(p1.geom,p2.geom)) from emu_topo.node p1, emu_topo.node p2 where p1.node_id=88584 and p2.node_id=88585


--select ST_ModEdgeSplit('emu_topo',edge_id, n.geom) from newnode n, emu_topo.edge_data e where gid=6 and e.edge_id=5758;
--with x as (select ((st_snap(st_snap(st_exteriorring(e.geom),n1.geom,100),n2.geom,100))) geom from emu.dumptable_new e join emu_topo.node n1 on st_dwithin(n1.geom,e.geom,200) join emu_topo.node n2 on st_dwithin(n1.geom,e.geom,200) where e.gid=4745 and n1.node_id=88588 and n2.node_id=88589),
-- newline as (select ST_LineSubstring(x.geom, st_linelocatepoint(x.geom,n2.geom),ST_LineLocatePoint(x.geom, n1.geom)) geom from x join emu_topo.node n1 on st_dwithin(n1.geom,x.geom,200) join emu_topo.node n2 on st_dwithin(n1.geom,x.geom,200) and n1.node_id=88588 and n2.node_id=88589)
--select ST_AddEdgeModFace('emu_topo',88589,88588,geom) from newline


--select id(topogeom) from emu.dumptable_new where gid=4745
--insert into emu_topo.relation values(3394,1,70846,3)





--select ST_ModEdgeSplit('emu_topo',edge_id, st_snap(n.geom,e.geom,10)) from newnode n, emu_topo.edge_data e where gid=14 and e.edge_id=156380;
--select ST_ModEdgeSplit('emu_topo',edge_id, st_snap(n.geom,e.geom,10)) from newnode n, emu_topo.edge_data e where gid=16 and e.edge_id=62201;
--with x as (select ((st_snap(st_snap(st_exteriorring(e.geom),n1.geom,300),n2.geom,100))) geom from emu.dumptable_new e join emu_topo.node n1 on st_dwithin(n1.geom,e.geom,300) join emu_topo.node n2 on st_dwithin(n1.geom,e.geom,300) where e.gid=4234 and n1.node_id=88593 and n2.node_id=88592),
-- newline as (select ST_LineSubstring(x.geom,ST_LineLocatePoint(x.geom, n1.geom), st_linelocatepoint(x.geom,n2.geom)) geom from x join emu_topo.node n1 on st_dwithin(n1.geom,x.geom,300) join emu_topo.node n2 on st_dwithin(n1.geom,x.geom,300) and n1.node_id=88593 and n2.node_id=88592)
--select ST_AddEdgeModFace('emu_topo',88593,88592,geom) from newline

--select id(topogeom) from emu.dumptable_new where gid=4234
--insert into emu_topo.relation values(3925,1,70847,3)

begin;  
delete from emu_topo.relation where topogeo_id not in (select id(topogeom) from emu.dumptable_new);
select * from emu_topo.relation;
commit;

--this is to find holes
--41110 is Andorra
--2173 is San San Marino
--others are real holes
select ST_Area(ST_GetFaceGeometry('emu_topo',face_id)), face_id from emu_topo.face where not exists (select element_id from emu_topo.relation where element_id=face_id and element_type=3) and face_id!=0 order by st_area desc


CREATE OR REPLACE FUNCTION FixGapsTopo(atopo varchar, faceid int)
RETURNS int AS $$
DECLARE
  newface int;
  topogeoid int;
 rcount int;
  sql varchar;
BEGIN
    sql := 'with edges as (
		select edge_id from ' || atopo ||'.edge_data where left_face='||faceid||' or right_face='||faceid||')
	(select left_face as face_id from ' || atopo ||'.edge_data where edge_id in (select * from edges) and left_face!='||faceid||' and left_face in (select element_id from '||atopo||'.relation where element_type=3 and element_id=left_face) 
	union
	select right_face as face_id from ' || atopo ||'.edge_data where edge_id in (select * from edges) and right_face!='||faceid||' and right_face in (select element_id from '||atopo||'.relation where element_type=3 and element_id=right_face) 
	)limit 1';
     EXECUTE sql into newface;
     get diagnostics rcount = row_count;
     if rcount > 0 then
	sql:= 'select topogeo_id from '||atopo||'.relation where element_id='||newface||' and element_type=3 limit 1';
	EXECUTE sql into topogeoid;
        get diagnostics rcount = row_count;
	if rcount > 0 then
		sql:='insert into '||atopo||'.relation values('||topogeoid||',1,'||faceid||',3)';
		EXECUTE sql;
		RETURN topogeoid;
	end if;
	return -1;
   end if;
   return -1;
   EXCEPTION
    WHEN OTHERS THEN
     RAISE WARNING 'errors for face_id: %, %, %', faceid, sql, SQLERRM;
     return -1;
END
$$ LANGUAGE 'plpgsql';


begin;
with holes as (select ST_Area(ST_GetFaceGeometry('emu_topo',face_id)), face_id from emu_topo.face where not exists (select element_id from emu_topo.relation where element_id=face_id and element_type=3) and face_id not in (0,41110,2173) order by st_area desc)
select  FixGapsTopo('emu_topo',face_id) from holes;
commit;

--just a correction for AX_Toto
delete from emu_topo.relation where element_id=65248 and element_type=3 and topogeo_id!=3449;

create table emu.tr_emu_emu_nohole as (select e.gid,emu_namesh,st_union(st_getfacegeometry('emu_topo',element_id)) geom from emu.dumptable_new join emu_topo.relation on id(topogeom)=topogeo_id join emu.tr_emu_emu e using(emu_namesh) 
	where element_type=3 group by emu_namesh,e.gid);
