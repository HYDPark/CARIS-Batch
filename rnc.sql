--Test for SRID set
SELECT
   LLDG_GEOM,
   SDO_GEOMETRY(PA1.LLDG_GEOM.SDO_GTYPE,
   2193,
   NULL,
   PA1.LLDG_GEOM.SDO_ELEM_INFO,
   PA1.LLDG_GEOM.SDO_ORDINATES) AS GEOMETRY
FROM
   RNC_PANEL_0 PA1;

--Finding SRID
--SRID 2193

CREATE TABLE RNC_PANEL_V1 AS (
   SELECT
      CHARTVER_ID,
      REP_ID,
      STRINGVAL,
      PANELVER_ID,
      PRODUCT_STATUS,
      PANELNUMBER,
      SCALE,
      PANEL,
      SDO_GEOMETRY(PA1.LLDG_GEOM.SDO_GTYPE,
      2193,
      NULL,
      PA1.LLDG_GEOM.SDO_ELEM_INFO,
      PA1.LLDG_GEOM.SDO_ORDINATES) AS GEOMETRY
   FROM
      RNC_PANEL_0 PA1
);

--SRID 8307  Now a couple of years ago I would said you should avoid 8307 as old-school,
--oracle-centric and a marker of old-age.
--You should use 4326 as "everybody" knows that SRID is WGS84 geodetic 2D while only the Oracle wonks know that 8307 is.

CREATE TABLE RNC_PANEL_V2 AS (
   SELECT
      CHARTVER_ID,
      REP_ID,
      STRINGVAL,
      PANELVER_ID,
      PRODUCT_STATUS,
      PANELNUMBER,
      SCALE,
      PANEL,
      SDO_GEOMETRY(PA1.LLDG_GEOM.SDO_GTYPE,
      8307,
      NULL,
      PA1.LLDG_GEOM.SDO_ELEM_INFO,
      PA1.LLDG_GEOM.SDO_ORDINATES) AS GEOMETRY
   FROM
      RNC_PANEL_0 PA1
);

--convert googlg coordinates
CREATE TABLE RNC_PANEL_V3 AS
   SELECT
      CHARTVER_ID,
      REP_ID,
      STRINGVAL,
      PANELVER_ID,
      PRODUCT_STATUS,
      PANELNUMBER,
      SCALE,
      PANEL,
      SDO_CS.TRANSFORM(GEOMETRY, 8307) AS GEOMETRY
   FROM
      RNC_PANEL_V2;

SELECT
   SRID,
   COORD_REF_SYS_NAME
FROM
   SDO_COORD_REF_SYS
WHERE
   COORD_REF_SYS_KIND = 'VERTICAL'
ORDER BY
   SRID;

SELECT
   *
FROM
   SDO_COORD_REF_SYS
WHERE
   SRID = 4167;

CREATE TABLE RNC_PANEL_V3 AS
   SELECT
      CHARTVER_ID,
      REP_ID,
      STRINGVAL,
      PANELVER_ID,
      PRODUCT_STATUS,
      PANELNUMBER,
      SCALE,
      PANEL,
      SDO_CS.TRANSFORM(GEOMETRY, 4167) AS GEOMETRY
   FROM
      RNC_PANEL_V2;
