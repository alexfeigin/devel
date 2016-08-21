#!/bin/bash
# install vnc server gnome and dev tools
yum update -y
yum install -y wget

# Download and unpack maven jdk eclipse chrome - and yum install devel tools and desktop async
for part in desktop-tools-yum maven jdk eclipse chrome-rpm; do
	wget -q https://rawgit.com/alexfeigin/devel/master/get-$part.sh
	chmod +x ./get-$part.sh
	echo getting $part
	./get-$part.sh > $part.log 2>&1 &
done
for job in `jobs -p`; do wait $job; done


develuser="devel"
develpwd="devel"
develvncpwd="develpass"

# Add user devel and let sudoers run with no pass
useradd -c "User $develuser" $develuser
echo $develpwd | passwd $develuser --stdin
usermod -aG wheel $develuser
sed -i "s:^# %wheel:UNCOMMENT%wheel:g" /etc/sudoers
sed -i "s:^%wheel:# %wheel:g" /etc/sudoers
sed -i "s:^UNCOMMENT%wheel:%wheel:g" /etc/sudoers

su $develuser -l -c logout

# Create vnc server services for root :1 and for devel user :2
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

# Override screen PROMPT_COMMAND with hack for backtick display branch
echo "echo \$PWD > /tmp/currpwd" > /etc/sysconfig/bash-prompt-screen
chmod +x /etc/sysconfig/bash-prompt-screen

# Maven settings.xml for opendaylight devs
runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
wget -q -O - https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

# Add maven options - some might be deprecated
echo 'export MAVEN_OPTS='"'"'-Xmx1048m -XX:MaxPermSize=512m'"'" >> /home/devel/.bashrc

# Download gitconfig for useful git aliases and setup
wget -q -O - https://cdn.rawgit.com/alexfeigin/devel/master/gitconfig > /etc/gitconfig

# Disable firewalld and NetworkManager enable legacy network
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl start network
systemctl enable network

# Setup terminal shortcut (create script, run as autostart app in gnome)
mkdir /usr/share/devel
cat << EOF > /usr/share/devel/term-scut.sh
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal &"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Primary><Alt>t"
EOF
chmod +x /usr/share/devel/term-scut.sh

cat << EOF > /etc/xdg/autostart/scuts.desktop
[Desktop Entry]
Name=CustomShortcuts
GenericName=Add custom shortcut
Comment=adds scut for running gnome-terminal
Exec=/usr/share/devel/term-scut.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF

# Fix "Authentication is required to set the network proxy used for downloading packages" message
echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-software-service.desktop

# Create an identity file ssh-keygen
runuser -l $develuser -c "mkdir ~/.ssh; cd ~/.ssh; ssh-keygen -f id_rsa -t rsa -N ''"

# Create sources dir and clone unimgr
su $develuser -c 'mkdir /home/$develuser/sources; cd /home/$develuser/sources; git clone https://git.opendaylight.org/gerrit/p/unimgr;'

# Screenrc
cat << EOF > /tmp/screenrc
hardstatus alwayslastline
hardstatus alwayslastline "%-w%{.bw}%n %t%{-}%+w %-60= %1\`"
defnonblock on
altscreen on
bind X only
defscrollback 3000
deflogin off
startup_message off
backtick 1 0 1 /home/$develuser/git-current-branch.sh

screen -t "$develuser" sh -c 'cd ~; exec /bin/bash'
screen -t "unimgr" sh -c 'cd ~/sources/unimgr; exec /bin/bash'
EOF

su $develuser -c "cat /tmp/screenrc > /home/$develuser/.screenrc"

echo << EOF > /tmp/gcbsh
cd \$(cat /tmp/currdir)
git branch 2>/dev/null | grep '*' | sed 's/\* //'
EOF

su $develuser -c "cat /tmp/gcbsh > /home/$develuser/git-current-branch.sh"
chmod +x /home/$develuser/git-current-branch.sh

# Modify PS1 in bashrc
echo "export PS1='"'[\u@\[`[ $? = 0 ] && X=2 || X=1; tput setaf $X`\]\h\[`tput sgr0`\]:$PWD]\$ '"'" >> /home/$develuser/.bashrc

# TODO: Make script quiet - only output to screen intresting info or progress
# TODO: Setup devel username and password from input
# TODO: Setup git user.name and user.email from input
# TODO: Clone into an opendaylight 'Hello World' project and add it to eclipse workspace


