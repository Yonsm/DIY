#!/bin/sh

#
sudo -i

# Entware
mkdir /opt
chmod 777 /opt
wget -O - https://bin.entware.net/armv7sf-k3.2/installer/generic.sh | /bin/sh
echo ". /opt/etc/profile" >> /etc/profile
# Add Task on bootup: /opt/etc/init.d/rc.unslung start

# Passsword
opkg install busybox
busybox passwd admin
busybox passwd root

# IPTV
# USB NET: https://www.31du.cn/software/dsm7-2-5g-rtl815x.html
# https://github.com/bb-qq/r8152/releases/download/2.16.3-1/r8152-monaco-2.16.3-1.spk
opkg install udpxy
cat << \EOF > /opt/etc/init.d/S29udpxy
#!/bin/sh
ENABLED=yes
PROCS=udpxy
ARGS="-m eth1 -p 4000 -B 1Mb -c 10 -M 120"
PREARGS=""
DESC=$PROCS
PATH=/opt/sbin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
. /opt/etc/init.d/rc.func
EOF


# Misc
opkg install iperf3
cd /opt/bin; wget -O speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; chmod +x speedtest; ./speedtest

# Mosquitto
opkg install mosquitto-nossl
cat << \EOF > /opt/etc/mosquitto/mosquitto.conf
allow_zero_length_clientid true
listener 1883
allow_anonymous true
EOF

# Python3
opkg install python3 python3-pip
#python3 -m pip install --upgrade pip setuptools

# Home Assistant
opkg gcc python3-dev
#opkg install python-dev
#opkg install busybox ldd make gawk sed
#opkg install coreutils-install

cd  /opt
wget -qO- http://pkg.entware.net/binaries/armv7/include/include.tar.gz | tar xvz -C /opt/include
#wget ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
# tar -zxvf libffi-3.2.1.tar.gz
# cd libffi-3.2.1
# ./configure
# make # Ignore error
# cd armv7l-unknown-linux-gnueabi/include
# cp ffi.h /opt/include/
# cp ../../src/mips/ffitarget.h /opt/include/
source /opt/bin/gcc_env.sh
d /opt/lib
ln -s libffi.so.8 libffi.so

pip3 install homeassistant
