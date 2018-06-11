#!/bin/bash
# install python36 and pip install some useful modules
. utils.sh
log "installing python 3.6"

yum install -y yum-tools
yum install -y https://centos7.iuscommunity.org/ius-release.rpm
yum-builddep -y python36u
yum install -y python36u*

log "upgrading pip"

pip3.6 install --upgrade pip

log "installing useful modules"
pip3.6 install jupyter ipython bs4 lxml
