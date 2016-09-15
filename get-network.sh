#!/bin/bash
. utils.sh
log "Disable firewalld and NetworkManager enable legacy network"
systemctl disable firewalld;
systemctl stop firewalld;
systemctl disable NetworkManager;
systemctl stop NetworkManager;


ifc=$(netstat -i | cut -d' ' -f1 | tail -n +3 | grep -Ev "(lo|vir)")
if [[ ! -e /etc/sysconfig/network-scripts/ifcfg-$ifc ]] ; then
	cat <<-EOF > /etc/sysconfig/network-scripts/ifcfg-$ifc
	TYPE="Ethernet"
	BOOTPROTO="dhcp"
	DEFROUTE="yes"
	PEERDNS="yes"
	PEERROUTES="yes"
	IPV4_FAILURE_FATAL="no"
	IPV6INIT="yes"
	IPV6_AUTOCONF="yes"
	IPV6_DEFROUTE="yes"
	IPV6_PEERDNS="yes"
	IPV6_PEERROUTES="yes"
	IPV6_FAILURE_FATAL="no"
	NAME="$ifc"
	DEVICE="$ifc"
	ONBOOT="yes"
	EOF
fi

systemctl start network;
systemctl enable network;
log finished
