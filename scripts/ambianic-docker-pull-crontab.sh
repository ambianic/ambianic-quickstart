#!/bin/bash

# This crontab task is responsible for pulling ambianic edge and associated docker images for the first time
# and ensure that the docker compose service is up and running with the pulled images

# make sure we have wget installed
if ! command -v "wget" &> /dev/null; then
  sudo apt update -q && sudo apt install wget -y
fi

# Check if internet connection is available
wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Online. Continuing with image pull."
    # check if the ambianic container is already pulled
    sudo docker ps --filter "name=ambianic-edge" | grep ambianic
    if [ $? -eq 0 ]; then
      echo "Ambianic docker image pulled. This crontab job is no longer needed."
      echo "Removing from crontab schedule."
      me=`basename "$0"`
      crontab -l | grep -v '$me'  | crontab -
    else
      echo "Ambianic docker image has not been pulled yet."
      echo "Restarting docker-compose to initiate pull."
      sudo systemctl restart docker-compose-app
    fi
else
    echo "Offline. Will try again later."
fi
