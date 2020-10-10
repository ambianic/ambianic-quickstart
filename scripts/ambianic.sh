#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo true

logs() {
    cd $INSTALLDIR && sudo docker-compose logs -f --tail 100 ambianic-edge
}

status() {
    cd $INSTALLDIR && sudo docker-compose ps ambianic-edge
}

start() {
    cd $INSTALLDIR && sudo docker-compose up -d
}

kill_cmd() {
    cd $INSTALLDIR && sudo docker-compose kill && sudo docker-compose down
}

stop() {
    cd $INSTALLDIR && sudo docker-compose down
}

case "$1" in
    'start')
            start
            ;;
    'stop')
            stop
            ;;
    'kill')
            kill_cmd
            ;;
    'restart')
            stop ; echo "Sleeping..."; sleep 1 ;
            start
            ;;
    'status')
            status
            ;;
    'logs')
            logs
            ;;
    *)
            echo
            echo "Usage: $0 { start | stop | restart | status | logs }"
            echo
            exit 1
            ;;
esac

exit 0