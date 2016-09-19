#!/bin/bash
mkdir -p /var/log/devel/init
export logdir="/var/log/devel/init"
exec > >(tee -i /var/log/devel/init/init.log)

curl -sL https://rawgit.com/alexfeigin/devel/master/utils.sh > utils.sh
. utils.sh

log "Run yum update"
yum update -y >> $logdir/update.log 2>&1
log "Install wget for easyier scripting"
yum install -y wget >> $logdir/update.log 2>&1

log "Install prerequisites async"
for part in desktop-tools-yum maven eclipse chrome-rpm; do
	log "Installing $part async"
	getpart $part >> $logdir/$part.log 2>&1 &
done
log "Waiting for all async installations to complete"
for job in `jobs -p`; do wait $job; done

log "Disable Network Manager and firewall"
getpart network >> $logdir/network.log 2>&1

#if [[ -e .env.sh ]]; then 
#	read -p "Use existing .env.sh? ([y]/n) `echo $'\n> '`" env
#	if [[ "$env" == "n" ]]; then rm -f .env.sh; fi
#fi
 
readparam jdk "Install jdk ([openjdk]/oracle)" openjdk; . .env.sh
if [ "$jdk" == "oracle" ]; then 
	log "Install Oracle jdk 1.8"
	getpart jdk >> $logdir/jdk.log 2>&1
else 
	log "Install openjdk 1.8"
	getpart openjdk >> $logdir/jdk.log 2>&1 
fi

readparam sdn "Install sdn test tools - openvswitch, mininet (y/[n])" n; . .env.sh
if [ "$sdn" == "y" ]; then
	log "Install sdn"
	getpart sdn >> $logdir/sdn.log 2>&1 
fi

readparam odl "Install Opendaylight build and test tools ([y]/n)" y; . .env.sh
if [ "$odl" == "y" ]; then
        log "Install odl"
        getpart odl >> $logdir/odl.log 2>&1
fi

log "Setting hostname to devel"
hostnamectl set-hostname devel

readparam develuser "Please enter your devel user [devel]" devel
readparam develpwd "Please enter your devel password [devel]" devel
readparam develvncpwd "Please enter your devel vnc password [develpass]" develpass
readparam gituser "Please enter your git user.name [Devel Name]" "Devel Name"
readparam gitemail "Please enter your git user.email [devel@company.com]" devel@company.com
. .env.sh

log "Setting up user"
setuppart user >> $logdir/user.log 2>&1 

log "Setup user configuration async"
for part in maven git vnc screen gnome bashrc; do
	log "Setting up $part async"
	setuppart $part >> $logdir/$part.log 2>&1 &
done
log "Waiting for all async setups to complete"
for job in `jobs -p`; do wait $job; done

log "Finished spinup of centos devel - please reboot and check"
