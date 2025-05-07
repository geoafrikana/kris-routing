sudo apt install osm2pgsql
sudo apt install osmium-tool
sudo apt install osmctools
sudo apt install osm2pgrouting
psql \
"postgresql://$POSTGRES_USER:$PGPASSWORD@localhost:5432/kris" \
-c "CREATE EXTENSION postgis; CREATE EXTENSION hstore; CREATE EXTENSION pgrouting;"

PGPASSWORD=$PGPASSWORD osm2pgsql --host localhost -U $POSTGRES_USER \
	--database $POSTGRES_DB --verbose  \
	--hstore-all --create yaounde.pbf

osmconvert yaounde.pbf \
	--drop-author --drop-version \
	--out-osm -o=yaounde_reduc.osm

osm2pgrouting --f yaounde_reduc.osm \
	--dbname $POSTGRES_DB \
	--username $POSTGRES_USER --clean \
    -W $PGPASSWORD

