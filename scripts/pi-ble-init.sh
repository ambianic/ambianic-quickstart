cd ~/ambianic-quickstart/
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
docker-compose restart ambianic-wifi
