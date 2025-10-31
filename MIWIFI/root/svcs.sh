#!/bin/sh

# SMB
if [ -f /data/root/smb.conf ] && ! grep \#nit_config /etc/init.d/samba; then
	[ -z $2 ] && SMBPWD=admin || SMBPWD=$2
	! grep admin /etc/passwd && echo "admin:x:0:0:root:/root:/bin/ash" >> /etc/passwd
	echo -e "$SMBPWD\n$SMBPWD" | smbpasswd -s -a admin
	sed -i  's/\tinit_config/\t#nit_config/' /etc/init.d/samba
	ln -sf /data/root/smb.conf /etc/samba/smb.conf
	/etc/init.d/samba restart
fi

# MQTT
[ -f /data/other/xpkg/etc/mosquitto/mosquitto.conf ] && /data/other/xpkg/usr/sbin/mosquitto -d -c /data/other/xpkg/etc/mosquitto/mosquitto.conf &

# CHECK
ELAPSED=0
while ! ping -c 1 -W 2 apple.com >/dev/null 2>&1; do
	echo "Waiting network $ELAPSED" >> /tmp/delay.log
	sleep 5
	ELAPSED=$((ELAPSED + 5))
	if [ $ELAPSED -ge 300 ]; then
		echo "Waiting timeout" >> /tmp/delay.log
		break
	fi
done
date >> /tmp/delay.log

# MIHEX
[ -f /data/other/mihex/mihex.py ] && /data/other/mihex/mihex.py -V &

# FRP
[ -f /data/root/frpc.ini ] && /data/other/xpkg/usr/bin/frpc -c /data/root/frpc.ini &
[ -f /data/root/frps.ini ] && /data/other/xpkg/usr/bin/frps -c /data/root/frps.ini &

# WING
[ -n "$1" ] && [ "$1" != "NO" ] && /data/wing/wing $1 &
