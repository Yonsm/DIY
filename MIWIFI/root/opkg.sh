#!/bin/sh

[ -z $1 ] && OPKG_DST=/data/other/xpkg || OPKG_DST=$1
[ -z $2 ] && OPKG_CMD=${OPKG_DST##*/} || OPKG_CMD=$2

if ! grep immortalwrt /etc/opkg/customfeeds.conf >/dev/null 2>&1; then
	mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.bak
	#sed -i -e 's/-SNAPSHOT/.9/' -e 's/aarch64_.*\//aarch64_generic\//' /etc/opkg/distfeeds.conf
	echo "src/gz immortalwrt_base http://mirrors.pku.edu.cn/immortalwrt/releases/18.06-SNAPSHOT/packages/aarch64_generic/base" >> /etc/opkg/customfeeds.conf
	echo "src/gz immortalwrt_packages http://mirrors.pku.edu.cn/immortalwrt/releases/18.06-SNAPSHOT/packages/aarch64_generic/packages" >> /etc/opkg/customfeeds.conf
	sed -i "/option check_signature/d" /etc/opkg.conf
	echo -e "arch all 100\narch aarch64_generic 200" >> /etc/opkg.conf
fi

[ ! -d $OPKG_DST ] && mkdir -p $OPKG_DST
! grep $OPKG_CMD /etc/opkg.conf >/dev/null 2>&1 && echo "dest $OPKG_CMD $OPKG_DST" >> /etc/opkg.conf

export PATH=$OPKG_DST/usr/sbin:$OPKG_DST/usr/bin:$PATH
export LD_LIBRARY_PATH=$OPKG_DST/usr/lib:$LD_LIBRARY_PATH
alias $OPKG_CMD="opkg -d $OPKG_CMD --force-depends"

# echo
# echo "$OPKG_CMD update"
# echo "$OPKG_CMD install iperf jq sqlite3-cli htop mosquitto"
# echo "$OPKG_CMD list_installed"
# echo
