#!/bin/bash

# This script is responsible for pulling ambianic edge and associated docker images for the first time
# and ensure that the docker compose service is up and running with the pulled images.
# If pull fails due to internet connection or other reasons, the script will keep retrying until success

echo "Initiating docker image pull..."
until /usr/local/bin/docker-compose pull; 
do 
  echo "docker image pull failed. Will retry in a minute."
  sleep 60; 
done

echo "Docker image pull finished. Starting docker containers..."
/usr/local/bin/docker-compose up -d

