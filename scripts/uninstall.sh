#!/bin/sh
INSTALLDIR="/opt/ambianic"

sudo true

purge() {
    if [ -d "$INSTALLDIR" ]; then
        cd $INSTALLDIR && sudo docker-compose down
    fi
    sudo rm -f /usr/bin/ambianic
    sudo rm -rf /etc/ambianic
    sudo rm -rf /opt/ambianic
    echo "\nAmbianic.ai removed"
    exit 0
}

confirm() {
    echo "This command will purge all the data and configuration of Ambianic.ui"
    echo -n "Continue? y or n "
    read REPLY
    case $REPLY in
    [Yy]) purge ;; 
    [Nn]) break ;;        # exit case statement gracefully
    *) confirm ;;
    esac
    # REPLY=''
}

confirm
