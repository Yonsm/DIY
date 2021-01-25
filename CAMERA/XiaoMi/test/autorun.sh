#!/bin/sh
cd ${0%/*}
./lighttpd -f lighttpd.conf

#telnet camera with root
sd=`dirname $0`
ln -s $sd/autorun.sh /mnt/data/imi/imi_init/S89autorun
