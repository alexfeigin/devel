#!/bin/bash
. utils.sh
log installing groups '"X Window System" "Fonts"'
yum groupinstall -y "X Window System" "Fonts"

log installing Gnome minimal
yum -y install epel-release
yum -y install epel-release gnome-classic-session gnome-terminal control-center tigervnc-server alacarte xorg-x11-server-Xvfb
log Finished installing Gnome minimal
