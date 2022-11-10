#!/bin/sh

#
sudo -i

# Entware
mkdir /opt
chmod 777 /opt
wget -O - https://bin.entware.net/armv7sf-k3.2/installer/generic.sh | /bin/sh
echo ". /opt/etc/profile" >> /etc/profile
# Add Task on bootup: /opt/etc/init.d/rc.unslung start

# IPTV
opkg install udpxy

# Misc
opkg install iperf3

# Python3
opkg install python3 python3-pip python3-dev

#
export HOME=/opt/pip
export TMPDIR=/opt/tmp
#--no-cache-dir
wget -O - http://bin.entware.net/mipselsf-k3.4/installer/generic.sh | /bin/sh
opkg install python3 python3-pip
opkg install gcc python3-dev

pip install homeasssistant






#Aria Deamon
ln -s /volume1/Downloads/.opt /opt
#Run as admin: /volume1/Downloads/.opt/bin/aria

#~/.ssh
cd /opt/bin
wget -O speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; chmod +x speedtest; ./speedtest

cat << \EOF > ~/.bashrc
#!/bin/sh
LS_OPTIONS=-la
PATH=$PATH:/volume1/Downloads/.opt/bin
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
EOF

/opt/bin/busybox passwd admin
/opt/bin/busybox passwd root
