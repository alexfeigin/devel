#!/bin/bash
# setup eclipse
pushd /opt
wget http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
tar xzf eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
mv eclipse eclipse-neon 
ln -s /opt/eclipse-neon /usr/local/eclipse
rm -f eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
popd
cat << EOF > /etc/profile.d/eclipse.sh
export ECLIPSE_HOME=/usr/local/eclipse
export PATH=\${ECLIPSE_HOME}:\${PATH}
EOF
chmod +x /etc/profile.d/eclipse.sh
