#!/bin/bash
INSTALLDIR=/opt/ambianic
COMPOSE_VERSION=1.26.0

sudo true

if ! type "wget" > /dev/null; then
  sudo apt update -q && sudo apt install wget -y
fi

if ! type "docker" > /dev/null; then
  echo "Installing docker"
  wget -qO- https://get.docker.com/ | sh
  sudo usermod -aG docker ${USER}
fi

if ! type "docker-compose" > /dev/null; then
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