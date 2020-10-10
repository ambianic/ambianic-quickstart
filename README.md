# Ambianic Quick Start

A collection of files and scripts to run ambianic.ai on your Raspberry Pi or Debian-like machine.

## Quick install script

```sh
wget -qO - https://raw.githubusercontent.com/ambianic/ambianic-quickstart/master/installer.sh | sh
```

## Usage

The setup will install an `ambianic` CLI command to control the setup

```sh
    Usage: ambianic { start | stop | restart | status | logs | ui }
```

- `start`, `stop`, `restart`: start/stop/restart the local `ambianic-edge` instance
- `status`: shows the instance status
- `logs`: logs on stdout the instance logs
- `ui`: opens the Ambianic.ai UI
- `upgrade`: Run the installer and upgrade the local setup

## Uninstall

```sh
cd /opt/ambianic && ./script/uninstall.sh