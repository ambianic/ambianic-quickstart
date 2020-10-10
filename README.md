# Ambianic Quick Start

A collection of files and scripts to run ambianic.ai on your Raspberry Pi or Debian-like machine.

## Quick install script

```sh
wget -qO - https://raw.githubusercontent.com/ambianic/ambianic-quickstart/master/installer.sh | sh
```

## Usage

The setup will install an `ambianic` CLI command to control the setup

```sh
    Usage: ambianic { start | stop | restart | status | logs }
```

## Uninstall

```sh
cd /opt/ambianic && ./script/uninstall.sh