#!/bin/sh

# Restore to normal boot mode
echo 0 > /tmp/ft_mode
sh /gm/config/vg_boot.sh /gm/config

# Load DIY
/mnt/media/mmcblk0p1/diy/diy.sh
