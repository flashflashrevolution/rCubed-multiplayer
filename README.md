# Smartfox Server Development Environment

## Attach to the dev environment.

1. Install the Remove - Containers extension in for Visual Studio Code.
1. Hit `F1`, trigger: remote-containers rebuildAndReopenInContainer

## Bootstrap (Get the JDK)

Run `./bootstrap.sh`

## MySQL Connection

Note that you'll need access to the server for this to work.
config.develop.xml has the DatabaseManager turned off be default.

`ssh -L 3306:dblocalhost:3306 flashfla@flashflashrevolution.com -q 2> /dev/null`

## Developing

1. Run `./start.sh` after attaching to the container.
1. Build with `Ctrl + Shift + B` to build and reload your extensions.
1. Attach with `F5` to hit breakpoints.

## Server Admin Tool

1. Open the "FlashPlayerDebugger.exe".
1. File -> Open -> Browse: sfs/SFS_PRO_1.6.6/AdminTool.swf
1. Login with:
    - IP Address: 127.0.0.1
    - Port: 9339
    - username: admin
    - password: password
