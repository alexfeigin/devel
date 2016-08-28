#!/bin/bash
mkdir -p /var/log/devel/init
export logdir="/var/log/devel/init"
exec > >(tee -i /var/log/devel/init/init.log)

curl -sL https://rawgit.com/alexfeigin/devel/master/utils.sh > utils.sh
. utils.sh

log "Run yum update"
yum update -y > $logdir/update.log 2>&1
log "Install wget for easyier scripting"
yum install -y wget >> $logdir/update.log 2>&1

log "Install prerequisites async"
for part in netwrok desktop-tools-yum maven eclipse chrome-rpm ; do
	log "Installing $part"
	getpart $part > $logdir/$part.log 2>&1 &
done
for job in `jobs -p`; do wait $job; done

readparam jdk "Install jdk ([openjdk]/oracle)" openjdk; . .env.sh
if [ "$jdk" == "oracle" ]; then 
	log "Install Oracle jdk 1.8"
	getpart jdk > $logdir/jdk.log 2>&1
else 
	log "Install open-jdk 1.8"
	getpart openjdk  > $logdir/jdk.log 2>&1 
fi

readparam sdn "Install sdn test tools (y/[n])" n; . .env.sh
if [ "$sdn" == "y" ]; then
	log "Install sdn"
	getpart sdn > $logdir/sdn.log 2>&1 
fi

readparam odl "Install Opendaylight build and test tools [y/n]" y; . .env.sh
if [ "$odl" == "y" ]; then
        log "Install odl"
        getpart odl > $logdir/odl.log 2>&1
fi

readparam develuser "Please enter your devel user" devel
readparam develpwd "Please enter your devel password" devel
readparam develvncpwd "Please enter your devel vnc password" develpass
. .env.sh
log Add user $develuser and as sudoer
useradd -c "User $develuser" $develuser
echo $develpwd | passwd $develuser --stdin
usermod -aG wheel $develuser
sed -i "s:^# %wheel:UNCOMMENT%wheel:g" /etc/sudoers
sed -i "s:^%wheel:# %wheel:g" /etc/sudoers
sed -i "s:^UNCOMMENT%wheel:%wheel:g" /etc/sudoers

log "first login user $develuser"
su $develuser -l -c logout

log "Setup user configuration "
for part in vnc screen gnome bashrc; do
	log "Setting up $part"
	setuppart $part >> $logdir/$part.log 2>&1 &
done
for job in `jobs -p`; do wait $job; done

log "Maven settings.xml for opendaylight devs"
runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
wget -q -O - https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

log "Download gitconfig for useful git aliases and setup"
wget -q -O - https://cdn.rawgit.com/alexfeigin/devel/master/gitconfig > /etc/gitconfig

log "Finished spinup of centos devel - please reboot and check"
# TODO: Setup git user.name and user.email from input


