#!/bin/sh

[ $# != 2 ] && echo "Usage: $0 [HOST] [URL] " && exit

cd `dirname $0`
ssh root@$1 "mkdir /data/wing"
for FILE in `ls|tr " " "?"`
do
	FILE=`echo $FILE|tr "?" " "`
	if [ $FILE != setup.sh ]; then
		echo scp $FILE root@$1:/data/wing/
	fi
done
ssh root@$1 "/data/wing/wing -i $2"
