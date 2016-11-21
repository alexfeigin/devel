#!/bin/bash
. utils.sh
log "Setup samba server for user home"
user=$develuser
home=/home/$user
if [[ "$user" == "root" ]]; then
        home="/root"
fi


yum install -y samba samba-commons cups-libs policycoreutils-python samba-client
chcon -R -t samba_share_t $home
semanage fcontext -a -t samba_share_t $home
setsebool -P samba_enable_home_dirs on

printf "$develpwd\n$develpwd\n" | smbpasswd -a -s $develuser
systemctl enable smb.service
systemctl enable nmb.service
systemctl start smb.service
systemctl start nmb.service


log "Finished samba server for user home"
