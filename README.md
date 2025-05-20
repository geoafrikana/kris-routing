# Kris Routing

![Build](https://github.com/geoafrikana/kris-routing/actions/workflows/build_kris.yml/badge.svg)
![Python](https://img.shields.io/badge/python-3.12-blue)
![License](https://img.shields.io/github/license/geoafrikana/kris-routing)

This project builds and tests a routing backend for Yaoundé, Cameroon using OpenStreetMap (OSM) data, PostgreSQL with PostGIS, and pgRouting. The automation is managed using GitHub Actions.

## Features

- Automatic ETL pipeline for OSM data
- Spatial database setup with PostGIS and pgRouting
- Routing graph import using `osm2pgrouting`
- Automated tests for backend code
- Containerized setup using Docker Compose

## Workflow Summary

The GitHub Actions CI/CD pipeline performs the following:

1. **Checkout the repository**
2. **Start PostgreSQL via Docker Compose**
3. **Enable PostgreSQL extensions:**
   - `hstore`
   - `postgis`
   - `pgrouting`
4. **Install tools:**
   - `osmctools`
   - `osm2pgrouting`
   - `osmium-tool`
   - Python 3.12 with [`uv`](https://astral.sh/blog/uv/)
5. **Download and process OSM data:**
   - Downloads Cameroon extract from [Geofabrik](https://download.geofabrik.de/africa/cameroon.html)
   - Extracts Yaoundé region using bounding box
   - Reduces and converts OSM data
   - Loads routing network into PostgreSQL
6. **Run backend tests** with `pytest`

## OSM Data Source

- **Download URL:** `https://download.geofabrik.de/africa/cameroon-latest.osm.pbf`
- **Bounding Box for Yaoundé:** `10.1,3.01,13.39,6.31`

## Local Development

You can replicate the ETL process locally with:

```bash
# Start services
cd scripts
docker compose up -d

# Run PostgreSQL readiness check
pg_isready -h localhost -p 5432 -U <your_user>

# Create extensions
psql "postgresql://<user>:<password>@localhost:5432/<dbname>" -c \
  "CREATE EXTENSION IF NOT EXISTS hstore; \
   CREATE EXTENSION IF NOT EXISTS pgrouting CASCADE;"

# Install dependencies
sudo apt install osmctools osm2pgrouting osmium-tool
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install 3.12

# Download and process data
wget https://download.geofabrik.de/africa/cameroon-latest.osm.pbf
osmium extract -b 10.1,3.01,13.39,6.31 cameroon-latest.osm.pbf -o yaounde.pbf
osmconvert yaounde.pbf --drop-author --drop-version --out-osm -o=yaounde_reduc.osm

osm2pgrouting \
  --f yaounde_reduc.osm \
  --dbname <your_db> \
  --username <your_user> --clean \
  -W <your_password>

## Testing
```bash
cd backend
uv sync --dev
export PYTHONPATH=.
uv run pytest
```
## Environment Variables

| Variable               | Description                     |
| ---------------------- | ------------------------------- |
| `POSTGRES_USER`        | PostgreSQL username             |
| `PGPASSWORD`           | PostgreSQL password             |
| `POSTGRES_DB`          | PostgreSQL database name        |
| `CAMEROON_PBF_URI`     | OSM data source URI             |
| `YAOUNDE_BOUNDING_BOX` | Bounding box for Yaoundé region |

## License
MIT or specify your preferred license here.

## Credits
- OSM data © OpenStreetMap contributors
- Routing tools: osm2pgrouting, pgRouting
