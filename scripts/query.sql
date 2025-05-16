DROP FUNCTION IF EXISTS get_route(float, float, float, float);
DROP FUNCTION IF EXISTS get_route(float, float);
CREATE OR REPLACE FUNCTION get_route(
source_lonx float, source_laty float,
target_lonx  float, target_laty float
) RETURNS TABLE(
total_cost FLOAT,
geom TEXT
)
AS $$
BEGIN
RETURN QUERY

WITH r as (
SELECT route.*, ways.the_geom FROM pgr_astar(
  'SELECT gid AS id, source, target, cost,
  reverse_cost, x1, y1, x2, y2 FROM ways',
  (
SELECT id
FROM ways_vertices_pgr
ORDER By the_geom <-> ST_SetSRID(
ST_MakePoint(source_lonx, source_laty), 4326) ASC
LIMIT 1),

(SELECT id FROM ways_vertices_pgr
ORDER By the_geom <-> ST_SetSRID(
ST_MakePoint(target_lonx, target_laty), 4326) ASC
LIMIT 1)
) as route
JOIN ways
ON route.edge = ways.gid)

SELECT SUM(COST) as total_cost, ST_AsGeoJSON(ST_LineMerge(
ST_Union(the_geom))
) as geom FROM r;

END; $$ 

LANGUAGE 'plpgsql';

SELECT * FROM get_route(11.515851, 3.478239, 11.399078, 4.242791);