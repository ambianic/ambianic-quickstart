#!/bin/bash
INSTALLDIR=/opt/ambianic
CONFIGDIR=/etc/ambianic
WORKSPACE=$INSTALLDIR/workspace
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

if [ ! -d "$WORKSPACE" ]
then
  sudo mkdir -p $WORKSPACE
  echo "${PREFIX}Creating workspace for ambianic docker image: $WORKSPACE"  
fi

if [ ! -d "$CONFIGDIR" ]
then
  sudo mkdir -p $CONFIGDIR
  echo "${PREFIX}Creating default configurations in $CONFIGDIR"  
fi

if [ ! -f "$WORKSPACE/peerjs.json" ]
then
  # creating config file in workspace dir first due to issues with docker file volume mapping
  echo "{}" | sudo tee $WORKSPACE/peerjs.json
  chmod 644 $WORKSPACE/peerjs.json
  # linking config file in system conventional path location
  ln -s $WORKSPACE/peerjs.json $CONFIGDIR/peerjs.json
fi
if [ ! -f "$WORKSPACE/config.yaml" ]
then
  # creating config file in workspace dir first due to issues with docker file volume mapping
  sudo mv $INSTALLDIR/config.yaml $WORKSPACE/config.yaml
  chmod 644 $WORKSPACE/config.yaml
  # linking config file in system conventional path location
  ln -s $WORKSPACE/config.yaml $CONFIGDIR/config.yaml
fi

echo "PEERJS_CONFIG=$CONFIGDIR/peerjs.json\nCONFIG=$CONFIGDIR/config.yaml" | sudo tee $INSTALLDIR/.env


# Attempt to kill overlapping containers
echo "${PREFIX}Removing legacy containers.."
sudo docker stop ambianic-edge ambianic-watchtower || true
sudo docker rm -f ambianic-edge ambianic-watchtower || true

echo "${PREFIX}Updating images.."
cd $INSTALLDIR 

# Setup docker-compose as a system boot service
install -m 644 $INSTALLDIR/docker-compose-app.service "/etc/systemd/system/docker-compose-app.service"

# enable docker compose on boot
sudo systemctl enable docker-compose-app
