#!/bin/sh

[ "$1" == "-h" ] && echo "Usage: $0 [HOST] [URL] " && exit
if [ -z $1 ]; then HOST=192.168.31.1; else HOST=$1; fi

cd `dirname $0`

echo "# Setup SSH: https://www.right.com.cn/forum/thread-8253125-1-1.html"
echo "ssh root@$HOST 'mkdir /data/auto_ssh'"
if [ -f ~/.ssh/authorized_keys ]; then
	echo "scp ~/.ssh/authorized_keys root@$HOST:/data/auto_ssh/"
	echo "ssh root@$HOST 'ln -s /data/auto_ssh/authorized_keys /etc/dropbear/'"
fi
echo "scp -O auto_ssh.sh root@$HOST:/data/auto_ssh/"
echo "ssh root@$HOST 'uci set firewall.auto_ssh=include'"
echo "ssh root@$HOST 'uci set firewall.auto_ssh.type=script'"
echo "ssh root@$HOST 'uci set firewall.auto_ssh.path=/data/auto_ssh/auto_ssh.sh'"
echo "ssh root@$HOST 'uci set firewall.auto_ssh.enabled=1'"
echo "ssh root@$HOST 'uci commit firewall'"

echo
echo "# Setup Wing"
echo "ssh root@$HOST 'mkdir /data/wing'"
for FILE in `ls|tr " " "?"`
do
	FILE=`echo $FILE|tr "?" " "`
	if [ ${FILE##*.} != sh ]; then
		echo "scp -O $FILE root@$HOST:/data/wing/"
	fi
done

echo
echo "# For more packages: https://op.supes.top/packages/aarch64_generic/"
echo
