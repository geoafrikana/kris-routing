WITH r as (
SELECT route.*, ways.the_geom FROM pgr_astar(
  'SELECT gid AS id, source, target, cost,
  reverse_cost, x1, y1, x2, y2 FROM ways',
  (
SELECT id
FROM ways_vertices_pgr
ORDER By the_geom <-> ST_SetSRID(
ST_MakePoint(11.515851, 3.478239), 4326) ASC
LIMIT 1
  ),
 (SELECT id FROM ways_vertices_pgr
ORDER By the_geom <-> ST_SetSRID(
ST_MakePoint(11.399078, 4.242791), 4326) ASC
LIMIT 1)
) as route
LEFT JOIN ways
ON route.edge = ways.gid)
SELECT SUM(COST), ST_AsText(ST_LineMerge(
ST_Union(the_geom))
) FROM r;