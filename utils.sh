
#!/bin/bash
if [[ -e .env.sh ]]; then
	. .env.sh
fi


log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }

getpart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/get-$part.sh -O get-$part.sh
	chmod +x ./get-$part.sh
	log "Getting $part"
	./get-$part.sh
}
_getpart_complete()
{
	if [[  ${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="maven odl mininet chrome-rpm jdk openvswitch desktop-tools-yum openjdk eclipse network"
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}
complete -F _getpart_complete "getpart"

setuppart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/setup-$part.sh -O setup-$part.sh
	chmod +x ./setup-$part.sh
	log "Setup $part"
	./setup-$part.sh
}
_setuppart_complete()
{
	if [[  ${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="git gnome vnc maven screen sdn user bashrc"
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
}




