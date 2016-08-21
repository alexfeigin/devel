#!/bin/bash
# Download and install java 1.8.0_77
pushd /opt
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
tar xzf jdk-8u77-linux-x64.tar.gz
rm -f jdk-8u77-linux-x64.tar.gz
ln -s /opt/jdk1.8.0_77 /usr/local/java
popd

cat << EOF > /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/java
export PATH=\${JAVA_HOME}/bin:\${PATH}
EOF
chmod +x /etc/profile.d/java.sh
