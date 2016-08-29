#!/bin/bash
. utils.sh
log install java-1.8.0-openjdk-devel
yum install -y java-1.8.0-openjdk-devel

log creating link: ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64 /usr/local/java
ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64 /usr/local/java

log Finished installing JDK
