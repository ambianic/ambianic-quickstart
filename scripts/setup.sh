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
cd $INSTALLDIR 

# Setup docker-compose as a system boot service
install -m 644 $INSTALLDIR/docker-compose-app.service "/etc/systemd/system/docker-compose-app.service"

# enable docker compose on boot
sudo systemctl enable docker-compose-app

sudo docker-compose pull 
if [ $? -eq 0 ]; then
  echo "Ambianic docker image pulled. This crontab job is no longer needed."
  echo "Removing from crontab schedule."
  me=`basename "$0"`
  crontab -l | grep -v '$me'  | crontab -
else
  echo "docker-compose is unable to pull the latest ambianic docker images at this time. Check the log for errors."
  echo "Scheduling cronjob to retry pulling docker images until success."
  # ensure the crontab script is executable
  chmod +x $INSTALLDIR/scripts/ambianic-docker-pull-crontab.sh
  (crontab -l ; echo "*/1 * * * * bash $INSTALLDIR/scripts/ambianic-docker-pull-crontab.sh >> $INSTALLDIR/ambianic-docker-pull-crontab.log 2>&1") | crontab -
fi

