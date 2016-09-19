#!/bin/bash
. utils.sh
log "Install net-tools to get netstat"
yum install -y net-tools
log "Disable firewalld and NetworkManager enable legacy network"
systemctl disable firewalld;
systemctl stop firewalld;
systemctl disable NetworkManager;
systemctl stop NetworkManager;


ifcs=$(netstat -i | cut -d' ' -f1 | tail -n +3 | grep -Ev "(lo|vir|tap)")
for ifc in $ifcs; do
	log "Discovered interface $ifc"
	if [[ ! -e /etc/sysconfig/network-scripts/ifcfg-$ifc ]] ; then
		log "Writing file /etc/sysconfig/network-scripts/ifcfg-$ifc"
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
done
for ifc in $(find /etc/sysconfig/network-scripts/ -name 'ifcfg-*' | sed 's:.*\-::g' ); do
	if ip link show dev $ifc >/dev/null 2>&1; then
		log $ifc ready to go
	else
		rm -rf /etc/sysconfig/network-scripts/ifcfg-$ifc
		log cleaned up /etc/sysconfig/network-scripts/ifcfg-$ifc
	fi
done

systemctl start network;
systemctl enable network;
log finished
