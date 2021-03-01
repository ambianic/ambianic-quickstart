#!/bin/bash

# set bash flags: e - fail on unset vars, x - verbose, u - fail quick 
set -exu

INSTALLDIR=/opt/ambianic
COMPOSE_VERSION=1.26.0

sudo true



if ! command -v "wget" &> /dev/null; then
  sudo apt update -q && sudo apt install wget -y
fi

# Download and add docker CA certificate to local db
# Necessary because of this issue: https://github.com/ambianic/ambianic-rpi-image/runs/2000160870?check_suite_focus=true#step:9:4235 
echo -n | openssl s_client -connect download.docker.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > docker.crt
sudo cp docker.crt /usr/local/share/ca-certificates
# download amazon root cert which docker.com uses
sudo update-ca-certificates
curl https://www.amazontrust.com/repository/AmazonRootCA1.pem --output /usr/local/share/ca-certificates/amazon.crt
sudo update-ca-certificates

if ! command -v "docker" &> /dev/null; then
  echo "Installing docker"
  # override pre_reqs variable to fix ca cert issue in docker install script
  export pre_reqs="apt-transport-https curl"
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo get-docker.sh
  # wget -qO- https://get.docker.com/ | sh
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
