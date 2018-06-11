#!/bin/bash

. utils.sh
log "Setup terminal shortcut (create script, run as autostart app in gnome)"
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

#log "install chrome-gnome-shell addon to let users install from gnome extension website"
#wget -q https://rawgit.com/alexfeigin/devel/master/chrome-gnome-shell-1.0-1.x86_64.rpm
#yum install -y chrome-gnome-shell-1.0-1.x86_64.rpm

#https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome/Installation
yum install jq p7zip p7zip
git clone git://git.gnome.org/chrome-gnome-shell
pushd chrome-gnome-shell
git checkout v10.1
mkdir build; cd build
cmake3 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_EXTENSION=OFF ../
make install
popd

log 'Fix "Authentication is required to set the network proxy used for downloading packages" message'
echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-software-service.desktop

cat << EOF > /etc/X11/xinit/xinitrc.d/profile.sh
#!/bin/env bash

source /etc/profile
EOF

log Finished gnome setup
