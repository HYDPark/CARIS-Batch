--Test for SRID set
select LLDG_GEOM, sdo_geometry(pa1.LLDG_GEOM.sdo_gtype,
       2193,
       null,
   pa1.LLDG_GEOM.sdo_elem_info,
   pa1.LLDG_GEOM.sdo_ordinates) as GEOMETRY   from rnc_panel_0 pa1;

--Finding SRID
--SRID 2193

CREATE TABLE rnc_panel_v1 as (
select chartver_id,rep_id, stringval,panelver_id,product_status,panelnumber,scale,panel, sdo_geometry(pa1.LLDG_GEOM.sdo_gtype,
       2193,
       null,
   pa1.LLDG_GEOM.sdo_elem_info,
   pa1.LLDG_GEOM.sdo_ordinates) as GEOMETRY   from rnc_panel_0 pa1);

--SRID 8307  Now a couple of years ago I would said you should avoid 8307 as old-school, 
--oracle-centric and a marker of old-age. 
--You should use 4326 as "everybody" knows that SRID is WGS84 geodetic 2D while only the Oracle wonks know that 8307 is.

CREATE TABLE rnc_panel_v2 as (
select chartver_id,rep_id, stringval,panelver_id,product_status,panelnumber,scale,panel, sdo_geometry(pa1.LLDG_GEOM.sdo_gtype,
       8307,
       null,
   pa1.LLDG_GEOM.sdo_elem_info,
   pa1.LLDG_GEOM.sdo_ordinates) as GEOMETRY   from rnc_panel_0 pa1);

--convert googlg
Create table rnc_panel_v3 as
select chartver_id,rep_id, stringval,panelver_id,product_status,panelnumber,scale,panel,
sdo_cs.transform(geometry, 8307) as geometry
from rnc_panel_v2;



SELECT srid, COORD_REF_SYS_NAME from sdo_coord_ref_sys 
  WHERE COORD_REF_SYS_KIND = 'VERTICAL' order by srid;
  
  SELECT * from sdo_coord_ref_sys 
  WHERE srid = 4167;

  Create table rnc_panel_v3 as
select chartver_id,rep_id, stringval,panelver_id,product_status,panelnumber,scale,panel,
sdo_cs.transform(geometry, 4167) as geometry
from rnc_panel_v2;





