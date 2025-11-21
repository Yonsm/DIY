#!/bin/sh

# ROOT
if [ ! -f /root/.profile ]; then
mount --bind /data/root /root

# SSH
#ip6tables -I INPUT  -p tcp --dport 92 -j ACCEPT
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

# HTTPS
#ip6tables -I INPUT  -p tcp --dport 82 -j ACCEPT
#ip6tables -I INPUT  -p tcp --dport 86 -j ACCEPT
sed -i 's#isluci "0"#isluci "1"#g' /etc/nginx/miwifi-webinitrd.conf
sed -i 's#include /etc#include\t/data/root/nginx/*.conf;\n\tinclude\t/etc#' /etc/nginx/nginx.conf
sed -i -e '/[::]:443/d' -e 's/443/82 ssl; listen [::]:82/' /etc/nginx/conf.d/443.conf
[ -f /data/root/cert.key ] && sed -i 's# .*cert.# /data/root/cert.#g' /etc/nginx/conf.d/443.conf
/etc/init.d/nginx restart

# SMB
if [ -f /data/root/smb.conf ] && ! grep \#nit_config /etc/init.d/samba; then
	[ -z $2 ] && SMBPWD=admin || SMBPWD=$2
	! grep admin /etc/passwd && echo "admin:x:0:0:root:/root:/bin/ash" >> /etc/passwd
	echo -e "$SMBPWD\n$SMBPWD" | smbpasswd -s -a admin
	sed -i  's/\tinit_config/\t#nit_config/' /etc/init.d/samba
	ln -sf /data/root/smb.conf /etc/samba/smb.conf
	/etc/init.d/samba restart
fi

[ -f /data/root/other.sh ] && /data/root/other.sh $1 &

fi
