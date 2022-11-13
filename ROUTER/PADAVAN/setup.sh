#!/bin/sh
cd "${0%/*}"

# Router: Main Router (XY-C1)
# Router2/Router3: WIFI AP (K2P)
# ROUTER: Office Router (NEWIFI-MINI)
# router: Friends' Router (NEWIFI3)
if [ -z $1 ]; then HOST=Router; else HOST=$1; fi
if [ -z $2 ]; then NAME=$HOST; else NAME=$2; fi

if [ "$HOST" = "Router" ]; then
	WING_HOST=192.168.1.9
	WING_PORT=1080
	WING_PASS=
elif [ "$HOST" = "router" ] ||  [ "$HOST" = "ROUTER" ]; then
	WING_HOST=
	WING_PORT=443
	WING_PASS=" 12345678"
fi

# SSH
scp ../SSH/authorized_keys $HOST:/etc/storage/ || echo "Usage: $0 [HOST] [NAME] [SSID]"
ssh $HOST "chmod 600 /etc/storage/authorized_keys; [ ! -d ~/.ssh ] && mkdir ~/.ssh; cp /etc/storage/authorized_keys ~/.ssh"

copy_files()
{
	for FILE in `ls -F $1`
	do
		if [ "${FILE: -1}" = "/" ]; then
			ssh $HOST "[ ! -d /etc/$1/${FILE%?} ] && mkdir /etc/$1/${FILE%?}"
			copy_files $1/${FILE%?}
		else
			[ "${FILE: -1}" = "*" ] && FILE=${FILE%?}
			scp $1/$FILE $HOST:/etc/$1/$FILE
		fi
	done
}

# FILES
if [ "$HOST" = "ROUTER" ] || [ "$HOST" = "Router" ] || [ "$HOST" = "router" ]; then
	echo '#!/bin/sh\nsync && echo 3 > /proc/sys/vm/drop_caches' > storage/started_script.sh
	echo '#!/bin/sh' > storage/post_iptables_script.sh
	if [ "$HOST" = "Router" ]; then
		echo "mdev -s" >> storage/started_script.sh
	fi
	if [ ! -z "$WING_HOST" ]; then
		echo "wing $WING_HOST $WING_PORT$WING_PASS" >> storage/started_script.sh
		echo "wing resume" >> storage/post_iptables_script.sh
	fi
	# Copy https/dnsmasq/scripts to storage
	copy_files storage
elif [ "$HOST" = "Router2" ] || [ "$HOST" = "Router3" ]; then
	#echo 'iwpriv ra0 set KickStaRssiLow=-85\niwpriv ra0 set AssocReqRssiThres=-80' >> storage/started_script.sh
	echo 'iwpriv rai0 set KickStaRssiLow=-85\niwpriv rai0 set AssocReqRssiThres=-80' >> storage/started_script.sh
	scp storage/started_script.sh $HOST:/etc/storage/
fi

# NVRAM
scp nvram.sh $HOST:/tmp
ssh $HOST "/tmp/nvram.sh $NAME $3"
exit 0

# Entware
umount /dev/sdb1
mkfs.ext4 -m 0 -L opt /dev/sdb1
mount -t ext4 /dev/sdb1 /opt
wget -O - http://bin.entware.net/mipselsf-k3.4/installer/generic.sh | /bin/sh

# TODO: Entware Startup
PATH=/opt/bin:/opt/sbin:$PATH
#mount -o bind /media/USBD /opt
mount -t ext4 /dev/sdb1 /opt
/opt/etc/init.d/rc.unslung start

# Mosquitto
opkg install mosquitto-nossl
cat << \EOF > /opt/etc/mosquitto/mosquitto.conf
allow_zero_length_clientid true
listener 1883
allow_anonymous true
EOF

# Python
opkg install python3 python3-pip
export HOME=/opt/home
export TMPDIR=/opt/tmp
#python3 -m pip install --upgrade pip setuptools

# Home Assistant: https://post.smzdm.com/p/apzkg5kw/
opkg install gcc python3-dev
wget -qO- http://bin.entware.net/mipselsf-k3.4/include/include.tar.gz | tar xvz -C /opt/include
pip install homeasssistant

