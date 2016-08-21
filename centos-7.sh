#!/bin/bash
# install vnc server gnome and dev tools
yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
yum update -y
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"
yum install -y network-tools wget vim tigervnc-server openvswitch screen wireshark-gnome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y google-chrome-stable_current_x86_64.rpm
# Download and install maven 3.3.9 and java 1.8.0_77
pushd /opt
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
wget http://apache.spd.co.il/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf jdk-8u77-linux-x64.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
rm -f jdk-8u77-linux-x64.tar.gz
rm -f apache-maven-3.3.9-bin.tar.gz
ln -s /opt/jdk1.8.0_77 /usr/local/java
ln -s /opt/apache-maven-3.3.9 /usr/local/maven
popd
cat << EOF > /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/java
export PATH=\${JAVA_HOME}/bin:\${PATH}
EOF
cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/usr/local/maven
export PATH=\${M2_HOME}/bin:\${PATH}
EOF
chmod +x /etc/profile.d/java.sh
chmod +x /etc/profile.d/maven.sh

develuser="devel"
develpwd="devel"
develvncpwd="develpass"

# add user devel and setup vnc
useradd -c "User $develuser" $develuser
echo $develpwd | passwd $develuser --stdin
usermod -aG wheel $develuser
#ssh -X devel@0
sed -i "s:^# %wheel:UNCOMMENT%wheel:g" /etc/sudoers
sed -i "s:^%wheel:# %wheel:g" /etc/sudoers
sed -i "s:^UNCOMMENT%wheel:%wheel:g" /etc/sudoers

cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:2.service
sed -i "s:<USER>:root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:/home/root:/root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:<USER>:$develuser:g" /etc/systemd/system/vncserver@:2.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:1.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:2.service
systemctl daemon-reload
systemctl enable vncserver@:1.service
systemctl enable vncserver@:2.service
runuser -l $develuser -c "mkdir -p /home/$develuser/.vnc"
mkdir -p /root/.vnc
echo $develvncpwd | vncpasswd -f > /home/$develuser/.vnc/passwd; chown $develuser /home/$develuser/.vnc/passwd; chgrp $develuser /home/$develuser/.vnc/passwd;
echo rootpass | vncpasswd -f > /root/.vnc/passwd
chmod 600 /home/$develuser/.vnc/passwd /root/.vnc/passwd

# override screen PROMPT_COMMAND
echo "unset PROMPT_COMMAND" > /etc/sysconfig/bash-prompt-screen
chmod +x /etc/sysconfig/bash-prompt-screen


runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
wget -q -O - https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

su $develuser -l -c logout
echo 'export MAVEN_OPTS='"'"'-Xmx1048m -XX:MaxPermSize=512m'"'" >> /home/devel/.bashrc

# disable firewalld and NetworkManager enable legacy network
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl start network
systemctl enable network

# setup terminal shortcut
cat << EOF > term-scut.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal &"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Primary><Alt>t"
EOF
chmod +x term-scut.sh
./term-scut.sh
fpath=$(readlink -f ./term-scut.sh)
runuser -l $develuser -c $fpath

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

# ssh-keygen
runuser -l $develuser -c "mkdir ~/.ssh; cd ~/.ssh; ssh-keygen -f id_rsa -t rsa -N ''"
