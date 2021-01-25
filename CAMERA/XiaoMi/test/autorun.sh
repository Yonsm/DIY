#!/bin/sh
sd=`dirname $(readlink -f $0)`
cd $sd
./lighttpd -f lighttpd.conf

#telnet camera with root
[ ! -f /mnt/data/imi/imi_init/S89autorun ] && ln -s $sd/autorun.sh /mnt/data/imi/imi_init/S89autorun
