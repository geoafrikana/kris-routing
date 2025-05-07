sudo apt install osm2pgsql
sudo apt install osmium-tool
psql \
"postgresql://$POSTGRES_USER:$PGPASSWORD@localhost:5432/kris" \
-c "CREATE EXTENSION postgis; CREATE EXTENSION hstore; CREATE EXTENSION pgrouting;"

PGPASSWORD=$PGPASSWORD osm2pgsql --host localhost -U $POSTGRES_USER \
	--database $POSTGRES_DB --verbose  \
	--hstore-all --create yaounde.pbf

