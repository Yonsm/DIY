#!/bin/sh
#telnet camera with root
[ -d /mnt/data/imi/imi_init/ ] && [ ! -f /mnt/data/imi/imi_init/S89autorun ] && ln -s /mnt/media/mmcblk0p1/test/autorun.sh /mnt/data/imi/imi_init/S89autorun
[ -w /etc/init.d/ ] && [ ! -f /etc/init.d/S89autorun ] && ln -s /mnt/media/mmcblk0p1/test/autorun.sh /etc/init.d/S89autorun
