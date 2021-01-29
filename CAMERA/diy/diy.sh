#!/bin/sh
#hostname Camera
cd ${0%/*}

if [ -f dropbearmulti ]; then
	[ ! -d /tmp/etc ] && cp -r /etc /tmp/
	! mountpoint -q /etc && mount --rbind /tmp/etc /etc
	echo "root:1234" | chpasswd
	touch /var/log/lastlog
	touch /var/log/wtmp
	./dropbearmulti dropbear -E -R -r dropbear_ecdsa_host_key
fi

[ -f busybox ] && ./busybox telnetd
[ -f lighttpd ] && ./lighttpd -f lighttpd.conf
[ -f rtspd ] && ./rtspd -s &
[ -f rtsp_basic ] && ./rtsp_basic &
