# Ambianic Quick Start CLI

Command Line Interface (CLI) for ambianic edge hosts based on Raspberry Pi or Debian-like OS.

## Quick install script

```sh
wget -qO - https://raw.githubusercontent.com/ambianic/ambianic-quickstart/master/installer.sh | sh
```

## Usage

The setup will install an `ambianic` CLI command to control the setup

```sh
    Usage: ambianic { start | stop | restart | status | logs | ui | upgrade }
```

- `start`, `stop`, `restart`: start/stop/restart the local `ambianic-edge` instance
- `status`: shows the instance status
- `logs`: logs on stdout the instance logs
- `ui`: opens the Ambianic.ai UI
- `upgrade`: Run the installer and upgrade the local setup

## Uninstall

```sh
cd /opt/ambianic && ./scripts/uninstall.sh
