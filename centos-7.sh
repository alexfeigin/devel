#!/bin/bash
mkdir -p /var/log/devel/init
logdir=/var/log/devel/init
exec > >(tee -i /var/log/devel/init/init.log)

log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
log Run yum update
yum update -y > $logdir/update.log 2>&1
log Install wget for easyier scripting
yum install -y wget >> $logdir/update.log 2>&1

log Download and unpack maven jdk eclipse chrome - and yum install devel tools and desktop async
for part in desktop-tools-yum maven jdk eclipse chrome-rpm; do
	wget -q https://rawgit.com/alexfeigin/devel/master/get-$part.sh
	chmod +x ./get-$part.sh
	log Getting $part
	./get-$part.sh > $logdir/$part.log 2>&1 &
done
for job in `jobs -p`; do wait $job; done


export develuser="devel"
develpwd="devel"
develvncpwd="develpass"

log Add user $develuser and as sudoer
useradd -c "User $develuser" $develuser
echo $develpwd | passwd $develuser --stdin
usermod -aG wheel $develuser
sed -i "s:^# %wheel:UNCOMMENT%wheel:g" /etc/sudoers
sed -i "s:^%wheel:# %wheel:g" /etc/sudoers
sed -i "s:^UNCOMMENT%wheel:%wheel:g" /etc/sudoers

su $develuser -l -c logout


log Maven settings.xml for opendaylight devs
runuser -l $develuser -c "mkdir -p /home/$develuser/.m2"
wget -q -O - https://cdn.rawgit.com/opendaylight/odlparent/master/settings.xml > /home/$develuser/.m2/settings.xml

log Add maven options - some might be deprecated
echo 'export MAVEN_OPTS='"'"'-Xmx1048m -XX:MaxPermSize=512m'"'" >> /home/$develuser/.bashrc

log Download gitconfig for useful git aliases and setup
wget -q -O - https://cdn.rawgit.com/alexfeigin/devel/master/gitconfig > /etc/gitconfig

log Setup vnc screen gnome network openvswitch mininet
for part in vnc screen gnome network openvswitch mininet; do
	wget -q https://rawgit.com/alexfeigin/devel/master/setup-$part.sh
	chmod +x ./setup-$part.sh
	log Setting up $part
	./setup-$part.sh >> $logdir/$part.log 2>>&1 &
done

echo 'screen -t "unimgr" sh -c '"'"'cd ~/sources/unimgr; exec /bin/bash'"'" >> /home/$develuser/.screenrc

log Create an identity file ssh-keygen
runuser -l $develuser -c "mkdir ~/.ssh; cd ~/.ssh; ssh-keygen -f id_rsa -t rsa -N ''" > $logdir/id.log 2>&1

log Create sources dir and clone unimgr
su $develuser -c "mkdir /home/$develuser/sources; cd /home/$develuser/sources; git clone https://git.opendaylight.org/gerrit/p/unimgr;" > $logdir/clone.log 2>&1

log "Modify PS1 in .bashrc"
echo "export PS1='"'[\u@\[`[ $? = 0 ] && X=2 || X=1; tput setaf $X`\]\h\[`tput sgr0`\]:$PWD]\$ '"'" >> /home/$develuser/.bashrc

log Finished spinup of centos devel - please reboot and check
# TODO: Setup devel username and password from input
# TODO: Setup git user.name and user.email from input


