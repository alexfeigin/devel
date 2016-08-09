# install vnc server gnome and dev tools
yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
yum update -y
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"
yum install -y network-tools wget vim tigervnc-server openvswitch screen wireshark-gnome

# Download and install maven 3.3.9 and java 1.8.0_77
pushd /opt
wget http://download.oracle.com/otn/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz
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
export PATH=${JAVA_HOME}/bin:${PATH}
EOF
cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/usr/local/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
chmod +x /etc/profile.d/java.sh
chmod +x /etc/profile.d/maven.sh

develuser="devel"
develpwd="devel"
develvncpwd="$develpwd"pass

# add user devel and setup vnc
useradd -c "User $develuser" $develuser
echo $develpwd | passwd $develuser --stdin
usermod -aG wheel $develuser
sed -i "s:^#%wheel:UNCOMMENT%wheel:g" /etc/sudoers
sed -i "s:^%wheel:#%wheel:g" /etc/sudoers
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
mkdir -p /home/$develuser/.vnc
mkdir -p /root/.vnc
echo $develvncpwd | vncpasswd -f > /home/$develuser/.vnc/passwd
echo rootpass | vncpasswd -f > /root/.vnc/passwd

# override screen PROMPT_COMMAND
echo "unset PROMPT_COMMAND" > /etc/sysconfig/bash-prompt-screen
chmod +x /etc/sysconfig/bash-prompt-screen


mkdir -p /home/$develuser/.m2
wget -q -O - https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

su $develuser -l -c logout
echo 'export MAVEN_OPTS='"'"'-Xmx1048m -XX:MaxPermSize=512m'"'" >> /home/devel/.bashrc

# disable firewalld and NetworkManager enable legacy network
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl start network
systemctl enable network

