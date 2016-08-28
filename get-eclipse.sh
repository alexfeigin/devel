#!/bin/bash
# setup eclipse
. utils.sh

pushd /opt
log Downloading neon eclipse from mirror.switch.ch
wget http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
log Untaring eclipse
tar xzf eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
mv eclipse eclipse-neon 
log Creating link: ln -s /opt/eclipse-neon /usr/local/eclipse
ln -s /opt/eclipse-neon /usr/local/eclipse
log cleaning tar file
rm -f eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
popd
log Creating /etc/profile.d/eclipse.sh
cat << EOF > /etc/profile.d/eclipse.sh
export ECLIPSE_HOME=/usr/local/eclipse
export PATH=\${ECLIPSE_HOME}:\${PATH}
EOF
chmod +x /etc/profile.d/eclipse.sh
sed -i "s/-Xmx1024m/-Xmx2048m/g" /opt/eclipse-neon/eclipse.ini
log Finished eclipse install 
