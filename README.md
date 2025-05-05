# kris-routing

Installation:
1. Follow the official docker website to install docker. 
2. Follow this Digital Ocean tutorial to use Docker without sudo
3. clone this repo on your server
4. Run the database service;
```bash
docker compose up
```
5. Log into the database with PgAdmin or psql and enable the needed extensions:
```sql
CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
CREATE EXTENSION pgrouting;
```
6. Confirm your pgrouting
```sql
select pgr_version(), postgis_version(), version();
```