#!/bin/sh

[ "$1" == "-h" ] && echo "Usage: $0 [HOST] [URL] " && exit
if [ -z $1 ]; then HOST=192.168.31.1; else HOST=$1; fi

cd `dirname $0`

echo "SSH for AX6000: https://www.right.com.cn/forum/thread-8253125-1-1.html"
echo "scp ~/.ssh/authorized_keys root@$1:/data/auto_ssh/"
echo "ssh root@$1 'ln -s /data/auto_ssh/authorized_keys /etc/dropbear/'"
echo "scp auto_ssh.sh root@$1:/data/auto_ssh/"
echo
echo "Execute command as below:"
echo "ssh root@$HOST 'mkdir /data/wing'"
for FILE in `ls|tr " " "?"`
do
	FILE=`echo $FILE|tr "?" " "`
	if [ ${FILE##*.} != sh ]; then
		echo "scp $FILE root@$1:/data/wing/"
	fi
done
echo "ssh root@$1 '/data/wing/wing install $2'"
