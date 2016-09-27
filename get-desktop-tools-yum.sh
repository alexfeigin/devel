#!/bin/bash
. utils.sh
log installing groups '"Development Tools" "GNOME Desktop" "Graphical Administration Tools"'
yum groupinstall -y "Development Tools" "GNOME Desktop" "Graphical Administration Tools"

log installing yum packages 
yum -y install epel-release
yum -y install epel-release net-tools vim
yum -y \
install python-{devel,setuptools,virtualenv} \
@development \
tigervnc-server \
yum-utils \
unzip \
sshuttle \
nc \
libffi-devel \
openssl-devel \
libpng-devel \
freetype-devel \
python-matplotlib \
crudini \
libpcap-devel \
boost-devel \
firefox \
xorg-x11-server-Xvfb \
alacarte \
python-netaddr \
python-docker-py \
python-pip \
wireshark-gnome.x86_64 \
screen \
virt-manager \
tmux \
mock \
sshpass \
zsh \
git-review
log Finished installing desktop and tools
