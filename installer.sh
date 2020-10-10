#!/bin/bash

INSTALLDIR=/opt/ambianic

sudo true

sudo apt update -q && sudo apt install git -y

echo "Installing Ambianic.ai in $INSTALLDIR"

# directory exists
if [ -d "$INSTALLDIR" ]
then
    if [ ! -d "$INSTALLDIR/.git" ]
    then
        echo "Directory $INSTALLDIR exists but is cannot be recognized as an Ambianic.ai installation."
        echo "Move it away or remove it and run again this script to continue the setup."
        exit 1
    else
        echo "Updating ..."
        cd $INSTALLDIR
        git pull
        sh scripts/updates.sh
        echo "Restarting Ambianic.ai"
        ambianic restart
        exit 0
fi

# clean install
echo "Installing in $INSTALLDIR"
sudo git clone https://github.com/ambianic/ambianic-quickstart.git $INSTALLDIR
cd $INSTALLDIR

sh scripts/setup.sh

echo "Starting Ambianic.ai"
ambianic start