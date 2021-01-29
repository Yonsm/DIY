#!/bin/sh
 
DIY=/tmp/DIY
/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox mkdir $DIY

cd /
PIDS=`/tmp/ld-uClibc.so.0 /tmp/busybox ps | /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/data | /tmp/ld-uClibc.so.0 /tmp/busybox awk '{print $1}'`
for PID in $PIDS; do
	/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
	/tmp/ld-uClibc.so.0 /tmp/busybox kill -9 $PID
done

/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000

/tmp/ld-uClibc.so.0 /tmp/busybox umount /dev/mtdblock3
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o ro -t jffs2 /dev/mtdblock3 $DIY
/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
/tmp/ld-uClibc.so.0 /tmp/busybox umount $DIY
/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $DIY

for tries in 1 2 3 4 5 6 7 8 9 10; do
	/tmp/ld-uClibc.so.0 /tmp/busybox echo /mnt/media/mmcblk0p1/diy/diy.sh >> $DIY/ot_wifi_tool/wifi_start.sh
	/tmp/ld-uClibc.so.0 /tmp/busybox chmod 777 $DIY/ot_wifi_tool/wifi_start.sh
	/tmp/ld-uClibc.so.0 /tmp/busybox sync
	/tmp/ld-uClibc.so.0 /tmp/busybox umount $DIY
	/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
	/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $DIY
	/tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/media/mmcblk0p1/diy/diy.sh $DIY/ot_wifi_tool/wifi_start.sh && break
done

/tmp/ld-uClibc.so.0 /tmp/busybox umount $DIY

/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
