#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo true
echo "Installing Ambianic.ai"

# Install docker and compose if required
bash $SCRIPT_DIR/install-docker.sh

# Scripts to setup Raspberry PI
bash $SCRIPT_DIR/setup-pi.sh

if [ ! -e /usr/bin/ambianic ]
then
  chmod +x ./script/ambianic.sh
  ln -s `pwd`/script/ambianic.sh /usr/bin/ambianic
fi

sudo docker-compose up -d
sleep 2
echo "Ambianic.ai Edge is starting, enjoy! "
sleep 2
