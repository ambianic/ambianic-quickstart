
BASE_URL=https://raw.githubusercontent.com/ambianic/ambianic-quickstart/master
AMBIANIC_COMPOSE_YAML=$BASE_URL/docker-compose.yaml
AMBIANIC_CFG=$BASE_URL/config.yaml

sudo true
echo "Installing Ambianic.ai"

sudo apt update -q && sudo apt install wget -y -q

if ! type "docker" > /dev/null; then
  echo "Installing docker"
  wget -qO- https://get.docker.com/ | sh
  #sudo usermod -aG docker ${USER}
fi

if ! type "docker-compose" > /dev/null; then
  echo "Installing docker-compose"
  if grep -q Raspbian /etc/issue.net; then
    # on PI
    sudo apt-get install -y libffi-dev libssl-dev  python3 python3-pip
    sudo pip3 install docker-compose
    # enable pi camera as /dev/video*
    echo "bcm2835-v4l2" | sudo tee -a /etc/modules
    sudo modprobe bcm2835-v4l2    
  else
    #other linux
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

DEST_DIR=/opt/ambianic-edge.prod

# create the workdir
sudo mkdir -p ${DEST_DIR}
sudo chown ${USER} ${DEST_DIR}

# get docker-compose.yaml
wget $AMBIANIC_COMPOSE_YAML

# get config.yml
sudo wget $AMBIANIC_CFG -O ${DEST_DIR}/config.yaml

#sudo su - ${USER}
sudo docker-compose up -d
echo "\n\nAmbianic started, run `sudo docker-compose logs` to see the status"
exit 0
