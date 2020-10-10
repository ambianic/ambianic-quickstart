#!/bin/sh
INSTALLDIR="/opt/ambianic"

sudo true
cd $INSTALLDIR && sudo docker-compose down
sudo rm -f /usr/bin/ambianic

echo "\nAmbianic.ai removed. Remove the directory '$INSTALLDIR' to remove all the data on disk"
exit 0