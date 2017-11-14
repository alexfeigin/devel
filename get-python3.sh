#!/bin/bash
# install python34 and pip install some useful modules
. utils.sh
yum install -y yum-tools
yum-builddep python
yum install -y python34*

pip3 install --upgrade pip
pip3 install jupyter ipython bs4 lxml
