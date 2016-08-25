#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log installing rdo-release yum repo
yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
log installing openvswitch 
yum install -y openvswitch
wget https://rawgit.com/alexfeigin/devel/master/openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
yum install -y ./openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
log Finished installing 
