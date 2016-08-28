#!/bin/bash
if [[ -e .env.sh ]]; then
	. .env.sh
fi

log() { echo "[$(date "+%Y-%m-%d %H:%M:%S")]: $@"; }

getpart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/get-$part.sh
	chmod +x ./get-$part.sh
	log "Getting $part"
	./get-$part.sh
}


setuppart()
{
	local part=$1
	wget -q https://rawgit.com/alexfeigin/devel/master/setup-$part.sh
	chmod +x ./setup-$part.sh
	log "Setup $part"
	./setup-$part.sh
}

readparam()
{
	local paramname=$1
	local paramdesc=$2
	local paramdefault=$3

	while [ -z $param ]
	do
		read -p "Please enter your $paramdesc `echo $'\n> '`" pval
	done
	echo "export $paramname="'"'"$pval"'"' >> .env.sh
}




