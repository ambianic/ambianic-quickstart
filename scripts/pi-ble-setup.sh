
# Assuming to work from home directory, a sort of linux smart working
cd ~
git clone https://github.com/ambianic/ambianic-quickstart.git -b ble_wifi
cd ~/ambianic-quickstart/

# Install bluetooth and network manager
sudo apt install -y bluetooth pi-bluetooth bluez network-manager

# Ensure network manager can manage wlan0
if ! grep -q "denyinterfaces wlan0" /etc/dhcpcd.conf; then
    echo "Disabling dhcpcd on wlan0"
    echo "denyinterfaces wlan0" | sudo tee -a /etc/dhcpcd.conf
    sudo systemctl daemon-reload
    sudo service dhcpcd restart
    sudo service network-manager restart 
fi

# Update the image, actually no updates a part a couple of additional log messages
docker-compose pull ambianic-wifi


