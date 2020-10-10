#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UI_URL="https://ui.ambianic.ai/"

sudo true

open_ui() {
    echo "Opening Ambianic.ai UI at $UI_URL"
    if type "xdg-open" 2>&1 > /dev/null; then
        xdg-open $UI_URL
    else
       echo "xdg-open not available, please copy the link above to reach the UI."
    fi
}

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
            stop ; start
            ;;
    'status')
            status
            ;;
    'ps')
            status
            ;;
    'logs')
            logs
            ;;
    'ui')
            open_ui
            ;;
    *)
            CMD=$(dirname $0)
            echo
            echo "Usage: $CMD { start | stop | restart | status | logs | ui }"
            echo
            exit 1
            ;;
esac

exit 0