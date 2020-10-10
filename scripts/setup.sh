#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPTS_DIR=$INSTALLDIR/scripts

PREFIX="--\t"

sudo true
echo "${PREFIX}Installing Ambianic.ai"

# Install docker and compose if required
bash $SCRIPTS_DIR/install-docker.sh

# Scripts to setup Raspberry PI
bash $SCRIPTS_DIR/setup-pi.sh

if [ ! -e /usr/bin/ambianic ]
then
  chmod +x $SCRIPTS_DIR/ambianic.sh
  sudo ln -s $SCRIPTS_DIR/ambianic.sh /usr/bin/ambianic
  echo "${PREFIX}Installed ambianic CLI"
fi


# Attempt to kill overlapping containers
echo "${PREFIX}Removing legacy containers.."
docker stop ambianic-edge ambianic-watchtower || true && docker rm -f ambianic-edge ambianic-watchtower || true

echo "${PREFIX}Updating.."
sudo docker-compose pull
