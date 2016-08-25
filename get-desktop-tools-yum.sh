#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log installing groups '"Development Tools" "GNOME Desktop" "Graphical Administration Tools"'
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"
log installing network-tools vim tigervnc-server screen wireshark-gnome
yum install -y network-tools vim tigervnc-server screen wireshark-gnome
log Finished installing desktop and tools
