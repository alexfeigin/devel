#!/bin/bash
# Download and install maven 3.3.9
. utils.sh
pushd /opt
log Downloading maven 3.3.9 from apache.spd.co.il
wget http://apache.spd.co.il/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
log Untaring maven
tar xzf apache-maven-3.3.9-bin.tar.gz
log cleaning tar file
rm -f apache-maven-3.3.9-bin.tar.gz
log creating link: ln -s /opt/apache-maven-3.3.9 /usr/local/maven
ln -s /opt/apache-maven-3.3.9 /usr/local/maven
popd
log Creating /etc/profile.d/maven.sh
cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/usr/local/maven
export M3=
export PATH=\${M2_HOME}/bin:\${PATH}
EOF
chmod +x /etc/profile.d/maven.sh
log Finished maven install
