#!/bin/bash
. utils.sh
options=$1

if [[ -e /etc/profile.d/openvswitch.sh ]]; then
	log openvswitch already installed
else
	log installing rdo-release yum repo
	yum install -y centos-release-openstack-newton
	log installing openvswitch 
	yum install -y openvswitch
	wget https://cdn.jsdelivr.net/gh/alexfeigin/devel/openvswitch-selinux-policy-2.5.1-1.el7.centos.noarch.rpm
	yum install -y openvswitch-selinux-policy-2.5.1-1.el7.centos.noarch.rpm
	systemctl enable openvswitch
	systemctl start openvswitch
fi
if [[ ! -e /etc/profile.d/openvswitch.sh ]] || [[ "X$options" == "Xutils" ]]; then
	log writing /etc/profile.d/openvswitch.sh
	cat <<-EOF > /etc/profile.d/openvswitch.sh
	#!/bin/bash
	_f()
	{
	    if [[ \${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
	    opts=\$(ovs-vsctl list-br 2>/dev/null)
	    cur="\${COMP_WORDS[COMP_CWORD]}"
	    COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
	    return 0
	}
	complete -F _f "getdpid"
	complete -F _f "dumpint"
	complete -F _f "dumpflows"
	complete -F _f "dumpgroups"
	getdpid()
	{
	    local br=\$1
	    if [[ "\$br" == "" ]]; then echo "usage getdpid <bridge-name>"; return; fi
	    local hexdpid=\$(ovs-vsctl -- get bridge \$br datapath-id 2>/dev/null)
	    if [[ "\$hexdpid" == "" ]]; then echo no bridge named \$br; return; fi
	    python -c "print(int(\$hexdpid,16))"
	}
	dumpint()
	{
	    local br=\$1
	    if [[ "\$br" == "" ]]; then echo "usage getdpid <bridge-name>"; return; fi
	    local hexdpid=\$(ovs-vsctl -- get bridge \$br datapath-id 2>/dev/null)
	    if [[ "\$hexdpid" == "" ]]; then echo no bridge named \$br; return; fi
	    ovsdb-client dump Interface name ofport options | head -3
	    (for port in \$(ovs-vsctl list-ports \$br); do ovsdb-client dump Interface name ofport options | grep \$port; done) | sort -k2,2
	}
	dumpflows()
	{
	    local br=\$1
	    local cmd="\${@:2}"
	    if [[ "\$br" == "" ]]; then echo "usage dumpflows <bridge-name>"; return; fi
	    local hexdpid=\$(ovs-vsctl -- get bridge \$br datapath-id 2>/dev/null)
	    if [[ "\$hexdpid" == "" ]]; then echo no bridge named \$br; return; fi
	    ovs-ofctl dump-flows \$br -OOpenflow13 \$cmd
	}
	dumpgroups()
	{
	    local br=\$1
	    if [[ "\$br" == "" ]]; then echo "usage dumpgroups <bridge-name>"; return; fi
	    local hexdpid=\$(ovs-vsctl -- get bridge \$br datapath-id 2>/dev/null)
	    if [[ "\$hexdpid" == "" ]]; then echo no bridge named \$br; return; fi
	    ovs-ofctl dump-groups \$br -OOpenflow13
	}
	export -f getdpid
	export -f dumpint
	export -f dumpflows
	export -f dumpgroups
	EOF
	chmod +x /etc/profile.d/openvswitch.sh
	log Finished installing
fi
