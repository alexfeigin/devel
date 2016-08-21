#!/bin/bash
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"
yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
yum install -y network-tools vim tigervnc-server openvswitch screen wireshark-gnome
