#!/bin/bash

log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
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

log 'Fix "Authentication is required to set the network proxy used for downloading packages" message'
echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/gnome-software-service.desktop

log Finished gnome setup
