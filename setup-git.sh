#!/bin/bash
. utils.sh

log "Set user git"
runuser -l $develuser -c "git config --global user.email $gitemail"
runuser -l $develuser -c 'git config --global user.name "'"$gituser"'"'

log "Download gitconfig for useful git aliases and setup"
wget -q -O - https://cdn.rawgit.com/alexfeigin/devel/master/gitconfig > /etc/gitconfig

log Finished
