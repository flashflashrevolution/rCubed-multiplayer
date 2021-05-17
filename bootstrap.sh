if git diff --quiet HEAD -- ':!bootstrap.sh'; then
    # Reset
    echo "\nReset"
    git clean -fdx

    # Install JDK
    echo "\nInstall JDK"
    #wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz # JDK 1.8
    #wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz # JDK 11
    wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.2%2B7/OpenJDK15U-jdk_x64_linux_hotspot_15.0.2_7.tar.gz # JDK 15
    #wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz # JDK 16
    mkdir -p jdk
    pv openjdk.tar.gz | tar --strip-components=1 --no-overwrite-dir -zxf - -C ./jdk

    # Install SmartFoxServer 2.17.0
    echo "\nInstall SmartFoxServer 2X 2.17.0"
    wget -nc -O sfs2x-2.17.0.tar.gz https://www.smartfoxserver.com/downloads/sfs2x/SFS2X_unix_2_17_0.tar.gz
    mkdir -p sfs
    pv sfs2x-2.17.0.tar.gz | tar --strip-components=1 --no-overwrite-dir -zxf - -C ./sfs

    # Configure SFS2X Extensions path
    echo "\nConfigure SFS2X Extensions path"
    rm -rf sfs/SFS2X/extensions
    ln -sfv /workspaces/rCubed-multiplayer/extensions /workspaces/rCubed-multiplayer/sfs/SFS2X/extensions

    # Configure SFS2X Zones path
    echo "\nConfigure SFS2X Zones path"
    rm -rf sfs/SFS2X/zones
    ln -sfv /workspaces/rCubed-multiplayer/zones /workspaces/rCubed-multiplayer/sfs/SFS2X/zones

    # Configure SFS2X Config path
    echo "\nConfigure SFS2X Config path"
    rm -rf /workspaces/rCubed-multiplayer/sfs/SFS2X/config
    ln -sfv /workspaces/rCubed-multiplayer/config /workspaces/rCubed-multiplayer/sfs/SFS2X/

    echo "\nConfigure SFS2X vmoptions"
    rm -rf /workspaces/rCubed-multiplayer/sfs/SFS2X/sfs2x-service.vmoptions
    rm -rf /workspaces/rCubed-multiplayer/sfs/SFS2X/sfs2x-standalone.vmoptions
    ln -sfv /workspaces/rCubed-multiplayer/sfs/SFS2X/config/sfs2x-service.vmoptions /workspaces/rCubed-multiplayer/sfs/SFS2X/sfs2x-service.vmoptions
    ln -sfv /workspaces/rCubed-multiplayer/sfs/SFS2X/config/sfs2x-standalone.vmoptions /workspaces/rCubed-multiplayer/sfs/SFS2X/sfs2x-standalone.vmoptions

    # Replace the embedded SmartFox JDK with our downloaded one.
    echo "\nReplace embedded JDK with downloaded one."
    rm -rf sfs/jre
    ln -sfv /workspaces/rCubed-multiplayer/jdk /workspaces/rCubed-multiplayer/sfs/jre

    echo "\nRemove Build Artifacts"
    rm -f openjdk.tar.gz
    rm -f sfs2x-2.17.0.tar.gz

    # Git Configuration
    echo "\nGit Configuration"
    git config --local core.fileMode false
    git lfs pull
    git config --local core.editor "code --wait"

    # Fix ssh mount issues.
    sudo chown -R vscode:vscode /home/vscode/.ssh

else
    echo "You have uncommitted changes, please stash or commit before bootstrapping."
fi
