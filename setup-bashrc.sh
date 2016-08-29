#!/bin/bash
. utils.sh

log "Set .bashrc"

log "Modify PS1"
echo "export PS1='"'[\u@\[`[ $? = 0 ] && X=2 || X=1; tput setaf $X`\]\h\[`tput sgr0`\]:$PWD]\$ '"'" >> /home/$develuser/.bashrc

log "Set karaf debug"
echo 'export KARAF_DEBUG=true' >> /home/$develuser/.bashrc
echo 'export JAVA_DEBUG_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"' >> /home/$develuser/.bashrc

log "Finished .bashrc update"
