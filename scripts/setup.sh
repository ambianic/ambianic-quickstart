#!/bin/bash
INSTALLDIR=/opt/ambianic
CONFIGDIR=/etc/ambianic
SCRIPTS_DIR=$INSTALLDIR/scripts

PREFIX="--\t"

# This script is run on updates and new install

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

# add autocompletion
if [ -d /etc/bash_completion.d/ ]
then
  if [ ! -f /etc/bash_completion.d/ambianic ]
  then
    sudo ln -s $SCRIPTS_DIR/autocomplete.sh /etc/bash_completion.d/ambianic
    source /etc/bash_completion.d/ambianic
  fi
fi

if [ ! -d "$CONFIGDIR" ]
then
  sudo mkdir -p $CONFIGDIR
  echo "${PREFIX}Creating default configurations in $CONFIGDIR"  
fi

if [ ! -f "$CONFIGDIR/peerjs.json" ]
then
  echo "{}" | sudo tee $CONFIGDIR/peerjs.json
fi
if [ ! -f "$CONFIGDIR/peerjs.json" ]
then
  sudo cp $INSTALLDIR/config.yaml $CONFIGDIR/config.yaml
fi

echo "PEERJS_CONFIG=$CONFIGDIR/peerjs.json\nCONFIG=$CONFIGDIR/config.yaml" | sudo tee $INSTALLDIR/.env


# Attempt to kill overlapping containers
echo "${PREFIX}Removing legacy containers.."
sudo docker stop ambianic-edge ambianic-watchtower || true
sudo docker rm -f ambianic-edge ambianic-watchtower || true

echo "${PREFIX}Updating images.."
cd $INSTALLDIR && sudo docker-compose pull
