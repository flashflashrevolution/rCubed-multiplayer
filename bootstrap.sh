wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz
mkdir -p jdk
pv openjdk.tar.gz | tar --strip-components=1 --no-overwrite-dir -zxf - -C ./jdk
rm -f openjdk.tar.gz

# Install SmartFoxServer 1.6.6
wget -nc -O sfs-1.6.6.tar.gz https://www.smartfoxserver.com/downloads/sfs1/SFSPRO_linux64_1.6.6.tar.gz
mkdir -p sfs-temp
pv sfs-1.6.6.tar.gz | tar --strip-components=1 --no-overwrite-dir -zxf - -C ./sfs-temp
printf "$PWD/sfs" | ./sfs-temp/install

# Install SmartFoxServer 1.6.20 Patch
cd ..
wget -nc -O sfs-patch-1.6.20.zip https://www.smartfoxserver.com/downloads/sfs1/SFSPRO_Patch_1.6.20.zip
unzip -o sfs-patch-1.6.20.zip -d sfs-patch | pv -l >/dev/null
cp -R sfs-patch/SFSPRO_Patch_1.6.20/Server/ sfs/SFS_PRO_1.6.6/Server/lib


# Git Configuration
git config --local core.fileMode false
git lfs pull
git config --local core.editor "code --wait"
