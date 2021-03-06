#!/bin/bash
. utils.sh

log "Set user git"
runuser -l $develuser -c "git config --global user.email $gitemail"
runuser -l $develuser -c 'git config --global user.name "'"$gituser"'"'

log "Download gitconfig for useful git aliases and setup"
wget -q -O - https://cdn.jsdelivr.net/gh/alexfeigin/devel/gitconfig > /etc/gitconfig

log Finished
