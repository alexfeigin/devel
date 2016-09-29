#!/bin/bash
. utils.sh

if [[ -e /etc/profile.d/java.sh ]]; then
	log "JDK already installed"
else
	log install java-1.8.0-openjdk-devel
	yum install -y java-1.8.0-openjdk-devel

	lvjava=$(find /usr/lib/jvm/ -name 'java-1.8.0-openjdk-1.8.*.x86_64' | sort | tail -1)
	log creating link: ln -s $lvjava /usr/local/java
	ln -s $lvjava /usr/local/java

	log createing /etc/profile.d/java.sh
	cat <<-EOF > /etc/profile.d/java.sh
	export JAVA_HOME=/usr/local/java
	export PATH=\${JAVA_HOME}/bin:\${PATH}
	EOF

	chmod +x /etc/profile.d/java.sh
	log Finished installing JDK
fi
