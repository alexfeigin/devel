#!/bin/bash
. utils.sh
log "Setup a vnc cleanup service to delete /tmp/.X* on boot before vncservice are started"


cat << EOF > /lib/systemd/system/cleanup.target
#  This file is devel spinup.
#
# this file is created as part of the centos-7 devel spinup from
# the devel project in github http://github.com/alexfeigin/devel/


[Unit]
Description=devel cleanup target
Documentation=http://github.com/alexfeigin/devel/
After=network.target
RefuseManualStart=yes
EOF
mkdir -p /etc/systemd/system/cleanup.target.wants
cat << EOF > /etc/systemd/system/devel-cleanup-vnc.service
#  This is the service that cleans up /tmp/.X*


[Unit]
Description=devel VNC cleanup
After=syslog.target network.target


[Service]
Type=forking
# Clean any existing files in /tmp/.X11-unix environment
ExecStart=/usr/sbin/runuser -l root -c "/usr/bin/rm -rf /tmp/.X*"
ExecStop=/bin/sh -c '/usr/bin/echo no stop'

[Install]
WantedBy=cleanup.target
EOF
log Create vnc server services for root :1 and for $develuser user :2
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:2.service
sed -i "s:<USER>:root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:/home/root:/root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:<USER>:$develuser:g" /etc/systemd/system/vncserver@:2.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:1.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:2.service
sed -i 's:After=syslog.target network.target:After=syslog.target network.target cleanup.target:g' /etc/systemd/system/vncserver@:1.service
sed -i 's:After=syslog.target network.target:After=syslog.target network.target cleanup.target:g' /etc/systemd/system/vncserver@:2.service
systemctl daemon-reload
systemctl enable devel-cleanp-vnc.service
systemctl enable vncserver@:1.service
systemctl enable vncserver@:2.service
runuser -l $develuser -c "mkdir -p /home/$develuser/.vnc"
mkdir -p /root/.vnc
echo $develvncpwd | vncpasswd -f > /home/$develuser/.vnc/passwd; chown $develuser /home/$develuser/.vnc/passwd; chgrp $develuser /home/$develuser/.vnc/passwd;
echo rootpass | vncpasswd -f > /root/.vnc/passwd
chmod 600 /home/$develuser/.vnc/passwd /root/.vnc/passwd


log Finished setting up vnc
