#!/bin/bash

# set bash flags: e - fail on unset vars, x - verbose, u - fail quick 
set -exu

INSTALLDIR=/opt/ambianic
COMPOSE_VERSION=1.26.0

sudo true



if ! command -v "wget" &> /dev/null; then
  sudo apt update -q && sudo apt install wget -y
fi

# Re-Install ARM/Raspberry Pi ca-certifcates
# Which otherwise cause SSL Certificate Verification problems.
if $(arch | grep -q arm)
then
  echo "Re-Installing ca-certifcates on Raspberry Pi / ARM CPU"
  sudo dpkg --configure -a  
  sudo apt-get remove -y ca-certificates
  sudo apt-get update
  sudo apt-get install -y ca-certificates
fi

if ! command -v "docker" &> /dev/null; then
  echo "Installing docker"
  wget -qO- https://get.docker.com/ | sh
  # Eenable docker access for FIRST_USER_NAME if set,
  # otherwise grant docker access for USER.
  # Using bash parameter expansion: https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
  DOCKER_USER=${FIRST_USER_NAME:-$USER}
  echo "Granting docker access to user: ${DOCKER_USER}"
  sudo usermod -aG docker ${DOCKER_USER}
fi

if ! command -v "docker-compose" &> /dev/null; then
  echo "Installing docker-compose"
  if grep -q Raspbian /etc/issue.net; then
    # on PI
    sudo apt-get install -y libffi-dev libssl-dev  python3 python3-pip
    sudo pip3 install docker-compose
  else
    #other linux
    sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

exit 0
