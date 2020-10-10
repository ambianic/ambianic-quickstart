#!/bin/bash

INSTALLDIR=/opt/ambianic
BRANCH=master

sudo true

if ! type "git" > /dev/null; then
    sudo apt update -q && sudo apt install git -y
fi

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
        sudo git pull
        sh $INSTALLDIR/scripts/setup.sh
        sh $INSTALLDIR/scripts/updates.sh
        echo "Restarting Ambianic.ai"
        sudo ambianic restart
        exit 0
    fi
fi

# clean install
echo "Installing in $INSTALLDIR"
sudo git clone -b $BRANCH https://github.com/ambianic/ambianic-quickstart.git $INSTALLDIR
sh $INSTALLDIR/scripts/setup.sh
echo "Starting Ambianic.ai"
sudo ambianic start
exit 0

