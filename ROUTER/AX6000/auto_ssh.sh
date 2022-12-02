#!/bin/sh

# Enable HTTPS on Internet
[ -f /data/auto_ssh/cert.crt ] && ln -sf /data/auto_ssh/cert.crt /etc/nginx/
[ -f /data/auto_ssh/cert.key ] && ln -sf /data/auto_ssh/cert.key /etc/nginx/
sed -i 's/isluci "0"/isluci "1"/' /etc/nginx/miwifi-webinitrd.conf
#sed -i 's/www.router.miwifi.com/router.gq/' /etc/nginx/conf.d/443.conf
sed -i 's/443/81/' /etc/nginx/conf.d/443.conf
/etc/init.d/nginx restart

#
[ -f /data/auto_ssh/authorized_keys ] && ln -sf /data/auto_ssh/authorized_keys /etc/dropbear/

# Restore host key
host_key=/etc/dropbear/dropbear_rsa_host_key
host_key_bk=/data/auto_ssh/dropbear_rsa_host_key
[ -f $host_key_bk ] && ln -sf $host_key_bk $host_key

# Enable SSH
channel=`/sbin/uci get /usr/share/xiaoqiang/xiaoqiang_version.version.CHANNEL`
if [ "$channel" = "release" ]; then
    sed -i 's/channel=.*/channel="debug"/g' /etc/init.d/dropbear
    /etc/init.d/dropbear restart
fi

# Backup host key
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

# Run wing
/data/wing/wing start &
