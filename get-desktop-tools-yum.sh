#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log installing groups '"Development Tools" "GNOME Desktop" "Graphical Administration Tools"'
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"
log installing rdo-release yum repo
yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
log installing network-tools vim tigervnc-server openvswitch screen wireshark-gnome
yum install -y network-tools vim tigervnc-server openvswitch screen wireshark-gnome
log Finished installing desktop and tools
