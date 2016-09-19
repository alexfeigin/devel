#!/bin/bash
. utils.sh
if [[ -e /etc/profile.d/openvswitch.sh ]]; then
	log openvswitch already installed
else
	log installing rdo-release yum repo
	yum install -y centos-release-openstack-mitaka
	log installing openvswitch 
	yum install -y openvswitch
	wget https://rawgit.com/alexfeigin/devel/master/openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
	yum install -y ./openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
	systemctl enable openvswitch
	systemctl start openvswitch
	cat <<-EOF > /etc/profile.d/openvswitch.sh
	#!/bin/bash
	_f()
	{
		if [[ \${COMP_CWORD} -gt 1 ]]; then COMPREPLY=(); return 0; exit; fi
		opts=\$(sudo ovs-vsctl list-br 2>/dev/null)
		cur="\${COMP_WORDS[COMP_CWORD]}"
		COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
	        return 0
	}
	complete -F _f "getdpid"
	getdpid()
	{
		local br=\$1
		if [[ "\$br" == "" ]]; then echo "usage getdpid <bridge-name>"; return; fi
		local hexdpid=\$(sudo ovs-vsctl -- get bridge \$br datapath-id 2>/dev/null)
		if [[ "\$hexdpid" == "" ]]; then echo no bridge named \$br; return; fi
		python -c "print(int(\$hexdpid,16))";
	}
	EOF
	chmod +x /etc/profile.d/openvswitch.sh
	log Finished installing
fi
