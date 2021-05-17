# Smartfox Server Development Environment

- [Smartfox Server Development Environment](#smartfox-server-development-environment)
  - [Requirements](#requirements)
  - [Where to Clone (For Performance Reasons)](#where-to-clone-for-performance-reasons)
  - [Attach to the dev environment. (Required)](#attach-to-the-dev-environment-required)
  - [Bootstrap (Required)](#bootstrap-required)
  - [MySQL Connection Access (Optional)](#mysql-connection-access-optional)
  - [Developing (Required)](#developing-required)
  - [Server Admin Tool (Optional)](#server-admin-tool-optional)

## Requirements

Follow the instructions on each of these pages, in order, before continuing.

- [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/) with WSL 2 Backend.

## Where to Clone (For Performance Reasons)

Please clone this repository directly into WSL2.
```zsh
# Type the following in the WSL2 shell, in the repository directory, to continue.
code .
```

## Attach to the dev environment. (Required)

1. Install the `Remote - Containers` extension in for Visual Studio Code.
2. Hit `F1`, type/trigger `Rebuild and Open in Container`

## Bootstrap (Required)

```zsh
# You may need to run the following command to enable execution of bootstrap.
# And if you ever run in to issues with ./start, run this command.
chmod +x bootstrap.sh start.sh

# Read, and then run, the following file.
./bootstrap.sh
```

## MySQL Connection Access (Optional)

- You will need to request access to the server for MySQL to function.
- BasicExamples.zone.xml has the DatabaseManager turned off by default.
- Duplicate BasicExamples.zone.xml and set `databaseManager active="true"`.
- **Do not add MySQL info any zone file that can be checked in to the depo to prevent exposing passwords.**
- Because SQL wont work for everyone, 
make sure there is a safe code path when a database cannot be connected to.

```zsh
# Conntects a tunnel to access MySQL server over localhost.
ssh -L 3306:dblocalhost:3306 flashfla@flashflashrevolution.com
```

## Developing (Required)

1. Build the extension with `Ctrl + Shift + B`.
2. Attach with `F5`. (The tunnel and SmartFox will automatically start)

## Server Admin Tool (Optional)

1. Download and install the standalone [AdminTool](https://www.smartfoxserver.com/download/sfs2x#p=extras).
2. Login with:
    - IP Address: 127.0.0.1
    - Port: 9339
    - username: sfsadmin
    - password: password
