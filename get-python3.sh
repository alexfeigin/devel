#!/bin/bash
# install python34 and pip install some useful modules
. utils.sh
log "installing python 3.4"
yum install -y yum-tools
yum-builddep python
yum install -y python34*

log "upgrading pip"

pip3 install --upgrade pip

log "installing useful modules"
pip3 install jupyter ipython bs4 lxml
