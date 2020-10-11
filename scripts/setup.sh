#!/bin/bash
INSTALLDIR=/opt/ambianic
CONFIGDIR=/etc/ambianic
SCRIPTS_DIR=$INSTALLDIR/scripts

PREFIX="--\t"

sudo true
echo "${PREFIX}Installing Ambianic.ai"

# Install docker and compose if required
echo "${PREFIX}Running docker and docker-compose setup"
bash $SCRIPTS_DIR/install-docker.sh

# Scripts to setup Raspberry PI
echo "${PREFIX}Running Raspberry PI setup"
bash $SCRIPTS_DIR/setup-pi.sh

if [ ! -e /usr/bin/ambianic ]
then
  chmod +x $SCRIPTS_DIR/ambianic.sh
  sudo ln -s $SCRIPTS_DIR/ambianic.sh /usr/bin/ambianic
  echo "${PREFIX}Installed ambianic CLI"
fi

if [ ! -d "$CONFIGDIR" ]
then
  sudo mkdir -p $CONFIGDIR
  sudo touch $CONFIGDIR/secrets.yaml
  sudo cp $INSTALLDIR/config.yaml $CONFIGDIR/config.yaml
  echo "SECRETS=/etc/ambianic/secrets.yaml\nCONFIG=/etc/ambianic/config.yaml" | sudo tee $INSTALLDIR/.env
  echo "${PREFIX}Created default configurations in $CONFIGDIR"
fi

# Attempt to kill overlapping containers
echo "${PREFIX}Removing legacy containers.."
sudo docker stop ambianic-edge ambianic-watchtower || true
sudo docker rm -f ambianic-edge ambianic-watchtower || true

echo "${PREFIX}Updating images.."
cd $INSTALLDIR && sudo docker-compose pull
