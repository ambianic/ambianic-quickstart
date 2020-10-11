#!/bin/bash
INSTALLDIR=/opt/ambianic
CFG_FILE=/boot/config.txt

sudo true
# Check if it is a PI or exit
if ! grep -q Raspbian /etc/issue.net; then
  exit 0
fi

echo "Preparing Raspberry PI"


# Enable camera: start_x=1
echo "Enable picamera"
sudo raspi-config nonint do_camera 1
sudo sed -i 's/start_x=0/start_x=1/' /boot/config.txt

echo "Allocate GPU"
# 3. Allocate GPU to camera: gpu_mem=256
if ! grep -Fq "gpu_mem=" $CFG_FILE; then
  echo "gpu_mem=256" | sudo tee -a $CFG_FILE
fi

# enable pi camera as /dev/video*
if ! grep -Fxq "bcm2835-v4l2" /etc/modules
then
  echo "Enabling bcm2835 video driver"
  echo "bcm2835-v4l2" | sudo tee -a /etc/modules
fi
sudo modprobe bcm2835-v4l2


echo "Raspberry PI setup completed"
exit 0