#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $INSTALLDIR

sudo true
docker-compose down
sudo rm -f /usr/bin/ambianic

echo "Ambianic.ai removed. Remove the directory `$INSTALLDIR` to remove all the data on disk."
exit 0