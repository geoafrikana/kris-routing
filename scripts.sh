sudo apt install osm2pgsql
sudo apt install osmium-tool
psql \
"postgresql://$POSTGRES_USER:$PGPASSWORD@localhost:5432/kris" \
-c "CREATE EXTENSION postgis; CREATE EXTENSION hstore; CREATE EXTENSION pgrouting;"

