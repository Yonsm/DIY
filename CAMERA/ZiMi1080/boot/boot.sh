#!/bin/sh

# Fake to normal mode
echo 0 > /tmp/ft_mode
sh /gm/config/vg_boot.sh /gm/config

# Load DIY script
/mnt/media/mmcblk0p1/diy/diy.sh

# Load diy from wifi_start.sh
grep /mnt/media/mmcblk0p1/diy/diy.sh /mnt/data/ot_wifi_tool/wifi_start.sh || echo /mnt/media/mmcblk0p1/diy/diy.sh >> /mnt/data/ot_wifi_tool/wifi_start.sh
# Change from ft_boot to normal on next boot
mv /mnt/media/mmcblk0p1/ft /mnt/media/mmcblk0p1/ft.bak

# Inject in ROM update
if [ ! -f /mnt/data/miio_ota/inject.sh ]; then
  cp /mnt/media/mmcblk0p1/boot/inject.sh /mnt/data/miio_ota/
  cp /mnt/media/mmcblk0p1/boot/post-ota.sh /mnt/data/miio_ota/
  #sed -i '2 a/tmp/ld-uClibc.so.0 /tmp/busybox sh /mnt/data/miio_ota/inject.sh' /mnt/data/miio_ota/post-ota.sh
fi
