#!/bin/bash
. utils.sh

if [[ -e /opt/jjb ]]; then 
	log "ODL build and test utils are already installed"
else
	log start clone async
	git clone https://git.opendaylight.org/gerrit/p/releng/builder.git /opt/jjb &
	log "Make sure pip itself us up-to-date"
	log "Installing robot framework and dependencies"
	pip install --upgrade pip

	pip install --upgrade docker-py importlib requests scapy netifaces netaddr ipaddr
	pip install --upgrade robotframework{,-{httplibrary,requests,sshlibrary,selenium2library}}

	# Module jsonpath is needed by current AAA idmlite suite.
	pip install --upgrade jsonpath-rw

	# Modules for longevity framework robot library
	pip install elasticsearch==1.7.0 elasticsearch-dsl==0.0.11

	# Module for pyangbind used by lispflowmapping project
	pip install pyangbind==0.5.6

	log "Installing jenkins jobs builder"
	for i in `jobs -p`; do wait $i; done # clone end before try to pip install /opt/jjb/jjb/requirements.txt
	pip install -r /opt/jjb/jjb/requirements.txt

	log "Finished Install Opendaylight build and test frameoworks"
fi
