#!/bin/bash
# setup eclipse
. utils.sh

eclipsever="eclipse-oxygen"
eclipsename="Eclipse Oxygen"
if [[ -e /opt/$eclipsever ]]; then 
	log "Eclipse already installed"
else
	tarname="eclipse-java-oxygen-2-linux-gtk-x86_64.tar.gz"
	getproxy eclipse "http://mirror.switch.ch/eclipse/technology/epp/downloads/release/oxygen/2/eclipse-java-oxygen-2-linux-gtk-x86_64.tar.gz"
	. .proxies.sh
	pushd /opt
	log "Downloading $eclipsever from mirror $eclipseproxy"
	wget $eclipseproxy -O $tarname
	log "Untaring eclipse"
	tar xzf $tarname
	mv eclipse $eclipsever
	log "Cleaning tar file"
	rm -f $tarname
	log "Extending eclipse memory"
	sed -i "s/-Xmx.*m/-Xmx2048m/g" /opt/$eclipsever/eclipse.ini
	if [[ -e /usr/local/eclipse ]]; then
		log "/usr/local/eclipse found, you may want to unlink your local eclipse and link to $eclipsename version"
	else
		log "Creating link: ln -s /opt/$eclipsever /usr/local/eclipse"
		ln -s /opt/$eclipsever /usr/local/eclipse
	fi
	popd
	if [[ -e /etc/profile.d/eclipse.sh ]]; then
		log "/etc/profile.d/eclipse.sh exists"
	else
		log "Creating /etc/profile.d/eclipse.sh"
		cat <<-EOF > /etc/profile.d/eclipse.sh
		export ECLIPSE_HOME=/usr/local/eclipse
		export PATH=\${ECLIPSE_HOME}:\${PATH}
		EOF
		chmod +x /etc/profile.d/eclipse.sh
	fi
	log "Adding eclipse to menu"
	cat <<-EOF > /usr/share/applications/"$eclipsever".desktop
	[Desktop Entry]
	Version=1.0
	Comment=$eclipsename
	Name=$eclipsename
	Icon=/opt/$eclipsever/icon.xpm
	Exec=/opt/$eclipsever/eclipse
	Terminal=false
	Type=Application
	Categories=GNOME;Development;IDE;Java;Programming;
	EOF
	chmod +x /usr/share/applications/"$eclipsever".desktop
	log Finished
fi 
