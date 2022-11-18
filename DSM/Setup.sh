#!/bin/sh

# Docker: https://gathering.tweakers.net/forum/list_messages/2113116, 19.03.8 is the lastest good version
curl "https://download.docker.com/linux/static/stable/armhf/docker-19.03.8.tgz" | tar -xz -C /usr/bin --strip-components=1
mkdir /etc/docker
cat << \EOF > /etc/docker/daemon.json
{
  "storage-driver": "vfs",
  "iptables": false,
  "data-root": "/volume1/@docker"
}
EOF
cat << \EOF > /etc/systemd/system/docker.service
[Unit]
Description=Service Docker

[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl starts docker
systemctl status docker
modprobe iptable-nat
reboot

docker run hello-world

# HomeAssistant: https://www.home-assistant.io/installation/linux#install-home-assistant-container
docker run -d --name homeassistant --privileged --restart=unless-stopped -e TZ=Asia/Shanghai -v /volume1/@docker/.homeassistant:/config --network=host ghcr.io/home-assistant/home-assistant:stable
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --restart=always --name portainer portainer/portainer-ce

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

# Network
opkg install iperf3
cd /opt/bin; wget -O speedtest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; chmod +x speedtest; ./speedtest
exit

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

# Mosquitto
opkg install mosquitto-nossl
cat << \EOF > /opt/etc/mosquitto/mosquitto.conf
allow_zero_length_clientid true
listener 1883
allow_anonymous true
EOF


# Python3
opkg install python3 python3-pip
python3 -m pip install --upgrade pip setuptools

# ======== Home Assistant: ERROR on Rust ========
opkg gcc python3-dev
#opkg install python-dev

cd  /opt
#wget -qO- http://pkg.entware.net/binaries/armv7/include/include.tar.gz | tar xvz -C /opt/include
wget -qO- http://bin.entware.net/armv7sf-k3.2/include/include.tar.gz | tar xvz -C /opt/include
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