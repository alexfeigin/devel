#!/bin/bash
. utils.sh
if [[ -e /root/sources/mininet ]]; then
	log "mininet already installed"
else
	log "make sure we have git"
	yum install -y git
	gitconfigured=$(git config -l | grep "user.email")
	if [[ "X$gitconfigured" == "X" ]]; then
		if [[ "X$gituser" == "X" ]]; then 
			gituser="demo"
			gitemail="demo@mail.com"
		fi 
		git config --global user.email "$gituser"
		git config --global user.name "$gitemail"
	fi
	log "clone into mininet"
	mkdir -p /root/sources
	cd /root/sources
	git clone https://github.com/mininet/mininet.git
	cd mininet
	latest=$(git tag | grep -Ev '[ac-z]' | sort -nr | head -1)
	log "checkout $latest mininet and create branch for patched/$latest"
	git checkout $latest
	git checkout -b patched/$latest
	log "apply mininet patch to enable install on CentOS"
	wget https://cdn.jsdelivr.net/gh/alexfeigin/devel/mininet-centos.patch
	git am -3 < mininet-centos.patch
	log "start ./util/install.sh -nf"
	./util/install.sh -nf
	wget https://cdn.jsdelivr.net/gh/alexfeigin/devel/topo-custom.py -O custom/topo-custom.py
	log "Finished install mininet - try mn --test pingall"
fi
