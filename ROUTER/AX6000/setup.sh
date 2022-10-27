#!/bin/sh

[ $# != 2 ] && echo "Usage: $0 [HOST] [URL] " && exit

cd `dirname $0`

echo "SSH for AX6000: https://www.right.com.cn/forum/thread-8253125-1-1.html"
echo "scp ~/.ssh/authorized_keys root@$1:/data/auto_ssh/"
echo "ssh root@$1 'ln -s /data/auto_ssh/authorized_keys /etc/dropbear/'"
echo "scp auto_ssh.sh root@$1:/data/auto_ssh/"
echo
echo "Execute command as below:"
echo "ssh root@$1 'mkdir /data/wing'"
for FILE in `ls|tr " " "?"`
do
	FILE=`echo $FILE|tr "?" " "`
	if [ ${FILE##*.} != sh ]; then
		echo "scp $FILE root@$1:/data/wing/"
	fi
done
echo "ssh root@$1 '/data/wing/wing install $2'"

echo "ssh root@$1 \"sed -i 's/canproxy \\\$isluci/canproxy 1/g' /etc/nginx/miwifi-webinitrd.conf\""
echo "ssh root@$1 '/etc/init.d/nginx restart'"
