# Smartfox Server Development Environment

## Attach to the dev environment. (Required)

1. Install the Remove - Containers extension in for Visual Studio Code.
1. Hit `F1`, type/trigger `Rebuild and Open in Container`
1. Hit `F1`, type/trigger `Reopen Container Locally`
1. Wait for the pop-up that asks you if you'd like to "Clone" into this container. Click that.

## Bootstrap (Required)

Run `./bootstrap.sh`

## MySQL Connection (Optional)

Note that you'll need access to the server for this to work.
config.develop.xml has the DatabaseManager turned off be default.

`ssh -L 3306:dblocalhost:3306 flashfla@flashflashrevolution.com -q 2> /dev/null`

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

1. Open the "FlashPlayerDebugger.exe".
1. File -> Open -> Browse: sfs/SFS_PRO_1.6.6/AdminTool.swf
1. Login with:
    - IP Address: 127.0.0.1
    - Port: 9339
    - username: admin
    - password: password
