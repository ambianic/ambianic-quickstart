#!/bin/bash

# This script is responsible for pulling ambianic edge and associated docker images for the first time
# and ensure that the docker compose service is up and running with the pulled images.
# If pull fails due to internet connection or other reasons, the script will keep retrying until success

echo "Initiating docker image pull..."
until /usr/local/bin/docker-compose pull
do 
  echo "docker image pull failed. Will retry in a minute."
  sleep 60
done

echo "Cleaning up artifacts left over from an unexpected power outage or a crash..."
# clean up leftover lock artifacts in case of power outage or other accidental crash
sudo rm -f /opt/ambianic/data/data/.__timeline-event-log.yaml.lock

echo "Docker image pull finished. Starting docker containers..."
/usr/local/bin/docker-compose up -d

