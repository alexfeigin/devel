#!/bin/bash
. utils.sh
pushd /opt
log Downloading JDK 8 update 77 from oracle.com
wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
log Untaring
tar xzf jdk-8u77-linux-x64.tar.gz
log cleaning tar file
rm -f jdk-8u77-linux-x64.tar.gz
log create link ln -s /opt/jdk1.8.0_77 /usr/local/java
ln -s /opt/jdk1.8.0_77 /usr/local/java
popd

log createing /etc/profile.d/java.sh
cat << EOF > /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/java
export PATH=\${JAVA_HOME}/bin:\${PATH}
EOF
chmod +x /etc/profile.d/java.sh
log Finished installing JDK
