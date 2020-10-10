#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo true

# Check if it is a PI or exit
if ! grep -q Raspbian /etc/issue.net; then
  exit 0
fi

echo "Preparing Raspberry PI"

# TODO: check for GPIO, VIDEO and GPU allocation in /boot/config.txt


# enable pi camera as /dev/video*
if ! grep -Fxq "bcm2835-v4l2" /etc/modules
then
  echo "Enabling bcm2835 video driver"
  echo "bcm2835-v4l2" | sudo tee -a /etc/modules
fi
sudo modprobe bcm2835-v4l2


echo "Raspberry PI setup completed!"
exit 0