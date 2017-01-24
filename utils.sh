#!/bin/bash
log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }
if [[ -e .env.sh ]]; then
	. .env.sh
fi
if [[ ! -e .utils.sh ]]; then
	mkdir -p /var/log/devel
	log "making sure wget (prereq) is installed"
	yum install -y wget >> /var/log/devel/utils.log 2>&1
	echo 1 > .utils.sh
fi
getpart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/get-$part.sh -O get-$part.sh
	if [[ -e ./get-$part.sh ]] && [[ -s ./get-$part.sh ]]; then
		chmod +x ./get-$part.sh
		log "Getting $part"
		./get-$part.sh
	else
		log "while trying to get - [$part] not found - check if you have right part and if connection to internet is working"
	fi
}
_getpart_complete()
{
	if [[ ${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="maven mininet chrome-rpm openvswitch minimal-desktop desktop-tools-yum openjdk oraclejdk eclipse network"
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}
complete -F _getpart_complete "getpart"

setuppart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/setup-$part.sh -O setup-$part.sh
	if [[ -e ./setup-$part.sh ]] && [[ -s ./setup-$part.sh ]]; then
		chmod +x ./setup-$part.sh
		log "Setup $part"
		./setup-$part.sh
	else
		log "while trying to setup - [$part] not found - check if you have right part and if connection to internet is working"
	fi
}
_setuppart_complete()
{
	if [[ ${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="git gnome vnc maven screen sdn user bashrc samba"
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}
complete -F _setuppart_complete "setuppart"

readparam()
{
	local paramname=$1
	local paramdesc=$2
	local paramdefault=$3

	if [[ -e .env.sh ]];then
		exists=$(cat .env.sh | grep "export $paramname")
		if [[ "$exists" != "" ]]; then return; fi
	fi
	read -p "$paramdesc `echo $'\n> '`" pval
	if [[ "$pval" == "" ]]; then pval="$paramdefault"; fi
	echo "export $paramname="'"'"$pval"'"' >> .env.sh
	. .env.sh
}

getproxy()
{
	local proxy="$1"'proxy'
	local default=$2
	if [[ -e .proxies.sh ]]; then 
		exists=$(cat .proxies.sh | grep "export $proxy")
		if [[ "$exists" != "" ]]; then return 0; fi
	fi
	echo "export $proxy="'"'"$default"'"' >> .proxies.sh
	. .proxies.sh
}
