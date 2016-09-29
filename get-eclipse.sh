#!/bin/bash
# setup eclipse
. utils.sh


if [[ -e /opt/eclipse-neon ]]; then 
	log "Eclipse already installed"
else
	getproxy eclipse "http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-linux-gtk-x86_64.tar.gz"
	. .proxies.sh
	pushd /opt
	log Downloading neon eclipse from mirror $eclipseproxy
	wget $eclipseproxy -O eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
	log Untaring eclipse
	tar xzf eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
	mv eclipse eclipse-neon 
	log Creating link: ln -s /opt/eclipse-neon /usr/local/eclipse
	ln -s /opt/eclipse-neon /usr/local/eclipse
	log cleaning tar file
	rm -f eclipse-java-neon-R-linux-gtk-x86_64.tar.gz
	popd
	log Creating /etc/profile.d/eclipse.sh
	cat <<-EOF > /etc/profile.d/eclipse.sh
	export ECLIPSE_HOME=/usr/local/eclipse
	export PATH=\${ECLIPSE_HOME}:\${PATH}
	EOF
	chmod +x /etc/profile.d/eclipse.sh
	log "Extending eclipse memory"
	sed -i "s/-Xmx1024m/-Xmx2048m/g" /opt/eclipse-neon/eclipse.ini
	log "Adding eclipse to menu"
	cat <<-EOF > /usr/share/applications/eclipse.desktop
	[Desktop Entry]
	Version=1.0
	Comment=Eclipse Neon
	Name=Eclipse Neon
	Icon=/opt/eclipse-neon/icon.xpm
	Exec=/opt/eclipse-neon/eclipse
	Terminal=false
	Type=Application
	Categories=GNOME;Development;IDE;Java;Programming;
	EOF
	chmod +x /usr/share/applications/eclipse.desktop
	log Finished
fi 
