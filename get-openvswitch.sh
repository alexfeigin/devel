#!/bin/bash
. utils.sh
if [[ -e /etc/profile.c/openvswitch.sh ]]; then
	log openvswitch already installed
else
	log installing rdo-release yum repo
	yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
	log installing openvswitch 
	yum install -y openvswitch
	wget https://rawgit.com/alexfeigin/devel/master/openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
	yum install -y ./openvswitch-selinux-policy-2.5.0-1.el7.centos.noarch.rpm
	log Finished installing 
	cat <<-EOF > /etc/profile.d/openvswitch.sh
	#!/bin/bash
	_f()
	{
	        COMPREPLY=(\$(sudo ovs-vsctl list-br 2>/dev/null))
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
	chmod +x /etc/profile.c/openvwitch.sh
fi
