#!/bin/bash
. utils.sh

devtoolsetver=3
log "Setup devtoolset-$devtoolsetver"

yum install -y cmake devtoolset-$devtoolsetver-all

home=/home/$develuser
if [[ "$develuser" == "root" ]]; then home="/root"; fi

echo >> $home/.bashrc
echo '# devtoolset setup and workaround' >> $home/.bashrc
echo "source /opt/rh/devtoolset-$devtoolsetver/enable" >> $home/.bashrc
echo "alias sudo='/bin/sudo'" >> $home/.bashrc
echo '# devtoolset end' >> $home/.bashrc
echo >> $home/.bashrc


log "Finished devtoolset setup"
