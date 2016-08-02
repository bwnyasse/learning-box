#!/bin/bash

set -e

echo "Job Import started: $(date)"

# mongoimport est l'utilitaire natif pour faire de l'import https://docs.mongodb.com/manual/reference/program/mongoimport/
mongoimport --quiet --host $MONGO_HOST:$MONGO_PORT --db $MONGO_DB_NAME --collection $MONGO_COLLECTION_NAME --type json --drop --file import.json --jsonArray

echo "Job Import finished: $(date)"
