#!/bin/bash
. utils.sh

log "get openvswitch"
getpart openvswitch >> $logdir/openvswitch.log 2>&1 &

log "get mininet"
getpart mininet >> $logdir/mininet.log 2>&1 &


log "Create sources dir and clone unimgr"
su $develuser -c "mkdir /home/$develuser/sources; cd /home/$develuser/sources; git clone https://git.opendaylight.org/gerrit/p/unimgr;" > $logdir/clone.log 2>&1 &
for job in `jobs -p`; do wait $job; done


log "Add screen for unimgr in /home/$develuser/.screenrc"
echo 'screen -t "unimgr" sh -c '"'"'cd ~/sources/unimgr; exec /bin/bash'"'" >> /home/$develuser/.screenrc

log "Create an identity file ssh-keygen"
runuser -l $develuser -c "mkdir ~/.ssh; cd ~/.ssh; ssh-keygen -f id_rsa -t rsa -N ''" > $logdir/id.log 2>&1

log Finished


