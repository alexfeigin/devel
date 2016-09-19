#!/bin/bash
. utils.sh

log "Set .bashrc"

home=/home/$develuser
if [[ "$develuser" == "root" ]]; then home="/root"; fi
log "Modify PS1"
echo "export PS1='"'[\A][\u@\[`[ $? = 0 ] && X=2 || X=1; tput setaf $X`\]\h\[`tput sgr0`\]:\w]\$ '"'" >> $home/.bashrc

log "Set karaf debug"
echo 'export KARAF_DEBUG=true' >> $home/.bashrc
echo 'export JAVA_DEBUG_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"' >> $home/.bashrc

chown $develuser $home/.bashrc
chgrp $develuser $home/.bashrc

log "Finished .bashrc update"
