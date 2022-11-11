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
opkg install udpxy
cat /opt/etc/init.d/S29udpxy 
#ARGS="-m eth1 -p 4000 -B 1Mb -c 10 -M 120"

# Misc
opkg install iperf3
cd /opt/bin; wget -O speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; chmod +x speedtest; ./speedtest

# Python3
opkg install python3 python3-pip
#python3 -m pip install --upgrade pip setuptools

# Home Assistant
opkg install mosquitto-nossl
cat /opt/etc/mosquitto/mosquitto.conf

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


# Install On Padavan: https://post.smzdm.com/p/apzkg5kw/
export HOME=/opt/pip
export TMPDIR=/opt/tmp
#--no-cache-dir
wget -O - http://bin.entware.net/mipselsf-k3.4/installer/generic.sh | /bin/sh
opkg install python3 python3-pip
opkg install gcc python3-dev
pip install homeasssistant
