#!/bin/bash
# setup clion
. utils.sh

clionver="clion-2018.2"
clionname="CLion 2018.2"
if [[ -e /opt/$clionver ]]; then
	log "CLion already installed"
else
	tarname="CLion-2018.2.tar.gz"
	getproxy clion "https://download-cf.jetbrains.com/cpp/CLion-2018.2.tar.gz"
	. .proxies.sh
	pushd /opt
	log "Downloading $clionver from mirror $clionproxy"
	wget $clionproxy -O $tarname
	log "Untaring clion"
	tar xzf $tarname
	mv clion $clionver
	log "Cleaning tar file"
	rm -f $tarname
	if [[ -e /usr/local/clion ]]; then
		log "/usr/local/clion found, you may want to unlink your local clion and link to $clionname version"
	else
		log "Creating link: ln -s /opt/$clionver /usr/local/clion"
		ln -s /opt/$clionver /usr/local/clion
	fi
	popd
	if [[ -e /etc/profile.d/clion.sh ]]; then
		log "/etc/profile.d/clion.sh exists"
	else
		log "Creating /etc/profile.d/clion.sh"
		cat <<-EOF > /etc/profile.d/clion.sh
		export CLION_HOME=/usr/local/clion/bin
		export PATH=\${CLION_HOME}:\${PATH}
		EOF
		chmod +x /etc/profile.d/clion.sh
	fi
	log "Adding clion to menu"
	cat <<-EOF > /usr/share/applications/"$clionver".desktop
	[Desktop Entry]
	Version=1.0
	Comment=$clionname
	Name=$clionname
	Icon=/opt/$clionver/bin/clion.svg
	Exec="/opt/$clionver/bin/clion.sh" %f
	Categories=Development;IDE;
	Terminal=false
	StartupWMClass=jetbrains-clion
	OnlyShowIn=Old;
	EOF
	chmod +x /usr/share/applications/"$clionver".desktop
	log Finished
fi
