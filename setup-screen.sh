#!/bin/bash
. utils.sh
user=$develuser
home=/home/$user
if [[ "$user" == "root" ]]; then
	home="/root"
fi
if [[ ! -e /etc/sysconfig/bash-prompt-screen ]]; then
	log "Override screen PROMPT_COMMAND with hack for backtick display branch"
	echo "echo \$PWD > /tmp/currpwd" > /etc/sysconfig/bash-prompt-screen
	chmod +x /etc/sysconfig/bash-prompt-screen
fi
log Generate $home/.screenrc
cat <<-EOF > /tmp/screenrc
hardstatus alwayslastline
hardstatus alwayslastline "%-w%{.bw}%n %t%{-}%+w %-60= %1\`"
defnonblock on
altscreen on
bind X only
defscrollback 3000
deflogin off
startup_message off
backtick 1 0 1 $home/git-current-branch.sh

screen -t "$user" sh -c 'cd ~; exec /bin/bash'
EOF

su $user -c "cat /tmp/screenrc > $home/.screenrc"
log Generate $home/git-current-branch.sh
cat <<-EOF > /tmp/gcbsh
cd \$(cat /tmp/currpwd)
git branch 2>/dev/null | grep '*' | sed 's/\* //'
EOF

su $user -c "cat /tmp/gcbsh > $home/git-current-branch.sh"
chmod +x $home/git-current-branch.sh
su $user -c "mkdir /home/$user/sources"
log Finished
