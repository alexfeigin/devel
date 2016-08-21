#!/bin/bash
# Download and install maven 3.3.9
pushd /opt
wget http://apache.spd.co.il/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
rm -f apache-maven-3.3.9-bin.tar.gz
ln -s /opt/apache-maven-3.3.9 /usr/local/maven
popd

cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/usr/local/maven
export PATH=\${M2_HOME}/bin:\${PATH}
EOF
chmod +x /etc/profile.d/maven.sh
