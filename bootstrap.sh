wget -nc -O openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz
mkdir -p jdk
pv openjdk.tar.gz | tar --strip-components=1 --no-overwrite-dir -zxf - -C ./jdk
rm -f openjdk.tar.gz
git config --local core.fileMode false
git lfs pull
