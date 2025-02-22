#!/bin/sh

[ "$1" == "-h" ] && echo "Usage: $0 [HOST] [URL] " && exit
if [ -z $1 ]; then HOST=192.168.31.1; else HOST=$1; fi

cd `dirname $0`

echo "# RedMi AX6000: https://www.right.com.cn/forum/thread-8253125-1-1.html"
echo "# XiaoMi AX7000: https://www.right.com.cn/forum/thread-8283638-1-1.html"
echo "# XiaoMi BE6500 Pro: https://www.gaicas.com/xiaomi-be6500-pro.html"
echo
echo "# Root"
echo  "ssh root@$HOST 'mkdir /data/root'"
if [ -f ~/.ssh/authorized_keys ]; then
	echo  "scp -O ~/.ssh/authorized_keys root@$HOST:/data/root"
	echo  "ssh root@$HOST 'ln -s /data/root/authorized_keys /etc/dropbear/'"
fi
echo  "scp -O root/.profile root@$HOST:/data/root/"
echo  "scp -O root/opkg.sh root@$HOST:/data/root/"
echo  "scp -O root/root.sh root@$HOST:/data/root/"
echo  "#scp -O root/hass.sh root@$HOST:/data/root/"
echo  "#scp -O root/smb.conf root@$HOST:/data/root/"
echo  "#scp -O root/alist.sh root@$HOST:/data/root/"
echo  "#scp -O root/dnspod.sh root@$HOST:/data/root/"
echo  "ssh root@$HOST 'uci set firewall.root=include'"
echo  "ssh root@$HOST 'uci set firewall.root.type=script'"
echo  "ssh root@$HOST 'uci set firewall.root.path=/data/root/root.sh'"
echo  "ssh root@$HOST 'uci set firewall.root.enabled=1'"
echo  "ssh root@$HOST 'uci commit firewall'"


echo
echo "# Wing"
echo  "ssh root@$HOST 'mkdir /data/wing'"
for FILE in `ls wing|tr " " "?"`
do
	FILE=`echo $FILE|tr "?" " "`
	echo  "scp -O wing/$FILE root@$HOST:/data/wing/"
done
echo  "ssh root@$HOST '/data/wing/wing install trojan://****@****.***:443'"


echo  "#ssh root@$HOST 'mkdir /data/other/xpkg; ln -s /data/other/xpkg /data/'"
echo  "#ssh root@$HOST 'mkdir /data/other_vol/libexec; ln -s /data/other_vol/libexec /data/'"

echo
echo "# SFTP"
echo  "ssh root@$HOST 'mkdir /data/libexec'"
echo  "scp -O libexec/sftp-server root@$HOST:/data/libexec/"
