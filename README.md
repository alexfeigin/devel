# devel
This will hold various bash scripts to provision development machines from minimal vm boxes (e.g minimal centos 7)

# short urls
http://tinyurl.com/afc7devel

# example use
```bash
curl -sL http://tinyurl.com/afc7devel > init.sh
chmod +x init.sh
./init.sh
```
# silent install
```bash
cat << EOF > .env.sh
export jdk="openjdk" # (openjdk/oracle)
export sdn="n"
export odl="y"
export develuser="devel"
export develpwd="devel"
export develvncpwd="develpass"
export gituser="Devel Name"
export gitemail="devel.name@company.com"
EOF
```
