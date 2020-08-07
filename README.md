# Ambianic Quick Start

A collection of files and scripts to run ambianic.ai on your Raspberry Pi

## Quick install on Raspberry Pi or Debian-based distro

```sh
wget -qO - https://raw.githubusercontent.com/ambianic/ambianic-quickstart/master/setup.sh | sh
```

## Troubleshooting the Picamera

- Read the offcial Picamera [troubleshooting section](https://www.raspberrypi.org/documentation/raspbian/applications/camera.md)
- Ensure to run `raspi-config` and enable the video source under the Interfacing menu
- See if the camera is available with `vcgencmd get_camera` and expect to have `supported=1 detected=1`
- Use `raspistill -o image.jpg` to test the camera connection and ensure no errors are shown

If  you get an error ensure the camera is connected to the pins in the center of the board (labelled as camera)