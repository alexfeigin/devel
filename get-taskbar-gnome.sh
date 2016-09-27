#!/bin/bash
. utils.sh
log "start install TaskBar@zpydr"
prevexts=$(gsettings get org.gnome.shell enabled-extensions | cut -d'[' -f2 | cut -d']' -f1)
if [[ "X$(echo $prevexts | grep -Eo TaskBar)" == "X" ]]; then
	wget -O /tmp/taskbar.zip "https://extensions.gnome.org/download-extension/taskbar@zpydr.shell-extension.zip?version_tag=5877"
	mkdir -p /usr/share/gnome-shell/extensions/TaskBar@zpydr/
	unzip /tmp/taskbar.zip -d /usr/share/gnome-shell/extensions/TaskBar@zpydr/
	if [[ "X$prevexts" == "X" ]]; then ext="['TaskBar@zpydr']"; else ext="[$prevexts, 'TaskBar@zpydr']"; fi
	gsettings set org.gnome.shell enabled-extensions "$ext"
else
	log "TaskBar@zpydr already installed"
fi
log end

