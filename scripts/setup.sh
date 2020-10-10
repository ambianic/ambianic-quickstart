#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPTS_DIR=$INSTALLDIR/scripts

sudo true
echo "Installing Ambianic.ai"

# Install docker and compose if required
bash $SCRIPTS_DIR/install-docker.sh

# Scripts to setup Raspberry PI
bash $SCRIPTS_DIR/setup-pi.sh

if [ ! -e /usr/bin/ambianic ]
then
  chmod +x $SCRIPTS_DIR/ambianic.sh
  sudo ln -s $SCRIPTS_DIR/ambianic.sh /usr/bin/ambianic
fi

# Attempt to kill overlapping containers
docker stop ambianic-edge ambianic-watchtower && docker rm -f ambianic-edge ambianic-watchtower || true
sudo docker-compose up -d --remove-orphans
sleep 2
echo "Ambianic.ai Edge is starting, enjoy! "
sleep 2
