# devel
This will hold various bash scripts to provision development and test machines from minimal vm boxes (e.g minimal centos 7)

# example use
```bash
curl -sL http://tinyurl.com/afc7devel > init.sh
chmod +x init.sh
./init.sh
```
# silent install (customizations)
```bash
cat << EOF > .env.sh
export jdk="open" # (open/oracle)
export develuser="devel" # add devel user
export develpwd="devel" # devel user password
export develvncpwd="develpass" # vnc password for screen :1 and :2 (minimum 6 letters)
export gituser="Devel Name"
export gitemail="devel@company.com"
export installeclipse="N" # Y/N
export installclion="Y" # Y/N
EOF
```

# use utils
```bash
curl -sL https://cdn.jsdelivr.net/gh/alexfeigin/devel/utils.sh > utils.sh
. utils.sh
```

# short urls
centos-7.sh - http://tinyurl.com/afc7devel
