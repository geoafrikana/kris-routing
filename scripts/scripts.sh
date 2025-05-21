sudo apt install osm2pgsql
sudo apt install osmium-tool
sudo apt install osmctools
sudo apt install osm2pgrouting
psql \
"postgresql://$POSTGRES_USER:$PGPASSWORD@localhost:5432/kris" \
-c "CREATE EXTENSION hstore; CREATE EXTENSION pgrouting CASCADE;"

# YAOUNDE_DOUALA_BOUNDING_BOX: 9.3358,3.7241,11.5766,4.2258 
osmium extract -b 9.3358,3.7241,11.5766,4.2258 \
             cameroon-latest.osm.pbf -o yaounde_douala.pbf

PGPASSWORD=$PGPASSWORD osm2pgsql --host localhost -U $POSTGRES_USER \
	--database $POSTGRES_DB --verbose  \
	--hstore-all --create yaounde_douala.pbf

osmconvert yaounde_douala.pbf \
	--drop-author --drop-version \
	--out-osm -o=yaounde_douala.osm

osm2pgrouting --f yaounde_douala.osm \
	--dbname $POSTGRES_DB \
	--username $POSTGRES_USER --clean \
    -W $PGPASSWORD



