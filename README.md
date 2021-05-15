# Smartfox Server Development Environment

- [Smartfox Server Development Environment](#smartfox-server-development-environment)
  - [Requirements](#requirements)
  - [Where to Clone (For Performance Reasons)](#where-to-clone-for-performance-reasons)
  - [Attach to the dev environment. (Required)](#attach-to-the-dev-environment-required)
  - [Bootstrap (Required)](#bootstrap-required)
  - [MySQL Connection (Optional)](#mysql-connection-optional)
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
1. Hit `F1`, type/trigger `Rebuild and Open in Container`

## Bootstrap (Required)

```zsh
# Read, and then run, the following file.
./bootstrap.sh
```

## MySQL Connection (Optional)

- You will require access to the server for this to work.
- config.develop.xml has the DatabaseManager turned off be default.
- Make sure there is a safe code path when a database cannot be connected to.

```zsh
# Conntects a tunnel to access MySQL server over localhost.
ssh -L 3306:dblocalhost:3306 flashfla@flashflashrevolution.com
```

## Developing (Required)

1. Build the initial `.class` files with `Ctrl + Shift + B`.
1. Start SmartFoxServer:
    ```zsh
    ./start.sh
    ```
2. Build with `Ctrl + Shift + B` to build and reload your extensions.
    - (Note: This currently doesn't work, [see thread](https://www.smartfoxserver.com/forums/viewtopic.php?f=4&p=96649&sid=eadfdce259bad95db397fe75090170c9#p96649).)
    - Alternative Auto Reload strategy:
        1. Switch your "build" task to `Export Jar`.
        2. Build with `Ctrl + Shift + B`.
        3. Use the [Admin Tool](#server-admin-tool-optional) to reload
        the extension after running `Export Jar`.
           - (Warning: If you switch back to `.class` files,
        make sure you delete `./lib/ffr/MultiplayerExtension.jar.`)
3. Attach with `F5` to hit breakpoints.

## Server Admin Tool (Optional)

1. Open `./tools/FlashPlayerDebugger.exe`.
2. File -> Open -> Browse: `./sfs/SFS_PRO_1.6.6/Admin/AdminTool.swf`
3. Login with:
    - IP Address: 127.0.0.1
    - Port: 9339
    - username: admin
    - password: password
