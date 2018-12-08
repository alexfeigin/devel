#!/bin/bash
curl -sL https://cdn.jsdelivr.net/gh/alexfeigin/devel/utils.sh > utils.sh
. utils.sh
logdir=/var/log/devel/init
mkdir -p $logdir
exec > >(tee -ia $logdir/init.log)
log "Run yum update"
yum update -y >> $logdir/update.log 2>&1

log "Disable Network Manager and firewalld and enable legacy network service"
getpart network >> $logdir/network.log 2>&1

log "Installing desktop-tools this may download and install 2G of software (give it time)"
getpart desktop-tools-yum

log "Installing python3"
getpart python3

parts="chrome-rpm"
readparam installeclipse "should install eclipse? (Y/N)[N]" N
if [[ $installeclipse == "Y" ]]; then parts=$parts" maven eclipse"; fi
readparam installclion "should install clion? (Y/N)[N]" N
if [[ $installclion == "Y" ]]; then parts=$parts" clion"; fi

log "Install $parts async"
for part in $parts; do
	log "Installing $part"
	getpart $part >> $logdir/$part.log 2>&1 &
done
log "Waiting for all async installations to complete"
for job in `jobs -p`; do wait $job; done
 
readparam jdk "Which jdk provider do you prefer ([open]/oracle)" open;
if [[ "$jdk" == "oracle" ]]; then 
	log "Install Oracle jdk 1.8"
else
	log "Install openjdk 1.8"
	jdk="open"
fi
getpart "$jdk"jdk >> $logdir/jdk.log 2>&1

readparam develuser "Please enter your devel user [devel]" devel
readparam develpwd "Please enter your devel password [devel]" devel
readparam develvncpwd "Please enter your devel vnc password [develpass]" develpass
readparam gituser "Please enter your git user.name [Devel Name]" "Devel Name"
readparam gitemail "Please enter your git user.email [devel@company.com]" devel@company.com

log "Setting up user"
setuppart user >> $logdir/user.log 2>&1 

log "Setup user configuration async"
for part in maven git vnc screen gnome bashrc; do
	log "Setting up $part async"
	setuppart $part >> $logdir/$part.log 2>&1 &
done

log "Waiting for all async setups to complete"
for job in `jobs -p`; do wait $job; done

log "setting up devtoolset"
setuppart devtoolset >> $logdir/devtoolset.log 2>&1

log "Finished spinup of centos devel - please reboot and check"
