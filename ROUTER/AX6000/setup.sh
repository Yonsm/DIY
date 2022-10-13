#!/bin/sh

[ $# != 2 ] && echo "Usage: $0 [HOST] [URL] " && exit

cd `dirname $0`

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

# SSH: https://www.right.com.cn/forum/thread-8253125-1-1.html
# WEB@Any: vi /etc/nginx/miwifi-webinitrd.conf; Insert 'set $isluci “1”;' before 'set $finalvar $canproxy $isluci'
