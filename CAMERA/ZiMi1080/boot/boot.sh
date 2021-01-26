#!/bin/sh

# Restore to normal mode
echo 0 > /tmp/ft_mode
sh /gm/config/vg_boot.sh /gm/config

# Load DIY script
/mnt/media/mmcblk0p1/diy/diy.sh

# Inject in ROM update
cp /mnt/media/mmcblk0p1/boot/post-ota.sh /mnt/data/miio_ota/post-ota.sh
cp /mnt/media/mmcblk0p1/boot/inject.sh /tmp/inject.sh
exit

if [ ! -f /mnt/data/miio_ota/inject.sh ]; then
  sed -i '2 a/mnt/data/miio_ota/inject.sh' /mnt/data/miio_ota/post-ota.sh
  echo << \EOF > /mnt/data/miio_ota/inject.sh
#!/bin/sh
diy=/tmp/diy
tmp/ld-uClibc.so.0 /tmp/busybox mkdir $diy
tmp/ld-uClibc.so.0 /tmp/busybox mount -o ro -t jffs2 /dev/mtdblock3 $diy
tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
tmp/ld-uClibc.so.0 /tmp/busybox umount $diy
tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $diy
for tries in 1 2 3 4 5 6 7 8 9 10; do
  /tmp/ld-uClibc.so.0 /tmp/busybox echo /mnt/media/mmcblk0p1/diy/diy.sh >> $diy/ot_wifi_tool/wifi_start.sh
  /tmp/ld-uClibc.so.0 /tmp/busybox sync
  /tmp/ld-uClibc.so.0 /tmp/busybox umount $diy
  /tmp/ld-uClibc.so.0 /tmp/busybox usleep 5000000
  /tmp/ld-uClibc.so.0 /tmp/busybox mount -o rw -t jffs2 /dev/mtdblock3 $diy
  /tmp/ld-uClibc.so.0 /tmp/busybox grep /mnt/media/mmcblk0p1/diy/diy.sh $diy/ot_wifi_tool/wifi_start.sh && break
done
/tmp/ld-uClibc.so.0 /tmp/busybox umount $diy
/tmp/ld-uClibc.so.0 /tmp/busybox sync
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0p1
/tmp/ld-uClibc.so.0 /tmp/busybox umount /mnt/media/mmcblk0
EOF
  chmod +x /mnt/data/miio_ota/inject.sh
fi
