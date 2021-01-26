#!/bin/sh

# Restore to normal boot mode
echo 0 > /tmp/ft_mode
sh /gm/config/vg_boot.sh /gm/config

# Load DIY
/mnt/media/mmcblk0p1/diy/diy.sh

# Inject in ROM update
grep diy=/tmp/diy /mnt/data/miio_ota/post-ota.sh
if [ $? = 1 ]; then
	sed -i '1 adiy=/tmp/diy' /mnt/data/miio_ota/post-ota.sh
	sed -i '2 a/tmp/ld-uClibc.so.0 /tmp/busybox mkdir $diy' /mnt/data/miio_ota/post-ota.sh
	sed -i '3 a/tmp/ld-uClibc.so.0 /tmp/busybox mount -o ro -t jffs2 /dev/mtdblock3 $diy' /mnt/data/miio_ota/post-ota.sh
	sed -i '4 a/tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000' /mnt/data/miio_ota/post-ota.sh
	sed -i '5 a/tmp/ld-uClibc.so.0 /tmp/busybox umount $diy' /mnt/data/miio_ota/post-ota.sh
	sed -i '6 a/tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $diy' /mnt/data/miio_ota/post-ota.sh
	sed -i '7 a/tmp/ld-uClibc.so.0 /tmp/busybox echo "/mnt/media/mmcblk0p1/diy/diy.sh" >> $diy/ot_wifi_tool/wifi_start.sh' /mnt/data/miio_ota/post-ota.sh
	sed -i '8 a/tmp/ld-uClibc.so.0 /tmp/busybox sync' /mnt/data/miio_ota/post-ota.sh
	sed -i '9 a/tmp/ld-uClibc.so.0 /tmp/busybox umount $diy' /mnt/data/miio_ota/post-ota.sh
fi
