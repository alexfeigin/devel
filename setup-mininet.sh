#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log clone into mininet
mkdir /root/sources
cd /root/sources
git clone https://github.com/mininet/mininet.git
cd mininet
latest=$(git tag | grep -Ev '[a-z]' | sort -nr | head -1)
log checkout $latest mininet and create branch for patched/$latest
git checkout $latest
git checkout -b patched/$latest
log apply mininet patch to enable install on CentOS
wget https://rawgit.com/alexfeigin/devel/master/mininet-centos.patch
git am -3 < mininet-centos.patch
log start ./util/install.sh -nf
./util/install.sh -nf
log Finished install mininet - try mn --test pingall