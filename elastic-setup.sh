#!/bin/bash
# elastic-setup.sh: Create built-in users es_owner and es_reader in the running Elasticsearch container

# Variables
HUB_IMAGE="elastic/elasticsearch:9.0.3"
LOCAL_IMAGE="elasticsearch-secure:9"
ELASTIC_CONTAINER="es01"
OWNER_USER="es_owner"
READER_USER="es_reader"
OWNER_PASS="Qwerty123!"
READER_PASS="Qwerty123!"

# Check if the custom Elasticsearch image is built
if ! docker images | grep -q "elasticsearch-secure"; then
  echo "Custom Elasticsearch image not found. Building from Dockerfile.elasticsearch9..."
  # Ensure the base image is available
  if ! docker images | grep -q "elastic/elasticsearch.*9.0.3"; then
    echo "Pulling $HUB_IMAGE from Docker Hub..."
    docker pull $HUB_IMAGE
  fi
  docker build -f Dockerfile.elasticsearch9 -t $LOCAL_IMAGE .
  docker volume create esdata
fi

# Start the cluster using docker compose
if ! docker compose ps | grep -q "es01"; then
  echo "Starting Elasticsearch cluster with docker compose..."
  docker compose up -d
else
  echo "Elasticsearch cluster is already running."
fi

# Wait for Elasticsearch to be up
until curl -k --silent https://localhost:9200 >/dev/null; do
  echo "Waiting for Elasticsearch to start..."
  sleep 5
done

echo "Creating user: $OWNER_USER"
docker exec $ELASTIC_CONTAINER bin/elasticsearch-users useradd $OWNER_USER -p $OWNER_PASS -r superuser

echo "Creating user: $READER_USER"
docker exec $ELASTIC_CONTAINER bin/elasticsearch-users useradd $READER_USER -p $READER_PASS -r viewer

echo "Users $OWNER_USER and $READER_USER created with password 'Qwerty123!'"
