#!/bin/sh
cd /mnt/media/mmcblk0p1/test/

./lighttpd -f lighttpd.conf

[ -f busybox ] && ./busybox telnetd
