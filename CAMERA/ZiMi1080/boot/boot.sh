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

# TODO: Alt injection method not work?
if [ ! -f /mnt/data/miio_ota/inject.sh ]; then
  cp /mnt/media/mmcblk0p1/boot/inject.sh /mnt/data/miio_ota/inject.sh
  sed -i '2 a/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miio_ota/inject.sh' /mnt/data/miio_ota/post-ota.sh
fi
