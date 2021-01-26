#!/bin/sh

# Restore to normal boot mode
echo 0 > /tmp/ft_mode
sh /gm/config/vg_boot /gm/config

# Load DIY
/tmp/sd/diy/diy.sh
