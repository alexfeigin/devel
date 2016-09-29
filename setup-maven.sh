#!/bin/bash
. utils.sh

log "Maven settings.xml for opendaylight devs"
runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
getproxy mvnsets "https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml"
. .proxies.sh
wget -q -O - $mvnsetsproxy > /home/$develuser/.m2/settings.xml
chown $develuser /home/$develuser/.m2/settings.xml
chgrp $develuser /home/$develuser/.m2/settings.xml
log "Set MAVEN_OPTS"
echo 'export MAVEN_OPTS='"'"'-Xmx2024m -XX:MaxPermSize=512m'"'" >> /home/$develuser/.bashrc

log Finished
