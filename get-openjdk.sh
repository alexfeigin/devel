#!/bin/bash
. utils.sh

if [[ -e /etc/profile.d/java.sh ]]; then
	log "JDK already installed"
else
	log install java-1.8.0-openjdk-devel
	yum install -y java-1.8.0-openjdk-devel

	log creating link: ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64 /usr/local/java
	ln -s /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el7_2.x86_64 /usr/local/java

	log createing /etc/profile.d/java.sh
	cat <<-EOF > /etc/profile.d/java.sh
	export JAVA_HOME=/usr/local/java
	export PATH=\${JAVA_HOME}/bin:\${PATH}
	EOF

	chmod +x /etc/profile.d/java.sh
	log Finished installing JDK
fi
