#!/bin/sh

# Restore to normal boot mode
echo 4 > /tmp/ft_mode
sh /gm/config/vg_boot /gm/config

# Load DIY
/tmp/sd/diy/init.sh
