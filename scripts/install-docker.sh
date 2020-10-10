#!/bin/bash
INSTALLDIR=/opt/ambianic

sudo true
sudo apt update -q && sudo apt install wget -y -q

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
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi
