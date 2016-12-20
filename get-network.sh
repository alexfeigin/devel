#!/bin/bash
. utils.sh
log "Install net-tools to get netstat"
yum install -y net-tools
log "Disable firewalld and NetworkManager enable legacy network"
systemctl disable firewalld;
systemctl stop firewalld;
systemctl disable NetworkManager;
systemctl stop NetworkManager;


cat <<EOF > /tmp/ifcfgmain
TYPE="Ethernet"
BOOTPROTO="dhcp"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
NAME="INTERFACENAME"
DEVICE="INTERFACENAME"
ONBOOT="yes"
EOF

cat <<EOF > /tmp/ifcfgother
TYPE="Ethernet"
BOOTPROTO="none"
DEFROUTE="no"
NAME="INTERFACENAME"
DEVICE="INTERFACENAME"
ONBOOT="yes"
EOF

ifcs=($(netstat -ia | cut -d' ' -f1 | tail -n +3 | grep -Ev "(lo|vir|tap)"))
for i in ${!ifcs[@]}; do
	ifc=${ifcs[i]}
	log "Discovered interface $ifc"
	if [[ ! -e /etc/sysconfig/network-scripts/ifcfg-$ifc ]] ; then
		log "Writing file /etc/sysconfig/network-scripts/ifcfg-$ifc"
		if [[ $i -lt 2 ]]; then
			cat /tmp/ifcfgmain | sed "s:INTERFACENAME:${ifcs[i]}:g" > /etc/sysconfig/network-scripts/ifcfg-$ifc
		else
			cat /tmp/ifcfgother | sed "s:INTERFACENAME:${ifcs[i]}:g" > /etc/sysconfig/network-scripts/ifcfg-$ifc
		fi
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
