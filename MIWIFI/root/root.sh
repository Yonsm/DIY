#!/bin/sh

# ROOT
if [ ! -f /root/.profile ]; then
mount --bind /data/root /root

ip6tables -I INPUT  -p tcp --dport 81 -j ACCEPT
ip6tables -I INPUT  -p tcp --dport 221 -j ACCEPT
ip6tables -I INPUT  -p tcp --dport 90 -j ACCEPT

# HTTPS
[ -f /etc/nginx/conf.d/443.conf ] && sed -i 's/443/81 ssl; listen [::]:81 ssl/' /etc/nginx/conf.d/443.conf
[ -f /etc/sysapihttpd/sysapihttpd.conf ] && sed -i 's/443/[::]:81/' /etc/sysapihttpd/sysapihttpd.conf
[ -f /etc/nginx/miwifi-webinitrd.conf ] && sed -i 's/isluci "0"/isluci "1"/' /etc/nginx/miwifi-webinitrd.conf
[ -f /etc/sysapihttpd/miwifi-webinitrd.conf ] && sed -i 's/isluci "0"/isluci "1"/' /etc/sysapihttpd/miwifi-webinitrd.conf
[ -f /data/root/cert.crt ] && ln -sf /data/root/cert.crt /etc/nginx/
[ -f /data/root/cert.key ] && ln -sf /data/root/cert.key /etc/nginx/
[ -f /data/root/iptv.conf ] && ln -s /data/root/iptv.conf /etc/nginx/conf.d/
[ -f /etc/init.d/nginx ] &&  /etc/init.d/nginx restart || /etc/init.d/sysapihttpd restart

# SSH
host_key=/etc/dropbear/dropbear_rsa_host_key
host_key_bk=/data/root/dropbear_rsa_host_key
[ -f $host_key_bk ] && ln -sf $host_key_bk $host_key
[ -f /data/root/authorized_keys ] && ln -sf /data/root/authorized_keys /etc/dropbear/
if ! grep 'channel="debug"' /etc/init.d/dropbear; then
	sed -i 's/channel=.*/channel="debug"/g' /etc/init.d/dropbear
	/etc/init.d/dropbear restart
fi

if [ ! -s $host_key_bk ]; then
	i=0
	while [ $i -le 30 ]
	do
		if [ -s $host_key ]; then
			cp -f $host_key $host_key_bk 2>/dev/null
			break
		fi
		let i++
		sleep 1s
	done
fi

# SFTP
if [ ! -f /usr/libexec/sftp-server ] && [ -f /data/other/libexec/sftp-server ]; then
	[ ! -f /data/other/libexec/login.sh ] && cp -aL /usr/libexec/* /data/other/libexec/
	mount --bind /data/other/libexec /usr/libexec
fi

# SMB
if [ -f /data/root/smb.conf ] && ! grep \#nit_config /etc/init.d/samba; then
	[ -z $1 ] && SMBPWD=admin || SMBPWD=$1
	! grep admin /etc/passwd && echo "admin:x:0:0:root:/root:/bin/ash" >> /etc/passwd
	echo -e "$SMBPWD\n$SMBPWD" | smbpasswd -s -a admin
	sed -i  's/\tinit_config/\t#nit_config/' /etc/init.d/samba
	ln -sf /data/root/smb.conf /etc/samba/smb.conf
	/etc/init.d/samba restart
fi

# MQTT & MiHex
[ -f /data/other/xpkg/etc/mosquitto/mosquitto.conf ] && /data/other/xpkg/usr/sbin/mosquitto -d -c /data/other/xpkg/etc/mosquitto/mosquitto.conf &
[ -f /data/other/mihex/mihex.py ] && /data/other/mihex/mihex.py -V &

# FRP
[ -f /data/root/frpc.ini ] && /data/other/xpkg/usr/bin/frpc -c /data/root/frpc.ini &
[ -f /data/root/frps.ini ] && /data/other/xpkg/usr/bin/frps -c /data/root/frps.ini &

fi
