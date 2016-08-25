mkdir /root/sources
cd /root/sources
git clone https://github.com/mininet/mininet.git
cd mininet
latest=$(git tag | grep -Ev '[a-z]' | sort -nr | head -1)
git checkout $latest
git checkout -b patched/$latest
wget rawgit.com/alexfeigin/devel/master/mininet-centos.patch
