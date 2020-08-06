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
wget https://gist.githubusercontent.com/ivelin/3891a7b5d61a12d6a1b9f652b6d53dce/raw/452658c6372f3ebf631e8e1c8567507d74e6e922/docker-compose.yaml

# get config.yml
sudo wget https://gist.githubusercontent.com/ivelin/1d1c885a25ad45bf8a3262653944b82c/raw/704aafa94b10fd2bdb506e8f98e12fa74cfac7e4/config.yaml -O ${DEST_DIR}/config.yaml

#sudo su - ${USER}
sudo docker-compose up -d
echo "Ambianic started, run `sudo docker-compose logs` to see the status"
exit 0
