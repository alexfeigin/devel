#!/bin/bash
. utils.sh

log "Maven settings.xml for opendaylight devs"
runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
wget -q -O - https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

log "Set MAVEN_OPTS"
echo 'export MAVEN_OPTS='"'"'-Xmx2024m -XX:MaxPermSize=512m'"'" >> /home/$develuser/.bashrc

log Finished
