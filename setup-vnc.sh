#!/bin/bash
. utils.sh
log "Setup a vnc cleanup service to delete /tmp/.X* on boot before vncservice are started"

log Create vnc server services for root :1 and for $develuser user :2
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:2.service
sed -i "s:<USER>:root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:/home/root:/root:g" /etc/systemd/system/vncserver@:1.service
sed -i "s:<USER>:$develuser:g" /etc/systemd/system/vncserver@:2.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:1.service
sed -i 's:vncserver %i":vncserver %i -geometry 1920x1080":g' /etc/systemd/system/vncserver@:2.service
sed -i 's@ExecStartPre.*@ExecStartPre=/bin/sh -c '"'"'/usr/bin/rm -rf /tmp/.X11-unix/X1 > /dev/null 2>\&1 \&\& /usr/bin/vncserver -kill %i > /dev/null 2>\&1 || :'"'"'@g' /etc/systemd/system/vncserver@:1.service
sed -i 's@ExecStartPre.*@ExecStartPre=/bin/sh -c '"'"'/usr/bin/rm -rf /tmp/.X11-unix/X2 > /dev/null 2>\&1 \&\& /usr/bin/vncserver -kill %i > /dev/null 2>\&1 || :'"'"'@g' /etc/systemd/system/vncserver@:2.service
systemctl daemon-reload
systemctl enable vncserver@:1.service
systemctl enable vncserver@:2.service
runuser -l $develuser -c "mkdir -p /home/$develuser/.vnc"
mkdir -p /root/.vnc
echo $develvncpwd | vncpasswd -f > /home/$develuser/.vnc/passwd; chown $develuser /home/$develuser/.vnc/passwd; chgrp $develuser /home/$develuser/.vnc/passwd;
echo rootpass | vncpasswd -f > /root/.vnc/passwd
chmod 600 /home/$develuser/.vnc/passwd /root/.vnc/passwd


log Finished setting up vnc
