#!/bin/sh
# curl http://yonsm.github.io/DIY/MIWIFI/setup.sh|sh -s -- [HOST] [WING]


[ "$1" == "-h" ] && echo "Usage: $0 [HOST] [WING] " && exit

[ -z $1 ] && HOST=192.168.31.1 || HOST=$1

cd `dirname $0`

if [ -f /etc/config/miwifi ]; then
	CMDS="mkdir /data/root"
else
	echo "# RedMi AX6000: https://www.right.com.cn/forum/thread-8253125-1-1.html"
	echo "# XiaoMi AX7000: https://www.gaicas.com/xiaomi-be7000.html"
	echo "# XiaoMi BE6500 Pro: https://www.gaicas.com/xiaomi-be6500-pro.html"
	echo
	echo  "ssh root@$HOST 'mkdir /data/root'"
	if [ -f ~/.ssh/authorized_keys ]; then
		echo  "scp -O ~/.ssh/authorized_keys root@$HOST:/data/root"
		CMDS="ln -s /data/root/authorized_keys /etc/dropbear/"
	else
		CMDS=
	fi
fi

# SFTP
CMDS="$CMDS	mkdir -p /data/other/libexec"
FILES=other/libexec/sftp-server

# ROOT
for FILE in .profile opkg.sh root.sh; do
	FILES="$FILES root/$FILE"
done
CMDS="$CMDS	uci set firewall.root=include"
CMDS="$CMDS	uci set firewall.root.type=script"
CMDS="$CMDS	uci set firewall.root.path=/data/root/root.sh"
CMDS="$CMDS	uci set firewall.root.enabled=1"
CMDS="$CMDS	uci commit firewall"

# WING
if [ -f /etc/config/miwifi ]; then
	CMDS="$CMDS	curl http://yonsm.github.io/DIY/MIWIFI/wing.sh|sh $2"
else
	CMDS="$CMDS	mkdir /data/wing"
	for FILE in `ls wing|tr " " "?"`
	do
		FILE=`echo $FILE|tr "?" " "`
		FILES="$FILES wing/$FILE"
	done
	CMDS="$CMDS	uci set firewall.wing=include"
	CMDS="$CMDS	uci set firewall.wing.type=script"
	CMDS="$CMDS	uci set firewall.wing.path=/data/wing/wing restart $2"
	CMDS="$CMDS	uci set firewall.wing.enabled=1"
	CMDS="$CMDS	uci commit firewall"
fi

for CMD in `echo "$CMDS"|tr " " "?"`
do
	CMD=`echo $CMD|tr "?" " "`
	if [ -f /etc/config/miwifi ]; then
		echo  $CMD
	else
		echo  "ssh root@$HOST '$CMD'"
	fi
done
for FILE in $FILES; do
	if [ -f /etc/config/miwifi ]; then
		echo "curl -o /data/$FILE http://yonsm.github.io/DIY/MIWIFI/$FILE"
	else
		echo  "scp -O $FILE root@$HOST:/data/$FILE"
	fi
done
