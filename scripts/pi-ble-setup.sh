# Assuming to work from home directory, a sort of linux smart working
cd ~
git clone https://github.com/ambianic/ambianic-quickstart.git -b ble_wifi
cd ~/ambianic-quickstart/
# Install bluetooth and network manager
sudo apt install bluetooth pi-bluetooth bluez network-manager
# Update the image, actually no updates a part a couple of additional log messages
docker-compose pull ambianic-wifi
# setup hci0 controller
sudo systemctl start hciuart
sudo service bluetooth restart
sudo hciconfig hci0 up
# setup the controller, was not working from docker
sudo btmgmt power off
sudo btmgmt bredr off
sudo btmgmt le on
sudo btmgmt power on
# start foreground, ctrl-c to kill
docker-compose up ambianic-wifi
